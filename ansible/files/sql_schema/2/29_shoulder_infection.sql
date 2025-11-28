-- Table: shoulder_infection
-- Generated: 2025-11-28T20:28:38.901285
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_infection (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_infection_diagnosis" VARCHAR(50),  -- Infection diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_infection
CREATE INDEX IF NOT EXISTS idx_shoulder_infection_encounter ON shoulder_infection(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_infection_created ON shoulder_infection(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_infection
    ADD CONSTRAINT fk_shoulder_infection_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
