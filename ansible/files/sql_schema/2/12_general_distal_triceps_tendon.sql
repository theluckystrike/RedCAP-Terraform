-- Table: general_distal_triceps_tendon
-- Generated: 2025-11-28T20:28:38.883108
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_distal_triceps_tendon (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_distal_triceps_tendon_diagnosis" JSONB,  -- DISTAL TRICEPS TENDON DIAGNOSIS
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_distal_triceps_tendon
CREATE INDEX IF NOT EXISTS idx_general_distal_triceps_tendon_encounter ON general_distal_triceps_tendon(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_distal_triceps_tendon_created ON general_distal_triceps_tendon(created_at);

-- Foreign key constraint
ALTER TABLE general_distal_triceps_tendon
    ADD CONSTRAINT fk_general_distal_triceps_tendon_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
