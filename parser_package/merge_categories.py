#!/usr/bin/env python3
"""
Merge Categories Script
Merges shoulder and elbow categories into upper_extremity category

Usage:
    python3 merge_categories.py \
        --shoulder output/shoulder_processed.json \
        --elbow output/elbow_processed.json \
        --output output/structured_form_fields_updated.json
"""

import json
import argparse
import logging
import sys
from datetime import datetime

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(message)s'
)
logger = logging.getLogger(__name__)


def renumber_elbow_fields(elbow_data: dict, start_number: int) -> dict:
    """
    Renumber elbow fields from 1509 to 2893

    Args:
        elbow_data: Parsed elbow JSON
        start_number: Starting display_order (1509)

    Returns:
        Renumbered elbow data
    """
    renumbered_fields = []

    # Sort by original display_order
    fields = sorted(elbow_data['fields'], key=lambda f: f['display_order'])

    for idx, field in enumerate(fields):
        new_field = field.copy()
        new_field['display_order'] = start_number + idx
        renumbered_fields.append(new_field)

    return {
        'metadata': elbow_data['metadata'],
        'fields': renumbered_fields
    }


def merge_shoulder_elbow(shoulder_path: str, elbow_path: str, output_path: str) -> int:
    """
    Merge shoulder and elbow into upper_extremity category

    Returns:
        0 on success, 1 on failure
    """
    logger.info("="*80)
    logger.info("MERGE CATEGORIES: SHOULDER + ELBOW → UPPER_EXTREMITY")
    logger.info("="*80)
    logger.info(f"Shoulder: {shoulder_path}")
    logger.info(f"Elbow: {elbow_path}")
    logger.info(f"Output: {output_path}")
    logger.info("")

    # Load files
    try:
        with open(shoulder_path, 'r', encoding='utf-8') as f:
            shoulder_data = json.load(f)
        logger.info(f"✅ Loaded shoulder: {len(shoulder_data['fields'])} fields")
    except Exception as e:
        logger.error(f"❌ Failed to load shoulder file: {e}")
        return 1

    try:
        with open(elbow_path, 'r', encoding='utf-8') as f:
            elbow_data = json.load(f)
        logger.info(f"✅ Loaded elbow: {len(elbow_data['fields'])} fields")
    except Exception as e:
        logger.error(f"❌ Failed to load elbow file: {e}")
        return 1

    # Renumber elbow
    shoulder_count = len(shoulder_data['fields'])
    logger.info(f"\n🔄 Renumbering elbow fields: {shoulder_count + 1} to {shoulder_count + len(elbow_data['fields'])}")
    elbow_renumbered = renumber_elbow_fields(elbow_data, shoulder_count + 1)

    # Merge fields
    all_fields = shoulder_data['fields'] + elbow_renumbered['fields']
    logger.info(f"✅ Merged {shoulder_count} shoulder + {len(elbow_renumbered['fields'])} elbow = {len(all_fields)} total fields\n")

    # Build final structure (matching original format)
    output = {
        'metadata': {
            'version': '2.0',
            'description': 'Clinical documentation form fields organized by specialty',
            'total_fields': len(all_fields),
            'generated_at': datetime.now().isoformat(),
            'field_counts': {
                'upper_extremity': len(all_fields)
            }
        },
        'categories': {
            'upper_extremity': {
                'name': 'Upper Extremity (Shoulder + Elbow)',
                'description': 'Merged shoulder and elbow specialties',
                'fields': all_fields
            }
        }
    }

    # Write output
    try:
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(output, f, indent=2, ensure_ascii=False)
        logger.info(f"✅ Merged JSON written to {output_path}")
    except Exception as e:
        logger.error(f"❌ Failed to write output file: {e}")
        return 1

    logger.info("")
    logger.info("="*80)
    logger.info("SUCCESS: CATEGORIES MERGED")
    logger.info(f"  Shoulder fields: {shoulder_count} (order 1-{shoulder_count})")
    logger.info(f"  Elbow fields: {len(elbow_renumbered['fields'])} (order {shoulder_count + 1}-{len(all_fields)})")
    logger.info(f"  Total fields: {len(all_fields)}")
    logger.info(f"  Output: {output_path}")
    logger.info("="*80)

    return 0


def main():
    """Main execution"""
    parser = argparse.ArgumentParser(description='Merge shoulder and elbow categories')
    parser.add_argument('--shoulder', required=True, help='Path to shoulder_processed.json')
    parser.add_argument('--elbow', required=True, help='Path to elbow_processed.json')
    parser.add_argument('--output', required=True, help='Output path for merged JSON')
    args = parser.parse_args()

    # Ensure output directory exists
    import os
    output_dir = os.path.dirname(args.output) or '.'
    os.makedirs(output_dir, exist_ok=True)

    return merge_shoulder_elbow(args.shoulder, args.elbow, args.output)


if __name__ == '__main__':
    sys.exit(main())
