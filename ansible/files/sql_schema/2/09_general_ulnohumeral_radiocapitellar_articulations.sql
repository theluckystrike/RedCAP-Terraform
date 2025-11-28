-- Table: general_ulnohumeral_radiocapitellar_articulations
-- Generated: 2025-11-28T20:28:38.882641
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_ulnohumeral_radiocapitellar_articulations (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_ulnohumeral_radiocapitellar_or_ulnoradial_forearm_radiocapi" JSONB,  -- Ulnohumeral & Radiocapitellar Articulations Diagnosis / path
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_ulnohumeral_radiocapitellar_articulations
CREATE INDEX IF NOT EXISTS idx_general_ulnohumeral_radiocapitellar_articulations_encounter ON general_ulnohumeral_radiocapitellar_articulations(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_ulnohumeral_radiocapitellar_articulations_created ON general_ulnohumeral_radiocapitellar_articulations(created_at);

-- Foreign key constraint
ALTER TABLE general_ulnohumeral_radiocapitellar_articulations
    ADD CONSTRAINT fk_general_ulnohumeral_radiocapitellar_articulations_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
