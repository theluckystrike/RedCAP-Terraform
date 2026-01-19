#!/usr/bin/env python3
"""
Fix Duplicate Display Order
Auto-renumbers fields to ensure sequential ordering 1 to N with no duplicates

Usage:
    python3 fix_duplicate_ordering.py \
        --excel "path/to/file.xls" \
        --output "path/to/fixed_file.xls"
"""

import xlrd
from xlrd import open_workbook
from xlwt import Workbook, easyxf
import argparse
import logging
import sys

logging.basicConfig(level=logging.INFO, format='%(message)s')
logger = logging.getLogger(__name__)


def fix_duplicate_ordering(input_path: str, output_path: str) -> int:
    """
    Read Excel file, auto-renumber display_order column, write to new file

    Returns:
        0 on success, 1 on failure
    """
    logger.info("="*80)
    logger.info("FIX DUPLICATE DISPLAY ORDER")
    logger.info("="*80)
    logger.info(f"Input: {input_path}")
    logger.info(f"Output: {output_path}")
    logger.info("")

    # Read input file
    try:
        rb = open_workbook(input_path, formatting_info=True)
        rs = rb.sheet_by_index(0)
        logger.info(f"✅ Read {rs.nrows} rows, {rs.ncols} columns")
    except Exception as e:
        logger.error(f"❌ Failed to read input file: {e}")
        return 1

    # Create output workbook
    wb = Workbook()
    ws = wb.add_sheet('Sheet1')

    # Copy header row (row 0)
    for col_idx in range(rs.ncols):
        ws.write(0, col_idx, rs.cell(0, col_idx).value)

    # Process data rows - renumber column E (index 4 = new_order)
    logger.info("🔄 Renumbering display_order column (E)...")

    duplicates_found = 0
    for row_idx in range(1, rs.nrows):
        for col_idx in range(rs.ncols):
            cell_value = rs.cell(row_idx, col_idx).value

            # Column E (index 4) is new_order - renumber sequentially
            if col_idx == 4:
                new_display_order = row_idx  # Sequential: 1, 2, 3, ...

                # Check if we're fixing a duplicate
                if cell_value != new_display_order:
                    duplicates_found += 1

                ws.write(row_idx, col_idx, new_display_order)
            else:
                # Copy other columns as-is
                ws.write(row_idx, col_idx, cell_value)

    logger.info(f"✅ Fixed {duplicates_found} duplicate/incorrect display_order values")

    # Save output
    try:
        wb.save(output_path)
        logger.info(f"✅ Saved to {output_path}")
    except Exception as e:
        logger.error(f"❌ Failed to save output file: {e}")
        return 1

    logger.info("")
    logger.info("="*80)
    logger.info("SUCCESS: Display order renumbered sequentially")
    logger.info(f"  Total rows: {rs.nrows - 1}")
    logger.info(f"  Display order: 1 to {rs.nrows - 1}")
    logger.info(f"  Fixed values: {duplicates_found}")
    logger.info("="*80)

    return 0


def main():
    parser = argparse.ArgumentParser(description='Fix duplicate display_order values')
    parser.add_argument('--excel', required=True, help='Input Excel file')
    parser.add_argument('--output', required=True, help='Output Excel file')
    args = parser.parse_args()

    return fix_duplicate_ordering(args.excel, args.output)


if __name__ == '__main__':
    sys.exit(main())
