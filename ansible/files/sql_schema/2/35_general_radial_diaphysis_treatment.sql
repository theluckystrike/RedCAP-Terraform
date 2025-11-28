-- Table: general_radial_diaphysis_treatment
-- Generated: 2025-11-28T20:28:38.887590
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_radial_diaphysis_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_radial_diaphysis_tx" JSONB,  -- Radial Diaphysis Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_radial_diaphysis_treatment
CREATE INDEX IF NOT EXISTS idx_general_radial_diaphysis_treatment_encounter ON general_radial_diaphysis_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_radial_diaphysis_treatment_created ON general_radial_diaphysis_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_radial_diaphysis_treatment
    ADD CONSTRAINT fk_general_radial_diaphysis_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
