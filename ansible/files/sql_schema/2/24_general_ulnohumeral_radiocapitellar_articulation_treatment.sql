-- Table: general_ulnohumeral_radiocapitellar_articulation_treatment
-- Generated: 2025-11-28T20:28:38.884798
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_ulnohumeral_radiocapitellar_articulation_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_ulnohumeral_radiocapitellar_tx" JSONB,  -- Ulnohumeral & Radiocapitellar Treatments
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_ulnohumeral_radiocapitellar_articulation_treatment
CREATE INDEX IF NOT EXISTS idx_general_ulnohumeral_radiocapitellar_articulation_treatment_encounter ON general_ulnohumeral_radiocapitellar_articulation_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_ulnohumeral_radiocapitellar_articulation_treatment_created ON general_ulnohumeral_radiocapitellar_articulation_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_ulnohumeral_radiocapitellar_articulation_treatment
    ADD CONSTRAINT fk_general_ulnohumeral_radiocapitellar_articulation_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
