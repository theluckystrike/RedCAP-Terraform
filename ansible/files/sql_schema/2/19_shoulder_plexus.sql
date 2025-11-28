-- Table: shoulder_plexus
-- Generated: 2025-11-28T20:28:38.899856
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_plexus (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_plexus_diagnosis" JSONB,  -- Plexus diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_plexus
CREATE INDEX IF NOT EXISTS idx_shoulder_plexus_encounter ON shoulder_plexus(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_plexus_created ON shoulder_plexus(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_plexus
    ADD CONSTRAINT fk_shoulder_plexus_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
