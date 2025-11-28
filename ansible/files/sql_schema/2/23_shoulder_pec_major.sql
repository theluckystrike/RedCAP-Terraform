-- Table: shoulder_pec_major
-- Generated: 2025-11-28T20:28:38.900375
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_pec_major (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_pec_major_diagnosis" JSONB,  -- Pec major diagnosis
    "orth_sh_pec_major_treatment" JSONB,  -- Pec major treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_pec_major
CREATE INDEX IF NOT EXISTS idx_shoulder_pec_major_encounter ON shoulder_pec_major(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_pec_major_created ON shoulder_pec_major(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_pec_major
    ADD CONSTRAINT fk_shoulder_pec_major_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
