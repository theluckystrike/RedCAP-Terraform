-- Table: shoulder_follow_up
-- Generated: 2025-11-28T20:28:38.906248
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_follow_up (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_outcome" VARCHAR(50),  -- Outcome
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_follow_up
CREATE INDEX IF NOT EXISTS idx_shoulder_follow_up_encounter ON shoulder_follow_up(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_follow_up_created ON shoulder_follow_up(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_follow_up
    ADD CONSTRAINT fk_shoulder_follow_up_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
