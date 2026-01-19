let currentFields = [];
let currentRecords = [];
let isFormLoaded = false;
let isLoadingFields = false;
let formSchema = null;
let activeCategory = 'general';
let columnMappingData = null;

// Virtualization state
let visibilityObserver = null;
let renderedSections = new Set();
let sectionFieldsData = new Map();

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
    } else if (sectionId === 'documents') {
        loadGeneratedDocuments();
    }
}

function showCategory(categoryKey) {
    activeCategory = categoryKey;
    
    // Update tab buttons
    document.querySelectorAll('.category-tab').forEach(tab => {
        tab.classList.remove('active');
    });
    document.getElementById(`tab-${categoryKey}`).classList.add('active');
    
    // Update category panels
    document.querySelectorAll('.category-panel').forEach(panel => {
        panel.classList.remove('active');
    });
    document.getElementById(`panel-${categoryKey}`).classList.add('active');
    
    // Initialize visibility observer for new category
    initializeVisibilityObserver(categoryKey);
}

function toggleSection(sectionId) {
    const header = document.getElementById(`section-header-${sectionId}`);
    const content = document.getElementById(`section-content-${sectionId}`);
    
    header.classList.toggle('collapsed');
    
    if (content.classList.contains('expanded')) {
        content.classList.remove('expanded');
    } else {
        content.classList.add('expanded');
        // Render content if expanding for the first time
        renderSectionContent(sectionId);
    }
}

function expandAllSections(categoryKey) {
    const panel = document.getElementById(`panel-${categoryKey}`);
    const headers = panel.querySelectorAll('.section-header-small');
    const contents = panel.querySelectorAll('.form-fields-grid');
    
    headers.forEach(header => header.classList.remove('collapsed'));
    
    // Expand but don't render yet - let virtualization handle it
    contents.forEach((content) => {
        content.classList.add('expanded');
    });
}

function collapseAllSections(categoryKey) {
    const panel = document.getElementById(`panel-${categoryKey}`);
    const headers = panel.querySelectorAll('.section-header-small');
    const contents = panel.querySelectorAll('.form-fields-grid');
    
    headers.forEach(header => header.classList.add('collapsed'));
    contents.forEach(content => content.classList.remove('expanded'));
}

// Initialize Intersection Observer for lazy rendering
function initializeVisibilityObserver(categoryKey) {
    // Disconnect existing observer
    if (visibilityObserver) {
        visibilityObserver.disconnect();
    }
    
    const options = {
        root: null,
        rootMargin: '500px', // Load well in advance
        threshold: [0, 0.1]
    };
    
    visibilityObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const sectionId = entry.target.dataset.sectionId;
                
                // Only render if section is expanded and not already rendered
                const content = document.getElementById(`section-content-${sectionId}`);
                if (content && content.classList.contains('expanded')) {
                    renderSectionContent(sectionId);
                }
            }
        });
    }, options);
    
    // Observe all section containers in the active category
    const panel = document.getElementById(`panel-${categoryKey}`);
    if (panel) {
        const sections = panel.querySelectorAll('.form-section');
        sections.forEach(section => {
            const sectionId = section.querySelector('.form-fields-grid').id.replace('section-content-', '');
            section.dataset.sectionId = sectionId;
            visibilityObserver.observe(section);
        });
    }
}

// Render section content on demand
function renderSectionContent(sectionId) {
    // Skip if already rendered
    if (renderedSections.has(sectionId)) {
        return;
    }
    
    const content = document.getElementById(`section-content-${sectionId}`);
    if (!content) return;
    
    // Get fields data from Map
    const fields = sectionFieldsData.get(sectionId);
    if (!fields) return;
    
    // Clear placeholder
    content.innerHTML = '';
    
    // Render fields in batches for better performance
    const fragment = document.createDocumentFragment();
    
    fields.forEach(field => {
        const fieldElement = createFieldElement(field);
        fragment.appendChild(fieldElement);
    });
    
    content.appendChild(fragment);
    
    // Mark as rendered
    renderedSections.add(sectionId);
    
    console.log(`✅ Rendered section: ${sectionId} (${fields.length} fields)`);
}

async function exportToExcel() {
    try {
        showAlert('Fetching records...', 'info');
        
        const response = await fetch('/api/getRecords');
        if (!response.ok) {
            throw new Error('Failed to fetch records');
        }
        
        const data = await response.json();
        
        if (!data.records || data.records.length === 0) {
            showAlert('No records to export', 'info');
            return;
        }
        
        console.log('Exporting records:', data.records.length);
        showAlert('Downloading Excel file...', 'info');
        
        const res = await fetch('/api/download-excel', {
            method: 'POST',
            headers: { 
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                projectId: 1, 
                data: data.records
            })
        });
        
        if (res.ok) {
            const blob = await res.blob();
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'patient_data_' + new Date().toISOString().split('T')[0] + '.xlsx';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            window.URL.revokeObjectURL(url);
            showAlert('✅ Data Downloaded Successfully', 'success');
        } else {
            const errorText = await res.text();
            console.error('Server response:', errorText);
            throw new Error('Failed to download records: ' + res.status + ' - ' + errorText);
        }
    } catch (error) {
        console.error('Error downloading record:', error);
        showAlert('❌ Error downloading record: ' + error.message, 'error');
    }
}

async function uploadToS3() {
    try {
        showAlert('Uploading to S3...', 'info');
        
        const response = await fetch('/api/upload-to-s3', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' }
        });
        
        const result = await response.json();
        
        if (response.ok) {
            if (result.uploaded) {
                showAlert(`✅ Successfully uploaded ${result.recordCount} records to S3`, 'success');
            } else {
                showAlert('ℹ️ No new data to upload', 'info');
            }
        } else {
            throw new Error(result.error || 'Failed to upload to S3');
        }
    } catch (error) {
        console.error('Error uploading to S3:', error);
        showAlert('Error uploading to S3: ' + error.message, 'error');
    }
}

async function loadGeneratedDocuments() {
    try {
        showAlert('Loading documents...', 'info');
        
        const response = await fetch('/api/generated-documents');
        const data = await response.json();
        
        if (response.ok) {
            renderDocumentsList(data.documents);
            if (data.documents.length === 0) {
                showAlert('No documents found', 'info');
            } else {
                setTimeout(() => {
                    document.getElementById('alert-container').innerHTML = '';
                }, 1000);
            }
        } else {
            throw new Error(data.error || 'Failed to load documents');
        }
    } catch (error) {
        console.error('Error loading documents:', error);
        showAlert('Error loading documents: ' + error.message, 'error');
    }
}

function renderDocumentsList(documents) {
    const container = document.getElementById('documents-list');
    
    if (!documents || documents.length === 0) {
        container.innerHTML = `
            <div class="empty-state">
                <div class="empty-icon">📄</div>
                <h3>No Documents Yet</h3>
                <p>Documents generated by Carbone will appear here after data is uploaded to S3</p>
            </div>
        `;
        return;
    }

    container.innerHTML = '';
    
    const grid = document.createElement('div');
    grid.className = 'documents-grid';
    
    documents.forEach(doc => {
        const date = new Date(doc.lastModified).toLocaleString();
        const fileExtension = doc.name.split('.').pop().toUpperCase();
        const icon = getFileIcon(fileExtension);
        
        const card = document.createElement('div');
        card.className = 'document-card';
        card.innerHTML = `
            <div class="document-icon">${icon}</div>
            <div class="document-info">
                <h4 class="document-name" title="${doc.name}">${doc.name}</h4>
                <div class="document-meta">
                    <span class="document-size">📊 ${doc.sizeFormatted}</span>
                    <span class="document-date">🕒 ${date}</span>
                </div>
            </div>
            <button class="btn-download" onclick="downloadDocument('${doc.key}')" title="Download ${doc.name}">
                ⬇️ Download
            </button>
        `;
        
        grid.appendChild(card);
    });
    
    container.appendChild(grid);
}

function getFileIcon(extension) {
    const icons = {
        'PDF': '📕',
        'DOCX': '📘',
        'DOC': '📘',
        'XLSX': '📗',
        'XLS': '📗',
        'CSV': '📊',
        'TXT': '📄',
        'PNG': '🖼️',
        'JPG': '🖼️',
        'JPEG': '🖼️'
    };
    return icons[extension] || '📄';
}

async function downloadDocument(key) {
    try {
        showAlert('Preparing download...', 'info');
        
        const encodedKey = encodeURIComponent(key);
        const response = await fetch(`/api/download-document?key=${encodedKey}`);
        const data = await response.json();
        
        if (response.ok && data.url) {
            const a = document.createElement('a');
            a.href = data.url;
            a.target = '_blank';
            const fileName = key.split('/').pop();
            a.download = fileName;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            
            showAlert('Download started', 'success');
        } else {
            throw new Error(data.error || 'Failed to generate download URL');
        }
    } catch (error) {
        console.error('Error downloading document:', error);
        showAlert('Error downloading document: ' + error.message, 'error');
    }
}

function showAlert(message, type = 'success') {
    const alertContainer = document.getElementById('alert-container');
    alertContainer.innerHTML = `<div class="alert alert-${type}">${message}</div>`;
    setTimeout(() => {
        alertContainer.innerHTML = '';
    }, 5000);
}

async function loadColumnMapping() {
    if (columnMappingData) {
        return columnMappingData;
    }
    
    try {
        const response = await fetch('/api/column-mapping');
        const data = await response.json();
        columnMappingData = data;
        console.log('Loaded column mapping:', data);
        return data;
    } catch (error) {
        console.error('Error loading column mapping:', error);
        return null;
    }
}

async function loadFormSchema() {
    if (isLoadingFields || isFormLoaded) {
        console.log('Schema already loading or loaded, skipping...');
        return;
    }
    
    isLoadingFields = true;
    
    try {
        const response = await fetch('/api/form-schema');
        const schema = await response.json();
        
        console.log('Loaded form schema:', schema);
        
        formSchema = schema;
        currentFields = extractFieldsFromSchema(schema);
        isFormLoaded = true;
        
        await loadColumnMapping();
        
        console.log('Extracted fields:', currentFields);
    } catch (error) {
        console.error('Error loading form schema:', error);
        showAlert('Error loading form schema', 'error');
    } finally {
        isLoadingFields = false;
    }
}

function extractFieldsFromSchema(schema) {
    const allFields = [];
    
    if (schema.categories) {
        Object.keys(schema.categories).forEach(categoryKey => {
            const category = schema.categories[categoryKey];
            if (category.fields && Array.isArray(category.fields)) {
                category.fields.forEach(field => {
                    allFields.push({
                        ...field,
                        category: categoryKey,
                        categoryName: category.name
                    });
                });
            }
        });
    }
    
    return allFields;
}

function scrollToTop(duration = 800) {
    const start = window.scrollY;
    const startTime = performance.now();

    function scrollStep(currentTime) {
        const elapsed = currentTime - startTime;
        const progress = Math.min(elapsed / duration, 1);
        const ease = 1 - Math.pow(1 - progress, 3);

        window.scrollTo(0, start * (1 - ease));

        if (progress < 1) {
            requestAnimationFrame(scrollStep);
        }
    }

    requestAnimationFrame(scrollStep);
}

function getFieldMetadata(fieldId) {
    if (!columnMappingData || !columnMappingData.fields) {
        return null;
    }
    
    return columnMappingData.fields.find(f => 
        f.Original_Field_ID.toLowerCase() === fieldId.toLowerCase()
    );
}

function generateSampleValue(fieldId, inputElement) {
    const metadata = getFieldMetadata(fieldId);
    
    if (!metadata) {
        return generateFallbackValue(fieldId, inputElement);
    }
    
    const dataType = metadata.SQL_Data_Type?.toUpperCase() || '';
    const label = metadata.Label || fieldId;
    
    if (dataType.includes('INTEGER') || dataType.includes('NUMERIC') || dataType.includes('DECIMAL')) {
        if (label.toLowerCase().includes('age')) return 45;
        if (label.toLowerCase().includes('height')) return 175;
        if (label.toLowerCase().includes('weight')) return 80;
        if (label.toLowerCase().includes('pressure') || label.toLowerCase().includes('bp')) return 120;
        if (label.toLowerCase().includes('pulse') || label.toLowerCase().includes('heart')) return 72;
        if (label.toLowerCase().includes('temp')) return 98.6;
        if (label.toLowerCase().includes('pain') || label.toLowerCase().includes('score')) return 7;
        if (label.toLowerCase().includes('count')) return 10;
        if (label.toLowerCase().includes('level')) return 5;
        
        return Math.floor(Math.random() * 10) + 1;
    }
    
    if (dataType.includes('DATE') || dataType.includes('TIMESTAMP')) {
        const today = new Date();
        if (label.toLowerCase().includes('birth')) {
            const birthDate = new Date(today.getFullYear() - 45, 5, 15);
            return birthDate.toISOString().split('T')[0];
        }
        return today.toISOString().split('T')[0];
    }
    
    if (dataType.includes('VARCHAR') || dataType.includes('TEXT')) {
        const fieldLower = fieldId.toLowerCase();
        
        if (fieldLower.includes('record') && fieldLower.includes('id')) {
            return 'REC-' + Math.floor(Math.random() * 10000);
        }
        if (fieldLower === 'id' || fieldLower === 'patient_id') {
            return 'PAT-' + Math.floor(Math.random() * 10000);
        }
        if (fieldLower.includes('firstname') || fieldLower.includes('first_name') || fieldLower.includes('given')) {
            return 'John';
        }
        if (fieldLower.includes('lastname') || fieldLower.includes('last_name') || fieldLower.includes('surname')) {
            return 'Doe';
        }
        if (fieldLower.includes('email')) {
            return 'john.doe@example.com';
        }
        if (fieldLower.includes('phone') || fieldLower.includes('mobile') || fieldLower.includes('tel')) {
            return '(555) 123-4567';
        }
        if (fieldLower.includes('address')) {
            return '123 Main Street';
        }
        if (fieldLower.includes('city')) {
            return 'New York';
        }
        if (fieldLower.includes('state')) {
            return 'NY';
        }
        if (fieldLower.includes('zip') || fieldLower.includes('postal')) {
            return '10001';
        }
        
        if (inputElement.tagName === 'TEXTAREA') {
            return generateTextareaSample(label);
        }
        
        return '';
    }
    
    return '';
}

function generateTextareaSample(label) {
    const labelLower = label.toLowerCase();
    
    if (labelLower.includes('complaint') || labelLower.includes('chief')) {
        return 'Patient reports shoulder pain and limited range of motion for approximately 3 weeks. Pain is worse with overhead activities and at night.';
    }
    if (labelLower.includes('history') || labelLower.includes('medical')) {
        return 'Hypertension (controlled with medication), Type 2 Diabetes (diet-controlled), no previous surgeries.';
    }
    if (labelLower.includes('medication')) {
        return 'Metformin 500mg twice daily, Lisinopril 10mg once daily, Multivitamin.';
    }
    if (labelLower.includes('allerg')) {
        return 'Penicillin (rash), Sulfa drugs (hives)';
    }
    if (labelLower.includes('diagnosis')) {
        return 'Rotator cuff tendinitis with mild impingement. No evidence of tear on examination.';
    }
    if (labelLower.includes('treatment') || labelLower.includes('plan')) {
        return 'Physical therapy 3x/week for 6 weeks, NSAIDs as needed for pain, ice 20 minutes 3-4x daily, follow-up in 2 weeks.';
    }
    
    return 'Clinical notes for ' + label + '. Patient is cooperative and understands treatment plan.';
}

function generateFallbackValue(fieldId, inputElement) {
    const fieldLower = fieldId.toLowerCase();
    
    if (inputElement.type === 'number') {
        if (fieldLower.includes('age')) return 45;
        if (fieldLower.includes('pain') || fieldLower.includes('score')) return 7;
        return Math.floor(Math.random() * 10) + 1;
    }
    
    if (inputElement.type === 'date') {
        const today = new Date();
        if (fieldLower.includes('birth')) {
            const birthDate = new Date(today.getFullYear() - 45, 5, 15);
            return birthDate.toISOString().split('T')[0];
        }
        return today.toISOString().split('T')[0];
    }
    
    if (fieldLower.includes('record') && fieldLower.includes('id')) {
        return 'REC-' + Math.floor(Math.random() * 10000);
    }
    if (fieldLower.includes('name')) {
        if (fieldLower.includes('first')) return 'John';
        if (fieldLower.includes('last')) return 'Doe';
        return 'John Doe';
    }
    if (fieldLower.includes('email')) {
        return 'john.doe@example.com';
    }
    if (fieldLower.includes('phone') || fieldLower.includes('mobile')) {
        return '(555) 123-4567';
    }
    
    return '';
}

// Fill sample data AND COLLAPSE sections afterward
async function fillSampleData() {
    if (!columnMappingData) {
        showAlert('Loading field metadata...', 'info');
        await loadColumnMapping();
    }
    
    showAlert('🔄 Filling sample data...', 'info');
    
    // Get all section IDs from current category
    const activePanel = document.querySelector('.category-panel.active');
    if (!activePanel) return;
    
    const allSections = activePanel.querySelectorAll('.form-fields-grid');
    const sectionIds = Array.from(allSections).map(section => 
        section.id.replace('section-content-', '')
    );
    
    let totalFilled = 0;
    
    // Process sections progressively with small delays
    for (let i = 0; i < sectionIds.length; i++) {
        const sectionId = sectionIds[i];
        const header = document.getElementById(`section-header-${sectionId}`);
        const content = document.getElementById(`section-content-${sectionId}`);
        
        if (!header || !content) continue;
        
        // Expand section temporarily
        const wasCollapsed = header.classList.contains('collapsed');
        header.classList.remove('collapsed');
        content.classList.add('expanded');
        
        // Render if not already rendered
        renderSectionContent(sectionId);
        
        // Small delay to allow rendering and prevent blocking
        await new Promise(resolve => setTimeout(resolve, 5));
        
        // Fill fields in this section
        const sectionInputs = content.querySelectorAll('input:not([type="radio"]):not([type="checkbox"]):not([type="submit"]):not([type="button"]), select, textarea');
        
        sectionInputs.forEach(input => {
            const fieldId = input.id || input.name;
            if (!fieldId) return;
            
            if (input.tagName === 'SELECT') {
                if (input.options.length > 1) {
                    input.selectedIndex = 1;
                    totalFilled++;
                }
            } else if (input.tagName === 'TEXTAREA') {
                const value = generateSampleValue(fieldId, input);
                if (value) {
                    input.value = value;
                    totalFilled++;
                }
            } else {
                const value = generateSampleValue(fieldId, input);
                if (value !== '') {
                    input.value = value;
                    totalFilled++;
                }
            }
        });
        
        // Handle radio buttons in this section
        const radioGroups = {};
        const sectionRadios = content.querySelectorAll('input[type="radio"]');
        
        sectionRadios.forEach(radio => {
            const groupName = radio.name;
            if (!radioGroups[groupName]) {
                radioGroups[groupName] = [];
            }
            radioGroups[groupName].push(radio);
        });
        
        Object.keys(radioGroups).forEach(groupName => {
            if (radioGroups[groupName].length > 0) {
                const fieldName = groupName.toLowerCase();
                
                if (fieldName.includes('gender') || fieldName.includes('sex')) {
                    const maleOption = radioGroups[groupName].find(r => 
                        r.value.toLowerCase().includes('male') && !r.value.toLowerCase().includes('female')
                    );
                    if (maleOption) {
                        maleOption.checked = true;
                        totalFilled++;
                        return;
                    }
                }
                
                radioGroups[groupName][0].checked = true;
                totalFilled++;
            }
        });
        
        // Handle checkboxes in this section
        const checkboxGroups = {};
        const sectionCheckboxes = content.querySelectorAll('input[type="checkbox"]');
        
        sectionCheckboxes.forEach(checkbox => {
            const groupName = checkbox.name;
            if (!checkboxGroups[groupName]) {
                checkboxGroups[groupName] = [];
            }
            checkboxGroups[groupName].push(checkbox);
        });
        
        Object.keys(checkboxGroups).forEach(groupName => {
            const checkboxes = checkboxGroups[groupName];
            if (checkboxes.length > 0) {
                checkboxes[0].checked = true;
                totalFilled++;
                if (checkboxes.length > 2) {
                    checkboxes[1].checked = true;
                    totalFilled++;
                }
            }
        });
        
        // COLLAPSE section after filling (keep only first section expanded)
        if (i > 0) {
            header.classList.add('collapsed');
            content.classList.remove('expanded');
        }
        
        // Update progress every few sections
        if (i % 10 === 0 || i === sectionIds.length - 1) {
            const progress = Math.round(((i + 1) / sectionIds.length) * 100);
            showAlert(`📝 Filling data... ${progress}% complete`, 'info');
        }
    }
    
    showAlert(`✅ Sample data loaded! Filled ${totalFilled} fields. Sections collapsed for easier navigation.`, 'success');
    scrollToTop(500);
}

document.getElementById('dataForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    
    showAlert('🔄 Preparing form submission...', 'info');
    
    // Get all section IDs from all categories
    const allPanels = document.querySelectorAll('.category-panel');
    const allSectionIds = [];
    
    allPanels.forEach(panel => {
        const sections = panel.querySelectorAll('.form-fields-grid');
        sections.forEach(section => {
            const sectionId = section.id.replace('section-content-', '');
            allSectionIds.push(sectionId);
        });
    });
    
    // Expand and render all sections progressively
    for (let i = 0; i < allSectionIds.length; i++) {
        const sectionId = allSectionIds[i];
        const header = document.getElementById(`section-header-${sectionId}`);
        const content = document.getElementById(`section-content-${sectionId}`);
        
        if (!header || !content) continue;
        
        // Expand section
        header.classList.remove('collapsed');
        content.classList.add('expanded');
        
        // Render if not already rendered
        renderSectionContent(sectionId);
        
        // Small delay for rendering
        if (i % 20 === 0) {
            await new Promise(resolve => setTimeout(resolve, 10));
        }
    }
    
    // Wait a bit more for final rendering
    await new Promise(resolve => setTimeout(resolve, 100));
    
    const formData = new FormData(e.target);
    const data = {};
    
    for (let [key, value] of formData.entries()) {
        if (data[key]) {
            if (!Array.isArray(data[key])) {
                data[key] = [data[key]];
            }
            data[key].push(value);
        } else {
            data[key] = value;
        }
    }

    console.log('Submitting data:', data);
    
    try {
        const response = await fetch('/api/addDataEntry', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', "content-encoding": "gzip" },
            body: pako.gzip(JSON.stringify({ projectId: 1, data: data }))
        });
        
        if (response.ok) {
            showAlert('✅ Data Entry added Successfully');
            
            // Collapse all sections after successful submission
            allSectionIds.forEach((sectionId, index) => {
                const header = document.getElementById(`section-header-${sectionId}`);
                const content = document.getElementById(`section-content-${sectionId}`);
                
                if (header && content && index > 0) {
                    header.classList.add('collapsed');
                    content.classList.remove('expanded');
                }
            });
            
            scrollToTop(800);
        } else {
            throw new Error('Failed to save record');
        }
    } catch (error) {
        console.error('Error saving record:', error);
        showAlert('❌ Error saving record', 'error');
    }
});

function clearForm() {
    document.getElementById('dataForm').reset();
    showAlert('Form cleared', 'info');
}

async function loadRecords() {
    try {
        showAlert('Loading records...', 'info');
        const response = await fetch('/api/getRecords');
        const data = await response.json();
        console.log('Records:', data.records);
        renderRecordsTable(data.records);
        
        if (data.records && data.records.length > 0) {
            setTimeout(() => {
                document.getElementById('alert-container').innerHTML = '';
            }, 1000);
        }
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
        body.innerHTML = '<tr><td style="text-align: center; padding: 2rem;">No data available. Please add some records first.</td></tr>';
        return;
    }

    const allKeys = new Set();
    records.forEach(record => {
        Object.keys(record).forEach(key => {
            if (key !== 'form_data') {
                allKeys.add(key);
            }
        });
    });
    
    const fieldKeys = Array.from(allKeys);

    let headerHTML = '<th>Record ID</th><th>Created At</th><th>Uploaded</th>';
    fieldKeys.forEach(fieldId => {
        if (!['id', 'created_at', 'uploaded_to_s3'].includes(fieldId)) {
            const field = currentFields.find(f => f.field_id === fieldId);
            const label = field ? field.label.replace(/<[^>]+>/g, '').trim() : fieldId;
            headerHTML += `<th title="${fieldId}">${label}</th>`;
        }
    });
    header.innerHTML = headerHTML;

    let bodyHTML = '';
    records.forEach(record => {
        bodyHTML += `<tr>
            <td>${record.id || ''}</td>
            <td>${record.created_at ? new Date(record.created_at).toLocaleString() : ''}</td>
            <td style="text-align: center;">${record.uploaded_to_s3 ? '✅' : '❌'}</td>`;
        
        fieldKeys.forEach(fieldId => {
            if (!['id', 'created_at', 'uploaded_to_s3'].includes(fieldId)) {
                const value = record[fieldId] || '';
                if (Array.isArray(value)) {
                    bodyHTML += `<td title="${value.join(', ')}">${value.join(', ')}</td>`;
                } else {
                    bodyHTML += `<td title="${value}">${value}</td>`;
                }
            }
        });
        
        bodyHTML += '</tr>';
    });

    body.innerHTML = bodyHTML;
}

function getFieldPriority(fieldId) {
    const nameFields = ['first_name', 'last_name', 'patient_name', 'full_name', 'name'];
    const identifierFields = ['record_id', 'patient_id', 'id', 'mrn'];
    
    const nameIndex = nameFields.indexOf(fieldId.toLowerCase());
    if (nameIndex !== -1) return nameIndex;
    
    const idIndex = identifierFields.indexOf(fieldId.toLowerCase());
    if (idIndex !== -1) return 10 + idIndex;
    
    return 1000;
}

function sortFieldsByPriority(fields) {
    return fields.sort((a, b) => {
        const priorityA = getFieldPriority(a.field_id);
        const priorityB = getFieldPriority(b.field_id);
        return priorityA - priorityB;
    });
}

async function buildForm() {
    const formContainer = document.getElementById("form-container");
    formContainer.innerHTML = "";

    if (!formSchema) {
        showAlert('Loading form schema...', 'info');
        await loadFormSchema();
    }

    if (!formSchema || !formSchema.categories) {
        showAlert('Failed to load form schema', 'error');
        return;
    }

    // Create category tabs
    const tabsDiv = document.createElement('div');
    tabsDiv.className = 'category-tabs';
    
    const categoryKeys = Object.keys(formSchema.categories);
    categoryKeys.forEach((categoryKey, index) => {
        const category = formSchema.categories[categoryKey];
        const tab = document.createElement('button');
        tab.type = 'button';
        tab.id = `tab-${categoryKey}`;
        tab.className = `category-tab ${index === 0 ? 'active' : ''}`;
        tab.onclick = () => showCategory(categoryKey);
        tab.innerHTML = `
            <span class="tab-icon">${getCategoryIcon(categoryKey)}</span>
            <span class="tab-text">
                <strong>${category.name}</strong>
                <small>${formSchema.metadata.field_counts[categoryKey]} fields</small>
            </span>
        `;
        tabsDiv.appendChild(tab);
    });
    
    formContainer.appendChild(tabsDiv);
    
    // Create category panels
    const panelsDiv = document.createElement('div');
    panelsDiv.className = 'category-panels';
    
    categoryKeys.forEach((categoryKey, index) => {
        const category = formSchema.categories[categoryKey];
        
        const panel = document.createElement('div');
        panel.id = `panel-${categoryKey}`;
        panel.className = `category-panel ${index === 0 ? 'active' : ''}`;
        
        const controls = document.createElement('div');
        controls.className = 'section-controls';
        controls.innerHTML = `
            <button type="button" class="btn btn-small btn-secondary" onclick="expandAllSections('${categoryKey}')">
                ⬇️ Expand All
            </button>
            <button type="button" class="btn btn-small btn-secondary" onclick="collapseAllSections('${categoryKey}')">
                ⬆️ Collapse All
            </button>
        `;
        panel.appendChild(controls);
        
        const fieldsBySection = groupFieldsBySection(category.fields);
        
        Object.keys(fieldsBySection).forEach((sectionKey, sectionIndex) => {
            const sectionFields = sortFieldsByPriority(fieldsBySection[sectionKey]);
            const sectionId = `${categoryKey}-${sectionKey}`;
            
            // Store fields data in Map for lazy loading
            sectionFieldsData.set(sectionId, sectionFields);
            
            const sectionDiv = document.createElement('div');
            sectionDiv.className = 'form-section';
            
            const sectionHeader = document.createElement('div');
            sectionHeader.id = `section-header-${sectionId}`;
            sectionHeader.className = `section-header-small ${sectionIndex > 0 ? 'collapsed' : ''}`;
            sectionHeader.onclick = () => toggleSection(sectionId);
            sectionHeader.innerHTML = `
                <h4>
                    <span class="collapse-icon">▼</span>
                    ${formatSectionName(sectionKey)}
                </h4>
                <span class="field-count">${sectionFields.length} fields</span>
            `;
            sectionDiv.appendChild(sectionHeader);
            
            const fieldsGrid = document.createElement('div');
            fieldsGrid.id = `section-content-${sectionId}`;
            fieldsGrid.className = `form-fields-grid ${sectionIndex === 0 ? 'expanded' : ''}`;
            
            // Create empty placeholder - fields will be rendered on-demand
            fieldsGrid.innerHTML = `
                <div class="section-placeholder">
                    <p class="placeholder-text">⏳ ${sectionFields.length} fields ready to load</p>
                </div>
            `;
            
            sectionDiv.appendChild(fieldsGrid);
            panel.appendChild(sectionDiv);
        });
        
        panelsDiv.appendChild(panel);
    });
    
    formContainer.appendChild(panelsDiv);
    
    // Initialize visibility observer for the first active category
    initializeVisibilityObserver(categoryKeys[0]);
    
    // Render the first expanded section immediately
    const firstSectionId = `${categoryKeys[0]}-${Object.keys(groupFieldsBySection(formSchema.categories[categoryKeys[0]].fields))[0]}`;
    renderSectionContent(firstSectionId);
}

function groupFieldsBySection(fields) {
    const sections = {};
    
    fields.forEach(field => {
        let section = field.section || 'General Fields';
        
        section = section.trim();
        if (section === '' || section === 'No Section') {
            section = 'General Fields';
        }
        
        const sectionKey = section.toLowerCase()
            .replace(/[^a-z0-9\s]/g, '')
            .replace(/\s+/g, '_')
            .substring(0, 50);
        
        if (!sections[sectionKey]) {
            sections[sectionKey] = [];
        }
        sections[sectionKey].push(field);
    });
    
    return sections;
}

function getCategoryIcon(categoryKey) {
    const icons = {
        'general': '👤',
        'shoulder': '💪',
        'elbow': '🦾',
        'wrist': '✋',
        'hand': '🖐️',
        'knee': '🦵',
        'hip': '🦴',
        'ankle': '👟',
        'spine': '🏋️',
        'demographics': '📋'
    };
    return icons[categoryKey] || '📋';
}

function formatSectionName(sectionKey) {
    return sectionKey
        .split('_')
        .map(word => word.charAt(0).toUpperCase() + word.slice(1))
        .join(' ');
}

function createFieldElement(field) {
    const wrapper = document.createElement("div");
    wrapper.classList.add("form-group");
    
    const fieldLabel = field.label.replace(/<[^>]+>/g, '').trim();
    
    const label = document.createElement("label");
    label.setAttribute("for", field.field_id);
    label.textContent = fieldLabel;
    
    if (field.required) {
        const requiredSpan = document.createElement('span');
        requiredSpan.className = 'required';
        requiredSpan.textContent = '*';
        label.appendChild(requiredSpan);
    }

    let input;
    
    switch (field.field_type) {
        case 'text':
        case 'email':
        case 'tel':
            input = document.createElement("input");
            input.type = field.field_type;
            input.id = field.field_id;
            input.name = field.field_id;
            input.classList.add("form-control");
            if (field.validation) {
                if (field.validation.min !== undefined) input.min = field.validation.min;
                if (field.validation.max !== undefined) input.max = field.validation.max;
            }
            break;

        case 'number':
        case 'slider':
            input = document.createElement("input");
            input.type = "number";
            input.id = field.field_id;
            input.name = field.field_id;
            input.classList.add("form-control");
            if (field.validation) {
                if (field.validation.min !== undefined) input.min = field.validation.min;
            }
            break;

        case 'date':
            input = document.createElement("input");
            input.type = "date";
            input.id = field.field_id;
            input.name = field.field_id;
            input.classList.add("form-control");
            break;

        case 'textarea':
            input = document.createElement("textarea");
            input.id = field.field_id;
            input.name = field.field_id;
            input.classList.add("form-control");
            input.rows = 3;
            break;

        case 'select':
            input = document.createElement("select");
            input.id = field.field_id;
            input.name = field.field_id;
            input.classList.add("form-control");
            
            if (field.options && Array.isArray(field.options)) {
                if (!field.required) {
                    const blankOpt = document.createElement("option");
                    blankOpt.value = "";
                    blankOpt.textContent = "-- Select --";
                    input.appendChild(blankOpt);
                }
                
                field.options.forEach(option => {
                    const opt = document.createElement("option");
                    opt.value = option.value;
                    opt.textContent = option.label;
                    input.appendChild(opt);
                });
            }
            break;

        case 'radio':
            input = document.createElement("div");
            input.classList.add("radio-group");
            input.style.display = "flex";
            input.style.flexDirection = "column";
            input.style.gap = "12px";
            
            if (field.options && Array.isArray(field.options)) {
                field.options.forEach((option, idx) => {
                    const radioWrapper = document.createElement("label");
                    radioWrapper.classList.add("radio-option");
                    radioWrapper.style.display = "flex";
                    radioWrapper.style.alignItems = "center";
                    radioWrapper.style.gap = "12px";
                    radioWrapper.style.padding = "10px 12px";
                    radioWrapper.style.background = "#f8fafc";
                    radioWrapper.style.borderRadius = "8px";
                    radioWrapper.style.cursor = "pointer";

                    const radio = document.createElement("input");
                    radio.type = "radio";
                    radio.name = field.field_id;
                    radio.value = option.value;
                    radio.id = `${field.field_id}_${idx}`;
                    radio.style.width = "18px";
                    radio.style.height = "18px";
                    radio.style.margin = "0";
                    radio.style.cursor = "pointer";
                    radio.style.flexShrink = "0";

                    const radioLabel = document.createElement("span");
                    radioLabel.textContent = option.label;
                    radioLabel.style.flex = "1";
                    radioLabel.style.lineHeight = "1.5";

                    radioWrapper.appendChild(radio);
                    radioWrapper.appendChild(radioLabel);
                    input.appendChild(radioWrapper);
                });
            }
            break;

        case 'checkbox':
            input = document.createElement("div");
            input.classList.add("checkbox-group");
            input.style.display = "flex";
            input.style.flexDirection = "column";
            input.style.gap = "12px";
            
            if (field.options && Array.isArray(field.options)) {
                field.options.forEach((option, idx) => {
                    const checkWrapper = document.createElement("label");
                    checkWrapper.classList.add("checkbox-option");
                    checkWrapper.style.display = "flex";
                    checkWrapper.style.alignItems = "center";
                    checkWrapper.style.gap = "12px";
                    checkWrapper.style.padding = "10px 12px";
                    checkWrapper.style.background = "#f8fafc";
                    checkWrapper.style.borderRadius = "8px";
                    checkWrapper.style.cursor = "pointer";

                    const checkbox = document.createElement("input");
                    checkbox.type = "checkbox";
                    checkbox.name = field.field_id;
                    checkbox.value = option.value;
                    checkbox.id = `${field.field_id}_${idx}`;
                    checkbox.style.width = "18px";
                    checkbox.style.height = "18px";
                    checkbox.style.margin = "0";
                    checkbox.style.cursor = "pointer";
                    checkbox.style.flexShrink = "0";

                    const checkLabel = document.createElement("span");
                    checkLabel.textContent = option.label;
                    checkLabel.style.flex = "1";
                    checkLabel.style.lineHeight = "1.5";

                    checkWrapper.appendChild(checkbox);
                    checkWrapper.appendChild(checkLabel);
                    input.appendChild(checkWrapper);
                });
            }
            break;

        default:
            input = document.createElement("input");
            input.type = "text";
            input.id = field.field_id;
            input.name = field.field_id;
            input.classList.add("form-control");
    }

    wrapper.appendChild(label);
    wrapper.appendChild(input);
    
    if (field.note) {
        const note = document.createElement('div');
        note.className = 'field-note';
        note.textContent = field.note;
        wrapper.appendChild(note);
    }

    return wrapper;
}

// Initialize
window.onload = async () => {
    await loadFormSchema();
    await buildForm();
};