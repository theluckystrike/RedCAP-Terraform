-- Table: shoulder_teres_major
-- Generated: 2025-11-28T20:28:38.905403
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_teres_major (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_teres_major_treatment" JSONB,  -- Teres major treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_teres_major
CREATE INDEX IF NOT EXISTS idx_shoulder_teres_major_encounter ON shoulder_teres_major(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_teres_major_created ON shoulder_teres_major(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_teres_major
    ADD CONSTRAINT fk_shoulder_teres_major_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
