-- Table: shoulder_peripheral_nerves_around_shoulder
-- Generated: 2025-11-28T20:28:38.905293
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_peripheral_nerves_around_shoulder (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_peripheral_nerve_treatment_location" JSONB,  -- Peripheral nerve treatment location
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_peripheral_nerves_around_shoulder
CREATE INDEX IF NOT EXISTS idx_shoulder_peripheral_nerves_around_shoulder_encounter ON shoulder_peripheral_nerves_around_shoulder(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_peripheral_nerves_around_shoulder_created ON shoulder_peripheral_nerves_around_shoulder(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_peripheral_nerves_around_shoulder
    ADD CONSTRAINT fk_shoulder_peripheral_nerves_around_shoulder_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
