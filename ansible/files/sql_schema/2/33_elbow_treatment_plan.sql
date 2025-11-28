-- Table: elbow_treatment_plan
-- Generated: 2025-11-28T20:28:38.915390
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_treatment_plan (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_tp_primary_revision" VARCHAR(50),  -- Primary/Revision
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_treatment_plan
CREATE INDEX IF NOT EXISTS idx_elbow_treatment_plan_encounter ON elbow_treatment_plan(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_treatment_plan_created ON elbow_treatment_plan(created_at);

-- Foreign key constraint
ALTER TABLE elbow_treatment_plan
    ADD CONSTRAINT fk_elbow_treatment_plan_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
