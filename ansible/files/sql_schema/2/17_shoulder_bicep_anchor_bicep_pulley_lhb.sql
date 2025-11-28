-- Table: shoulder_bicep_anchor_bicep_pulley_lhb
-- Generated: 2025-11-28T20:28:38.899596
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_bicep_anchor_bicep_pulley_lhb (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_bicep_anchor_11_to_1_oclock_diagnosis" JSONB,  -- Biceps anchor 11 to 1 oclock diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_bicep_anchor_bicep_pulley_lhb
CREATE INDEX IF NOT EXISTS idx_shoulder_bicep_anchor_bicep_pulley_lhb_encounter ON shoulder_bicep_anchor_bicep_pulley_lhb(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_bicep_anchor_bicep_pulley_lhb_created ON shoulder_bicep_anchor_bicep_pulley_lhb(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_bicep_anchor_bicep_pulley_lhb
    ADD CONSTRAINT fk_shoulder_bicep_anchor_bicep_pulley_lhb_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
