-- Table: shoulder_muscle_power
-- Generated: 2025-11-28T20:28:38.902206
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_muscle_power (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_trapezius" VARCHAR(50),  -- Trapezius
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_muscle_power
CREATE INDEX IF NOT EXISTS idx_shoulder_muscle_power_encounter ON shoulder_muscle_power(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_muscle_power_created ON shoulder_muscle_power(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_muscle_power
    ADD CONSTRAINT fk_shoulder_muscle_power_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
