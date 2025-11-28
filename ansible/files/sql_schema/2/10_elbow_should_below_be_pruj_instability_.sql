-- Table: elbow_should_below_be_pruj_instability_
-- Generated: 2025-11-28T20:28:38.911441
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_should_below_be_pruj_instability_ (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_pruj_stability_instability" JSONB,  -- PRUJ stability instability
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_should_below_be_pruj_instability_
CREATE INDEX IF NOT EXISTS idx_elbow_should_below_be_pruj_instability__encounter ON elbow_should_below_be_pruj_instability_(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_should_below_be_pruj_instability__created ON elbow_should_below_be_pruj_instability_(created_at);

-- Foreign key constraint
ALTER TABLE elbow_should_below_be_pruj_instability_
    ADD CONSTRAINT fk_elbow_should_below_be_pruj_instability__encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
