"""
SQL Schema Generator from Structured JSON
Generates normalized PostgreSQL schema with semantic prefixes and proper table organization
"""
import json
import os
import re
from datetime import datetime

def map_field_type_to_sql(field_type, validation=None):
    """
    Map JSON field types to PostgreSQL data types
    """
    type_mapping = {
        'text': 'VARCHAR(500)',
        'textarea': 'TEXT',
        'radio': 'VARCHAR(50)',
        'checkbox': 'JSONB',  # Store multiple selections as JSON array
        'select': 'VARCHAR(50)',
        'date': 'DATE',
        'email': 'VARCHAR(255)',
        'number': 'DECIMAL',
        'tel': 'VARCHAR(50)',
        'calculated': 'DECIMAL',
        'file': 'VARCHAR(500)',  # Store S3 path
        'slider': 'INTEGER',
        'display': 'TEXT'
    }
    
    sql_type = type_mapping.get(field_type, 'TEXT')
    
    # Refine based on validation rules
    if validation:
        val_type = validation.get('validation_type', '')
        if 'integer' in str(val_type).lower():
            sql_type = 'INTEGER'
        elif 'number' in str(val_type).lower() or 'decimal' in str(val_type).lower():
            sql_type = 'DECIMAL'
    
    return sql_type

def generate_semantic_prefix(category, section_hint=""):
    """
    Generate semantic prefix based on category and section
    """
    category_lower = category.lower()
    section_lower = section_hint.lower()
    
    # Category prefixes
    if category_lower == 'general':
        return 'dem'  # Demographics/General
    elif category_lower == 'shoulder':
        # Determine section-specific prefix
        if 'diagnosis' in section_lower or 'diag' in section_lower:
            return 'orth_sh_diag'
        elif 'clinical' in section_lower or 'clin' in section_lower or 'exam' in section_lower:
            return 'orth_sh_clin'
        elif 'treatment' in section_lower or 'plan' in section_lower:
            return 'orth_sh_tp'
        elif 'surgery' in section_lower or 'surg' in section_lower or 'operation' in section_lower:
            return 'orth_sh_surg'
        elif 'prom' in section_lower or 'outcome' in section_lower:
            return 'orth_sh_proms'
        else:
            return 'orth_sh'
    elif category_lower == 'elbow':
        # Determine section-specific prefix
        if 'diagnosis' in section_lower or 'diag' in section_lower:
            return 'orth_el_diag'
        elif 'clinical' in section_lower or 'clin' in section_lower or 'exam' in section_lower:
            return 'orth_el_clin'
        elif 'treatment' in section_lower or 'plan' in section_lower:
            return 'orth_el_tp'
        elif 'surgery' in section_lower or 'surg' in section_lower or 'operation' in section_lower:
            return 'orth_el_surg'
        elif 'prom' in section_lower or 'outcome' in section_lower:
            return 'orth_el_proms'
        else:
            return 'orth_el'
    
    return 'gen'  # Default

def sanitize_column_name(field_id, prefix="", used_names=None):
    """
    Create clean SQL column name with semantic prefix
    Handles name collisions by adding numeric suffixes
    
    Args:
        field_id: Original field identifier
        prefix: Semantic prefix to add
        used_names: Set of already-used column names to avoid duplicates
    
    Returns:
        Unique column name within the table
    """
    if used_names is None:
        used_names = set()
    
    # Remove existing suffixes like _shoulder, _elbow
    clean_id = re.sub(r'_(shoulder|elbow)$', '', field_id)
    
    # Sanitize
    clean = re.sub(r'\W+', '_', clean_id.strip().lower())
    
    # Remove leading/trailing underscores
    clean = clean.strip('_')
    
    # Add prefix if provided
    if prefix and not clean.startswith(prefix):
        # Check if field already has a category prefix to avoid duplication
        if not (clean.startswith('orth_') or clean.startswith('dem_') or clean.startswith('gen_')):
            clean = f"{prefix}_{clean}"
    
    # Ensure not too long (PostgreSQL limit 63 chars)
    base = clean[:63]
    final = base
    
    # Handle collisions by adding numeric suffix
    counter = 1
    while final in used_names:
        suffix = f"_{counter}"
        # Make room for suffix by truncating base
        final = base[:63 - len(suffix)] + suffix
        counter += 1
    
    used_names.add(final)
    return final

def organize_fields_by_section(category_data):
    """
    Organize fields into logical sections based on section headers
    """
    sections = {}
    
    for field in category_data['fields']:
        section = field.get('section', 'general')
        
        # Normalize section name
        if not section or section == '':
            section = 'general'
        
        # Clean section name for use as key
        section_key = re.sub(r'\W+', '_', section.lower())[:50]
        
        if section_key not in sections:
            sections[section_key] = {
                'display_name': section,
                'fields': []
            }
        
        sections[section_key]['fields'].append(field)
    
    return sections

def generate_table_name(category, section_key):
    """
    Generate table name based on category and section
    """
    category_lower = category.lower()
    
    if category_lower == 'general':
        if 'demographic' in section_key or section_key == 'general':
            return 'demographics'
        else:
            return f'general_{section_key}'
    
    elif category_lower == 'shoulder':
        if 'diagnosis' in section_key or 'diag' in section_key:
            return 'shoulder_diagnosis'
        elif 'clinical' in section_key or 'exam' in section_key:
            return 'shoulder_clinical'
        elif 'treatment' in section_key or 'plan' in section_key:
            return 'shoulder_treatment_plan'
        elif 'surgery' in section_key or 'operation' in section_key:
            return 'shoulder_surgery'
        elif 'prom' in section_key or 'outcome' in section_key:
            return 'shoulder_proms'
        else:
            return f'shoulder_{section_key}'
    
    elif category_lower == 'elbow':
        if 'diagnosis' in section_key or 'diag' in section_key:
            return 'elbow_diagnosis'
        elif 'clinical' in section_key or 'exam' in section_key:
            return 'elbow_clinical'
        elif 'treatment' in section_key or 'plan' in section_key:
            return 'elbow_treatment_plan'
        elif 'surgery' in section_key or 'operation' in section_key:
            return 'elbow_surgery'
        elif 'prom' in section_key or 'outcome' in section_key:
            return 'elbow_proms'
        else:
            return f'elbow_{section_key}'
    
    return f'{category_lower}_{section_key}'

def split_large_sections(fields, max_fields_per_table=250):
    """
    Split large sections into multiple parts to avoid PostgreSQL row size limits
    """
    if len(fields) <= max_fields_per_table:
        return [fields]
    
    # Split into chunks
    chunks = []
    for i in range(0, len(fields), max_fields_per_table):
        chunks.append(fields[i:i + max_fields_per_table])
    
    return chunks

def generate_table_sql(table_name, fields, category, part_num=None):
    """
    Generate CREATE TABLE SQL for a specific table
    
    Args:
        table_name: Base table name
        fields: List of field definitions
        category: Category name (for prefix generation)
        part_num: Part number if table is split (optional)
    
    Returns:
        SQL CREATE TABLE statement as string
    """
    # Adjust table name for multi-part tables
    if part_num is not None:
        table_name = f"{table_name}_part_{part_num}"
    
    sql_lines = []
    
    # Table header
    sql_lines.append(f"-- Table: {table_name}")
    sql_lines.append(f"-- Generated: {datetime.now().isoformat()}")
    sql_lines.append(f"-- Fields: {len(fields)}")
    sql_lines.append("")
    sql_lines.append(f"CREATE TABLE IF NOT EXISTS {table_name} (")
    
    # Primary key
    sql_lines.append("    id SERIAL PRIMARY KEY,")
    
    # encounter_id foreign key (links all tables)
    sql_lines.append("    encounter_id VARCHAR(100) NOT NULL,")
    
    # Track used column names to avoid duplicates within this table
    used_names = {'id', 'encounter_id', 'created_at', 'updated_at'}
    
    # Add fields
    for field in fields:
        field_id = field['field_id']
        field_type = field['field_type']
        label = field['label']
        validation = field.get('validation')
        section_hint = field.get('section', '')
        
        # Generate semantic prefix
        prefix = generate_semantic_prefix(category, section_hint)
        
        # Create column name with duplicate detection
        col_name = sanitize_column_name(field_id, prefix, used_names)
        
        # Map to SQL type
        sql_type = map_field_type_to_sql(field_type, validation)
        
        # Build column definition
        col_def = f'    "{col_name}" {sql_type}'
        
        # Add constraints
        if field.get('required'):
            col_def += " NOT NULL"
        
        col_def += ","
        
        # Add comment with original label and field_id for traceability
        sql_lines.append(col_def + f"  -- {label[:50]} (original: {field_id[:30]})")
    
    # Timestamps (audit trail)
    sql_lines.append("    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,")
    sql_lines.append("    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    
    sql_lines.append(");")
    sql_lines.append("")
    
    # Add indexes
    sql_lines.append(f"-- Indexes for {table_name}")
    sql_lines.append(f"CREATE INDEX IF NOT EXISTS idx_{table_name}_encounter ON {table_name}(encounter_id);")
    sql_lines.append(f"CREATE INDEX IF NOT EXISTS idx_{table_name}_created ON {table_name}(created_at);")
    sql_lines.append("")
    
    # Add foreign key constraint (idempotent approach)
    sql_lines.append(f"-- Foreign key constraint (idempotent)")
    sql_lines.append(f"DO $$")
    sql_lines.append(f"BEGIN")
    sql_lines.append(f"    IF NOT EXISTS (")
    sql_lines.append(f"        SELECT 1 FROM pg_constraint ")
    sql_lines.append(f"        WHERE conname = 'fk_{table_name}_encounter'")
    sql_lines.append(f"    ) THEN")
    sql_lines.append(f"        ALTER TABLE {table_name}")
    sql_lines.append(f"            ADD CONSTRAINT fk_{table_name}_encounter")
    sql_lines.append(f"            FOREIGN KEY (encounter_id)")
    sql_lines.append(f"            REFERENCES encounters(encounter_id)")
    sql_lines.append(f"            ON DELETE CASCADE;")
    sql_lines.append(f"    END IF;")
    sql_lines.append(f"END $$;")
    sql_lines.append("")
    
    return '\n'.join(sql_lines)

def generate_encounters_table():
    """
    Generate the main encounters table (master record)
    """
    sql = """-- Main Encounters Table (Master Record)
-- Links all specialty-specific tables together

CREATE TABLE IF NOT EXISTS encounters (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) UNIQUE NOT NULL,  -- Format: YYYYMMDD_PatientID
    patient_id VARCHAR(50) NOT NULL,
    processing_date DATE NOT NULL,
    encounter_date DATE,
    encounter_type VARCHAR(50),  -- first_visit, follow_up, surgery, post_op
    is_first_visit BOOLEAN DEFAULT TRUE,
    prior_encounter_id VARCHAR(100),  -- Link to previous encounter
    schema_version VARCHAR(20) DEFAULT '1.0',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Self-referencing foreign key (idempotent)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'fk_prior_encounter'
    ) THEN
        ALTER TABLE encounters
            ADD CONSTRAINT fk_prior_encounter 
            FOREIGN KEY (prior_encounter_id) 
            REFERENCES encounters(encounter_id);
    END IF;
END $$;

-- Indexes for encounters table
CREATE INDEX IF NOT EXISTS idx_encounters_patient ON encounters(patient_id);
CREATE INDEX IF NOT EXISTS idx_encounters_date ON encounters(encounter_date);
CREATE INDEX IF NOT EXISTS idx_encounters_processing ON encounters(processing_date);
CREATE INDEX IF NOT EXISTS idx_encounters_prior ON encounters(prior_encounter_id);
CREATE INDEX IF NOT EXISTS idx_encounters_type ON encounters(encounter_type);

"""
    return sql

def generate_column_mapping_csv(all_tables_info, output_path):
    """
    Generate CSV mapping original field IDs to SQL columns
    """
    import csv
    
    with open(output_path, 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow([
            'Original_Field_ID',
            'Category',
            'Section',
            'Table_Name',
            'SQL_Column_Name',
            'SQL_Data_Type',
            'Field_Type',
            'Label'
        ])
        
        for table_info in all_tables_info:
            table_name = table_info['table_name']
            category = table_info['category']
            
            for field_mapping in table_info['field_mappings']:
                writer.writerow([
                    field_mapping['original_id'],
                    category,
                    field_mapping['section'],
                    table_name,
                    field_mapping['sql_column'],
                    field_mapping['sql_type'],
                    field_mapping['field_type'],
                    field_mapping['label'][:100]  # Truncate long labels
                ])

def generate_schema_from_json(json_path, output_dir):
    """
    Main function to generate SQL schema from structured JSON
    """
    print("="*80)
    print("SQL SCHEMA GENERATOR")
    print("="*80)
    print(f"Input: {json_path}")
    print(f"Output: {output_dir}")
    print()
    
    # Load JSON
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Create output directory
    os.makedirs(output_dir, exist_ok=True)
    
    # Version management
    version = "1"
    version_file = os.path.join(output_dir, "../version.txt")
    if os.path.exists(version_file):
        with open(version_file, 'r') as f:
            version = str(int(f.read().strip()) + 1)
    
    with open(version_file, 'w') as f:
        f.write(version)
    
    # Create versioned directory
    version_dir = os.path.join(output_dir, version)
    os.makedirs(version_dir, exist_ok=True)
    
    print(f"Schema Version: {version}")
    print()
    
    # Track all table info for mapping
    all_tables_info = []
    
    # Generate encounters table first
    print("Generating encounters table (master record)...")
    encounters_sql = generate_encounters_table()
    with open(os.path.join(version_dir, '00_encounters.sql'), 'w', encoding='utf-8') as f:
        f.write(encounters_sql)
    print("✓ encounters.sql")
    print()
    
    # Process each category
    for category_key, category_data in data['categories'].items():
        print(f"Processing category: {category_data['name']}")
        print(f"  Total fields: {len(category_data['fields'])}")
        
        # Organize fields by section
        sections = organize_fields_by_section(category_data)
        print(f"  Sections found: {len(sections)}")
        
        # Generate tables for each section
        file_counter = 1
        for section_key, section_data in sections.items():
            section_fields = section_data['fields']
            table_name = generate_table_name(category_key, section_key)
            
            print(f"    Section: {section_data['display_name']}")
            print(f"      Fields: {len(section_fields)}")
            print(f"      Table: {table_name}")
            
            # Split if too large
            field_chunks = split_large_sections(section_fields, max_fields_per_table=250)
            
            if len(field_chunks) > 1:
                print(f"      Split into {len(field_chunks)} parts (row size limit)")
            
            for part_idx, chunk in enumerate(field_chunks, 1):
                part_num = part_idx if len(field_chunks) > 1 else None
                actual_table_name = f"{table_name}_part_{part_num}" if part_num else table_name
                
                # Generate SQL
                sql = generate_table_sql(actual_table_name, chunk, category_key, 
                                        part_num if len(field_chunks) > 1 else None)
                
                # Save to file
                filename = f"{file_counter:02d}_{actual_table_name}.sql"
                filepath = os.path.join(version_dir, filename)
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(sql)
                
                print(f"        ✓ {filename}")
                
                # Track for mapping - IMPORTANT: Use same logic for column names
                field_mappings = []
                used_names_for_mapping = {'id', 'encounter_id', 'created_at', 'updated_at'}
                
                for field in chunk:
                    prefix = generate_semantic_prefix(category_key, field.get('section', ''))
                    # Use same sanitize function with used_names tracking
                    col_name = sanitize_column_name(field['field_id'], prefix, used_names_for_mapping)
                    sql_type = map_field_type_to_sql(field['field_type'], field.get('validation'))
                    
                    field_mappings.append({
                        'original_id': field['field_id'],
                        'section': field.get('section', ''),
                        'sql_column': col_name,
                        'sql_type': sql_type,
                        'field_type': field['field_type'],
                        'label': field['label']
                    })
                
                all_tables_info.append({
                    'table_name': actual_table_name,
                    'category': category_key,
                    'section': section_key,
                    'field_count': len(chunk),
                    'field_mappings': field_mappings
                })
                
                file_counter += 1
        
        print()
    
    # Generate column mapping CSV
    print("Generating column mapping CSV...")
    mapping_path = os.path.join(version_dir, 'column_mapping.csv')
    generate_column_mapping_csv(all_tables_info, mapping_path)
    print(f"✓ {mapping_path}")
    print()
    
    # Summary
    print("="*80)
    print("SCHEMA GENERATION COMPLETE")
    print("="*80)
    print(f"Version: {version}")
    print(f"Total Tables: {len(all_tables_info) + 1} (including encounters)")
    print(f"Total Fields: {data['metadata']['total_fields']}")
    print(f"Output Directory: {version_dir}")
    print()
    print("Files Generated:")
    print(f"  • {len(all_tables_info) + 1} individual SQL files")
    print(f"  • 1 column_mapping.csv (traceability)")
    print("="*80)
    
    return version_dir

# Main execution
if __name__ == '__main__':
    json_path = 'structured_form_fields.json'
    output_dir = 'sql_schema'
    
    version_dir = generate_schema_from_json(json_path, output_dir)
    
    print("\n✅ Schema generation successful!")
    print(f"📁 Files saved to: {version_dir}")