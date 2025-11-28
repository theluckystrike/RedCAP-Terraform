-- Table: general_coronoid_process
-- Generated: 2025-11-28T20:28:38.883943
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_coronoid_process (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_coronoid_process_dx_1" JSONB,  -- Coronoid Process Diagnosis / Pathology
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_coronoid_process
CREATE INDEX IF NOT EXISTS idx_general_coronoid_process_encounter ON general_coronoid_process(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_coronoid_process_created ON general_coronoid_process(created_at);

-- Foreign key constraint
ALTER TABLE general_coronoid_process
    ADD CONSTRAINT fk_general_coronoid_process_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
