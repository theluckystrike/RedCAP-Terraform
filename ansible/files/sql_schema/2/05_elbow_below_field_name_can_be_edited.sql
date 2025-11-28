-- Table: elbow_below_field_name_can_be_edited
-- Generated: 2025-11-28T20:28:38.910784
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_below_field_name_can_be_edited (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_selected_locations_to_record_data_about" JSONB,  -- Selected locations to record data about
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_below_field_name_can_be_edited
CREATE INDEX IF NOT EXISTS idx_elbow_below_field_name_can_be_edited_encounter ON elbow_below_field_name_can_be_edited(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_below_field_name_can_be_edited_created ON elbow_below_field_name_can_be_edited(created_at);

-- Foreign key constraint
ALTER TABLE elbow_below_field_name_can_be_edited
    ADD CONSTRAINT fk_elbow_below_field_name_can_be_edited_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
