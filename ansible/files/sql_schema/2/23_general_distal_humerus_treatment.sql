-- Table: general_distal_humerus_treatment
-- Generated: 2025-11-28T20:28:38.884681
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_distal_humerus_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_distal_humerus_tx" JSONB,  -- Distal Humerus Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_distal_humerus_treatment
CREATE INDEX IF NOT EXISTS idx_general_distal_humerus_treatment_encounter ON general_distal_humerus_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_distal_humerus_treatment_created ON general_distal_humerus_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_distal_humerus_treatment
    ADD CONSTRAINT fk_general_distal_humerus_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
