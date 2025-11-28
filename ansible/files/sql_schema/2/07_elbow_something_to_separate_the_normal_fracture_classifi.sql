-- Table: elbow_something_to_separate_the_normal_fracture_classifi
-- Generated: 2025-11-28T20:28:38.911073
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_something_to_separate_the_normal_fracture_classifi (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_distal_humerus_fracture_classification_adult_ao" VARCHAR(50),  -- Distal humerus fracture classification adult AO
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_something_to_separate_the_normal_fracture_classifi
CREATE INDEX IF NOT EXISTS idx_elbow_something_to_separate_the_normal_fracture_classifi_encounter ON elbow_something_to_separate_the_normal_fracture_classifi(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_something_to_separate_the_normal_fracture_classifi_created ON elbow_something_to_separate_the_normal_fracture_classifi(created_at);

-- Foreign key constraint
ALTER TABLE elbow_something_to_separate_the_normal_fracture_classifi
    ADD CONSTRAINT fk_elbow_something_to_separate_the_normal_fracture_classifi_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
