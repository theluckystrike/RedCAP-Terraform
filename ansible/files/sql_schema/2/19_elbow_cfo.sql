-- Table: elbow_cfo
-- Generated: 2025-11-28T20:28:38.913523
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_cfo (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_cfo_diagnosis" JSONB,  -- CFO diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_cfo
CREATE INDEX IF NOT EXISTS idx_elbow_cfo_encounter ON elbow_cfo(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_cfo_created ON elbow_cfo(created_at);

-- Foreign key constraint
ALTER TABLE elbow_cfo
    ADD CONSTRAINT fk_elbow_cfo_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
