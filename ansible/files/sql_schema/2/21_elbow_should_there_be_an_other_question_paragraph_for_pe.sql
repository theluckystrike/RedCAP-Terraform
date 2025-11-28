-- Table: elbow_should_there_be_an_other_question_paragraph_for_pe
-- Generated: 2025-11-28T20:28:38.913743
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_should_there_be_an_other_question_paragraph_for_pe (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_olecranon_diagnosis" JSONB,  -- Olecranon diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_should_there_be_an_other_question_paragraph_for_pe
CREATE INDEX IF NOT EXISTS idx_elbow_should_there_be_an_other_question_paragraph_for_pe_encounter ON elbow_should_there_be_an_other_question_paragraph_for_pe(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_should_there_be_an_other_question_paragraph_for_pe_created ON elbow_should_there_be_an_other_question_paragraph_for_pe(created_at);

-- Foreign key constraint
ALTER TABLE elbow_should_there_be_an_other_question_paragraph_for_pe
    ADD CONSTRAINT fk_elbow_should_there_be_an_other_question_paragraph_for_pe_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
