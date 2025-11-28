-- Table: general_radial_head_neck
-- Generated: 2025-11-28T20:28:38.884063
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_radial_head_neck (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_radial_head_dx_1" JSONB,  -- RADIAL HEAD / NECK Diagnosis / pathology
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_radial_head_neck
CREATE INDEX IF NOT EXISTS idx_general_radial_head_neck_encounter ON general_radial_head_neck(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_radial_head_neck_created ON general_radial_head_neck(created_at);

-- Foreign key constraint
ALTER TABLE general_radial_head_neck
    ADD CONSTRAINT fk_general_radial_head_neck_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
