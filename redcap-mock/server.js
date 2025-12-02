const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const ExcelJS = require('exceljs');
const path = require('path');
const fs = require('fs');
const multer = require('multer');
const zlib = require('zlib');
const { S3Client, PutObjectCommand, ListObjectsV2Command, GetObjectCommand } = require("@aws-sdk/client-s3");
const { getSignedUrl } = require("@aws-sdk/s3-request-presigner");
const cron = require("node-cron");

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.static('public'));
app.use(express.json({ limit: '50mb' })); // Parse JSON bodies
app.use(express.urlencoded({ extended: true, limit: '50mb' })); // Parse URL-encoded bodies

// Configure multer for file uploads
const upload = multer({ dest: 'uploads/' });
const s3 = new S3Client({ region: "ap-southeast-2" });

// Initialize SQLite database and schema
let results = [];
let fields = [];
let formSchema = null;
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

// Load structured JSON schema
const prepareData = () => {
  results.length = 0;
  fields.length = 0;
  
  return new Promise((resolve, reject) => {
    const schemaPath = path.join(__dirname, "structured_form_fields.json");
    
    if (!fs.existsSync(schemaPath)) {
      console.error("❌ structured_form_fields.json not found!");
      console.error("   Please copy structured_form_fields.json to the root directory.");
      return reject(new Error("Schema file not found"));
    }

    try {
      const schemaData = fs.readFileSync(schemaPath, 'utf-8');
      formSchema = JSON.parse(schemaData);
      
      console.log('✅ Loaded form schema:');
      console.log(`   Total fields: ${formSchema.metadata.total_fields}`);
      console.log(`   Categories: ${Object.keys(formSchema.categories).join(', ')}`);
      
      // Extract all fields from all categories
      Object.keys(formSchema.categories).forEach(categoryKey => {
        const category = formSchema.categories[categoryKey];
        
        if (category.fields && Array.isArray(category.fields)) {
          category.fields.forEach(field => {
            const fieldData = {
              name: field.field_id,
              label: field.label,
              type: field.field_type,
              note: field.note || null,
              category: categoryKey,
              section: field.section || null
            };
            
            if (field.options && Array.isArray(field.options)) {
              fieldData.choices = field.options.map(opt => `${opt.value}, ${opt.label}`);
            }
            
            if (field.validation) {
              fieldData.validation = field.validation;
            }
            
            results.push(fieldData);
            fields.push(field.field_id);
          });
        }
      });
      
      console.log(`✅ Extracted ${fields.length} fields from schema`);
      resolve();
      
    } catch (err) {
      console.error("❌ Error loading schema:", err.message);
      reject(err);
    }
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

        // Flatten JSON data for Excel export
        const flattenedRows = rows.map(row => {
          const flattened = {
            id: row.id,
            created_at: row.created_at,
            uploaded_to_s3: row.uploaded_to_s3
          };
          
          // Parse and flatten the form_data JSON
          if (row.form_data) {
            try {
              const formData = JSON.parse(row.form_data);
              Object.assign(flattened, formData);
            } catch (e) {
              console.error('Error parsing form_data:', e);
            }
          } else {
            // Handle old format - extract all non-system columns
            Object.keys(row).forEach(key => {
              if (!['id', 'created_at', 'uploaded_to_s3'].includes(key)) {
                flattened[key] = row[key];
              }
            });
          }
          
          return flattened;
        });

        if (flattenedRows.length > 0) {
          // Add headers
          worksheet.addRow(Object.keys(flattenedRows[0]));

          // Add rows
          flattenedRows.forEach(row => worksheet.addRow(Object.values(row)));
        }

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

// Migrate old table to new JSON-based structure
const migrateTableToJSON = () => {
  return new Promise((resolve, reject) => {
    console.log("🔄 Starting table migration to JSON format...");
    
    // Step 1: Rename old table
    db.run("ALTER TABLE my_table RENAME TO my_table_old", (err) => {
      if (err) {
        console.error("❌ Error renaming old table:", err.message);
        return reject(err);
      }
      
      console.log("✅ Old table renamed to my_table_old");
      
      // Step 2: Create new table with JSON structure
      const createSQL = `CREATE TABLE my_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        uploaded_to_s3 INTEGER DEFAULT 0,
        form_data TEXT
      )`;
      
      db.run(createSQL, (err) => {
        if (err) {
          console.error("❌ Error creating new table:", err.message);
          return reject(err);
        }
        
        console.log("✅ New table created with JSON structure");
        
        // Step 3: Migrate data from old table to new table
        db.all("SELECT * FROM my_table_old", [], (err, rows) => {
          if (err) {
            console.error("❌ Error reading old table:", err.message);
            return reject(err);
          }
          
          if (rows.length === 0) {
            console.log("ℹ️  No data to migrate");
            
            // Drop old table
            db.run("DROP TABLE my_table_old", (err) => {
              if (err) console.error("⚠️  Could not drop old table:", err.message);
              else console.log("✅ Old table dropped");
            });
            
            return resolve();
          }
          
          console.log(`🔄 Migrating ${rows.length} records...`);
          
          let migrated = 0;
          let errors = 0;
          
          rows.forEach((row, index) => {
            const formData = {};
            
            // Extract all columns except system columns
            Object.keys(row).forEach(key => {
              if (!['id', 'created_at', 'uploaded_to_s3'].includes(key)) {
                formData[key] = row[key];
              }
            });
            
            const jsonData = JSON.stringify(formData);
            
            db.run(
              `INSERT INTO my_table (id, created_at, uploaded_to_s3, form_data) 
               VALUES (?, ?, ?, ?)`,
              [row.id, row.created_at, row.uploaded_to_s3 || 0, jsonData],
              (err) => {
                if (err) {
                  console.error(`❌ Error migrating row ${row.id}:`, err.message);
                  errors++;
                } else {
                  migrated++;
                }
                
                // Check if all rows processed
                if (migrated + errors === rows.length) {
                  console.log(`✅ Migration complete: ${migrated} records migrated, ${errors} errors`);
                  
                  // Drop old table
                  db.run("DROP TABLE my_table_old", (err) => {
                    if (err) {
                      console.error("⚠️  Could not drop old table:", err.message);
                    } else {
                      console.log("✅ Old table dropped");
                    }
                    resolve();
                  });
                }
              }
            );
          });
        });
      });
    });
  });
};

// Create or migrate table
const createTable = () => {
  return new Promise((resolve, reject) => {
    // Check if table exists and its structure
    db.all("PRAGMA table_info(my_table)", [], (err, rows) => {
      if (err) {
        console.error("❌ Error checking table:", err.message);
        return reject(err);
      }
      
      // If table doesn't exist, create it
      if (rows.length === 0) {
        const sql = `CREATE TABLE my_table (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          uploaded_to_s3 INTEGER DEFAULT 0,
          form_data TEXT
        )`;
        
        db.run(sql, (err) => {
          if (err) {
            console.error("❌ Error creating table:", err.message);
            return reject(err);
          }
          console.log("✅ New table created with JSON storage");
          resolve();
        });
        return;
      }
      
      // Check if form_data column exists
      const hasFormDataColumn = rows.some(row => row.name === 'form_data');
      
      if (hasFormDataColumn) {
        console.log("✅ Table already using JSON format");
        
        // Ensure uploaded_to_s3 column exists
        const hasUploadedColumn = rows.some(row => row.name === 'uploaded_to_s3');
        if (!hasUploadedColumn) {
          db.run("ALTER TABLE my_table ADD COLUMN uploaded_to_s3 INTEGER DEFAULT 0", (err) => {
            if (err) {
              console.error("❌ Error adding uploaded_to_s3:", err.message);
            } else {
              console.log("✅ Added uploaded_to_s3 column");
            }
            resolve();
          });
        } else {
          resolve();
        }
      } else {
        // Old table format detected - need to migrate
        console.log("⚠️  Old table format detected (columnar storage)");
        console.log(`   Current columns: ${rows.length}`);
        
        if (rows.length > 100) {
          console.log("🔄 Migrating to JSON format to avoid column limits...");
          migrateTableToJSON()
            .then(() => resolve())
            .catch((err) => reject(err));
        } else {
          console.log("ℹ️  Column count is manageable, but migration recommended");
          resolve();
        }
      }
    });
  });
};

const insertData = (data) => {
  const jsonData = JSON.stringify(data);
  const sql = `INSERT INTO my_table (form_data) VALUES (?)`;

  db.run(sql, [jsonData], function(err) {
    if (err) return console.error("❌ Insert error:", err.message);
    console.log(`✅ Row inserted with ID: ${this.lastID}`);
  });
};

// Middleware to handle gzip compressed requests (must be AFTER express.json())
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
        req.body = JSON.parse(decompressed);
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

// Endpoint to get full form schema
app.get('/api/form-schema', (req, res) => {
  if (!formSchema) {
    return res.status(500).json({ error: 'Form schema not loaded' });
  }
  res.json(formSchema);
});

// Endpoint to get fields (flat array for backward compatibility)
app.get("/api/fields", (req, res) => {
  res.json(results);  
});

// Add data entry endpoint
app.post('/api/addDataEntry', async(req, res) => {
  try {
    const { projectId, data } = req.body;
    
    if (!data) {
      return res.status(400).json({ error: 'No data provided' });
    }
    
    // Handle both nested and flat data structures
    let sqlInsertData = {};
    
    if (typeof data === 'object' && !Array.isArray(data)) {
      if (data.data) {
        sqlInsertData = data.data;
      } else {
        sqlInsertData = data;
      }
    }
    
    insertData(sqlInsertData);
    res.status(200).json({ success: true, message: "Data added successfully" });
  } catch(err) {
    console.error("❌ Error adding data:", err);
    res.status(500).json({ error: "There was error while adding data" });
  }
});

// Get all records
app.get("/api/getRecords", (req, res) => {
  const sql = `SELECT * FROM my_table ORDER BY created_at DESC`;

  db.all(sql, [], (err, rows) => {
    if (err) {
      console.error("❌ Select error:", err.message);
      return res.status(500).json({ error: err.message });
    }

    // Parse form_data JSON for each row
    const parsedRows = rows.map(row => {
      const parsed = {
        id: row.id,
        created_at: row.created_at,
        uploaded_to_s3: row.uploaded_to_s3
      };
      
      if (row.form_data) {
        try {
          const formData = JSON.parse(row.form_data);
          Object.assign(parsed, formData);
        } catch (e) {
          console.error('Error parsing form_data for row', row.id, ':', e);
        }
      } else {
        // Handle old format if migration hasn't happened yet
        Object.keys(row).forEach(key => {
          if (!['id', 'created_at', 'uploaded_to_s3', 'form_data'].includes(key)) {
            parsed[key] = row[key];
          }
        });
      }
      
      return parsed;
    });

    res.json({ records: parsedRows });
  });
});

// Download Excel endpoint - FIXED VERSION
app.post('/api/download-excel', async (req, res) => {
  try {
    console.log('📥 Download Excel request received');
    console.log('Request body keys:', Object.keys(req.body));
    console.log('projectId:', req.body.projectId);
    console.log('data type:', Array.isArray(req.body.data) ? 'array' : typeof req.body.data);
    console.log('data length:', req.body.data?.length);
    
    if (!req.body || !req.body.data) {
      console.error('❌ No data in request body');
      return res.status(400).json({ 
        error: 'No data provided',
        received: req.body 
      });
    }
    
    const projectId = req.body.projectId || 1;
    const recordsArray = req.body.data;
    
    if (!Array.isArray(recordsArray)) {
      console.error('❌ Data is not an array:', typeof recordsArray);
      return res.status(400).json({ 
        error: 'Invalid data format. Expected an array.',
        received: typeof recordsArray 
      });
    }
    
    if (recordsArray.length === 0) {
      console.log('ℹ️  Empty array, no data to export');
      return res.status(400).json({ error: 'No records to export' });
    }

    console.log(`📊 Exporting ${recordsArray.length} records to Excel for project ${projectId}`);

    const workbook = new ExcelJS.Workbook();
    const worksheet = workbook.addWorksheet(`Project_${projectId}`);

    // Add header row
    const headers = Object.keys(recordsArray[0] || {});
    console.log(`📋 Headers (${headers.length}):`, headers.slice(0, 10).join(', '), headers.length > 10 ? '...' : '');
    worksheet.addRow(headers);
    
    // Style header row
    worksheet.getRow(1).font = { bold: true };
    worksheet.getRow(1).fill = {
      type: 'pattern',
      pattern: 'solid',
      fgColor: { argb: 'FF667eea' }
    };
    
    // Add data rows
    for(let i = 0; i < recordsArray.length; i++) {
      const rowData = headers.map(header => {
        const value = recordsArray[i][header];
        // Handle arrays and objects
        if (Array.isArray(value)) {
          return value.join(', ');
        }
        if (typeof value === 'object' && value !== null) {
          return JSON.stringify(value);
        }
        return value;
      });
      worksheet.addRow(rowData);
    }
    
    // Auto-fit columns
    worksheet.columns.forEach(column => {
      column.width = 15;
    });

    // Generate buffer
    const buffer = await workbook.xlsx.writeBuffer();
    console.log(`📦 Excel buffer size: ${(buffer.length / 1024).toFixed(2)} KB`);

    // Set headers for download
    res.setHeader(
      'Content-Disposition',
      `attachment; filename=clinical_data_${Date.now()}.xlsx`
    );
    res.setHeader(
      'Content-Type',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    );

    // Send file
    console.log(`✅ Excel file generated successfully (${recordsArray.length} records, ${headers.length} columns)`);
    res.send(buffer);
  } catch (err) {
    console.error('❌ Excel export error:', err);
    console.error('Stack trace:', err.stack);
    res.status(500).json({ 
      error: 'Failed to export Excel',
      details: err.message 
    });
  }
});

// Manual S3 upload endpoint
app.post('/api/upload-to-s3', async (req, res) => {
  try {
    const result = await exportNewDataToExcel(true);
    
    if (!result) {
      return res.status(200).json({ 
        message: 'No new data to upload',
        uploaded: false,
        recordCount: 0
      });
    }

    const { filePath, rowIds } = result;
    
    await uploadToS3(filePath, "clinical-docs-dev-dev-redcap-exports");
    await markAsUploaded(rowIds);
    fs.unlinkSync(filePath);
    
    console.log(`✅ Manually uploaded ${rowIds.length} records to S3`);
    
    res.status(200).json({ 
      message: `Successfully uploaded ${rowIds.length} records to S3`,
      uploaded: true,
      recordCount: rowIds.length
    });
  } catch (err) {
    console.error('❌ Manual S3 upload error:', err);
    res.status(500).json({ 
      error: 'Failed to upload to S3',
      details: err.message 
    });
  }
});

// List generated documents from S3
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
    console.error('❌ Error listing documents:', err);
    res.status(500).json({ 
      error: 'Failed to fetch documents',
      details: err.message 
    });
  }
});

// Generate presigned URL for document download
app.get('/api/download-document', async (req, res) => {
  try {
    const bucketName = "clinical-docs-dev-dev-generated-documents";
    const key = req.query.key;

    if (!key) {
      return res.status(400).json({ error: 'Document key is required' });
    }

    console.log('📥 Generating download URL for:', key);

    const command = new GetObjectCommand({
      Bucket: bucketName,
      Key: key
    });

    const url = await getSignedUrl(s3, command, { expiresIn: 3600 });

    res.json({ url });
  } catch (err) {
    console.error('❌ Error generating download URL:', err);
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

// Start server
app.listen(PORT, async () => {
  console.log('='.repeat(70));
  console.log('🏥 Clinical Documentation System - Server Starting');
  console.log('='.repeat(70));
  
  try {
    await prepareData();
    await createTable();
    
    console.log(`✅ Server running at: http://localhost:${PORT}`);
    console.log(`📊 Total fields loaded: ${fields.length}`);
    console.log(`📂 Categories available: ${formSchema ? Object.keys(formSchema.categories).join(', ') : 'N/A'}`);
    console.log(`💾 Storage: JSON format (no column limit)`);
    console.log(`⏰ Hourly S3 upload: Enabled (cron: 0 * * * *)`);
    console.log('='.repeat(70));
  } catch (err) {
    console.error("❌ Error starting server:", err);
    process.exit(1);
  }
});

// Modified cron job for hourly S3 uploads
cron.schedule("0 * * * *", async () => {
  console.log("\n" + "=".repeat(70));
  console.log("⏰ Running hourly automated S3 upload job...");
  console.log("=".repeat(70));
  
  try {
    const result = await exportNewDataToExcel(false);
    
    if (result) {
      const { filePath, rowIds } = result;
      const unuploadedIds = await getUnuploadedIds(rowIds);
      
      if (unuploadedIds.length > 0) {
        await uploadToS3(filePath, "clinical-docs-dev-dev-redcap-exports");
        await markAsUploaded(unuploadedIds);
        console.log(`✅ Hourly job uploaded ${unuploadedIds.length} new records to S3`);
      } else {
        console.log("ℹ️  All records in the last hour were already uploaded");
      }
      
      fs.unlinkSync(filePath);
    } else {
      console.log("ℹ️  No new data in the last hour.");
    }
  } catch (err) {
    console.error("❌ Cron job failed:", err);
  }
  
  console.log("=".repeat(70) + "\n");
});

// Graceful shutdown
process.on('SIGINT', () => {
  console.log('\n🛑 Shutting down server gracefully...');
  db.close((err) => {
    if (err) {
      console.error('❌ Error closing database:', err.message);
    } else {
      console.log('✅ Database connection closed.');
    }
    console.log('👋 Server stopped.');
    process.exit(0);
  });
});

process.on('SIGTERM', () => {
  console.log('\n🛑 SIGTERM received, shutting down...');
  db.close((err) => {
    if (err) {
      console.error('❌ Error closing database:', err.message);
    }
    process.exit(0);
  });
});