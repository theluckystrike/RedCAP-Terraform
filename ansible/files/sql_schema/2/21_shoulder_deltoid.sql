-- Table: shoulder_deltoid
-- Generated: 2025-11-28T20:28:38.900122
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_deltoid (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_deltoid_diagnosis" JSONB,  -- Deltoid diagnosis
    "orth_sh_deltoid_treatment" JSONB,  -- Deltoid treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_deltoid
CREATE INDEX IF NOT EXISTS idx_shoulder_deltoid_encounter ON shoulder_deltoid(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_deltoid_created ON shoulder_deltoid(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_deltoid
    ADD CONSTRAINT fk_shoulder_deltoid_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
