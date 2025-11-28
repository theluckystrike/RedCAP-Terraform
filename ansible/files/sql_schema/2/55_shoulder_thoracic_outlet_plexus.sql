-- Table: shoulder_thoracic_outlet_plexus
-- Generated: 2025-11-28T20:28:38.905187
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_thoracic_outlet_plexus (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_plexus_treatment" JSONB,  -- Plexus treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_thoracic_outlet_plexus
CREATE INDEX IF NOT EXISTS idx_shoulder_thoracic_outlet_plexus_encounter ON shoulder_thoracic_outlet_plexus(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_thoracic_outlet_plexus_created ON shoulder_thoracic_outlet_plexus(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_thoracic_outlet_plexus
    ADD CONSTRAINT fk_shoulder_thoracic_outlet_plexus_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
