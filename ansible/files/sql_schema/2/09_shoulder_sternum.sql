-- Table: shoulder_sternum
-- Generated: 2025-11-28T20:28:38.898340
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_sternum (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_sternum_diagnosis" JSONB,  -- Sternum diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_sternum
CREATE INDEX IF NOT EXISTS idx_shoulder_sternum_encounter ON shoulder_sternum(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_sternum_created ON shoulder_sternum(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_sternum
    ADD CONSTRAINT fk_shoulder_sternum_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
