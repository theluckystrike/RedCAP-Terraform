import pandas as pd
import os
import re

# Load the REDCap data dictionary CSV
df = pd.read_csv("Testing_DataDictionary_2025-08-27.csv")

# Ensure required column is present
if 'Field Label' not in df.columns:
    raise ValueError("Missing column 'Field Label' in CSV")

# Create mapping from original to SQL-safe (truncated + sanitized) column names
used_names = set()

def sanitize_and_truncate(name):
    name = str(name)
    clean = re.sub(r'\W+', '_', name.strip().lower())
    base = clean[:63]
    final = base
    i = 1
    while final in used_names:
        suffix = f"_{i}"
        final = base[:63 - len(suffix)] + suffix
        i += 1
    used_names.add(final)
    return final

df["SQL_Column_Name"] = df["Field Label"].apply(sanitize_and_truncate)

with open("version.txt", "r") as file:
    version = int(file.read())+1
    version = str(version)

with open("version.txt", "w") as file:
    file.write(version)

output_dir = "sql_files/"+version
os.makedirs(output_dir, exist_ok=True)

# Save the column mapping
mapping_path = os.path.join(output_dir, "redcap_column_mapping.csv")
df[["Field Label", "SQL_Column_Name"]].to_csv(mapping_path, index=False)

# CHANGED: Split into more parts to avoid row size limit
# PostgreSQL has ~8KB row limit, so aim for ~250 columns per table max
num_chunks = 10  # Changed from 3 to 10 for better distribution
chunk_size = (len(df) + num_chunks - 1) // num_chunks

print(f"Total columns: {len(df)}")
print(f"Splitting into {num_chunks} tables")
print(f"~{chunk_size} columns per table")

for i in range(num_chunks):
    chunk = df.iloc[i * chunk_size: (i + 1) * chunk_size]
    
    # Skip empty chunks
    if len(chunk) == 0:
        continue
        
    table_name = f"redcap_form_part_{i + 1}"
    
    print(f"\nTable {i+1}: {table_name} - {len(chunk)} columns")
    
    sql_lines = [f"CREATE TABLE IF NOT EXISTS {table_name} ("]
    for _, row in chunk.iterrows():
        sql_lines.append(f'  "{row["SQL_Column_Name"]}" TEXT,')
    sql_lines[-1] = sql_lines[-1].rstrip(',')  # remove trailing comma
    sql_lines.append(");")

    sql_file_path = os.path.join(output_dir, f"part_{i + 1}.sql")
    with open(sql_file_path, "w") as f:
        f.write('\n'.join(sql_lines))

print("\n✅ Done: SQL files and column mapping saved!")