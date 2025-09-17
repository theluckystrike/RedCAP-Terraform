import pandas as pd
import os
import re

# Load the REDCap data dictionary CSV
df = pd.read_csv("Testing_DataDictionary_2025-08-27.csv")

# Ensure required column is present
if 'Variable / Field Name' not in df.columns:
    raise ValueError("Missing column 'Variable / Field Name' in CSV")

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

df["SQL_Column_Name"] = df["Variable / Field Name"].apply(sanitize_and_truncate)
with open("version.txt", "r") as file:
    version = int(file.read())+1
    version = str(version)

with open("version.txt", "w") as file:
    file.write(version)

output_dir = "sql_files/"+version
os.makedirs(output_dir, exist_ok=True)

# Save the column mapping
mapping_path = os.path.join(output_dir, "redcap_column_mapping.csv")
df[["Variable / Field Name", "SQL_Column_Name"]].to_csv(mapping_path, index=False)

# Split into 3 roughly equal parts and create SQL
num_chunks = 3
chunk_size = (len(df) + num_chunks - 1) // num_chunks

for i in range(num_chunks):
    chunk = df.iloc[i * chunk_size: (i + 1) * chunk_size]
    table_name = f"redcap_form_part_{i + 1}"
    sql_lines = [f"CREATE TABLE {table_name} ("]
    for _, row in chunk.iterrows():
        sql_lines.append(f'  "{row["SQL_Column_Name"]}" TEXT,')
    sql_lines[-1] = sql_lines[-1].rstrip(',')  # remove trailing comma
    sql_lines.append(");")

    sql_file_path = os.path.join(output_dir, f"part_{i + 1}.sql")
    with open(sql_file_path, "w") as f:
        f.write('\n'.join(sql_lines))

print("✅ Done: SQL files and column mapping saved to ansible/files/")