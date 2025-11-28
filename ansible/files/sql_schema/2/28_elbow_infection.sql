-- Table: elbow_infection
-- Generated: 2025-11-28T20:28:38.914724
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_infection (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_infection_diagnosis" VARCHAR(50),  -- Infection diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_infection
CREATE INDEX IF NOT EXISTS idx_elbow_infection_encounter ON elbow_infection(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_infection_created ON elbow_infection(created_at);

-- Foreign key constraint
ALTER TABLE elbow_infection
    ADD CONSTRAINT fk_elbow_infection_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
