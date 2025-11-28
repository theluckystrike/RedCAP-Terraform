-- Table: elbow_diagnosis
-- Generated: 2025-11-28T20:28:38.915005
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_diagnosis (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_diag_location" JSONB,  -- Elbow Regions
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_diagnosis
CREATE INDEX IF NOT EXISTS idx_elbow_diagnosis_encounter ON elbow_diagnosis(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_diagnosis_created ON elbow_diagnosis(created_at);

-- Foreign key constraint
ALTER TABLE elbow_diagnosis
    ADD CONSTRAINT fk_elbow_diagnosis_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
