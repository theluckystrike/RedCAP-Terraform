-- Table: shoulder_scapula
-- Generated: 2025-11-28T20:28:38.898834
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_scapula (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_scapula_diagnosis" JSONB,  -- Scapula Diagnosis
    "orth_sh_scapula_treatment_location" JSONB,  -- Scapula treatment location
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_scapula
CREATE INDEX IF NOT EXISTS idx_shoulder_scapula_encounter ON shoulder_scapula(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_scapula_created ON shoulder_scapula(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_scapula
    ADD CONSTRAINT fk_shoulder_scapula_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
