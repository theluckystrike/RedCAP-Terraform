const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const ExcelJS = require('exceljs');
const path = require('path');
const fs = require('fs');
const multer = require('multer');
const csv = require("csv-parser");
const zlib = require('zlib');
const { S3Client, PutObjectCommand } = require("@aws-sdk/client-s3");

const app = express();
const PORT = process.env.PORT || 3000;
const cron = require("node-cron");

// Middleware
app.use(express.static('public'));

// Configure multer for file uploads
const upload = multer({ dest: 'uploads/' });
const s3 = new S3Client({ region: "ap-southeast-2" });
// Initialize SQLite database


// Create tables
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
  seen = new Set()
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
          seen.add(label)

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

const exportNewDataToExcel = async () => {
  return new Promise((resolve, reject) => {
    const sql = `
      SELECT * FROM my_table 
      WHERE created_at >= datetime('now', '-1 hour')
    `;
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

        resolve(filePath);
      } catch (e) {
        reject(e);
      }
    });
  });
};


const createTable = () => {
  const columns = fields.map(f => `"${f.replace(/"/g, '""')}" TEXT`).join(", ");
  const sql = `CREATE TABLE IF NOT EXISTS my_table (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ${columns ? ", " + columns : ""}
  )`;
  db.run(sql, (err) => {
    if (err) console.error("Error creating table:", err.message);
    else console.log("Table created successfully.");
  });
};

const insertData = (data) => {
  const cols = fields.map(f => `"${f.replace(/"/g, '""')}"`).join(", ");
  const placeholders = fields.map(() => "?").join(", ");
  const sql = `INSERT INTO my_table (${cols}) VALUES (${placeholders})`;
  const values = fields.map(f => data[f] || null); // map fields to data object

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

app.post('/api/addDataEntry',async(req,res)=>{
  const { projectId, data } = req.body;
  let sqlInsertData = {};
   Object.values(data).forEach(record =>{
        Object.entries(record).forEach(([key, value]) => {
          sqlInsertData[key] = value;
        })
    });
    try{
      insertData(sqlInsertData)
      res.status(200).json("data added successfully");
    }catch(err){
      res.status(500).json("There was error while adding data");
    }
    
})


app.post('/api/download-excel', async (req, res) => {
  try {
    const {projectId,data} = req.body
    if (!data || Object.keys(data).length === 0) {
      return res.status(400).json({ error: 'No data provided' });
    }

    const workbook = new ExcelJS.Workbook();
    const worksheet = workbook.addWorksheet(`Project_${projectId}`);

    // Add header row
    const headers = Object.keys(data.data[0] || {});
    worksheet.addRow(headers);
    
    // Add rows
    for(let i=0;i<data.data.length;i++){
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

app.get("/api/fields", (req, res) => {
  res.json(results);  
});

app.get("/api/getRecords",(req,res)=>{
  const sql = `SELECT * FROM my_table`;

  db.all(sql, [], (err, rows) => {
    if (err) {
      console.error("Select error:", err.message);
      return res.status(500).json({ error: err.message });
    }

    res.json({ records: rows });
  });
})

// Start server
app.listen(PORT, async () => {
  try {
    await prepareData();  // wait until CSV is fully read
    createTable();        // now fields array is populated
    console.log(`REDCap-style server running on http://localhost:${PORT}`);
  } catch (err) {
    console.error("Error preparing data:", err);
  }
});

cron.schedule("0 * * * *", async () => {
  console.log("Running hourly job...");
  try {
    const filePath = await exportNewDataToExcel();
    if (filePath) {
      await uploadToS3(filePath, "clinical-docs-dev-dev-redcap-exports");
      fs.unlinkSync(filePath); // clean up local file
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