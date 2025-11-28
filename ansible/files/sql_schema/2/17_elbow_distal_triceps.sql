-- Table: elbow_distal_triceps
-- Generated: 2025-11-28T20:28:38.913292
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_distal_triceps (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_distal_triceps_diagnosis" JSONB,  -- Distal triceps diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_distal_triceps
CREATE INDEX IF NOT EXISTS idx_elbow_distal_triceps_encounter ON elbow_distal_triceps(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_distal_triceps_created ON elbow_distal_triceps(created_at);

-- Foreign key constraint
ALTER TABLE elbow_distal_triceps
    ADD CONSTRAINT fk_elbow_distal_triceps_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
