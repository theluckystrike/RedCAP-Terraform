#!/usr/bin/env python3
"""
Excel Parser for Client Field Reordering
Converts client Excel files to JSON format for templating engine

Usage:
    python3 process_geoff_excel.py \
        --excel "path/to/file.xls" \
        --category shoulder \
        --output output/shoulder_processed.json
"""

import xlrd
import json
import argparse
import logging
import sys
from datetime import datetime
from typing import List, Dict, Optional, Tuple, Set

# Configure logging with emoji indicators
logging.basicConfig(
    level=logging.INFO,
    format='%(message)s'
)
logger = logging.getLogger(__name__)


class ExcelParser:
    """Handles reading and parsing Excel files"""

    # Excel column indices (0-based)
    COLUMN_MAP = {
        'BETTER_field_id': 1,          # Col B
        'new_order': 4,                # Col E
        'BETTER_section': 6,           # Col G
        'BETTER_label': 8,             # Col I
        'BETTER_field_type': 10,       # Col K
        'PROMS': 11,                   # Col L (for identification)
        'possible_responses': 12,      # Col M
        'BETTER_has_conditional': 14,  # Col O
        'trigger_field': 15,           # Col P
        'operator': 16,                # Col Q
        'trigger_value': 17,           # Col R
        'notes': 21                    # Col V
    }

    def __init__(self, excel_path: str, category: str):
        self.excel_path = excel_path
        self.category = category

    def read_excel(self) -> List[Dict]:
        """
        Read Excel file and extract raw rows

        Returns:
            List of dictionaries with raw column data
        """
        try:
            book = xlrd.open_workbook(self.excel_path)
            sheet = book.sheet_by_index(0)

            logger.info(f"📂 Reading Excel: {self.excel_path}")
            logger.info(f"   Rows: {sheet.nrows - 1} (excluding header)")
            logger.info(f"   Columns: {sheet.ncols}")

            rows = []
            for row_idx in range(1, sheet.nrows):  # Skip header (row 0)
                row_data = {}
                for key, col_idx in self.COLUMN_MAP.items():
                    if col_idx < sheet.ncols:
                        row_data[key] = sheet.cell(row_idx, col_idx).value
                    else:
                        row_data[key] = ''

                row_data['row_number'] = row_idx + 1  # For error reporting
                rows.append(row_data)

            # Convert to fields
            fields = [self.extract_yellow_columns(row) for row in rows]

            # Filter out empty rows (rows with no field_id)
            fields = [f for f in fields if f.get('field_id', '').strip()]

            logger.info(f"   Valid fields (after filtering empty rows): {len(fields)}")

            return fields

        except Exception as e:
            logger.error(f"❌ Failed to read Excel file: {e}")
            raise

    def extract_yellow_columns(self, row_data: Dict) -> Dict:
        """
        Extract only the "BETTER" (yellow) columns client wants used

        Args:
            row_data: Raw row data from Excel

        Returns:
            Cleaned field dictionary
        """
        field = {
            'field_id': str(row_data['BETTER_field_id']).strip(),
            'label': str(row_data['BETTER_label']).strip(),
            'field_type': str(row_data['BETTER_field_type']).strip().lower(),
            'section': str(row_data['BETTER_section']).strip() if row_data['BETTER_section'] else '',
            'validation': {'validation_type': None},  # Match existing structure
            '_source_row': row_data['row_number']  # For error tracking
        }

        # Handle new_order -> display_order conversion
        try:
            new_order = row_data['new_order']
            if isinstance(new_order, str):
                if new_order.strip():
                    field['display_order'] = int(new_order.strip())
                else:
                    field['display_order'] = None
            elif new_order:
                field['display_order'] = int(float(new_order))
            else:
                field['display_order'] = None
        except (ValueError, TypeError):
            field['display_order'] = None  # Will be caught by validator

        # Parse options for radio/checkbox/select fields
        if field['field_type'] in ['radio', 'checkbox', 'select']:
            options_str = str(row_data['possible_responses']).strip()
            if options_str and options_str != '' and options_str != 'nan':
                field['options'] = self.parse_options(options_str)

        # Parse conditional logic
        has_cond = row_data['BETTER_has_conditional']
        if has_cond == 1 or has_cond == 1.0 or str(has_cond).strip() == '1':
            conditional = self.parse_conditional(
                row_data['trigger_field'],
                row_data['operator'],
                row_data['trigger_value']
            )
            if conditional:
                field['conditional'] = conditional

        # Add note if present
        note = str(row_data.get('notes', '')).strip()
        if note and note != '' and note != 'nan':
            field['note'] = note

        # Infer interface (patient vs surgeon)
        field['interface'] = self.infer_interface(field)

        return field

    def parse_options(self, options_string: str) -> List[Dict]:
        """
        Parse POSSIBLE RESPONSES column into options array

        Input format examples:
            "1, First visit | 2, Follow up visit | 3, Surgery"
            "Yes | No"
            "0, Male | 1, Female"

        Output format:
            [{"value": "1", "label": "First visit"}, ...]
        """
        if not options_string or options_string.strip() == '':
            return []

        options = []
        segments = options_string.split('|')

        for idx, segment in enumerate(segments):
            segment = segment.strip()
            if not segment:
                continue

            # Try to split on first comma
            if ',' in segment:
                parts = segment.split(',', 1)
                value = parts[0].strip()
                label = parts[1].strip()
            else:
                # No explicit value - use index
                value = str(idx)
                label = segment

            options.append({
                'value': value,
                'label': label
            })

        return options

    def parse_conditional(self, trigger_field: str, operator: str, trigger_value: str) -> Optional[Dict]:
        """
        Convert three-column conditional format to structured object

        Args:
            trigger_field: Field that controls visibility
            operator: "IS" or "CONTAINS"
            trigger_value: Value that triggers display

        Returns:
            Conditional object with both REDCap and structured format
        """
        trigger_field = str(trigger_field).strip()
        operator = str(operator).strip().upper()
        trigger_value = str(trigger_value).strip()

        if not trigger_field or not operator or not trigger_value:
            return None

        if trigger_field == 'nan' or operator == 'nan' or trigger_value == 'nan':
            return None

        # Normalize operator
        operator_map = {
            'IS': 'equals',
            'CONTAINS': 'contains',
            '=': 'equals',
            '==': 'equals'
        }
        normalized_op = operator_map.get(operator, 'equals')

        # Build REDCap-style logic string
        if ',' in trigger_value:
            # Multiple values (OR logic)
            values = [v.strip() for v in trigger_value.split(',')]
            logic_parts = [f"[{trigger_field}] = '{v}'" for v in values]
            logic = ' or '.join(logic_parts)
        else:
            # Single value
            logic = f"[{trigger_field}] = '{trigger_value}'"

        return {
            'logic': logic,              # REDCap format (backward compatible)
            'trigger_field': trigger_field,
            'operator': normalized_op,
            'trigger_value': trigger_value
        }

    def infer_interface(self, field: Dict) -> str:
        """
        Determine if field is patient-facing or surgeon-facing

        Rules:
            - Fields with "_q" suffix (PROMS questions) -> "patient"
            - Fields with "proms" in field_id or section -> "patient"
            - Default -> "surgeon"
        """
        field_id = field.get('field_id', '').lower()
        section = field.get('section', '').lower()

        # Patient-facing indicators
        if 'proms' in field_id or 'proms' in section:
            return 'patient'
        if field_id.endswith('_q') or field_id.endswith('_score'):
            return 'patient'

        # Default
        return 'surgeon'


class FieldValidator:
    """Validates parsed field data"""

    VALID_FIELD_TYPES = {
        'text', 'textarea', 'radio', 'checkbox', 'select',
        'date', 'email', 'number', 'tel',
        'calculated', 'file', 'slider', 'display'
    }

    def __init__(self, fields: List[Dict], category: str, lenient: bool = False):
        self.fields = fields
        self.category = category
        self.lenient = lenient
        self.all_errors = []

    def validate_all(self) -> Tuple[bool, List[str]]:
        """
        Run all validation rules and collect errors

        Returns:
            Tuple of (is_valid, list of error messages)
        """
        self.all_errors = []

        # Run all validators
        self.all_errors.extend(self.validate_new_order_sequence())
        self.all_errors.extend(self.validate_required_fields())
        self.all_errors.extend(self.validate_field_types())
        self.all_errors.extend(self.validate_conditional_references())
        self.all_errors.extend(self.validate_proms_pairing())

        is_valid = len(self.all_errors) == 0
        return is_valid, self.all_errors

    def validate_new_order_sequence(self) -> List[str]:
        """Validate new_order is sequential from 1 to N with no gaps or duplicates"""
        errors = []

        # Extract all display_order values
        orders = []
        for field in self.fields:
            order = field.get('display_order')
            if order is None:
                errors.append(
                    f"Row {field['_source_row']}: Missing display_order for field '{field['field_id']}'"
                )
            else:
                orders.append((order, field))

        # Sort by display_order
        orders.sort(key=lambda x: x[0])

        # Check for duplicates
        seen = {}
        for order, field in orders:
            if order in seen:
                errors.append(
                    f"Row {field['_source_row']}: Duplicate display_order {order} "
                    f"(field '{field['field_id']}' and '{seen[order]['field_id']}')"
                )
            else:
                seen[order] = field

        # Check for gaps (expected: 1, 2, 3, ..., N) - skip in lenient mode
        if not self.lenient:
            expected = 1
            for order, field in orders:
                if order != expected:
                    errors.append(
                        f"Row {field['_source_row']}: Expected display_order {expected}, got {order} "
                        f"(gap detected for field '{field['field_id']}')"
                    )
                expected = order + 1

        return errors

    def validate_required_fields(self) -> List[str]:
        """Ensure required fields are present and non-empty"""
        errors = []

        for field in self.fields:
            row = field['_source_row']

            if not field.get('field_id', '').strip():
                errors.append(f"Row {row}: Missing field_id")

            if not field.get('label', '').strip():
                errors.append(f"Row {row}: Missing label for field '{field.get('field_id', 'UNKNOWN')}'")

            if not field.get('field_type', '').strip():
                errors.append(f"Row {row}: Missing field_type for field '{field.get('field_id', 'UNKNOWN')}'")

            if field.get('display_order') is None:
                errors.append(f"Row {row}: Missing display_order for field '{field.get('field_id', 'UNKNOWN')}'")

        return errors

    def validate_field_types(self) -> List[str]:
        """Validate field_type values against known types"""
        errors = []

        for field in self.fields:
            field_type = field.get('field_type', '').lower()
            if field_type and field_type not in self.VALID_FIELD_TYPES:
                errors.append(
                    f"Row {field['_source_row']}: Invalid field_type '{field_type}' "
                    f"for field '{field['field_id']}' (valid types: {', '.join(sorted(self.VALID_FIELD_TYPES))})"
                )

        return errors

    def validate_conditional_references(self) -> List[str]:
        """Validate that conditional logic references existing fields"""
        errors = []
        warnings = []

        # Build field_id -> field mapping
        field_map = {f['field_id']: f for f in self.fields}

        for field in self.fields:
            conditional = field.get('conditional')
            if not conditional:
                continue

            trigger_field = conditional.get('trigger_field')
            if not trigger_field:
                continue

            # Check if trigger_field exists
            if trigger_field not in field_map:
                # Might be from another category (e.g., general field)
                warnings.append(
                    f"Row {field['_source_row']}: Field '{field['field_id']}' references "
                    f"'{trigger_field}' which is not in this category (may be in 'general')"
                )
            else:
                # Check ordering - trigger must come before dependent (skip in lenient mode)
                if not self.lenient:
                    trigger_order = field_map[trigger_field].get('display_order')
                    field_order = field.get('display_order')

                    if trigger_order and field_order and trigger_order >= field_order:
                        errors.append(
                            f"Row {field['_source_row']}: Field '{field['field_id']}' (order {field_order}) "
                            f"depends on '{trigger_field}' (order {trigger_order}), but trigger comes after dependent"
                        )

        # Log warnings separately
        if warnings:
            logger.info("\n⚠️  WARNINGS (cross-category references):")
            for warning in warnings:
                logger.info(f"  {warning}")

        return errors

    def validate_proms_pairing(self) -> List[str]:
        """Validate PROMS fields come in _q and _score pairs"""
        errors = []
        warnings = []

        # Find all PROMS fields
        q_fields = {}
        score_fields = {}

        for field in self.fields:
            field_id = field['field_id']
            if field_id.endswith('_q'):
                base = field_id[:-2]  # Remove '_q'
                q_fields[base] = field
            elif field_id.endswith('_score'):
                base = field_id[:-6]  # Remove '_score'
                score_fields[base] = field

        # Check for missing pairs - treat as warnings not errors
        all_bases = set(q_fields.keys()) | set(score_fields.keys())

        for base in all_bases:
            if base not in q_fields:
                warnings.append(
                    f"Row {score_fields[base]['_source_row']}: PROMS score field '{base}_score' "
                    f"is missing matching question field '{base}_q'"
                )
            elif base not in score_fields:
                warnings.append(
                    f"Row {q_fields[base]['_source_row']}: PROMS question field '{base}_q' "
                    f"is missing matching score field '{base}_score'"
                )

        # Log warnings separately
        if warnings:
            logger.info("\n⚠️  PROMS PAIRING WARNINGS:")
            for warning in warnings[:10]:  # Show first 10
                logger.info(f"  {warning}")
            if len(warnings) > 10:
                logger.info(f"  ... and {len(warnings) - 10} more")

        return errors  # Return empty - these are warnings only


class JSONConverter:
    """Converts validated fields to JSON structure"""

    def __init__(self, fields: List[Dict], category: str, excel_path: str):
        self.fields = fields
        self.category = category
        self.excel_path = excel_path

    def convert_to_json_structure(self) -> Dict:
        """
        Convert validated fields to final JSON structure

        Returns:
            JSON dictionary matching structured_form_fields.json format
        """
        import os

        # Remove internal tracking fields
        clean_fields = []
        for field in self.fields:
            clean_field = {k: v for k, v in field.items() if not k.startswith('_')}
            clean_fields.append(clean_field)

        # Sort by display_order
        clean_fields.sort(key=lambda f: f.get('display_order', 0))

        # Build metadata
        metadata = {
            'version': '2.0',
            'category': self.category,
            'total_fields': len(clean_fields),
            'generated_at': datetime.now().isoformat(),
            'source_file': os.path.basename(self.excel_path)
        }

        return {
            'metadata': metadata,
            'fields': clean_fields
        }


def write_validation_report(category: str, is_valid: bool, errors: List[str], output_dir: str):
    """Write validation report to file"""
    report_path = f"{output_dir}/{category}_validation_report.txt"

    with open(report_path, 'w') as f:
        f.write(f"VALIDATION REPORT: {category.upper()}\n")
        f.write(f"Generated: {datetime.now().isoformat()}\n")
        f.write(f"\n{'='*80}\n")

        if is_valid:
            f.write(f"✅ VALIDATION PASSED\n")
            f.write(f"{'='*80}\n\n")
        else:
            f.write(f"❌ VALIDATION FAILED\n")
            f.write(f"TOTAL ERRORS: {len(errors)}\n")
            f.write(f"{'='*80}\n\n")

            # Group errors by type
            error_groups = {
                'new_order': [],
                'required_fields': [],
                'field_types': [],
                'conditional': [],
                'proms': []
            }

            for error in errors:
                if 'display_order' in error or 'gap' in error or 'Duplicate' in error:
                    error_groups['new_order'].append(error)
                elif 'Missing' in error:
                    error_groups['required_fields'].append(error)
                elif 'Invalid field_type' in error:
                    error_groups['field_types'].append(error)
                elif 'depends on' in error or 'references' in error:
                    error_groups['conditional'].append(error)
                elif 'PROMS' in error:
                    error_groups['proms'].append(error)

            # Print grouped errors
            for group_name, group_errors in error_groups.items():
                if group_errors:
                    f.write(f"\n{group_name.upper().replace('_', ' ')} ERRORS ({len(group_errors)}):\n")
                    f.write("-" * 80 + "\n")
                    for error in group_errors:
                        f.write(f"  • {error}\n")

    return report_path


def main():
    """Main execution"""
    parser = argparse.ArgumentParser(description='Parse client Excel files to JSON')
    parser.add_argument('--excel', required=True, help='Path to Excel file')
    parser.add_argument('--category', required=True, choices=['shoulder', 'elbow'], help='Category name')
    parser.add_argument('--output', required=True, help='Output JSON file path')
    parser.add_argument('--lenient', action='store_true', help='Auto-fix data quality issues')
    args = parser.parse_args()

    # Ensure output directory exists
    import os
    output_dir = os.path.dirname(args.output) or '.'
    os.makedirs(output_dir, exist_ok=True)

    logger.info("="*80)
    logger.info("EXCEL PARSER FOR FIELD REORDERING")
    logger.info("="*80)
    logger.info(f"Category: {args.category}")
    logger.info(f"Input: {args.excel}")
    logger.info(f"Output: {args.output}")
    logger.info("")

    # Parse Excel
    excel_parser = ExcelParser(args.excel, args.category)
    try:
        fields = excel_parser.read_excel()
        logger.info(f"✅ Parsed {len(fields)} fields from Excel\n")
    except Exception as e:
        logger.error(f"❌ Failed to parse Excel: {e}")
        return 1

    # Apply lenient mode fixes if enabled
    if args.lenient:
        logger.info("🔧 Lenient mode: Auto-fixing data quality issues...")
        fixes_applied = 0

        for field in fields:
            # Fix missing field_type - default to 'text'
            if not field.get('field_type', '').strip():
                field['field_type'] = 'text'
                fixes_applied += 1
                logger.info(f"   Fixed missing field_type for '{field['field_id']}' → 'text'")

            # Fix invalid field_type values
            field_type = field.get('field_type', '').lower()
            if field_type and field_type not in FieldValidator.VALID_FIELD_TYPES:
                # Map common invalid types to valid ones
                type_mapping = {
                    'calc': 'calculated',
                    'dropdown': 'select',
                    'multi': 'checkbox',
                    'number': 'text',  # Often means text input for numbers
                }

                # Try direct mapping
                if field_type in type_mapping:
                    field['field_type'] = type_mapping[field_type]
                    fixes_applied += 1
                # Default to 'text' for unknown types
                else:
                    field['field_type'] = 'text'
                    fixes_applied += 1

            # Fix missing label - use field_id
            if not field.get('label', '').strip():
                field['label'] = field['field_id'].replace('_', ' ').title()
                fixes_applied += 1

        if fixes_applied > 0:
            logger.info(f"✅ Applied {fixes_applied} automatic fixes\n")

    # Renumber display_order to be sequential 1 to N (always in lenient mode)
    if args.lenient:
        logger.info("🔢 Renumbering display_order to be sequential 1 to N...")
        # Sort by current display_order
        fields_sorted = sorted(fields, key=lambda f: f.get('display_order') or 999999)
        # Renumber sequentially
        for idx, field in enumerate(fields_sorted, start=1):
            old_order = field.get('display_order')
            field['display_order'] = idx
            if old_order != idx:
                logger.info(f"   Renumbered '{field['field_id']}': {old_order} → {idx}")
        # Replace fields list with renumbered version
        fields[:] = fields_sorted
        logger.info(f"✅ Renumbered {len(fields)} fields to sequential order 1-{len(fields)}\n")

    # Validate
    logger.info("🔍 Validating fields...")
    validator = FieldValidator(fields, args.category, lenient=args.lenient)
    is_valid, all_errors = validator.validate_all()

    # Write validation report
    report_path = write_validation_report(args.category, is_valid, all_errors, output_dir)

    if not is_valid:
        logger.error(f"\n❌ Validation failed with {len(all_errors)} errors")
        logger.error(f"📄 Detailed error report: {report_path}\n")
        return 1

    logger.info(f"✅ Validation passed\n")

    # Convert to JSON
    logger.info("🔄 Converting to JSON...")
    converter = JSONConverter(fields, args.category, args.excel)
    json_data = converter.convert_to_json_structure()

    # Write output
    with open(args.output, 'w', encoding='utf-8') as f:
        json.dump(json_data, f, indent=2, ensure_ascii=False)

    logger.info(f"✅ JSON written to {args.output}")
    logger.info(f"📄 Validation report: {report_path}")
    logger.info("")
    logger.info("="*80)
    logger.info(f"SUCCESS: {args.category.upper()} fields processed")
    logger.info(f"  Total fields: {len(fields)}")
    logger.info(f"  Output file: {args.output}")
    logger.info("="*80)

    return 0


if __name__ == '__main__':
    sys.exit(main())
