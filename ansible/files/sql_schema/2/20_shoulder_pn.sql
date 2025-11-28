-- Table: shoulder_pn
-- Generated: 2025-11-28T20:28:38.899980
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_pn (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_peripheral_nerve_around_shoulder_girdle_diagnosis" JSONB,  -- Peripheral nerve around shoulder girdle diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_pn
CREATE INDEX IF NOT EXISTS idx_shoulder_pn_encounter ON shoulder_pn(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_pn_created ON shoulder_pn(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_pn
    ADD CONSTRAINT fk_shoulder_pn_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
