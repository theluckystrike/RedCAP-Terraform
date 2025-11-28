-- Table: shoulder_other
-- Generated: 2025-11-28T20:28:38.901403
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_other (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_other_pathology_diagnosis" TEXT,  -- Other pathology diagnosis
    "orth_sh_other_treatment" TEXT,  -- Other treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_other
CREATE INDEX IF NOT EXISTS idx_shoulder_other_encounter ON shoulder_other(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_other_created ON shoulder_other(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_other
    ADD CONSTRAINT fk_shoulder_other_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
