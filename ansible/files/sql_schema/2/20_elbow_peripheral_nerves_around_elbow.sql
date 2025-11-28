-- Table: elbow_peripheral_nerves_around_elbow
-- Generated: 2025-11-28T20:28:38.913635
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_peripheral_nerves_around_elbow (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_peripheral_nerve_around_elbow_diagnosis" JSONB,  -- Peripheral nerve around elbow diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_peripheral_nerves_around_elbow
CREATE INDEX IF NOT EXISTS idx_elbow_peripheral_nerves_around_elbow_encounter ON elbow_peripheral_nerves_around_elbow(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_peripheral_nerves_around_elbow_created ON elbow_peripheral_nerves_around_elbow(created_at);

-- Foreign key constraint
ALTER TABLE elbow_peripheral_nerves_around_elbow
    ADD CONSTRAINT fk_elbow_peripheral_nerves_around_elbow_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
