-- Table: shoulder_encounter_details
-- Generated: 2025-11-28T20:28:38.897711
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_encounter_details (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_encounter_date" DATE,  -- Encounter date
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_encounter_details
CREATE INDEX IF NOT EXISTS idx_shoulder_encounter_details_encounter ON shoulder_encounter_details(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_encounter_details_created ON shoulder_encounter_details(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_encounter_details
    ADD CONSTRAINT fk_shoulder_encounter_details_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
