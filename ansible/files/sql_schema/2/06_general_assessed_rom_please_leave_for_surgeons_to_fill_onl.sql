-- Table: general_assessed_rom_please_leave_for_surgeons_to_fill_onl
-- Generated: 2025-11-28T20:28:38.881890
-- Fields: 8

CREATE TABLE IF NOT EXISTS general_assessed_rom_please_leave_for_surgeons_to_fill_onl (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_shoulder_flexion" VARCHAR(500),  -- Shoulder Flexion
    "dem_shoulder_flexion_3mo" VARCHAR(500),  -- Shoulder Flexion
    "dem_shoulder_flexion_6mo" VARCHAR(500),  -- Shoulder Flexion
    "dem_shoulder_flexion_12mo" VARCHAR(500),  -- Shoulder Flexion
    "dem_shoulder_flexion_24mo" VARCHAR(500),  -- Shoulder Flexion
    "dem_shoulder_flexion_36mo" VARCHAR(500),  -- Shoulder Flexion
    "dem_shoulder_flexion_5y" VARCHAR(500),  -- Shoulder Flexion
    "dem_shoulder_flexion_10y" VARCHAR(500),  -- Shoulder Flexion
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_assessed_rom_please_leave_for_surgeons_to_fill_onl
CREATE INDEX IF NOT EXISTS idx_general_assessed_rom_please_leave_for_surgeons_to_fill_onl_encounter ON general_assessed_rom_please_leave_for_surgeons_to_fill_onl(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_assessed_rom_please_leave_for_surgeons_to_fill_onl_created ON general_assessed_rom_please_leave_for_surgeons_to_fill_onl(created_at);

-- Foreign key constraint
ALTER TABLE general_assessed_rom_please_leave_for_surgeons_to_fill_onl
    ADD CONSTRAINT fk_general_assessed_rom_please_leave_for_surgeons_to_fill_onl_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
