-- Table: elbow_fascia
-- Generated: 2025-11-28T20:28:38.914448
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_fascia (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_fascia_diagnosis" JSONB,  -- Fascia diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_fascia
CREATE INDEX IF NOT EXISTS idx_elbow_fascia_encounter ON elbow_fascia(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_fascia_created ON elbow_fascia(created_at);

-- Foreign key constraint
ALTER TABLE elbow_fascia
    ADD CONSTRAINT fk_elbow_fascia_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
