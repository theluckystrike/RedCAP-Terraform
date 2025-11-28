-- Table: shoulder_rotator_cuff
-- Generated: 2025-11-28T20:28:38.899414
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_rotator_cuff (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_rotator_cuff_diagnosis" JSONB,  -- Rotator cuff diagnosis
    "orth_sh_rotator_cuff_treatment" JSONB,  -- Rotator cuff treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_rotator_cuff
CREATE INDEX IF NOT EXISTS idx_shoulder_rotator_cuff_encounter ON shoulder_rotator_cuff(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_rotator_cuff_created ON shoulder_rotator_cuff(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_rotator_cuff
    ADD CONSTRAINT fk_shoulder_rotator_cuff_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
