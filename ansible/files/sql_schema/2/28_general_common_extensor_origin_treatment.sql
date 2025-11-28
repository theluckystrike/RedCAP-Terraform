-- Table: general_common_extensor_origin_treatment
-- Generated: 2025-11-28T20:28:38.885252
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_common_extensor_origin_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_ceo_tx" JSONB,  -- Common Extensor Origin Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_common_extensor_origin_treatment
CREATE INDEX IF NOT EXISTS idx_general_common_extensor_origin_treatment_encounter ON general_common_extensor_origin_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_common_extensor_origin_treatment_created ON general_common_extensor_origin_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_common_extensor_origin_treatment
    ADD CONSTRAINT fk_general_common_extensor_origin_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
