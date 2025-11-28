-- Table: general_common_flexor_origin
-- Generated: 2025-11-28T20:28:38.883336
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_common_flexor_origin (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_common_flexor_origin_diagnosis" JSONB,  -- COMMON FLEXOR ORIGIN DIAGNOSIS
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_common_flexor_origin
CREATE INDEX IF NOT EXISTS idx_general_common_flexor_origin_encounter ON general_common_flexor_origin(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_common_flexor_origin_created ON general_common_flexor_origin(created_at);

-- Foreign key constraint
ALTER TABLE general_common_flexor_origin
    ADD CONSTRAINT fk_general_common_flexor_origin_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
