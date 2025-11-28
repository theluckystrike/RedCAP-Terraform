-- Table: shoulder_proximal_humerus
-- Generated: 2025-11-28T20:28:38.900773
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_proximal_humerus (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_proximal_humerus_diagnosis" JSONB,  -- Proximal humerus diagnosis
    "orth_sh_proximal_humerus_treatment" JSONB,  -- Proximal humerus treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_proximal_humerus
CREATE INDEX IF NOT EXISTS idx_shoulder_proximal_humerus_encounter ON shoulder_proximal_humerus(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_proximal_humerus_created ON shoulder_proximal_humerus(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_proximal_humerus
    ADD CONSTRAINT fk_shoulder_proximal_humerus_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
