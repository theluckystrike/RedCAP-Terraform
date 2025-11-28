-- Table: elbow_pruj
-- Generated: 2025-11-28T20:28:38.911308
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_pruj (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_pruj_diagnosis" JSONB,  -- PRUJ diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_pruj
CREATE INDEX IF NOT EXISTS idx_elbow_pruj_encounter ON elbow_pruj(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_pruj_created ON elbow_pruj(created_at);

-- Foreign key constraint
ALTER TABLE elbow_pruj
    ADD CONSTRAINT fk_elbow_pruj_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
