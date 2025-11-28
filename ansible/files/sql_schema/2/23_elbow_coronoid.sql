-- Table: elbow_coronoid
-- Generated: 2025-11-28T20:28:38.913968
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_coronoid (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_coronoid_diagnosis" JSONB,  -- Coronoid diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_coronoid
CREATE INDEX IF NOT EXISTS idx_elbow_coronoid_encounter ON elbow_coronoid(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_coronoid_created ON elbow_coronoid(created_at);

-- Foreign key constraint
ALTER TABLE elbow_coronoid
    ADD CONSTRAINT fk_elbow_coronoid_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
