-- Table: general_nerve_dysfunction
-- Generated: 2025-11-28T20:28:38.885580
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_nerve_dysfunction (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_mechanical_neuropathy_treatment" JSONB,  -- Neuropathy Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_nerve_dysfunction
CREATE INDEX IF NOT EXISTS idx_general_nerve_dysfunction_encounter ON general_nerve_dysfunction(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_nerve_dysfunction_created ON general_nerve_dysfunction(created_at);

-- Foreign key constraint
ALTER TABLE general_nerve_dysfunction
    ADD CONSTRAINT fk_general_nerve_dysfunction_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
