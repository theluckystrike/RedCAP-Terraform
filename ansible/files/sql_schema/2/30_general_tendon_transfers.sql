-- Table: general_tendon_transfers
-- Generated: 2025-11-28T20:28:38.885467
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_tendon_transfers (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_tendon_recipient" VARCHAR(500),  -- Tendon Recipient
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_tendon_transfers
CREATE INDEX IF NOT EXISTS idx_general_tendon_transfers_encounter ON general_tendon_transfers(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_tendon_transfers_created ON general_tendon_transfers(created_at);

-- Foreign key constraint
ALTER TABLE general_tendon_transfers
    ADD CONSTRAINT fk_general_tendon_transfers_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
