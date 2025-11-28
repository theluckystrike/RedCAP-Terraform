-- Table: elbow_ulnohumeral_and_radiocapitellar_joint_edit_branchi
-- Generated: 2025-11-28T20:28:38.911192
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_ulnohumeral_and_radiocapitellar_joint_edit_branchi (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_ulnohumeral_and_radiocapitellar_joint_diagnosis" JSONB,  -- Ulnohumeral and radiocapitellar joint diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_ulnohumeral_and_radiocapitellar_joint_edit_branchi
CREATE INDEX IF NOT EXISTS idx_elbow_ulnohumeral_and_radiocapitellar_joint_edit_branchi_encounter ON elbow_ulnohumeral_and_radiocapitellar_joint_edit_branchi(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_ulnohumeral_and_radiocapitellar_joint_edit_branchi_created ON elbow_ulnohumeral_and_radiocapitellar_joint_edit_branchi(created_at);

-- Foreign key constraint
ALTER TABLE elbow_ulnohumeral_and_radiocapitellar_joint_edit_branchi
    ADD CONSTRAINT fk_elbow_ulnohumeral_and_radiocapitellar_joint_edit_branchi_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
