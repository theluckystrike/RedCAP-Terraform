-- Table: shoulder_biceps_anchor
-- Generated: 2025-11-28T20:28:38.904728
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_biceps_anchor (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_biceps_anchor_treatment" JSONB,  -- Biceps anchor treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_biceps_anchor
CREATE INDEX IF NOT EXISTS idx_shoulder_biceps_anchor_encounter ON shoulder_biceps_anchor(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_biceps_anchor_created ON shoulder_biceps_anchor(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_biceps_anchor
    ADD CONSTRAINT fk_shoulder_biceps_anchor_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
