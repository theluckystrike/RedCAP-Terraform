let currentFields = [];
let currentRecords = [];
let isFormLoaded = false; // Prevent multiple loads
let isLoadingFields = false; // Prevent concurrent loads

// Initialize
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
    alertContainer.innerHTML = `<div class="alert alert-${type}">${message}</div>`;
    setTimeout(() => {
        alertContainer.innerHTML = '';
    }, 5000);
}

async function loadFields() {
    if (isLoadingFields || isFormLoaded) {
        console.log('Fields already loading or loaded, skipping...');
        return;
    }
    
    isLoadingFields = true;
    
    try {
        const response = await fetch('/api/fields/1');
        const fields = await response.json();
        console.log('Loaded fields:', fields); // Debug log
        
        // Check for duplicates
        const uniqueFields = [];
        const seenFieldNames = new Set();
        
        fields.forEach(field => {
            if (!seenFieldNames.has(field.field_name)) {
                seenFieldNames.add(field.field_name);
                uniqueFields.push(field);
            }
        });
        
        console.log('Unique fields after deduplication:', uniqueFields); // Debug log
        
        currentFields = uniqueFields;
        renderForm(uniqueFields);
        isFormLoaded = true;
    } catch (error) {
        console.error('Error loading fields:', error);
        showAlert('Error loading form fields', 'error');
    } finally {
        isLoadingFields = false;
    }
}

function renderForm(fields) {
    const container = document.getElementById('form-fields');
    
    // Double-check that container exists and clear it completely
    if (!container) {
        console.error('Form fields container not found!');
        return;
    }
    
    // Clear any existing content
    container.innerHTML = '';
    
    console.log('Rendering form with fields:', fields); // Debug log
    console.log('Container cleared, starting fresh render...'); // Debug log

    if (!fields || fields.length === 0) {
        console.log('No fields to render');
        return;
    }

    fields.forEach((field, index) => {
        console.log(`Rendering field ${index + 1}:`, field.field_name, field.field_label); // Debug log
        
        const div = document.createElement('div');
        div.className = 'form-group';
        div.setAttribute('data-field', field.field_name); // Add identifier
        
        let inputHTML = '';
        const required = field.required ? 'required' : '';
        
        switch(field.field_type) {
            case 'text':
                inputHTML = `<input type="text" id="${field.field_name}" name="${field.field_name}" ${required} />`;
                break;
            case 'number':
                inputHTML = `<input type="number" id="${field.field_name}" name="${field.field_name}" ${required} />`;
                break;
            case 'date':
                inputHTML = `<input type="date" id="${field.field_name}" name="${field.field_name}" ${required} />`;
                break;
            case 'radio':
                const options = field.options ? field.options.split(',') : [];
                inputHTML = '<div class="radio-group">';
                options.forEach((option, index) => {
                    // Only add required attribute to the first radio button in the group
                    const radioRequired = (required && index === 0) ? 'required' : '';
                    inputHTML += `
                        <label>
                            <input type="radio" name="${field.field_name}" value="${option.trim()}" ${radioRequired} />
                            ${option.trim()}
                        </label>
                    `;
                });
                inputHTML += '</div>';
                break;
            case 'textarea':
                inputHTML = `<textarea id="${field.field_name}" name="${field.field_name}" rows="4" ${required}></textarea>`;
                break;
        }
        
        div.innerHTML = `
            <label for="${field.field_name}">${field.field_label}${field.required ? ' *' : ''}</label>
            ${inputHTML}
        `;
        
        container.appendChild(div);
    });
    
    console.log('Form rendered with', fields.length, 'fields'); // Debug log
    console.log('Form container children count:', container.children.length); // Debug log
}

document.getElementById('dataForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    
    const formData = new FormData(e.target);
    const data = {};
    
    for (let [key, value] of formData.entries()) {
        data[key] = value;
    }

    console.log(data);
    
    try {
        const response = await fetch('/api/download-excel', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json',"content-encoding":"gzip" },
            body: pako.gzip(JSON.stringify({ projectId: 1, data: data }))
        });
        
        if (response.ok) {
            const blob = await response.blob();
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'patient_data.xlsx';
            a.click();
            window.URL.revokeObjectURL(url);
            showAlert('Excel file downloaded successfully!');
        }
        else {
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
        `<th>${currentFields.find(f => f.field_name === name)?.field_label || name}</th>`
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
               fieldNames.map(fieldName => `<td>${record[fieldName] || ''}</td>`).join('') + 
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
            showAlert(`Import successful! ${result.imported} records imported.`);
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

async function buildForm() {
  const formFieldsDiv = document.getElementById("form-fields");
  formFieldsDiv.innerHTML = "";

  const res = await fetch("/api/fields");
  const fields = await res.json();

  fields.forEach(field => {
    let index = 1;
    const wrapper = document.createElement("div");
    wrapper.classList.add("form-group");
    // normalize field properties
    const fieldLabel = field.label;
    const label = document.createElement("label");
    label.setAttribute("for", fieldLabel);
    label.textContent = fieldLabel;
    field.name = fieldLabel

    let input = {};
    let dummyValue = ""; // decide below
    input.id = fieldLabel;
    input.name = fieldLabel;
    // ✅ Generate dummy values that pass checks
    switch (field.type) {
      case "number":
        // pick a number within range if defined
        if (field.min && field.max) {
          dummyValue = Math.floor((+field.min + +field.max) / 2); 
        } else {
          dummyValue = 123;
        }
        break;

      case "date":
        // use today's date if no default
        dummyValue = field.default || new Date().toISOString().slice(0, 10);
        break;

      case "email":
        dummyValue = field.default || "test@example.com";
        break;

      case "text":
        // if regex/validation rule exists, make a safe placeholder
        if (field.validation === "phone") {
          dummyValue = "123-456-7890";
        } else if (field.validation === "zip") {
          dummyValue = "12345";
        } else {
          dummyValue = field.default || `dummy_${field.name}`;
        }
        break;

      case "textarea":
        dummyValue = field.default || `Sample text for ${field.label}`;
        break;

      case "select":
      case "radio":
        // handled below (first choice by default)
        break;

      default:
        dummyValue = field.default || `dummy_${field.name}`;
    }

    switch (field.type) {
      case "date":
      case "email":
      case "number":
      case "text":
        input = document.createElement("input");
        input.type = field.type;
        input.id = field.name;
        input.name = field.name;
        input.classList.add("form-control");
        if (dummyValue) input.value = dummyValue;
        break;

      case "textarea":
        input = document.createElement("textarea");
        input.id = field.name;
        input.name = field.name;
        input.classList.add("form-control");
        input.value = dummyValue;
        break;

      case "select":
        input = document.createElement("select");
        input.id = field.name;
        input.name = field.name;
        input.classList.add("form-control");
        field.choices.forEach((choice, idx) => {
          const opt = document.createElement("option");
          const [val, text] = choice.split(",");
          opt.value = val.trim();
          opt.textContent = text ? text.trim() : val;
          if (idx === 0) opt.selected = true; // default first choice
          input.appendChild(opt);
        });
        break;

      case "radio":
        input = document.createElement("div");
        field.choices.forEach((choice, idx) => {
          const [val, text] = choice.split(",");
          const radioWrapper = document.createElement("div");
          radioWrapper.classList.add("radio-option");

          const radio = document.createElement("input");
          radio.type = "radio";
          radio.name = field.name;
          radio.value = val.trim();
          if (idx === 0) radio.checked = true; // default first radio

          const radioLabel = document.createElement("label");
          radioLabel.textContent = text ? text.trim() : val;

          radioWrapper.appendChild(radio);
          radioWrapper.appendChild(radioLabel);
          input.appendChild(radioWrapper);
        });
        break;

      default:
        input = document.createElement("input");
        input.type = "text";
        input.id = field.name;
        input.name = field.name;
        input.classList.add("form-control");
        input.value = dummyValue;
    }

    wrapper.appendChild(label);
    wrapper.appendChild(input);

    formFieldsDiv.appendChild(wrapper);
    index++;
  });
}

// Initialize
window.onload = () => {
  buildForm();
};