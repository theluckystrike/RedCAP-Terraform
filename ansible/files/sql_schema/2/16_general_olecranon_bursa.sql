-- Table: general_olecranon_bursa
-- Generated: 2025-11-28T20:28:38.883767
-- Fields: 2

CREATE TABLE IF NOT EXISTS general_olecranon_bursa (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_olecranon_bursa_dx" JSONB,  -- OLECRANON BURSA diagnosis / pathology
    "dem_olecranon_bursa_tx" JSONB,  -- Olecranon Bursa Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_olecranon_bursa
CREATE INDEX IF NOT EXISTS idx_general_olecranon_bursa_encounter ON general_olecranon_bursa(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_olecranon_bursa_created ON general_olecranon_bursa(created_at);

-- Foreign key constraint
ALTER TABLE general_olecranon_bursa
    ADD CONSTRAINT fk_general_olecranon_bursa_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
