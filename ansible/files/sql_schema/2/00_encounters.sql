-- Main Encounters Table (Master Record)
-- Links all specialty-specific tables together

CREATE TABLE IF NOT EXISTS encounters (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) UNIQUE NOT NULL,  -- Format: YYYYMMDD_PatientID
    patient_id VARCHAR(50) NOT NULL,
    processing_date DATE NOT NULL,
    encounter_date DATE,
    encounter_type VARCHAR(50),  -- first_visit, follow_up, surgery, post_op
    is_first_visit BOOLEAN DEFAULT TRUE,
    prior_encounter_id VARCHAR(100),  -- Link to previous encounter
    schema_version VARCHAR(20) DEFAULT '1.0',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_prior_encounter 
        FOREIGN KEY (prior_encounter_id) 
        REFERENCES encounters(encounter_id)
);

-- Indexes for encounters table
CREATE INDEX IF NOT EXISTS idx_encounters_patient ON encounters(patient_id);
CREATE INDEX IF NOT EXISTS idx_encounters_date ON encounters(encounter_date);
CREATE INDEX IF NOT EXISTS idx_encounters_processing ON encounters(processing_date);
CREATE INDEX IF NOT EXISTS idx_encounters_prior ON encounters(prior_encounter_id);
CREATE INDEX IF NOT EXISTS idx_encounters_type ON encounters(encounter_type);

