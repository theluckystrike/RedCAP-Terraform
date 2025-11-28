-- Table: shoulder_latissimus_dorsi
-- Generated: 2025-11-28T20:28:38.900506
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_latissimus_dorsi (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_latissimus_dorsi_diagnosis" JSONB,  -- Latissimus dorsi diagnosis
    "orth_sh_lat_dorsi_treatment" JSONB,  -- Lat dorsi treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_latissimus_dorsi
CREATE INDEX IF NOT EXISTS idx_shoulder_latissimus_dorsi_encounter ON shoulder_latissimus_dorsi(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_latissimus_dorsi_created ON shoulder_latissimus_dorsi(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_latissimus_dorsi
    ADD CONSTRAINT fk_shoulder_latissimus_dorsi_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
