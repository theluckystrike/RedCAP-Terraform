-- Table: general_olecranon_treatment
-- Generated: 2025-11-28T20:28:38.885690
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_olecranon_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_olecranon_tx" JSONB,  -- Olecranon Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_olecranon_treatment
CREATE INDEX IF NOT EXISTS idx_general_olecranon_treatment_encounter ON general_olecranon_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_olecranon_treatment_created ON general_olecranon_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_olecranon_treatment
    ADD CONSTRAINT fk_general_olecranon_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
