-- Table: shoulder_history
-- Generated: 2025-11-28T20:28:38.901535
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_history (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_record_history_for_the_encounter" VARCHAR(50),  -- Record history for the encounter
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_history
CREATE INDEX IF NOT EXISTS idx_shoulder_history_encounter ON shoulder_history(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_history_created ON shoulder_history(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_history
    ADD CONSTRAINT fk_shoulder_history_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
