const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const ExcelJS = require('exceljs');
const path = require('path');
const fs = require('fs');
const multer = require('multer');
const csv = require("csv-parser");
const zlib = require('zlib');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
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

// Debug route to check fields
app.get('/api/debug/fields/:projectId', (req, res) => {
  const projectId = req.params.projectId;
  db.all('SELECT * FROM fields WHERE project_id = ? ORDER BY id', [projectId], (err, rows) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    console.log('Fields in database:', rows);
    res.json({ count: rows.length, fields: rows });
  });
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

app.use((req, res, next) => {
  if (req.headers['content-encoding'] === 'gzip') {
    const gunzip = zlib.createGunzip();
    let buffer = [];

    req.pipe(gunzip);

    gunzip.on('data', (chunk) => {
      buffer.push(chunk);
    });

    gunzip.on('end', () => {
      try {
        const decompressed = Buffer.concat(buffer).toString();
        req.body={data: JSON.parse(decompressed)}; // attach to req.body like express.json()
        next();
      } catch (err) {
        next(err);
      }
    });

    gunzip.on('error', (err) => {
      next(err);
    });
  } else {
    next(); // if not gzip, pass along
  }
});

app.post('/api/download-excel', async (req, res) => {
  try {
    const { projectId, data } = req.body;

    if (!data || Object.keys(data).length === 0) {
      return res.status(400).json({ error: 'No data provided' });
    }

    const workbook = new ExcelJS.Workbook();
    const worksheet = workbook.addWorksheet(`Project_${projectId}`);

    // Add header row
    const headers = Object.keys(data.data || {});
    worksheet.addRow(headers);

    // Add rows
    Object.values(data).forEach(record => {
      worksheet.addRow(Object.values(record));
    });

    // Generate buffer
    const buffer = await workbook.xlsx.writeBuffer();

    // Set headers for download
    res.setHeader(
      'Content-Disposition',
      `attachment; filename=project_${projectId}.xlsx`
    );
    res.setHeader(
      'Content-Type',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    );

    // Send file
    res.send(buffer);
  } catch (err) {
    console.error('Excel export error:', err);
    res.status(500).json({ error: 'Failed to export Excel' });
  }
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

app.get("/api/fields", (req, res) => {
  const results = [];
  const filePath = path.join(__dirname,"Testing_DataDictionary_2025-08-27.csv");
  fs.createReadStream(filePath)
    .pipe(csv())
    .on("data", (row) => {
      const field = {
        name: row["Variable / Field Name"],
        label: row["Field Label"],
        type: "text",
        note: row["Field Note"] || null
      };

      if(row["Field Label"]!= null){

        // Field type mapping
        switch (row["Field Type"]) {
          case "notes":
            field.type = "textarea";
            break;
          case "radio":
            field.type = "radio";
            field.choices = row["Choices, Calculations, OR Slider Labels"]
              ? row["Choices, Calculations, OR Slider Labels"].split("|")
              : [];
            break;
          case "dropdown":
            field.type = "select";
            field.choices = row["Choices, Calculations, OR Slider Labels"]
              ? row["Choices, Calculations, OR Slider Labels"].split("|")
              : [];
            break;
          case "yesno":
            field.type = "select";
            field.choices = ["0, No", "1, Yes"];
            break;
          case "truefalse":
            field.type = "select";
            field.choices = ["0, False", "1, True"];
            break;
          case "calc":
            field.type = "calculated";
            break;
          case "slider":
            field.type = "range";
            break;
          case "text":
            const validation = row["Text Validation Type OR Show Slider Number"];
            if (validation === "date_dmy") field.type = "date";
            else if (validation === "email") field.type = "email";
            else if (validation === "integer" || validation === "float") field.type = "number";
            else field.type = "text";
            break;
        }

        results.push(field);
      }
    })
    .on("end", () => {
      res.json(results);
    });
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