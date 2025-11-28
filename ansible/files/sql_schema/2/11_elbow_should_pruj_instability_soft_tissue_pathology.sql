-- Table: elbow_should_pruj_instability_soft_tissue_pathology
-- Generated: 2025-11-28T20:28:38.911757
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_should_pruj_instability_soft_tissue_pathology (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_pruj_annular_ligament" JSONB,  -- PRUJ annular ligament
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_should_pruj_instability_soft_tissue_pathology
CREATE INDEX IF NOT EXISTS idx_elbow_should_pruj_instability_soft_tissue_pathology_encounter ON elbow_should_pruj_instability_soft_tissue_pathology(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_should_pruj_instability_soft_tissue_pathology_created ON elbow_should_pruj_instability_soft_tissue_pathology(created_at);

-- Foreign key constraint
ALTER TABLE elbow_should_pruj_instability_soft_tissue_pathology
    ADD CONSTRAINT fk_elbow_should_pruj_instability_soft_tissue_pathology_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
