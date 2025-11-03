const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const ExcelJS = require('exceljs');
const path = require('path');
const fs = require('fs');
const multer = require('multer');
const csv = require("csv-parser");
const zlib = require('zlib');
const { S3Client, PutObjectCommand, ListObjectsV2Command, GetObjectCommand } = require("@aws-sdk/client-s3");
const { getSignedUrl } = require("@aws-sdk/s3-request-presigner");
const cron = require("node-cron");

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.static('public'));

// Configure multer for file uploads
const upload = multer({ dest: 'uploads/' });
const s3 = new S3Client({ region: "ap-southeast-2" });

// Initialize SQLite database
let results = [];
let fields = [];
const db = new sqlite3.Database("./data.db");

const uploadToS3 = async (filePath, bucketName) => {
  const fileContent = fs.readFileSync(filePath);
  const fileName = path.basename(filePath);

  const command = new PutObjectCommand({
    Bucket: bucketName,
    Key: `incoming/${fileName}`,
    Body: fileContent,
    ServerSideEncryption: "AES256"
  });

  await s3.send(command);
  console.log(`Uploaded ${fileName} to S3://${bucketName}/incoming/`);
};

const prepareData = () => {
  results.length = 0;
  fields.length = 0;
  let seen = new Set();
  
  return new Promise((resolve, reject) => {
    const filePath = path.join(__dirname, "Testing_DataDictionary_2025-08-27.csv");

    fs.createReadStream(filePath)
      .pipe(csv())
      .on("data", (row) => {
        if (!row["Field Label"]) return;

        const label = row["Field Label"].trim().toLowerCase();

        if(seen.has(label))
          return;
        else
          seen.add(label);

        const field = {
          name: row["Variable / Field Name"],
          label: row["Field Label"],
          type: "text",
          note: row["Field Note"] || null
        };

        switch (row["Field Type"]) {
          case "notes": field.type = "textarea"; break;
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
          case "yesno": field.type = "select"; field.choices = ["0, No", "1, Yes"]; break;
          case "truefalse": field.type = "select"; field.choices = ["0, False", "1, True"]; break;
          case "calc": field.type = "calculated"; break;
          case "slider": field.type = "range"; break;
          case "text":
            const validation = row["Text Validation Type OR Show Slider Number"];
            if (validation === "date_dmy") field.type = "date";
            else if (validation === "email") field.type = "email";
            else if (validation === "integer" || validation === "float") field.type = "number";
            else field.type = "text";
            break;
        }

        fields.push(field.label);
        results.push(field);
      })
      .on("end", () => resolve())
      .on("error", (err) => reject(err));
  });
};

const exportNewDataToExcel = async (onlyUnuploaded = false) => {
  return new Promise((resolve, reject) => {
    let sql = `
      SELECT * FROM my_table 
      WHERE created_at >= datetime('now', '-1 hour')
    `;
    
    if (onlyUnuploaded) {
      sql = `
        SELECT * FROM my_table 
        WHERE uploaded_to_s3 = 0
      `;
    }
    
    db.all(sql, [], async (err, rows) => {
      if (err) return reject(err);
      if (rows.length === 0) return resolve(null);

      try {
        const workbook = new ExcelJS.Workbook();
        const worksheet = workbook.addWorksheet('NewData');

        // Add headers
        worksheet.addRow(Object.keys(rows[0]));

        // Add rows
        rows.forEach(row => worksheet.addRow(Object.values(row)));

        // Write to temp file
        const filePath = path.join(__dirname, `export_${Date.now()}.xlsx`);
        await workbook.xlsx.writeFile(filePath);

        resolve({ filePath, rowIds: rows.map(r => r.id) });
      } catch (e) {
        reject(e);
      }
    });
  });
};

// Function to mark records as uploaded
const markAsUploaded = (ids) => {
  return new Promise((resolve, reject) => {
    const placeholders = ids.map(() => '?').join(',');
    const sql = `UPDATE my_table SET uploaded_to_s3 = 1 WHERE id IN (${placeholders})`;
    
    db.run(sql, ids, function(err) {
      if (err) return reject(err);
      resolve(this.changes);
    });
  });
};

// Helper function to filter unuploaded IDs
const getUnuploadedIds = (ids) => {
  return new Promise((resolve, reject) => {
    const placeholders = ids.map(() => '?').join(',');
    const sql = `SELECT id FROM my_table WHERE id IN (${placeholders}) AND uploaded_to_s3 = 0`;
    
    db.all(sql, ids, (err, rows) => {
      if (err) return reject(err);
      resolve(rows.map(r => r.id));
    });
  });
};

// UPDATED: Create table with migration support
const createTable = () => {
  // First, create table if it doesn't exist
  const columns = fields.map(f => `"${f.replace(/"/g, '""')}" TEXT`).join(", ");
  const sql = `CREATE TABLE IF NOT EXISTS my_table (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    uploaded_to_s3 INTEGER DEFAULT 0
    ${columns ? ", " + columns : ""}
  )`;
  
  db.run(sql, (err) => {
    if (err) {
      console.error("Error creating table:", err.message);
    } else {
      console.log("Table checked/created.");
      
      // Check if uploaded_to_s3 column exists, if not add it (for existing tables)
      db.all("PRAGMA table_info(my_table)", [], (err, rows) => {
        if (err) {
          console.error("Error checking table structure:", err.message);
          return;
        }
        
        const hasUploadedColumn = rows.some(row => row.name === 'uploaded_to_s3');
        
        if (!hasUploadedColumn) {
          console.log("⚠️  Adding uploaded_to_s3 column to existing table...");
          db.run("ALTER TABLE my_table ADD COLUMN uploaded_to_s3 INTEGER DEFAULT 0", (err) => {
            if (err) {
              console.error("❌ Error adding uploaded_to_s3 column:", err.message);
            } else {
              console.log("✅ uploaded_to_s3 column added successfully.");
            }
          });
        } else {
          console.log("✅ Table structure is up to date.");
        }
        
        // Check for any missing field columns and add them
        const existingColumns = rows.map(row => row.name);
        const missingFields = fields.filter(f => !existingColumns.includes(f));
        
        if (missingFields.length > 0) {
          console.log(`⚠️  Adding ${missingFields.length} missing field columns...`);
          
          missingFields.forEach(field => {
            const escapedField = `"${field.replace(/"/g, '""')}"`;
            db.run(`ALTER TABLE my_table ADD COLUMN ${escapedField} TEXT`, (err) => {
              if (err) {
                console.error(`❌ Error adding column ${field}:`, err.message);
              } else {
                console.log(`✅ Added column: ${field}`);
              }
            });
          });
        }
      });
    }
  });
};

const insertData = (data) => {
  const cols = fields.map(f => `"${f.replace(/"/g, '""')}"`).join(", ");
  const placeholders = fields.map(() => "?").join(", ");
  const sql = `INSERT INTO my_table (${cols}) VALUES (${placeholders})`;
  const values = fields.map(f => data[f] || null);

  db.run(sql, values, function(err) {
    if (err) return console.error("Insert error:", err.message);
    console.log(`Row inserted with ID: ${this.lastID}`);
  });
};

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
        req.body = {data: JSON.parse(decompressed)};
        next();
      } catch (err) {
        next(err);
      }
    });

    gunzip.on('error', (err) => {
      next(err);
    });
  } else {
    next();
  }
});

app.post('/api/addDataEntry', async(req, res) => {
  const { projectId, data } = req.body;
  let sqlInsertData = {};
  
  Object.values(data).forEach(record => {
    Object.entries(record).forEach(([key, value]) => {
      sqlInsertData[key] = value;
    });
  });
  
  try {
    insertData(sqlInsertData);
    res.status(200).json("data added successfully");
  } catch(err) {
    res.status(500).json("There was error while adding data");
  }
});

app.post('/api/download-excel', async (req, res) => {
  try {
    const {projectId, data} = req.body;
    
    if (!data || Object.keys(data).length === 0) {
      return res.status(400).json({ error: 'No data provided' });
    }

    const workbook = new ExcelJS.Workbook();
    const worksheet = workbook.addWorksheet(`Project_${projectId}`);

    // Add header row
    const headers = Object.keys(data.data[0] || {});
    worksheet.addRow(headers);
    
    // Add rows
    for(let i = 0; i < data.data.length; i++) {
      worksheet.addRow(Object.values(data.data[i]));
    }

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

// New endpoint for manual S3 upload
app.post('/api/upload-to-s3', async (req, res) => {
  try {
    const result = await exportNewDataToExcel(true);
    
    if (!result) {
      return res.status(200).json({ 
        message: 'No new data to upload',
        uploaded: false 
      });
    }

    const { filePath, rowIds } = result;
    
    await uploadToS3(filePath, "clinical-docs-dev-dev-redcap-exports");
    await markAsUploaded(rowIds);
    fs.unlinkSync(filePath);
    
    res.status(200).json({ 
      message: `Successfully uploaded ${rowIds.length} records to S3`,
      uploaded: true,
      recordCount: rowIds.length
    });
  } catch (err) {
    console.error('Manual S3 upload error:', err);
    res.status(500).json({ 
      error: 'Failed to upload to S3',
      details: err.message 
    });
  }
});

// Endpoint to list generated documents from S3
app.get('/api/generated-documents', async (req, res) => {
  try {
    const bucketName = "clinical-docs-dev-dev-generated-documents";
    const prefix = "generated/";
    
    const command = new ListObjectsV2Command({
      Bucket: bucketName,
      Prefix: prefix,
      MaxKeys: 100
    });

    const response = await s3.send(command);
    
    if (!response.Contents || response.Contents.length === 0) {
      return res.json({ documents: [] });
    }

    // Format the document list
    const documents = response.Contents
      .filter(item => item.Size > 0)
      .map(item => ({
        key: item.Key,
        name: path.basename(item.Key),
        size: item.Size,
        lastModified: item.LastModified,
        sizeFormatted: formatBytes(item.Size)
      }))
      .sort((a, b) => b.lastModified - a.lastModified);

    res.json({ documents });
  } catch (err) {
    console.error('Error listing documents:', err);
    res.status(500).json({ 
      error: 'Failed to fetch documents',
      details: err.message 
    });
  }
});

// Endpoint to generate a presigned URL for document download
app.get('/api/download-document', async (req, res) => {
  try {
    const bucketName = "clinical-docs-dev-dev-generated-documents";
    const key = req.query.key;

    if (!key) {
      return res.status(400).json({ error: 'Document key is required' });
    }

    console.log('Generating download URL for key:', key);

    const command = new GetObjectCommand({
      Bucket: bucketName,
      Key: key
    });

    // Generate presigned URL valid for 1 hour
    const url = await getSignedUrl(s3, command, { expiresIn: 3600 });

    res.json({ url });
  } catch (err) {
    console.error('Error generating download URL:', err);
    res.status(500).json({ 
      error: 'Failed to generate download URL',
      details: err.message 
    });
  }
});

// Helper function to format bytes
function formatBytes(bytes, decimals = 2) {
  if (bytes === 0) return '0 Bytes';
  const k = 1024;
  const dm = decimals < 0 ? 0 : decimals;
  const sizes = ['Bytes', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
}

app.get("/api/fields", (req, res) => {
  res.json(results);  
});

app.get("/api/getRecords", (req, res) => {
  const sql = `SELECT * FROM my_table`;

  db.all(sql, [], (err, rows) => {
    if (err) {
      console.error("Select error:", err.message);
      return res.status(500).json({ error: err.message });
    }

    res.json({ records: rows });
  });
});

// Start server
app.listen(PORT, async () => {
  try {
    await prepareData();
    createTable();
    console.log(`REDCap-style server running on http://localhost:${PORT}`);
  } catch (err) {
    console.error("Error preparing data:", err);
  }
});

// Modified cron job
cron.schedule("0 * * * *", async () => {
  console.log("Running hourly job...");
  try {
    const result = await exportNewDataToExcel(false);
    
    if (result) {
      const { filePath, rowIds } = result;
      const unuploadedIds = await getUnuploadedIds(rowIds);
      
      if (unuploadedIds.length > 0) {
        await uploadToS3(filePath, "clinical-docs-dev-dev-redcap-exports");
        await markAsUploaded(unuploadedIds);
        console.log(`Hourly job uploaded ${unuploadedIds.length} new records`);
      } else {
        console.log("All records in the last hour were already uploaded");
      }
      
      fs.unlinkSync(filePath);
    } else {
      console.log("No new data in the last hour.");
    }
  } catch (err) {
    console.error("Cron job failed:", err);
  }
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