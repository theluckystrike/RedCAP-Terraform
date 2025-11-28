-- Table: shoulder_clavicle
-- Generated: 2025-11-28T20:28:38.898963
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_clavicle (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_clavicle_diagnosis" JSONB,  -- Clavicle Diagnosis
    "orth_sh_clavicle_treatment" JSONB,  -- Clavicle treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_clavicle
CREATE INDEX IF NOT EXISTS idx_shoulder_clavicle_encounter ON shoulder_clavicle(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_clavicle_created ON shoulder_clavicle(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_clavicle
    ADD CONSTRAINT fk_shoulder_clavicle_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
