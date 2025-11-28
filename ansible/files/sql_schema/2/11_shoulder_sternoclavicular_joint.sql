-- Table: shoulder_sternoclavicular_joint
-- Generated: 2025-11-28T20:28:38.898716
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_sternoclavicular_joint (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_sternoclavicular_joint_diagnosis" JSONB,  -- Sternoclavicular joint diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_sternoclavicular_joint
CREATE INDEX IF NOT EXISTS idx_shoulder_sternoclavicular_joint_encounter ON shoulder_sternoclavicular_joint(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_sternoclavicular_joint_created ON shoulder_sternoclavicular_joint(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_sternoclavicular_joint
    ADD CONSTRAINT fk_shoulder_sternoclavicular_joint_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
