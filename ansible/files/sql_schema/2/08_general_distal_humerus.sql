-- Table: general_distal_humerus
-- Generated: 2025-11-28T20:28:38.882453
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_distal_humerus (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_distal_humerus_dx_1" JSONB,  -- DISTAL HUMERUS Diagnosis / pathology
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_distal_humerus
CREATE INDEX IF NOT EXISTS idx_general_distal_humerus_encounter ON general_distal_humerus(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_distal_humerus_created ON general_distal_humerus(created_at);

-- Foreign key constraint
ALTER TABLE general_distal_humerus
    ADD CONSTRAINT fk_general_distal_humerus_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
