-- Table: elbow_ceo_ecrb
-- Generated: 2025-11-28T20:28:38.913404
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_ceo_ecrb (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_ceo_ecrb_diagnosis" JSONB,  -- CEO ECRB diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_ceo_ecrb
CREATE INDEX IF NOT EXISTS idx_elbow_ceo_ecrb_encounter ON elbow_ceo_ecrb(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_ceo_ecrb_created ON elbow_ceo_ecrb(created_at);

-- Foreign key constraint
ALTER TABLE elbow_ceo_ecrb
    ADD CONSTRAINT fk_elbow_ceo_ecrb_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
