import csv
from docx import Document
from docx.shared import Pt, RGBColor, Inches
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml.ns import qn
from docx.oxml import OxmlElement

def add_table_borders(table):
    """Add borders to table"""
    tbl = table._element
    tblPr = tbl.tblPr
    if tblPr is None:
        tblPr = OxmlElement('w:tblPr')
        tbl.insert(0, tblPr)
    
    tblBorders = OxmlElement('w:tblBorders')
    for border_name in ['top', 'left', 'bottom', 'right', 'insideH', 'insideV']:
        border = OxmlElement(f'w:{border_name}')
        border.set(qn('w:val'), 'single')
        border.set(qn('w:sz'), '4')
        border.set(qn('w:space'), '0')
        border.set(qn('w:color'), '000000')
        tblBorders.append(border)
    tblPr.append(tblBorders)

def create_docx_from_csv(csv_file_path, output_docx_path):
    """
    Read CSV file and create a DOCX document with field mappings
    
    Args:
        csv_file_path: Path to the input CSV file
        output_docx_path: Path for the output DOCX file
    """
    # Create a new Document
    doc = Document()
    
    # Add title
    title = doc.add_heading('Field Label to SQL Column Name Mappings', 0)
    title.alignment = WD_ALIGN_PARAGRAPH.CENTER
    
    # Add a paragraph explaining the document
    intro = doc.add_paragraph()
    intro_run = intro.add_run('This document contains mappings between field labels and their corresponding SQL column names.\n')
    intro_run.bold = True
    intro_run.font.size = Pt(11)
    
    format_run = intro.add_run('Format: Field Label = {d.SQL_Column_Name}')
    format_run.font.size = Pt(10)
    format_run.font.color.rgb = RGBColor(100, 100, 100)
    
    doc.add_paragraph()  # Add spacing
    
    # Read CSV file and collect data
    mappings = []
    try:
        with open(csv_file_path, 'r', encoding='utf-8') as csvfile:
            csv_reader = csv.DictReader(csvfile)
            
            # Check if required columns exist
            if 'Field Label' not in csv_reader.fieldnames or 'SQL_Column_Name' not in csv_reader.fieldnames:
                print("Error: CSV must have 'Field Label' and 'SQL_Column_Name' columns")
                return
            
            for row in csv_reader:
                field_label = row['Field Label']
                sql_column = row['SQL_Column_Name']
                
                # Skip empty rows
                if field_label and sql_column:
                    mappings.append((field_label, sql_column))
        
        print(f"Total mappings found: {len(mappings)}")
        
    except FileNotFoundError:
        print(f"Error: File '{csv_file_path}' not found")
        return
    except Exception as e:
        print(f"Error reading CSV file: {e}")
        return
    
    # Create table
    table = doc.add_table(rows=1, cols=3)
    table.style = 'Light Grid Accent 1'
    table.autofit = False
    table.allow_autofit = False
    
    # Set column widths
    table.columns[0].width = Inches(0.5)
    table.columns[1].width = Inches(3.0)
    table.columns[2].width = Inches(3.0)
    
    # Add header row
    header_cells = table.rows[0].cells
    header_cells[0].text = '#'
    header_cells[1].text = 'Field Label'
    header_cells[2].text = 'SQL Column Name (d.column_name)'
    
    # Format header row
    for cell in header_cells:
        cell.paragraphs[0].runs[0].font.bold = True
        cell.paragraphs[0].runs[0].font.size = Pt(11)
        cell.paragraphs[0].alignment = WD_ALIGN_PARAGRAPH.CENTER
        # Set background color for header
        shading_elm = OxmlElement('w:shd')
        shading_elm.set(qn('w:fill'), 'D9E2F3')
        cell._element.get_or_add_tcPr().append(shading_elm)
    
    # Add data rows
    for idx, (field_label, sql_column) in enumerate(mappings, start=1):
        row_cells = table.add_row().cells
        row_cells[0].text = str(idx)
        row_cells[1].text = field_label
        row_cells[2].text = f"{{d.{sql_column}}}"
        
        # Format cells
        row_cells[0].paragraphs[0].alignment = WD_ALIGN_PARAGRAPH.CENTER
        row_cells[0].paragraphs[0].runs[0].font.size = Pt(9)
        row_cells[1].paragraphs[0].runs[0].font.size = Pt(10)
        row_cells[2].paragraphs[0].runs[0].font.size = Pt(10)
        row_cells[2].paragraphs[0].runs[0].font.color.rgb = RGBColor(0, 0, 255)
    
    # Add borders to table
    add_table_borders(table)
    
    # Add footer with count
    doc.add_paragraph()
    footer = doc.add_paragraph()
    footer_run = footer.add_run(f'Total Mappings: {len(mappings)}')
    footer_run.bold = True
    footer_run.font.size = Pt(10)
    footer.alignment = WD_ALIGN_PARAGRAPH.RIGHT
    
    # Save document
    doc.save(output_docx_path)
    print(f"Document created successfully: {output_docx_path}")
    print(f"Total mappings written: {len(mappings)}")


# Example usage
if __name__ == "__main__":
    # Update these paths according to your file locations
    csv_input_file = "/Users/ankitgatg/Desktop/RedCAP-Terraform/ansible/files/sql_files/3/redcap_column_mapping.csv"  # Update with your CSV file path
    docx_output_file = "/Users/ankitgatg/Desktop/RedCAP-Terraform/patient_report.docx"
    
    create_docx_from_csv(csv_input_file, docx_output_file)