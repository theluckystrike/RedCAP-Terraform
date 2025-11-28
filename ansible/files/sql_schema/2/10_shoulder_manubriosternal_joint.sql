-- Table: shoulder_manubriosternal_joint
-- Generated: 2025-11-28T20:28:38.898584
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_manubriosternal_joint (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_manubriosternal_joint_diagnosis" JSONB,  -- Manubriosternal joint diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_manubriosternal_joint
CREATE INDEX IF NOT EXISTS idx_shoulder_manubriosternal_joint_encounter ON shoulder_manubriosternal_joint(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_manubriosternal_joint_created ON shoulder_manubriosternal_joint(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_manubriosternal_joint
    ADD CONSTRAINT fk_shoulder_manubriosternal_joint_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
