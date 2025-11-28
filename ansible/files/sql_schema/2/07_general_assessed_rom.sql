-- Table: general_assessed_rom
-- Generated: 2025-11-28T20:28:38.882190
-- Fields: 8

CREATE TABLE IF NOT EXISTS general_assessed_rom (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_elbow_flexion" VARCHAR(500),  -- Elbow Flexion
    "dem_elbow_flexion_3mo" VARCHAR(500),  -- Elbow Flexion
    "dem_elbow_flexion_6mo" VARCHAR(500),  -- Elbow Flexion
    "dem_elbow_flexion_12mo" VARCHAR(500),  -- Elbow Flexion
    "dem_elbow_flexion_24mo" VARCHAR(500),  -- Elbow Flexion
    "dem_elbow_flexion_36mo" VARCHAR(500),  -- Elbow Flexion
    "dem_elbow_flexion_5y" VARCHAR(500),  -- Elbow Flexion
    "dem_elbow_flexion_10y" VARCHAR(500),  -- Elbow Flexion
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_assessed_rom
CREATE INDEX IF NOT EXISTS idx_general_assessed_rom_encounter ON general_assessed_rom(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_assessed_rom_created ON general_assessed_rom(created_at);

-- Foreign key constraint
ALTER TABLE general_assessed_rom
    ADD CONSTRAINT fk_general_assessed_rom_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
