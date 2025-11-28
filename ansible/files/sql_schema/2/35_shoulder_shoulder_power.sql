-- Table: shoulder_shoulder_power
-- Generated: 2025-11-28T20:28:38.901998
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_shoulder_power (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_shoulder_power_flexion" VARCHAR(50),  -- Shoulder power flexion
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_shoulder_power
CREATE INDEX IF NOT EXISTS idx_shoulder_shoulder_power_encounter ON shoulder_shoulder_power(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_shoulder_power_created ON shoulder_shoulder_power(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_shoulder_power
    ADD CONSTRAINT fk_shoulder_shoulder_power_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
