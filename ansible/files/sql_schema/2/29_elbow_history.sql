-- Table: elbow_history
-- Generated: 2025-11-28T20:28:38.914876
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_history (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_record_history_for_the_enc" VARCHAR(50),  -- Record history for the encounter
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_history
CREATE INDEX IF NOT EXISTS idx_elbow_history_encounter ON elbow_history(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_history_created ON elbow_history(created_at);

-- Foreign key constraint
ALTER TABLE elbow_history
    ADD CONSTRAINT fk_elbow_history_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
