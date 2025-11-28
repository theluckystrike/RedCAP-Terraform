-- Table: general_ulna_diaphysis
-- Generated: 2025-11-28T20:28:38.884321
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_ulna_diaphysis (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_ulna_diaphysis_dx_1" JSONB,  -- Ulna Diaphysis Diagnosis / Pathology
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_ulna_diaphysis
CREATE INDEX IF NOT EXISTS idx_general_ulna_diaphysis_encounter ON general_ulna_diaphysis(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_ulna_diaphysis_created ON general_ulna_diaphysis(created_at);

-- Foreign key constraint
ALTER TABLE general_ulna_diaphysis
    ADD CONSTRAINT fk_general_ulna_diaphysis_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
