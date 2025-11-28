-- Table: elbow_forearm
-- Generated: 2025-11-28T20:28:38.912478
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_forearm (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_forearm_diagnosis" JSONB,  -- Forearm diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_forearm
CREATE INDEX IF NOT EXISTS idx_elbow_forearm_encounter ON elbow_forearm(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_forearm_created ON elbow_forearm(created_at);

-- Foreign key constraint
ALTER TABLE elbow_forearm
    ADD CONSTRAINT fk_elbow_forearm_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
