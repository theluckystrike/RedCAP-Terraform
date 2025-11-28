-- Table: shoulder_pec_minor
-- Generated: 2025-11-28T20:28:38.900253
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_pec_minor (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_pec_minor_diagnosis" JSONB,  -- Pec minor diagnosis
    "orth_sh_pec_minor_treatment" JSONB,  -- Pec minor treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_pec_minor
CREATE INDEX IF NOT EXISTS idx_shoulder_pec_minor_encounter ON shoulder_pec_minor(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_pec_minor_created ON shoulder_pec_minor(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_pec_minor
    ADD CONSTRAINT fk_shoulder_pec_minor_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
