-- Table: general_radial_head_neck_treatment
-- Generated: 2025-11-28T20:28:38.887392
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_radial_head_neck_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_radial_head_neck_tx" JSONB,  -- Radial Head / Neck Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_radial_head_neck_treatment
CREATE INDEX IF NOT EXISTS idx_general_radial_head_neck_treatment_encounter ON general_radial_head_neck_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_radial_head_neck_treatment_created ON general_radial_head_neck_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_radial_head_neck_treatment
    ADD CONSTRAINT fk_general_radial_head_neck_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
