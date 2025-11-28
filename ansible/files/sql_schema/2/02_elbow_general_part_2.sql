-- Table: elbow_general_part_2_part_2
-- Generated: 2025-11-28T20:28:38.909231
-- Fields: 121

CREATE TABLE IF NOT EXISTS elbow_general_part_2_part_2 (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_ulna_diaphysis_bone_loss_extraarticular" TEXT,  -- Ulna diaphysis bone loss extraarticular
    "orth_el_ulna_diaphysis_sequelae_non_arthroplasty_implants" VARCHAR(50),  -- Ulna diaphysis sequelae non arthroplasty implants
    "orth_el_ulna_diaphysis_other" TEXT,  -- Ulna diaphysis other
    "orth_el_compartment_syndrome_type" JSONB,  -- Compartment syndrome type
    "orth_el_compartments_involved" TEXT,  -- Compartments involved
    "orth_el_fascia_infection_chronicity" VARCHAR(50),  -- Fascia infection chronicity
    "orth_el_fascia_infection_aetiology" VARCHAR(50),  -- Fascia infection aetiology
    "orth_el_fascia_infection_organism" JSONB,  -- Fascia infection organism
    "orth_el_fascia_other" TEXT,  -- Fascia other
    "orth_el_surgical_site_infection_chronicity" VARCHAR(50),  -- Surgical site infection chronicity
    "orth_el_surgical_site_infection_aetiology" VARCHAR(50),  -- Surgical site infection aetiology
    "orth_el_surgical_site_infection_organism" JSONB,  -- Surgical site infection organism
    "orth_el_infection_other_location" TEXT,  -- Infection other location
    "orth_el_infection_other_chronicity" VARCHAR(50),  -- Infection other chronicity
    "orth_el_infection_other_aetiology" VARCHAR(50),  -- Infection other aetiology
    "orth_el_infection_other_organism" JSONB,  -- Infection other organism
    "orth_el_other_pathology_diagnosis" TEXT,  -- Other pathology diagnosis
    "orth_el_symptoms" JSONB,  -- Symptoms
    "orth_el_date" DATE,  -- Today's Date
    "orth_el_lastname" VARCHAR(500),  -- Surname
    "orth_el_givenname" VARCHAR(500),  -- First Name
    "orth_el_dateofbirth" DATE,  -- Date of Birth
    "orth_el_email_pt" VARCHAR(255),  -- Email
    "orth_el_mobile_pt" VARCHAR(500),  -- Mobile Number
    "orth_el_mainsport" VARCHAR(500),  -- Main Sport
    "orth_el_mainsportgrade" VARCHAR(50),  -- Main Sport Grade
    "orth_el_date_of_operation" DATE,  -- 
    "orth_el_uh_rc_ur_rc_elbow_arthroplasty_sequelae_subtypes" VARCHAR(50),  -- Ulnohumeral / Radiocapitellar Articulations ELBOW ARTHROPLAS
    "orth_el_uh_rc_ur_rc_elbow_arthroplasty_sequelae_bone_pathology_" VARCHAR(50),  -- Ulnohumeral / Radiocapitellar Articulations ELBOW ARTHROPLAS
    "orth_el_uh_rc_ur_rc_elbow_arthroplasty_sequelae_bone_pathology_" VARCHAR(50),  -- Ulnohumeral / Radiocapitellar ELBOW ARTHROPLASTY SEQUELAE Bo
    "orth_el_uh_rc_ur_rc_elbow_arthroplasty_sequelae_bone_pathology_" VARCHAR(500),  -- Ulnohumeral / Radiocapitellar ELBOW ARTHROPLASTY SEQUELAE Bo
    "orth_el_olecranon_fracture_fracture_sequelae_deformity_options_" VARCHAR(50),  -- Olecranon FRACTURE / FRACTURE SEQUELAE / DEFORMITY OPTIONS S
    "orth_el_olecranon_fracture_fracture_sequelae_deformity_options_" TEXT,  -- Olecranon FRACTURE / FRACTURE SEQUELAE / DEFORMITY OPTIONS A
    "orth_el_olecranon_fracture_fracture_sequelae_deformity_options_" VARCHAR(500),  -- Olecranon FRACTURE / FRACTURE SEQUELAE / DEFORMITY OPTIONS A
    "orth_el_olecranon_fracture_fracture_sequelae_deformity_options_" VARCHAR(500),  -- Olecranon FRACTURE / FRACTURE SEQUELAE / DEFORMITY OPTIONS o
    "orth_el_olecranon_fracture_fracture_sequelae_deformity_options_" VARCHAR(50),  -- Olecranon Fracture Open Grade
    "orth_el_coronoid_process_fracture_fracture_sequelae_deformity_o" VARCHAR(50),  -- Coronoid Process FRACTURE / FRACTURE SEQUELAE / DEFORMITY OP
    "orth_el_coronoid_process_fracture_fracture_sequelae_deformity_o" TEXT,  -- Coronoid Process FRACTURE / FRACTURE SEQUELAE / DEFORMITY OP
    "orth_el_coronoid_process_fracture_fracture_sequelae_deformity_o" VARCHAR(500),  -- Coronoid Process FRACTURE / FRACTURE SEQUELAE / DEFORMITY OP
    "orth_el_coronoid_process_fracture_fracture_sequelae_deformity_o" TEXT,  -- Coronoid Process FRACTURE / FRACTURE SEQUELAE / DEFORMITY OP
    "orth_el_coronoid_process_fracture_fracture_sequelae_deformity_o" VARCHAR(500),  -- Coronoid Process FRACTURE / FRACTURE SEQUELAE / DEFORMITY OP
    "orth_el_coronoid_process_fracture_fracture_sequelae_deformity_o" VARCHAR(500),  -- Coronoid Process FRACTURE / FRACTURE SEQUELAE / DEFORMITY OP
    "orth_el_radial_head_fracture_fracture_sequelae_deformity_option" VARCHAR(50),  -- Radial Head / Neck FRACTURE / FRACTURE SEQUELAE / DEFORMITY 
    "orth_el_radial_head_fracture_fracture_sequelae_deformity_option" TEXT,  -- Radial Head / Neck FRACTURE / FRACTURE SEQUELAE / DEFORMITY 
    "orth_el_radial_head_fracture_fracture_sequelae_deformity_option" VARCHAR(500),  -- Radial Head / Neck FRACTURE / FRACTURE SEQUELAE / DEFORMITY 
    "orth_el_radial_head_fracture_fracture_sequelae_deformity_option" VARCHAR(500),  -- Radial Head / Neck FRACTURE / FRACTURE SEQUELAE / DEFORMITY 
    "orth_el_radial_diaphysis_fracture_fracture_sequelae_deformity_o" VARCHAR(50),  -- Radial Diaphysis FRACTURE / FRACTURE SEQUELAE / DEFORMITY OP
    "orth_el_radial_diaphysis_fracture_fracture_sequelae_deformity_o" TEXT,  -- Radial Diaphysis FRACTURE / FRACTURE SEQUELAE / DEFORMITY OP
    "orth_el_radial_diaphysis_fracture_fracture_sequelae_deformity_o" VARCHAR(500),  -- Radial Diaphysis FRACTURE / FRACTURE SEQUELAE / DEFORMITY OP
    "orth_el_radial_diaphysis_fracture_fracture_sequelae_deformity_o" VARCHAR(500),  -- Radial Diaphysis FRACTURE / FRACTURE SEQUELAE / DEFORMITY OP
    "orth_el_ulna_diaphysis_fracture_fracture_sequelae_deformity_opt" VARCHAR(50),  -- Ulna Diaphysis FRACTURE / FRACTURE SEQUELAE / DEFORMITY OPTI
    "orth_el_ulna_diaphysis_fracture_fracture_sequelae_deformity_opt" TEXT,  -- Ulna Diaphysis FRACTURE / FRACTURE SEQUELAE / DEFORMITY OPTI
    "orth_el_ulna_diaphysis_fracture_fracture_sequelae_deformity_opt" VARCHAR(500),  -- Ulna Diaphysis FRACTURE / FRACTURE SEQUELAE / DEFORMITY OPTI
    "orth_el_ulna_diaphysis_fracture_fracture_sequelae_deformity_opt" VARCHAR(500),  -- Ulna Diaphysis FRACTURE / FRACTURE SEQUELAE / DEFORMITY OPTI
    "orth_el_primary_surgeon_for_revision" VARCHAR(50),  -- Who performed the primary surgery for the revision case you 
    "orth_el_intention" VARCHAR(50),  -- Intention
    "orth_el_multistage_stage" VARCHAR(50),  -- Multistage stage
    "orth_el_approach" JSONB,  -- Approach
    "orth_el_guidance" JSONB,  -- Guidance
    "orth_el_location_elbow_tx" JSONB,  -- Treated Regions
    "orth_el_median_nerve_elbow_lacertus_treatment" JSONB,  -- Median nerve elbow / lacertus - treatment
    "orth_el_median_nerve_elbow_lacertus_decompression_technique" JSONB,  -- Median nerve elbow / lacertus - decompression technique
    "orth_el_ulnar_nerve_at_elbow_cubital_tunnel_treatment" JSONB,  -- Ulnar nerve at elbow / cubital tunnel - treatment
    "orth_el_ulnar_nerve_at_elbow_cubital_tunnel_decompression_techn" JSONB,  -- Ulnar nerve at elbow / cubital tunnel - decompression techni
    "orth_el_additional_treatment_notes" TEXT,  -- Additional treatment notes (please complete if selected 'Oth
    "orth_el_date_elbow_3mo" DATE,  -- Today's Date
    "orth_el_lastname_elbow_3mo" VARCHAR(500),  -- Surname
    "orth_el_givenname_elbow_3mo" VARCHAR(500),  -- First Name
    "orth_el_dateofbirth_elbow_3mo" DATE,  -- Date of Birth
    "orth_el_email_pt_elbow_3mo" VARCHAR(255),  -- Email
    "orth_el_mobile_pt_elbow_3mo" VARCHAR(500),  -- Mobile Number
    "orth_el_mainsport_elbow_3mo" VARCHAR(500),  -- Main Sport
    "orth_el_mainsportgrade_elbow_3mo" VARCHAR(50),  -- Main Sport Grade
    "orth_el_date_elbow_6mo" DATE,  -- Today's Date
    "orth_el_lastname_elbow_6mo" VARCHAR(500),  -- Surname
    "orth_el_givenname_elbow_6mo" VARCHAR(500),  -- First Name
    "orth_el_dateofbirth_elbow_6mo" DATE,  -- Date of Birth
    "orth_el_email_pt_elbow_6mo" VARCHAR(255),  -- Email
    "orth_el_mobile_pt_elbow_6mo" VARCHAR(500),  -- Mobile Number
    "orth_el_mainsport_elbow_6mo" VARCHAR(500),  -- Main Sport
    "orth_el_mainsportgrade_elbow_6mo" VARCHAR(50),  -- Main Sport Grade
    "orth_el_date_elbow_12mo" DATE,  -- Today's Date
    "orth_el_lastname_elbow_12mo" VARCHAR(500),  -- Surname
    "orth_el_givenname_elbow_12mo" VARCHAR(500),  -- First Name
    "orth_el_dateofbirth_elbow_12mo" DATE,  -- Date of Birth
    "orth_el_email_pt_elbow_12mo" VARCHAR(255),  -- Email
    "orth_el_mobile_pt_elbow_12mo" VARCHAR(500),  -- Mobile Number
    "orth_el_mainsport_elbow_12mo" VARCHAR(500),  -- Main Sport
    "orth_el_mainsportgrade_elbow_12mo" VARCHAR(50),  -- Main Sport Grade
    "orth_el_date_elbow_24mo" DATE,  -- Today's Date
    "orth_el_lastname_elbow_24mo" VARCHAR(500),  -- Surname
    "orth_el_givenname_elbow_24mo" VARCHAR(500),  -- First Name
    "orth_el_dateofbirth_elbow_24mo" DATE,  -- Date of Birth
    "orth_el_email_pt_elbow_24mo" VARCHAR(255),  -- Email
    "orth_el_mobile_pt_elbow_24mo" VARCHAR(500),  -- Mobile Number
    "orth_el_mainsport_elbow_24mo" VARCHAR(500),  -- Main Sport
    "orth_el_mainsportgrade_elbow_24mo" VARCHAR(50),  -- Main Sport Grade
    "orth_el_date_elbow_36mo" DATE,  -- Today's Date
    "orth_el_lastname_elbow_36mo" VARCHAR(500),  -- Surname
    "orth_el_givenname_elbow_36mo" VARCHAR(500),  -- First Name
    "orth_el_dateofbirth_elbow_36mo" DATE,  -- Date of Birth
    "orth_el_email_pt_elbow_36mo" VARCHAR(255),  -- Email
    "orth_el_mobile_pt_elbow_36mo" VARCHAR(500),  -- Mobile Number
    "orth_el_mainsport_elbow_36mo" VARCHAR(500),  -- Main Sport
    "orth_el_mainsportgrade_elbow_36mo" VARCHAR(50),  -- Main Sport Grade
    "orth_el_date_elbow_5y" DATE,  -- Today's Date
    "orth_el_lastname_elbow_5y" VARCHAR(500),  -- Surname
    "orth_el_givenname_elbow_5y" VARCHAR(500),  -- First Name
    "orth_el_dateofbirth_elbow_5y" DATE,  -- Date of Birth
    "orth_el_email_pt_elbow_5y" VARCHAR(255),  -- Email
    "orth_el_mobile_pt_elbow_5y" VARCHAR(500),  -- Mobile Number
    "orth_el_mainsport_elbow_5y" VARCHAR(500),  -- Main Sport
    "orth_el_mainsportgrade_elbow_5y" VARCHAR(50),  -- Main Sport Grade
    "orth_el_date_elbow_10y" DATE,  -- Today's Date
    "orth_el_lastname_elbow_10y" VARCHAR(500),  -- Surname
    "orth_el_givenname_elbow_10y" VARCHAR(500),  -- First Name
    "orth_el_dateofbirth_elbow_10y" DATE,  -- Date of Birth
    "orth_el_email_pt_elbow_10y" VARCHAR(255),  -- Email
    "orth_el_mobile_pt_elbow_10y" VARCHAR(500),  -- Mobile Number
    "orth_el_mainsport_elbow_10y" VARCHAR(500),  -- Main Sport
    "orth_el_mainsportgrade_elbow_10y" VARCHAR(50),  -- Main Sport Grade
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_general_part_2_part_2
CREATE INDEX IF NOT EXISTS idx_elbow_general_part_2_part_2_encounter ON elbow_general_part_2_part_2(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_general_part_2_part_2_created ON elbow_general_part_2_part_2(created_at);

-- Foreign key constraint
ALTER TABLE elbow_general_part_2_part_2
    ADD CONSTRAINT fk_elbow_general_part_2_part_2_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;
