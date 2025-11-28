-- Table: shoulder_fascia
-- Generated: 2025-11-28T20:28:38.901154
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_fascia (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_fascia_diagnosis" JSONB,  -- Fascia diagnosis
    "orth_sh_fascia_treatment" JSONB,  -- Fascia treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_fascia
CREATE INDEX IF NOT EXISTS idx_shoulder_fascia_encounter ON shoulder_fascia(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_fascia_created ON shoulder_fascia(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_fascia
    ADD CONSTRAINT fk_shoulder_fascia_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
