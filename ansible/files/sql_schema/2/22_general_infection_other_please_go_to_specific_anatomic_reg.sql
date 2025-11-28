-- Table: general_infection_other_please_go_to_specific_anatomic_reg
-- Generated: 2025-11-28T20:28:38.884558
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_infection_other_please_go_to_specific_anatomic_reg (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_infection_location" VARCHAR(500),  -- Infection Location
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_infection_other_please_go_to_specific_anatomic_reg
CREATE INDEX IF NOT EXISTS idx_general_infection_other_please_go_to_specific_anatomic_reg_encounter ON general_infection_other_please_go_to_specific_anatomic_reg(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_infection_other_please_go_to_specific_anatomic_reg_created ON general_infection_other_please_go_to_specific_anatomic_reg(created_at);

-- Foreign key constraint
ALTER TABLE general_infection_other_please_go_to_specific_anatomic_reg
    ADD CONSTRAINT fk_general_infection_other_please_go_to_specific_anatomic_reg_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
