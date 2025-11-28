-- Table: general_coronoid_process_treatment
-- Generated: 2025-11-28T20:28:38.886932
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_coronoid_process_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_coronoid_tx" JSONB,  -- Coronoid Process Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_coronoid_process_treatment
CREATE INDEX IF NOT EXISTS idx_general_coronoid_process_treatment_encounter ON general_coronoid_process_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_coronoid_process_treatment_created ON general_coronoid_process_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_coronoid_process_treatment
    ADD CONSTRAINT fk_general_coronoid_process_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
