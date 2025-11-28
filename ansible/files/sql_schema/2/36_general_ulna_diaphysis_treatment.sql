-- Table: general_ulna_diaphysis_treatment
-- Generated: 2025-11-28T20:28:38.887702
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_ulna_diaphysis_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_ulna_diaphysis_tx" JSONB,  -- Ulna Diaphysis Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_ulna_diaphysis_treatment
CREATE INDEX IF NOT EXISTS idx_general_ulna_diaphysis_treatment_encounter ON general_ulna_diaphysis_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_ulna_diaphysis_treatment_created ON general_ulna_diaphysis_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_ulna_diaphysis_treatment
    ADD CONSTRAINT fk_general_ulna_diaphysis_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
