-- Table: shoulder_lhb
-- Generated: 2025-11-28T20:28:38.904909
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_lhb (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_lhb_treatment" JSONB,  -- LHB treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_lhb
CREATE INDEX IF NOT EXISTS idx_shoulder_lhb_encounter ON shoulder_lhb(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_lhb_created ON shoulder_lhb(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_lhb
    ADD CONSTRAINT fk_shoulder_lhb_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
