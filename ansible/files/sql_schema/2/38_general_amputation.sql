-- Table: general_amputation
-- Generated: 2025-11-28T20:28:38.888005
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_amputation (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_amputation_level" JSONB,  -- Amputation Level
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_amputation
CREATE INDEX IF NOT EXISTS idx_general_amputation_encounter ON general_amputation(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_amputation_created ON general_amputation(created_at);

-- Foreign key constraint
ALTER TABLE general_amputation
    ADD CONSTRAINT fk_general_amputation_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
