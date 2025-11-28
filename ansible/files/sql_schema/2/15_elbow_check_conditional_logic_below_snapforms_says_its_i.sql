-- Table: elbow_check_conditional_logic_below_snapforms_says_its_i
-- Generated: 2025-11-28T20:28:38.913026
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_check_conditional_logic_below_snapforms_says_its_i (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_forearm_proximal_oblique_cord" JSONB,  -- Forearm proximal oblique cord
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_check_conditional_logic_below_snapforms_says_its_i
CREATE INDEX IF NOT EXISTS idx_elbow_check_conditional_logic_below_snapforms_says_its_i_encounter ON elbow_check_conditional_logic_below_snapforms_says_its_i(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_check_conditional_logic_below_snapforms_says_its_i_created ON elbow_check_conditional_logic_below_snapforms_says_its_i(created_at);

-- Foreign key constraint
ALTER TABLE elbow_check_conditional_logic_below_snapforms_says_its_i
    ADD CONSTRAINT fk_elbow_check_conditional_logic_below_snapforms_says_its_i_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
