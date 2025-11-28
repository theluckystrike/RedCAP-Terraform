-- Table: elbow_distal_biceps
-- Generated: 2025-11-28T20:28:38.913176
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_distal_biceps (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_distal_biceps_diagnosis" JSONB,  -- Distal biceps diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_distal_biceps
CREATE INDEX IF NOT EXISTS idx_elbow_distal_biceps_encounter ON elbow_distal_biceps(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_distal_biceps_created ON elbow_distal_biceps(created_at);

-- Foreign key constraint
ALTER TABLE elbow_distal_biceps
    ADD CONSTRAINT fk_elbow_distal_biceps_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
