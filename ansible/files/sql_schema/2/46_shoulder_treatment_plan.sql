-- Table: shoulder_treatment_plan
-- Generated: 2025-11-28T20:28:38.903573
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_treatment_plan (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_tp_treatment_plan" JSONB,  -- Treatment Plan
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_treatment_plan
CREATE INDEX IF NOT EXISTS idx_shoulder_treatment_plan_encounter ON shoulder_treatment_plan(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_treatment_plan_created ON shoulder_treatment_plan(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_treatment_plan
    ADD CONSTRAINT fk_shoulder_treatment_plan_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
