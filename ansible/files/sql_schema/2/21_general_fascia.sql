-- Table: general_fascia
-- Generated: 2025-11-28T20:28:38.884439
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_fascia (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_fascia_dx" JSONB,  -- Fascia diagnosis / pathology
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_fascia
CREATE INDEX IF NOT EXISTS idx_general_fascia_encounter ON general_fascia(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_fascia_created ON general_fascia(created_at);

-- Foreign key constraint
ALTER TABLE general_fascia
    ADD CONSTRAINT fk_general_fascia_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
