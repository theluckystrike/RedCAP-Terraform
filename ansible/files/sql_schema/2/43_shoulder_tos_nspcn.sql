-- Table: shoulder_tos_nspcn
-- Generated: 2025-11-28T20:28:38.902871
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_tos_nspcn (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_tos_signs" JSONB,  -- TOS signs
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_tos_nspcn
CREATE INDEX IF NOT EXISTS idx_shoulder_tos_nspcn_encounter ON shoulder_tos_nspcn(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_tos_nspcn_created ON shoulder_tos_nspcn(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_tos_nspcn
    ADD CONSTRAINT fk_shoulder_tos_nspcn_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
