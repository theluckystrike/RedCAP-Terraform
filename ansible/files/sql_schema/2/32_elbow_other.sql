-- Table: elbow_other
-- Generated: 2025-11-28T20:28:38.915258
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_other (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_other_diagnostic_pathological_information" TEXT,  -- Other diagnostic / pathological information
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_other
CREATE INDEX IF NOT EXISTS idx_elbow_other_encounter ON elbow_other(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_other_created ON elbow_other(created_at);

-- Foreign key constraint
ALTER TABLE elbow_other
    ADD CONSTRAINT fk_elbow_other_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
