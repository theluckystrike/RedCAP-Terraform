-- Table: shoulder_shoulder_lag_signs
-- Generated: 2025-11-28T20:28:38.901889
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_shoulder_lag_signs (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_shoulder_lag_drop_arm" VARCHAR(50),  -- Shoulder lag drop arm
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_shoulder_lag_signs
CREATE INDEX IF NOT EXISTS idx_shoulder_shoulder_lag_signs_encounter ON shoulder_shoulder_lag_signs(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_shoulder_lag_signs_created ON shoulder_shoulder_lag_signs(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_shoulder_lag_signs
    ADD CONSTRAINT fk_shoulder_shoulder_lag_signs_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
