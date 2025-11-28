-- Table: general_forearm_articulations_pruj_druj_treatment
-- Generated: 2025-11-28T20:28:38.884913
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_forearm_articulations_pruj_druj_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_forearm_articulation_pruj_druj_tx" JSONB,  -- Forearm Articulation ± PRUJ ± DRUJ Treatments
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_forearm_articulations_pruj_druj_treatment
CREATE INDEX IF NOT EXISTS idx_general_forearm_articulations_pruj_druj_treatment_encounter ON general_forearm_articulations_pruj_druj_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_forearm_articulations_pruj_druj_treatment_created ON general_forearm_articulations_pruj_druj_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_forearm_articulations_pruj_druj_treatment
    ADD CONSTRAINT fk_general_forearm_articulations_pruj_druj_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
