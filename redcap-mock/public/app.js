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

async function exportToExcel(){
    try{
        const response = await fetch('/api/getRecords');
        const data = await response.json();
        const res = await fetch('/api/download-excel',{
            method: 'POST',
            headers: { 'Content-Type': 'application/json',"content-encoding":"gzip" },
            body: pako.gzip(JSON.stringify({projectId:1,data: data.records }))
        });
        if (res.ok) {
            const blob = await res.blob();
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'patient_data.xlsx';
            a.click();
            window.URL.revokeObjectURL(url);
            showAlert('Data Downloaded Successfully');
        }
        else {
            throw new Error('Failed to download records');
        }
    } catch (error) {
        console.error('Error downloading record:', error);
        showAlert('Error downloading record', 'error');
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
        const response = await fetch('/api/fields');
        const fields = await response.json();
        console.log('Loaded fields:', fields); // Debug log
        
        // Check for duplicates
        const uniqueFields = [];
        
        fields.forEach(field => {
            uniqueFields.push(field);
        });
        
        console.log('Unique fields after deduplication:', uniqueFields); // Debug log
        
        currentFields = uniqueFields;
        isFormLoaded = true;
    } catch (error) {
        console.error('Error loading fields:', error);
        showAlert('Error loading form fields', 'error');
    } finally {
        isLoadingFields = false;
    }
}

function scrollToTop(duration = 800) {
    const start = window.scrollY;
    const startTime = performance.now();

    function scrollStep(currentTime) {
        const elapsed = currentTime - startTime;
        const progress = Math.min(elapsed / duration, 1); // 0 → 1
        const ease = 1 - Math.pow(1 - progress, 3); // easing (cubic)

        window.scrollTo(0, start * (1 - ease));

        if (progress < 1) {
            requestAnimationFrame(scrollStep);
        }
    }

    requestAnimationFrame(scrollStep);
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
        const response = await fetch('/api/addDataEntry', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json',"content-encoding":"gzip" },
            body: pako.gzip(JSON.stringify({ projectId: 1, data: data }))
        });
        
        if (response.ok) {
            // const blob = await response.blob();
            // const url = window.URL.createObjectURL(blob);
            // const a = document.createElement('a');
            // a.href = url;
            // a.download = 'patient_data.xlsx';
            // a.click();
            // window.URL.revokeObjectURL(url);

            showAlert('Data Entry added Successfully');
            scrollToTop(800);
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
        const response = await fetch('/api/getRecords');
        const data = await response.json();
        console.log(data.records)
        renderRecordsTable(data.records);
    } catch (error) {
        console.error('Error loading records:', error);
        showAlert('Error loading records', 'error');
    }
}

function renderRecordsTable(records) {
    const header = document.getElementById('records-header');
    const body = document.getElementById('records-body');

    if (!records || records.length === 0) {
        header.innerHTML = '<th>No records found</th>';
        body.innerHTML = '';
        return;
    }

    // Use currentFields (from /api/fields) to get proper order + labels
    console.log(currentFields)
    const fieldNames = currentFields.map(f => f.label);

    // Create header
    header.innerHTML = '<th>Record ID</th>' + fieldNames.map(name =>
        `<th>${currentFields.find(f => f.label === name)?.label || name}</th>`
    ).join('');

    // Create rows
    let html = ``;

    records.forEach(record => {
    html += '<tr><td>' + record.id + '</td>' +
        fieldNames.map(fn => `<td>${record[fn] || ''}</td>`).join('') +
        '</tr>';
    });

    console.log(html);
    body.innerHTML = html;
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
          dummyValue = field.default || `${field.name}`;
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
        dummyValue = field.default || `${field.name}`;
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
  loadFields();
};