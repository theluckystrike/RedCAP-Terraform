-- Table: general_radial_diaphysis
-- Generated: 2025-11-28T20:28:38.884188
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_radial_diaphysis (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_radial_diaphysis_dx_1" JSONB,  -- Radial Diaphysis Diagnosis / Pathology
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_radial_diaphysis
CREATE INDEX IF NOT EXISTS idx_general_radial_diaphysis_encounter ON general_radial_diaphysis(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_radial_diaphysis_created ON general_radial_diaphysis(created_at);

-- Foreign key constraint
ALTER TABLE general_radial_diaphysis
    ADD CONSTRAINT fk_general_radial_diaphysis_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
