-- Table: shoulder_document_builder
-- Generated: 2025-11-28T20:28:38.898030
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_document_builder (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_first_visit" VARCHAR(50),  -- First visit
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_document_builder
CREATE INDEX IF NOT EXISTS idx_shoulder_document_builder_encounter ON shoulder_document_builder(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_document_builder_created ON shoulder_document_builder(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_document_builder
    ADD CONSTRAINT fk_shoulder_document_builder_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
