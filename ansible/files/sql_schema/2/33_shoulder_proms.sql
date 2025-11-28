-- Table: shoulder_proms
-- Generated: 2025-11-28T20:28:38.901774
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_proms (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_proms_shoulder_rom_passive_flexion" VARCHAR(50),  -- Shoulder ROM passive flexion
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_proms
CREATE INDEX IF NOT EXISTS idx_shoulder_proms_encounter ON shoulder_proms(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_proms_created ON shoulder_proms(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_proms
    ADD CONSTRAINT fk_shoulder_proms_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
