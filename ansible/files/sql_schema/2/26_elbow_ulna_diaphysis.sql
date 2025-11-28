-- Table: elbow_ulna_diaphysis
-- Generated: 2025-11-28T20:28:38.914324
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_ulna_diaphysis (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_ulna_diaphysis_diagnosis" JSONB,  -- Ulna diaphysis diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_ulna_diaphysis
CREATE INDEX IF NOT EXISTS idx_elbow_ulna_diaphysis_encounter ON elbow_ulna_diaphysis(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_ulna_diaphysis_created ON elbow_ulna_diaphysis(created_at);

-- Foreign key constraint
ALTER TABLE elbow_ulna_diaphysis
    ADD CONSTRAINT fk_elbow_ulna_diaphysis_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
