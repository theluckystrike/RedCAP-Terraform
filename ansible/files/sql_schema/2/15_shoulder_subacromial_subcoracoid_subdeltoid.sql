-- Table: shoulder_subacromial_subcoracoid_subdeltoid
-- Generated: 2025-11-28T20:28:38.899248
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_subacromial_subcoracoid_subdeltoid (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_subacromial_subcoracoid_subdeltoid_space_diagnosis" JSONB,  -- Subacromial subcoracoid subdeltoid space diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_subacromial_subcoracoid_subdeltoid
CREATE INDEX IF NOT EXISTS idx_shoulder_subacromial_subcoracoid_subdeltoid_encounter ON shoulder_subacromial_subcoracoid_subdeltoid(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_subacromial_subcoracoid_subdeltoid_created ON shoulder_subacromial_subcoracoid_subdeltoid(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_subacromial_subcoracoid_subdeltoid
    ADD CONSTRAINT fk_shoulder_subacromial_subcoracoid_subdeltoid_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
