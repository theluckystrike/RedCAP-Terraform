const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const ExcelJS = require('exceljs');
const path = require('path');
const fs = require('fs');
const multer = require('multer');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

// Configure multer for file uploads
const upload = multer({ dest: 'uploads/' });

// Initialize SQLite database
const db = new sqlite3.Database('./data.db');

// Create tables
db.serialize(() => {
  // Projects table
  db.run(`CREATE TABLE IF NOT EXISTS projects (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  )`);

  // Fields table (form structure)
  db.run(`CREATE TABLE IF NOT EXISTS fields (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    project_id INTEGER,
    field_name TEXT NOT NULL,
    field_label TEXT NOT NULL,
    field_type TEXT NOT NULL,
    options TEXT,
    required BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (project_id) REFERENCES projects (id)
  )`);

  // Records table (actual data)
  db.run(`CREATE TABLE IF NOT EXISTS records (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    project_id INTEGER,
    record_id TEXT NOT NULL,
    field_name TEXT NOT NULL,
    field_value TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES projects (id)
  )`);

  // Insert sample project and fields
  db.run(`INSERT OR IGNORE INTO projects (id, name, description) VALUES 
    (1, 'Patient Survey', 'Sample patient data collection form')`);

  const sampleFields = [
    [1, 'patient_id', 'Patient ID', 'text', null, true],
    [1, 'first_name', 'First Name', 'text', null, true],
    [1, 'last_name', 'Last Name', 'text', null, true],
    [1, 'age', 'Age', 'number', null, false],
    [1, 'gender', 'Gender', 'radio', 'Male,Female,Other', false],
    [1, 'diagnosis', 'Primary Diagnosis', 'text', null, false],
    [1, 'treatment_date', 'Treatment Date', 'date', null, false],
    [1, 'satisfaction', 'Satisfaction Rating', 'radio', '1,2,3,4,5', false]
  ];

  const stmt = db.prepare(`INSERT OR IGNORE INTO fields 
    (project_id, field_name, field_label, field_type, options, required) VALUES (?, ?, ?, ?, ?, ?)`);
  
  sampleFields.forEach(field => {
    stmt.run(field);
  });
  stmt.finalize();
});

// Routes

// Serve main page
app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
        <title>REDCap-style Data Server</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
            body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
            .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
            .header { background: #007bff; color: white; padding: 15px; margin: -20px -20px 20px -20px; border-radius: 8px 8px 0 0; }
            .nav { margin: 20px 0; }
            .nav button { margin-right: 10px; padding: 10px 15px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; }
            .nav button:hover { background: #0056b3; }
            .nav button.active { background: #28a745; }
            .section { display: none; }
            .section.active { display: block; }
            .form-group { margin: 15px 0; }
            .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
            .form-group input, .form-group select, .form-group textarea { 
                width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; 
            }
            .form-group input[type="radio"] { width: auto; margin-right: 8px; }
            .radio-group { display: flex; gap: 15px; flex-wrap: wrap; }
            .radio-group label { display: flex; align-items: center; font-weight: normal; margin-bottom: 0; }
            .btn { padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px; }
            .btn:hover { background: #0056b3; }
            .btn-success { background: #28a745; }
            .btn-success:hover { background: #218838; }
            .btn-danger { background: #dc3545; }
            .btn-danger:hover { background: #c82333; }
            .table { width: 100%; border-collapse: collapse; margin-top: 20px; }
            .table th, .table td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
            .table th { background-color: #f8f9fa; font-weight: bold; }
            .table tr:hover { background-color: #f5f5f5; }
            .alert { padding: 15px; margin: 20px 0; border: 1px solid transparent; border-radius: 4px; }
            .alert-success { color: #155724; background-color: #d4edda; border-color: #c3e6cb; }
            .alert-error { color: #721c24; background-color: #f8d7da; border-color: #f5c6cb; }
            .records-container { max-height: 400px; overflow-y: auto; }
            .export-section { background: #f8f9fa; padding: 15px; border-radius: 4px; margin: 20px 0; }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>REDCap-style Data Server</h1>
                <p>Collect, manage, and export data to Excel</p>
            </div>

            <div class="nav">
                <button onclick="showSection('data-entry')" id="data-entry-btn" class="active">Data Entry</button>
                <button onclick="showSection('view-data')" id="view-data-btn">View Data</button>
                <button onclick="showSection('export-data')" id="export-data-btn">Export Data</button>
            </div>

            <div id="alert-container"></div>

            <div id="data-entry" class="section active">
                <h2>Data Entry Form</h2>
                <form id="dataForm">
                    <div id="form-fields"></div>
                    <button type="submit" class="btn btn-success">Save Record</button>
                    <button type="button" class="btn" onclick="clearForm()">Clear Form</button>
                </form>
            </div>

            <div id="view-data" class="section">
                <h2>View Records</h2>
                <button onclick="loadRecords()" class="btn">Refresh Data</button>
                <div class="records-container">
                    <table id="records-table" class="table">
                        <thead>
                            <tr id="records-header"></tr>
                        </thead>
                        <tbody id="records-body"></tbody>
                    </table>
                </div>
            </div>

            <div id="export-data" class="section">
                <h2>Export Data</h2>
                <div class="export-section">
                    <h3>Export Options</h3>
                    <p>Export all records to Excel format (.xlsx)</p>
                    <button onclick="exportToExcel()" class="btn btn-success">Download Excel File</button>
                    <button onclick="exportToCSV()" class="btn">Download CSV File</button>
                </div>
                
                <div class="export-section">
                    <h3>Import Data</h3>
                    <p>Upload Excel or CSV file to import records</p>
                    <input type="file" id="import-file" accept=".xlsx,.csv" />
                    <button onclick="importData()" class="btn">Import File</button>
                </div>
            </div>
        </div>

        <script>
            let currentFields = [];
            let currentRecords = [];

            // Initialize
            document.addEventListener('DOMContentLoaded', function() {
                loadFields();
            });

            function showSection(sectionId) {
                document.querySelectorAll('.section').forEach(section => {
                    section.classList.remove('active');
                });
                document.querySelectorAll('.nav button').forEach(btn => {
                    btn.classList.remove('active');
                });
                
                document.getElementById(sectionId).classList.add('active');
                document.getElementById(sectionId + '-btn').classList.add('active');

                if (sectionId === 'view-data') {
                    loadRecords();
                }
            }

            function showAlert(message, type = 'success') {
                const alertContainer = document.getElementById('alert-container');
                alertContainer.innerHTML = \`<div class="alert alert-\${type}">\${message}</div>\`;
                setTimeout(() => {
                    alertContainer.innerHTML = '';
                }, 5000);
            }

            async function loadFields() {
                try {
                    const response = await fetch('/api/fields/1');
                    const fields = await response.json();
                    currentFields = fields;
                    renderForm(fields);
                } catch (error) {
                    console.error('Error loading fields:', error);
                    showAlert('Error loading form fields', 'error');
                }
            }

            function renderForm(fields) {
                const container = document.getElementById('form-fields');
                container.innerHTML = '';

                fields.forEach(field => {
                    const div = document.createElement('div');
                    div.className = 'form-group';
                    
                    let inputHTML = '';
                    const required = field.required ? 'required' : '';
                    
                    switch(field.field_type) {
                        case 'text':
                            inputHTML = \`<input type="text" id="\${field.field_name}" name="\${field.field_name}" \${required} />\`;
                            break;
                        case 'number':
                            inputHTML = \`<input type="number" id="\${field.field_name}" name="\${field.field_name}" \${required} />\`;
                            break;
                        case 'date':
                            inputHTML = \`<input type="date" id="\${field.field_name}" name="\${field.field_name}" \${required} />\`;
                            break;
                        case 'radio':
                            const options = field.options ? field.options.split(',') : [];
                            inputHTML = '<div class="radio-group">';
                            options.forEach(option => {
                                inputHTML += \`
                                    <label>
                                        <input type="radio" name="\${field.field_name}" value="\${option.trim()}" \${required} />
                                        \${option.trim()}
                                    </label>
                                \`;
                            });
                            inputHTML += '</div>';
                            break;
                        case 'textarea':
                            inputHTML = \`<textarea id="\${field.field_name}" name="\${field.field_name}" rows="4" \${required}></textarea>\`;
                            break;
                    }
                    
                    div.innerHTML = \`
                        <label for="\${field.field_name}">\${field.field_label}\${field.required ? ' *' : ''}</label>
                        \${inputHTML}
                    \`;
                    
                    container.appendChild(div);
                });
            }

            document.getElementById('dataForm').addEventListener('submit', async function(e) {
                e.preventDefault();
                
                const formData = new FormData(e.target);
                const data = {};
                
                for (let [key, value] of formData.entries()) {
                    data[key] = value;
                }
                
                try {
                    const response = await fetch('/api/records', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ projectId: 1, data: data })
                    });
                    
                    if (response.ok) {
                        showAlert('Record saved successfully!');
                        clearForm();
                    } else {
                        throw new Error('Failed to save record');
                    }
                } catch (error) {
                    console.error('Error saving record:', error);
                    showAlert('Error saving record', 'error');
                }
            });

            function clearForm() {
                document.getElementById('dataForm').reset();
            }

            async function loadRecords() {
                try {
                    const response = await fetch('/api/records/1');
                    const records = await response.json();
                    currentRecords = records;
                    renderRecordsTable(records);
                } catch (error) {
                    console.error('Error loading records:', error);
                    showAlert('Error loading records', 'error');
                }
            }

            function renderRecordsTable(records) {
                const header = document.getElementById('records-header');
                const body = document.getElementById('records-body');
                
                if (records.length === 0) {
                    header.innerHTML = '<th>No records found</th>';
                    body.innerHTML = '';
                    return;
                }

                // Get all unique field names
                const fieldNames = [...new Set(records.map(r => r.field_name))];
                
                // Create header
                header.innerHTML = '<th>Record ID</th>' + fieldNames.map(name => 
                    \`<th>\${currentFields.find(f => f.field_name === name)?.field_label || name}</th>\`
                ).join('');

                // Group records by record_id
                const groupedRecords = {};
                records.forEach(record => {
                    if (!groupedRecords[record.record_id]) {
                        groupedRecords[record.record_id] = {};
                    }
                    groupedRecords[record.record_id][record.field_name] = record.field_value;
                });

                // Create rows
                body.innerHTML = Object.keys(groupedRecords).map(recordId => {
                    const record = groupedRecords[recordId];
                    return '<tr><td>' + recordId + '</td>' + 
                           fieldNames.map(fieldName => \`<td>\${record[fieldName] || ''}</td>\`).join('') + 
                           '</tr>';
                }).join('');
            }

            async function exportToExcel() {
                try {
                    const response = await fetch('/api/export/excel/1');
                    if (response.ok) {
                        const blob = await response.blob();
                        const url = window.URL.createObjectURL(blob);
                        const a = document.createElement('a');
                        a.href = url;
                        a.download = 'patient_data.xlsx';
                        a.click();
                        window.URL.revokeObjectURL(url);
                        showAlert('Excel file downloaded successfully!');
                    } else {
                        throw new Error('Export failed');
                    }
                } catch (error) {
                    console.error('Error exporting to Excel:', error);
                    showAlert('Error exporting to Excel', 'error');
                }
            }

            async function exportToCSV() {
                try {
                    const response = await fetch('/api/export/csv/1');
                    if (response.ok) {
                        const blob = await response.blob();
                        const url = window.URL.createObjectURL(blob);
                        const a = document.createElement('a');
                        a.href = url;
                        a.download = 'patient_data.csv';
                        a.click();
                        window.URL.revokeObjectURL(url);
                        showAlert('CSV file downloaded successfully!');
                    } else {
                        throw new Error('Export failed');
                    }
                } catch (error) {
                    console.error('Error exporting to CSV:', error);
                    showAlert('Error exporting to CSV', 'error');
                }
            }

            async function importData() {
                const fileInput = document.getElementById('import-file');
                const file = fileInput.files[0];
                
                if (!file) {
                    showAlert('Please select a file to import', 'error');
                    return;
                }

                const formData = new FormData();
                formData.append('file', file);
                formData.append('projectId', '1');

                try {
                    const response = await fetch('/api/import', {
                        method: 'POST',
                        body: formData
                    });

                    if (response.ok) {
                        const result = await response.json();
                        showAlert(\`Import successful! \${result.imported} records imported.\`);
                        loadRecords();
                        fileInput.value = '';
                    } else {
                        throw new Error('Import failed');
                    }
                } catch (error) {
                    console.error('Error importing data:', error);
                    showAlert('Error importing data', 'error');
                }
            }
        </script>
    </body>
    </html>
  `);
});

// API Routes

// Get fields for a project
app.get('/api/fields/:projectId', (req, res) => {
  const projectId = req.params.projectId;
  db.all('SELECT * FROM fields WHERE project_id = ? ORDER BY id', [projectId], (err, rows) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json(rows);
  });
});

// Get all records for a project
app.get('/api/records/:projectId', (req, res) => {
  const projectId = req.params.projectId;
  db.all('SELECT * FROM records WHERE project_id = ? ORDER BY record_id, field_name', [projectId], (err, rows) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json(rows);
  });
});

// Save a new record
app.post('/api/records', (req, res) => {
  const { projectId, data } = req.body;
  const recordId = data.patient_id || Date.now().toString();
  
  db.serialize(() => {
    const stmt = db.prepare('INSERT INTO records (project_id, record_id, field_name, field_value) VALUES (?, ?, ?, ?)');
    
    Object.keys(data).forEach(fieldName => {
      if (data[fieldName]) {
        stmt.run([projectId, recordId, fieldName, data[fieldName]]);
      }
    });
    
    stmt.finalize((err) => {
      if (err) {
        res.status(500).json({ error: err.message });
        return;
      }
      res.json({ success: true, recordId });
    });
  });
});

// Export to Excel
app.get('/api/export/excel/:projectId', async (req, res) => {
  const projectId = req.params.projectId;
  
  try {
    // Get fields and records
    const fields = await new Promise((resolve, reject) => {
      db.all('SELECT * FROM fields WHERE project_id = ? ORDER BY id', [projectId], (err, rows) => {
        if (err) reject(err);
        else resolve(rows);
      });
    });

    const records = await new Promise((resolve, reject) => {
      db.all('SELECT * FROM records WHERE project_id = ? ORDER BY record_id, field_name', [projectId], (err, rows) => {
        if (err) reject(err);
        else resolve(rows);
      });
    });

    // Create Excel workbook
    const workbook = new ExcelJS.Workbook();
    const worksheet = workbook.addWorksheet('Patient Data');

    // Group records by record_id
    const groupedRecords = {};
    records.forEach(record => {
      if (!groupedRecords[record.record_id]) {
        groupedRecords[record.record_id] = {};
      }
      groupedRecords[record.record_id][record.field_name] = record.field_value;
    });

    // Create headers
    const headers = ['Record ID', ...fields.map(f => f.field_label)];
    worksheet.addRow(headers);

    // Style headers
    const headerRow = worksheet.getRow(1);
    headerRow.font = { bold: true };
    headerRow.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: 'FFE0E0E0' } };

    // Add data rows
    Object.keys(groupedRecords).forEach(recordId => {
      const record = groupedRecords[recordId];
      const row = [recordId, ...fields.map(f => record[f.field_name] || '')];
      worksheet.addRow(row);
    });

    // Auto-fit columns
    worksheet.columns.forEach(column => {
      column.width = Math.max(column.width || 0, 15);
    });

    // Generate Excel file
    res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    res.setHeader('Content-Disposition', 'attachment; filename="patient_data.xlsx"');
    
    await workbook.xlsx.write(res);
    res.end();
  } catch (error) {
    console.error('Export error:', error);
    res.status(500).json({ error: 'Export failed' });
  }
});

// Export to CSV
app.get('/api/export/csv/:projectId', async (req, res) => {
  const projectId = req.params.projectId;
  
  try {
    const fields = await new Promise((resolve, reject) => {
      db.all('SELECT * FROM fields WHERE project_id = ? ORDER BY id', [projectId], (err, rows) => {
        if (err) reject(err);
        else resolve(rows);
      });
    });

    const records = await new Promise((resolve, reject) => {
      db.all('SELECT * FROM records WHERE project_id = ? ORDER BY record_id, field_name', [projectId], (err, rows) => {
        if (err) reject(err);
        else resolve(rows);
      });
    });

    // Group records by record_id
    const groupedRecords = {};
    records.forEach(record => {
      if (!groupedRecords[record.record_id]) {
        groupedRecords[record.record_id] = {};
      }
      groupedRecords[record.record_id][record.field_name] = record.field_value;
    });

    // Create CSV content
    const headers = ['Record ID', ...fields.map(f => f.field_label)];
    let csv = headers.join(',') + '\n';

    Object.keys(groupedRecords).forEach(recordId => {
      const record = groupedRecords[recordId];
      const row = [recordId, ...fields.map(f => `"${(record[f.field_name] || '').replace(/"/g, '""')}"`)];
      csv += row.join(',') + '\n';
    });

    res.setHeader('Content-Type', 'text/csv');
    res.setHeader('Content-Disposition', 'attachment; filename="patient_data.csv"');
    res.send(csv);
  } catch (error) {
    console.error('Export error:', error);
    res.status(500).json({ error: 'Export failed' });
  }
});

// Import data from Excel/CSV
app.post('/api/import', upload.single('file'), async (req, res) => {
  const projectId = req.body.projectId;
  const file = req.file;

  if (!file) {
    return res.status(400).json({ error: 'No file uploaded' });
  }

  try {
    let data = [];
    
    if (file.originalname.endsWith('.xlsx')) {
      // Read Excel file
      const workbook = new ExcelJS.Workbook();
      await workbook.xlsx.readFile(file.path);
      const worksheet = workbook.getWorksheet(1);
      
      const headers = [];
      worksheet.getRow(1).eachCell((cell, colNumber) => {
        headers[colNumber] = cell.text;
      });

      worksheet.eachRow((row, rowNumber) => {
        if (rowNumber > 1) {
          const rowData = {};
          row.eachCell((cell, colNumber) => {
            if (headers[colNumber]) {
              rowData[headers[colNumber]] = cell.text;
            }
          });
          data.push(rowData);
        }
      });
    } else if (file.originalname.endsWith('.csv')) {
      // Read CSV file
      const csvContent = fs.readFileSync(file.path, 'utf8');
      const lines = csvContent.split('\n');
      const headers = lines[0].split(',').map(h => h.trim().replace(/"/g, ''));
      
      for (let i = 1; i < lines.length; i++) {
        if (lines[i].trim()) {
          const values = lines[i].split(',').map(v => v.trim().replace(/"/g, ''));
          const rowData = {};
          headers.forEach((header, index) => {
            rowData[header] = values[index] || '';
          });
          data.push(rowData);
        }
      }
    }

    // Get field mappings
    const fields = await new Promise((resolve, reject) => {
      db.all('SELECT * FROM fields WHERE project_id = ?', [projectId], (err, rows) => {
        if (err) reject(err);
        else resolve(rows);
      });
    });

    const fieldMap = {};
    fields.forEach(field => {
      fieldMap[field.field_label] = field.field_name;
    });

    // Insert data
    let imported = 0;
    db.serialize(() => {
      const stmt = db.prepare('INSERT INTO records (project_id, record_id, field_name, field_value) VALUES (?, ?, ?, ?)');
      
      data.forEach((row, index) => {
        const recordId = row['Record ID'] || `imported_${Date.now()}_${index}`;
        
        Object.keys(row).forEach(key => {
          if (key !== 'Record ID' && row[key]) {
            const fieldName = fieldMap[key];
            if (fieldName) {
              stmt.run([projectId, recordId, fieldName, row[key]]);
              imported++;
            }
          }
        });
      });
      
      stmt.finalize();
    });

    // Clean up uploaded file
    fs.unlinkSync(file.path);

    res.json({ success: true, imported });
  } catch (error) {
    console.error('Import error:', error);
    res.status(500).json({ error: 'Import failed' });
  }
});

// Start server
app.listen(PORT, () => {
  console.log(`REDCap-style server running on http://localhost:${PORT}`);
  console.log('Features:');
  console.log('- Web-based data entry form');
  console.log('- SQLite database for data storage');
  console.log('- Excel export (.xlsx)');
  console.log('- CSV export');
  console.log('- Excel/CSV import');
  console.log('- RESTful API endpoints');
});

// Graceful shutdown
process.on('SIGINT', () => {
  console.log('\nShutting down server...');
  db.close((err) => {
    if (err) {
      console.error(err.message);
    }
    console.log('Database connection closed.');
    process.exit(0);
  });
});