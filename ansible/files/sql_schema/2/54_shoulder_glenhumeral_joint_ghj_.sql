-- Table: shoulder_glenhumeral_joint_ghj_
-- Generated: 2025-11-28T20:28:38.905073
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_glenhumeral_joint_ghj_ (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_ghj_treatment" JSONB,  -- GHJ treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_glenhumeral_joint_ghj_
CREATE INDEX IF NOT EXISTS idx_shoulder_glenhumeral_joint_ghj__encounter ON shoulder_glenhumeral_joint_ghj_(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_glenhumeral_joint_ghj__created ON shoulder_glenhumeral_joint_ghj_(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_glenhumeral_joint_ghj_
    ADD CONSTRAINT fk_shoulder_glenhumeral_joint_ghj__encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
