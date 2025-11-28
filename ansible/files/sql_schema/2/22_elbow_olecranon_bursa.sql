-- Table: elbow_olecranon_bursa
-- Generated: 2025-11-28T20:28:38.913863
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_olecranon_bursa (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_olecranon_bursa_diagnosis" JSONB,  -- Olecranon bursa diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_olecranon_bursa
CREATE INDEX IF NOT EXISTS idx_elbow_olecranon_bursa_encounter ON elbow_olecranon_bursa(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_olecranon_bursa_created ON elbow_olecranon_bursa(created_at);

-- Foreign key constraint
ALTER TABLE elbow_olecranon_bursa
    ADD CONSTRAINT fk_elbow_olecranon_bursa_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
