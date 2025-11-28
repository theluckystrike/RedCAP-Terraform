-- Table: shoulder_subacromial_subcoracoid_subdeltoid_sa_sc_sd_space
-- Generated: 2025-11-28T20:28:38.904541
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_subacromial_subcoracoid_subdeltoid_sa_sc_sd_space (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_sa_sc_sd_treatment" JSONB,  -- SA SC SD treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_subacromial_subcoracoid_subdeltoid_sa_sc_sd_space
CREATE INDEX IF NOT EXISTS idx_shoulder_subacromial_subcoracoid_subdeltoid_sa_sc_sd_space_encounter ON shoulder_subacromial_subcoracoid_subdeltoid_sa_sc_sd_space(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_subacromial_subcoracoid_subdeltoid_sa_sc_sd_space_created ON shoulder_subacromial_subcoracoid_subdeltoid_sa_sc_sd_space(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_subacromial_subcoracoid_subdeltoid_sa_sc_sd_space
    ADD CONSTRAINT fk_shoulder_subacromial_subcoracoid_subdeltoid_sa_sc_sd_space_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
