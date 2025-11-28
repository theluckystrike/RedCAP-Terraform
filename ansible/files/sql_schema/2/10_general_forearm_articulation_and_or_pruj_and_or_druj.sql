-- Table: general_forearm_articulation_and_or_pruj_and_or_druj
-- Generated: 2025-11-28T20:28:38.882793
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_forearm_articulation_and_or_pruj_and_or_druj (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_forearm_articulation_and_or_pruj_and_or_druj_dx" JSONB,  -- Forearm Articulation and/or PRUJ and/or DRUJ diagnosis / pat
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_forearm_articulation_and_or_pruj_and_or_druj
CREATE INDEX IF NOT EXISTS idx_general_forearm_articulation_and_or_pruj_and_or_druj_encounter ON general_forearm_articulation_and_or_pruj_and_or_druj(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_forearm_articulation_and_or_pruj_and_or_druj_created ON general_forearm_articulation_and_or_pruj_and_or_druj(created_at);

-- Foreign key constraint
ALTER TABLE general_forearm_articulation_and_or_pruj_and_or_druj
    ADD CONSTRAINT fk_general_forearm_articulation_and_or_pruj_and_or_druj_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
