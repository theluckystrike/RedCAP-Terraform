-- Table: general_olecranon
-- Generated: 2025-11-28T20:28:38.883586
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_olecranon (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_olecranon_dx_1" JSONB,  -- OLECRANON Diagnosis / pathology
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_olecranon
CREATE INDEX IF NOT EXISTS idx_general_olecranon_encounter ON general_olecranon(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_olecranon_created ON general_olecranon(created_at);

-- Foreign key constraint
ALTER TABLE general_olecranon
    ADD CONSTRAINT fk_general_olecranon_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
