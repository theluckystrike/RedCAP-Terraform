-- Table: elbow_radial_head_neck
-- Generated: 2025-11-28T20:28:38.914085
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_radial_head_neck (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_radial_head_neck_diagnosis" JSONB,  -- Radial head neck diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_radial_head_neck
CREATE INDEX IF NOT EXISTS idx_elbow_radial_head_neck_encounter ON elbow_radial_head_neck(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_radial_head_neck_created ON elbow_radial_head_neck(created_at);

-- Foreign key constraint
ALTER TABLE elbow_radial_head_neck
    ADD CONSTRAINT fk_elbow_radial_head_neck_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
