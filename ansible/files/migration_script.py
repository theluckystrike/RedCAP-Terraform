"""
Schema Migration Generator
Handles changes in JSON structure and generates migration SQL scripts
Compares old and new JSON schemas and creates appropriate ALTER TABLE statements
"""
import json
import os
import re
from datetime import datetime
from typing import Dict, List, Set, Tuple
from collections import defaultdict

class SchemaMigration:
    """
    Handles schema migrations when JSON structure changes
    """
    
    def __init__(self, old_json_path: str, new_json_path: str, output_dir: str):
        self.old_json_path = old_json_path
        self.new_json_path = new_json_path
        self.output_dir = output_dir
        
        # Load both schemas
        with open(old_json_path, 'r', encoding='utf-8') as f:
            self.old_schema = json.load(f)
        
        with open(new_json_path, 'r', encoding='utf-8') as f:
            self.new_schema = json.load(f)
        
        # Track changes
        self.added_fields = []
        self.removed_fields = []
        self.modified_fields = []
        self.renamed_fields = []
        
    def map_field_type_to_sql(self, field_type, validation=None):
        """Map JSON field types to PostgreSQL data types"""
        type_mapping = {
            'text': 'VARCHAR(500)',
            'textarea': 'TEXT',
            'radio': 'VARCHAR(50)',
            'checkbox': 'JSONB',
            'select': 'VARCHAR(50)',
            'date': 'DATE',
            'email': 'VARCHAR(255)',
            'number': 'DECIMAL',
            'tel': 'VARCHAR(50)',
            'calculated': 'DECIMAL',
            'file': 'VARCHAR(500)',
            'slider': 'INTEGER',
            'display': 'TEXT'
        }
        
        sql_type = type_mapping.get(field_type, 'TEXT')
        
        if validation:
            val_type = validation.get('validation_type', '')
            if 'integer' in str(val_type).lower():
                sql_type = 'INTEGER'
            elif 'number' in str(val_type).lower():
                sql_type = 'DECIMAL'
        
        return sql_type
    
    def generate_semantic_prefix(self, category, section_hint=""):
        """Generate semantic prefix based on category and section"""
        category_lower = category.lower()
        section_lower = section_hint.lower()
        
        if category_lower == 'general':
            return 'dem'
        elif category_lower == 'shoulder':
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
        
        return 'gen'
    
    def sanitize_column_name(self, field_id, prefix=""):
        """Create clean SQL column name with semantic prefix"""
        clean_id = re.sub(r'_(shoulder|elbow)$', '', field_id)
        clean = re.sub(r'\W+', '_', clean_id.strip().lower())
        clean = clean.strip('_')
        
        if prefix and not clean.startswith(prefix):
            if not (clean.startswith('orth_') or clean.startswith('dem_') or clean.startswith('gen_')):
                clean = f"{prefix}_{clean}"
        
        if len(clean) > 63:
            clean = clean[:63]
        
        return clean
    
    def generate_table_name(self, category, section_key):
        """Generate table name based on category and section"""
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
    
    def build_field_index(self, schema):
        """
        Build an index of all fields in schema for easy comparison
        Returns: Dict[field_id] -> {category, section, table, field_info}
        """
        field_index = {}
        
        for category_key, category_data in schema['categories'].items():
            for field in category_data['fields']:
                field_id = field['field_id']
                section = field.get('section', 'general')
                section_key = re.sub(r'\W+', '_', section.lower())[:50]
                
                table_name = self.generate_table_name(category_key, section_key)
                prefix = self.generate_semantic_prefix(category_key, section)
                column_name = self.sanitize_column_name(field_id, prefix)
                
                field_index[field_id] = {
                    'category': category_key,
                    'section': section,
                    'section_key': section_key,
                    'table_name': table_name,
                    'column_name': column_name,
                    'field_type': field['field_type'],
                    'label': field['label'],
                    'validation': field.get('validation'),
                    'required': field.get('required', False),
                    'options': field.get('options')
                }
        
        return field_index
    
    def detect_changes(self):
        """
        Detect all changes between old and new schemas
        """
        print("🔍 Detecting schema changes...")
        print()
        
        old_fields = self.build_field_index(self.old_schema)
        new_fields = self.build_field_index(self.new_schema)
        
        old_field_ids = set(old_fields.keys())
        new_field_ids = set(new_fields.keys())
        
        # Detect added fields
        added_ids = new_field_ids - old_field_ids
        for field_id in added_ids:
            self.added_fields.append({
                'field_id': field_id,
                'info': new_fields[field_id]
            })
        
        # Detect removed fields
        removed_ids = old_field_ids - new_field_ids
        for field_id in removed_ids:
            self.removed_fields.append({
                'field_id': field_id,
                'info': old_fields[field_id]
            })
        
        # Detect modified fields (same field_id but different properties)
        common_ids = old_field_ids & new_field_ids
        for field_id in common_ids:
            old_info = old_fields[field_id]
            new_info = new_fields[field_id]
            
            changes = {}
            
            # Check for type changes
            if old_info['field_type'] != new_info['field_type']:
                changes['field_type'] = {
                    'old': old_info['field_type'],
                    'new': new_info['field_type']
                }
            
            # Check for table changes (field moved to different section)
            if old_info['table_name'] != new_info['table_name']:
                changes['table_name'] = {
                    'old': old_info['table_name'],
                    'new': new_info['table_name']
                }
            
            # Check for column name changes
            if old_info['column_name'] != new_info['column_name']:
                changes['column_name'] = {
                    'old': old_info['column_name'],
                    'new': new_info['column_name']
                }
            
            # Check for required constraint changes
            if old_info['required'] != new_info['required']:
                changes['required'] = {
                    'old': old_info['required'],
                    'new': new_info['required']
                }
            
            if changes:
                self.modified_fields.append({
                    'field_id': field_id,
                    'old_info': old_info,
                    'new_info': new_info,
                    'changes': changes
                })
        
        # Print summary
        print(f"✅ Changes detected:")
        print(f"   • Added fields: {len(self.added_fields)}")
        print(f"   • Removed fields: {len(self.removed_fields)}")
        print(f"   • Modified fields: {len(self.modified_fields)}")
        print()
    
    def generate_migration_sql(self, migration_version: str) -> str:
        """
        Generate SQL migration script for all detected changes
        """
        sql_lines = []
        
        # Header
        sql_lines.append(f"-- Schema Migration: Version {migration_version}")
        sql_lines.append(f"-- Generated: {datetime.now().isoformat()}")
        sql_lines.append(f"-- Changes: {len(self.added_fields)} added, {len(self.removed_fields)} removed, {len(self.modified_fields)} modified")
        sql_lines.append("")
        sql_lines.append("-- Start transaction")
        sql_lines.append("BEGIN;")
        sql_lines.append("")
        
        # Track tables that need updating
        tables_modified = set()
        
        # 1. Handle ADDED fields
        if self.added_fields:
            sql_lines.append("-- ============================================")
            sql_lines.append("-- ADDED FIELDS")
            sql_lines.append("-- ============================================")
            sql_lines.append("")
            
            # Group by table
            fields_by_table = defaultdict(list)
            for field in self.added_fields:
                table_name = field['info']['table_name']
                fields_by_table[table_name].append(field)
            
            for table_name, fields in fields_by_table.items():
                sql_lines.append(f"-- Add fields to {table_name}")
                
                for field in fields:
                    info = field['info']
                    column_name = info['column_name']
                    sql_type = self.map_field_type_to_sql(info['field_type'], info['validation'])
                    
                    sql_line = f"ALTER TABLE {table_name} ADD COLUMN IF NOT EXISTS \"{column_name}\" {sql_type}"
                    
                    # Add NOT NULL only if required AND we have a default
                    if info['required']:
                        # For required fields, we need a default value first
                        sql_lines.append(f"-- Note: '{column_name}' is marked as required")
                        sql_lines.append(f"-- Setting default value first, then adding NOT NULL constraint")
                        
                        # Determine appropriate default based on type
                        if sql_type == 'INTEGER':
                            default_val = '0'
                        elif sql_type == 'DECIMAL':
                            default_val = '0.0'
                        elif sql_type == 'DATE':
                            default_val = "CURRENT_DATE"
                        elif sql_type == 'BOOLEAN':
                            default_val = 'FALSE'
                        elif sql_type == 'JSONB':
                            default_val = "'[]'::jsonb"
                        else:
                            default_val = "''"
                        
                        sql_line += f" DEFAULT {default_val}"
                    
                    sql_line += ";"
                    sql_lines.append(sql_line)
                    
                    # Add comment with label
                    # Add comment with label (escape single quotes)
                    label_escaped = info['label'][:100].replace("'", "''")
                    sql_lines.append(f"COMMENT ON COLUMN {table_name}.\"{column_name}\" IS '{label_escaped}';")
                    
                    tables_modified.add(table_name)
                
                sql_lines.append("")
        
        # 2. Handle MODIFIED fields
        if self.modified_fields:
            sql_lines.append("-- ============================================")
            sql_lines.append("-- MODIFIED FIELDS")
            sql_lines.append("-- ============================================")
            sql_lines.append("")
            
            for field in self.modified_fields:
                changes = field['changes']
                old_info = field['old_info']
                new_info = field['new_info']
                
                sql_lines.append(f"-- Modify field: {field['field_id']}")
                
                # Handle type changes
                if 'field_type' in changes:
                    old_table = old_info['table_name']
                    old_column = old_info['column_name']
                    new_type = self.map_field_type_to_sql(new_info['field_type'], new_info['validation'])
                    
                    sql_lines.append(f"-- Type change: {changes['field_type']['old']} -> {changes['field_type']['new']}")
                    sql_lines.append(f"ALTER TABLE {old_table} ALTER COLUMN \"{old_column}\" TYPE {new_type} USING \"{old_column}\"::{new_type};")
                    tables_modified.add(old_table)
                
                # Handle table moves (field moved to different section/table)
                if 'table_name' in changes:
                    old_table = changes['table_name']['old']
                    new_table = changes['table_name']['new']
                    column_name = old_info['column_name']
                    
                    sql_lines.append(f"-- Move field from {old_table} to {new_table}")
                    sql_lines.append(f"-- Step 1: Add column to new table")
                    sql_type = self.map_field_type_to_sql(new_info['field_type'], new_info['validation'])
                    sql_lines.append(f"ALTER TABLE {new_table} ADD COLUMN IF NOT EXISTS \"{column_name}\" {sql_type};")
                    
                    sql_lines.append(f"-- Step 2: Copy data from old table to new table")
                    sql_lines.append(f"UPDATE {new_table} nt")
                    sql_lines.append(f"SET \"{column_name}\" = ot.\"{column_name}\"")
                    sql_lines.append(f"FROM {old_table} ot")
                    sql_lines.append(f"WHERE nt.encounter_id = ot.encounter_id;")
                    
                    sql_lines.append(f"-- Step 3: Drop column from old table (commented out for safety)")
                    sql_lines.append(f"-- ALTER TABLE {old_table} DROP COLUMN IF EXISTS \"{column_name}\";")
                    
                    tables_modified.add(old_table)
                    tables_modified.add(new_table)
                
                # Handle column renames
                if 'column_name' in changes:
                    table = old_info['table_name']
                    old_column = changes['column_name']['old']
                    new_column = changes['column_name']['new']
                    
                    sql_lines.append(f"-- Rename column: {old_column} -> {new_column}")
                    sql_lines.append(f"ALTER TABLE {table} RENAME COLUMN \"{old_column}\" TO \"{new_column}\";")
                    tables_modified.add(table)
                
                # Handle required constraint changes
                if 'required' in changes:
                    table = new_info['table_name']
                    column = new_info['column_name']
                    
                    if changes['required']['new']:
                        sql_lines.append(f"-- Add NOT NULL constraint (commented out - requires data validation)")
                        sql_lines.append(f"-- First ensure no NULL values exist:")
                        sql_lines.append(f"-- UPDATE {table} SET \"{column}\" = '' WHERE \"{column}\" IS NULL;")
                        sql_lines.append(f"-- ALTER TABLE {table} ALTER COLUMN \"{column}\" SET NOT NULL;")
                    else:
                        sql_lines.append(f"-- Remove NOT NULL constraint")
                        sql_lines.append(f"ALTER TABLE {table} ALTER COLUMN \"{column}\" DROP NOT NULL;")
                        tables_modified.add(table)
                
                sql_lines.append("")
        
        # 3. Handle REMOVED fields (create backup and optionally drop)
        if self.removed_fields:
            sql_lines.append("-- ============================================")
            sql_lines.append("-- REMOVED FIELDS (BACKUP AND DROP)")
            sql_lines.append("-- ============================================")
            sql_lines.append("")
            
            # Group by table
            fields_by_table = defaultdict(list)
            for field in self.removed_fields:
                table_name = field['info']['table_name']
                fields_by_table[table_name].append(field)
            
            for table_name, fields in fields_by_table.items():
                sql_lines.append(f"-- Remove fields from {table_name}")
                
                # Create backup table first
                sql_lines.append(f"-- Create backup of removed columns")
                backup_table = f"{table_name}_removed_fields_backup"
                sql_lines.append(f"CREATE TABLE IF NOT EXISTS {backup_table} AS")
                sql_lines.append(f"SELECT encounter_id")
                
                for field in fields:
                    column_name = field['info']['column_name']
                    sql_lines.append(f"       , \"{column_name}\"")
                
                sql_lines.append(f"FROM {table_name};")
                sql_lines.append("")
                
                # Drop columns (commented out for safety)
                for field in fields:
                    column_name = field['info']['column_name']
                    sql_lines.append(f"-- DROP COLUMN (commented out for safety - data backed up in {backup_table})")
                    sql_lines.append(f"-- ALTER TABLE {table_name} DROP COLUMN IF EXISTS \"{column_name}\";")
                
                sql_lines.append("")
        
        # 4. Update schema version in encounters table
        sql_lines.append("-- ============================================")
        sql_lines.append("-- UPDATE SCHEMA VERSION")
        sql_lines.append("-- ============================================")
        sql_lines.append("")
        sql_lines.append(f"-- Update schema version to {migration_version}")
        sql_lines.append(f"ALTER TABLE encounters ALTER COLUMN schema_version SET DEFAULT '{migration_version}';")
        sql_lines.append("")
        
        # 5. Create migration log entry
        sql_lines.append("-- ============================================")
        sql_lines.append("-- LOG MIGRATION")
        sql_lines.append("-- ============================================")
        sql_lines.append("")
        sql_lines.append("-- Create migration log table if not exists")
        sql_lines.append("CREATE TABLE IF NOT EXISTS schema_migrations (")
        sql_lines.append("    id SERIAL PRIMARY KEY,")
        sql_lines.append("    version VARCHAR(20) NOT NULL,")
        sql_lines.append("    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,")
        sql_lines.append("    fields_added INTEGER,")
        sql_lines.append("    fields_removed INTEGER,")
        sql_lines.append("    fields_modified INTEGER,")
        sql_lines.append("    description TEXT")
        sql_lines.append(");")
        sql_lines.append("")
        sql_lines.append("-- Log this migration")
        sql_lines.append(f"INSERT INTO schema_migrations (version, fields_added, fields_removed, fields_modified, description)")
        sql_lines.append(f"VALUES ('{migration_version}', {len(self.added_fields)}, {len(self.removed_fields)}, {len(self.modified_fields)},")
        sql_lines.append(f"        'Migration from previous version: {len(self.added_fields)} fields added, {len(self.removed_fields)} removed, {len(self.modified_fields)} modified');")
        sql_lines.append("")
        
        # Commit transaction
        sql_lines.append("-- Commit all changes")
        sql_lines.append("COMMIT;")
        sql_lines.append("")
        sql_lines.append("-- Migration complete!")
        sql_lines.append(f"-- Tables modified: {', '.join(sorted(tables_modified))}")
        
        return '\n'.join(sql_lines)
    
    def generate_rollback_sql(self, migration_version: str) -> str:
        """
        Generate SQL to rollback the migration
        """
        sql_lines = []
        
        sql_lines.append(f"-- Rollback Migration: Version {migration_version}")
        sql_lines.append(f"-- Generated: {datetime.now().isoformat()}")
        sql_lines.append("")
        sql_lines.append("-- WARNING: This will undo the migration. Use with caution!")
        sql_lines.append("")
        sql_lines.append("BEGIN;")
        sql_lines.append("")
        
        # Rollback added fields (drop them)
        if self.added_fields:
            sql_lines.append("-- Drop added fields")
            fields_by_table = defaultdict(list)
            for field in self.added_fields:
                table_name = field['info']['table_name']
                fields_by_table[table_name].append(field)
            
            for table_name, fields in fields_by_table.items():
                for field in fields:
                    column_name = field['info']['column_name']
                    sql_lines.append(f"ALTER TABLE {table_name} DROP COLUMN IF EXISTS \"{column_name}\";")
            sql_lines.append("")
        
        # Rollback modified fields (restore old values)
        if self.modified_fields:
            sql_lines.append("-- Restore modified fields to original state")
            for field in self.modified_fields:
                changes = field['changes']
                
                if 'field_type' in changes:
                    table = field['old_info']['table_name']
                    column = field['old_info']['column_name']
                    old_type = self.map_field_type_to_sql(field['old_info']['field_type'], 
                                                          field['old_info']['validation'])
                    sql_lines.append(f"ALTER TABLE {table} ALTER COLUMN \"{column}\" TYPE {old_type};")
                
                if 'column_name' in changes:
                    table = field['old_info']['table_name']
                    new_column = changes['column_name']['new']
                    old_column = changes['column_name']['old']
                    sql_lines.append(f"ALTER TABLE {table} RENAME COLUMN \"{new_column}\" TO \"{old_column}\";")
            
            sql_lines.append("")
        
        # Rollback removed fields (restore from backup)
        if self.removed_fields:
            sql_lines.append("-- Restore removed fields from backup")
            fields_by_table = defaultdict(list)
            for field in self.removed_fields:
                table_name = field['info']['table_name']
                fields_by_table[table_name].append(field)
            
            for table_name, fields in fields_by_table.items():
                backup_table = f"{table_name}_removed_fields_backup"
                
                # Re-add columns
                for field in fields:
                    info = field['info']
                    column_name = info['column_name']
                    sql_type = self.map_field_type_to_sql(info['field_type'], info['validation'])
                    sql_lines.append(f"ALTER TABLE {table_name} ADD COLUMN IF NOT EXISTS \"{column_name}\" {sql_type};")
                
                # Restore data
                sql_lines.append(f"-- Restore data from backup")
                sql_lines.append(f"UPDATE {table_name} t")
                sql_lines.append(f"SET {', '.join([f'\"{f['info']['column_name']}\" = b.\"{f['info']['column_name']}\"' for f in fields])}")
                sql_lines.append(f"FROM {backup_table} b")
                sql_lines.append(f"WHERE t.encounter_id = b.encounter_id;")
            
            sql_lines.append("")
        
        # Remove migration log entry
        sql_lines.append("-- Remove migration log entry")
        sql_lines.append(f"DELETE FROM schema_migrations WHERE version = '{migration_version}';")
        sql_lines.append("")
        
        sql_lines.append("COMMIT;")
        sql_lines.append("")
        sql_lines.append("-- Rollback complete!")
        
        return '\n'.join(sql_lines)
    
    def generate_change_report(self) -> str:
        """
        Generate human-readable change report
        """
        lines = []
        
        lines.append("="*80)
        lines.append("SCHEMA MIGRATION REPORT")
        lines.append("="*80)
        lines.append(f"Generated: {datetime.now().isoformat()}")
        lines.append(f"Old Schema: {self.old_json_path}")
        lines.append(f"New Schema: {self.new_json_path}")
        lines.append("")
        
        lines.append("SUMMARY")
        lines.append("-"*80)
        lines.append(f"Fields Added:    {len(self.added_fields)}")
        lines.append(f"Fields Removed:  {len(self.removed_fields)}")
        lines.append(f"Fields Modified: {len(self.modified_fields)}")
        lines.append("")
        
        if self.added_fields:
            lines.append("ADDED FIELDS")
            lines.append("-"*80)
            for field in self.added_fields:
                info = field['info']
                lines.append(f"  • {field['field_id']}")
                lines.append(f"    Table:  {info['table_name']}")
                lines.append(f"    Column: {info['column_name']}")
                lines.append(f"    Type:   {info['field_type']}")
                lines.append(f"    Label:  {info['label'][:60]}")
                lines.append("")
        
        if self.removed_fields:
            lines.append("REMOVED FIELDS")
            lines.append("-"*80)
            for field in self.removed_fields:
                info = field['info']
                lines.append(f"  • {field['field_id']}")
                lines.append(f"    Table:  {info['table_name']}")
                lines.append(f"    Column: {info['column_name']}")
                lines.append("")
        
        if self.modified_fields:
            lines.append("MODIFIED FIELDS")
            lines.append("-"*80)
            for field in self.modified_fields:
                lines.append(f"  • {field['field_id']}")
                for change_type, change_data in field['changes'].items():
                    lines.append(f"    {change_type}: {change_data['old']} → {change_data['new']}")
                lines.append("")
        
        lines.append("="*80)
        
        return '\n'.join(lines)
    
    def run_migration(self, migration_version: str = None):
        """
        Main method to detect changes and generate migration files
        """
        # Detect changes
        self.detect_changes()
        
        # Check if any changes detected
        if not (self.added_fields or self.removed_fields or self.modified_fields):
            print("✅ No schema changes detected. Schemas are identical.")
            return None
        
        # Determine migration version
        if migration_version is None:
            # Read current version
            version_file = os.path.join(self.output_dir, "version.txt")
            if os.path.exists(version_file):
                with open(version_file, 'r') as f:
                    current_version = int(f.read().strip())
                migration_version = str(current_version + 1)
            else:
                migration_version = "2"
        
        # Create migration directory
        migration_dir = os.path.join(self.output_dir, f"migration_{migration_version}")
        os.makedirs(migration_dir, exist_ok=True)
        
        print(f"📝 Generating migration files for version {migration_version}...")
        print()
        
        # Generate migration SQL
        migration_sql = self.generate_migration_sql(migration_version)
        migration_file = os.path.join(migration_dir, f"migrate_to_v{migration_version}.sql")
        with open(migration_file, 'w', encoding='utf-8') as f:
            f.write(migration_sql)
        print(f"✅ Migration SQL: {migration_file}")
        
        # Generate rollback SQL
        rollback_sql = self.generate_rollback_sql(migration_version)
        rollback_file = os.path.join(migration_dir, f"rollback_from_v{migration_version}.sql")
        with open(rollback_file, 'w', encoding='utf-8') as f:
            f.write(rollback_sql)
        print(f"✅ Rollback SQL:  {rollback_file}")
        
        # Generate change report
        change_report = self.generate_change_report()
        report_file = os.path.join(migration_dir, "MIGRATION_REPORT.txt")
        with open(report_file, 'w', encoding='utf-8') as f:
            f.write(change_report)
        print(f"✅ Change Report: {report_file}")
        
        # Also print to console
        print()
        print(change_report)
        
        return migration_dir


def main():
    """
    Main execution function
    """
    import sys
    
    print("="*80)
    print("SCHEMA MIGRATION GENERATOR")
    print("="*80)
    print()
    
    # For demo, use the same JSON as both old and new
    # In real usage, you'd compare two different versions
    old_json = '/mnt/user-data/outputs/structured_form_fields.json'
    new_json = '/mnt/user-data/outputs/structured_form_fields.json'  # Replace with new version
    output_dir = '/mnt/user-data/outputs/sql_schema'
    
    # Check if we have two different files as arguments
    if len(sys.argv) >= 3:
        old_json = sys.argv[1]
        new_json = sys.argv[2]
        if len(sys.argv) >= 4:
            output_dir = sys.argv[3]
    
    print(f"Old Schema: {old_json}")
    print(f"New Schema: {new_json}")
    print(f"Output Dir: {output_dir}")
    print()
    
    # Create migrator
    migrator = SchemaMigration(old_json, new_json, output_dir)
    
    # Run migration
    migration_dir = migrator.run_migration()
    
    if migration_dir:
        print()
        print("="*80)
        print("✅ MIGRATION GENERATION COMPLETE")
        print("="*80)
        print(f"Migration files saved to: {migration_dir}")
        print()
        print("Next steps:")
        print("  1. Review the migration SQL file")
        print("  2. Test in development database")
        print("  3. Apply to production: psql -d your_db -f migrate_to_vX.sql")
        print("  4. If issues occur: psql -d your_db -f rollback_from_vX.sql")
        print("="*80)
    
    return migration_dir


if __name__ == '__main__':
    main()