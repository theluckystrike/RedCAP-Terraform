-- Table: elbow_druj
-- Generated: 2025-11-28T20:28:38.912250
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_druj (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_druj_diagnosis" JSONB,  -- DRUJ diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_druj
CREATE INDEX IF NOT EXISTS idx_elbow_druj_encounter ON elbow_druj(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_druj_created ON elbow_druj(created_at);

-- Foreign key constraint
ALTER TABLE elbow_druj
    ADD CONSTRAINT fk_elbow_druj_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
