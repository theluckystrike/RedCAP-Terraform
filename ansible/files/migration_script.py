import pandas as pd
import sqlalchemy
from sqlalchemy import create_engine, inspect, text
import boto3
import datetime

# ---- AWS Config ----
RDS_INSTANCE_ID = "your-rds-instance-id"
REGION = "ap-southeast-2"  # change to your region

# ---- CONFIG ----
with open("version.txt", "r") as file:
    new_version = int(file.read())
    old_version = str(new_version - 1)
    new_version = str(new_version)

DB_URI = "postgresql+psycopg2://user:password@rds-host:5432/mydb"
OLD_MAPPING = "sql_files/"+old_version+"/redcap_column_mapping_old.csv"
NEW_MAPPING = "sql_files/"+new_version+"/redcap_column_mapping.csv"
NUM_PARTS = 3  # number of shards/tables

engine = create_engine(DB_URI)

def create_snapshot():
    rds = boto3.client("rds", region_name=REGION)
    snapshot_id = f"{RDS_INSTANCE_ID}-migration-snap-{datetime.datetime.utcnow().strftime('%Y%m%d%H%M%S')}"
    
    print(f"📸 Creating snapshot: {snapshot_id}")
    rds.create_db_snapshot(
        DBSnapshotIdentifier=snapshot_id,
        DBInstanceIdentifier=RDS_INSTANCE_ID
    )
    return snapshot_id

def get_current_columns(table):
    """Fetch current column names from a Postgres table."""
    insp = inspect(engine)
    return {col["name"] for col in insp.get_columns(table)}

def migrate_table(table_name, old_map, new_map):
    """Migrate one shard (table) based on old vs new mapping."""
    current_cols = get_current_columns(table_name)

    for _, row in new_map.iterrows():
        new_field = row["SQL_Column_Name"]
        variable_name = row["Variable / Field Name"]

        # See if this variable existed before
        match = old_map[old_map["Variable / Field Name"] == variable_name]
        old_field = match.iloc[0]["SQL_Column_Name"] if not match.empty else None

        if old_field and old_field in current_cols and new_field not in current_cols:
            # ---- Case 1: Rename ----
            print(f"[{table_name}] Renaming {old_field} → {new_field}")
            with engine.begin() as conn:
                conn.execute(
                    text(f'ALTER TABLE {table_name} RENAME COLUMN "{old_field}" TO "{new_field}"')
                )
            current_cols.remove(old_field)
            current_cols.add(new_field)

        elif not old_field and new_field not in current_cols:
            # ---- Case 2: Add ----
            print(f"[{table_name}] Adding new column {new_field}")
            with engine.begin() as conn:
                conn.execute(
                    text(f'ALTER TABLE {table_name} ADD COLUMN "{new_field}" TEXT')
                )
            current_cols.add(new_field)

        else:
            # ---- Case 3: No change ----
            print(f"[{table_name}] No change for {new_field}")

def migrate_all():
    """Run migration across all shards."""
    old_map = pd.read_csv(OLD_MAPPING)
    new_map = pd.read_csv(NEW_MAPPING)

    # Split into NUM_PARTS chunks consistently
    chunk_size = (len(new_map) + NUM_PARTS - 1) // NUM_PARTS
    for i in range(NUM_PARTS):
        chunk_new = new_map.iloc[i * chunk_size:(i + 1) * chunk_size]
        chunk_old = old_map.iloc[i * chunk_size:(i + 1) * chunk_size]
        table_name = f"redcap_form_part_{i + 1}"
        print(f"\n🔄 Migrating {table_name}")
        migrate_table(table_name, chunk_old, chunk_new)

if __name__ == "__main__":
    create_snapshot()
    migrate_all()
    print("\n✅ Migration complete")