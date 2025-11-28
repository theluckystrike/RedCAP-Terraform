-- Complete Database Schema
-- Version: 2
-- Generated: 2025-11-28T20:28:38.925609
-- Total Tables: 134

-- Main Encounters Table (Master Record)
-- Links all specialty-specific tables together

CREATE TABLE IF NOT EXISTS encounters (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) UNIQUE NOT NULL,  -- Format: YYYYMMDD_PatientID
    patient_id VARCHAR(50) NOT NULL,
    processing_date DATE NOT NULL,
    encounter_date DATE,
    encounter_type VARCHAR(50),  -- first_visit, follow_up, surgery, post_op
    is_first_visit BOOLEAN DEFAULT TRUE,
    prior_encounter_id VARCHAR(100),  -- Link to previous encounter
    schema_version VARCHAR(20) DEFAULT '1.0',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_prior_encounter 
        FOREIGN KEY (prior_encounter_id) 
        REFERENCES encounters(encounter_id)
);

-- Indexes for encounters table
CREATE INDEX IF NOT EXISTS idx_encounters_patient ON encounters(patient_id);
CREATE INDEX IF NOT EXISTS idx_encounters_date ON encounters(encounter_date);
CREATE INDEX IF NOT EXISTS idx_encounters_processing ON encounters(processing_date);
CREATE INDEX IF NOT EXISTS idx_encounters_prior ON encounters(prior_encounter_id);
CREATE INDEX IF NOT EXISTS idx_encounters_type ON encounters(encounter_type);



-- Main Encounters Table (Master Record)
-- Links all specialty-specific tables together

CREATE TABLE IF NOT EXISTS encounters (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) UNIQUE NOT NULL,  -- Format: YYYYMMDD_PatientID
    patient_id VARCHAR(50) NOT NULL,
    processing_date DATE NOT NULL,
    encounter_date DATE,
    encounter_type VARCHAR(50),  -- first_visit, follow_up, surgery, post_op
    is_first_visit BOOLEAN DEFAULT TRUE,
    prior_encounter_id VARCHAR(100),  -- Link to previous encounter
    schema_version VARCHAR(20) DEFAULT '1.0',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_prior_encounter 
        FOREIGN KEY (prior_encounter_id) 
        REFERENCES encounters(encounter_id)
);

-- Indexes for encounters table
CREATE INDEX IF NOT EXISTS idx_encounters_patient ON encounters(patient_id);
CREATE INDEX IF NOT EXISTS idx_encounters_date ON encounters(encounter_date);
CREATE INDEX IF NOT EXISTS idx_encounters_processing ON encounters(processing_date);
CREATE INDEX IF NOT EXISTS idx_encounters_prior ON encounters(prior_encounter_id);
CREATE INDEX IF NOT EXISTS idx_encounters_type ON encounters(encounter_type);



-- Table: demographics_part_1_part_1
-- Generated: 2025-11-28T20:28:38.873493
-- Fields: 250

CREATE TABLE IF NOT EXISTS demographics_part_1_part_1 (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_record_id" VARCHAR(500),  -- Record ID
    "dem_mrn" TEXT,  -- Patient Hospital/Clinic Numbers
    "dem_sex" VARCHAR(50),  -- Sex
    "dem_email_2" VARCHAR(255),  -- Backup Email
    "dem_mobile" VARCHAR(500),  -- Mobile
    "dem_body_region" JSONB,  -- Body Region
    "dem_insurance_type" VARCHAR(50),  -- Insurance Type
    "dem_date" DATE,  -- Today's Date
    "dem_lastname" VARCHAR(500),  -- Surname
    "dem_givenname" VARCHAR(500),  -- First Name
    "dem_dateofbirth" DATE,  -- Date of Birth
    "dem_email_pt" VARCHAR(255),  -- Email
    "dem_mobile_pt" VARCHAR(500),  -- Mobile Number
    "dem_mainsport" VARCHAR(500),  -- Main Sport
    "dem_mainsportgrade" VARCHAR(50),  -- Main Sport Grade
    "dem_pain_vas" INTEGER,  -- How much pain in your shoulder do you have during your usual
    "dem_pain_rowe" DECIMAL,  -- Pain (Rowe)
    "dem_csmasss_sleep_q" VARCHAR(50),  -- Is your night's sleep disturbed by your shoulder?
    "dem_p_ases_sleep" VARCHAR(50),  -- Can you sleep on your affected shoulder comfortably
    "dem_p_ases_bra" VARCHAR(50),  -- Can you wash your back / fasten your bra?
    "dem_p_ases_coat" VARCHAR(50),  -- Can you put on your coat unassisted?
    "dem_p_ases_comb" VARCHAR(50),  -- Can you comb / wash your hair?
    "dem_p_ases_toilet" VARCHAR(50),  -- Can you use toilet tissue?
    "dem_p_ases_shelf" VARCHAR(50),  -- Can you reach a shelf over your head?
    "dem_p_ases_4kg" VARCHAR(50),  -- Can you lift 4 kilograms above the level of your shoulder?
    "dem_p_ases_throw" VARCHAR(50),  -- Can you throw a ball overhand?
    "dem_full_work" VARCHAR(50),  -- Does your shoulder allow you to work full time at your usual
    "dem_rtw" VARCHAR(50),  -- What work are you currently able to do (if not working-your 
    "dem_full_work_csmasss" DECIMAL,  -- Full Work CS/MASSS
    "dem_usual_sports" VARCHAR(50),  -- Does your shoulder allow you to do your usual sports?
    "dem_usual_sports_csmasss" DECIMAL,  -- Usual Sports CS/MASSS
    "dem_rts" VARCHAR(50),  -- Are you able to do your usual sports/activities?
    "dem_csmasss_comfortable_use" VARCHAR(50),  -- What level can you use your arm for painless activities?
    "dem_rowe_subjective_instability" VARCHAR(50),  -- Have you had a shoulder dislocation or do you feel apprehens
    "dem_abd_pic" TEXT,  -- Abduction
    "dem_p_abd" DECIMAL,  -- Give the range of motion of ABDUCTION (raising your arm to t
    "dem_abd_rowe" DECIMAL,  -- Abduction (Rowe)
    "dem_er_pic" TEXT,  -- (A) External rotation in Abduction and (B) External rotation
    "dem_p_aber" DECIMAL,  -- Give the range of motion of EXTERNAL ROTATION IN ABDUCTION (
    "dem_p_ader" DECIMAL,  -- Give the range of motion of EXTERNAL ROTATION IN ADDUCTION (
    "dem_ader_rowe" DECIMAL,  -- ADER (Rowe)
    "dem_ir_pic" TEXT,  -- Internal Rotation
    "dem_p_ir" DECIMAL,  -- Give the range of motion of INTERNAL ROTATION (reaching up y
    "dem_ir_rowe" DECIMAL,  -- IR (Rowe)
    "dem_rom_vas" DECIMAL,  -- Give the overall range of motion of your affected/operated s
    "dem_csmasss_strength" DECIMAL,  -- Give the overall strength of your affected/operated shoulder
    "dem_sane_stability" DECIMAL,  -- Give the overall stability of your affected/operated shoulde
    "dem_ssv" DECIMAL,  -- Give your affected/operated shoulder an overall mark out of 
    "dem_ssv_rowe" DECIMAL,  -- SSV (Rowe)
    "dem_total_ases" DECIMAL,  -- Total ASES
    "dem_total_csmasss" DECIMAL,  -- Total CS MASSS
    "dem_total_rowe" DECIMAL,  -- Total Rowe
    "dem_shoulder_extension" VARCHAR(500),  -- Shoulder Extension
    "dem_shoulder_abduction" VARCHAR(500),  -- Shoulder Abduction
    "dem_shoulder_er1" VARCHAR(500),  -- Shoulder External Rotation with elbow at the side (ER1)
    "dem_shoulder_er2" VARCHAR(500),  -- Shoulder External Rotation with arm abducted at 90° (ER1)
    "dem_shoulder_ir" VARCHAR(500),  -- Shoulder Internal Rotation
    "dem_pree1" DECIMAL,  -- How much pain in your ELBOW do you have when it is at its wo
    "dem_pree2" DECIMAL,  -- How much pain in your ELBOW do you have at rest?
    "dem_pree3" DECIMAL,  -- How much pain in your ELBOW do you have lifting a heavy obje
    "dem_pree4" DECIMAL,  -- How much pain in your ELBOW do you have when doing a task wi
    "dem_pree5" DECIMAL,  -- How often do you have pain in your elbow?
    "dem_mepimesss6" VARCHAR(50),  -- Rate the OVERALL pain in your elbow
    "dem_pree7" DECIMAL,  -- Can you comb hair?
    "dem_pree7_mepi" DECIMAL,  -- PREE7 to MEPI
    "dem_pree8" DECIMAL,  -- Can you eat with a fork or spoon?
    "dem_pree8_mepi" DECIMAL,  -- PREE8 to MEPI
    "dem_pree9" DECIMAL,  -- Can you pull a heavy object?
    "dem_pree10" DECIMAL,  -- Can you rise from a chair pushing with arm?
    "dem_pree11" DECIMAL,  -- Can you carry a 4kg object with your arm at your side?
    "dem_pree12" DECIMAL,  -- Can you throw a ball?
    "dem_pree13" DECIMAL,  -- Can you use a telephone?
    "dem_pree14" DECIMAL,  -- Can you do up buttons on a shirt?
    "dem_pree14_mepi" DECIMAL,  -- PREE14 to MEPI
    "dem_pree15" DECIMAL,  -- Can you wash your opposite armpit?
    "dem_pree16" DECIMAL,  -- Can you tie your shoelaces?
    "dem_pree16_mepi" DECIMAL,  -- PREE16 to MEPI
    "dem_pree17" DECIMAL,  -- Can you turn a doorknob and open a door?
    "dem_pree18" DECIMAL,  -- Can you do personal care activities (washing, dressing)?
    "dem_pree18_mepi" DECIMAL,  -- PREE18 to MEPI
    "dem_pree19" DECIMAL,  -- Can you you do household chores (cleaning, maintenance)?
    "dem_pree20" DECIMAL,  -- How much difficulty do you have with work?
    "dem_pree21" DECIMAL,  -- How much difficulty do you have with recreational activities
    "dem_pree22" VARCHAR(50),  -- Describe your current work
    "dem_pree23" VARCHAR(50),  -- Describe your current sports/activities
    "dem_elbow_flexex" DECIMAL,  -- Give the range of motion of FLEXION-EXTENSION (bending and s
    "dem_elbow_flexex_to_mepi_step1" DECIMAL,  -- Elbow FlexEx to MEPI Step1
    "dem_elbow_flexex_to_mepi_step2" DECIMAL,  -- Elbow FlexEx to MEPI Step1
    "dem_elbow_pronsup" DECIMAL,  -- Give the range of motion of PRONATION-SUPINATION (turning yo
    "dem_elbow_strength" DECIMAL,  -- Give the overall strength of your affected/operated elbow a 
    "dem_stability_sane" DECIMAL,  -- Give the overall stability of your affected/operated elbow a
    "dem_stability_sane_to_mepi" DECIMAL,  -- Stability SANE to MEPI
    "dem_pree_total" DECIMAL,  -- PREE (Total)
    "dem_mepi_total" DECIMAL,  -- MEPI (Total)
    "dem_sev" DECIMAL,  -- Give your affected/operated elbow an overall mark out of 100
    "dem_elbow_extension" VARCHAR(500),  -- Elbow Extension
    "dem_pronation" VARCHAR(500),  -- Pronation
    "dem_supination" VARCHAR(500),  -- Supination
    "dem_distal_humerus_fracture_fracture_sequelae_deformity_subtype" VARCHAR(50),  -- DISTAL HUMERUS FRACTURE / FRACTURE SEQUELAE / DEFORMITY Subt
    "dem_distal_humerus_fracture_classification_ao_pic" TEXT,  -- DISTAL HUMERUS FRACTURE Classification (AO)
    "dem_distal_humerus_fracture_classification_ao" VARCHAR(500),  -- DISTAL HUMERUS FRACTURE Classification (AO)
    "dem_distal_humerus_fracture_closed_open" VARCHAR(50),  -- Distal Humerus Fracture Closed/Open
    "dem_distal_humerus_fracture_fracture_sequelae_deformity_open_gr" VARCHAR(50),  -- Distal Humerus Fracture Open Grade
    "dem_distal_humerus_fracture_soft_tissue_status" TEXT,  -- Distal Humerus Fracture Soft Tissue Status
    "dem_distal_humerus_malunion" VARCHAR(500),  -- DISTAL HUMERUS malunion
    "dem_distal_humerus_pathological_fracture_description" VARCHAR(500),  -- DISTAL HUMERUS Pathological Fracture Description
    "dem_distal_humerus_periprosthetic_fracture_non_arthroplasty_typ" VARCHAR(500),  -- DISTAL HUMERUS Periprosthetic fracture - non arthroplasty ty
    "dem_distal_humerus_periprosthetic_fracture_arthroplasty" VARCHAR(500),  -- DISTAL HUMERUS Periprosthetic fracture - arthroplasty
    "dem_distal_humerus_bone_deformity_other_description" VARCHAR(500),  -- DISTAL HUMERUS Bone deformity (NOT fracture-related)
    "dem_distal_humerus_bone_defect" VARCHAR(500),  -- DISTAL HUMERUS BONE DEFECT
    "dem_distal_humerus_sequelae_related_to_non_arthroplasty_implant" JSONB,  -- DISTAL HUMERUS Sequelae related to non-arthroplasty implant
    "dem_distal_humerus_bone_tumour_classification" VARCHAR(50),  -- DISTAL HUMERUS BONE TUMOUR Classification
    "dem_distal_humerus_bone_tumour_malignancy" VARCHAR(50),  -- DISTAL HUMERUS BONE TUMOUR Malignancy
    "dem_distal_humerus_bone_infection_chronicity" VARCHAR(50),  -- DISTAL HUMERUS BONE INFECTION Chronicity
    "dem_distal_humerus_bone_infection_aetiology" VARCHAR(50),  -- DISTAL HUMERUS BONE INFECTION Aetiology
    "dem_distal_humerus_bone_infection_organsim" VARCHAR(50),  -- DISTAL HUMERUS BONE INFECTION Organsim
    "dem_ulnohumeral_radiocapitellar_or_ulnoradial_forearm_radiocapi" VARCHAR(50),  -- Ulnohumeral & Radiocapitellar Articulations INSTABILITY - ch
    "dem_ulnohumeral_radiocapitellar_or_ulnoradial_forearm_radiocapi" JSONB,  -- Ulnohumeral & Radiocapitellar Articulations INSTABILITY - Jo
    "dem_ulnohumeral_instability_type_direction_of_forearm_displacem" JSONB,  -- Ulnohumeral Instability type - direction of forearm displace
    "dem_ulnohumeral_radiocapitellar_articulations_instability_patho" JSONB,  -- Ulnohumeral + Radiocapitellar articulations instability path
    "dem_ulnohumeral_radiocapitellar_articulations_instability_soft_" JSONB,  -- Ulnohumeral + Radiocapitellar articulations instability soft
    "dem_rcl_instability_soft_tissue_pathology" JSONB,  -- RCL instability soft tissue pathology
    "dem_lucl_instability_soft_tissue_pathology" JSONB,  -- LUCL instability soft tissue pathology
    "dem_annular_ligament_instability_soft_tissue_pathology" JSONB,  -- Annular ligament instability soft tissue pathology
    "dem_anterior_band_mucl_instability_soft_tissue_pathology" JSONB,  -- Anterior band MUCL instability soft tissue pathology
    "dem_posterior_band_mucl_instability_soft_tissue_pathology" JSONB,  -- Posterior band MUCL instability soft tissue pathology
    "dem_anterior_capsule_instability_soft_tissue_pathology" JSONB,  -- Anterior capsule instability soft tissue pathology
    "dem_osborne_cotterill_ligament_instability_soft_tissue_patholog" JSONB,  -- Osborne-Cotterill ligament instability soft tissue pathology
    "dem_other_instability_soft_tissue_pathology" JSONB,  -- Other instability soft tissue pathology
    "dem_ulnohumeral_radiocapitellar_articulations_instability_acute" JSONB,  -- Ulnohumeral + Radiocapitellar articulations instability - ac
    "dem_ulnohumeral_radiocapitellar_articulations_instability_attri" JSONB,  -- Ulnohumeral + Radiocapitellar articulations instability - at
    "dem_distal_humerus_classification" VARCHAR(500),  -- Distal humerus classification
    "dem_radial_head_neck_classification" VARCHAR(500),  -- Radial head / neck classification
    "dem_coronoid_process_classification" VARCHAR(500),  -- Coronoid process classification
    "dem_olecranon_process_classification" VARCHAR(500),  -- Olecranon process classification
    "dem_other_bone_classification" VARCHAR(500),  -- Other bone classification
    "dem_uh_rc_ur_rc_arthropathy_type" VARCHAR(50),  -- Ulnohumeral / Radiocapitellar Articulations ARTHROPATHY Type
    "dem_uh_rc_ur_rc_arthropathy_joints_involved" JSONB,  -- Ulnohumeral / Radiocapitellar Articulations ARTHROPATHY Join
    "dem_uh_rc_ur_rc_arthropathy_bone_pathology_humerus" VARCHAR(50),  -- Ulnohumeral / Radiocapitellar Articulations ARTHROPATHY Bone
    "dem_uh_rc_ur_rc_arthropathy_bone_pathology_proximal_ulna" VARCHAR(50),  -- Ulnohumeral / Radiocapitellar Articulations ARTHROPATHY Bone
    "dem_uh_rc_ur_rc_arthropathy_bone_pathology_proximal_radius" VARCHAR(50),  -- Ulnohumeral / Radiocapitellar Articulations ARTHROPATHY Bone
    "dem_uh_rc_ur_rc_arthropathy_additional_diagnostic_pathological_" TEXT,  -- Ulnohumeral / Radiocapitellar ARTHROPATHY Additional Diagnos
    "dem_uh_rc_ur_rc_stiffness_joints" JSONB,  -- Ulnohumeral / Radiocapitellar Articulations STIFFNESS WITHOU
    "dem_uh_rc_ur_rc_stiffness_classification" JSONB,  -- Ulnohumeral / Radiocapitellar Articulations STIFFNESS WITHOU
    "dem_uh_rc_ur_rc_stiffness_additional_diagnostic_pathological_in" TEXT,  -- Ulnohumeral / Radiocapitellar Articulations STIFFNESS WITHOU
    "dem_elbow_and_forearm_articulations_impingement_type" JSONB,  -- Ulnohumeral / Radiocapitellar Articulations Impingement Type
    "dem_uh_rc_ur_rc_localised_articular_pathology_location" VARCHAR(500),  -- Ulnohumeral / Radiocapitellar Articulations LOCALISED ARTICU
    "dem_uh_rc_ur_rc_localised_articular_pathology_classification_ae" VARCHAR(50),  -- Ulnohumeral / Radiocapitellar Articulations LOCALISED ARTICU
    "dem_uh_rc_ur_rc_localised_articular_pathology_ocd_classificatio" TEXT,  -- Ulnohumeral / Radiocapitellar Articulations LOCALISED ARTICU
    "dem_uh_rc_ur_rc_localised_articular_pathology_ocd_classificatio" VARCHAR(50),  -- Ulnohumeral / Radiocapitellar Articulations LOCALISED ARTICU
    "dem_uh_rc_ur_rc_localised_articular_pathology_additional_diagno" TEXT,  -- Ulnohumeral / Radiocapitellar Articulations LOCALISED ARTICU
    "dem_uh_rc_ur_rc_septic_arthritis_location" VARCHAR(500),  -- Ulnohumeral / Radiocapitellar Articulations SEPTIC ARTHRITIS
    "dem_uh_rc_ur_rc_septic_arthritis_chronicity" VARCHAR(50),  -- Ulnohumeral / Radiocapitellar Articulations SEPTIC ARTHRITIS
    "dem_uh_rc_ur_rc_septic_arthritis_pathogenesis" VARCHAR(50),  -- Ulnohumeral / Radiocapitellar Articulations SEPTIC ARTHRITIS
    "dem_uh_rc_ur_rc_septic_arthritis_organism" VARCHAR(50),  -- Ulnohumeral / Radiocapitellar Articulations SEPTIC ARTHRITIS
    "dem_uh_rc_ur_rc_septic_arthritis_additional_diagnostic_patholog" TEXT,  -- Ulnohumeral / Radiocapitellar Articulations SEPTIC ARTHRITIS
    "dem_elbow_arthroplasty_sequelae_mayo_classification" VARCHAR(500),  -- ELBOW ARTHROPLASTY SEQUELAE Mayo Classification
    "dem_ulnohumeral_radiocapitellar_symptomatic_plica_location" JSONB,  -- Ulnohumeral / Radiocapitellar Symptomatic Plica Location
    "dem_ulnohumeral_radiocapitellar_sequelae_related_to_non_arthrop" JSONB,  -- Ulnohumeral / Radiocapitellar Sequelae related to non-arthro
    "dem_forearm_articulation_and_or_pruj_and_or_druj_instability_ty" VARCHAR(50),  -- Forearm articulation and/or PRUJ and/or DRUJ - instability t
    "dem_forearm_articulation_and_or_pruj_and_or_druj_instability_jo" JSONB,  -- Forearm articulation and/or PRUJ and/or DRUJ - instability -
    "dem_forearm_articulation_and_or_pruj_and_or_druj_ulnoradial_ins" JSONB,  -- Forearm articulation and/or PRUJ and/or DRUJ - ulnoradial in
    "dem_forearm_articulation_and_or_pruj_and_or_druj_instability_pa" JSONB,  -- Forearm articulation and/or PRUJ and/or DRUJ - instability p
    "dem_forearm_articulation_and_or_pruj_and_or_druj_instability_so" JSONB,  -- Forearm articulation and/or PRUJ and/or DRUJ - instability s
    "dem_quadrate_ligament_instability_soft_tissue_pathology" JSONB,  -- Quadrate ligament instability soft tissue pathology
    "dem_proximal_oblique_cord_instability_soft_tissue_pathology" JSONB,  -- Proximal oblique cord instability soft tissue pathology
    "dem_interosseus_membrane_instability_soft_tissue_pathology" JSONB,  -- Interosseus membrane instability soft tissue pathology
    "dem_distal_oblique_band_instability_soft_tissue_pathology" JSONB,  -- Distal oblique band instability soft tissue pathology
    "dem_druj_capsule_tfc_instability_soft_tissue_pathology" JSONB,  -- DRUJ capsule/TFC instability soft tissue pathology
    "dem_forearm_articulation_and_or_pruj_and_or_druj_acute_fracture" JSONB,  -- Forearm articulation and/or PRUJ and/or DRUJ - acute fractur
    "dem_forearm_articulation_and_or_pruj_and_or_druj_instability_bo" JSONB,  -- Forearm articulation and/or PRUJ and/or DRUJ - instability b
    "dem_forearm_articulation_and_or_pruj_and_or_druj_sequelae_relat" JSONB,  -- Forearm articulation and/or PRUJ and/or DRUJ Sequelae relate
    "dem_distal_biceps_tendon_tear_type_chronicity" VARCHAR(50),  -- DISTAL BICEPS TENDON Tear type - chronicity
    "dem_distal_biceps_tendon_tear_type_thickness" VARCHAR(50),  -- DISTAL BICEPS TENDON Tear type - thickness
    "dem_distal_biceps_tendon_sequelae_related_to_non_arthroplasty_i" JSONB,  -- DISTAL BICEPS TENDON - Sequelae related to non-arthroplasty 
    "dem_distal_triceps_tendon_tear_type_chronicity" VARCHAR(50),  -- DISTAL TRICEPS TENDON Tear type - chronicity
    "dem_distal_triceps_tendon_tear_type_thickness" VARCHAR(50),  -- DISTAL TRICEPS TENDON Tear type - thickness
    "dem_distal_triceps_tendon_sequelae_related_to_non_arthroplasty_" JSONB,  -- DISTAL TRICEPS TENDON - Sequelae related to non-arthroplasty
    "dem_common_extensor_origin_tear_type_chronicity" VARCHAR(50),  -- COMMON EXTENSOR ORIGIN Tear type - chronicity
    "dem_common_extensor_origin_tear_type_thickness" VARCHAR(50),  -- COMMON EXTENSOR ORIGIN Tear type - thickness
    "dem_common_extensor_origin_sequelae_related_to_non_arthroplasty" JSONB,  -- COMMON EXTENSOR ORIGIN - Sequelae related to non-arthroplast
    "dem_common_flexor_origin_tear_type_chronicity" VARCHAR(50),  -- COMMON FLEXOR ORIGIN Tear type - chronicity
    "dem_common_flexor_origin_tear_type_thickness" VARCHAR(50),  -- COMMON FLEXOR ORIGIN Tear type - thickness
    "dem_common_flexor_origin_sequelae_related_to_non_arthroplasty_i" JSONB,  -- COMMON FLEXOR ORIGIN - Sequelae related to non-arthroplasty 
    "dem_mechanical_neuropathy_nerve_location_involvement_aetiology_" VARCHAR(50),  -- Mechanical neuropathy - nerve location involvement / aetiolo
    "dem_nerve_dysfunction_classification_seddon_pic" TEXT,  -- Nerve Dysfunction Classification (Seddon) Davplast, CC BY-SA
    "dem_nerve_dysfunction_classification_seddon" VARCHAR(50),  -- Nerve Dysfunction Classification (Seddon)
    "dem_olecranon_fracture_closed_open" VARCHAR(50),  -- Olecranon Fracture Closed / Open
    "dem_olecranon_fracture_soft_tissue_status" TEXT,  -- Olecranon Fracture Soft Tissue Status
    "dem_olecranon_malunion" VARCHAR(500),  -- Olecranon malunion
    "dem_olecranon_pathological_fracture_excluding_stress_fracture" VARCHAR(500),  -- Olecranon pathological fracture (excluding stress fracture)
    "dem_olecranon_periprosthetic_fracture_non_arthroplasty" VARCHAR(500),  -- Olecranon periprosthetic fracture - non-arthroplasty
    "dem_olecranon_periprosthetic_fracture_arthroplasty" VARCHAR(500),  -- Olecranon periprosthetic fracture - arthroplasty
    "dem_olecranon_bone_deformity_not_fracture_related" VARCHAR(500),  -- Olecranon bone deformity (NOT fracture-related)
    "dem_olecranon_sequelae_related_to_non_arthroplasty_implant" JSONB,  -- OLECRANON - Sequelae related to non-arthroplasty implant
    "dem_olecranon_bone_tumour_classification" VARCHAR(50),  -- OLECRANON BONE TUMOUR Classification
    "dem_olecranon_bone_tumour_malignancy_source" VARCHAR(50),  -- OLECRANON BONE TUMOUR Malignancy Source
    "dem_olecranon_bone_infection_chronicity" VARCHAR(50),  -- OLECRANON BONE INFECTION Chronicity
    "dem_olecranon_bone_infection_aetiology" VARCHAR(50),  -- OLECRANON BONE INFECTION Aetiology
    "dem_olecranon_bone_infection_organsim" VARCHAR(50),  -- OLECRANON BONE INFECTION Organsim
    "dem_coronoid_process_fracture_closed_open" VARCHAR(50),  -- Coronoid Process Fracture Closed/Open
    "dem_coronoid_process_fracture_open_grade" VARCHAR(50),  -- Coronoid Process Fracture Open Grade
    "dem_coronoid_process_fracture_soft_tissue_status" TEXT,  -- Coronoid Process Fracture Soft Tissue Status
    "dem_coronoid_process_malunion" VARCHAR(500),  -- Coronoid Process malunion
    "dem_coronoid_process_pathological_fracture_excluding_stress_fra" VARCHAR(500),  -- Coronoid Process pathological fracture (excluding stress fra
    "dem_coronoid_process_periprosthetic_fracture_non_arthroplasty" VARCHAR(500),  -- Coronoid Process periprosthetic fracture - non-arthroplasty
    "dem_coronoid_process_periprosthetic_fracture_arthroplasty" VARCHAR(500),  -- Coronoid Process periprosthetic fracture - arthroplasty
    "dem_coronoid_process_arthroplasty_sequelae" JSONB,  -- CORONOID PROCESS ARTHROPLASTY SEQUELAE
    "dem_coronoid_process_arthroplasty_sequelae_loosening_radius_bon" VARCHAR(500),  -- Coronoid process arthroplasty sequelae - loosening - radius 
    "dem_coronoid_process_periprosthetic_acute_fracture_type" JSONB,  -- Coronoid Process periprosthetic acute fracture type
    "dem_coronoid_process_arthroplasty_sequelae_loosening_capitellum" VARCHAR(500),  -- Coronoid process arthroplasty sequelae - loosening - capitel
    "dem_coronoid_process_sequelae_related_to_non_arthroplasty_impla" JSONB,  -- CORONOID PROCESS Sequelae related to non-arthroplasty implan
    "dem_coronoid_process_bone_tumour_classification" VARCHAR(50),  -- CORONOID PROCESS BONE TUMOUR Classification
    "dem_coronoid_process_bone_tumour_malignancy_source" VARCHAR(50),  -- CORONOID PROCESS BONE TUMOUR Malignancy Source
    "dem_coronoid_process_bone_infection_chronicity" VARCHAR(50),  -- CORONOID PROCESS BONE INFECTION Chronicity
    "dem_coronoid_process_bone_infection_aetiology" VARCHAR(50),  -- CORONOID PROCESS BONE INFECTION Aetiology
    "dem_coronoid_process_bone_infection_organsim" VARCHAR(50),  -- CORONOID PROCESS BONE INFECTION Organsim
    "dem_radial_head_fracture_closed_open" VARCHAR(50),  -- Radial Head / Neck Fracture Closed / Open
    "dem_radial_head_fracture_open_grade" VARCHAR(50),  -- Radial Head / Neck Fracture Open Grade
    "dem_radial_head_neck_fracture" TEXT,  -- Radial Head / Neck Fracture Soft Tissue Status
    "dem_radial_head_malunion" VARCHAR(500),  -- Radial Head malunion
    "dem_radial_head_pathological_fracture_excluding_stress_fracture" VARCHAR(500),  -- Radial Head pathological fracture (excluding stress fracture
    "dem_radial_head_periprosthetic_fracture_non_arthroplasty" VARCHAR(500),  -- Radial Head Periprosthetic fracture - non-arthroplasty
    "dem_radial_head_periprosthetic_fracture_arthroplasty" VARCHAR(500),  -- Radial Head Periprosthetic fracture - arthroplasty
    "dem_radial_head_bone_deformity_not_fracture_related" VARCHAR(500),  -- Radial Head bone deformity (NOT fracture-related)
    "dem_radial_head_arthroplasty_sequelae" JSONB,  -- RADIAL HEAD ARTHROPLASTY SEQUELAE
    "dem_radial_head_arthroplasty_sequelae_loosening_radius_bone_pat" VARCHAR(500),  -- Radial Head arthroplasty sequelae - loosening - radius bone 
    "dem_radial_head_periprosthetic_acute_fracture_type" JSONB,  -- Radial Head periprosthetic acute fracture type
    "dem_radial_head_arthroplasty_sequelae_loosening_capitellum_bone" VARCHAR(500),  -- Radial Head arthroplasty sequelae - loosening - capitellum b
    "dem_radial_head_sequelae_related_to_non_arthroplasty_implant" JSONB,  -- RADIAL HEAD Sequelae related to non-arthroplasty implant
    "dem_radial_head_bone_tumour_classification" VARCHAR(50),  -- RADIAL HEAD BONE TUMOUR Classification
    "dem_radial_head_bone_tumour_malignancy_source" VARCHAR(50),  -- RADIAL HEAD BONE TUMOUR Malignancy Source
    "dem_radial_head_bone_infection_chronicity" VARCHAR(50),  -- RADIAL HEAD BONE INFECTION Chronicity
    "dem_radial_head_bone_infection_aetiology" VARCHAR(50),  -- RADIAL HEAD BONE INFECTION Aetiology
    "dem_radial_head_bone_infection_organsim" VARCHAR(50),  -- RADIAL HEAD BONE INFECTION Organsim
    "dem_radial_diaphysis_fracture_closed_open" VARCHAR(50),  -- Radial Diaphysis Fracture Closed/Open
    "dem_radial_diaphysis_fracture_open_grade" VARCHAR(50),  -- Radial Diaphysis Fracture Open Grade
    "dem_radial_diaphysis_fracture_soft_tissue_status" TEXT,  -- Radial Diaphysis Fracture Soft Tissue Status
    "dem_radial_diaphysis_malunion" VARCHAR(500),  -- Radial Diaphysis malunion
    "dem_radial_diaphysis_pathological_fracture_excluding_stress_fra" VARCHAR(500),  -- Radial Diaphysis pathological fracture (excluding stress fra
    "dem_radial_diaphysis_periprosthetic_fracture_non_arthroplasty" VARCHAR(500),  -- Radial Diaphysis Periprosthetic fracture - non-arthroplasty
    "dem_radial_diaphysis_periprosthetic_fracture_arthroplasty" VARCHAR(500),  -- Radial Diaphysis Periprosthetic fracture - arthroplasty
    "dem_radial_diaphysis_bone_deformity_not_fracture_related" VARCHAR(500),  -- Radial Diaphysis bone deformity (NOT fracture-related)
    "dem_radial_diaphysis_bone_defect_extra_articular" VARCHAR(500),  -- RADIAL DIAPHYSIS bone defect extra-articular
    "dem_radial_diaphysis_sequelae_related_to_non_arthroplasty_impla" JSONB,  -- RADIAL DIAPHYSIS Sequelae related to non-arthroplasty implan
    "dem_radial_diaphysis_bone_tumour_classification" VARCHAR(50),  -- RADIAL DIAPHYSIS BONE TUMOUR Classification
    "dem_radial_diaphysis_bone_tumour_malignancy_source" VARCHAR(50),  -- RADIAL DIAPHYSIS BONE TUMOUR Malignancy Source
    "dem_radial_diaphysis_bone_infection_chronicity" VARCHAR(50),  -- RADIAL DIAPHYSIS BONE INFECTION Chronicity
    "dem_radial_diaphysis_bone_infection_aetiology" VARCHAR(50),  -- RADIAL DIAPHYSIS BONE INFECTION Aetiology
    "dem_radial_diaphysis_bone_infection_organsim" VARCHAR(50),  -- RADIAL DIAPHYSIS BONE INFECTION Organsim
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for demographics_part_1_part_1
CREATE INDEX IF NOT EXISTS idx_demographics_part_1_part_1_encounter ON demographics_part_1_part_1(encounter_id);
CREATE INDEX IF NOT EXISTS idx_demographics_part_1_part_1_created ON demographics_part_1_part_1(created_at);

-- Foreign key constraint
ALTER TABLE demographics_part_1_part_1
    ADD CONSTRAINT fk_demographics_part_1_part_1_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_general_part_1_part_1
-- Generated: 2025-11-28T20:28:38.906854
-- Fields: 250

CREATE TABLE IF NOT EXISTS elbow_general_part_1_part_1 (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_patient_id" VARCHAR(500),  -- Patient ID
    "orth_el_first_name" VARCHAR(500),  -- First Name
    "orth_el_last_name" VARCHAR(500),  -- Last name
    "orth_el_date_of_birth" DATE,  -- Date of Birth
    "orth_el_email_address" VARCHAR(255),  -- Email address
    "orth_el_encounter_date" DATE,  -- Encounter date
    "orth_el_encounter_type" VARCHAR(50),  -- Encounter type
    "orth_el_add_in_background_informat" TEXT,  -- add in background information section here
    "orth_el_document_builder_goes_here" TEXT,  -- DOCUMENT BUILDER GOES HERE
    "orth_el_dist_humerus_fracture_sequelae_deformity_subtypes" JSONB,  -- Dist humerus fracture sequelae deformity subtypes
    "orth_el_distal_humerus_fracture_paediatric_ao" VARCHAR(50),  -- Distal humerus fracture paediatric AO
    "orth_el_distal_humerus_fracture_classification_other" TEXT,  -- Distal humerus fracture classification other
    "orth_el_distal_humerus_fracture_open_or_closed" VARCHAR(50),  -- Distal humerus fracture open or closed
    "orth_el_distal_humerus_fracture_open_grade_gustilo" VARCHAR(50),  -- Distal humerus fracture open grade Gustilo
    "orth_el_distal_humerus_deformity" TEXT,  -- Distal humerus deformity
    "orth_el_distal_humerus_tumour_pathology" VARCHAR(50),  -- Distal humerus tumour pathology
    "orth_el_distal_humerus_infection_chronicity" VARCHAR(50),  -- Distal humerus infection chronicity
    "orth_el_distal_humerus_infection_aetiology" VARCHAR(50),  -- Distal humerus infection aetiology
    "orth_el_distal_humerus_infection_organism" JSONB,  -- Distal humerus infection organism
    "orth_el_distal_humerus_bone_loss_extraarticular" TEXT,  -- Distal humerus bone loss extraarticular
    "orth_el_distal_humerus_sequelae_non_arthoplasty_implants" JSONB,  -- Distal humerus sequelae non arthroplasty implants
    "orth_el_distal_humerus_other" TEXT,  -- Distal humerus other
    "orth_el_uh_rc_synovial_fluid_volume" VARCHAR(50),  -- UH RC synovial fluid volume
    "orth_el_uh_rc_synovial_fluid_type" VARCHAR(50),  -- UH RC synovial fluid type
    "orth_el_uh_rc_synovium_anterior_compartment" JSONB,  -- UH RC synovium anterior compartment
    "orth_el_uh_rc_anterior_compartment_loose_bodies" VARCHAR(50),  -- UH RC anterior compartment loose bodies
    "orth_el_uh_rc_anterior_loose_bodies_type" VARCHAR(500),  -- UH RC anterior loose bodies type
    "orth_el_uh_rc_instability" VARCHAR(50),  -- UH RC instability
    "orth_el_uh_rc_instability_direction_signs" JSONB,  -- UH RC instability direction signs
    "orth_el_uh_rc_synovium_posterior_compartment" JSONB,  -- UH RC synovium posterior compartment
    "orth_el_uh_rc_posterior_compartment_loose_bodies" VARCHAR(50),  -- UH RC posterior compartment loose bodies
    "orth_el_uh_rc_posterior_loose_bodies_type" VARCHAR(500),  -- UH RC posterior loose bodies type
    "orth_el_uh_rc_capsule_volume" JSONB,  -- UH RC capsule volume
    "orth_el_uh_rc_capsule_quality" VARCHAR(50),  -- UH RC capsule quality
    "orth_el_uh_rc_instability_tissues_involved" JSONB,  -- UH RC instability tissues involved
    "orth_el_uh_rc_rcl" JSONB,  -- UH RC RCL
    "orth_el_uh_rc_lucl" JSONB,  -- UH RC LUCL
    "orth_el_uh_rc_annular_ligament" JSONB,  -- UH RC annular ligament
    "orth_el_uh_rc_ocl" JSONB,  -- UH RC OCL
    "orth_el_uh_rc_amucl" JSONB,  -- UH RC aMUCL
    "orth_el_uh_rc_pmucl" JSONB,  -- UH RC pMUCL
    "orth_el_uh_rc_anterior_capsule" JSONB,  -- UH RC anterior capsule
    "orth_el_uh_rc_posterior_capsule" JSONB,  -- UH RC posterior capsule
    "orth_el_uh_rc_instability_acute_fracture" JSONB,  -- UH RC instability acute fracture
    "orth_el_uh_rc_instability_attritional_bone_loss" JSONB,  -- UH RC instability attritional bone loss
    "orth_el_uh_rc_arthropathy_type" VARCHAR(50),  -- UH RC arthropathy type
    "orth_el_uh_rc_arthropathy_compartments_involved" JSONB,  -- UH RC arthropathy compartments involved
    "orth_el_uh_rc_arthropathy_severity" VARCHAR(50),  -- UH RC arthropathy severity
    "orth_el_uh_rc_stiffness_no_arthropathy_cause" JSONB,  -- UH RC stiffness no arthropathy cause
    "orth_el_uc_rc_stiffness_extraarticular" JSONB,  -- UC RC stiffness extraarticular
    "orth_el_uh_rc_stiffness_no_arthropathy_info" TEXT,  -- UH RC stiffness no arthropathy info
    "orth_el_uh_rc_impingement_no_arthropathy" JSONB,  -- UH RC impingement no arthropathy
    "orth_el_uh_rc_localised_articular_cartilage_locations" JSONB,  -- UH RC localised articular cartilage locations
    "orth_el_clac_aetiology" JSONB,  -- CLAC aetiology
    "orth_el_clac_location" TEXT,  -- CLAC location
    "orth_el_clac_depth" TEXT,  -- CLAC depth
    "orth_el_ocd_capitellum_details" JSONB,  -- OCD capitellum details
    "orth_el_tlac_aetiology" JSONB,  -- TLAC aetiology
    "orth_el_tlac_location" TEXT,  -- TLAC location
    "orth_el_tlac_depth" TEXT,  -- TLAC depth
    "orth_el_rlac_aetiology" JSONB,  -- RLAC aetiology
    "orth_el_rlac_location" TEXT,  -- RLAC location
    "orth_el_rlac_depth" TEXT,  -- RLAC depth
    "orth_el_ulac_aetiology" JSONB,  -- ULAC aetiology
    "orth_el_ulac_location" TEXT,  -- ULAC location
    "orth_el_ulac_depth" TEXT,  -- ULAC depth
    "orth_el_uh_rc_complications_of_elbow_arthroplasty" JSONB,  -- UH RC complications of elbow arthroplasty
    "orth_el_uh_rc_elbow_arthroplasty_loosening_location" JSONB,  -- UH RC elbow arthroplasty loosening location
    "orth_el_uh_rc_periprosthetic_acute_fracture_location" JSONB,  -- UH RC periprosthetic acute fracture location
    "orth_el_uh_rc_periprosthetic_stress_fracture_location" JSONB,  -- UH RC periprosthetic stress fracture location
    "orth_el_rc_plica" JSONB,  -- RC plica
    "orth_el_uh_rc_cyst" VARCHAR(50),  -- UH RC cyst
    "orth_el_uh_rc_cyst_location" TEXT,  -- UH RC cyst location
    "orth_el_uh_rc_septic_arthritis_chronicity" VARCHAR(50),  -- UH RC septic arthritis chronicity
    "orth_el_uh_rc_septic_arthritis_pathogenesis" VARCHAR(50),  -- UH RC septic arthritis pathogenesis
    "orth_el_uh_rc_septic_arthritis_organism" VARCHAR(50),  -- UH RC septic arthritis organism
    "orth_el_uh_rc_sequelae_non_arthroplasty_implants" JSONB,  -- UH RC sequelae non arthroplasty implants
    "orth_el_uh_rc_other" TEXT,  -- UH RC other
    "orth_el_capitellum_arthrosis_grade_outerbridge" JSONB,  -- Capitellum arthrosis grade Outerbridge
    "orth_el_trochlea_arthrosis_grade_outerbridge" JSONB,  -- Trochlea arthrosis grade Outerbridge
    "orth_el_uh_rc_arthropathy_bone_pathology_humerus" VARCHAR(50),  -- UH RC arthropathy bone pathology humerus
    "orth_el_uh_rc_complications_elbow_arthoplasty_humerus" VARCHAR(50),  -- UH RC complications elbow arthroplasty humerus
    "orth_el_radial_head_arthrosis_grade_outerbridge" JSONB,  -- Radial head arthrosis grade Outerbridge
    "orth_el_uh_rc_arthropathy_bone_pathology_radius" VARCHAR(50),  -- UH RC arthropathy bone pathology radius
    "orth_el_uh_rc_complications_elbow_arthroplasty_radius" TEXT,  -- UH RC complications elbow arthroplasty radius
    "orth_el_greater_sigmoid_notch_arthrosis_grade_outerbridge" JSONB,  -- Greater sigmoid notch arthrosis grade Outerbridge
    "orth_el_uh_rc_arthropathy_bone_pathology_ulna" VARCHAR(50),  -- UH RC arthropathy bone pathology ulna
    "orth_el_uh_rc_complications_elbow_arthroplasty_ulna" VARCHAR(50),  -- UH RC complications elbow arthroplasty ulna
    "orth_el_coronoid_fossa" JSONB,  -- Coronoid fossa
    "orth_el_coronoid_process" JSONB,  -- Coronoid process
    "orth_el_radial_head" JSONB,  -- Radial head
    "orth_el_olecranon_fossa" JSONB,  -- Olecranon fossa
    "orth_el_olecranon_process" JSONB,  -- Olecranon process
    "orth_el_lateral_gutter" JSONB,  -- Lateral gutter
    "orth_el_medial_gutter" JSONB,  -- Medial gutter
    "orth_el_pruj_instability_direction" VARCHAR(50),  -- PRUJ instability direction
    "orth_el_pruj_instability_pathology" JSONB,  -- PRUJ instability pathology
    "orth_el_pruj_instability_soft_tissue_pathology" JSONB,  -- PRUJ instability soft tissue pathology
    "orth_el_pruj_anterior_capsule" JSONB,  -- PRUJ anterior capsule
    "orth_el_pruj_quadrate_ligament" JSONB,  -- PRUJ quadrate ligament
    "orth_el_pruj_instability_acute_fracture_pathology" JSONB,  -- PRUJ instability acute fracture pathology
    "orth_el_pruj_arthropathy_type" VARCHAR(50),  -- PRUJ arthropathy type
    "orth_el_pruj_arthropathy_severity" VARCHAR(50),  -- PRUJ arthropathy severity
    "orth_el_pruj_stiffness_without_arthropathy_type" JSONB,  -- PRUJ stiffness without arthropathy type
    "orth_el_pruj_stiffness_capsular_aetiology" VARCHAR(50),  -- PRUJ stiffness capsular aetiology
    "orth_el_pruj_stiffness_capsular_severity" VARCHAR(50),  -- PRUJ stiffness capsular severity
    "orth_el_pruj_localised_articular_cartilage_locations" JSONB,  -- PRUJ localised articular cartilage locations
    "orth_el_rlac_pruj_aetiology" JSONB,  -- RLAC PRUJ aetiology
    "orth_el_rlac_pruj_depth" TEXT,  -- RLAC PRUJ depth
    "orth_el_ulac_pruj_aetiology" JSONB,  -- ULAC PRUJ aetiology
    "orth_el_ulac_pruj_depth" TEXT,  -- ULAC PRUJ depth
    "orth_el_complications_pruj_arthropathy_subtypes" JSONB,  -- Complications PRUJ arthroplasty subtypes
    "orth_el_pruj_arthroplasty_loosening_location" JSONB,  -- PRUJ arthroplasty loosening location
    "orth_el_pruj_periprosthetic_fracture_acute_location" JSONB,  -- PRUJ periprosthetic fracture acute location
    "orth_el_pruj_periprosthetic_fracture_stress_location" JSONB,  -- PRUJ periprosthetic fracture stress location
    "orth_el_pruj_sequelae_non_arthroplasty_implants" JSONB,  -- PRUJ sequelae non arthroplasty implants
    "orth_el_pruj_other" TEXT,  -- PRUJ other
    "orth_el_radius_pruj_arthropathy_grade_outerbridge" JSONB,  -- Radius PRUJ arthropathy grade Outerbridge
    "orth_el_radius_pruj_arthropathy_bone_loss" TEXT,  -- Radius PRUJ arthropathy bone loss
    "orth_el_radius_pruj_bone_defect_arthroplasty" TEXT,  -- Radius PRUJ bone defect arthroplasty
    "orth_el_ulna_pruj_arthropathy_grade_outerbridge" JSONB,  -- Ulna PRUJ arthropathy grade Outerbridge
    "orth_el_ulna_pruj_arthropathy_bone_loss" TEXT,  -- Ulna PRUJ arthropathy bone loss
    "orth_el_ulna_pruj_bone_defect_arthroplasty" TEXT,  -- Ulna PRUJ bone defect arthroplasty
    "orth_el_lesser_sigmoid_notch_morphology" VARCHAR(50),  -- Lesser sigmoid notch morphology
    "orth_el_druj_synovial_fluid_volume" VARCHAR(50),  -- DRUJ synovial fluid volume
    "orth_el_druj_synovial_fluid_type" VARCHAR(50),  -- DRUJ synovial fluid type
    "orth_el_druj_synovium" JSONB,  -- DRUJ synovium
    "orth_el_druj_loose_bodies" VARCHAR(50),  -- DRUJ loose bodies
    "orth_el_druj_loose_bodies_details" VARCHAR(500),  -- DRUJ loose bodies details
    "orth_el_druj_stability_instability" VARCHAR(50),  -- DRUJ stability instability
    "orth_el_druj_instability_direction" JSONB,  -- DRUJ instability direction
    "orth_el_druj_instability_pathology" JSONB,  -- DRUJ instability pathology
    "orth_el_druj_instability_soft_tissue_pathology" JSONB,  -- DRUJ instability soft tissue pathology
    "orth_el_druj_distal_oblique_band" JSONB,  -- DRUJ distal oblique band
    "orth_el_druj_tfc" JSONB,  -- DRUJ TFC
    "orth_el_druj_instability_acute_fracture_pathology" JSONB,  -- DRUJ instability acute fracture pathology
    "orth_el_druj_instability_attritional_bone_loss" JSONB,  -- DRUJ instability attritional bone loss
    "orth_el_druj_arthropathy_type" VARCHAR(50),  -- DRUJ arthropathy type
    "orth_el_druj_arthropathy_severity" VARCHAR(50),  -- DRUJ arthropathy severity
    "orth_el_druj_stiffness_without_druj_arthropathy_type" JSONB,  -- DRUJ stiffness without DRUJ arthropathy type
    "orth_el_druj_stiffness_capsular_severity" VARCHAR(50),  -- DRUJ stiffness capsular severity
    "orth_el_druj_stiffness_capsular_aetiology" VARCHAR(50),  -- DRUJ stiffness capsular aetiology
    "orth_el_druj_localised_articular_cartilage_locations" JSONB,  -- DRUJ localised articular cartilage locations
    "orth_el_rlac_druj_aetiology" JSONB,  -- RLAC DRUJ aetiology
    "orth_el_rlac_druj_depth" TEXT,  -- RLAC DRUJ depth
    "orth_el_ulac_druj_aetiology" JSONB,  -- ULAC DRUJ aetiology
    "orth_el_ulac_druj_depth" TEXT,  -- ULAC ULAC DRUJ depth
    "orth_el_complications_druj_arthropathy_subtypes" JSONB,  -- Complications DRUJ arthroplasty subtypes
    "orth_el_druj_arthroplasty_loosening_location" JSONB,  -- DRUJ arthroplasty loosening location
    "orth_el_druj_periprosthetic_fracture_acute_location" JSONB,  -- DRUJ periprosthetic fracture acute location
    "orth_el_druj_periprosthetic_fracture_stress_location" JSONB,  -- DRUJ periprosthetic fracture stress location
    "orth_el_druj_septic_arthritis_chronicity" VARCHAR(50),  -- DRUJ septic arthritis chronicity
    "orth_el_druj_septic_arthritis_pathogenesis" VARCHAR(50),  -- DRUJ septic arthritis pathogenesis
    "orth_el_druj_septic_arthritis_organism" VARCHAR(50),  -- DRUJ septic arthritis organism
    "orth_el_druj_sequelae_non_arthroplasty_implants" JSONB,  -- DRUJ sequelae non arthroplasty implants
    "orth_el_druj_other" TEXT,  -- DRUJ other
    "orth_el_ulnar_variance" JSONB,  -- Ulnar variance
    "orth_el_sigmoid_notch_morphology" JSONB,  -- Sigmoid notch morphology
    "orth_el_radius_druj_arthropathy_grade_outerbridge" JSONB,  -- Radius DRUJ arthropathy grade Outerbridge
    "orth_el_radius_druj_arthropathy_bone_loss" TEXT,  -- Radius DRUJ arthropathy bone loss
    "orth_el_radius_druj_bone_defect_arthroplasty" TEXT,  -- Radius DRUJ bone defect arthroplasty
    "orth_el_ulna_druj_arthropathy_grade_outerbridge" JSONB,  -- Ulna DRUJ arthropathy grade Outerbridge
    "orth_el_ulna_druj_arthropathy_bone_loss" TEXT,  -- Ulna DRUJ arthropathy bone loss
    "orth_el_ulna_druj_bone_defect_arthroplasty" TEXT,  -- Ulna DRUJ bone defect arthroplasty
    "orth_el_forearm_instability_direct" VARCHAR(50),  -- Forearm instability direction
    "orth_el_forearm_instability_pathology" JSONB,  -- Forearm instability pathology
    "orth_el_forearm_instability_soft_tissue_pathology" JSONB,  -- Forearm instability soft tissue pathology
    "orth_el_forearm_iom" JSONB,  -- Forearm IOM
    "orth_el_forearm_sequelae_related_to_non_arthroplasty_implants" JSONB,  -- Forearm sequelae related to non-arthroplasty implants
    "orth_el_forearm_other" TEXT,  -- Forearm other
    "orth_el_distal_biceps_tend_tear_ty" VARCHAR(50),  -- Distal biceps tend tear type
    "orth_el_distal_biceps_tear_avulsion_dehiscence_location" VARCHAR(50),  -- Distal biceps tear avulsion dehiscence location
    "orth_el_distal_biceps_sequelae_non_arthroplasty_implants" JSONB,  -- Distal biceps sequelae non arthroplasty implants
    "orth_el_distal_biceps_other" TEXT,  -- Distal biceps other
    "orth_el_distal_triceps_tend_tear_type" VARCHAR(50),  -- Distal triceps tend tear type
    "orth_el_distal_triceps_tear_avulsion_dehiscence_chronicity" VARCHAR(50),  -- Distal triceps tear avulsion dehiscence chronicity
    "orth_el_distal_triceps_tear_avulsion_dehiscence_location" VARCHAR(50),  -- Distal triceps tear avulsion dehiscence location
    "orth_el_distal_triceps_other" TEXT,  -- Distal triceps other
    "orth_el_ceo_tear_avulsion_dehiscence_chronicity" VARCHAR(50),  -- CEO tear avulsion dehiscence chronicity
    "orth_el_ceo_ecrb_tear_extent" JSONB,  -- CEO ECRB tear extent
    "orth_el_ceo_ecrb_mri" VARCHAR(50),  -- CEO ECRB MRI
    "orth_el_ceo_ecrb_arthroscopy" VARCHAR(50),  -- CEO ECRB arthroscopy
    "orth_el_ceo_sequelae_non_arthroplasty_implants" JSONB,  -- CEO sequelae non arthroplasty implants
    "orth_el_ceo_other" TEXT,  -- CEO other
    "orth_el_cfo_tear_avulsion_dehiscence_chronicity" VARCHAR(50),  -- CFO tear avulsion dehiscence chronicity
    "orth_el_cfo_tear_extent" JSONB,  -- CFO tear extent
    "orth_el_cfo_mri" VARCHAR(50),  -- CFO MRI
    "orth_el_cfo_arthroscopy" VARCHAR(50),  -- CFO arthroscopy
    "orth_el_cfo_sequelae_non_arthroplasty_implants" JSONB,  -- CFO sequelae non arthroplasty implants
    "orth_el_cfo_other" TEXT,  -- CFO other
    "orth_el_pn_elbow_mechanical_neuropathy_aetiology_location" JSONB,  -- PN mechanical neuropathy aetiology location
    "orth_el_pn_elbow_mechanical_neuropathy_grade_seddon" JSONB,  -- PN mechanical neuropathy grade Seddon
    "orth_el_compressive_lesion_pn" TEXT,  -- Compressive lesion PN
    "orth_el_olecranon_fracture_sequelae_deformity_subtype" JSONB,  -- Olecranon fracture sequelae deformity subtype
    "orth_el_olecranon_fracture_uh_rc_instability" JSONB,  -- Olecranon fracture UH RC instability
    "orth_el_olecranon_fracture_mayo" JSONB,  -- Olecranon fracture Mayo
    "orth_el_olecranon_fracture_closed_or_open" VARCHAR(50),  -- Olecranon fracture closed or open
    "orth_el_olecranon_fracture_open_grade_gustilo" VARCHAR(50),  -- Olecranon fracture open grade Gustilo
    "orth_el_olecranon_deformity" TEXT,  -- Olecranon deformity
    "orth_el_olecranon_tumour_classification" VARCHAR(50),  -- Olecranon tumour classification
    "orth_el_olecranon_infection_chronicity" VARCHAR(50),  -- Olecranon infection chronicity
    "orth_el_olecranon_infection_aetiology" VARCHAR(50),  -- Olecranon infection aetiology
    "orth_el_olecranon_infection_organism" VARCHAR(50),  -- Olecranon infection organism
    "orth_el_olecranon_bone_loss_extraarticular" TEXT,  -- Olecranon bone loss extraarticular
    "orth_el_olecranon_sequelae_non_arthroplasty_implants" VARCHAR(50),  -- Olecranon sequelae non arthroplasty implants
    "orth_el_olecranon_other" TEXT,  -- Olecranon other
    "orth_el_coronoid_fracture_sequelae_deformity_subtypes" VARCHAR(50),  -- Coronoid fracture sequelae deformity subtypes
    "orth_el_coronoid_fracture_type_o_driscoll" VARCHAR(50),  -- Coronoid fracture type O'Driscoll
    "orth_el_coronoid_fracture_type_wrightington" VARCHAR(50),  -- Coronoid fracture type Wrightington
    "orth_el_coronoid_fracture_closed_or_open" VARCHAR(50),  -- Coronoid fracture closed or open
    "orth_el_coronoid_open_grade_gustilo" VARCHAR(50),  -- Coronoid open grade Gustilo
    "orth_el_coronoid_deformity" TEXT,  -- Coronoid deformity
    "orth_el_coronoid_sequelae_non_arthroplasty_implants" VARCHAR(50),  -- Coronoid sequelae non arthroplasty implants
    "orth_el_coronoid_process_arthroplasty_complications" VARCHAR(50),  -- Coronoid process arthroplasty complications
    "orth_el_coronoid_arthroplasty_periprosthetic_acute" TEXT,  -- Coronoid arthroplasty periprosthetic acute
    "orth_el_coronoid_arthroplasty_periprosthetic_stress" TEXT,  -- Coronoid arthroplasty periprosthetic stress
    "orth_el_coronoid_other" TEXT,  -- Coronoid other
    "orth_el_rh_rn_fracture_type_ao" VARCHAR(50),  -- RH RN fracture type AO
    "orth_el_rh_rn_fracture_closed_or_open" VARCHAR(50),  -- RH RN fracture closed or open
    "orth_el_rh_rn_open_grade_gustilo" VARCHAR(50),  -- RH RN open grade Gustilo
    "orth_el_rh_rn_deformity" TEXT,  -- RH RN deformity
    "orth_el_rh_rn_tumour_type" VARCHAR(50),  -- RH RN tumour type
    "orth_el_rh_rn_infection_chronicity" VARCHAR(50),  -- RH RN infection chronicity
    "orth_el_rh_rn_infection_aetiology" VARCHAR(50),  -- RH RN infection aetiology
    "orth_el_rh_rn_infection_organism" VARCHAR(50),  -- RH RN infection organism
    "orth_el_rh_rn_bone_loss_extrarticular" TEXT,  -- RH RN bone loss extrarticular
    "orth_el_rh_rn_sequelae_non_arthroplasty_implants" JSONB,  -- RH RN sequelae non arthroplasty implants
    "orth_el_rh_arthroplasty_complications" JSONB,  -- RH arthroplasty complications
    "orth_el_rh_arthroplasty_periprosthetic_acute" TEXT,  -- RH arthroplasty periprosthetic acute
    "orth_el_rh_periprosthetic_stress" TEXT,  -- RH periprosthetic stress
    "orth_el_rh_other" TEXT,  -- RH other
    "orth_el_radius_diaphysis_fracture_type_ao" JSONB,  -- Radius diaphysis fracture type AO
    "orth_el_radius_diaphysis_fracture_closed_or_open" VARCHAR(50),  -- Radius diaphysis fracture closed or open
    "orth_el_radius_diaphysis_open_grade_gustilo" VARCHAR(50),  -- Radius diaphysis open grade Gustilo
    "orth_el_radius_diaphysis_deformity" TEXT,  -- Radius diaphysis deformity
    "orth_el_radius_diaphysis_tumour_type" VARCHAR(50),  -- Radius diaphysis tumour type
    "orth_el_radius_diaphysis_infection_chronicity" VARCHAR(50),  -- Radius diaphysis infection chronicity
    "orth_el_radius_diaphysis_infection_aetiology" VARCHAR(50),  -- Radius diaphysis infection aetiology
    "orth_el_radius_diaphysis_infection_organism" VARCHAR(50),  -- Radius diaphysis infection organism
    "orth_el_radius_diaphysis_bone_loss_extrarticular" TEXT,  -- Radius diaphysis bone loss extrarticular
    "orth_el_radius_diaphysis_sequelae_non_arthroplasty_implants" JSONB,  -- Radius diaphysis sequelae non arthroplasty implants
    "orth_el_radius_diaphysis_other" TEXT,  -- Radius diaphysis other
    "orth_el_ulna_diaphysis_fracture_type_ao" VARCHAR(50),  -- Ulna diaphysis fracture type AO
    "orth_el_ulna_diaphysis_fracture_closed_or_open" VARCHAR(50),  -- Ulna diaphysis fracture closed or open
    "orth_el_ulna_diaphysis_open_grade_gustilo" VARCHAR(50),  -- Ulna diaphysis open grade Gustilo
    "orth_el_ulna_diaphysis_deformity" TEXT,  -- Ulna diaphysis deformity
    "orth_el_ulna_diaphysis_tumour_type" VARCHAR(50),  -- Ulna diaphysis tumour type
    "orth_el_ulna_diaphysis_infection_chronicity" VARCHAR(50),  -- Ulna diaphysis infection chronicity
    "orth_el_ulna_diaphysis_infection_aetiology" VARCHAR(50),  -- Ulna diaphysis infection aetiology
    "orth_el_ulna_diaphysis_infection_organism" VARCHAR(50),  -- Ulna diaphysis infection organism
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_general_part_1_part_1
CREATE INDEX IF NOT EXISTS idx_elbow_general_part_1_part_1_encounter ON elbow_general_part_1_part_1(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_general_part_1_part_1_created ON elbow_general_part_1_part_1(created_at);

-- Foreign key constraint
ALTER TABLE elbow_general_part_1_part_1
    ADD CONSTRAINT fk_elbow_general_part_1_part_1_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_general_part_1_part_1
-- Generated: 2025-11-28T20:28:38.889131
-- Fields: 250

CREATE TABLE IF NOT EXISTS shoulder_general_part_1_part_1 (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_patient_id" VARCHAR(500),  -- Patient ID
    "orth_sh_first_name" VARCHAR(500),  -- First Name
    "orth_sh_last_name" VARCHAR(500),  -- Last name
    "orth_sh_date_of_birth" DATE,  -- Date of Birth
    "orth_sh_email_address" VARCHAR(255),  -- Email address
    "orth_sh_encounter_type" VARCHAR(50),  -- Encounter type
    "orth_sh_encounter_background_info_diagnosis" VARCHAR(50),  -- Encounter background info diagnosis
    "orth_sh_doi" VARCHAR(500),  -- DOI
    "orth_sh_moi" VARCHAR(500),  -- MOI
    "orth_sh_previous_treatment" VARCHAR(500),  -- Previous treatment
    "orth_sh_previous_surgery" VARCHAR(500),  -- Previous surgery
    "orth_sh_comorbidities" VARCHAR(500),  -- Comorbidities
    "orth_sh_allergies" VARCHAR(500),  -- Allergies
    "orth_sh_handedness" VARCHAR(50),  -- Handedness
    "orth_sh_occupation" VARCHAR(500),  -- Occupation
    "orth_sh_sports_hobbies" VARCHAR(500),  -- Sports hobbies
    "orth_sh_selected_locations_to_record_data_about" JSONB,  -- Selected locations to record data about
    "orth_sh_follow_up_non_op" VARCHAR(50),  -- Follow up non op
    "orth_sh_operation_note" VARCHAR(50),  -- Operation note
    "orth_sh_post_op" VARCHAR(50),  -- Post op
    "orth_sh_pronoun" VARCHAR(50),  -- Pronoun
    "orth_sh_text_to_include" JSONB,  -- Text to include
    "orth_sh_sct_motion_stam_type" VARCHAR(50),  -- ScT motion STAM type
    "orth_sh_sct_bursa_bursitis_impingement" JSONB,  -- ScT bursa bursitis impingement
    "orth_sh_sct_stability_dissociation" JSONB,  -- ScT stability dissociation
    "orth_sh_sct_articulation_other" VARCHAR(500),  -- ScT articulation other
    "orth_sh_sternum_fracture_sequelae_deformity_subtypes" JSONB,  -- Sternum fracture sequelae deformity subtypes
    "orth_sh_sternum_fracture_classification_ao" VARCHAR(50),  -- Sternum fracture classification AO
    "orth_sh_sternum_deformity" VARCHAR(500),  -- Sternum deformity
    "orth_sh_sternum_tumour_pathology" VARCHAR(50),  -- Sternum tumour pathology
    "orth_sh_sternum_infection_chronicity" VARCHAR(50),  -- Sternum infection chronicity
    "orth_sh_sternum_infection_aetiology" VARCHAR(50),  -- Sternum infection aetiology
    "orth_sh_sternum_infection_organsim" VARCHAR(50),  -- Sternum infection organsim
    "orth_sh_sternum_bone_loss_extraarticular" VARCHAR(500),  -- Sternum bone loss extraarticular
    "orth_sh_sternum_sequelae_non_arthroplasty_implants" JSONB,  -- Sternum sequelae non-arthroplasty implants
    "orth_sh_sternum_other" VARCHAR(500),  -- Sternum other
    "orth_sh_msj_stability_instability" VARCHAR(50),  -- MSJ stability instability
    "orth_sh_manubriosternal_instability_type_direction" VARCHAR(50),  -- Manubriosternal Instability type - direction
    "orth_sh_manubriosternal_instability_pathology" JSONB,  -- Manubriosternal Instability pathology
    "orth_sh_msj_attritional_bone_loss_proximal_bone_loss" VARCHAR(50),  -- Manubriosternal attritional bone loss - proximal % bone loss
    "orth_sh_manubriosternal_attritional_bone_loss_distal_bone_loss" VARCHAR(50),  -- Manubriosternal attritional bone loss - distal % bone loss
    "orth_sh_manubriosternal_arthropathy_type" JSONB,  -- Manubriosternal arthropathy type
    "orth_sh_msj_arthropathy_bone_pathology_manubrium" VARCHAR(500),  -- MSJ arthropathy bone pathology manubrium
    "orth_sh_msj_arthropathy_bone_pathology_sternum" VARCHAR(500),  -- MSJ arthropathy bone pathology sternum
    "orth_sh_msj_septic_arthritis_chronicity" VARCHAR(50),  -- MSJ septic arthritis chronicity
    "orth_sh_msj_septic_arthritis_pathogenesis" VARCHAR(50),  -- MSJ septic arthritis pathogenesis
    "orth_sh_msj_septic_arthritis_organsim" VARCHAR(50),  -- MSJ septic arthritis organism
    "orth_sh_msj_sequelae_non_arthroplasty_implants" JSONB,  -- MSJ sequelae non arthroplasty implants
    "orth_sh_msj_other" TEXT,  -- MSJ other
    "orth_sh_scj_stability_instability" VARCHAR(50),  -- SCJ stability instability
    "orth_sh_scj_instability_direction" VARCHAR(50),  -- SCJ instability direction
    "orth_sh_scj_instability_pathology" JSONB,  -- SCJ instability pathology
    "orth_sh_scj_attritional_bone_loss_proximal_bone_loss" VARCHAR(50),  -- SCJ instability attritional bone loss proximal
    "orth_sh_scj_attritional_bone_loss_distal_bone_loss" VARCHAR(50),  -- SCJ instability attritional bone loss distal
    "orth_sh_sternoclavicular_arthropathy_type" VARCHAR(50),  -- Sternoclavicular Arthropathy type
    "orth_sh_bone_pathology_sternum" VARCHAR(500),  -- Bone pathology - sternum
    "orth_sh_bone_pathology_clavicle" VARCHAR(500),  -- Bone pathology - clavicle
    "orth_sh_scj_septic_arthritis_chronicity" VARCHAR(50),  -- SCJ septic arthritis chronicity
    "orth_sh_scj_septic_arthritis_aetiology" VARCHAR(50),  -- SCJ septic arthritis aetiology
    "orth_sh_scj_septic_arthritis_organism" VARCHAR(50),  -- SCJ septic arthritis organism
    "orth_sh_scj_sequelae_non_arthroplasty_implants" JSONB,  -- SCJ sequelae non arthroplasty implants
    "orth_sh_scj_other" TEXT,  -- SCJ other
    "orth_sh_acromial_morphology_bigliani" VARCHAR(50),  -- Acromial morphology Bigliani
    "orth_sh_acromial_morphology_other" VARCHAR(500),  -- Acromial morphology other
    "orth_sh_os_acromiale" VARCHAR(50),  -- Os acromiale
    "orth_sh_critical_shoulder_angle" VARCHAR(50),  -- Critical shoulder angle
    "orth_sh_glenoid_version" VARCHAR(50),  -- Glenoid version
    "orth_sh_glenoid_inclination" VARCHAR(50),  -- Glenoid inclination
    "orth_sh_scapula_spine_morphology" VARCHAR(500),  -- Scapula spine morphology
    "orth_sh_coracoid_morphology" VARCHAR(500),  -- Coracoid morphology
    "orth_sh_scapula_body_morphology" VARCHAR(500),  -- Scapula body morphology
    "orth_sh_scapula_neck_morphology" VARCHAR(500),  -- Scapula neck morphology
    "orth_sh_scapula_fracture_sequelae_deformity_subtypes" JSONB,  -- Scapula fracture sequelae deformity subtypes
    "orth_sh_scapula_fracture_ao" JSONB,  -- Scapula fracture AO
    "orth_sh_scapula_stress_fracture_classification" JSONB,  -- Scapula Stress fracture classification
    "orth_sh_scapula_nonunion_classification" JSONB,  -- Scapula Non-union classification
    "orth_sh_scapula_malunion_classification" JSONB,  -- Scapula Malunion classification
    "orth_sh_scapular_fracture_other_classification" VARCHAR(500),  -- Scapular fracture other classification
    "orth_sh_scapula_fracture_acromion_types_kuhn" JSONB,  -- Scapula fracture acromion types Kuhn
    "orth_sh_scapula_spine_fracture" VARCHAR(500),  -- Scapula spine fracture
    "orth_sh_scapula_fracture_coracoid_types_eyres" JSONB,  -- Scapula fracture coracoid types Eyres
    "orth_sh_scapula_body_fracture" VARCHAR(500),  -- Scapula body fracture
    "orth_sh_scapula_neck_fracture" VARCHAR(500),  -- Scapula neck fracture
    "orth_sh_glenoid_fracture_ideberg" VARCHAR(50),  -- Glenoid fracture Ideberg
    "orth_sh_scapula_fracture_classification_closed_open" VARCHAR(50),  -- Scapula Fracture Classification Closed/Open
    "orth_sh_scapula_acute_fracture_open_grade_gustilo" VARCHAR(50),  -- Scapula Fracture Open Grade (Gustilo)
    "orth_sh_scapula_deformity" TEXT,  -- Scapula deformity
    "orth_sh_scapula_tumour_classification" VARCHAR(50),  -- Scapula tumour Classification
    "orth_sh_scapula_infection_chronicity" VARCHAR(50),  -- Scapula infection Chronicity
    "orth_sh_scapula_infection_aetiology" VARCHAR(50),  -- Scapula infection Aetiology
    "orth_sh_scapula_infection_organism" JSONB,  -- Scapula infection Organsim
    "orth_sh_scapula_bone_loss_extra_articular_location" TEXT,  -- Scapula bone loss extra articular location
    "orth_sh_scapula_sequelae_non_arthroplasty_implants" JSONB,  -- Scapula sequelae non-arthroplasty implants
    "orth_sh_scapula_other" TEXT,  -- Scapula Other
    "orth_sh_clavicle_fracture_subtypes_ao" JSONB,  -- Clavicle fracture subtypes AO
    "orth_sh_clavicle_fracture_other_classification" VARCHAR(500),  -- Clavicle fracture other classification
    "orth_sh_clavicle_fracture_closed_or_open" VARCHAR(50),  -- Clavicle fracture closed or open
    "orth_sh_clavicle_fracture_open_grade_gustilo" VARCHAR(50),  -- Clavicle Fracture Open Grade (Gustilo)
    "orth_sh_clavicle_deformity" VARCHAR(500),  -- Clavicle deformity
    "orth_sh_clavicle_tumour_pathology" VARCHAR(50),  -- Clavicle tumour pathology
    "orth_sh_clavicle_infection_chronicity" VARCHAR(50),  -- Clavicle infection chronicity
    "orth_sh_clavicle_infection_aetiology" VARCHAR(50),  -- Clavicle infection aetiology
    "orth_sh_clavicle_infection_organsim" JSONB,  -- Clavicle infection organsim
    "orth_sh_clavicle_bone_loss_extraarticular" TEXT,  -- Clavicle bone loss extraarticular
    "orth_sh_clavicle_sequelae_non_arthroplasty_implants" JSONB,  -- Clavicle sequelae non-arthroplasty implants
    "orth_sh_clavicle_other" TEXT,  -- Clavicle other
    "orth_sh_acj_stability_instability" VARCHAR(50),  -- ACJ stability instability
    "orth_sh_acj_instability_type_rockwood" VARCHAR(50),  -- ACJ instability type Rockwood
    "orth_sh_acj_instability_pathology" JSONB,  -- ACJ Instability pathology
    "orth_sh_cc_instability_pathology" JSONB,  -- CC instability pathology
    "orth_sh_acj_arthropathy_type" VARCHAR(50),  -- ACJ arthropathy type
    "orth_sh_acj_arthropathy_severity" VARCHAR(50),  -- ACJ arthropathy severity
    "orth_sh_acj_arthropathy_bone_pathology_clavicle" VARCHAR(500),  -- ACJ arthropathy bone pathology clavicle
    "orth_sh_acj_arthropathy_bone_pathology_acromion" VARCHAR(500),  -- ACJ arthropathy bone pathology acromion
    "orth_sh_acj_osteolysis_distal_clavicle_type" VARCHAR(50),  -- ACJ osteolysis distal clavicle type
    "orth_sh_acj_osteolysis_distal_clavicle_severity" JSONB,  -- ACJ osteolysis distal clavicle severity
    "orth_sh_acj_septic_arthritis_chronicity" VARCHAR(50),  -- ACJ septic arthritis chronicity
    "orth_sh_acj_septic_arthritis_pathogenesis" VARCHAR(50),  -- ACJ septic arthritis pathogenesis
    "orth_sh_acj_septic_arthritis_organsim" VARCHAR(50),  -- ACJ septic arthritis organsim
    "orth_sh_acj_cyst" VARCHAR(50),  -- ACJ cyst
    "orth_sh_acj_sequelae_non_arthroplasty_implants" JSONB,  -- ACJ sequelae non-arthroplasty implants
    "orth_sh_acj_other" TEXT,  -- ACJ other
    "orth_sh_subacromial_bursa" JSONB,  -- Subacromial bursa
    "orth_sh_subacromial_impingement" JSONB,  -- Subacromial impingement
    "orth_sh_subcoracoid_bursa" JSONB,  -- Subcoracoid bursa
    "orth_sh_sa_sd_sc_sequelae_non_arthroplasty_implants" JSONB,  -- SA SD SC sequelae non arthroplasty implants
    "orth_sh_sa_sd_sc_other" TEXT,  -- SA SD SC other
    "orth_sh_subscapularis" JSONB,  -- Subscapularis
    "orth_sh_subscapularis_tear_vertical_size" VARCHAR(50),  -- Subscapularis tear vertical size
    "orth_sh_subscapularis_tendon_quality" VARCHAR(50),  -- Subscapularis tendon quality
    "orth_sh_supraspinatus" JSONB,  -- Supraspinatus
    "orth_sh_supraspinatus_tear_ap_width" VARCHAR(50),  -- Supraspinatus Tear AP Width
    "orth_sh_infraspinatus" JSONB,  -- Infraspinatus
    "orth_sh_infraspinatus_tear_ap_width" VARCHAR(50),  -- Infraspinatus tear AP width
    "orth_sh_teres_minor" JSONB,  -- Teres minor
    "orth_sh_teres_minor_tear_ap_width" VARCHAR(50),  -- Teres minor tear AP width
    "orth_sh_posterosuperior_tear_delamination" VARCHAR(50),  -- Posterosuperior tear delamination
    "orth_sh_posterosuperior_tear_type" VARCHAR(50),  -- Posterosuperior tear type
    "orth_sh_posterosuperior_tendon_quality" VARCHAR(50),  -- Posterosuperior tendon quality
    "orth_sh_subscapularis_goutallier" VARCHAR(50),  -- Subscapularis Goutallier
    "orth_sh_supraspinatus_goutallier" VARCHAR(50),  -- Supraspinatus Goutallier
    "orth_sh_infraspinatus_goutallier" VARCHAR(50),  -- Infraspinatus Goutallier
    "orth_sh_teres_minor_goutallier" VARCHAR(50),  -- Teres minor Goutallier
    "orth_sh_subscapularis_sarcopenia" VARCHAR(50),  -- Subscapularis sarcopenia
    "orth_sh_supraspinatus_sarcopenia" VARCHAR(50),  -- Supraspinatus sarcopenia
    "orth_sh_infraspinatus_sarcopenia" VARCHAR(50),  -- Infraspinatus sarcopenia
    "orth_sh_teres_minor_sarcopenia" VARCHAR(50),  -- Teres minor sarcopenia
    "orth_sh_subscapularis_myosteatosis" VARCHAR(50),  -- Subscapularis myosteatosis
    "orth_sh_supraspinatus_myosteatosis" VARCHAR(50),  -- Supraspinatus myosteatosis
    "orth_sh_infraspinatus_myosteatosis" VARCHAR(50),  -- Infraspinatus myosteatosis
    "orth_sh_teres_minor_myosteatosis" VARCHAR(50),  -- Teres minor myosteatosis
    "orth_sh_rotator_cuff_sequelae_non_arthroplasty_implants" JSONB,  -- Rotator cuff sequelae non arthroplasty implants
    "orth_sh_rotator_cuff_other" TEXT,  -- Rotator cuff other
    "orth_sh_hamada" VARCHAR(50),  -- Hamada
    "orth_sh_rohi" VARCHAR(500),  -- ROHI
    "orth_sh_rotator_cuff_functional_state" JSONB,  -- Rotator cuff functional state
    "orth_sh_rotator_cuff_tear_stage_gs" VARCHAR(50),  -- Rotator cuff tear stage GS
    "orth_sh_slap_tear_type" VARCHAR(50),  -- SLAP tear type
    "orth_sh_biceps_anchor_sequelae_non_arthroplasty_implants" JSONB,  -- Biceps anchor sequelae non arthroplasty implants
    "orth_sh_biceps_anchor_other" TEXT,  -- Biceps anchor other
    "orth_sh_biceps_pulley_diagnosis" JSONB,  -- Biceps pulley diagnosis
    "orth_sh_lhb_diagnosis" JSONB,  -- LHB diagnosis
    "orth_sh_lhb_instability_direction" JSONB,  -- LHB instability direction
    "orth_sh_intraarticular_lhb_synovitis_tear" VARCHAR(50),  -- Intraarticular LHB synovitis tear
    "orth_sh_extraarticular_lhb_synovitis_tear" VARCHAR(50),  -- Extraarticular LHB synovitis tear
    "orth_sh_lhb_sequelae_non_arthroplasty_implants" JSONB,  -- LHB sequelae non arthroplasty implants
    "orth_sh_lhb_other" TEXT,  -- LHB other
    "orth_sh_synovial_fluid_volume" VARCHAR(50),  -- Synovial fluid volume
    "orth_sh_synovial_fluid_type" VARCHAR(50),  -- Synovial fluid type
    "orth_sh_synovium" JSONB,  -- Synovium
    "orth_sh_loose_bodies" VARCHAR(50),  -- Loose bodies
    "orth_sh_loose_body_details" TEXT,  -- Loose body details
    "orth_sh_ghj_stability" VARCHAR(50),  -- GHJ stability
    "orth_sh_ghj_instability_direction" VARCHAR(50),  -- GHJ instability direction
    "orth_sh_ghj_instability_pathology" JSONB,  -- GHJ instability pathology
    "orth_sh_ghj_arthropathy_type" VARCHAR(50),  -- GHJ arthropathy type
    "orth_sh_ghj_arthropathy_severity" VARCHAR(50),  -- GHJ arthropathy severity
    "orth_sh_complications_shoulder_arthroplasty_subtypes" JSONB,  -- Complications shoulder arthroplasty subtypes
    "orth_sh_shoulder_arthroplasty_loosening_location" JSONB,  -- Shoulder arthoplasty loosening location
    "orth_sh_periprothetic_acute_fracture_location" JSONB,  -- Periprothetic fracture acute location
    "orth_sh_periprosthetic_fracture_stress_location" JSONB,  -- Periprosthetic fracture stress location
    "orth_sh_shoulder_stiffness_without_ghj_arthropathy_type" JSONB,  -- Shoulder stiffness without GHJ arthropathy type
    "orth_sh_shoulder_stiffness_capsular_aetiology" VARCHAR(50),  -- Shoulder stiffness capsular aetiology
    "orth_sh_shoulder_stiffness_capsular_severity" VARCHAR(50),  -- Shoulder stiffness capsular severity
    "orth_sh_ghj_septic_arthritis_chronicity" VARCHAR(50),  -- GHJ septic arthritis chronicity
    "orth_sh_ghj_septic_arthritis_pathogenesis" VARCHAR(50),  -- GHJ septic arthritis pathogenesis
    "orth_sh_ghj_septic_arthritis_organism" VARCHAR(50),  -- GHJ septic arthritis organism
    "orth_sh_ghj_sequelae_non_arthroplasty_implants" JSONB,  -- GHJ sequelae non arthroplasty implants
    "orth_sh_glenohumeral_joint_other_diagnosis" TEXT,  -- Glenohumeral Joint Other Diagnosis
    "orth_sh_glenoid_labrum_anterior_1_to_6_oclock_diagnosis" JSONB,  -- Glenoid labrum anterior 1 to 6 oclock diagnosis
    "orth_sh_glenoid_labrum_anterior_tear_type" VARCHAR(50),  -- Glenoid labrum anterior tear type
    "orth_sh_glenoid_labrum_anterior_tear_location" TEXT,  -- Glenoid labrum anterior tear location
    "orth_sh_anterior_paralabral_cyst_location" TEXT,  -- Anterior paralabral cyst location
    "orth_sh_anterior_labrum_pathology_other" TEXT,  -- Anterior labrum pathology other
    "orth_sh_glenoid_labrum_posterior_1_to_6_oclock_diagnosis" JSONB,  -- Glenoid labrum posterior 1 to 6 oclock diagnosis
    "orth_sh_glenoid_labrum_posterior_tear_type" VARCHAR(50),  -- Glenoid labrum posterior tear type
    "orth_sh_glenoid_labrum_posterior_tear_location" TEXT,  -- Glenoid labrum posterior tear location
    "orth_sh_posterior_paralabral_cyst_location" TEXT,  -- Posterior paralabral cyst location
    "orth_sh_posterior_labrum_pathology_other" TEXT,  -- Posterior labrum pathology other
    "orth_sh_glenohumeral_capsule_volume" VARCHAR(50),  -- Glenohumeral capsule volume
    "orth_sh_glenohumeral_capsule_quality" VARCHAR(50),  -- Glenohumeral capsule quality
    "orth_sh_glenohumeral_capsule_tear" VARCHAR(50),  -- Glenohumeral capsule tear
    "orth_sh_glenohumeral_capsule_tear_location" VARCHAR(50),  -- Glenohumeral capsule tear location
    "orth_sh_rotator_interval" VARCHAR(50),  -- Rotator interval
    "orth_sh_glenoid_arthrosis_grade_outerbridge" VARCHAR(50),  -- Glenoid arthrosis grade Outerbridge
    "orth_sh_bony_bankart_lesion_size" VARCHAR(50),  -- Bony Bankart lesion size
    "orth_sh_glenoid_attritional_bone_loss_size" VARCHAR(50),  -- Glenoid attritional bone loss size
    "orth_sh_walch" VARCHAR(50),  -- Walch
    "orth_sh_favard" VARCHAR(50),  -- Favard
    "orth_sh_arthrosis_glenoid_bone_defect" VARCHAR(50),  -- Arthrosis glenoid bone defect
    "orth_sh_shoulder_arthroplasty_glenoid_bone_defect" VARCHAR(50),  -- Shoulder arthroplasty glenoid bone defect
    "orth_sh_glac_pathology_type" VARCHAR(50),  -- GLAC pathology type
    "orth_sh_glac_pathology_location" TEXT,  -- GLAC pathology location
    "orth_sh_glac_pathology_depth" TEXT,  -- GLAC pathology depth
    "orth_sh_humeral_arthrosis_grade_outerbridge" VARCHAR(50),  -- Humeral arthrosis grade Outerbridge
    "orth_sh_hill_sachs_location" JSONB,  -- Hill sachs location
    "orth_sh_hill_sachs_depth" VARCHAR(50),  -- Hill sachs depth
    "orth_sh_arthrosis_humeral_bone_defect" VARCHAR(50),  -- Arthrosis humeral bone defect
    "orth_sh_shoulder_arthroplasty_humeral_bone_defect" VARCHAR(50),  -- Shoulder arthroplasty humeral bone defect
    "orth_sh_hlac_pathology_type" VARCHAR(50),  -- HLAC pathology type
    "orth_sh_hlac_pathology_location" TEXT,  -- HLAC pathology location
    "orth_sh_hlac_pathology_depth" TEXT,  -- HLAC pathology depth
    "orth_sh_plexus_mechanical_neuropathy_location_aetiology" VARCHAR(50),  -- Plexus mechanical neuropathy location aetiology
    "orth_sh_plexus_mechanical_neuropathy_grade_seddon" VARCHAR(50),  -- Plexus mechanical neuropathy grade Seddon
    "orth_sh_compressive_lesion_plexus" TEXT,  -- Compressive lesion plexus
    "orth_sh_pn_mechanical_neuropathy_aetiology_location" JSONB,  -- PN mechanical neuropathy aetiology location
    "orth_sh_pn_mechanical_neuropathy_grade_seddon" VARCHAR(50),  -- PN mechanical neuropathy grade Seddon
    "orth_sh_compressive_lesion_pn" TEXT,  -- Compressive lesion PN
    "orth_sh_deltoid_tear_avulsion_dehiscence_chronicity" VARCHAR(50),  -- Deltoid tear avulsion dehiscence chronicity
    "orth_sh_deltoid_tear_avulsion_dehiscence_location" VARCHAR(50),  -- Deltoid tear avulsion dehiscence location
    "orth_sh_deltoid_sequelae_non_arthroplasty_implants" JSONB,  -- Deltoid sequelae non arthroplasty implants
    "orth_sh_deltoid_other" TEXT,  -- Deltoid other
    "orth_sh_pec_minor_tear_chronicity" VARCHAR(50),  -- Pec minor tear chronicity
    "orth_sh_pec_minor_tear_avulsion_dehiscence_location" VARCHAR(50),  -- Pec minor tear avulsion dehiscence location
    "orth_sh_pec_minor_tightness" VARCHAR(50),  -- Pec minor tightness
    "orth_sh_pec_minor_sequelae_non_arthroplasty_implants" JSONB,  -- Pec minor sequelae non arthroplasty implants
    "orth_sh_pec_minor_other" TEXT,  -- Pec minor other
    "orth_sh_pec_major_tear_chronicity" VARCHAR(50),  -- Pec major tear chronicity
    "orth_sh_pec_major_tear_tendon_involvement" VARCHAR(50),  -- Pec major tear tendon involvement
    "orth_sh_pec_major_tear_location" VARCHAR(50),  -- Pec major tear Location
    "orth_sh_pec_major_sequelae_non_arthroplasty_implants" JSONB,  -- Pec major sequelae non-arthroplasty implants
    "orth_sh_pec_major_other" TEXT,  -- Pec major other
    "orth_sh_lat_dorsi_tear_chronicity" VARCHAR(50),  -- Lat dorsi tear chronicity
    "orth_sh_lat_dorsi_tear_location" VARCHAR(50),  -- Lat dorsi tear location
    "orth_sh_lat_dorsi_tightness" VARCHAR(50),  -- Lat dorsi tightness
    "orth_sh_lat_dorsi_sequelae_non_arthroplasty_implants" JSONB,  -- Lat dorsi sequelae non arthroplasty implants
    "orth_sh_lat_dorsi_other" TEXT,  -- Lat dorsi other
    "orth_sh_teres_major_tear_chronicity" VARCHAR(50),  -- Teres major tear chronicity
    "orth_sh_teres_major_tear_location" VARCHAR(50),  -- Teres major tear location
    "orth_sh_teres_major_sequelae_non_arthroplasty_implants" JSONB,  -- Teres major sequelae non arthroplasty implants
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_general_part_1_part_1
CREATE INDEX IF NOT EXISTS idx_shoulder_general_part_1_part_1_encounter ON shoulder_general_part_1_part_1(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_general_part_1_part_1_created ON shoulder_general_part_1_part_1(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_general_part_1_part_1
    ADD CONSTRAINT fk_shoulder_general_part_1_part_1_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: demographics_part_2_part_2
-- Generated: 2025-11-28T20:28:38.875395
-- Fields: 250

CREATE TABLE IF NOT EXISTS demographics_part_2_part_2 (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_ulna_diaphysis_fracture_closed_open" VARCHAR(50),  -- Ulna Diaphysis Fracture Closed / Open
    "dem_ulna_diaphysis_fracture_open_grade" VARCHAR(50),  -- Ulna Diaphysis Fracture Open Grade
    "dem_ulna_diaphysis_fracture_soft_tissue_status" TEXT,  -- Ulna Diaphysis Fracture Soft Tissue Status
    "dem_ulna_diaphysis_malunion" VARCHAR(500),  -- Ulna Diaphysis malunion
    "dem_ulna_diaphysis_pathological_fracture_excluding_stress_fract" VARCHAR(500),  -- Ulna Diaphysis pathological fracture (excluding stress fract
    "dem_ulna_diaphysis_periprosthetic_fracture_non_arthroplasty" VARCHAR(500),  -- Ulna Diaphysis Periprosthetic fracture - non-arthroplasty
    "dem_ulna_diaphysis_periprosthetic_fracture_arthroplasty" VARCHAR(500),  -- Ulna Diaphysis Periprosthetic fracture - arthroplasty
    "dem_ulna_diaphysis_bone_deformity_not_fracture_related" VARCHAR(500),  -- Ulna Diaphysis bone deformity (NOT fracture-related)
    "dem_ulna_diaphysis_bone_defect_extra_articular" VARCHAR(500),  -- ULNA DIAPHYSIS bone defect extra-articular
    "dem_ulna_diaphysis_sequelae_related_to_non_arthroplasty_implant" JSONB,  -- ULNA DIAPHYSIS Sequelae related to non-arthroplasty implant
    "dem_ulna_diaphysis_bone_tumour_classification" VARCHAR(50),  -- ULNA DIAPHYSIS BONE TUMOUR Classification
    "dem_ulna_diaphysis_bone_tumour_malignancy_source" VARCHAR(50),  -- ULNA DIAPHYSIS BONE TUMOUR Malignancy Source
    "dem_ulna_diaphysis_bone_infection_chronicity" VARCHAR(50),  -- ULNA DIAPHYSIS BONE INFECTION Chronicity
    "dem_ulna_diaphysis_bone_infection_aetiology" VARCHAR(50),  -- ULNA DIAPHYSIS BONE INFECTION Aetiology
    "dem_ulna_diaphysis_bone_infection_organsim" VARCHAR(50),  -- ULNA DIAPHYSIS BONE INFECTION Organsim
    "dem_fascia_compartment_syndrome_type" VARCHAR(50),  -- Fascia Compartment Syndrome Type
    "dem_fascia_compartment_involved" VARCHAR(500),  -- Fascia Compartment Involved
    "dem_infection_organism" VARCHAR(50),  -- Infection Organism
    "dem_distal_humerus_fracture_reduction" VARCHAR(50),  -- Distal Humerus fracture reduction
    "dem_distal_humerus_fixation_not_joint_spanning" JSONB,  -- Distal Humerus fixation - not joint spanning
    "dem_distal_humerus_bone_graft_reconstruction_type" JSONB,  -- Distal Humerus bone graft / reconstruction type
    "dem_distal_humerus_bone_graft_bone_reconstruction_fixation_type" JSONB,  -- Distal Humerus bone graft / bone reconstruction fixation typ
    "dem_distal_humerus_osteotomy_location" JSONB,  -- Distal Humerus osteotomy location
    "dem_distal_humerus_osteotomy_type" VARCHAR(500),  -- Distal Humerus osteotomy type
    "dem_distal_humerus_removal_of_implants" VARCHAR(50),  -- Distal Humerus removal of implants
    "dem_distal_humerus_implants_removed" VARCHAR(500),  -- Distal Humerus implants removed
    "dem_distal_humerus_implants_retained" VARCHAR(500),  -- Distal humerus implants retained
    "dem_ulnohumeral_debridement_arthroplasty" JSONB,  -- Ulnohumeral debridement arthroplasty
    "dem_radiocapitellar_debridement_arthroplasty" JSONB,  -- Radiocapitellar debridement arthroplasty
    "dem_ulnohumeral_arthroplasty_type" VARCHAR(50),  -- Ulnohumeral arthroplasty type
    "dem_ulnohumeral_arthroplasty_spacer_type" VARCHAR(50),  -- Ulnohumeral arthroplasty spacer type
    "dem_ulnohumeral_arthroplasty_spacer_location" VARCHAR(50),  -- Ulnohumeral arthroplasty spacer location
    "dem_ulnohumeral_arthroplasty_anatomic_subtypes" VARCHAR(50),  -- Ulnohumeral arthroplasty anatomic subtypes
    "dem_ulnohumeral_hemiarthroplasty_distal_humerus_hemiarthroplast" VARCHAR(50),  -- Ulnohumeral hemiarthroplasty - distal humerus hemiarthroplas
    "dem_ulnohumeral_hemiarthroplasty_distal_humerus_hemiarthroplast" VARCHAR(50),  -- Ulnohumeral hemiarthroplasty - distal humerus hemiarthroplas
    "dem_ulnohumeral_hemiarthroplasty_distal_humerus_hemiarthroplast" VARCHAR(50),  -- Ulnohumeral hemiarthroplasty - distal humerus hemiarthroplas
    "dem_ulnohumeral_hemiarthroplasty_uncemented_subtypes" JSONB,  -- Ulnohumeral hemiarthroplasty - uncemented subtypes
    "dem_ulnohumeral_total_arthroplasty_distal_humerus_component_des" VARCHAR(50),  -- Ulnohumeral total arthroplasty - distal humerus component de
    "dem_ulnohumeral_total_arthroplasty_distal_humerus_component_bea" VARCHAR(50),  -- Ulnohumeral total arthroplasty - distal humerus component be
    "dem_ulnohumeral_total_arthroplasty_distal_humerus_component_fix" VARCHAR(50),  -- Ulnohumeral total arthroplasty - distal humerus component fi
    "dem_ulnohumeral_total_arthroplasty_uncemented_subtypes" JSONB,  -- Ulnohumeral total arthroplasty - uncemented subtypes
    "dem_ulnohumeral_total_arthroplasty_ulna_component_design" VARCHAR(50),  -- Ulnohumeral total arthroplasty - ulna component design
    "dem_ulnohumeral_total_arthroplasty_ulna_component_bearing_surfa" VARCHAR(50),  -- Ulnohumeral total arthroplasty - ulna component bearing surf
    "dem_ulnohumeral_total_arthroplasty_ulna_component_fixation" VARCHAR(50),  -- Ulnohumeral total arthroplasty - ulna component fixation
    "dem_ulnohumeral_total_arthroplasty_uncemented_subtypes_ulna_sid" JSONB,  -- Ulnohumeral total arthroplasty - uncemented subtypes (ulna s
    "dem_ulnohumeral_total_arthroplasty_implant_linkage_options" VARCHAR(50),  -- Ulnohumeral total arthroplasty - implant linkage options
    "dem_ulnohumeral_arthroplasty_approach" VARCHAR(50),  -- Ulnohumeral arthroplasty approach
    "dem_ulnohumeral_arthroplasty_triceps_off_type" VARCHAR(50),  -- Ulnohumeral arthroplasty - triceps 'off' type
    "dem_radiocapitellar_arthroplasty_type" VARCHAR(50),  -- Radiocapitellar arthroplasty type
    "dem_radiocapitellar_arthroplasty_spacer_type" VARCHAR(50),  -- Radiocapitellar arthroplasty spacer type
    "dem_radiocapitellar_arthroplasty_spacer_location" VARCHAR(50),  -- Radiocapitellar arthroplasty spacer location
    "dem_radiocapitellar_arthroplasty_anatomic_subtypes" VARCHAR(50),  -- Radiocapitellar arthroplasty anatomic subtypes
    "dem_radiocapitellar_arthroplasty_capitellar_hemiarthroplasty_co" VARCHAR(50),  -- Radiocapitellar arthroplasty - capitellar hemiarthroplasty c
    "dem_radiocapitellar_arthroplasty_capitellar_hemiarthroplasty_co" VARCHAR(50),  -- Radiocapitellar arthroplasty - capitellar hemiarthroplasty c
    "dem_radiocapitellar_arthroplasty_capitellar_hemiarthroplasty_co" VARCHAR(50),  -- Radiocapitellar arthroplasty - capitellar hemiarthroplasty c
    "dem_radiocapitellar_arthroplasty_capitellar_hemiarthroplasty_un" VARCHAR(50),  -- Radiocapitellar arthroplasty - capitellar hemiarthroplasty u
    "dem_radiocapitellar_arthroplasty_capitellar_component_design" VARCHAR(50),  -- Radiocapitellar arthroplasty - capitellar component design
    "dem_radiocapitellar_arthroplasty_capitellar_component_bearing_s" VARCHAR(50),  -- Radiocapitellar arthroplasty - capitellar component bearing 
    "dem_radiocapitellar_arthroplasty_capitellar_component_fixation" VARCHAR(50),  -- Radiocapitellar arthroplasty - capitellar component fixation
    "dem_radiocapitellar_arthroplasty_capitellar_uncemented_subtypes" VARCHAR(50),  -- Radiocapitellar arthroplasty - capitellar uncemented subtype
    "dem_radiocapitellar_arthroplasty_proximal_radius_component_desi" VARCHAR(50),  -- Radiocapitellar arthroplasty - proximal radius component des
    "dem_radiocapitellar_arthroplasty_proximal_radius_component_bear" VARCHAR(50),  -- Radiocapitellar arthroplasty - proximal radius component bea
    "dem_radiocapitellar_arthroplasty_proximal_radius_component_fixa" VARCHAR(50),  -- Radiocapitellar arthroplasty - proximal radius component fix
    "dem_radiocapitellar_arthroplasty_proximal_radius_uncemented_sub" VARCHAR(50),  -- Radiocapitellar arthroplasty - proximal radius uncemented su
    "dem_ulnohumeral_radiocapitellar_ulnohumeral_interposition_arthr" VARCHAR(500),  -- Ulnohumeral & Radiocapitellar - ulnohumeral interposition ar
    "dem_ulnohumeral_radiocapitellar_radiocapitellar_interposition_a" VARCHAR(500),  -- Ulnohumeral & Radiocapitellar - radiocapitellar interpositio
    "dem_ulnohumeral_arthrodesis_type" JSONB,  -- Ulnohumeral arthrodesis type
    "dem_ulnohumeral_arthrodesis_implant" JSONB,  -- Ulnohumeral arthrodesis implant
    "dem_ulnohumeral_arthrodesis_bone_graft" JSONB,  -- Ulnohumeral arthrodesis bone graft
    "dem_uh_rc_stabilisation_type" JSONB,  -- Ulnohumeral +- Radiocapitellar Stabilisation Type
    "dem_rcl_capsule_ligament_repair_type" JSONB,  -- RCL capsule / ligament repair type
    "dem_rcl_capsule_ligament_to_bone_fixation_type_proximal" JSONB,  -- RCL capsule / ligament to bone fixation type - proximal
    "dem_rcl_capsule_ligament_to_bone_fixation_type_distal" JSONB,  -- RCL capsule / ligament to bone fixation type - distal
    "dem_lucl_capsule_ligament_repair_type" JSONB,  -- LUCL capsule / ligament repair type
    "dem_lucl_capsule_ligament_to_bone_fixation_type_proximal" JSONB,  -- LUCL capsule / ligament to bone fixation type - proximal
    "dem_lucl_capsule_ligament_to_bone_fixation_type_distal" JSONB,  -- LUCL capsule / ligament to bone fixation type - distal
    "dem_al_capsule_ligament_repair_type" JSONB,  -- Annular Ligament capsule / ligament repair type
    "dem_al_capsule_ligament_to_bone_fixation_type_proximal" JSONB,  -- Annular Ligament capsule / ligament to bone fixation type - 
    "dem_al_capsule_ligament_to_bone_fixation_type_distal" JSONB,  -- Annular Ligament capsule / ligament to bone fixation type - 
    "dem_anterior_band_mucl_capsule_ligament_repair_type" JSONB,  -- Anterior Band MUCL capsule / ligament repair type
    "dem_anterior_band_mucl_capsule_ligament_to_bone_fixation_type_p" JSONB,  -- Anterior Band MUCL capsule / ligament to bone fixation type 
    "dem_anterior_band_mucl_capsule_ligament_to_bone_fixation_type_d" JSONB,  -- Anterior Band MUCL capsule / ligament to bone fixation type 
    "dem_posterior_band_mucl_capsule_ligament_repair_type" JSONB,  -- Posterior Band MUCL capsule / ligament repair type
    "dem_posterior_band_mucl_capsule_ligament_to_bone_fixation_type_" JSONB,  -- Posterior Band MUCL capsule / ligament to bone fixation type
    "dem_posterior_band_mucl_capsule_ligament_to_bone_fixation_type_" JSONB,  -- Posterior Band MUCL capsule / ligament to bone fixation type
    "dem_anterior_capsule_repair_type" JSONB,  -- Anterior capsule repair type
    "dem_anterior_capsule_to_bone_fixation_type_proximal" JSONB,  -- Anterior capsule to bone fixation type - proximal
    "dem_anterior_capsule_to_bone_fixation_type_distal" JSONB,  -- Anterior capsule to bone fixation type - distal
    "dem_osbourne_cotterill_posterolateral_ligament_repair_type" JSONB,  -- Osborne-Cotterill (posterolateral) ligament repair type
    "dem_osbourne_cotterill_posterolateral_ligament_to_bone_fixation" JSONB,  -- Osbourne-Cotterill (posterolateral) ligament to bone fixatio
    "dem_osbourne_cotterill_posterolateral_ligament_to_bone_fixation" JSONB,  -- Osbourne-Cotterill (posterolateral) ligament to bone fixatio
    "dem_lateral_humeral_avulsion_fracture_fixation_type" JSONB,  -- Lateral - Humeral avulsion fracture fixation type
    "dem_lateral_ulna_avulsion_fracture_fixation_type" JSONB,  -- Lateral - Ulna avulsion fracture fixation type
    "dem_medial_humeral_avulsion_fracture_fixation_type" JSONB,  -- Medial - Humeral avulsion fracture fixation type
    "dem_medial_ulna_avulsion_fracture_fixation_type" JSONB,  -- Medial - Ulna avulsion fracture fixation type
    "dem_lateral_ligament_complex_reconstruction_graft_type" JSONB,  -- Lateral ligament complex reconstruction graft type
    "dem_lateral_ligament_complex_reconstruction_bone_fixation_type_" JSONB,  -- Lateral ligament complex reconstruction bone fixation type -
    "dem_lateral_ligament_complex_reconstruction_bone_fixation_type_" JSONB,  -- Lateral ligament complex reconstruction bone fixation type -
    "dem_lateral_ligament_complex_reconstruction_limbs" VARCHAR(50),  -- Lateral ligament complex reconstruction limbs
    "dem_medial_ligament_complex_reconstruction_graft_type" JSONB,  -- Medial ligament complex reconstruction graft type
    "dem_medial_ligament_complex_reconstruction_bone_fixation_type_p" JSONB,  -- Medial ligament complex reconstruction bone fixation type - 
    "dem_medial_ligament_complex_reconstruction_bone_fixation_type_d" JSONB,  -- Medial ligament complex reconstruction bone fixation type - 
    "dem_medial_ligament_complex_reconstruction_limbs" VARCHAR(50),  -- Medial ligament complex reconstruction limbs
    "dem_proximal_radius_bone_graft_reconstruction_type" JSONB,  -- Proximal radius - Bone graft / reconstruction - type
    "dem_proximal_radius_bone_graft_reconstruction_fixation_type" JSONB,  -- Proximal radius - Bone graft / reconstruction - fixation typ
    "dem_proximal_radius_bone_graft_reconstruction_location" JSONB,  -- Proximal radius - Bone graft / reconstruction - location
    "dem_coronoid_process_bone_graft_reconstruction_type" JSONB,  -- Coronoid process - Bone graft / reconstruction - intraarticu
    "dem_coronoid_process_bone_graft_reconstruction_fixation_type" JSONB,  -- Coronoid process - Bone graft / reconstruction - fixation ty
    "dem_coronoid_process_bone_graft_reconstruction_location" JSONB,  -- Coronoid process - Bone graft / reconstruction - location
    "dem_olecranon_process_bone_graft_reconstruction_type" JSONB,  -- Olecranon process - Bone graft / reconstruction - type
    "dem_olecranon_process_bone_graft_reconstruction_fixation_type" JSONB,  -- Olecranon process - Bone graft / reconstruction - fixation t
    "dem_olecranon_process_bone_graft_reconstruction_location" JSONB,  -- Olecranon process - Bone graft / reconstruction - location
    "dem_distal_humerus_bone_graft_reconstruction_type_x" JSONB,  -- Distal humerus - Bone graft / reconstruction - type
    "dem_distal_humerus_bone_graft_reconstruction_fixation_type_x" JSONB,  -- Distal Humerus - Bone graft / reconstruction - fixation type
    "dem_distal_humerus_bone_graft_reconstruction_location_x" JSONB,  -- Distal Humerus - Bone graft / reconstruction - location
    "dem_ulnohumeral_radiocapitellar_joint_spanning_fixation_type" JSONB,  -- Ulnohumeral +- Radiocapitellar joint spanning fixation type
    "dem_ulnohumeral_and_radiocapitellar_arthrolysis_release_techniq" JSONB,  -- Ulnohumeral and Radiocapitellar Arthrolysis / Release Techni
    "dem_ulnohumeral_and_radiocapitellar_articular_cartilage_treatme" JSONB,  -- Ulnohumeral and Radiocapitellar Articular Cartilage Treatmen
    "dem_ulnohumeral_and_radiocapitellar_biopsy_tissue" JSONB,  -- Ulnohumeral and Radiocapitellar Biopsy Tissue
    "dem_ulnohumeral_and_radiocapitellar_periarticular_cyst_treatmen" VARCHAR(50),  -- Ulnohumeral and Radiocapitellar Periarticular Cyst Treatment
    "dem_ulnohumeral_and_radiocapitellar_reduction_native_joint" VARCHAR(50),  -- Ulnohumeral and Radiocapitellar reduction - native joint
    "dem_ulnohumeral_and_radiocapitellar_reduction_arthroplasty" VARCHAR(50),  -- Ulnohumeral and Radiocapitellar reduction - arthroplasty
    "dem_ulnohumeral_and_radiocapitellar_extent_of_implant_removal_a" VARCHAR(50),  -- Ulnohumeral and Radiocapitellar extent of implant removal - 
    "dem_ulnohumeral_and_radiocapitellar_implants_removed_arthroplas" VARCHAR(500),  -- Ulnohumeral and Radiocapitellar implants removed - arthropla
    "dem_ulnohumeral_and_radiocapitellar_implants_retained_arthropla" VARCHAR(500),  -- Ulnohumeral and Radiocapitellar implants retained - arthropl
    "dem_ulnohumeral_and_radiocapitellar_extent_of_implant_removal_n" VARCHAR(50),  -- Ulnohumeral and Radiocapitellar extent of implant removal - 
    "dem_ulnohumeral_and_radiocapitellar_implants_removed_non_arthro" VARCHAR(500),  -- Ulnohumeral and Radiocapitellar implants removed - non-arthr
    "dem_ulnohumeral_and_radiocapitellar_implants_retained_non_arthr" VARCHAR(500),  -- Ulnohumeral and Radiocapitellar implants retained - non-arth
    "dem_forearm_articulation_pruj_druj_stabilisation_type" JSONB,  -- Forearm Articulation ± PRUJ ± DRUJ stabilisation type
    "dem_annular_ligament_repair" JSONB,  -- Annular ligament repair type
    "dem_annular_ligament_repair_to_bone_fixation_proximal" JSONB,  -- Annular ligament repair to bone fixation - proximal
    "dem_annular_ligament_repair_to_bone_fixation_distal" JSONB,  -- Annular ligament repair to bone fixation - distal
    "dem_quadrate_ligament_repair_type" JSONB,  -- Quadrate ligament repair type
    "dem_quadrate_ligament_repair_to_bone_fixation_proximal" JSONB,  -- Quadrate ligament repair to bone fixation - proximal
    "dem_quadrate_ligament_repair_to_bone_fixation_distal" JSONB,  -- Quadrate ligament repair to bone fixation - distal
    "dem_proximal_oblique_cord_repair_type" JSONB,  -- Proximal oblique cord repair type
    "dem_proximal_oblique_cord_repair_to_bone_fixation_proximal" JSONB,  -- Proximal oblique cord repair to bone fixation - proximal
    "dem_proximal_oblique_cord_repair_to_bone_fixation_distal" JSONB,  -- Proximal oblique cord repair to bone fixation - distal
    "dem_interosseus_membrane_repair_type" JSONB,  -- Interosseus membrane repair type
    "dem_interosseus_membrane_repair_to_bone_fixation_proximal" JSONB,  -- Interosseus membrane repair to bone fixation - proximal
    "dem_interosseus_membrane_repair_to_bone_fixation_distal" JSONB,  -- Interosseus membrane repair to bone fixation - distal
    "dem_distal_oblique_band_repair_type" JSONB,  -- Distal oblique band repair type
    "dem_distal_oblique_band_repair_to_bone_fixation_proximal" JSONB,  -- Distal oblique band repair to bone fixation - proximal
    "dem_distal_oblique_band_repair_to_bone_fixation_distal" JSONB,  -- Distal oblique band repair to bone fixation - distal
    "dem_druj_capsule_tfcc_repair_type" JSONB,  -- DRUJ capsule / TFCC repair type
    "dem_druj_capsule_tfcc_repair_to_bone_fixation_proximal" JSONB,  -- DRUJ capsule / TFCC repair to bone fixation - proximal
    "dem_druj_capsule_tfcc_repair_to_bone_fixation_distal" JSONB,  -- DRUJ capsule / TFCC repair to bone fixation - distal
    "dem_annular_ligament_reconstruction_implant_graft_type" JSONB,  -- Annular ligament reconstruction - implant / graft type
    "dem_annular_ligament_reconstruction_fixation_type_proximal" JSONB,  -- Annular ligament reconstruction - fixation type - proximal
    "dem_annular_ligament_reconstruction_fixation_type_distal" JSONB,  -- Annular ligament reconstruction - fixation type - distal
    "dem_proximal_oblique_cord_reconstruction_implant_graft_type" JSONB,  -- Proximal oblique cord reconstruction - implant / graft type
    "dem_proximal_oblique_cord_reconstruction_fixation_type_proximal" JSONB,  -- Proximal oblique cord reconstruction - fixation type - proxi
    "dem_proximal_oblique_cord_reconstruction_fixation_type_distal" JSONB,  -- Proximal oblique cord reconstruction - fixation type - dista
    "dem_interosseus_membrane_reconstruction_implant_graft_type" JSONB,  -- Interosseus membrane reconstruction - implant / graft type
    "dem_interosseus_membrane_reconstruction_fixation_type_proximal" JSONB,  -- Interosseus membrane reconstruction - fixation type - proxim
    "dem_interosseus_membrane_reconstruction_fixation_type_distal" JSONB,  -- Interosseus membrane reconstruction - fixation type - distal
    "dem_distal_oblique_band_reconstruction_implant_graft_type" JSONB,  -- Distal oblique band reconstruction - implant / graft type
    "dem_distal_oblique_band_reconstruction_fixation_type_proximal" JSONB,  -- Distal oblique band reconstruction - fixation type - proxima
    "dem_distal_oblique_band_reconstruction_fixation_type_distal" JSONB,  -- Distal oblique band reconstruction - fixation type - distal
    "dem_druj_capsule_reconstruction_implant_graft_type" JSONB,  -- DRUJ capsule reconstruction - implant / graft type
    "dem_druj_capsule_reconstruction_fixation_type_proximal" JSONB,  -- DRUJ capsule reconstruction - fixation type - proximal
    "dem_druj_capsule_reconstruction_fixation_type_distal" JSONB,  -- DRUJ capsule reconstruction - fixation type - distal
    "dem_avulsion_fracture_fixation_pruj_fixation_type" JSONB,  -- Avulsion fracture fixation - PRUJ fixation type
    "dem_avulsion_fracture_fixation_druj_fixation_type" JSONB,  -- Avulsion fracture fixation - DRUJ fixation type
    "dem_joint_spanning_fixation_pruj_fixation_type" JSONB,  -- Joint spanning fixation - PRUJ fixation type
    "dem_joint_spanning_fixation_forearm_fixation_type" JSONB,  -- Joint spanning fixation - Forearm fixation type
    "dem_joint_spanning_fixation_druj_fixation_type" JSONB,  -- Joint spanning fixation - DRUJ fixation type
    "dem_pruj_intraarticular_bone_graft_reconstruction_type" JSONB,  -- PRUJ intraarticular bone graft / reconstruction type
    "dem_pruj_intraarticular_bone_graft_reconstruction_fixation_type" JSONB,  -- PRUJ intraarticular bone graft / reconstruction fixation typ
    "dem_pruj_intraarticular_bone_graft_reconstruction_location" JSONB,  -- PRUJ intraarticular bone graft / reconstruction location
    "dem_druj_bone_graft_reconstruction_type" JSONB,  -- DRUJ bone graft / reconstruction type
    "dem_druj_bone_graft_reconstruction_fixation_type" JSONB,  -- DRUJ bone graft / reconstruction fixation type
    "dem_druj_bone_graft_reconstruction_location" JSONB,  -- DRUJ bone graft / reconstruction location
    "dem_pruj_arthrolysis_techniques" JSONB,  -- PRUJ arthrolysis techniques
    "dem_druj_arthrolysis_techniques" JSONB,  -- DRUJ arthrolysis techniques
    "dem_pruj_debridement_arthroplasty" JSONB,  -- PRUJ debridement arthroplasty
    "dem_pruj_interposition_arthroplasty_material" VARCHAR(500),  -- PRUJ interposition arthroplasty material
    "dem_druj_debridement_arthroplasty" JSONB,  -- DRUJ debridement arthroplasty
    "dem_druj_interposition_arthroplasty_material" VARCHAR(500),  -- DRUJ interposition arthroplasty material
    "dem_pruj_biopsy_tissue" JSONB,  -- PRUJ biopsy tissue
    "dem_druj_biopsy_tissue" JSONB,  -- DRUJ biopsy tissue
    "dem_pruj_periarticular_cyst_treatment" VARCHAR(50),  -- PRUJ periarticular cyst treatment
    "dem_druj_periarticular_cyst_treatment_2" VARCHAR(50),  -- DRUJ periarticular cyst treatment
    "dem_pruj_reduction_native_joint" VARCHAR(50),  -- PRUJ reduction - native joint
    "dem_druj_reduction_native_joint" VARCHAR(50),  -- DRUJ reduction - native joint
    "dem_pruj_reduction_arthroplasty" VARCHAR(50),  -- PRUJ reduction - arthroplasty
    "dem_druj_reduction_arthroplasty" VARCHAR(50),  -- DRUJ reduction - arthroplasty
    "dem_pruj_extent_of_implant_removal_arthroplasty" VARCHAR(50),  -- PRUJ extent of implant removal - arthroplasty
    "dem_pruj_implants_removed_arthroplasty" VARCHAR(500),  -- PRUJ implants removed - arthroplasty
    "dem_pruj_implants_retained_arthroplasty" VARCHAR(500),  -- PRUJ implants retained - arthroplasty
    "dem_druj_extent_of_implant_removal_arthroplasty" VARCHAR(50),  -- DRUJ extent of implant removal - arthroplasty
    "dem_druj_implants_removed_arthroplasty" VARCHAR(500),  -- DRUJ implants removed - arthroplasty
    "dem_druj_implants_retained_arthroplasty" VARCHAR(500),  -- DRUJ implants retained - arthroplasty
    "dem_pruj_extent_of_implant_removal_non_arthroplasty" VARCHAR(50),  -- PRUJ extent of implant removal - non-arthroplasty
    "dem_pruj_implants_removed_non_arthroplasty" VARCHAR(500),  -- PRUJ implants removed - non-arthroplasty
    "dem_pruj_implants_retained_non_arthroplasty" VARCHAR(500),  -- PRUJ implants retained - non-arthroplasty
    "dem_druj_extent_of_implant_removal_non_arthroplasty" VARCHAR(50),  -- DRUJ extent of implant removal - non-arthroplasty
    "dem_druj_implants_removed_non_arthroplasty" VARCHAR(500),  -- DRUJ implants removed - non-arthroplasty
    "dem_druj_implants_retained_non_arthroplasty" VARCHAR(500),  -- DRUJ implants retained - non-arthroplasty
    "dem_distal_biceps_tendon_repair_type" JSONB,  -- Distal Biceps Tendon - repair type
    "dem_distal_biceps_tendon_repair_technique" VARCHAR(50),  -- Distal Biceps Tendon - repair technique
    "dem_distal_biceps_tendon_repair_fixation_type" JSONB,  -- Distal Biceps Tendon - repair fixation type
    "dem_distal_biceps_tendon_augmentation_implant_options" JSONB,  -- Distal Biceps Tendon - augmentation implant options
    "dem_distal_biceps_tendon_reconstruction_implant_options" JSONB,  -- Distal Biceps Tendon - reconstruction implant options
    "dem_distal_biceps_tendon_reconstruction_technique" VARCHAR(50),  -- Distal Biceps Tendon - reconstruction technique
    "dem_distal_biceps_tendon_reconstruction_fixation_options" JSONB,  -- Distal Biceps Tendon - reconstruction fixation options
    "dem_distal_triceps_tendon_repair_type" JSONB,  -- Distal Triceps Tendon - repair type
    "dem_distal_triceps_tendon_repair_outcome" VARCHAR(50),  -- Distal Triceps Tendon - repair outcome
    "dem_distal_triceps_tendon_repair_fixation_type" JSONB,  -- Distal Triceps Tendon - repair fixation type
    "dem_distal_triceps_tendon_augmentation_implant_options" JSONB,  -- Distal Triceps Tendon - augmentation implant options
    "dem_distal_triceps_tendon_reconstruction_implant_options" JSONB,  -- Distal Triceps Tendon - reconstruction implant options
    "dem_distal_triceps_tendon_reconstruction_technique" VARCHAR(50),  -- Distal Triceps Tendon - reconstruction technique
    "dem_distal_triceps_tendon_reconstruction_fixation_options" JSONB,  -- Distal Triceps Tendon - reconstruction fixation options
    "dem_ceo_repair_type" JSONB,  -- Common Extensor Origin - repair type
    "dem_coe_repair_outcome" VARCHAR(50),  -- Common Extensor Origin - repair outcome
    "dem_ceo_repair_fixation_type" JSONB,  -- Common Extensor Origin - repair fixation type
    "dem_ceo_augmentation_implant_options" JSONB,  -- Common Extensor Origin - augmentation implant options
    "dem_ceo_reconstruction_implant_options" JSONB,  -- Common Extensor Origin - reconstruction implant options
    "dem_cfo_repair_type" JSONB,  -- Common Flexor Origin - repair type
    "dem_cfo_repair_outcome" VARCHAR(50),  -- Common Flexor Origin - repair outcome
    "dem_cfo_repair_fixation_type" JSONB,  -- Common Flexor Origin - repair fixation type
    "dem_cfo_augmentation_implant_options" JSONB,  -- Common Flexor Origin - augmentation implant options
    "dem_cfo_reconstruction_implant_options" JSONB,  -- Common Flexor Origin - reconstruction implant options
    "dem_tendon_donor" VARCHAR(500),  -- Tendon Donor
    "dem_radial_nerve_spiral_groove_treatment" JSONB,  -- Radial nerve spiral groove - treatment
    "dem_radial_nerve_spiral_groove_decompression_technique" JSONB,  -- Radial nerve spiral groove - decompression technique
    "dem_radial_nerve_or_pin_radial_tunnel_treatment" JSONB,  -- Radial nerve or PIN radial tunnel - treatment
    "dem_radial_nerve_or_pin_radial_tunnel_decompression_technique" JSONB,  -- Radial nerve or PIN radial tunnel - decompression technique
    "dem_neuropathy_treatment_approach" VARCHAR(50),  -- Neuropathy Treatment Approach
    "dem_neuropathy_guidance_options" JSONB,  -- Neuropathy Guidance Options
    "dem_neuropathy_injectable_treatment" JSONB,  -- Neuropathy Injectable Treatment
    "dem_neuropathy_treatment_additional_notes" TEXT,  -- Neuropathy Treatment Additional Notes
    "dem_olecranon_fracture_reduction" VARCHAR(50),  -- Olecranon fracture reduction
    "dem_olecranon_fixation_not_joint_spanning" JSONB,  -- Olecranon fixation - not joint spanning
    "dem_olecranon_fixation_interosseous_but_not_joint_spanning_fixa" JSONB,  -- Olecranon fixation - interosseous (but not joint spanning) -
    "dem_olecranon_fixation_interosseous_but_not_joint_spanning_prox" JSONB,  -- Olecranon fixation - interosseous (but not joint spanning) -
    "dem_olecranon_fixation_interosseous_but_not_joint_spanning_dist" JSONB,  -- Olecranon fixation - interosseous (but not joint spanning) -
    "dem_olecranon_fixation_interosseous_but_not_joint_spanning_prox" JSONB,  -- Olecranon fixation - interosseous (but not joint spanning) -
    "dem_olecranon_fixation_interosseous_but_not_joint_spanning_dist" JSONB,  -- Olecranon fixation - interosseous (but not joint spanning) -
    "dem_olecranon_osteotomy_location" JSONB,  -- Olecranon osteotomy location
    "dem_olecranon_osteotomy_type" VARCHAR(500),  -- Olecranon osteotomy type
    "dem_olecranon_removal_of_implants" VARCHAR(50),  -- Olecranon removal of implants
    "dem_olecranon_implants_removed" VARCHAR(500),  -- Olecranon implants removed
    "dem_olecranon_implants_retained" VARCHAR(500),  -- Olecranon implants retained
    "dem_coronoid_fracture_reduction" VARCHAR(50),  -- Coronoid fracture reduction
    "dem_coronoid_fixation" JSONB,  -- Coronoid fixation
    "dem_coronoid_process_bone_graft_reconstruction_extraarticular_t" JSONB,  -- Coronoid process bone graft / reconstruction - extraarticula
    "dem_coronoid_osteotomy_location" JSONB,  -- Coronoid osteotomy location
    "dem_coronoid_osteotomy_type" VARCHAR(500),  -- Coronoid osteotomy type
    "dem_coronoid_removal_of_implants" VARCHAR(50),  -- Coronoid removal of implants
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for demographics_part_2_part_2
CREATE INDEX IF NOT EXISTS idx_demographics_part_2_part_2_encounter ON demographics_part_2_part_2(encounter_id);
CREATE INDEX IF NOT EXISTS idx_demographics_part_2_part_2_created ON demographics_part_2_part_2(created_at);

-- Foreign key constraint
ALTER TABLE demographics_part_2_part_2
    ADD CONSTRAINT fk_demographics_part_2_part_2_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


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


-- Table: shoulder_general_part_2_part_2
-- Generated: 2025-11-28T20:28:38.891045
-- Fields: 250

CREATE TABLE IF NOT EXISTS shoulder_general_part_2_part_2 (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_teres_major_other" TEXT,  -- Teres major other
    "orth_sh_prox_humerus_bone_quality" VARCHAR(50),  -- Prox humerus bone quality
    "orth_sh_proximal_humeral_cystic_lesion" TEXT,  -- Proximal humeral cystic lesion
    "orth_sh_prox_humeral_fracture_sequelae_deformity_subtype" JSONB,  -- Prox humeral fracture sequelae deformity subtype
    "orth_sh_prox_humeral_fracture_hertel_any" JSONB,  -- Prox humeral fracture Hertel any
    "orth_sh_prox_humeral_fracture_hertel_displaced" JSONB,  -- Prox humerus fracture Hertel displaced
    "orth_sh_proximal_humerus_fracture_closed_or_open" VARCHAR(50),  -- Prox humerus fracture closed or open
    "orth_sh_proximal_humerus_fracture_open_grade_gustilo" VARCHAR(50),  -- Prox Humerus Fracture Open Grade (Gustilo)
    "orth_sh_head_fragment_dislocated" VARCHAR(50),  -- Head fragment dislocated
    "orth_sh_head_split" VARCHAR(50),  -- Head split
    "orth_sh_head_fragment_orientation" VARCHAR(50),  -- Head fragment orientation
    "orth_sh_medial_hinge" VARCHAR(50),  -- Medial hinge
    "orth_sh_calcar_length" VARCHAR(50),  -- Calcar length
    "orth_sh_proximal_humerus_deformity" VARCHAR(500),  -- Proximal humerus deformity
    "orth_sh_prox_humerus_tumour_classification" VARCHAR(50),  -- Prox humerus tumour classification
    "orth_sh_proximal_humerus_infection_chronicity" VARCHAR(50),  -- Prox humerus infection chronicity
    "orth_sh_proximal_humerus_infection_aetiology" VARCHAR(50),  -- Proximal humerus infection Aetiology
    "orth_sh_prox_humerus_infection_organsim" VARCHAR(50),  -- Prox humerus infection Organsim
    "orth_sh_prox_humerus_bone_loss_extraarticular" TEXT,  -- Prox humerus bone loss extraarticular
    "orth_sh_prox_humerus_sequelae_non_arthroplasty_implants" VARCHAR(50),  -- Prox humerus sequelae non-arthroplasty implants
    "orth_sh_prox_humerus_other" TEXT,  -- Prox humerus other
    "orth_sh_hum_diaph_fracture_sequelae_deformity_subtypes" VARCHAR(50),  -- Hum diaph fracture sequelae deformity subtypes
    "orth_sh_hum_diaph_fracture_type_ao" VARCHAR(50),  -- Hum diaph fracture type AO
    "orth_sh_hum_diaph_classification_other" TEXT,  -- Hum diaph classification other
    "orth_sh_hum_diaph_fracture_closed_or_open" VARCHAR(50),  -- Hum diaph fracture closed or open
    "orth_sh_hum_diaph_open_grade_gustilo" VARCHAR(50),  -- Hum diaph open grade Gustilo
    "orth_sh_hum_diaphysis_deformity" VARCHAR(500),  -- Hum diaphysis deformity
    "orth_sh_hum_diaph_tumour_type" VARCHAR(50),  -- Hum diaph tumour type
    "orth_sh_hum_diaph_infection_chronicity" VARCHAR(50),  -- Hum diaph infection chronicity
    "orth_sh_hum_diaph_infection_aetiology" VARCHAR(50),  -- Hum diaph infection aetiology
    "orth_sh_hum_diaph_infection_organism" VARCHAR(50),  -- Hum diaph infection organsim
    "orth_sh_hum_diaph_bone_loss_extraarticular" TEXT,  -- Hum diaph bone loss extraarticular
    "orth_sh_hum_diaph_sequelae_non_arthroplasty_implants" VARCHAR(50),  -- Hum diaph sequelae non arthroplasty implants
    "orth_sh_hum_diaph_other" TEXT,  -- Hum diaph other
    "orth_sh_compartment_syndrome_type" VARCHAR(50),  -- Compartment syndrome type
    "orth_sh_compartments_involved" VARCHAR(500),  -- Compartments involved
    "orth_sh_fascia_infection_chronicity" VARCHAR(50),  -- Fascia infection chronicity
    "orth_sh_fascia_infection_aetiology" VARCHAR(50),  -- Fascia infection aetiology
    "orth_sh_fascia_infection_organism" JSONB,  -- Fascia infection organism
    "orth_sh_surgical_site_infection_chronicity" VARCHAR(50),  -- Surgical site infection chronicity
    "orth_sh_surgical_site_infection_aetiology" VARCHAR(50),  -- Surgical site infection aetiology
    "orth_sh_surgical_site_infection_organism" JSONB,  -- Surgical site infection organism
    "orth_sh_infection_other_location" VARCHAR(500),  -- Infection other location
    "orth_sh_infection_other_chronicity" VARCHAR(50),  -- Infection other chronicity
    "orth_sh_infection_other_aetiology" JSONB,  -- Infection other aetiology
    "orth_sh_infection_other_organism" JSONB,  -- Infection other organism
    "orth_sh_symptoms" JSONB,  -- Symptoms
    "orth_sh_pain_location" JSONB,  -- Pain location
    "orth_sh_stiffness" JSONB,  -- Stiffness
    "orth_sh_weakness" JSONB,  -- Weakness
    "orth_sh_instability_number_of_episodes" TEXT,  -- Instability number of episodes
    "orth_sh_deformity" TEXT,  -- Deformity
    "orth_sh_parasthaesia_dysaesthesia_location" JSONB,  -- Parasthaesia Dysaesthesia location
    "orth_sh_symptoms_other" TEXT,  -- Symptoms other
    "orth_sh_symptom_onset" VARCHAR(50),  -- Symptom onset
    "orth_sh_mechanism_of_injury" TEXT,  -- Mechanism of Injury
    "orth_sh_date_of_injury" DATE,  -- Date of injury
    "orth_sh_symptom_course" VARCHAR(500),  -- Symptom course
    "orth_sh_effects_of_symptoms" JSONB,  -- Effects of symptoms
    "orth_sh_prior_treatment" JSONB,  -- Prior treatment
    "orth_sh_prior_treatment_other" TEXT,  -- Prior treatment other
    "orth_sh_shoulder_rom_active_flexion" VARCHAR(50),  -- Shoulder ROM active flexion
    "orth_sh_shoulder_rom_active_abduction" VARCHAR(50),  -- Shoulder ROM active abduction
    "orth_sh_shoulder_rom_active_er1" VARCHAR(50),  -- Shoulder ROM active ER1
    "orth_sh_shoulder_rom_active_er_cms" JSONB,  -- Shoulder ROM active ER CMS
    "orth_sh_shoulder_rom_active_er2" VARCHAR(50),  -- Shoulder ROM active ER2
    "orth_sh_shoulder_rom_active_ir" VARCHAR(50),  -- Shoulder ROM active IR
    "orth_sh_shoulder_rom_passive_abduction" VARCHAR(50),  -- Shoulder ROM passive abduction
    "orth_sh_shoulder_rom_passive_er1" VARCHAR(50),  -- Shoulder ROM passive ER1
    "orth_sh_shoulder_rom_passive_er2" VARCHAR(50),  -- Shoulder ROM passive ER2
    "orth_sh_shoulder_rom_passive_ir" VARCHAR(50),  -- Shoulder ROM passive IR
    "orth_sh_shoulder_lag_er1" VARCHAR(50),  -- Shoulder lag ER1
    "orth_sh_shoulder_lag_er2" JSONB,  -- Shoulder lag ER2
    "orth_sh_shoulder_lag_ir" VARCHAR(50),  -- Shoulder lag IR
    "orth_sh_shoulder_power_er1" VARCHAR(50),  -- Shoulder power ER1
    "orth_sh_shoulder_power_er2" VARCHAR(50),  -- Shoulder power ER2
    "orth_sh_shoulder_power_ir" VARCHAR(50),  -- Shoulder power IR
    "orth_sh_stam" VARCHAR(50),  -- STAM
    "orth_sh_flexion_resistance_test_30" VARCHAR(50),  -- Flexion resistance test 30
    "orth_sh_flexion_resistance_test_60" VARCHAR(50),  -- Flexion resistance test 60
    "orth_sh_flexion_resistance_test_90" VARCHAR(50),  -- Flexion resistance test 90
    "orth_sh_scapula_repositioning_test_trapezius" VARCHAR(50),  -- Scapula repositioning test (trapezius)
    "orth_sh_scapula_compression_test_serratus" VARCHAR(50),  -- Scapula compression test (serratus)
    "orth_sh_power_rhomboid" VARCHAR(50),  -- Power Rhomboid
    "orth_sh_power_serratus_anterior" VARCHAR(50),  -- Power Serratus Anterior
    "orth_sh_power_deltoid_anterior" VARCHAR(50),  -- Power Deltoid Anterior
    "orth_sh_power_deltoid_middle" VARCHAR(50),  -- Power Deltoid Middle
    "orth_sh_power_deltoid_posterior" VARCHAR(50),  -- Power Deltoid Posterior
    "orth_sh_power_subscapularis" VARCHAR(50),  -- Power Subscapularis
    "orth_sh_power_supraspinatus" VARCHAR(50),  -- Power Supraspinatus
    "orth_sh_power_infraspinatus" VARCHAR(50),  -- Power Infraspinatus
    "orth_sh_power_teres_minor" VARCHAR(50),  -- Power Teres Minor
    "orth_sh_power_lat_dorsi" VARCHAR(50),  -- Power Lat Dorsi
    "orth_sh_power_pec_major" VARCHAR(50),  -- Power Pec Major
    "orth_sh_power_biceps" VARCHAR(50),  -- Power Biceps
    "orth_sh_power_triceps" VARCHAR(50),  -- Power Triceps
    "orth_sh_power_supinator_biceps" VARCHAR(50),  -- Power Supinator / Biceps
    "orth_sh_power_pronator_teres" VARCHAR(50),  -- Power Pronator Teres
    "orth_sh_power_ecrl" VARCHAR(50),  -- Power ECRL
    "orth_sh_power_ecu" VARCHAR(50),  -- Power ECU
    "orth_sh_power_epl" VARCHAR(50),  -- Power EPL
    "orth_sh_power_fcr" VARCHAR(50),  -- Power FCR
    "orth_sh_power_fpl" VARCHAR(50),  -- Power FPL
    "orth_sh_power_fdp_2" VARCHAR(50),  -- Power FDP 2
    "orth_sh_power_fdp_5" VARCHAR(50),  -- Power FDP 5
    "orth_sh_power_abductor_digiti_minimi" VARCHAR(50),  -- Power Abductor digiti minimi
    "orth_sh_acj_irritability" VARCHAR(50),  -- ACJ Irritability
    "orth_sh_acj_deformity" VARCHAR(50),  -- ACJ deformity
    "orth_sh_acj_instability" JSONB,  -- ACJ instability
    "orth_sh_gagey_hyperabduction_test" VARCHAR(50),  -- Gagey hyperabduction test
    "orth_sh_anterior_apprehension" VARCHAR(50),  -- Anterior apprehension
    "orth_sh_posterior_instability_test" VARCHAR(50),  -- Posterior instability testing
    "orth_sh_scj_irritability" VARCHAR(50),  -- SCJ irritability
    "orth_sh_scj_deformity" VARCHAR(50),  -- SCJ deformity
    "orth_sh_scj_instability" JSONB,  -- SCJ instability
    "orth_sh_nspcn_signs" JSONB,  -- NSPCN signs
    "orth_sh_primary_surgery" JSONB,  -- Primary surgery
    "orth_sh_secondary_surgery_definite" JSONB,  -- Secondary surgery definite
    "orth_sh_secondary_surgery_possible" JSONB,  -- Secondary surgery possible
    "orth_sh_surgery_other" TEXT,  -- Surgery other
    "orth_sh_physiotherapy_protocol" VARCHAR(50),  -- Physiotherapy protocol
    "orth_sh_injection_other" TEXT,  -- Injection - other
    "orth_sh_referral_details" JSONB,  -- Referral details
    "orth_sh_treatment_other" TEXT,  -- Treatment - other
    "orth_sh_surgery_title" TEXT,  -- Surgery title
    "orth_sh_surgery_area" JSONB,  -- Surgery area
    "orth_sh_hospital" VARCHAR(50),  -- Hospital
    "orth_sh_snomed_surgery_codes" VARCHAR(500),  -- SNOMED surgery codes
    "orth_sh_mbs_item_numbers" VARCHAR(500),  -- MBS item numbers
    "orth_sh_surgeon" VARCHAR(500),  -- Surgeon
    "orth_sh_assistant_surgeon" VARCHAR(500),  -- Assistant surgeon
    "orth_sh_anaesthetist" VARCHAR(500),  -- Anaesthetist
    "orth_sh_anaesthetic_type" JSONB,  -- Anaesthetic type
    "orth_sh_primary_or_revision" VARCHAR(50),  -- Primary or revision
    "orth_sh_primary_surgeon_if_revision" VARCHAR(500),  -- Primary surgeon if revision
    "orth_sh_intention" VARCHAR(50),  -- Intention
    "orth_sh_multistage_stage" VARCHAR(50),  -- Multistage stage
    "orth_sh_approach" JSONB,  -- Approach
    "orth_sh_open_approach_used" JSONB,  -- Open approach used
    "orth_sh_arthroscopic_endoscopic_portals_used" JSONB,  -- Arthroscopic / endoscopic portals used
    "orth_sh_approach_other_details" TEXT,  -- Approach other details
    "orth_sh_guidance" JSONB,  -- Guidance
    "orth_sh_guidance_other_details" TEXT,  -- Guidance other details
    "orth_sh_dvt_prophylaxis_intraoperative" JSONB,  -- DVT prophylaxis intraoperative
    "orth_sh_dvt_prophylaxis_detail" TEXT,  -- DVT prophylaxis detail
    "orth_sh_antibiotic_prophylaxis" JSONB,  -- Antibiotic prophylaxis
    "orth_sh_positioning" JSONB,  -- Positioning
    "orth_sh_scapulothoracic_tendon_transfer_type" JSONB,  -- Scapulothoracic tendon transfer type
    "orth_sh_scapulothoracic_tendon_transfer_fixation" JSONB,  -- Scapulothoracic tendon transfer fixation
    "orth_sh_scapulothoracic_treatment_of_infection" JSONB,  -- Scapulothoracic treatment of infection
    "orth_sh_scapulothoracic_treatment_other" TEXT,  -- Scapulothoracic treatment other
    "orth_sh_scapulothoracic_technique_details" TEXT,  -- Scapulothoracic technique details
    "orth_sh_scapulothoracic_implant_details" TEXT,  -- Scapulothoracic implant details
    "orth_sh_scapulothoracic_intraoperative_complications" TEXT,  -- Scapulothoracic intraoperative complications
    "orth_sh_sternum_treatment" JSONB,  -- Sternum treatment
    "orth_sh_sternum_fracture_reduction" VARCHAR(50),  -- Sternum fracture reduction
    "orth_sh_sternum_fixation_technique" JSONB,  -- Sternum fixation technique
    "orth_sh_sternum_recon_bone_graft_type" JSONB,  -- Sternum recon bone graft type
    "orth_sh_sternum_recon_bone_graft_fixation_type" JSONB,  -- Sternum recon bone graft fixation type
    "orth_sh_sternum_osteotomy_location" JSONB,  -- Sternum osteotomy location
    "orth_sh_sternum_osteotomy_type" VARCHAR(500),  -- Sternum osteotomy type
    "orth_sh_sternum_extent_of_removal_of_implants" VARCHAR(50),  -- Sternum extent of removal of implants
    "orth_sh_sternum_implants_removed" VARCHAR(500),  -- Sternum implants removed
    "orth_sh_sternum_implants_retained" VARCHAR(500),  -- Sternum implants retained
    "orth_sh_sternum_treatment_of_infection" JSONB,  -- Sternum treatment of infection
    "orth_sh_sternum_treatment_other" TEXT,  -- Sternum treatment other
    "orth_sh_sternum_technique_details" TEXT,  -- Sternum technique details
    "orth_sh_sternum_implant_details" TEXT,  -- Sternum implant details
    "orth_sh_sternum_intraoperative_complications" TEXT,  -- Sternum intraoperative complications
    "orth_sh_msj_arthrodesis_type" JSONB,  -- MSJ arthrodesis type
    "orth_sh_msj_arthrodesis_implant" JSONB,  -- MSJ arthrodesis implant
    "orth_sh_msj_arthrodesis_bone_graft" JSONB,  -- MSJ arthrodesis bone graft
    "orth_sh_msj_debridement_arthroplasty_type" JSONB,  -- MSJ debridement arthroplasty type
    "orth_sh_msj_interposition_material" VARCHAR(500),  -- MSJ interposition material
    "orth_sh_msj_stabilisation_type" JSONB,  -- MSJ stabilisation type
    "orth_sh_msj_capsule_ligament_repair_type" JSONB,  -- MSJ capsule ligament repair type
    "orth_sh_msj_capsule_ligament_to_bone_fixation_proximal" JSONB,  -- MSJ capsule ligament to bone fixation proximal
    "orth_sh_msj_capsule_ligament_to_bone_fixation_type_distal" JSONB,  -- MSJ capsule ligament to bone fixation type distal
    "orth_sh_msj_capsule_ligament_recon_implant_graft_type" JSONB,  -- MSJ capsule ligament recon implant graft type
    "orth_sh_msj_capsule_ligament_recon_fixation_type_proximal" JSONB,  -- MSJ capsule ligament recon fixation type proximal
    "orth_sh_msj_capsule_ligament_recon_fixation_type_distal" JSONB,  -- MSJ capsule ligament recon fixation type distal
    "orth_sh_msj_avulsion_fracture_bone_fixation" JSONB,  -- MSJ avulsion fracture bone fixation
    "orth_sh_msj_spanning_bone_fixation" JSONB,  -- MSJ spanning bone fixation
    "orth_sh_msj_bone_recon_bone_graft_type" JSONB,  -- MSJ bone recon bone graft type
    "orth_sh_msj_bone_recon_bone_graft_fixation_type" JSONB,  -- MSJ bone recon bone graft fixation type
    "orth_sh_msj_bone_recon_bone_graft_location" JSONB,  -- MSJ bone recon bone graft location
    "orth_sh_msj_arthrolysis_techniques" JSONB,  -- MSJ arthrolysis techniques
    "orth_sh_msj_articular_cartilage_techniques" JSONB,  -- MSJ articular cartilage techniques
    "orth_sh_msj_biopsy_tissue" JSONB,  -- MSJ biopsy tissue
    "orth_sh_msj_periarticular_cyst_treatment" JSONB,  -- MSJ periarticular cyst treatment
    "orth_sh_msj_reduction_type" JSONB,  -- MSJ reduction type
    "orth_sh_msj_extent_of_implant_removal" VARCHAR(50),  -- MSJ extent of implant removal
    "orth_sh_msj_implants_removed" VARCHAR(500),  -- MSJ implants removed
    "orth_sh_msj_implants_retained" VARCHAR(500),  -- MSJ implants retained
    "orth_sh_msj_treatment_other" TEXT,  -- MSJ treatment other
    "orth_sh_msj_technique_details" TEXT,  -- MSJ technique details
    "orth_sh_msj_implant_details" TEXT,  -- MSJ implant details
    "orth_sh_msj_intraoperative_complications" TEXT,  -- MSJ intraoperative complications
    "orth_sh_scj_arthrodesis_type" JSONB,  -- SCJ arthrodesis type
    "orth_sh_scj_arthrodesis_implant" JSONB,  -- SCJ arthrodesis implant
    "orth_sh_scj_arthrodesis_bone_graft" JSONB,  -- SCJ arthrodesis bone graft
    "orth_sh_scj_debridement_arthroplasty_type" JSONB,  -- SCJ debridement arthroplasty type
    "orth_sh_scj_interposition_material" TEXT,  -- SCJ interposition material
    "orth_sh_scj_arthroplasty_replacement_primary" TEXT,  -- SCJ arthroplasty replacement primary
    "orth_sh_scj_arthroplasty_replacement_revision" TEXT,  -- SCJ arthroplasty replacement revision
    "orth_sh_scj_stabilisation_type" JSONB,  -- SCJ stabilisation type
    "orth_sh_scj_capsule_ligament_repair_type" JSONB,  -- SCJ capsule ligament repair type
    "orth_sh_scj_capsule_ligament_to_bone_repair_proximal" JSONB,  -- SCJ capsule ligament to bone repair proximal
    "orth_sh_scj_capsule_ligament_to_bone_repair_distal" JSONB,  -- SCJ capsule ligament to bone repair distal
    "orth_sh_scj_anterior_capsule_ligament_recon_graft_type" JSONB,  -- SCJ anterior capsule ligament recon graft type
    "orth_sh_scj_ant_capsule_ligament_recon_fixation_prox" JSONB,  -- SCJ ant capsule ligament recon fixation prox
    "orth_sh_scj_ant_capsule_ligament_recon_fixation_dist" JSONB,  -- SCJ ant capsule ligament recon fixation dist
    "orth_sh_scj_posterior_capsule_ligament_recon_graft_type" JSONB,  -- SCJ posterior capsule ligament recon graft type
    "orth_sh_scj_post_capsule_ligament_recon_fixation_prox" JSONB,  -- SCJ post capsule ligament recon fixation prox
    "orth_sh_scj_post_capsule_ligament_recon_fixation_dist" JSONB,  -- SCJ post capsule ligament recon fixation dist
    "orth_sh_scj_cc_ligament_recon_graft_type" JSONB,  -- SCJ CC ligament recon graft type
    "orth_sh_scj_cc_ligament_recon_fixation_proximal" JSONB,  -- SCJ CC ligament recon fixation proximal
    "orth_sh_scj_cc_ligament_recon_fixation_distal" JSONB,  -- SCJ CC ligament recon fixation distal
    "orth_sh_scj_avulsion_fracture_fixation" JSONB,  -- SCJ avulsion fracture fixation
    "orth_sh_scj_joint_spanning_fixation" JSONB,  -- SCJ joint spanning fixation
    "orth_sh_scj_bone_recon_bone_graft" JSONB,  -- SCJ bone recon bone graft
    "orth_sh_scj_bone_recon_bone_graft_fixation" JSONB,  -- SCJ bone recon bone graft fixation
    "orth_sh_scj_bone_recon_bone_graft_location" JSONB,  -- SCJ bone recon bone graft location
    "orth_sh_scj_arthrolysis_techniques" JSONB,  -- SCJ arthrolysis techniques
    "orth_sh_scj_articular_cartilage_techniques" JSONB,  -- SCJ articular cartilage techniques
    "orth_sh_scj_biopsy_tissue" JSONB,  -- SCJ biopsy tissue
    "orth_sh_scj_periarticular_cyst_treatment" JSONB,  -- SCJ periarticular cyst treatment
    "orth_sh_scj_reduction_type" JSONB,  -- SCJ reduction type
    "orth_sh_scj_extent_of_implant_removal" VARCHAR(50),  -- SCJ extent of implant removal
    "orth_sh_scj_implants_removed" VARCHAR(500),  -- SCJ implants removed
    "orth_sh_scj_implants_retained" VARCHAR(500),  -- SCJ implants retained
    "orth_sh_scj_treatment_of_infection" JSONB,  -- SCJ treatment of infection
    "orth_sh_scj_treatment_other" TEXT,  -- SCJ treatment other
    "orth_sh_scj_technique_details" TEXT,  -- SCJ technique details
    "orth_sh_scj_implant_details" TEXT,  -- SCJ implant details
    "orth_sh_scj_intraoperative_complications" TEXT,  -- SCJ intraoperative complications
    "orth_sh_scapula_body_treatment" JSONB,  -- Scapula body treatment
    "orth_sh_scapula_body_fracture_reduction" JSONB,  -- Scapula body fracture reduction
    "orth_sh_scapula_body_fixation_technique" JSONB,  -- Scapula body fixation technique
    "orth_sh_scapula_body_recon_bone_graft_type" JSONB,  -- Scapula body recon bone graft type
    "orth_sh_scapula_body_recon_bone_graft_fixation_type" JSONB,  -- Scapula body recon bone graft fixation type
    "orth_sh_scapula_body_osteotomy_location" TEXT,  -- Scapula body osteotomy location
    "orth_sh_scapula_body_osteotomy_type" TEXT,  -- Scapula body osteotomy type
    "orth_sh_scapula_body_extent_of_removal_of_implants" VARCHAR(50),  -- Scapula body extent of removal of implants
    "orth_sh_scapula_body_implants_removed" TEXT,  -- Scapula body implants removed
    "orth_sh_scapula_body_implants_retained" TEXT,  -- Scapula body implants retained
    "orth_sh_scapula_body_treatment_of_infection" JSONB,  -- Scapula body treatment of infection
    "orth_sh_scapula_body_treatment_other" TEXT,  -- Scapula body treatment other
    "orth_sh_scapula_body_technique_details" TEXT,  -- Scapula body technique details
    "orth_sh_scapula_body_implant_details" TEXT,  -- Scapula body implant details
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_general_part_2_part_2
CREATE INDEX IF NOT EXISTS idx_shoulder_general_part_2_part_2_encounter ON shoulder_general_part_2_part_2(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_general_part_2_part_2_created ON shoulder_general_part_2_part_2(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_general_part_2_part_2
    ADD CONSTRAINT fk_shoulder_general_part_2_part_2_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: demographics_part_3_part_3
-- Generated: 2025-11-28T20:28:38.877264
-- Fields: 250

CREATE TABLE IF NOT EXISTS demographics_part_3_part_3 (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_coronoid_implants_removed" VARCHAR(500),  -- Coronoid implants removed
    "dem_coronoid_implants_retained" VARCHAR(500),  -- Coronoid implants retained
    "dem_radial_head_neck_fracture_reduction" VARCHAR(50),  -- Radial Head / Neck fracture reduction
    "dem_radial_head_neck_fixation_not_joint_spanning" JSONB,  -- Radial Head / Neck fixation - not joint spanning
    "dem_radial_head_arthroplasty" VARCHAR(50),  -- Radial head arthroplasty
    "dem_radial_head_arthroplasty_spacer_type" VARCHAR(50),  -- Radial head arthroplasty - spacer type
    "dem_radial_head_arthroplasty_spacer_location" VARCHAR(50),  -- Radial head arthroplasty - spacer location
    "dem_radial_head_arthroplasty_proximal_radius_component_design" VARCHAR(50),  -- Radial head arthroplasty - proximal radius component design
    "dem_radial_head_arthroplasty_proximal_radius_bearing_surface" VARCHAR(50),  -- Radial head arthroplasty - proximal radius bearing surface
    "dem_radial_head_arthroplasty_proximal_radius_component_fixation" JSONB,  -- Radial head arthroplasty - proximal radius component fixatio
    "dem_radial_head_arthroplasty_proximal_radius_component_fixation" JSONB,  -- Radial head arthroplasty - proximal radius component fixatio
    "dem_radial_head_neck_bone_graft_bone_reconstruction_fixation_ty" JSONB,  -- Radial Head / Neck bone graft / bone reconstruction fixation
    "dem_radial_head_neck_bone_graft_reconstruction_type" JSONB,  -- Radial Head / Neck bone graft / reconstruction type
    "dem_radial_head_neck_osteotomy_location" JSONB,  -- Radial Head / Neck osteotomy location
    "dem_radial_head_neck_osteotomy_type" VARCHAR(500),  -- Radial Head / Neck osteotomy type
    "dem_radial_head_neck_removal_of_implants" VARCHAR(50),  -- Radial Head / Neck removal of implants
    "dem_radial_head_neck_implants_removed" VARCHAR(500),  -- Radial Head / Neck implants removed
    "dem_radial_head_neck_implants_retained" VARCHAR(500),  -- Radial Head / Neck implants retained
    "dem_radial_diaphysis_fracture_reduction" VARCHAR(50),  -- Radial Diaphysis fracture reduction
    "dem_radial_diaphysis_fixation_not_joint_spanning" JSONB,  -- Radial Diaphysis fixation - not joint spanning
    "dem_radial_diaphysis_bone_graft_reconstruction_type" JSONB,  -- Radial Diaphysis bone graft / reconstruction type
    "dem_radial_diaphysis_bone_graft_bone_reconstruction_fixation_ty" JSONB,  -- Radial Diaphysis bone graft / bone reconstruction fixation t
    "dem_radial_diaphysis_osteotomy_location" JSONB,  -- Radial Diaphysis osteotomy location
    "dem_radial_diaphysis_osteotomy_type" VARCHAR(500),  -- Radial Diaphysis osteotomy type
    "dem_radial_diaphysis_removal_of_implants" VARCHAR(50),  -- Radial Diaphysis removal of implants
    "dem_radial_diaphysis_implants_removed" VARCHAR(500),  -- Radial Diaphysis implants removed
    "dem_radial_diaphysis_implants_retained" VARCHAR(500),  -- Radial Diaphysis implants retained
    "dem_ulna_diaphysis_fracture_reduction" VARCHAR(50),  -- Ulna Diaphysis fracture reduction
    "dem_ulna_diaphysis_fixation_not_joint_spanning" JSONB,  -- Ulna Diaphysis fixation - not joint spanning
    "dem_ulna_diaphysis_bone_graft_reconstruction_type" JSONB,  -- Ulna Diaphysis bone graft / reconstruction type
    "dem_ulna_diaphysis_bone_graft_bone_reconstruction_fixation_type" JSONB,  -- Ulna Diaphysis bone graft / bone reconstruction fixation typ
    "dem_ulna_diaphysis_osteotomy_location" JSONB,  -- Ulna Diaphysis osteotomy location
    "dem_ulna_diaphysis_osteotomy_type" VARCHAR(500),  -- Ulna Diaphysis osteotomy type
    "dem_ulna_diaphysis_removal_of_implants" VARCHAR(50),  -- Ulna Diaphysis removal of implants
    "dem_ulna_diaphysis_implants_retained" VARCHAR(500),  -- Ulna Diaphysis implants retained
    "dem_ulna_diaphysis_implants_removed" VARCHAR(500),  -- Ulna Diaphysis implants removed
    "dem_date_3mo" DATE,  -- Today's Date
    "dem_lastname_3mo" VARCHAR(500),  -- Surname
    "dem_givenname_3mo" VARCHAR(500),  -- First Name
    "dem_dateofbirth_3mo" DATE,  -- Date of Birth
    "dem_email_pt_3mo" VARCHAR(255),  -- Email
    "dem_mobile_pt_3mo" VARCHAR(500),  -- Mobile Number
    "dem_mainsport_3mo" VARCHAR(500),  -- Main Sport
    "dem_mainsportgrade_3mo" VARCHAR(50),  -- Main Sport Grade
    "dem_pain_vas_3mo" INTEGER,  -- How much pain in your shoulder do you have during your usual
    "dem_pain_rowe_3mo" DECIMAL,  -- Pain (Rowe)
    "dem_csmasss_sleep_q_3mo" VARCHAR(50),  -- Is your night's sleep disturbed by your shoulder?
    "dem_p_ases_sleep_3mo" VARCHAR(50),  -- Can you sleep on your affected shoulder comfortably
    "dem_p_ases_bra_3mo" VARCHAR(50),  -- Can you wash your back / fasten your bra?
    "dem_p_ases_coat_3mo" VARCHAR(50),  -- Can you put on your coat unassisted?
    "dem_p_ases_comb_3mo" VARCHAR(50),  -- Can you comb / wash your hair?
    "dem_p_ases_toilet_3mo" VARCHAR(50),  -- Can you use toilet tissue?
    "dem_p_ases_shelf_3mo" VARCHAR(50),  -- Can you reach a shelf over your head?
    "dem_p_ases_4kg_3mo" VARCHAR(50),  -- Can you lift 4 kilograms above the level of your shoulder?
    "dem_p_ases_throw_3mo" VARCHAR(50),  -- Can you throw a ball overhand?
    "dem_full_work_3mo" VARCHAR(50),  -- Does your shoulder allow you to work full time at your usual
    "dem_rtw_3mo" VARCHAR(50),  -- What work are you currently able to do (if not working-your 
    "dem_full_work_csmasss_3mo" DECIMAL,  -- Full Work CS/MASSS
    "dem_usual_sports_3mo" VARCHAR(50),  -- Does your shoulder allow you to do your usual sports?
    "dem_usual_sports_csmasss_3mo" DECIMAL,  -- Usual Sports CS/MASSS
    "dem_rts_3mo" VARCHAR(50),  -- Are you able to do your usual sports/activities?
    "dem_csmasss_comfortable_use_3mo" VARCHAR(50),  -- What level can you use your arm for painless activities?
    "dem_rowe_subjective_instability_3mo" VARCHAR(50),  -- Have you had a shoulder dislocation or do you feel apprehens
    "dem_abd_pic_3mo" TEXT,  -- Abduction
    "dem_p_abd_3mo" DECIMAL,  -- Give the range of motion of ABDUCTION (raising your arm to t
    "dem_abd_rowe_3mo" DECIMAL,  -- Abduction (Rowe)
    "dem_er_pic_3mo" TEXT,  -- (A) External rotation in Abduction and (B) External rotation
    "dem_p_aber_3mo" DECIMAL,  -- Give the range of motion of EXTERNAL ROTATION IN ABDUCTION (
    "dem_p_ader_3mo" DECIMAL,  -- Give the range of motion of EXTERNAL ROTATION IN ADDUCTION (
    "dem_ader_rowe_3mo" DECIMAL,  -- ADER (Rowe)
    "dem_ir_pic_3mo" TEXT,  -- Internal Rotation
    "dem_p_ir_3mo" DECIMAL,  -- Give the range of motion of INTERNAL ROTATION (reaching up y
    "dem_ir_rowe_3mo" DECIMAL,  -- IR (Rowe)
    "dem_rom_vas_3mo" DECIMAL,  -- Give the overall range of motion of your affected/operated s
    "dem_csmasss_strength_3mo" DECIMAL,  -- Give the overall strength of your affected/operated shoulder
    "dem_sane_stability_3mo" DECIMAL,  -- Give the overall stability of your affected/operated shoulde
    "dem_ssv_3mo" DECIMAL,  -- Give your affected/operated shoulder an overall mark out of 
    "dem_ssv_rowe_3mo" DECIMAL,  -- SSV (Rowe)
    "dem_total_ases_3mo" DECIMAL,  -- Total ASES
    "dem_total_csmasss_3mo" DECIMAL,  -- Total CS MASSS
    "dem_total_rowe_3mo" DECIMAL,  -- Total Rowe
    "dem_shoulder_extension_3mo" VARCHAR(500),  -- Shoulder Extension
    "dem_shoulder_abduction_3mo" VARCHAR(500),  -- Shoulder Abduction
    "dem_shoulder_er1_3mo" VARCHAR(500),  -- Shoulder External Rotation with elbow at the side (ER1)
    "dem_shoulder_er2_3mo" VARCHAR(500),  -- Shoulder External Rotation with arm abducted at 90° (ER1)
    "dem_shoulder_ir_3mo" VARCHAR(500),  -- Shoulder Internal Rotation
    "dem_date_6mo" DATE,  -- Today's Date
    "dem_lastname_6mo" VARCHAR(500),  -- Surname
    "dem_givenname_6mo" VARCHAR(500),  -- First Name
    "dem_dateofbirth_6mo" DATE,  -- Date of Birth
    "dem_email_pt_6mo" VARCHAR(255),  -- Email
    "dem_mobile_pt_6mo" VARCHAR(500),  -- Mobile Number
    "dem_mainsport_6mo" VARCHAR(500),  -- Main Sport
    "dem_mainsportgrade_6mo" VARCHAR(50),  -- Main Sport Grade
    "dem_pain_vas_6mo" INTEGER,  -- How much pain in your shoulder do you have during your usual
    "dem_pain_rowe_6mo" DECIMAL,  -- Pain (Rowe)
    "dem_csmasss_sleep_q_6mo" VARCHAR(50),  -- Is your night's sleep disturbed by your shoulder?
    "dem_p_ases_sleep_6mo" VARCHAR(50),  -- Can you sleep on your affected shoulder comfortably
    "dem_p_ases_bra_6mo" VARCHAR(50),  -- Can you wash your back / fasten your bra?
    "dem_p_ases_coat_6mo" VARCHAR(50),  -- Can you put on your coat unassisted?
    "dem_p_ases_comb_6mo" VARCHAR(50),  -- Can you comb / wash your hair?
    "dem_p_ases_toilet_6mo" VARCHAR(50),  -- Can you use toilet tissue?
    "dem_p_ases_shelf_6mo" VARCHAR(50),  -- Can you reach a shelf over your head?
    "dem_p_ases_4kg_6mo" VARCHAR(50),  -- Can you lift 4 kilograms above the level of your shoulder?
    "dem_p_ases_throw_6mo" VARCHAR(50),  -- Can you throw a ball overhand?
    "dem_full_work_6mo" VARCHAR(50),  -- Does your shoulder allow you to work full time at your usual
    "dem_rtw_6mo" VARCHAR(50),  -- What work are you currently able to do (if not working-your 
    "dem_full_work_csmasss_6mo" DECIMAL,  -- Full Work CS/MASSS
    "dem_usual_sports_6mo" VARCHAR(50),  -- Does your shoulder allow you to do your usual sports?
    "dem_usual_sports_csmasss_6mo" DECIMAL,  -- Usual Sports CS/MASSS
    "dem_rts_6mo" VARCHAR(50),  -- Are you able to do your usual sports/activities?
    "dem_csmasss_comfortable_use_6mo" VARCHAR(50),  -- What level can you use your arm for painless activities?
    "dem_rowe_subjective_instability_6mo" VARCHAR(50),  -- Have you had a shoulder dislocation or do you feel apprehens
    "dem_abd_pic_6mo" TEXT,  -- Abduction
    "dem_p_abd_6mo" DECIMAL,  -- Give the range of motion of ABDUCTION (raising your arm to t
    "dem_abd_rowe_6mo" DECIMAL,  -- Abduction (Rowe)
    "dem_er_pic_6mo" TEXT,  -- (A) External rotation in Abduction and (B) External rotation
    "dem_p_aber_6mo" DECIMAL,  -- Give the range of motion of EXTERNAL ROTATION IN ABDUCTION (
    "dem_p_ader_6mo" DECIMAL,  -- Give the range of motion of EXTERNAL ROTATION IN ADDUCTION (
    "dem_ader_rowe_6mo" DECIMAL,  -- ADER (Rowe)
    "dem_ir_pic_6mo" TEXT,  -- Internal Rotation
    "dem_p_ir_6mo" DECIMAL,  -- Give the range of motion of INTERNAL ROTATION (reaching up y
    "dem_ir_rowe_6mo" DECIMAL,  -- IR (Rowe)
    "dem_rom_vas_6mo" DECIMAL,  -- Give the overall range of motion of your affected/operated s
    "dem_csmasss_strength_6mo" DECIMAL,  -- Give the overall strength of your affected/operated shoulder
    "dem_sane_stability_6mo" DECIMAL,  -- Give the overall stability of your affected/operated shoulde
    "dem_ssv_6mo" DECIMAL,  -- Give your affected/operated shoulder an overall mark out of 
    "dem_ssv_rowe_6mo" DECIMAL,  -- SSV (Rowe)
    "dem_total_ases_6mo" DECIMAL,  -- Total ASES
    "dem_total_csmasss_6mo" DECIMAL,  -- Total CS MASSS
    "dem_total_rowe_6mo" DECIMAL,  -- Total Rowe
    "dem_shoulder_extension_6mo" VARCHAR(500),  -- Shoulder Extension
    "dem_shoulder_abduction_6mo" VARCHAR(500),  -- Shoulder Abduction
    "dem_shoulder_er1_6mo" VARCHAR(500),  -- Shoulder External Rotation with elbow at the side (ER1)
    "dem_shoulder_er2_6mo" VARCHAR(500),  -- Shoulder External Rotation with arm abducted at 90° (ER1)
    "dem_shoulder_ir_6mo" VARCHAR(500),  -- Shoulder Internal Rotation
    "dem_date_12mo" DATE,  -- Today's Date
    "dem_lastname_12mo" VARCHAR(500),  -- Surname
    "dem_givenname_12mo" VARCHAR(500),  -- First Name
    "dem_dateofbirth_12mo" DATE,  -- Date of Birth
    "dem_email_pt_12mo" VARCHAR(255),  -- Email
    "dem_mobile_pt_12mo" VARCHAR(500),  -- Mobile Number
    "dem_mainsport_12mo" VARCHAR(500),  -- Main Sport
    "dem_mainsportgrade_12mo" VARCHAR(50),  -- Main Sport Grade
    "dem_pain_vas_12mo" INTEGER,  -- How much pain in your shoulder do you have during your usual
    "dem_pain_rowe_12mo" DECIMAL,  -- Pain (Rowe)
    "dem_csmasss_sleep_q_12mo" VARCHAR(50),  -- Is your night's sleep disturbed by your shoulder?
    "dem_p_ases_sleep_12mo" VARCHAR(50),  -- Can you sleep on your affected shoulder comfortably
    "dem_p_ases_bra_12mo" VARCHAR(50),  -- Can you wash your back / fasten your bra?
    "dem_p_ases_coat_12mo" VARCHAR(50),  -- Can you put on your coat unassisted?
    "dem_p_ases_comb_12mo" VARCHAR(50),  -- Can you comb / wash your hair?
    "dem_p_ases_toilet_12mo" VARCHAR(50),  -- Can you use toilet tissue?
    "dem_p_ases_shelf_12mo" VARCHAR(50),  -- Can you reach a shelf over your head?
    "dem_p_ases_4kg_12mo" VARCHAR(50),  -- Can you lift 4 kilograms above the level of your shoulder?
    "dem_p_ases_throw_12mo" VARCHAR(50),  -- Can you throw a ball overhand?
    "dem_full_work_12mo" VARCHAR(50),  -- Does your shoulder allow you to work full time at your usual
    "dem_rtw_12mo" VARCHAR(50),  -- What work are you currently able to do (if not working-your 
    "dem_full_work_csmasss_12mo" DECIMAL,  -- Full Work CS/MASSS
    "dem_usual_sports_12mo" VARCHAR(50),  -- Does your shoulder allow you to do your usual sports?
    "dem_usual_sports_csmasss_12mo" DECIMAL,  -- Usual Sports CS/MASSS
    "dem_rts_12mo" VARCHAR(50),  -- Are you able to do your usual sports/activities?
    "dem_csmasss_comfortable_use_12mo" VARCHAR(50),  -- What level can you use your arm for painless activities?
    "dem_rowe_subjective_instability_12mo" VARCHAR(50),  -- Have you had a shoulder dislocation or do you feel apprehens
    "dem_abd_pic_12mo" TEXT,  -- Abduction
    "dem_p_abd_12mo" DECIMAL,  -- Give the range of motion of ABDUCTION (raising your arm to t
    "dem_abd_rowe_12mo" DECIMAL,  -- Abduction (Rowe)
    "dem_er_pic_12mo" TEXT,  -- (A) External rotation in Abduction and (B) External rotation
    "dem_p_aber_12mo" DECIMAL,  -- Give the range of motion of EXTERNAL ROTATION IN ABDUCTION (
    "dem_p_ader_12mo" DECIMAL,  -- Give the range of motion of EXTERNAL ROTATION IN ADDUCTION (
    "dem_ader_rowe_12mo" DECIMAL,  -- ADER (Rowe)
    "dem_ir_pic_12mo" TEXT,  -- Internal Rotation
    "dem_p_ir_12mo" DECIMAL,  -- Give the range of motion of INTERNAL ROTATION (reaching up y
    "dem_ir_rowe_12mo" DECIMAL,  -- IR (Rowe)
    "dem_rom_vas_12mo" DECIMAL,  -- Give the overall range of motion of your affected/operated s
    "dem_csmasss_strength_12mo" DECIMAL,  -- Give the overall strength of your affected/operated shoulder
    "dem_sane_stability_12mo" DECIMAL,  -- Give the overall stability of your affected/operated shoulde
    "dem_ssv_12mo" DECIMAL,  -- Give your affected/operated shoulder an overall mark out of 
    "dem_ssv_rowe_12mo" DECIMAL,  -- SSV (Rowe)
    "dem_total_ases_12mo" DECIMAL,  -- Total ASES
    "dem_total_csmasss_12mo" DECIMAL,  -- Total CS MASSS
    "dem_total_rowe_12mo" DECIMAL,  -- Total Rowe
    "dem_shoulder_extension_12mo" VARCHAR(500),  -- Shoulder Extension
    "dem_shoulder_abduction_12mo" VARCHAR(500),  -- Shoulder Abduction
    "dem_shoulder_er1_12mo" VARCHAR(500),  -- Shoulder External Rotation with elbow at the side (ER1)
    "dem_shoulder_er2_12mo" VARCHAR(500),  -- Shoulder External Rotation with arm abducted at 90° (ER1)
    "dem_shoulder_ir_12mo" VARCHAR(500),  -- Shoulder Internal Rotation
    "dem_date_24mo" DATE,  -- Today's Date
    "dem_lastname_24mo" VARCHAR(500),  -- Surname
    "dem_givenname_24mo" VARCHAR(500),  -- First Name
    "dem_dateofbirth_24mo" DATE,  -- Date of Birth
    "dem_email_pt_24mo" VARCHAR(255),  -- Email
    "dem_mobile_pt_24mo" VARCHAR(500),  -- Mobile Number
    "dem_mainsport_24mo" VARCHAR(500),  -- Main Sport
    "dem_mainsportgrade_24mo" VARCHAR(50),  -- Main Sport Grade
    "dem_pain_vas_24mo" INTEGER,  -- How much pain in your shoulder do you have during your usual
    "dem_pain_rowe_24mo" DECIMAL,  -- Pain (Rowe)
    "dem_csmasss_sleep_q_24mo" VARCHAR(50),  -- Is your night's sleep disturbed by your shoulder?
    "dem_p_ases_sleep_24mo" VARCHAR(50),  -- Can you sleep on your affected shoulder comfortably
    "dem_p_ases_bra_24mo" VARCHAR(50),  -- Can you wash your back / fasten your bra?
    "dem_p_ases_coat_24mo" VARCHAR(50),  -- Can you put on your coat unassisted?
    "dem_p_ases_comb_24mo" VARCHAR(50),  -- Can you comb / wash your hair?
    "dem_p_ases_toilet_24mo" VARCHAR(50),  -- Can you use toilet tissue?
    "dem_p_ases_shelf_24mo" VARCHAR(50),  -- Can you reach a shelf over your head?
    "dem_p_ases_4kg_24mo" VARCHAR(50),  -- Can you lift 4 kilograms above the level of your shoulder?
    "dem_p_ases_throw_24mo" VARCHAR(50),  -- Can you throw a ball overhand?
    "dem_full_work_24mo" VARCHAR(50),  -- Does your shoulder allow you to work full time at your usual
    "dem_rtw_24mo" VARCHAR(50),  -- What work are you currently able to do (if not working-your 
    "dem_full_work_csmasss_24mo" DECIMAL,  -- Full Work CS/MASSS
    "dem_usual_sports_24mo" VARCHAR(50),  -- Does your shoulder allow you to do your usual sports?
    "dem_usual_sports_csmasss_24mo" DECIMAL,  -- Usual Sports CS/MASSS
    "dem_rts_24mo" VARCHAR(50),  -- Are you able to do your usual sports/activities?
    "dem_csmasss_comfortable_use_24mo" VARCHAR(50),  -- What level can you use your arm for painless activities?
    "dem_rowe_subjective_instability_24mo" VARCHAR(50),  -- Have you had a shoulder dislocation or do you feel apprehens
    "dem_abd_pic_24mo" TEXT,  -- Abduction
    "dem_p_abd_24mo" DECIMAL,  -- Give the range of motion of ABDUCTION (raising your arm to t
    "dem_abd_rowe_24mo" DECIMAL,  -- Abduction (Rowe)
    "dem_er_pic_24mo" TEXT,  -- (A) External rotation in Abduction and (B) External rotation
    "dem_p_aber_24mo" DECIMAL,  -- Give the range of motion of EXTERNAL ROTATION IN ABDUCTION (
    "dem_p_ader_24mo" DECIMAL,  -- Give the range of motion of EXTERNAL ROTATION IN ADDUCTION (
    "dem_ader_rowe_24mo" DECIMAL,  -- ADER (Rowe)
    "dem_ir_pic_24mo" TEXT,  -- Internal Rotation
    "dem_p_ir_24mo" DECIMAL,  -- Give the range of motion of INTERNAL ROTATION (reaching up y
    "dem_ir_rowe_24mo" DECIMAL,  -- IR (Rowe)
    "dem_rom_vas_24mo" DECIMAL,  -- Give the overall range of motion of your affected/operated s
    "dem_csmasss_strength_24mo" DECIMAL,  -- Give the overall strength of your affected/operated shoulder
    "dem_sane_stability_24mo" DECIMAL,  -- Give the overall stability of your affected/operated shoulde
    "dem_ssv_24mo" DECIMAL,  -- Give your affected/operated shoulder an overall mark out of 
    "dem_ssv_rowe_24mo" DECIMAL,  -- SSV (Rowe)
    "dem_total_ases_24mo" DECIMAL,  -- Total ASES
    "dem_total_csmasss_24mo" DECIMAL,  -- Total CS MASSS
    "dem_total_rowe_24mo" DECIMAL,  -- Total Rowe
    "dem_shoulder_extension_24mo" VARCHAR(500),  -- Shoulder Extension
    "dem_shoulder_abduction_24mo" VARCHAR(500),  -- Shoulder Abduction
    "dem_shoulder_er1_24mo" VARCHAR(500),  -- Shoulder External Rotation with elbow at the side (ER1)
    "dem_shoulder_er2_24mo" VARCHAR(500),  -- Shoulder External Rotation with arm abducted at 90° (ER1)
    "dem_shoulder_ir_24mo" VARCHAR(500),  -- Shoulder Internal Rotation
    "dem_date_36mo" DATE,  -- Today's Date
    "dem_lastname_36mo" VARCHAR(500),  -- Surname
    "dem_givenname_36mo" VARCHAR(500),  -- First Name
    "dem_dateofbirth_36mo" DATE,  -- Date of Birth
    "dem_email_pt_36mo" VARCHAR(255),  -- Email
    "dem_mobile_pt_36mo" VARCHAR(500),  -- Mobile Number
    "dem_mainsport_36mo" VARCHAR(500),  -- Main Sport
    "dem_mainsportgrade_36mo" VARCHAR(50),  -- Main Sport Grade
    "dem_pain_vas_36mo" INTEGER,  -- How much pain in your shoulder do you have during your usual
    "dem_pain_rowe_36mo" DECIMAL,  -- Pain (Rowe)
    "dem_csmasss_sleep_q_36mo" VARCHAR(50),  -- Is your night's sleep disturbed by your shoulder?
    "dem_p_ases_sleep_36mo" VARCHAR(50),  -- Can you sleep on your affected shoulder comfortably
    "dem_p_ases_bra_36mo" VARCHAR(50),  -- Can you wash your back / fasten your bra?
    "dem_p_ases_coat_36mo" VARCHAR(50),  -- Can you put on your coat unassisted?
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for demographics_part_3_part_3
CREATE INDEX IF NOT EXISTS idx_demographics_part_3_part_3_encounter ON demographics_part_3_part_3(encounter_id);
CREATE INDEX IF NOT EXISTS idx_demographics_part_3_part_3_created ON demographics_part_3_part_3(created_at);

-- Foreign key constraint
ALTER TABLE demographics_part_3_part_3
    ADD CONSTRAINT fk_demographics_part_3_part_3_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_below_needs_branching_logic_to_be_edited
-- Generated: 2025-11-28T20:28:38.910317
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_below_needs_branching_logic_to_be_edited (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_encounter_background_info" VARCHAR(50),  -- Encounter background info diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_below_needs_branching_logic_to_be_edited
CREATE INDEX IF NOT EXISTS idx_elbow_below_needs_branching_logic_to_be_edited_encounter ON elbow_below_needs_branching_logic_to_be_edited(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_below_needs_branching_logic_to_be_edited_created ON elbow_below_needs_branching_logic_to_be_edited(created_at);

-- Foreign key constraint
ALTER TABLE elbow_below_needs_branching_logic_to_be_edited
    ADD CONSTRAINT fk_elbow_below_needs_branching_logic_to_be_edited_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_general_part_3_part_3
-- Generated: 2025-11-28T20:28:38.893429
-- Fields: 250

CREATE TABLE IF NOT EXISTS shoulder_general_part_3_part_3 (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_scapula_body_intraoperative_complications" TEXT,  -- Scapula body intraoperative complications
    "orth_sh_scapula_neck_treatment" JSONB,  -- Scapula neck treatment
    "orth_sh_scapula_neck_fracture_reduction" JSONB,  -- Scapula neck fracture reduction
    "orth_sh_scapula_neck_fixation_technique" JSONB,  -- Scapula neck fixation technique
    "orth_sh_scapula_neck_recon_bone_graft_type" JSONB,  -- Scapula neck recon bone graft type
    "orth_sh_scapula_neck_recon_bone_graft_fixation_type" JSONB,  -- Scapula neck recon bone graft fixation type
    "orth_sh_scapula_neck_osteotomy_location" TEXT,  -- Scapula neck osteotomy location
    "orth_sh_scapula_neck_osteotomy_type" TEXT,  -- Scapula neck osteotomy type
    "orth_sh_scapula_neck_extent_of_removal_of_implants" VARCHAR(50),  -- Scapula neck extent of removal of implants
    "orth_sh_scapula_neck_implants_removed" TEXT,  -- Scapula neck implants removed
    "orth_sh_scapula_neck_implants_retained" TEXT,  -- Scapula neck implants retained
    "orth_sh_scapula_neck_treatment_of_infection" JSONB,  -- Scapula neck treatment of infection
    "orth_sh_scapula_neck_treatment_other" TEXT,  -- Scapula neck treatment other
    "orth_sh_scapula_neck_technique_details" TEXT,  -- Scapula neck technique details
    "orth_sh_scapula_neck_implant_details" TEXT,  -- Scapula neck implant details
    "orth_sh_scapula_neck_intraoperative_complications" TEXT,  -- Scapula neck intraoperative complications
    "orth_sh_glenoid_treatment" JSONB,  -- Glenoid treatment
    "orth_sh_glenoid_fracture_reduction" JSONB,  -- Glenoid fracture reduction
    "orth_sh_glenoid_fixation_technique" JSONB,  -- Glenoid fixation technique
    "orth_sh_glenoid_recon_bone_graft_type" JSONB,  -- Glenoid recon bone graft type
    "orth_sh_glenoid_recon_bone_graft_fixation_type" JSONB,  -- Glenoid recon bone graft fixation type
    "orth_sh_glenoid_osteotomy_location" TEXT,  -- Glenoid osteotomy location
    "orth_sh_glenoid_osteotomy_type" TEXT,  -- Glenoid osteotomy type
    "orth_sh_glenoid_extent_of_removal_of_implants" VARCHAR(50),  -- Glenoid extent of removal of implants
    "orth_sh_glenoid_implants_removed" TEXT,  -- Glenoid implants removed
    "orth_sh_glenoid_implants_retained" TEXT,  -- Glenoid implants retained
    "orth_sh_glenoid_treatment_of_infection" JSONB,  -- Glenoid treatment of infection
    "orth_sh_glenoid_treatment_other" TEXT,  -- Glenoid treatment other
    "orth_sh_glenoid_technique_details" TEXT,  -- Glenoid technique details
    "orth_sh_glenoid_implant_details" TEXT,  -- Glenoid implant details
    "orth_sh_glenoid_intraoperative_complications" TEXT,  -- Glenoid intraoperative complications
    "orth_sh_scapula_spine_treatment" JSONB,  -- Scapula spine treatment
    "orth_sh_scapula_spine_fracture_reduction" JSONB,  -- Scapula spine fracture reduction
    "orth_sh_scapula_spine_fixation_technique" JSONB,  -- Scapula spine fixation technique
    "orth_sh_scapula_spine_recon_bone_graft_type" JSONB,  -- Scapula spine recon bone graft type
    "orth_sh_scapula_spine_recon_bone_graft_fixation_type" JSONB,  -- Scapula spine recon bone graft fixation type
    "orth_sh_scapula_spine_osteotomy_location" TEXT,  -- Scapula spine osteotomy location
    "orth_sh_scapula_spine_osteotomy_type" TEXT,  -- Scapula spine osteotomy type
    "orth_sh_scapula_spine_extent_of_removal_of_implants" VARCHAR(50),  -- Scapula spine extent of removal of implants
    "orth_sh_scapula_spine_implants_removed" TEXT,  -- Scapula spine implants removed
    "orth_sh_scapula_spine_implants_retained" TEXT,  -- Scapula spine implants retained
    "orth_sh_scapula_spine_treatment_of_infection" JSONB,  -- Scapula spine treatment of infection
    "orth_sh_scapula_spine_treatment_other" TEXT,  -- Scapula spine treatment other
    "orth_sh_scapula_spine_technique_details" TEXT,  -- Scapula spine technique details
    "orth_sh_scapula_spine_implant_details" TEXT,  -- Scapula spine implant details
    "orth_sh_scapula_spine_intraoperative_complications" TEXT,  -- Scapula spine intraoperative complications
    "orth_sh_acromion_treatment" JSONB,  -- Acromion treatment
    "orth_sh_acromion_fracture_reduction" JSONB,  -- Acromion fracture reduction
    "orth_sh_acromion_fixation_technique" JSONB,  -- Acromion fixation technique
    "orth_sh_acromion_recon_bone_graft_type" JSONB,  -- Acromion recon bone graft type
    "orth_sh_acromion_recon_bone_graft_fixation_type" JSONB,  -- Acromion recon bone graft fixation type
    "orth_sh_acromion_osteotomy_location" TEXT,  -- Acromion osteotomy location
    "orth_sh_acromion_osteotomy_type" TEXT,  -- Acromion osteotomy type
    "orth_sh_acromion_extent_of_removal_of_implants" VARCHAR(50),  -- Acromion extent of removal of implants
    "orth_sh_acromion_implants_removed" TEXT,  -- Acromion implants removed
    "orth_sh_acromion_implants_retained" TEXT,  -- Acromion implants retained
    "orth_sh_acromion_treatment_of_infection" JSONB,  -- Acromion treatment of infection
    "orth_sh_acromion_treatment_other" TEXT,  -- Acromion treatment other
    "orth_sh_acromion_technique_details" TEXT,  -- Acromion technique details
    "orth_sh_acromion_implant_details" TEXT,  -- Acromion implant details
    "orth_sh_acromion_intraoperative_complications" TEXT,  -- Acromion intraoperative complications
    "orth_sh_coracoid_treatment" JSONB,  -- Coracoid treatment
    "orth_sh_coracoid_fracture_reduction" JSONB,  -- Coracoid fracture reduction
    "orth_sh_coracoid_fixation_technique" JSONB,  -- Coracoid fixation technique
    "orth_sh_coracoid_recon_bone_graft_type" JSONB,  -- Coracoid recon bone graft type
    "orth_sh_coracoid_recon_bone_graft_fixation_type" JSONB,  -- Coracoid recon bone graft fixation type
    "orth_sh_coracoid_osteotomy_location" TEXT,  -- Coracoid osteotomy location
    "orth_sh_coracoid_osteotomy_type" TEXT,  -- Coracoid osteotomy type
    "orth_sh_coracoid_extent_of_removal_of_implants" VARCHAR(50),  -- Coracoid extent of removal of implants
    "orth_sh_coracoid_implants_removed" TEXT,  -- Coracoid implants removed
    "orth_sh_coracoid_implants_retained" TEXT,  -- Coracoid implants retained
    "orth_sh_coracoid_treatment_of_infection" JSONB,  -- Coracoid treatment of infection
    "orth_sh_coracoid_treatment_other" TEXT,  -- Coracoid treatment other
    "orth_sh_coracoid_technique_details" TEXT,  -- Coracoid technique details
    "orth_sh_coracoid_implant_details" TEXT,  -- Coracoid implant details
    "orth_sh_coracoid_intraoperative_complications" TEXT,  -- Coracoid intraoperative complications
    "orth_sh_clavicle_fracture_reduction" JSONB,  -- Clavicle fracture reduction
    "orth_sh_clavicle_fixation_technique" JSONB,  -- Clavicle fixation technique
    "orth_sh_clavicle_recon_bone_graft_type" JSONB,  -- Clavicle recon bone graft type
    "orth_sh_clavicle_recon_bone_graft_fixation_type" JSONB,  -- Clavicle recon bone graft fixation type
    "orth_sh_clavicle_osteotomy_location" TEXT,  -- Clavicle osteotomy location
    "orth_sh_clavicle_osteotomy_type" TEXT,  -- Clavicle osteotomy type
    "orth_sh_clavicle_extent_of_implant_removal" VARCHAR(50),  -- Clavicle extent of implant removal
    "orth_sh_clavicle_implants_removed" TEXT,  -- Clavicle implants removed
    "orth_sh_clavicle_implants_retained" TEXT,  -- Clavicle implants retained
    "orth_sh_clavicle_treatment_of_infection" JSONB,  -- Clavicle treatment of infection
    "orth_sh_clavicle_treatment_other" TEXT,  -- Clavicle treatment other
    "orth_sh_clavicle_technique_details" TEXT,  -- Clavicle technique details
    "orth_sh_clavicle_implant_details" TEXT,  -- Clavicle implant details
    "orth_sh_clavicle_intraoperative_complications" TEXT,  -- Clavicle intraoperative complications
    "orth_sh_acj_treatment" JSONB,  -- ACJ treatment
    "orth_sh_acj_arthrodesis_type" JSONB,  -- ACJ arthrodesis type
    "orth_sh_acj_arthrodesis_implant" JSONB,  -- ACJ arthrodesis implant
    "orth_sh_acj_arthrodesis_bone_graft" JSONB,  -- ACJ arthrodesis bone graft
    "orth_sh_acj_debridement_arthroplasty_type" JSONB,  -- ACJ debridement arthroplasty type
    "orth_sh_acj_excision_arthroplasty_type" JSONB,  -- ACJ excision arthroplasty type
    "orth_sh_acj_interposition_material" TEXT,  -- ACJ interposition material
    "orth_sh_acj_arthroplasty_replacement_primary" TEXT,  -- ACJ arthroplasty replacement primary
    "orth_sh_acj_arthroplasty_replacement_revision" TEXT,  -- ACJ_arthroplasty_replacement_revision
    "orth_sh_acj_stabilisation_type" JSONB,  -- ACJ stabilisation type
    "orth_sh_acj_capsule_ligament_repair_type" JSONB,  -- ACJ capsule ligament repair type
    "orth_sh_acj_capsule_ligament_to_bone_repair_proximal" JSONB,  -- ACJ capsule ligament to bone repair proximal
    "orth_sh_acj_capsule_ligament_to_bone_repair_distal" JSONB,  -- ACJ capsule ligament to bone repair distal
    "orth_sh_acj_capsule_ligament_recon_graft_type" JSONB,  -- ACJ capsule ligament recon graft type
    "orth_sh_acj_capsule_ligament_recon_fixation_proximal" JSONB,  -- ACJ capsule ligament recon fixation proximal
    "orth_sh_acj_capsule_ligament_recon_fixation_distal" JSONB,  -- ACJ capsule ligament recon fixation distal
    "orth_sh_acj_joint_spanning_fixation" JSONB,  -- ACJ joint spanning fixation
    "orth_sh_acj_avulsion_fracture_fixation" JSONB,  -- ACJ avulsion fracture fixation
    "orth_sh_acj_bone_recon_bone_graft" JSONB,  -- ACJ bone recon bone graft
    "orth_sh_acj_bone_recon_bone_graft_fixation" JSONB,  -- ACJ bone recon bone graft fixation
    "orth_sh_acj_bone_recon_bone_graft_location" JSONB,  -- ACJ bone recon bone graft location
    "orth_sh_cc_ligament_repair_type" JSONB,  -- CC ligament repair type
    "orth_sh_cc_ligament_repair_bone_fixation_proximal" JSONB,  -- CC ligament repair bone fixation proximal
    "orth_sh_cc_ligament_repair_bone_fixation_distal" JSONB,  -- CC ligament repair bone fixation distal
    "orth_sh_cc_ligament_recon_graft_type" JSONB,  -- CC ligament recon graft type
    "orth_sh_cc_ligament_recon_fixation_proximal" JSONB,  -- CC ligament recon fixation proximal
    "orth_sh_cc_ligament_recon_fixation_distal" JSONB,  -- CC ligament recon fixation distal
    "orth_sh_cc_ligament_avulsion_fracture_fixation" JSONB,  -- CC ligament avulsion fracture fixation
    "orth_sh_cc_interval_spanning_fixation" JSONB,  -- CC interval spanning fixation
    "orth_sh_cc_bone_reconstruction" JSONB,  -- CC bone reconstruction
    "orth_sh_cc_bone_reconstruction_fixation" JSONB,  -- CC bone reconstruction fixation
    "orth_sh_cc_bone_reconstruction_location" JSONB,  -- CC bone reconstruction location
    "orth_sh_acj_arthrolysis_techniques" JSONB,  -- ACJ arthrolysis techniques
    "orth_sh_acj_articular_cartilage_techniques" JSONB,  -- ACJ articular cartilage techniques
    "orth_sh_acj_periarticular_cyst_treatment" JSONB,  -- ACJ periarticular cyst treatment
    "orth_sh_acj_biopsy_tissue" JSONB,  -- ACJ biopsy tissue
    "orth_sh_acj_reduction_type" JSONB,  -- ACJ reduction type
    "orth_sh_acj_extent_of_implant_removal" VARCHAR(50),  -- ACJ extent of implant removal
    "orth_sh_acj_implants_removed" TEXT,  -- ACJ implants removed
    "orth_sh_acj_implants_retained" TEXT,  -- ACJ implants retained
    "orth_sh_acj_treatment_of_infection" JSONB,  -- ACJ treatment of infection
    "orth_sh_acj_treatment_other" TEXT,  -- ACJ treatment other
    "orth_sh_acj_technique_details" TEXT,  -- ACJ technique details
    "orth_sh_acj_implant_details" TEXT,  -- ACJ implant details
    "orth_sh_acj_intraoperative_complications" TEXT,  -- ACJ intraoperative complications
    "orth_sh_acromioplasty_location" JSONB,  -- Acromioplasty location
    "orth_sh_subacromial_spacer_type" JSONB,  -- Subacromial spacer type
    "orth_sh_sa_sc_sd_extent_of_implant_removal" VARCHAR(50),  -- SA SC SD extent of implant removal
    "orth_sh_sa_sc_sd_implants_removed" TEXT,  -- SA SC SD implants removed
    "orth_sh_sa_sc_sd_implants_retained" TEXT,  -- SA SC SD implants retained
    "orth_sh_sa_sc_sd_treatment_of_infection" JSONB,  -- SA SC SD treatment of infection
    "orth_sh_sa_sc_sd_other" TEXT,  -- SA SC SD other
    "orth_sh_sa_sc_sd_technique_details" TEXT,  -- SA SC SD technique details
    "orth_sh_sa_sc_sd_implant_details" TEXT,  -- SA SC SD implant details
    "orth_sh_sa_sc_sd_intraoperative_complications" TEXT,  -- SA SC SD intraoperative complications
    "orth_sh_subscapularis_repair_outcome" VARCHAR(50),  -- Subscapularis repair outcome
    "orth_sh_subscapularis_repair_fixation_type" VARCHAR(50),  -- Subscapularis repair fixation type
    "orth_sh_subscapularis_repair_medial_row_fixation_points" VARCHAR(50),  -- Subscapularis repair medial row fixation points
    "orth_sh_subscapularis_repair_medial_row_fixation_type" VARCHAR(50),  -- Subscapularis repair medial row fixation type
    "orth_sh_subscapularis_augment_capsular_surface_graft" JSONB,  -- Subscapularis augment capsular surface graft
    "orth_sh_subscapularis_augment_bursal_surface_graft" JSONB,  -- Subscapularis augment bursal surface graft
    "orth_sh_subscapularis_augment_graft_fixation_location" JSONB,  -- Subscapularis augment graft fixation location
    "orth_sh_subscapularis_augment_humerus_fixation" JSONB,  -- Subscapularis augment humerus fixation
    "orth_sh_subscapularis_augment_tendon_fixation" JSONB,  -- Subscapularis augment tendon fixation
    "orth_sh_subscapularis_augment_glenoid_fixation" JSONB,  -- Subscapularis augment glenoid fixation
    "orth_sh_subscapularis_recon_capsular_surface_graft" JSONB,  -- Subscapularis recon capsular surface graft
    "orth_sh_subscapularis_recon_bursal_surface_graft" JSONB,  -- Subscapularis recon bursal surface graft
    "orth_sh_subscapularis_recon_graft_fixation_location" JSONB,  -- Subscapularis recon graft fixation location
    "orth_sh_subscapularis_recon_humerus_fixation" JSONB,  -- Subscapularis recon humerus fixation
    "orth_sh_subscapularis_recon_tendon_fixation" JSONB,  -- Subscapularis recon tendon fixation
    "orth_sh_subscapularis_recon_glenoid_fixation" JSONB,  -- Subscapularis recon glenoid fixation
    "orth_sh_subscapularis_tendon_transfer_donor" VARCHAR(50),  -- Subscapularis tendon transfer donor
    "orth_sh_subscapularis_tendon_transfer_fixation" VARCHAR(50),  -- Subscapularis tendon transfer fixation
    "orth_sh_subscapularis_mobilisation_techniques" JSONB,  -- Subscapularis mobilisation techniques
    "orth_sh_subscapularis_fixation_details" TEXT,  -- Subscapularis fixation details
    "orth_sh_subscapularis_tendon_other" TEXT,  -- Subscapularis tendon other
    "orth_sh_posterosuperior_tendon_repair_outcome" VARCHAR(50),  -- Posterosuperior tendon repair outcome
    "orth_sh_posterosuperior_tendon_repair_fixation_type" JSONB,  -- Posterosuperior tendon repair fixation type
    "orth_sh_posterosuperior_cuff_repair_medial_row_fixation_points" VARCHAR(50),  -- Posterosuperior cuff repair medial row fixation points
    "orth_sh_posterosuperior_repair_medial_row_fixation_type" JSONB,  -- Posterosuperior repair medial row fixation type
    "orth_sh_posterosuperior_cuff_augment_capsular_surface_graft" JSONB,  -- Posterosuperior cuff augment capsular surface graft
    "orth_sh_posterosuperior_cuff_augment_bursal_surface_graft" JSONB,  -- Posterosuperior cuff augment bursal surface graft
    "orth_sh_posterosuperior_cuff_augmentation_graft_fixation_locati" JSONB,  -- Posterosuperior cuff augmentation graft fixation location
    "orth_sh_posterosuperior_cuff_augment_humerus_fixation" JSONB,  -- Posterosuperior cuff augment humerus fixation
    "orth_sh_posterosuperior_cuff_augment_tendon_fixation" JSONB,  -- Posterosuperior cuff augment tendon fixation
    "orth_sh_posterosuperior_cuff_augment_glenoid_fixation" JSONB,  -- Posterosuperior cuff augment glenoid fixation
    "orth_sh_posterosuperior_cuff_recon_capsular_surface_graft" JSONB,  -- Posterosuperior cuff recon capsular surface graft
    "orth_sh_posterosuperior_cuff_recon_bursal_surface_graft" JSONB,  -- Posterosuperior cuff recon bursal surface graft
    "orth_sh_posterosuperior_cuff_recon_graft_fixation_location" JSONB,  -- Posterosuperior cuff recon graft fixation location
    "orth_sh_posterosuperior_cuff_recon_humerus_fixation" JSONB,  -- Posterosuperior cuff recon humerus fixation
    "orth_sh_posterosuperior_cuff_recon_tendon_fixation" JSONB,  -- Posterosuperior cuff recon tendon fixation
    "orth_sh_posterosuperior_cuff_recon_glenoid_fixation" JSONB,  -- Posterosuperior cuff recon glenoid fixation
    "orth_sh_posterosuperior_tendon_transfer_type" JSONB,  -- Posterosuperior tendon transfer type
    "orth_sh_posterosuperior_tendon_transfer_fixation" JSONB,  -- Posterosuperior tendon transfer fixation
    "orth_sh_posterosuperior_tendon_transfer_bridging_graft" JSONB,  -- Posterosuperior tendon transfer bridging graft
    "orth_sh_posterosuperior_cuff_mobilisation_techniques" JSONB,  -- Posterosuperior cuff mobilisation techniques
    "orth_sh_posterosuperior_cuff_fixation_details" TEXT,  -- Posterosuperior cuff fixation details
    "orth_sh_posterosuperior_cuff_other" TEXT,  -- Posterosuperior cuff other
    "orth_sh_rotator_cuff_extent_of_implant_removal" VARCHAR(50),  -- Rotator cuff extent of implant removal
    "orth_sh_rotator_cuff_implants_removed" VARCHAR(500),  -- Rotator cuff implants removed
    "orth_sh_rotator_cuff_implants_retained" VARCHAR(500),  -- Rotator cuff implants retained
    "orth_sh_rotator_cuff_technique_details" TEXT,  -- Rotator cuff technique details
    "orth_sh_rotator_cuff_implant_details" TEXT,  -- Rotator cuff implant details
    "orth_sh_rotator_cuff_intraoperative_complications" TEXT,  -- Rotator cuff intraoperative complications
    "orth_sh_biceps_anchor_repair_fixation_to_bone" JSONB,  -- Biceps anchor repair fixation to bone
    "orth_sh_biceps_anchor_extent_of_implant_removal" VARCHAR(50),  -- Biceps anchor extent of implant removal
    "orth_sh_biceps_anchor_implants_removed" VARCHAR(500),  -- Biceps anchor implants removed
    "orth_sh_biceps_anchor_implants_retained" VARCHAR(500),  -- Biceps anchor implants retained
    "orth_sh_biceps_anchor_other_treatment" TEXT,  -- Biceps anchor other
    "orth_sh_biceps_anchor_technique_details" TEXT,  -- Biceps anchor technique details
    "orth_sh_biceps_anchor_implant_details" TEXT,  -- Biceps anchor implant details
    "orth_sh_biceps_anchor_intraoperative_complications" TEXT,  -- Biceps anchor intraoperative complications
    "orth_sh_lhb_tenotomy_location" JSONB,  -- LHB tenotomy location
    "orth_sh_lhb_tenodesis_type" VARCHAR(50),  -- LHB tenodesis type
    "orth_sh_lhb_tenodesis_location" JSONB,  -- LHB tenodesis location
    "orth_sh_lhb_extent_of_implant_removal" VARCHAR(50),  -- LHB extent of implant removal
    "orth_sh_lhb_implants_removed" VARCHAR(500),  -- LHB implants removed
    "orth_sh_lhb_implants_retained" VARCHAR(500),  -- LHB implants retained
    "orth_sh_lhb_other_treatment" TEXT,  -- LHB other
    "orth_sh_lhb_technique_details" TEXT,  -- LHB technique details
    "orth_sh_lhb_implant_details" TEXT,  -- LHB implant details
    "orth_sh_lhb_intraoperative_complications" TEXT,  -- LHB intraoperative complications
    "orth_sh_ghj_arthrodesis_type" JSONB,  -- GHJ arthrodesis type
    "orth_sh_ghj_arthrodesis_implant" JSONB,  -- GHJ arthrodesis implant
    "orth_sh_ghj_arthrodesis_bone_graft" JSONB,  -- GHJ arthrodesis bone graft
    "orth_sh_ghj_debridement_arthroplasty_type" JSONB,  -- GHJ debridement arthroplasty type
    "orth_sh_ghj_interposition_material" TEXT,  -- GHJ interposition material
    "orth_sh_ghj_replacement_arthroplasty_intention" VARCHAR(50),  -- GHJ replacement arthroplasty intention
    "orth_sh_ghj_replacement_temporary_type" VARCHAR(50),  -- GHJ replacement temporary type
    "orth_sh_ghj_replacement_temporary_location" VARCHAR(50),  -- GHJ replacement temporary location
    "orth_sh_ghj_replacement_type" VARCHAR(50),  -- GHJ replacement type
    "orth_sh_ghj_replacement_anatomic_type" VARCHAR(50),  -- GHJ replacement anatomic type
    "orth_sh_ghj_replacement_anatomic_glenoid" VARCHAR(50),  -- GHJ replacement anatomic glenoid
    "orth_sh_ghj_replacement_anatomic_glenoid_fixation" VARCHAR(50),  -- GHJ replacement anatomic glenoid fixation
    "orth_sh_ghj_replacement_anatomic_glenoid_bone_graft" VARCHAR(50),  -- GHJ replacement anatomic glenoid bone graft
    "orth_sh_ghj_replacement_anatomic_glenoid_design" VARCHAR(50),  -- GHJ replacement anatomic glenoid design
    "orth_sh_ghj_replacement_anatomic_glenoid_bearing_surface" VARCHAR(50),  -- GHJ replacement anatomic glenoid bearing surface
    "orth_sh_ghj_replacement_anatomic_humerus_design" VARCHAR(50),  -- GHJ replacement anatomic humerus design
    "orth_sh_ghj_replacement_anatomic_humerus_bearing_surface" VARCHAR(50),  -- GHJ replacement anatomic humerus bearing surface
    "orth_sh_ghj_replacement_anatomic_humerus_fixation" VARCHAR(50),  -- GHJ replacement anatomic humerus fixation
    "orth_sh_ghj_replacement_reverse_type" VARCHAR(50),  -- GHJ replacement reverse type
    "orth_sh_ghj_replacement_reverse_baseplate_type" VARCHAR(50),  -- GHJ replacement reverse baseplate type
    "orth_sh_ghj_replacement_reverse_augmented_baseplate" VARCHAR(50),  -- GHJ replacement reverse augmented baseplate
    "orth_sh_ghj_replacement_reverse_baseplate_fixation" VARCHAR(50),  -- GHJ replacement reverse baseplate fixation
    "orth_sh_ghj_replacement_reverse_baseplate_peripheral_screws" VARCHAR(50),  -- GHJ replacement reverse baseplate peripheral screws
    "orth_sh_ghj_replacement_reverse_baseplate_shape" VARCHAR(50),  -- GHJ replacement reverse baseplate shape
    "orth_sh_ghj_replacement_reverse_baseplate_graft" VARCHAR(50),  -- GHJ replacement reverse baseplate graft
    "orth_sh_ghj_replacement_reverse_glenosphere_bearing_sphere" VARCHAR(50),  -- GHJ replacement reverse glenosphere bearing surface
    "orth_sh_ghj_replacement_reverse_glenosphere_diameter" TEXT,  -- GHJ replacement reverse glenosphere diameter
    "orth_sh_ghj_replacement_reverse_glenosphere_geometry" VARCHAR(50),  -- GHJ replacement reverse glenosphere geometry
    "orth_sh_ghj_replacement_reverse_humerus_type" VARCHAR(50),  -- GHJ replacement reverse humerus type
    "orth_sh_ghj_replacement_reverse_humerus_bearing_surface" VARCHAR(50),  -- GHJ replacement reverse humerus bearing surface
    "orth_sh_ghj_replacement_reverse_humerus_fixation" JSONB,  -- GHJ replacement reverse humerus fixation
    "orth_sh_ghj_replacement_reverse_humerus_uncemented_type" VARCHAR(50),  -- GHJ replacement reverse humerus uncemented type
    "orth_sh_ghj_replacement_subscapularis_management" VARCHAR(50),  -- GHJ replacement subscapularis management
    "orth_sh_ghj_replacement_subscapularis_repair" VARCHAR(50),  -- GHJ replacement subscapularis repair
    "orth_sh_ghj_replacement_subscapularis_repair_type" JSONB,  -- GHJ replacement subscapularis repair type
    "orth_sh_ghj_stabilisation_type" JSONB,  -- GHJ stabilisation type
    "orth_sh_ghj_capsulolabral_repair_anterior_labrum_to_bone_fixati" JSONB,  -- GHJ capsulolabral repair anterior labrum to bone fixation
    "orth_sh_remplissage_fixation" JSONB,  -- Remplissage fixation
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_general_part_3_part_3
CREATE INDEX IF NOT EXISTS idx_shoulder_general_part_3_part_3_encounter ON shoulder_general_part_3_part_3(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_general_part_3_part_3_created ON shoulder_general_part_3_part_3(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_general_part_3_part_3
    ADD CONSTRAINT fk_shoulder_general_part_3_part_3_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: demographics_part_4_part_4
-- Generated: 2025-11-28T20:28:38.878874
-- Fields: 250

CREATE TABLE IF NOT EXISTS demographics_part_4_part_4 (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_p_ases_comb_36mo" VARCHAR(50),  -- Can you comb / wash your hair?
    "dem_p_ases_toilet_36mo" VARCHAR(50),  -- Can you use toilet tissue?
    "dem_p_ases_shelf_36mo" VARCHAR(50),  -- Can you reach a shelf over your head?
    "dem_p_ases_4kg_36mo" VARCHAR(50),  -- Can you lift 4 kilograms above the level of your shoulder?
    "dem_p_ases_throw_36mo" VARCHAR(50),  -- Can you throw a ball overhand?
    "dem_full_work_36mo" VARCHAR(50),  -- Does your shoulder allow you to work full time at your usual
    "dem_rtw_36mo" VARCHAR(50),  -- What work are you currently able to do (if not working-your 
    "dem_full_work_csmasss_36mo" DECIMAL,  -- Full Work CS/MASSS
    "dem_usual_sports_36mo" VARCHAR(50),  -- Does your shoulder allow you to do your usual sports?
    "dem_usual_sports_csmasss_36mo" DECIMAL,  -- Usual Sports CS/MASSS
    "dem_rts_36mo" VARCHAR(50),  -- Are you able to do your usual sports/activities?
    "dem_csmasss_comfortable_use_36mo" VARCHAR(50),  -- What level can you use your arm for painless activities?
    "dem_rowe_subjective_instability_36mo" VARCHAR(50),  -- Have you had a shoulder dislocation or do you feel apprehens
    "dem_abd_pic_36mo" TEXT,  -- Abduction
    "dem_p_abd_36mo" DECIMAL,  -- Give the range of motion of ABDUCTION (raising your arm to t
    "dem_abd_rowe_36mo" DECIMAL,  -- Abduction (Rowe)
    "dem_er_pic_36mo" TEXT,  -- (A) External rotation in Abduction and (B) External rotation
    "dem_p_aber_36mo" DECIMAL,  -- Give the range of motion of EXTERNAL ROTATION IN ABDUCTION (
    "dem_p_ader_36mo" DECIMAL,  -- Give the range of motion of EXTERNAL ROTATION IN ADDUCTION (
    "dem_ader_rowe_36mo" DECIMAL,  -- ADER (Rowe)
    "dem_ir_pic_36mo" TEXT,  -- Internal Rotation
    "dem_p_ir_36mo" DECIMAL,  -- Give the range of motion of INTERNAL ROTATION (reaching up y
    "dem_ir_rowe_36mo" DECIMAL,  -- IR (Rowe)
    "dem_rom_vas_36mo" DECIMAL,  -- Give the overall range of motion of your affected/operated s
    "dem_csmasss_strength_36mo" DECIMAL,  -- Give the overall strength of your affected/operated shoulder
    "dem_sane_stability_36mo" DECIMAL,  -- Give the overall stability of your affected/operated shoulde
    "dem_ssv_36mo" DECIMAL,  -- Give your affected/operated shoulder an overall mark out of 
    "dem_ssv_rowe_36mo" DECIMAL,  -- SSV (Rowe)
    "dem_total_ases_36mo" DECIMAL,  -- Total ASES
    "dem_total_csmasss_36mo" DECIMAL,  -- Total CS MASSS
    "dem_total_rowe_36mo" DECIMAL,  -- Total Rowe
    "dem_shoulder_extension_36mo" VARCHAR(500),  -- Shoulder Extension
    "dem_shoulder_abduction_36mo" VARCHAR(500),  -- Shoulder Abduction
    "dem_shoulder_er1_36mo" VARCHAR(500),  -- Shoulder External Rotation with elbow at the side (ER1)
    "dem_shoulder_er2_36mo" VARCHAR(500),  -- Shoulder External Rotation with arm abducted at 90° (ER1)
    "dem_shoulder_ir_36mo" VARCHAR(500),  -- Shoulder Internal Rotation
    "dem_date_5y" DATE,  -- Today's Date
    "dem_lastname_5y" VARCHAR(500),  -- Surname
    "dem_givenname_5y" VARCHAR(500),  -- First Name
    "dem_dateofbirth_5y" DATE,  -- Date of Birth
    "dem_email_pt_5y" VARCHAR(255),  -- Email
    "dem_mobile_pt_5y" VARCHAR(500),  -- Mobile Number
    "dem_mainsport_5y" VARCHAR(500),  -- Main Sport
    "dem_mainsportgrade_5y" VARCHAR(50),  -- Main Sport Grade
    "dem_pain_vas_5y" INTEGER,  -- How much pain in your shoulder do you have during your usual
    "dem_pain_rowe_5y" DECIMAL,  -- Pain (Rowe)
    "dem_csmasss_sleep_q_5y" VARCHAR(50),  -- Is your night's sleep disturbed by your shoulder?
    "dem_p_ases_sleep_5y" VARCHAR(50),  -- Can you sleep on your affected shoulder comfortably
    "dem_p_ases_bra_5y" VARCHAR(50),  -- Can you wash your back / fasten your bra?
    "dem_p_ases_coat_5y" VARCHAR(50),  -- Can you put on your coat unassisted?
    "dem_p_ases_comb_5y" VARCHAR(50),  -- Can you comb / wash your hair?
    "dem_p_ases_toilet_5y" VARCHAR(50),  -- Can you use toilet tissue?
    "dem_p_ases_shelf_5y" VARCHAR(50),  -- Can you reach a shelf over your head?
    "dem_p_ases_4kg_5y" VARCHAR(50),  -- Can you lift 4 kilograms above the level of your shoulder?
    "dem_p_ases_throw_5y" VARCHAR(50),  -- Can you throw a ball overhand?
    "dem_full_work_5y" VARCHAR(50),  -- Does your shoulder allow you to work full time at your usual
    "dem_rtw_5y" VARCHAR(50),  -- What work are you currently able to do (if not working-your 
    "dem_full_work_csmasss_5y" DECIMAL,  -- Full Work CS/MASSS
    "dem_usual_sports_5y" VARCHAR(50),  -- Does your shoulder allow you to do your usual sports?
    "dem_usual_sports_csmasss_5y" DECIMAL,  -- Usual Sports CS/MASSS
    "dem_rts_5y" VARCHAR(50),  -- Are you able to do your usual sports/activities?
    "dem_csmasss_comfortable_use_5y" VARCHAR(50),  -- What level can you use your arm for painless activities?
    "dem_rowe_subjective_instability_5y" VARCHAR(50),  -- Have you had a shoulder dislocation or do you feel apprehens
    "dem_abd_pic_5y" TEXT,  -- Abduction
    "dem_p_abd_5y" DECIMAL,  -- Give the range of motion of ABDUCTION (raising your arm to t
    "dem_abd_rowe_5y" DECIMAL,  -- Abduction (Rowe)
    "dem_er_pic_5y" TEXT,  -- (A) External rotation in Abduction and (B) External rotation
    "dem_p_aber_5y" DECIMAL,  -- Give the range of motion of EXTERNAL ROTATION IN ABDUCTION (
    "dem_p_ader_5y" DECIMAL,  -- Give the range of motion of EXTERNAL ROTATION IN ADDUCTION (
    "dem_ader_rowe_5y" DECIMAL,  -- ADER (Rowe)
    "dem_ir_pic_5y" TEXT,  -- Internal Rotation
    "dem_p_ir_5y" DECIMAL,  -- Give the range of motion of INTERNAL ROTATION (reaching up y
    "dem_ir_rowe_5y" DECIMAL,  -- IR (Rowe)
    "dem_rom_vas_5y" DECIMAL,  -- Give the overall range of motion of your affected/operated s
    "dem_csmasss_strength_5y" DECIMAL,  -- Give the overall strength of your affected/operated shoulder
    "dem_sane_stability_5y" DECIMAL,  -- Give the overall stability of your affected/operated shoulde
    "dem_ssv_5y" DECIMAL,  -- Give your affected/operated shoulder an overall mark out of 
    "dem_ssv_rowe_5y" DECIMAL,  -- SSV (Rowe)
    "dem_total_ases_5y" DECIMAL,  -- Total ASES
    "dem_total_csmasss_5y" DECIMAL,  -- Total CS MASSS
    "dem_total_rowe_5y" DECIMAL,  -- Total Rowe
    "dem_shoulder_extension_5y" VARCHAR(500),  -- Shoulder Extension
    "dem_shoulder_abduction_5y" VARCHAR(500),  -- Shoulder Abduction
    "dem_shoulder_er1_5y" VARCHAR(500),  -- Shoulder External Rotation with elbow at the side (ER1)
    "dem_shoulder_er2_5y" VARCHAR(500),  -- Shoulder External Rotation with arm abducted at 90° (ER1)
    "dem_shoulder_ir_5y" VARCHAR(500),  -- Shoulder Internal Rotation
    "dem_date_10y" DATE,  -- Today's Date
    "dem_lastname_10y" VARCHAR(500),  -- Surname
    "dem_givenname_10y" VARCHAR(500),  -- First Name
    "dem_dateofbirth_10y" DATE,  -- Date of Birth
    "dem_email_pt_10y" VARCHAR(255),  -- Email
    "dem_mobile_pt_10y" VARCHAR(500),  -- Mobile Number
    "dem_mainsport_10y" VARCHAR(500),  -- Main Sport
    "dem_mainsportgrade_10y" VARCHAR(50),  -- Main Sport Grade
    "dem_pain_vas_10y" INTEGER,  -- How much pain in your shoulder do you have during your usual
    "dem_pain_rowe_10y" DECIMAL,  -- Pain (Rowe)
    "dem_csmasss_sleep_q_10y" VARCHAR(50),  -- Is your night's sleep disturbed by your shoulder?
    "dem_p_ases_sleep_10y" VARCHAR(50),  -- Can you sleep on your affected shoulder comfortably
    "dem_p_ases_bra_10y" VARCHAR(50),  -- Can you wash your back / fasten your bra?
    "dem_p_ases_coat_10y" VARCHAR(50),  -- Can you put on your coat unassisted?
    "dem_p_ases_comb_10y" VARCHAR(50),  -- Can you comb / wash your hair?
    "dem_p_ases_toilet_10y" VARCHAR(50),  -- Can you use toilet tissue?
    "dem_p_ases_shelf_10y" VARCHAR(50),  -- Can you reach a shelf over your head?
    "dem_p_ases_4kg_10y" VARCHAR(50),  -- Can you lift 4 kilograms above the level of your shoulder?
    "dem_p_ases_throw_10y" VARCHAR(50),  -- Can you throw a ball overhand?
    "dem_full_work_10y" VARCHAR(50),  -- Does your shoulder allow you to work full time at your usual
    "dem_rtw_10y" VARCHAR(50),  -- What work are you currently able to do (if not working-your 
    "dem_full_work_csmasss_10y" DECIMAL,  -- Full Work CS/MASSS
    "dem_usual_sports_10y" VARCHAR(50),  -- Does your shoulder allow you to do your usual sports?
    "dem_usual_sports_csmasss_10y" DECIMAL,  -- Usual Sports CS/MASSS
    "dem_rts_10y" VARCHAR(50),  -- Are you able to do your usual sports/activities?
    "dem_csmasss_comfortable_use_10y" VARCHAR(50),  -- What level can you use your arm for painless activities?
    "dem_rowe_subjective_instability_10y" VARCHAR(50),  -- Have you had a shoulder dislocation or do you feel apprehens
    "dem_abd_pic_10y" TEXT,  -- Abduction
    "dem_p_abd_10y" DECIMAL,  -- Give the range of motion of ABDUCTION (raising your arm to t
    "dem_abd_rowe_10y" DECIMAL,  -- Abduction (Rowe)
    "dem_er_pic_10y" TEXT,  -- (A) External rotation in Abduction and (B) External rotation
    "dem_p_aber_10y" DECIMAL,  -- Give the range of motion of EXTERNAL ROTATION IN ABDUCTION (
    "dem_p_ader_10y" DECIMAL,  -- Give the range of motion of EXTERNAL ROTATION IN ADDUCTION (
    "dem_ader_rowe_10y" DECIMAL,  -- ADER (Rowe)
    "dem_ir_pic_10y" TEXT,  -- Internal Rotation
    "dem_p_ir_10y" DECIMAL,  -- Give the range of motion of INTERNAL ROTATION (reaching up y
    "dem_ir_rowe_10y" DECIMAL,  -- IR (Rowe)
    "dem_rom_vas_10y" DECIMAL,  -- Give the overall range of motion of your affected/operated s
    "dem_csmasss_strength_10y" DECIMAL,  -- Give the overall strength of your affected/operated shoulder
    "dem_sane_stability_10y" DECIMAL,  -- Give the overall stability of your affected/operated shoulde
    "dem_ssv_10y" DECIMAL,  -- Give your affected/operated shoulder an overall mark out of 
    "dem_ssv_rowe_10y" DECIMAL,  -- SSV (Rowe)
    "dem_total_ases_10y" DECIMAL,  -- Total ASES
    "dem_total_csmasss_10y" DECIMAL,  -- Total CS MASSS
    "dem_total_rowe_10y" DECIMAL,  -- Total Rowe
    "dem_shoulder_extension_10y" VARCHAR(500),  -- Shoulder Extension
    "dem_shoulder_abduction_10y" VARCHAR(500),  -- Shoulder Abduction
    "dem_shoulder_er1_10y" VARCHAR(500),  -- Shoulder External Rotation with elbow at the side (ER1)
    "dem_shoulder_er2_10y" VARCHAR(500),  -- Shoulder External Rotation with arm abducted at 90° (ER1)
    "dem_shoulder_ir_10y" VARCHAR(500),  -- Shoulder Internal Rotation
    "dem_pree1_3mo" DECIMAL,  -- How much pain in your ELBOW do you have when it is at its wo
    "dem_pree2_3mo" DECIMAL,  -- How much pain in your ELBOW do you have at rest?
    "dem_pree3_3mo" DECIMAL,  -- How much pain in your ELBOW do you have lifting a heavy obje
    "dem_pree4_3mo" DECIMAL,  -- How much pain in your ELBOW do you have when doing a task wi
    "dem_pree5_3mo" DECIMAL,  -- How often do you have pain in your elbow?
    "dem_mepimesss6_3mo" VARCHAR(50),  -- Rate the OVERALL pain in your elbow
    "dem_pree7_3mo" DECIMAL,  -- Can you comb hair?
    "dem_pree7_mepi_3mo" DECIMAL,  -- PREE7 to MEPI
    "dem_pree8_3mo" DECIMAL,  -- Can you eat with a fork or spoon?
    "dem_pree8_mepi_3mo" DECIMAL,  -- PREE8 to MEPI
    "dem_pree9_3mo" DECIMAL,  -- Can you pull a heavy object?
    "dem_pree10_3mo" DECIMAL,  -- Can you rise from a chair pushing with arm?
    "dem_pree11_3mo" DECIMAL,  -- Can you carry a 4kg object with your arm at your side?
    "dem_pree12_3mo" DECIMAL,  -- Can you throw a ball?
    "dem_pree13_3mo" DECIMAL,  -- Can you use a telephone?
    "dem_pree14_3mo" DECIMAL,  -- Can you do up buttons on a shirt?
    "dem_pree14_mepi_3mo" DECIMAL,  -- PREE14 to MEPI
    "dem_pree15_3mo" DECIMAL,  -- Can you wash your opposite armpit?
    "dem_pree16_3mo" DECIMAL,  -- Can you tie your shoelaces?
    "dem_pree16_mepi_3mo" DECIMAL,  -- PREE16 to MEPI
    "dem_pree17_3mo" DECIMAL,  -- Can you turn a doorknob and open a door?
    "dem_pree18_3mo" DECIMAL,  -- Can you do personal care activities (washing, dressing)?
    "dem_pree18_mepi_3mo" DECIMAL,  -- PREE18 to MEPI
    "dem_pree19_3mo" DECIMAL,  -- Can you you do household chores (cleaning, maintenance)?
    "dem_pree20_3mo" DECIMAL,  -- How much difficulty do you have with work?
    "dem_pree21_3mo" DECIMAL,  -- How much difficulty do you have with recreational activities
    "dem_pree22_3mo" VARCHAR(50),  -- Describe your current work
    "dem_pree23_3mo" VARCHAR(50),  -- Describe your current sports/activities
    "dem_elbow_flexex_3mo" DECIMAL,  -- Give the range of motion of FLEXION-EXTENSION (bending and s
    "dem_elbow_flexex_to_mepi_step1_3mo" DECIMAL,  -- Elbow FlexEx to MEPI Step1
    "dem_elbow_flexex_to_mepi_step2_3mo" DECIMAL,  -- Elbow FlexEx to MEPI Step1
    "dem_elbow_pronsup_3mo" DECIMAL,  -- Give the range of motion of PRONATION-SUPINATION (turning yo
    "dem_elbow_strength_3mo" DECIMAL,  -- Give the overall strength of your affected/operated elbow a 
    "dem_stability_sane_3mo" DECIMAL,  -- Give the overall stability of your affected/operated elbow a
    "dem_stability_sane_to_mepi_3mo" DECIMAL,  -- Stability SANE to MEPI
    "dem_pree_total_3mo" DECIMAL,  -- PREE (Total)
    "dem_mepi_total_3mo" DECIMAL,  -- MEPI (Total)
    "dem_sev_3mo" DECIMAL,  -- Give your affected/operated elbow an overall mark out of 100
    "dem_elbow_extension_3mo" VARCHAR(500),  -- Elbow Extension
    "dem_pronation_3mo" VARCHAR(500),  -- Pronation
    "dem_supination_3mo" VARCHAR(500),  -- Supination
    "dem_pree1_6mo" DECIMAL,  -- How much pain in your ELBOW do you have when it is at its wo
    "dem_pree2_6mo" DECIMAL,  -- How much pain in your ELBOW do you have at rest?
    "dem_pree3_6mo" DECIMAL,  -- How much pain in your ELBOW do you have lifting a heavy obje
    "dem_pree4_6mo" DECIMAL,  -- How much pain in your ELBOW do you have when doing a task wi
    "dem_pree5_6mo" DECIMAL,  -- How often do you have pain in your elbow?
    "dem_mepimesss6_6mo" VARCHAR(50),  -- Rate the OVERALL pain in your elbow
    "dem_pree7_6mo" DECIMAL,  -- Can you comb hair?
    "dem_pree7_mepi_6mo" DECIMAL,  -- PREE7 to MEPI
    "dem_pree8_6mo" DECIMAL,  -- Can you eat with a fork or spoon?
    "dem_pree8_mepi_6mo" DECIMAL,  -- PREE8 to MEPI
    "dem_pree9_6mo" DECIMAL,  -- Can you pull a heavy object?
    "dem_pree10_6mo" DECIMAL,  -- Can you rise from a chair pushing with arm?
    "dem_pree11_6mo" DECIMAL,  -- Can you carry a 4kg object with your arm at your side?
    "dem_pree12_6mo" DECIMAL,  -- Can you throw a ball?
    "dem_pree13_6mo" DECIMAL,  -- Can you use a telephone?
    "dem_pree14_6mo" DECIMAL,  -- Can you do up buttons on a shirt?
    "dem_pree14_mepi_6mo" DECIMAL,  -- PREE14 to MEPI
    "dem_pree15_6mo" DECIMAL,  -- Can you wash your opposite armpit?
    "dem_pree16_6mo" DECIMAL,  -- Can you tie your shoelaces?
    "dem_pree16_mepi_6mo" DECIMAL,  -- PREE16 to MEPI
    "dem_pree17_6mo" DECIMAL,  -- Can you turn a doorknob and open a door?
    "dem_pree18_6mo" DECIMAL,  -- Can you do personal care activities (washing, dressing)?
    "dem_pree18_mepi_6mo" DECIMAL,  -- PREE18 to MEPI
    "dem_pree19_6mo" DECIMAL,  -- Can you you do household chores (cleaning, maintenance)?
    "dem_pree20_6mo" DECIMAL,  -- How much difficulty do you have with work?
    "dem_pree21_6mo" DECIMAL,  -- How much difficulty do you have with recreational activities
    "dem_pree22_6mo" VARCHAR(50),  -- Describe your current work
    "dem_pree23_6mo" VARCHAR(50),  -- Describe your current sports/activities
    "dem_elbow_flexex_6mo" DECIMAL,  -- Give the range of motion of FLEXION-EXTENSION (bending and s
    "dem_elbow_flexex_to_mepi_step1_6mo" DECIMAL,  -- Elbow FlexEx to MEPI Step1
    "dem_elbow_flexex_to_mepi_step2_6mo" DECIMAL,  -- Elbow FlexEx to MEPI Step1
    "dem_elbow_pronsup_6mo" DECIMAL,  -- Give the range of motion of PRONATION-SUPINATION (turning yo
    "dem_elbow_strength_6mo" DECIMAL,  -- Give the overall strength of your affected/operated elbow a 
    "dem_stability_sane_6mo" DECIMAL,  -- Give the overall stability of your affected/operated elbow a
    "dem_stability_sane_to_mepi_6mo" DECIMAL,  -- Stability SANE to MEPI
    "dem_pree_total_6mo" DECIMAL,  -- PREE (Total)
    "dem_mepi_total_6mo" DECIMAL,  -- MEPI (Total)
    "dem_sev_6mo" DECIMAL,  -- Give your affected/operated elbow an overall mark out of 100
    "dem_elbow_extension_6mo" VARCHAR(500),  -- Elbow Extension
    "dem_pronation_6mo" VARCHAR(500),  -- Pronation
    "dem_supination_6mo" VARCHAR(500),  -- Supination
    "dem_pree1_12mo" DECIMAL,  -- How much pain in your ELBOW do you have when it is at its wo
    "dem_pree2_12mo" DECIMAL,  -- How much pain in your ELBOW do you have at rest?
    "dem_pree3_12mo" DECIMAL,  -- How much pain in your ELBOW do you have lifting a heavy obje
    "dem_pree4_12mo" DECIMAL,  -- How much pain in your ELBOW do you have when doing a task wi
    "dem_pree5_12mo" DECIMAL,  -- How often do you have pain in your elbow?
    "dem_mepimesss6_12mo" VARCHAR(50),  -- Rate the OVERALL pain in your elbow
    "dem_pree7_12mo" DECIMAL,  -- Can you comb hair?
    "dem_pree7_mepi_12mo" DECIMAL,  -- PREE7 to MEPI
    "dem_pree8_12mo" DECIMAL,  -- Can you eat with a fork or spoon?
    "dem_pree8_mepi_12mo" DECIMAL,  -- PREE8 to MEPI
    "dem_pree9_12mo" DECIMAL,  -- Can you pull a heavy object?
    "dem_pree10_12mo" DECIMAL,  -- Can you rise from a chair pushing with arm?
    "dem_pree11_12mo" DECIMAL,  -- Can you carry a 4kg object with your arm at your side?
    "dem_pree12_12mo" DECIMAL,  -- Can you throw a ball?
    "dem_pree13_12mo" DECIMAL,  -- Can you use a telephone?
    "dem_pree14_12mo" DECIMAL,  -- Can you do up buttons on a shirt?
    "dem_pree14_mepi_12mo" DECIMAL,  -- PREE14 to MEPI
    "dem_pree15_12mo" DECIMAL,  -- Can you wash your opposite armpit?
    "dem_pree16_12mo" DECIMAL,  -- Can you tie your shoelaces?
    "dem_pree16_mepi_12mo" DECIMAL,  -- PREE16 to MEPI
    "dem_pree17_12mo" DECIMAL,  -- Can you turn a doorknob and open a door?
    "dem_pree18_12mo" DECIMAL,  -- Can you do personal care activities (washing, dressing)?
    "dem_pree18_mepi_12mo" DECIMAL,  -- PREE18 to MEPI
    "dem_pree19_12mo" DECIMAL,  -- Can you you do household chores (cleaning, maintenance)?
    "dem_pree20_12mo" DECIMAL,  -- How much difficulty do you have with work?
    "dem_pree21_12mo" DECIMAL,  -- How much difficulty do you have with recreational activities
    "dem_pree22_12mo" VARCHAR(50),  -- Describe your current work
    "dem_pree23_12mo" VARCHAR(50),  -- Describe your current sports/activities
    "dem_elbow_flexex_12mo" DECIMAL,  -- Give the range of motion of FLEXION-EXTENSION (bending and s
    "dem_elbow_flexex_to_mepi_step1_12mo" DECIMAL,  -- Elbow FlexEx to MEPI Step1
    "dem_elbow_flexex_to_mepi_step2_12mo" DECIMAL,  -- Elbow FlexEx to MEPI Step1
    "dem_elbow_pronsup_12mo" DECIMAL,  -- Give the range of motion of PRONATION-SUPINATION (turning yo
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for demographics_part_4_part_4
CREATE INDEX IF NOT EXISTS idx_demographics_part_4_part_4_encounter ON demographics_part_4_part_4(encounter_id);
CREATE INDEX IF NOT EXISTS idx_demographics_part_4_part_4_created ON demographics_part_4_part_4(created_at);

-- Foreign key constraint
ALTER TABLE demographics_part_4_part_4
    ADD CONSTRAINT fk_demographics_part_4_part_4_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_diagnosis
-- Generated: 2025-11-28T20:28:38.910574
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_diagnosis (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_diag_affected_side" JSONB,  -- Affected side
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_diagnosis
CREATE INDEX IF NOT EXISTS idx_elbow_diagnosis_encounter ON elbow_diagnosis(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_diagnosis_created ON elbow_diagnosis(created_at);

-- Foreign key constraint
ALTER TABLE elbow_diagnosis
    ADD CONSTRAINT fk_elbow_diagnosis_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_general_part_4_part_4
-- Generated: 2025-11-28T20:28:38.896069
-- Fields: 216

CREATE TABLE IF NOT EXISTS shoulder_general_part_4_part_4 (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_ghj_bony_bankart_anterior_fixation" JSONB,  -- GHJ bony bankart anterior fixation
    "orth_sh_ghj_glenoid_recon_anterior_type" VARCHAR(50),  -- GHJ glenoid recon anterior type
    "orth_sh_ghj_glenoid_recon_anterior_fbg_type" VARCHAR(50),  -- GHJ glenoid recon anterior FBG type
    "orth_sh_ghj_glenoid_recon_anterior_fbg_fixation" JSONB,  -- GHJ glenoid recon anterior FBG fixation
    "orth_sh_ghj_glenoid_recon_anterior_fbg_fixation_number" VARCHAR(50),  -- GHJ glenoid recon anterior FBG fixation number
    "orth_sh_ghj_latarjet_type" VARCHAR(50),  -- GHJ Latarjet type
    "orth_sh_ghj_latarjet_fixation" JSONB,  -- GHJ Latarjet fixation
    "orth_sh_ghj_latarjet_fixation_number" VARCHAR(50),  -- GHJ Latarjet fixation number
    "orth_sh_ghj_bristow_fixation" JSONB,  -- GHJ Bristow fixation
    "orth_sh_ghj_bristow_fixation_number" VARCHAR(50),  -- GHJ Bristow fixation number
    "orth_sh_humeral_head_recon_bone_graft_type_hsl" VARCHAR(50),  -- Humeral head recon bone graft type HSL
    "orth_sh_humeral_head_recon_bone_graft_fixation_hsl" JSONB,  -- Humeral head recon bone graft fixation HSL
    "orth_sh_ghj_labral_recon_anterior" VARCHAR(50),  -- GHJ labral recon anterior
    "orth_sh_ghj_labral_recon_anterior_fixation" JSONB,  -- GHJ labral recon anterior fixation
    "orth_sh_ghj_capsular_recon_anterior" VARCHAR(50),  -- GHJ capsular recon anterior
    "orth_sh_ghj_capsular_recon_anterior_glenoid_fixation" JSONB,  -- GHJ capsular recon anterior glenoid fixation
    "orth_sh_ghj_capsular_recon_anterior_humeral_fixation" JSONB,  -- GHJ capsular recon anterior humeral fixation
    "orth_sh_ghj_capsulolabral_repair_posterior_labrum_to_bone_fixat" JSONB,  -- GHJ capsulolabral repair posterior labrum to bone fixation
    "orth_sh_ghj_bony_bankart_posterior_fixation" JSONB,  -- GHJ bony bankart posterior fixation
    "orth_sh_ghj_glenoid_recon_posterior_type" VARCHAR(50),  -- GHJ glenoid recon posterior type
    "orth_sh_ghj_glenoid_recon_posterior_fbg_type" VARCHAR(50),  -- GHJ glenoid recon posterior FBG type
    "orth_sh_ghj_glenoid_recon_posterior_fbg_fixation" JSONB,  -- GHJ glenoid recon posterior FBG fixation
    "orth_sh_ghj_glenoid_recon_posterior_fbg_fixation_number" VARCHAR(50),  -- GHJ glenoid recon posterior FBG fixation number
    "orth_sh_ghj_glenoid_recon_posterior_kouvalchouk_fixation" JSONB,  -- GHJ glenoid recon posterior Kouvalchouk fixation
    "orth_sh_ghj_glenoid_recon_posterior_kouvalchouk_fixation_number" VARCHAR(50),  -- GHJ glenoid recon posterior Kouvalchouk fixation number
    "orth_sh_humeral_head_recon_bone_graft_type_rhsl" VARCHAR(50),  -- Humeral head recon bone graft type rHSL
    "orth_sh_humeral_head_recon_bone_graft_fixation_rhsl" JSONB,  -- Humeral head recon bone graft fixation rHSL
    "orth_sh_ghj_labral_recon_posterior" VARCHAR(50),  -- GHJ labral recon posterior
    "orth_sh_ghj_labral_recon_posterior_fixation" JSONB,  -- GHJ labral recon posterior fixation
    "orth_sh_ghj_capsular_recon_posterior" VARCHAR(50),  -- GHJ capsular recon posterior
    "orth_sh_ghj_capsular_recon_posterior_glenoid_fixation" JSONB,  -- GHJ capsular recon posterior glenoid fixation
    "orth_sh_ghj_capsular_recon_posterior_humeral_fixation" JSONB,  -- GHJ capsular recon posterior humeral fixation
    "orth_sh_ghj_spanning_fixation" JSONB,  -- GHJ spanning fixation
    "orth_sh_ghj_arthrolysis_techniques" JSONB,  -- GHJ arthrolysis techniques
    "orth_sh_glenoid_articular_cartilage_techniques" JSONB,  -- Glenoid articular cartilage techniques
    "orth_sh_humeral_articular_cartilage_techniques" JSONB,  -- Humeral articular cartilage techniques
    "orth_sh_labrum_treatment_non_instability" JSONB,  -- Labrum treatment non instability
    "orth_sh_labrum_repair_location" TEXT,  -- Labrum repair location
    "orth_sh_labrum_repair_fixation_to_bone" JSONB,  -- Labrum repair fixation to bone
    "orth_sh_ghj_paralabral_cyst_treatment" JSONB,  -- GHJ paralabral cyst treatment
    "orth_sh_capsule_treatment_non_instability" JSONB,  -- Capsule treatment non instability
    "orth_sh_capsulectomy_location" JSONB,  -- Capsulectomy location
    "orth_sh_capsulotomy_location" JSONB,  -- Capsulotomy location
    "orth_sh_capsule_repair_location" JSONB,  -- Capsule repair location
    "orth_sh_ghj_biopsy_tissue" JSONB,  -- GHJ biopsy tissue
    "orth_sh_ghj_reduction_native_joint_type" JSONB,  -- GHJ reduction native joint type
    "orth_sh_ghj_reduction_arthroplasty_type" JSONB,  -- GHJ reduction arthroplasty type
    "orth_sh_ghj_extent_of_implant_removal_nonarthroplasty" VARCHAR(50),  -- GHJ extent of implant removal nonarthroplasty
    "orth_sh_ghj_implants_nonarthroplasty_removed" VARCHAR(500),  -- GHJ implants nonarthroplasty removed
    "orth_sh_ghj_implants_nonarthroplasty_retained" VARCHAR(500),  -- GHJ implants nonarthroplasty retained
    "orth_sh_ghj_extent_of_implant_removal_arthroplasty" VARCHAR(50),  -- GHJ extent of implant removal arthroplasty
    "orth_sh_ghj_implants_arthroplasty_removed" VARCHAR(500),  -- GHJ implants arthroplasty removed
    "orth_sh_ghj_implants_arthroplasty_retained" VARCHAR(500),  -- GHJ implants arthroplasty retained
    "orth_sh_ghj_treatment_of_infection" JSONB,  -- GHJ treatment of infection
    "orth_sh_ghj_treatment_other" TEXT,  -- GHJ treatment other
    "orth_sh_ghj_technique_details" TEXT,  -- GHJ technique details
    "orth_sh_ghj_implant_details" TEXT,  -- GHJ implant details
    "orth_sh_ghj_intraoperative_complications" TEXT,  -- GHJ intraoperative complications
    "orth_sh_supraclavicular_plexus_treatment" JSONB,  -- Supraclavicular plexus treatment
    "orth_sh_supraclavicular_decompression_neurolysis_technique" JSONB,  -- Supraclavicular decompression neurolysis technique
    "orth_sh_supraclavicular_neurotisation_donor" TEXT,  -- Supraclavicular neurotisation donor
    "orth_sh_supraclavicular_neurotisation_recipient" TEXT,  -- Supraclavicular neurotisation recipient
    "orth_sh_supraclavicular_nerve_graft_donor" TEXT,  -- Supraclavicular nerve graft donor
    "orth_sh_supraclavicular_nerve_graft_recipient" TEXT,  -- Supraclavicular nerve graft recipient
    "orth_sh_infraclavicular_plexus_treatment" JSONB,  -- Infraclavicular plexus treatment
    "orth_sh_infraclavicular_decompression_technique" JSONB,  -- Infraclavicular decompression technique
    "orth_sh_infraclavicular_neurotisation_donor" TEXT,  -- Infraclavicular neurotisation donor
    "orth_sh_infraclavicular_neurotisation_recipient" TEXT,  -- Infraclavicular neurotisation recipient
    "orth_sh_infraclavicular_nerve_graft_donor" TEXT,  -- Infraclavicular nerve graft donor
    "orth_sh_infraclavicular_nerve_graft_recipient" TEXT,  -- Infraclavicular nerve graft recipient
    "orth_sh_plexus_other" TEXT,  -- Plexus other
    "orth_sh_plexus_technique_details" TEXT,  -- Plexus technique details
    "orth_sh_plexus_implant_details" TEXT,  -- Plexus implant details
    "orth_sh_plexus_intraoperative_complications" TEXT,  -- Plexus intraoperative complications
    "orth_sh_axillary_nerve_treatment" JSONB,  -- Axillary nerve treatment
    "orth_sh_axillary_nerve_decompression_technique" JSONB,  -- Axillary nerve decompression technique
    "orth_sh_axillary_neurotisation_donor" TEXT,  -- Axillary neurotisation donor
    "orth_sh_axillary_nerve_graft_donor" TEXT,  -- Axillary nerve graft donor
    "orth_sh_long_thoracic_nerve_treatment" JSONB,  -- Long thoracic nerve treatment
    "orth_sh_long_thoracic_decompression_technique" TEXT,  -- Long thoracic decompression technique
    "orth_sh_long_thoracic_neurotisation_donor" TEXT,  -- Long thoracic neurotisation donor
    "orth_sh_long_thoracic_nerve_graft_donor" TEXT,  -- Long thoracic nerve graft donor
    "orth_sh_thoracodorsal_nerve_treatment" JSONB,  -- Thoracodorsal nerve treatment
    "orth_sh_thoracodorsal_decompression_technique" TEXT,  -- Thoracodorsal decompression technique
    "orth_sh_thoracodorsal_neurotisation_donor" TEXT,  -- Thoracodorsal neurotisation donor
    "orth_sh_thoracodorsal_nerve_graft_donor" TEXT,  -- Thoracodorsal nerve graft donor
    "orth_sh_radial_nerve_treatment" JSONB,  -- Radial nerve treatment
    "orth_sh_radial_nerve_decompression_technique" JSONB,  -- Radial nerve decompression technique
    "orth_sh_radial_neurotisation_donor" TEXT,  -- Radial neurotisation donor
    "orth_sh_radial_nerve_graft_donor" TEXT,  -- Radial nerve graft donor
    "orth_sh_musculocutaneous_nerve_treatment" JSONB,  -- Musculocutaneous nerve treatment
    "orth_sh_musculocutaneous_nerve_decompression_technique" JSONB,  -- Musculocutaneous nerve decompression technique
    "orth_sh_musculocutaneous_neurotisation_donor" TEXT,  -- Musculocutaneous neurotisation donor
    "orth_sh_musculocutaneous_nerve_graft_donor" TEXT,  -- Musculocutaneous nerve graft donor
    "orth_sh_suprascapular_nerve_treatment" JSONB,  -- Suprascapular nerve treatment
    "orth_sh_suprascapular_nerve_decompression_technique" JSONB,  -- Suprascapular nerve decompression technique
    "orth_sh_suprascapular_neurotisation_donor" TEXT,  -- Suprascapular neurotisation donor
    "orth_sh_suprascapular_nerve_graft_donor" TEXT,  -- Suprascapular nerve graft donor
    "orth_sh_peripheral_nerves_other" TEXT,  -- Peripheral nerves other
    "orth_sh_peripheral_nerves_technique_details" TEXT,  -- Peripheral nerves technique details
    "orth_sh_peripheral_nerves_implant_details" TEXT,  -- Peripheral nerves implant details
    "orth_sh_peripheral_nerves_intraoperative_complications" TEXT,  -- Peripheral nerves intraoperative complications
    "orth_sh_deltoid_repair_fixation" JSONB,  -- Deltoid repair fixation
    "orth_sh_deltoid_recon_graft" JSONB,  -- Deltoid recon graft
    "orth_sh_deltoid_recon_graft_fixation" JSONB,  -- Deltoid recon graft fixation
    "orth_sh_deltoid_tendon_transfer_donor" JSONB,  -- Deltoid tendon transfer donor
    "orth_sh_deltoid_tendon_transfer_fixation" JSONB,  -- Deltoid tendon transfer fixation
    "orth_sh_deltoid_extent_of_implant_removal" VARCHAR(50),  -- Deltoid extent of implant removal
    "orth_sh_deltoid_implants_removed" TEXT,  -- Deltoid implants removed
    "orth_sh_deltoid_implants_retained" TEXT,  -- Deltoid implants retained
    "orth_sh_deltoid_treatment_of_infection" JSONB,  -- Deltoid treatment of infection
    "orth_sh_deltoid_treatment_other" TEXT,  -- Deltoid treatment other
    "orth_sh_deltoid_technique_details" TEXT,  -- Deltoid technique details
    "orth_sh_deltoid_implant_details" TEXT,  -- Deltoid implant details
    "orth_sh_deltoid_intraoperative_complications" TEXT,  -- Deltoid intraoperative complications
    "orth_sh_pec_minor_repair_fixation" JSONB,  -- Pec minor repair fixation
    "orth_sh_pec_minor_recon_graft" JSONB,  -- Pec minor recon graft
    "orth_sh_pec_minor_recon_graft_fixation" JSONB,  -- Pec minor recon graft fixation
    "orth_sh_pec_minor_extent_of_implant_removal" VARCHAR(50),  -- Pec minor extent of implant removal
    "orth_sh_pec_minor_implants_removed" TEXT,  -- Pec minor implants removed
    "orth_sh_pec_minor_implants_retained" TEXT,  -- Pec minor implants retained
    "orth_sh_pec_minor_treatment_of_infection" JSONB,  -- Pec minor treatment of infection
    "orth_sh_pec_minor_treatment_other" TEXT,  -- Pec minor treatment other
    "orth_sh_pec_minor_technique_details" TEXT,  -- Pec minor technique details
    "orth_sh_pec_minor_implant_details" TEXT,  -- Pec minor implant details
    "orth_sh_pec_minor_intraoperative_complications" TEXT,  -- Pec minor intraoperative complications
    "orth_sh_pec_major_repair_outcome" VARCHAR(50),  -- Pec major repair outcome
    "orth_sh_pec_major_repair_fixation_points" VARCHAR(50),  -- Pec major repair fixation points
    "orth_sh_pec_major_repair_fixation" JSONB,  -- Pec major repair fixation
    "orth_sh_pec_major_recon_graft" JSONB,  -- Pec major recon graft
    "orth_sh_pec_major_recon_fixation_points" VARCHAR(50),  -- Pec major recon fixation points
    "orth_sh_pec_major_recon_graft_fixation" JSONB,  -- Pec major recon graft fixation
    "orth_sh_pec_major_extent_of_implant_removal" VARCHAR(50),  -- Pec major extent of implant removal
    "orth_sh_pec_major_implants_removed" TEXT,  -- Pec major implants removed
    "orth_sh_pec_major_implants_retained" TEXT,  -- Pec major implants retained
    "orth_sh_pec_major_treatment_of_infection" JSONB,  -- Pec major treatment of infection
    "orth_sh_pec_major_treatment_other" TEXT,  -- Pec major treatment other
    "orth_sh_pec_major_technique_details" TEXT,  -- Pec major technique details
    "orth_sh_pec_major_implant_details" TEXT,  -- Pec major implant details
    "orth_sh_pec_major_intraoperative_complications" TEXT,  -- Pec major intraoperative complications
    "orth_sh_lat_dorsi_repair_fixation" JSONB,  -- Lat dorsi repair fixation
    "orth_sh_lat_dorsi_recon_graft" JSONB,  -- Lat dorsi recon graft
    "orth_sh_lat_dorsi_recon_graft_fixation" JSONB,  -- Lat dorsi recon graft fixation
    "orth_sh_lat_dorsi_extent_of_implant_removal" VARCHAR(50),  -- Lat dorsi extent of implant removal
    "orth_sh_lat_dorsi_implants_removed" TEXT,  -- Lat dorsi implants removed
    "orth_sh_lat_dorsi_implants_retained" TEXT,  -- Lat dorsi implants retained
    "orth_sh_lat_dorsi_treatment_of_infection" JSONB,  -- Lat dorsi treatment of infection
    "orth_sh_lat_dorsi_treatment_other" TEXT,  -- Lat dorsi treatment other
    "orth_sh_lat_dorsi_technique_details" TEXT,  -- Lat dorsi technique details
    "orth_sh_lat_dorsi_implant_details" TEXT,  -- Lat dorsi implant details
    "orth_sh_lat_dorsi_intraoperative_complications" TEXT,  -- Lat dorsi intraoperative complications
    "orth_sh_teres_major_repair_fixation" JSONB,  -- Teres major repair fixation
    "orth_sh_teres_major_recon_graft" JSONB,  -- Teres major recon graft
    "orth_sh_teres_major_recon_graft_fixation" JSONB,  -- Teres major recon graft fixation
    "orth_sh_teres_major_extent_of_implant_removal" VARCHAR(50),  -- Teres major extent of implant removal
    "orth_sh_teres_major_implants_removed" TEXT,  -- Teres major implants removed
    "orth_sh_teres_major_implants_retained" TEXT,  -- Teres major implants retained
    "orth_sh_teres_major_treatment_of_infection" JSONB,  -- Teres major treatment of infection
    "orth_sh_teres_major_treatment_other" TEXT,  -- Teres major treatment other
    "orth_sh_teres_major_technique_details" TEXT,  -- Teres major technique details
    "orth_sh_teres_major_implant_details" TEXT,  -- Teres major implant details
    "orth_sh_teres_major_intraoperative_complications" TEXT,  -- Teres major intraoperative complications
    "orth_sh_proximal_humerus_reduction_type" VARCHAR(50),  -- Proximal humerus reduction type
    "orth_sh_proximal_humerus_fixation_type" JSONB,  -- Proximal humerus fixation type
    "orth_sh_proximal_humerus_recon_bone_graft_type" JSONB,  -- Proximal humerus recon bone graft type
    "orth_sh_proximal_humerus_recon_bone_graft_fixation" JSONB,  -- Proximal humerus recon bone graft fixation
    "orth_sh_proximal_humerus_osteotomy_location" VARCHAR(50),  -- Proximal humerus osteotomy location
    "orth_sh_proximal_humerus_osteotomy_type" TEXT,  -- Proximal humerus osteotomy type
    "orth_sh_proximal_humerus_extent_of_implant_removal" VARCHAR(50),  -- Proximal humerus extent of implant removal
    "orth_sh_proximal_humerus_implants_removed" TEXT,  -- Proximal humerus implants removed
    "orth_sh_proximal_humerus_implants_retained" TEXT,  -- Proximal humerus implants retained
    "orth_sh_proximal_humerus_treatment_of_infection" JSONB,  -- Proximal humerus treatment of infection
    "orth_sh_proximal_humerus_treatment_other" TEXT,  -- Proximal humerus treatment other
    "orth_sh_proximal_humerus_technique_details" TEXT,  -- Proximal humerus technique details
    "orth_sh_proximal_humerus_implant_details" TEXT,  -- Proximal humerus implant details
    "orth_sh_proximal_humerus_intraoperative_complications" TEXT,  -- Proximal humerus intraoperative complications
    "orth_sh_humerus_diaphysis_reduction_type" VARCHAR(50),  -- Humerus diaphysis reduction type
    "orth_sh_humerus_diaphysis_fixation_type" JSONB,  -- Humerus diaphysis fixation type
    "orth_sh_humerus_diaphysis_recon_bone_graft_type" JSONB,  -- Humerus diaphysis recon bone graft type
    "orth_sh_humerus_diaphysis_recon_bone_graft_fixation" JSONB,  -- Humerus diaphysis recon bone graft fixation
    "orth_sh_humerus_diaphysis_osteotomy_location" TEXT,  -- Humerus diaphysis osteotomy location
    "orth_sh_humerus_diaphysis_osteotomy_type" TEXT,  -- Humerus diaphysis osteotomy type
    "orth_sh_humerus_diaphysis_extent_of_implant_removal" VARCHAR(50),  -- Humerus diaphysis extent of implant removal
    "orth_sh_humerus_diaphysis_implants_removed" TEXT,  -- Humerus diaphysis implants removed
    "orth_sh_humerus_diaphysis_implants_retained" TEXT,  -- Humerus diaphysis implants retained
    "orth_sh_humerus_diaphysis_treatment_of_infection" JSONB,  -- Humerus diaphysis treatment of infection
    "orth_sh_humerus_diaphysis_treatment_other" TEXT,  -- Humerus diaphysis treatment other
    "orth_sh_humerus_diaphysis_technique_details" TEXT,  -- Humerus diaphysis technique details
    "orth_sh_humerus_diaphysis_implant_details" TEXT,  -- Humerus diaphysis implant details
    "orth_sh_humerus_diaphysis_intraoperative_complications" TEXT,  -- Humerus diaphysis intraoperative complications
    "orth_sh_fasciotomy_treatment_location" TEXT,  -- Fasciotomy treatment location
    "orth_sh_fasciectomy_treatment_location" TEXT,  -- Fasciectomy treatment location
    "orth_sh_fascia_treatment_of_infection" JSONB,  -- Fascia treatment of infection
    "orth_sh_fascia_other" TEXT,  -- Fascia other
    "orth_sh_fascia_technique_details" TEXT,  -- Fascia technique details
    "orth_sh_fascia_implant_details" TEXT,  -- Fascia implant details
    "orth_sh_fascia_treatment_intraoperative_complications" TEXT,  -- Fascia treatment intraoperative complications
    "orth_sh_sling" VARCHAR(50),  -- Sling
    "orth_sh_proms_trigger" VARCHAR(50),  -- PROMS trigger
    "orth_sh_observations" JSONB,  -- Observations
    "orth_sh_analgesia" JSONB,  -- Analgesia
    "orth_sh_dvt_prophyllaxis_duration" VARCHAR(50),  -- DVT prophyllaxis duration
    "orth_sh_antibiotics" JSONB,  -- Antibiotics
    "orth_sh_antibiotic_duration" VARCHAR(50),  -- Antibiotic duration
    "orth_sh_imaging" JSONB,  -- Imaging
    "orth_sh_imaging_other" TEXT,  -- Imaging other
    "orth_sh_blood_tests" JSONB,  -- Blood tests
    "orth_sh_drains" JSONB,  -- Drains
    "orth_sh_dressings" JSONB,  -- Dressings
    "orth_sh_discharge" JSONB,  -- Discharge
    "orth_sh_rehabilitation_early" JSONB,  -- Rehabilitation early
    "orth_sh_rehabilitation_ongoing" JSONB,  -- Rehabilitation ongoing
    "orth_sh_post_op_instructions_other" TEXT,  -- Post op instructions other
    "orth_sh_follow_up_interval" VARCHAR(50),  -- Follow up interval
    "orth_sh_investigations_required_prior_to_next_appointment" JSONB,  -- Investigations required prior to next appointment
    "orth_sh_further_investigations_other" TEXT,  -- Further investigations other
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_general_part_4_part_4
CREATE INDEX IF NOT EXISTS idx_shoulder_general_part_4_part_4_encounter ON shoulder_general_part_4_part_4(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_general_part_4_part_4_created ON shoulder_general_part_4_part_4(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_general_part_4_part_4
    ADD CONSTRAINT fk_shoulder_general_part_4_part_4_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: demographics_part_5_part_5
-- Generated: 2025-11-28T20:28:38.880389
-- Fields: 178

CREATE TABLE IF NOT EXISTS demographics_part_5_part_5 (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_elbow_strength_12mo" DECIMAL,  -- Give the overall strength of your affected/operated elbow a 
    "dem_stability_sane_12mo" DECIMAL,  -- Give the overall stability of your affected/operated elbow a
    "dem_stability_sane_to_mepi_12mo" DECIMAL,  -- Stability SANE to MEPI
    "dem_pree_total_12mo" DECIMAL,  -- PREE (Total)
    "dem_mepi_total_12mo" DECIMAL,  -- MEPI (Total)
    "dem_sev_12mo" DECIMAL,  -- Give your affected/operated elbow an overall mark out of 100
    "dem_elbow_extension_12mo" VARCHAR(500),  -- Elbow Extension
    "dem_pronation_12mo" VARCHAR(500),  -- Pronation
    "dem_supination_12mo" VARCHAR(500),  -- Supination
    "dem_pree1_24mo" DECIMAL,  -- How much pain in your ELBOW do you have when it is at its wo
    "dem_pree2_24mo" DECIMAL,  -- How much pain in your ELBOW do you have at rest?
    "dem_pree3_24mo" DECIMAL,  -- How much pain in your ELBOW do you have lifting a heavy obje
    "dem_pree4_24mo" DECIMAL,  -- How much pain in your ELBOW do you have when doing a task wi
    "dem_pree5_24mo" DECIMAL,  -- How often do you have pain in your elbow?
    "dem_mepimesss6_24mo" VARCHAR(50),  -- Rate the OVERALL pain in your elbow
    "dem_pree7_24mo" DECIMAL,  -- Can you comb hair?
    "dem_pree7_mepi_24mo" DECIMAL,  -- PREE7 to MEPI
    "dem_pree8_24mo" DECIMAL,  -- Can you eat with a fork or spoon?
    "dem_pree8_mepi_24mo" DECIMAL,  -- PREE8 to MEPI
    "dem_pree9_24mo" DECIMAL,  -- Can you pull a heavy object?
    "dem_pree10_24mo" DECIMAL,  -- Can you rise from a chair pushing with arm?
    "dem_pree11_24mo" DECIMAL,  -- Can you carry a 4kg object with your arm at your side?
    "dem_pree12_24mo" DECIMAL,  -- Can you throw a ball?
    "dem_pree13_24mo" DECIMAL,  -- Can you use a telephone?
    "dem_pree14_24mo" DECIMAL,  -- Can you do up buttons on a shirt?
    "dem_pree14_mepi_24mo" DECIMAL,  -- PREE14 to MEPI
    "dem_pree15_24mo" DECIMAL,  -- Can you wash your opposite armpit?
    "dem_pree16_24mo" DECIMAL,  -- Can you tie your shoelaces?
    "dem_pree16_mepi_24mo" DECIMAL,  -- PREE16 to MEPI
    "dem_pree17_24mo" DECIMAL,  -- Can you turn a doorknob and open a door?
    "dem_pree18_24mo" DECIMAL,  -- Can you do personal care activities (washing, dressing)?
    "dem_pree18_mepi_24mo" DECIMAL,  -- PREE18 to MEPI
    "dem_pree19_24mo" DECIMAL,  -- Can you you do household chores (cleaning, maintenance)?
    "dem_pree20_24mo" DECIMAL,  -- How much difficulty do you have with work?
    "dem_pree21_24mo" DECIMAL,  -- How much difficulty do you have with recreational activities
    "dem_pree22_24mo" VARCHAR(50),  -- Describe your current work
    "dem_pree23_24mo" VARCHAR(50),  -- Describe your current sports/activities
    "dem_elbow_flexex_24mo" DECIMAL,  -- Give the range of motion of FLEXION-EXTENSION (bending and s
    "dem_elbow_flexex_to_mepi_step1_24mo" DECIMAL,  -- Elbow FlexEx to MEPI Step1
    "dem_elbow_flexex_to_mepi_step2_24mo" DECIMAL,  -- Elbow FlexEx to MEPI Step1
    "dem_elbow_pronsup_24mo" DECIMAL,  -- Give the range of motion of PRONATION-SUPINATION (turning yo
    "dem_elbow_strength_24mo" DECIMAL,  -- Give the overall strength of your affected/operated elbow a 
    "dem_stability_sane_24mo" DECIMAL,  -- Give the overall stability of your affected/operated elbow a
    "dem_stability_sane_to_mepi_24mo" DECIMAL,  -- Stability SANE to MEPI
    "dem_pree_total_24mo" DECIMAL,  -- PREE (Total)
    "dem_mepi_total_24mo" DECIMAL,  -- MEPI (Total)
    "dem_sev_24mo" DECIMAL,  -- Give your affected/operated elbow an overall mark out of 100
    "dem_elbow_extension_24mo" VARCHAR(500),  -- Elbow Extension
    "dem_pronation_24mo" VARCHAR(500),  -- Pronation
    "dem_supination_24mo" VARCHAR(500),  -- Supination
    "dem_pree1_36mo" DECIMAL,  -- How much pain in your ELBOW do you have when it is at its wo
    "dem_pree2_36mo" DECIMAL,  -- How much pain in your ELBOW do you have at rest?
    "dem_pree3_36mo" DECIMAL,  -- How much pain in your ELBOW do you have lifting a heavy obje
    "dem_pree4_36mo" DECIMAL,  -- How much pain in your ELBOW do you have when doing a task wi
    "dem_pree5_36mo" DECIMAL,  -- How often do you have pain in your elbow?
    "dem_mepimesss6_36mo" VARCHAR(50),  -- Rate the OVERALL pain in your elbow
    "dem_pree7_36mo" DECIMAL,  -- Can you comb hair?
    "dem_pree7_mepi_36mo" DECIMAL,  -- PREE7 to MEPI
    "dem_pree8_36mo" DECIMAL,  -- Can you eat with a fork or spoon?
    "dem_pree8_mepi_36mo" DECIMAL,  -- PREE8 to MEPI
    "dem_pree9_36mo" DECIMAL,  -- Can you pull a heavy object?
    "dem_pree10_36mo" DECIMAL,  -- Can you rise from a chair pushing with arm?
    "dem_pree11_36mo" DECIMAL,  -- Can you carry a 4kg object with your arm at your side?
    "dem_pree12_36mo" DECIMAL,  -- Can you throw a ball?
    "dem_pree13_36mo" DECIMAL,  -- Can you use a telephone?
    "dem_pree14_36mo" DECIMAL,  -- Can you do up buttons on a shirt?
    "dem_pree14_mepi_36mo" DECIMAL,  -- PREE14 to MEPI
    "dem_pree15_36mo" DECIMAL,  -- Can you wash your opposite armpit?
    "dem_pree16_36mo" DECIMAL,  -- Can you tie your shoelaces?
    "dem_pree16_mepi_36mo" DECIMAL,  -- PREE16 to MEPI
    "dem_pree17_36mo" DECIMAL,  -- Can you turn a doorknob and open a door?
    "dem_pree18_36mo" DECIMAL,  -- Can you do personal care activities (washing, dressing)?
    "dem_pree18_mepi_36mo" DECIMAL,  -- PREE18 to MEPI
    "dem_pree19_36mo" DECIMAL,  -- Can you you do household chores (cleaning, maintenance)?
    "dem_pree20_36mo" DECIMAL,  -- How much difficulty do you have with work?
    "dem_pree21_36mo" DECIMAL,  -- How much difficulty do you have with recreational activities
    "dem_pree22_36mo" VARCHAR(50),  -- Describe your current work
    "dem_pree23_36mo" VARCHAR(50),  -- Describe your current sports/activities
    "dem_elbow_flexex_36mo" DECIMAL,  -- Give the range of motion of FLEXION-EXTENSION (bending and s
    "dem_elbow_flexex_to_mepi_step1_36mo" DECIMAL,  -- Elbow FlexEx to MEPI Step1
    "dem_elbow_flexex_to_mepi_step2_36mo" DECIMAL,  -- Elbow FlexEx to MEPI Step1
    "dem_elbow_pronsup_36mo" DECIMAL,  -- Give the range of motion of PRONATION-SUPINATION (turning yo
    "dem_elbow_strength_36mo" DECIMAL,  -- Give the overall strength of your affected/operated elbow a 
    "dem_stability_sane_36mo" DECIMAL,  -- Give the overall stability of your affected/operated elbow a
    "dem_stability_sane_to_mepi_36mo" DECIMAL,  -- Stability SANE to MEPI
    "dem_pree_total_36mo" DECIMAL,  -- PREE (Total)
    "dem_mepi_total_36mo" DECIMAL,  -- MEPI (Total)
    "dem_sev_36mo" DECIMAL,  -- Give your affected/operated elbow an overall mark out of 100
    "dem_elbow_extension_36mo" VARCHAR(500),  -- Elbow Extension
    "dem_pronation_36mo" VARCHAR(500),  -- Pronation
    "dem_supination_36mo" VARCHAR(500),  -- Supination
    "dem_pree1_5y" DECIMAL,  -- How much pain in your ELBOW do you have when it is at its wo
    "dem_pree2_5y" DECIMAL,  -- How much pain in your ELBOW do you have at rest?
    "dem_pree3_5y" DECIMAL,  -- How much pain in your ELBOW do you have lifting a heavy obje
    "dem_pree4_5y" DECIMAL,  -- How much pain in your ELBOW do you have when doing a task wi
    "dem_pree5_5y" DECIMAL,  -- How often do you have pain in your elbow?
    "dem_mepimesss6_5y" VARCHAR(50),  -- Rate the OVERALL pain in your elbow
    "dem_pree7_5y" DECIMAL,  -- Can you comb hair?
    "dem_pree7_mepi_5y" DECIMAL,  -- PREE7 to MEPI
    "dem_pree8_5y" DECIMAL,  -- Can you eat with a fork or spoon?
    "dem_pree8_mepi_5y" DECIMAL,  -- PREE8 to MEPI
    "dem_pree9_5y" DECIMAL,  -- Can you pull a heavy object?
    "dem_pree10_5y" DECIMAL,  -- Can you rise from a chair pushing with arm?
    "dem_pree11_5y" DECIMAL,  -- Can you carry a 4kg object with your arm at your side?
    "dem_pree12_5y" DECIMAL,  -- Can you throw a ball?
    "dem_pree13_5y" DECIMAL,  -- Can you use a telephone?
    "dem_pree14_5y" DECIMAL,  -- Can you do up buttons on a shirt?
    "dem_pree14_mepi_5y" DECIMAL,  -- PREE14 to MEPI
    "dem_pree15_5y" DECIMAL,  -- Can you wash your opposite armpit?
    "dem_pree16_5y" DECIMAL,  -- Can you tie your shoelaces?
    "dem_pree16_mepi_5y" DECIMAL,  -- PREE16 to MEPI
    "dem_pree17_5y" DECIMAL,  -- Can you turn a doorknob and open a door?
    "dem_pree18_5y" DECIMAL,  -- Can you do personal care activities (washing, dressing)?
    "dem_pree18_mepi_5y" DECIMAL,  -- PREE18 to MEPI
    "dem_pree19_5y" DECIMAL,  -- Can you you do household chores (cleaning, maintenance)?
    "dem_pree20_5y" DECIMAL,  -- How much difficulty do you have with work?
    "dem_pree21_5y" DECIMAL,  -- How much difficulty do you have with recreational activities
    "dem_pree22_5y" VARCHAR(50),  -- Describe your current work
    "dem_pree23_5y" VARCHAR(50),  -- Describe your current sports/activities
    "dem_elbow_flexex_5y" DECIMAL,  -- Give the range of motion of FLEXION-EXTENSION (bending and s
    "dem_elbow_flexex_to_mepi_step1_5y" DECIMAL,  -- Elbow FlexEx to MEPI Step1
    "dem_elbow_flexex_to_mepi_step2_5y" DECIMAL,  -- Elbow FlexEx to MEPI Step1
    "dem_elbow_pronsup_5y" DECIMAL,  -- Give the range of motion of PRONATION-SUPINATION (turning yo
    "dem_elbow_strength_5y" DECIMAL,  -- Give the overall strength of your affected/operated elbow a 
    "dem_stability_sane_5y" DECIMAL,  -- Give the overall stability of your affected/operated elbow a
    "dem_stability_sane_to_mepi_5y" DECIMAL,  -- Stability SANE to MEPI
    "dem_pree_total_5y" DECIMAL,  -- PREE (Total)
    "dem_mepi_total_5y" DECIMAL,  -- MEPI (Total)
    "dem_sev_5y" DECIMAL,  -- Give your affected/operated elbow an overall mark out of 100
    "dem_elbow_extension_5y" VARCHAR(500),  -- Elbow Extension
    "dem_pronation_5y" VARCHAR(500),  -- Pronation
    "dem_supination_5y" VARCHAR(500),  -- Supination
    "dem_pree1_10y" DECIMAL,  -- How much pain in your ELBOW do you have when it is at its wo
    "dem_pree2_10y" DECIMAL,  -- How much pain in your ELBOW do you have at rest?
    "dem_pree3_10y" DECIMAL,  -- How much pain in your ELBOW do you have lifting a heavy obje
    "dem_pree4_10y" DECIMAL,  -- How much pain in your ELBOW do you have when doing a task wi
    "dem_pree5_10y" DECIMAL,  -- How often do you have pain in your elbow?
    "dem_mepimesss6_10y" VARCHAR(50),  -- Rate the OVERALL pain in your elbow
    "dem_pree7_10y" DECIMAL,  -- Can you comb hair?
    "dem_pree7_mepi_10y" DECIMAL,  -- PREE7 to MEPI
    "dem_pree8_10y" DECIMAL,  -- Can you eat with a fork or spoon?
    "dem_pree8_mepi_10y" DECIMAL,  -- PREE8 to MEPI
    "dem_pree9_10y" DECIMAL,  -- Can you pull a heavy object?
    "dem_pree10_10y" DECIMAL,  -- Can you rise from a chair pushing with arm?
    "dem_pree11_10y" DECIMAL,  -- Can you carry a 4kg object with your arm at your side?
    "dem_pree12_10y" DECIMAL,  -- Can you throw a ball?
    "dem_pree13_10y" DECIMAL,  -- Can you use a telephone?
    "dem_pree14_10y" DECIMAL,  -- Can you do up buttons on a shirt?
    "dem_pree14_mepi_10y" DECIMAL,  -- PREE14 to MEPI
    "dem_pree15_10y" DECIMAL,  -- Can you wash your opposite armpit?
    "dem_pree16_10y" DECIMAL,  -- Can you tie your shoelaces?
    "dem_pree16_mepi_10y" DECIMAL,  -- PREE16 to MEPI
    "dem_pree17_10y" DECIMAL,  -- Can you turn a doorknob and open a door?
    "dem_pree18_10y" DECIMAL,  -- Can you do personal care activities (washing, dressing)?
    "dem_pree18_mepi_10y" DECIMAL,  -- PREE18 to MEPI
    "dem_pree19_10y" DECIMAL,  -- Can you you do household chores (cleaning, maintenance)?
    "dem_pree20_10y" DECIMAL,  -- How much difficulty do you have with work?
    "dem_pree21_10y" DECIMAL,  -- How much difficulty do you have with recreational activities
    "dem_pree22_10y" VARCHAR(50),  -- Describe your current work
    "dem_pree23_10y" VARCHAR(50),  -- Describe your current sports/activities
    "dem_elbow_flexex_10y" DECIMAL,  -- Give the range of motion of FLEXION-EXTENSION (bending and s
    "dem_elbow_flexex_to_mepi_step1_10y" DECIMAL,  -- Elbow FlexEx to MEPI Step1
    "dem_elbow_flexex_to_mepi_step2_10y" DECIMAL,  -- Elbow FlexEx to MEPI Step1
    "dem_elbow_pronsup_10y" DECIMAL,  -- Give the range of motion of PRONATION-SUPINATION (turning yo
    "dem_elbow_strength_10y" DECIMAL,  -- Give the overall strength of your affected/operated elbow a 
    "dem_stability_sane_10y" DECIMAL,  -- Give the overall stability of your affected/operated elbow a
    "dem_stability_sane_to_mepi_10y" DECIMAL,  -- Stability SANE to MEPI
    "dem_pree_total_10y" DECIMAL,  -- PREE (Total)
    "dem_mepi_total_10y" DECIMAL,  -- MEPI (Total)
    "dem_sev_10y" DECIMAL,  -- Give your affected/operated elbow an overall mark out of 100
    "dem_elbow_extension_10y" VARCHAR(500),  -- Elbow Extension
    "dem_pronation_10y" VARCHAR(500),  -- Pronation
    "dem_supination_10y" VARCHAR(500),  -- Supination
    "dem_ases_chart" TEXT,  -- ASES Chart
    "dem_masss_chart" TEXT,  -- MASSS Chart
    "dem_rowe_chart" TEXT,  -- Rowe Chart
    "dem_pree_chart" TEXT,  -- PREE Chart
    "dem_mepi_chart" TEXT,  -- MEPI Chart
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for demographics_part_5_part_5
CREATE INDEX IF NOT EXISTS idx_demographics_part_5_part_5_encounter ON demographics_part_5_part_5(encounter_id);
CREATE INDEX IF NOT EXISTS idx_demographics_part_5_part_5_created ON demographics_part_5_part_5(created_at);

-- Foreign key constraint
ALTER TABLE demographics_part_5_part_5
    ADD CONSTRAINT fk_demographics_part_5_part_5_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


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


-- Table: shoulder_encounter_details
-- Generated: 2025-11-28T20:28:38.897711
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_encounter_details (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_encounter_date" DATE,  -- Encounter date
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_encounter_details
CREATE INDEX IF NOT EXISTS idx_shoulder_encounter_details_encounter ON shoulder_encounter_details(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_encounter_details_created ON shoulder_encounter_details(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_encounter_details
    ADD CONSTRAINT fk_shoulder_encounter_details_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_diagnosis
-- Generated: 2025-11-28T20:28:38.910952
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_diagnosis (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_diag_distal_humerus_diagnosis" JSONB,  -- Distal humerus diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_diagnosis
CREATE INDEX IF NOT EXISTS idx_elbow_diagnosis_encounter ON elbow_diagnosis(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_diagnosis_created ON elbow_diagnosis(created_at);

-- Foreign key constraint
ALTER TABLE elbow_diagnosis
    ADD CONSTRAINT fk_elbow_diagnosis_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_assessed_rom_please_leave_for_surgeons_to_fill_onl
-- Generated: 2025-11-28T20:28:38.881890
-- Fields: 8

CREATE TABLE IF NOT EXISTS general_assessed_rom_please_leave_for_surgeons_to_fill_onl (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_shoulder_flexion" VARCHAR(500),  -- Shoulder Flexion
    "dem_shoulder_flexion_3mo" VARCHAR(500),  -- Shoulder Flexion
    "dem_shoulder_flexion_6mo" VARCHAR(500),  -- Shoulder Flexion
    "dem_shoulder_flexion_12mo" VARCHAR(500),  -- Shoulder Flexion
    "dem_shoulder_flexion_24mo" VARCHAR(500),  -- Shoulder Flexion
    "dem_shoulder_flexion_36mo" VARCHAR(500),  -- Shoulder Flexion
    "dem_shoulder_flexion_5y" VARCHAR(500),  -- Shoulder Flexion
    "dem_shoulder_flexion_10y" VARCHAR(500),  -- Shoulder Flexion
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_assessed_rom_please_leave_for_surgeons_to_fill_onl
CREATE INDEX IF NOT EXISTS idx_general_assessed_rom_please_leave_for_surgeons_to_fill_onl_encounter ON general_assessed_rom_please_leave_for_surgeons_to_fill_onl(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_assessed_rom_please_leave_for_surgeons_to_fill_onl_created ON general_assessed_rom_please_leave_for_surgeons_to_fill_onl(created_at);

-- Foreign key constraint
ALTER TABLE general_assessed_rom_please_leave_for_surgeons_to_fill_onl
    ADD CONSTRAINT fk_general_assessed_rom_please_leave_for_surgeons_to_fill_onl_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_diagnosis
-- Generated: 2025-11-28T20:28:38.897864
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_diagnosis (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_diag_affected_side" JSONB,  -- Affected side
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_diagnosis
CREATE INDEX IF NOT EXISTS idx_shoulder_diagnosis_encounter ON shoulder_diagnosis(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_diagnosis_created ON shoulder_diagnosis(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_diagnosis
    ADD CONSTRAINT fk_shoulder_diagnosis_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


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


-- Table: general_assessed_rom
-- Generated: 2025-11-28T20:28:38.882190
-- Fields: 8

CREATE TABLE IF NOT EXISTS general_assessed_rom (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_elbow_flexion" VARCHAR(500),  -- Elbow Flexion
    "dem_elbow_flexion_3mo" VARCHAR(500),  -- Elbow Flexion
    "dem_elbow_flexion_6mo" VARCHAR(500),  -- Elbow Flexion
    "dem_elbow_flexion_12mo" VARCHAR(500),  -- Elbow Flexion
    "dem_elbow_flexion_24mo" VARCHAR(500),  -- Elbow Flexion
    "dem_elbow_flexion_36mo" VARCHAR(500),  -- Elbow Flexion
    "dem_elbow_flexion_5y" VARCHAR(500),  -- Elbow Flexion
    "dem_elbow_flexion_10y" VARCHAR(500),  -- Elbow Flexion
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_assessed_rom
CREATE INDEX IF NOT EXISTS idx_general_assessed_rom_encounter ON general_assessed_rom(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_assessed_rom_created ON general_assessed_rom(created_at);

-- Foreign key constraint
ALTER TABLE general_assessed_rom
    ADD CONSTRAINT fk_general_assessed_rom_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


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


-- Table: general_distal_humerus
-- Generated: 2025-11-28T20:28:38.882453
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_distal_humerus (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_distal_humerus_dx_1" JSONB,  -- DISTAL HUMERUS Diagnosis / pathology
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_distal_humerus
CREATE INDEX IF NOT EXISTS idx_general_distal_humerus_encounter ON general_distal_humerus(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_distal_humerus_created ON general_distal_humerus(created_at);

-- Foreign key constraint
ALTER TABLE general_distal_humerus
    ADD CONSTRAINT fk_general_distal_humerus_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_diagnosis
-- Generated: 2025-11-28T20:28:38.898150
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_diagnosis (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_diag_scapulothoracic_articulation_diagnosis" JSONB,  -- Scapulothoracic articulation diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_diagnosis
CREATE INDEX IF NOT EXISTS idx_shoulder_diagnosis_encounter ON shoulder_diagnosis(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_diagnosis_created ON shoulder_diagnosis(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_diagnosis
    ADD CONSTRAINT fk_shoulder_diagnosis_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_pruj
-- Generated: 2025-11-28T20:28:38.911308
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_pruj (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_pruj_diagnosis" JSONB,  -- PRUJ diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_pruj
CREATE INDEX IF NOT EXISTS idx_elbow_pruj_encounter ON elbow_pruj(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_pruj_created ON elbow_pruj(created_at);

-- Foreign key constraint
ALTER TABLE elbow_pruj
    ADD CONSTRAINT fk_elbow_pruj_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_ulnohumeral_radiocapitellar_articulations
-- Generated: 2025-11-28T20:28:38.882641
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_ulnohumeral_radiocapitellar_articulations (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_ulnohumeral_radiocapitellar_or_ulnoradial_forearm_radiocapi" JSONB,  -- Ulnohumeral & Radiocapitellar Articulations Diagnosis / path
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_ulnohumeral_radiocapitellar_articulations
CREATE INDEX IF NOT EXISTS idx_general_ulnohumeral_radiocapitellar_articulations_encounter ON general_ulnohumeral_radiocapitellar_articulations(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_ulnohumeral_radiocapitellar_articulations_created ON general_ulnohumeral_radiocapitellar_articulations(created_at);

-- Foreign key constraint
ALTER TABLE general_ulnohumeral_radiocapitellar_articulations
    ADD CONSTRAINT fk_general_ulnohumeral_radiocapitellar_articulations_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_sternum
-- Generated: 2025-11-28T20:28:38.898340
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_sternum (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_sternum_diagnosis" JSONB,  -- Sternum diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_sternum
CREATE INDEX IF NOT EXISTS idx_shoulder_sternum_encounter ON shoulder_sternum(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_sternum_created ON shoulder_sternum(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_sternum
    ADD CONSTRAINT fk_shoulder_sternum_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_should_below_be_pruj_instability_
-- Generated: 2025-11-28T20:28:38.911441
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_should_below_be_pruj_instability_ (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_pruj_stability_instability" JSONB,  -- PRUJ stability instability
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_should_below_be_pruj_instability_
CREATE INDEX IF NOT EXISTS idx_elbow_should_below_be_pruj_instability__encounter ON elbow_should_below_be_pruj_instability_(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_should_below_be_pruj_instability__created ON elbow_should_below_be_pruj_instability_(created_at);

-- Foreign key constraint
ALTER TABLE elbow_should_below_be_pruj_instability_
    ADD CONSTRAINT fk_elbow_should_below_be_pruj_instability__encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_forearm_articulation_and_or_pruj_and_or_druj
-- Generated: 2025-11-28T20:28:38.882793
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_forearm_articulation_and_or_pruj_and_or_druj (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_forearm_articulation_and_or_pruj_and_or_druj_dx" JSONB,  -- Forearm Articulation and/or PRUJ and/or DRUJ diagnosis / pat
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_forearm_articulation_and_or_pruj_and_or_druj
CREATE INDEX IF NOT EXISTS idx_general_forearm_articulation_and_or_pruj_and_or_druj_encounter ON general_forearm_articulation_and_or_pruj_and_or_druj(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_forearm_articulation_and_or_pruj_and_or_druj_created ON general_forearm_articulation_and_or_pruj_and_or_druj(created_at);

-- Foreign key constraint
ALTER TABLE general_forearm_articulation_and_or_pruj_and_or_druj
    ADD CONSTRAINT fk_general_forearm_articulation_and_or_pruj_and_or_druj_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_manubriosternal_joint
-- Generated: 2025-11-28T20:28:38.898584
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_manubriosternal_joint (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_manubriosternal_joint_diagnosis" JSONB,  -- Manubriosternal joint diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_manubriosternal_joint
CREATE INDEX IF NOT EXISTS idx_shoulder_manubriosternal_joint_encounter ON shoulder_manubriosternal_joint(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_manubriosternal_joint_created ON shoulder_manubriosternal_joint(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_manubriosternal_joint
    ADD CONSTRAINT fk_shoulder_manubriosternal_joint_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


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


-- Table: general_distal_biceps_tendon
-- Generated: 2025-11-28T20:28:38.882987
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_distal_biceps_tendon (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_distal_biceps_tendon_diagnosis" JSONB,  -- DISTAL BICEPS TENDON DIAGNOSIS
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_distal_biceps_tendon
CREATE INDEX IF NOT EXISTS idx_general_distal_biceps_tendon_encounter ON general_distal_biceps_tendon(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_distal_biceps_tendon_created ON general_distal_biceps_tendon(created_at);

-- Foreign key constraint
ALTER TABLE general_distal_biceps_tendon
    ADD CONSTRAINT fk_general_distal_biceps_tendon_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_sternoclavicular_joint
-- Generated: 2025-11-28T20:28:38.898716
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_sternoclavicular_joint (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_sternoclavicular_joint_diagnosis" JSONB,  -- Sternoclavicular joint diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_sternoclavicular_joint
CREATE INDEX IF NOT EXISTS idx_shoulder_sternoclavicular_joint_encounter ON shoulder_sternoclavicular_joint(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_sternoclavicular_joint_created ON shoulder_sternoclavicular_joint(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_sternoclavicular_joint
    ADD CONSTRAINT fk_shoulder_sternoclavicular_joint_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_druj
-- Generated: 2025-11-28T20:28:38.912250
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_druj (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_druj_diagnosis" JSONB,  -- DRUJ diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_druj
CREATE INDEX IF NOT EXISTS idx_elbow_druj_encounter ON elbow_druj(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_druj_created ON elbow_druj(created_at);

-- Foreign key constraint
ALTER TABLE elbow_druj
    ADD CONSTRAINT fk_elbow_druj_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_distal_triceps_tendon
-- Generated: 2025-11-28T20:28:38.883108
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_distal_triceps_tendon (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_distal_triceps_tendon_diagnosis" JSONB,  -- DISTAL TRICEPS TENDON DIAGNOSIS
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_distal_triceps_tendon
CREATE INDEX IF NOT EXISTS idx_general_distal_triceps_tendon_encounter ON general_distal_triceps_tendon(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_distal_triceps_tendon_created ON general_distal_triceps_tendon(created_at);

-- Foreign key constraint
ALTER TABLE general_distal_triceps_tendon
    ADD CONSTRAINT fk_general_distal_triceps_tendon_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_scapula
-- Generated: 2025-11-28T20:28:38.898834
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_scapula (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_scapula_diagnosis" JSONB,  -- Scapula Diagnosis
    "orth_sh_scapula_treatment_location" JSONB,  -- Scapula treatment location
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_scapula
CREATE INDEX IF NOT EXISTS idx_shoulder_scapula_encounter ON shoulder_scapula(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_scapula_created ON shoulder_scapula(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_scapula
    ADD CONSTRAINT fk_shoulder_scapula_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_forearm
-- Generated: 2025-11-28T20:28:38.912478
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_forearm (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_forearm_diagnosis" JSONB,  -- Forearm diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_forearm
CREATE INDEX IF NOT EXISTS idx_elbow_forearm_encounter ON elbow_forearm(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_forearm_created ON elbow_forearm(created_at);

-- Foreign key constraint
ALTER TABLE elbow_forearm
    ADD CONSTRAINT fk_elbow_forearm_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_common_extensor_origin
-- Generated: 2025-11-28T20:28:38.883220
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_common_extensor_origin (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_common_extensor_origin_diagnosis" JSONB,  -- COMMON EXTENSOR ORIGIN DIAGNOSIS
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_common_extensor_origin
CREATE INDEX IF NOT EXISTS idx_general_common_extensor_origin_encounter ON general_common_extensor_origin(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_common_extensor_origin_created ON general_common_extensor_origin(created_at);

-- Foreign key constraint
ALTER TABLE general_common_extensor_origin
    ADD CONSTRAINT fk_general_common_extensor_origin_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_clavicle
-- Generated: 2025-11-28T20:28:38.898963
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_clavicle (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_clavicle_diagnosis" JSONB,  -- Clavicle Diagnosis
    "orth_sh_clavicle_treatment" JSONB,  -- Clavicle treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_clavicle
CREATE INDEX IF NOT EXISTS idx_shoulder_clavicle_encounter ON shoulder_clavicle(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_clavicle_created ON shoulder_clavicle(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_clavicle
    ADD CONSTRAINT fk_shoulder_clavicle_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_diagnosis
-- Generated: 2025-11-28T20:28:38.912717
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_diagnosis (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_diag_forearm_stability_instability" JSONB,  -- Forearm stability instability
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_diagnosis
CREATE INDEX IF NOT EXISTS idx_elbow_diagnosis_encounter ON elbow_diagnosis(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_diagnosis_created ON elbow_diagnosis(created_at);

-- Foreign key constraint
ALTER TABLE elbow_diagnosis
    ADD CONSTRAINT fk_elbow_diagnosis_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_common_flexor_origin
-- Generated: 2025-11-28T20:28:38.883336
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_common_flexor_origin (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_common_flexor_origin_diagnosis" JSONB,  -- COMMON FLEXOR ORIGIN DIAGNOSIS
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_common_flexor_origin
CREATE INDEX IF NOT EXISTS idx_general_common_flexor_origin_encounter ON general_common_flexor_origin(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_common_flexor_origin_created ON general_common_flexor_origin(created_at);

-- Foreign key constraint
ALTER TABLE general_common_flexor_origin
    ADD CONSTRAINT fk_general_common_flexor_origin_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_acj
-- Generated: 2025-11-28T20:28:38.899080
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_acj (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_acj_diagnosis" JSONB,  -- ACJ diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_acj
CREATE INDEX IF NOT EXISTS idx_shoulder_acj_encounter ON shoulder_acj(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_acj_created ON shoulder_acj(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_acj
    ADD CONSTRAINT fk_shoulder_acj_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


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


-- Table: general_olecranon
-- Generated: 2025-11-28T20:28:38.883586
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_olecranon (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_olecranon_dx_1" JSONB,  -- OLECRANON Diagnosis / pathology
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_olecranon
CREATE INDEX IF NOT EXISTS idx_general_olecranon_encounter ON general_olecranon(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_olecranon_created ON general_olecranon(created_at);

-- Foreign key constraint
ALTER TABLE general_olecranon
    ADD CONSTRAINT fk_general_olecranon_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_subacromial_subcoracoid_subdeltoid
-- Generated: 2025-11-28T20:28:38.899248
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_subacromial_subcoracoid_subdeltoid (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_subacromial_subcoracoid_subdeltoid_space_diagnosis" JSONB,  -- Subacromial subcoracoid subdeltoid space diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_subacromial_subcoracoid_subdeltoid
CREATE INDEX IF NOT EXISTS idx_shoulder_subacromial_subcoracoid_subdeltoid_encounter ON shoulder_subacromial_subcoracoid_subdeltoid(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_subacromial_subcoracoid_subdeltoid_created ON shoulder_subacromial_subcoracoid_subdeltoid(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_subacromial_subcoracoid_subdeltoid
    ADD CONSTRAINT fk_shoulder_subacromial_subcoracoid_subdeltoid_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_distal_biceps
-- Generated: 2025-11-28T20:28:38.913176
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_distal_biceps (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_distal_biceps_diagnosis" JSONB,  -- Distal biceps diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_distal_biceps
CREATE INDEX IF NOT EXISTS idx_elbow_distal_biceps_encounter ON elbow_distal_biceps(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_distal_biceps_created ON elbow_distal_biceps(created_at);

-- Foreign key constraint
ALTER TABLE elbow_distal_biceps
    ADD CONSTRAINT fk_elbow_distal_biceps_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_olecranon_bursa
-- Generated: 2025-11-28T20:28:38.883767
-- Fields: 2

CREATE TABLE IF NOT EXISTS general_olecranon_bursa (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_olecranon_bursa_dx" JSONB,  -- OLECRANON BURSA diagnosis / pathology
    "dem_olecranon_bursa_tx" JSONB,  -- Olecranon Bursa Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_olecranon_bursa
CREATE INDEX IF NOT EXISTS idx_general_olecranon_bursa_encounter ON general_olecranon_bursa(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_olecranon_bursa_created ON general_olecranon_bursa(created_at);

-- Foreign key constraint
ALTER TABLE general_olecranon_bursa
    ADD CONSTRAINT fk_general_olecranon_bursa_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_rotator_cuff
-- Generated: 2025-11-28T20:28:38.899414
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_rotator_cuff (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_rotator_cuff_diagnosis" JSONB,  -- Rotator cuff diagnosis
    "orth_sh_rotator_cuff_treatment" JSONB,  -- Rotator cuff treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_rotator_cuff
CREATE INDEX IF NOT EXISTS idx_shoulder_rotator_cuff_encounter ON shoulder_rotator_cuff(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_rotator_cuff_created ON shoulder_rotator_cuff(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_rotator_cuff
    ADD CONSTRAINT fk_shoulder_rotator_cuff_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_distal_triceps
-- Generated: 2025-11-28T20:28:38.913292
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_distal_triceps (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_distal_triceps_diagnosis" JSONB,  -- Distal triceps diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_distal_triceps
CREATE INDEX IF NOT EXISTS idx_elbow_distal_triceps_encounter ON elbow_distal_triceps(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_distal_triceps_created ON elbow_distal_triceps(created_at);

-- Foreign key constraint
ALTER TABLE elbow_distal_triceps
    ADD CONSTRAINT fk_elbow_distal_triceps_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_coronoid_process
-- Generated: 2025-11-28T20:28:38.883943
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_coronoid_process (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_coronoid_process_dx_1" JSONB,  -- Coronoid Process Diagnosis / Pathology
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_coronoid_process
CREATE INDEX IF NOT EXISTS idx_general_coronoid_process_encounter ON general_coronoid_process(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_coronoid_process_created ON general_coronoid_process(created_at);

-- Foreign key constraint
ALTER TABLE general_coronoid_process
    ADD CONSTRAINT fk_general_coronoid_process_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_bicep_anchor_bicep_pulley_lhb
-- Generated: 2025-11-28T20:28:38.899596
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_bicep_anchor_bicep_pulley_lhb (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_bicep_anchor_11_to_1_oclock_diagnosis" JSONB,  -- Biceps anchor 11 to 1 oclock diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_bicep_anchor_bicep_pulley_lhb
CREATE INDEX IF NOT EXISTS idx_shoulder_bicep_anchor_bicep_pulley_lhb_encounter ON shoulder_bicep_anchor_bicep_pulley_lhb(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_bicep_anchor_bicep_pulley_lhb_created ON shoulder_bicep_anchor_bicep_pulley_lhb(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_bicep_anchor_bicep_pulley_lhb
    ADD CONSTRAINT fk_shoulder_bicep_anchor_bicep_pulley_lhb_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_ceo_ecrb
-- Generated: 2025-11-28T20:28:38.913404
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_ceo_ecrb (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_ceo_ecrb_diagnosis" JSONB,  -- CEO ECRB diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_ceo_ecrb
CREATE INDEX IF NOT EXISTS idx_elbow_ceo_ecrb_encounter ON elbow_ceo_ecrb(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_ceo_ecrb_created ON elbow_ceo_ecrb(created_at);

-- Foreign key constraint
ALTER TABLE elbow_ceo_ecrb
    ADD CONSTRAINT fk_elbow_ceo_ecrb_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_radial_head_neck
-- Generated: 2025-11-28T20:28:38.884063
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_radial_head_neck (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_radial_head_dx_1" JSONB,  -- RADIAL HEAD / NECK Diagnosis / pathology
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_radial_head_neck
CREATE INDEX IF NOT EXISTS idx_general_radial_head_neck_encounter ON general_radial_head_neck(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_radial_head_neck_created ON general_radial_head_neck(created_at);

-- Foreign key constraint
ALTER TABLE general_radial_head_neck
    ADD CONSTRAINT fk_general_radial_head_neck_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_glenohumeral_joint
-- Generated: 2025-11-28T20:28:38.899737
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_glenohumeral_joint (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_glenohumeral_joint_diagnosis" JSONB,  -- Glenohumeral joint diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_glenohumeral_joint
CREATE INDEX IF NOT EXISTS idx_shoulder_glenohumeral_joint_encounter ON shoulder_glenohumeral_joint(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_glenohumeral_joint_created ON shoulder_glenohumeral_joint(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_glenohumeral_joint
    ADD CONSTRAINT fk_shoulder_glenohumeral_joint_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_cfo
-- Generated: 2025-11-28T20:28:38.913523
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_cfo (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_cfo_diagnosis" JSONB,  -- CFO diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_cfo
CREATE INDEX IF NOT EXISTS idx_elbow_cfo_encounter ON elbow_cfo(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_cfo_created ON elbow_cfo(created_at);

-- Foreign key constraint
ALTER TABLE elbow_cfo
    ADD CONSTRAINT fk_elbow_cfo_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_radial_diaphysis
-- Generated: 2025-11-28T20:28:38.884188
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_radial_diaphysis (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_radial_diaphysis_dx_1" JSONB,  -- Radial Diaphysis Diagnosis / Pathology
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_radial_diaphysis
CREATE INDEX IF NOT EXISTS idx_general_radial_diaphysis_encounter ON general_radial_diaphysis(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_radial_diaphysis_created ON general_radial_diaphysis(created_at);

-- Foreign key constraint
ALTER TABLE general_radial_diaphysis
    ADD CONSTRAINT fk_general_radial_diaphysis_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_plexus
-- Generated: 2025-11-28T20:28:38.899856
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_plexus (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_plexus_diagnosis" JSONB,  -- Plexus diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_plexus
CREATE INDEX IF NOT EXISTS idx_shoulder_plexus_encounter ON shoulder_plexus(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_plexus_created ON shoulder_plexus(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_plexus
    ADD CONSTRAINT fk_shoulder_plexus_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_peripheral_nerves_around_elbow
-- Generated: 2025-11-28T20:28:38.913635
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_peripheral_nerves_around_elbow (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_peripheral_nerve_around_elbow_diagnosis" JSONB,  -- Peripheral nerve around elbow diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_peripheral_nerves_around_elbow
CREATE INDEX IF NOT EXISTS idx_elbow_peripheral_nerves_around_elbow_encounter ON elbow_peripheral_nerves_around_elbow(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_peripheral_nerves_around_elbow_created ON elbow_peripheral_nerves_around_elbow(created_at);

-- Foreign key constraint
ALTER TABLE elbow_peripheral_nerves_around_elbow
    ADD CONSTRAINT fk_elbow_peripheral_nerves_around_elbow_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_ulna_diaphysis
-- Generated: 2025-11-28T20:28:38.884321
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_ulna_diaphysis (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_ulna_diaphysis_dx_1" JSONB,  -- Ulna Diaphysis Diagnosis / Pathology
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_ulna_diaphysis
CREATE INDEX IF NOT EXISTS idx_general_ulna_diaphysis_encounter ON general_ulna_diaphysis(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_ulna_diaphysis_created ON general_ulna_diaphysis(created_at);

-- Foreign key constraint
ALTER TABLE general_ulna_diaphysis
    ADD CONSTRAINT fk_general_ulna_diaphysis_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_pn
-- Generated: 2025-11-28T20:28:38.899980
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_pn (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_peripheral_nerve_around_shoulder_girdle_diagnosis" JSONB,  -- Peripheral nerve around shoulder girdle diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_pn
CREATE INDEX IF NOT EXISTS idx_shoulder_pn_encounter ON shoulder_pn(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_pn_created ON shoulder_pn(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_pn
    ADD CONSTRAINT fk_shoulder_pn_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


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


-- Table: general_fascia
-- Generated: 2025-11-28T20:28:38.884439
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_fascia (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_fascia_dx" JSONB,  -- Fascia diagnosis / pathology
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_fascia
CREATE INDEX IF NOT EXISTS idx_general_fascia_encounter ON general_fascia(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_fascia_created ON general_fascia(created_at);

-- Foreign key constraint
ALTER TABLE general_fascia
    ADD CONSTRAINT fk_general_fascia_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_deltoid
-- Generated: 2025-11-28T20:28:38.900122
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_deltoid (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_deltoid_diagnosis" JSONB,  -- Deltoid diagnosis
    "orth_sh_deltoid_treatment" JSONB,  -- Deltoid treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_deltoid
CREATE INDEX IF NOT EXISTS idx_shoulder_deltoid_encounter ON shoulder_deltoid(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_deltoid_created ON shoulder_deltoid(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_deltoid
    ADD CONSTRAINT fk_shoulder_deltoid_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_olecranon_bursa
-- Generated: 2025-11-28T20:28:38.913863
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_olecranon_bursa (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_olecranon_bursa_diagnosis" JSONB,  -- Olecranon bursa diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_olecranon_bursa
CREATE INDEX IF NOT EXISTS idx_elbow_olecranon_bursa_encounter ON elbow_olecranon_bursa(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_olecranon_bursa_created ON elbow_olecranon_bursa(created_at);

-- Foreign key constraint
ALTER TABLE elbow_olecranon_bursa
    ADD CONSTRAINT fk_elbow_olecranon_bursa_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_infection_other_please_go_to_specific_anatomic_reg
-- Generated: 2025-11-28T20:28:38.884558
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_infection_other_please_go_to_specific_anatomic_reg (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_infection_location" VARCHAR(500),  -- Infection Location
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_infection_other_please_go_to_specific_anatomic_reg
CREATE INDEX IF NOT EXISTS idx_general_infection_other_please_go_to_specific_anatomic_reg_encounter ON general_infection_other_please_go_to_specific_anatomic_reg(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_infection_other_please_go_to_specific_anatomic_reg_created ON general_infection_other_please_go_to_specific_anatomic_reg(created_at);

-- Foreign key constraint
ALTER TABLE general_infection_other_please_go_to_specific_anatomic_reg
    ADD CONSTRAINT fk_general_infection_other_please_go_to_specific_anatomic_reg_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_pec_minor
-- Generated: 2025-11-28T20:28:38.900253
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_pec_minor (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_pec_minor_diagnosis" JSONB,  -- Pec minor diagnosis
    "orth_sh_pec_minor_treatment" JSONB,  -- Pec minor treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_pec_minor
CREATE INDEX IF NOT EXISTS idx_shoulder_pec_minor_encounter ON shoulder_pec_minor(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_pec_minor_created ON shoulder_pec_minor(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_pec_minor
    ADD CONSTRAINT fk_shoulder_pec_minor_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_coronoid
-- Generated: 2025-11-28T20:28:38.913968
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_coronoid (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_coronoid_diagnosis" JSONB,  -- Coronoid diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_coronoid
CREATE INDEX IF NOT EXISTS idx_elbow_coronoid_encounter ON elbow_coronoid(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_coronoid_created ON elbow_coronoid(created_at);

-- Foreign key constraint
ALTER TABLE elbow_coronoid
    ADD CONSTRAINT fk_elbow_coronoid_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_distal_humerus_treatment
-- Generated: 2025-11-28T20:28:38.884681
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_distal_humerus_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_distal_humerus_tx" JSONB,  -- Distal Humerus Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_distal_humerus_treatment
CREATE INDEX IF NOT EXISTS idx_general_distal_humerus_treatment_encounter ON general_distal_humerus_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_distal_humerus_treatment_created ON general_distal_humerus_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_distal_humerus_treatment
    ADD CONSTRAINT fk_general_distal_humerus_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_pec_major
-- Generated: 2025-11-28T20:28:38.900375
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_pec_major (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_pec_major_diagnosis" JSONB,  -- Pec major diagnosis
    "orth_sh_pec_major_treatment" JSONB,  -- Pec major treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_pec_major
CREATE INDEX IF NOT EXISTS idx_shoulder_pec_major_encounter ON shoulder_pec_major(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_pec_major_created ON shoulder_pec_major(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_pec_major
    ADD CONSTRAINT fk_shoulder_pec_major_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_radial_head_neck
-- Generated: 2025-11-28T20:28:38.914085
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_radial_head_neck (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_radial_head_neck_diagnosis" JSONB,  -- Radial head neck diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_radial_head_neck
CREATE INDEX IF NOT EXISTS idx_elbow_radial_head_neck_encounter ON elbow_radial_head_neck(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_radial_head_neck_created ON elbow_radial_head_neck(created_at);

-- Foreign key constraint
ALTER TABLE elbow_radial_head_neck
    ADD CONSTRAINT fk_elbow_radial_head_neck_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_ulnohumeral_radiocapitellar_articulation_treatment
-- Generated: 2025-11-28T20:28:38.884798
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_ulnohumeral_radiocapitellar_articulation_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_ulnohumeral_radiocapitellar_tx" JSONB,  -- Ulnohumeral & Radiocapitellar Treatments
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_ulnohumeral_radiocapitellar_articulation_treatment
CREATE INDEX IF NOT EXISTS idx_general_ulnohumeral_radiocapitellar_articulation_treatment_encounter ON general_ulnohumeral_radiocapitellar_articulation_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_ulnohumeral_radiocapitellar_articulation_treatment_created ON general_ulnohumeral_radiocapitellar_articulation_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_ulnohumeral_radiocapitellar_articulation_treatment
    ADD CONSTRAINT fk_general_ulnohumeral_radiocapitellar_articulation_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_latissimus_dorsi
-- Generated: 2025-11-28T20:28:38.900506
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_latissimus_dorsi (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_latissimus_dorsi_diagnosis" JSONB,  -- Latissimus dorsi diagnosis
    "orth_sh_lat_dorsi_treatment" JSONB,  -- Lat dorsi treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_latissimus_dorsi
CREATE INDEX IF NOT EXISTS idx_shoulder_latissimus_dorsi_encounter ON shoulder_latissimus_dorsi(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_latissimus_dorsi_created ON shoulder_latissimus_dorsi(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_latissimus_dorsi
    ADD CONSTRAINT fk_shoulder_latissimus_dorsi_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_radial_diaphysis
-- Generated: 2025-11-28T20:28:38.914204
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_radial_diaphysis (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_radius_diaphysis_diagnosis" JSONB,  -- Radius diaphysis diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_radial_diaphysis
CREATE INDEX IF NOT EXISTS idx_elbow_radial_diaphysis_encounter ON elbow_radial_diaphysis(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_radial_diaphysis_created ON elbow_radial_diaphysis(created_at);

-- Foreign key constraint
ALTER TABLE elbow_radial_diaphysis
    ADD CONSTRAINT fk_elbow_radial_diaphysis_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_forearm_articulations_pruj_druj_treatment
-- Generated: 2025-11-28T20:28:38.884913
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_forearm_articulations_pruj_druj_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_forearm_articulation_pruj_druj_tx" JSONB,  -- Forearm Articulation ± PRUJ ± DRUJ Treatments
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_forearm_articulations_pruj_druj_treatment
CREATE INDEX IF NOT EXISTS idx_general_forearm_articulations_pruj_druj_treatment_encounter ON general_forearm_articulations_pruj_druj_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_forearm_articulations_pruj_druj_treatment_created ON general_forearm_articulations_pruj_druj_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_forearm_articulations_pruj_druj_treatment
    ADD CONSTRAINT fk_general_forearm_articulations_pruj_druj_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_diagnosis
-- Generated: 2025-11-28T20:28:38.900640
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_diagnosis (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_diag_teres_major_diagnosis" JSONB,  -- Teres major diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_diagnosis
CREATE INDEX IF NOT EXISTS idx_shoulder_diagnosis_encounter ON shoulder_diagnosis(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_diagnosis_created ON shoulder_diagnosis(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_diagnosis
    ADD CONSTRAINT fk_shoulder_diagnosis_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_ulna_diaphysis
-- Generated: 2025-11-28T20:28:38.914324
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_ulna_diaphysis (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_ulna_diaphysis_diagnosis" JSONB,  -- Ulna diaphysis diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_ulna_diaphysis
CREATE INDEX IF NOT EXISTS idx_elbow_ulna_diaphysis_encounter ON elbow_ulna_diaphysis(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_ulna_diaphysis_created ON elbow_ulna_diaphysis(created_at);

-- Foreign key constraint
ALTER TABLE elbow_ulna_diaphysis
    ADD CONSTRAINT fk_elbow_ulna_diaphysis_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_distal_biceps_tendon_treatment
-- Generated: 2025-11-28T20:28:38.885026
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_distal_biceps_tendon_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_distal_biceps_tendon_tx" JSONB,  -- Distal Biceps Tendon Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_distal_biceps_tendon_treatment
CREATE INDEX IF NOT EXISTS idx_general_distal_biceps_tendon_treatment_encounter ON general_distal_biceps_tendon_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_distal_biceps_tendon_treatment_created ON general_distal_biceps_tendon_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_distal_biceps_tendon_treatment
    ADD CONSTRAINT fk_general_distal_biceps_tendon_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_proximal_humerus
-- Generated: 2025-11-28T20:28:38.900773
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_proximal_humerus (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_proximal_humerus_diagnosis" JSONB,  -- Proximal humerus diagnosis
    "orth_sh_proximal_humerus_treatment" JSONB,  -- Proximal humerus treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_proximal_humerus
CREATE INDEX IF NOT EXISTS idx_shoulder_proximal_humerus_encounter ON shoulder_proximal_humerus(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_proximal_humerus_created ON shoulder_proximal_humerus(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_proximal_humerus
    ADD CONSTRAINT fk_shoulder_proximal_humerus_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_fascia
-- Generated: 2025-11-28T20:28:38.914448
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_fascia (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_fascia_diagnosis" JSONB,  -- Fascia diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_fascia
CREATE INDEX IF NOT EXISTS idx_elbow_fascia_encounter ON elbow_fascia(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_fascia_created ON elbow_fascia(created_at);

-- Foreign key constraint
ALTER TABLE elbow_fascia
    ADD CONSTRAINT fk_elbow_fascia_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_distal_triceps_tendon_treatment
-- Generated: 2025-11-28T20:28:38.885139
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_distal_triceps_tendon_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_distal_triceps_tendon_tx" JSONB,  -- Distal Triceps Tendon Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_distal_triceps_tendon_treatment
CREATE INDEX IF NOT EXISTS idx_general_distal_triceps_tendon_treatment_encounter ON general_distal_triceps_tendon_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_distal_triceps_tendon_treatment_created ON general_distal_triceps_tendon_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_distal_triceps_tendon_treatment
    ADD CONSTRAINT fk_general_distal_triceps_tendon_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_humerus_diaphysis
-- Generated: 2025-11-28T20:28:38.901015
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_humerus_diaphysis (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_humerus_diaphysis_diagnosis" JSONB,  -- Humerus diaphysis diagnosis
    "orth_sh_humerus_diaphysis_treatment" JSONB,  -- Humerus diaphysis treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_humerus_diaphysis
CREATE INDEX IF NOT EXISTS idx_shoulder_humerus_diaphysis_encounter ON shoulder_humerus_diaphysis(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_humerus_diaphysis_created ON shoulder_humerus_diaphysis(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_humerus_diaphysis
    ADD CONSTRAINT fk_shoulder_humerus_diaphysis_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_infection
-- Generated: 2025-11-28T20:28:38.914724
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_infection (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_infection_diagnosis" VARCHAR(50),  -- Infection diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_infection
CREATE INDEX IF NOT EXISTS idx_elbow_infection_encounter ON elbow_infection(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_infection_created ON elbow_infection(created_at);

-- Foreign key constraint
ALTER TABLE elbow_infection
    ADD CONSTRAINT fk_elbow_infection_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_common_extensor_origin_treatment
-- Generated: 2025-11-28T20:28:38.885252
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_common_extensor_origin_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_ceo_tx" JSONB,  -- Common Extensor Origin Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_common_extensor_origin_treatment
CREATE INDEX IF NOT EXISTS idx_general_common_extensor_origin_treatment_encounter ON general_common_extensor_origin_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_common_extensor_origin_treatment_created ON general_common_extensor_origin_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_common_extensor_origin_treatment
    ADD CONSTRAINT fk_general_common_extensor_origin_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_fascia
-- Generated: 2025-11-28T20:28:38.901154
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_fascia (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_fascia_diagnosis" JSONB,  -- Fascia diagnosis
    "orth_sh_fascia_treatment" JSONB,  -- Fascia treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_fascia
CREATE INDEX IF NOT EXISTS idx_shoulder_fascia_encounter ON shoulder_fascia(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_fascia_created ON shoulder_fascia(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_fascia
    ADD CONSTRAINT fk_shoulder_fascia_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_history
-- Generated: 2025-11-28T20:28:38.914876
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_history (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_record_history_for_the_enc" VARCHAR(50),  -- Record history for the encounter
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_history
CREATE INDEX IF NOT EXISTS idx_elbow_history_encounter ON elbow_history(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_history_created ON elbow_history(created_at);

-- Foreign key constraint
ALTER TABLE elbow_history
    ADD CONSTRAINT fk_elbow_history_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_common_flexor_origin_treatment
-- Generated: 2025-11-28T20:28:38.885361
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_common_flexor_origin_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_cfo_tx" JSONB,  -- Common Flexor Origin Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_common_flexor_origin_treatment
CREATE INDEX IF NOT EXISTS idx_general_common_flexor_origin_treatment_encounter ON general_common_flexor_origin_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_common_flexor_origin_treatment_created ON general_common_flexor_origin_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_common_flexor_origin_treatment
    ADD CONSTRAINT fk_general_common_flexor_origin_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_infection
-- Generated: 2025-11-28T20:28:38.901285
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_infection (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_infection_diagnosis" VARCHAR(50),  -- Infection diagnosis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_infection
CREATE INDEX IF NOT EXISTS idx_shoulder_infection_encounter ON shoulder_infection(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_infection_created ON shoulder_infection(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_infection
    ADD CONSTRAINT fk_shoulder_infection_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_diagnosis
-- Generated: 2025-11-28T20:28:38.915005
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_diagnosis (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_diag_location" JSONB,  -- Elbow Regions
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_diagnosis
CREATE INDEX IF NOT EXISTS idx_elbow_diagnosis_encounter ON elbow_diagnosis(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_diagnosis_created ON elbow_diagnosis(created_at);

-- Foreign key constraint
ALTER TABLE elbow_diagnosis
    ADD CONSTRAINT fk_elbow_diagnosis_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


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


-- Table: shoulder_other
-- Generated: 2025-11-28T20:28:38.901403
-- Fields: 2

CREATE TABLE IF NOT EXISTS shoulder_other (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_other_pathology_diagnosis" TEXT,  -- Other pathology diagnosis
    "orth_sh_other_treatment" TEXT,  -- Other treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_other
CREATE INDEX IF NOT EXISTS idx_shoulder_other_encounter ON shoulder_other(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_other_created ON shoulder_other(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_other
    ADD CONSTRAINT fk_shoulder_other_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_peripheral_nerve_around_elbow_forearm
-- Generated: 2025-11-28T20:28:38.915133
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_peripheral_nerve_around_elbow_forearm (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_nerve_dysfunction_dx_1" JSONB,  -- Peripheral Nerve around Elbow / Forearm diagnosis / patholog
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_peripheral_nerve_around_elbow_forearm
CREATE INDEX IF NOT EXISTS idx_elbow_peripheral_nerve_around_elbow_forearm_encounter ON elbow_peripheral_nerve_around_elbow_forearm(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_peripheral_nerve_around_elbow_forearm_created ON elbow_peripheral_nerve_around_elbow_forearm(created_at);

-- Foreign key constraint
ALTER TABLE elbow_peripheral_nerve_around_elbow_forearm
    ADD CONSTRAINT fk_elbow_peripheral_nerve_around_elbow_forearm_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_nerve_dysfunction
-- Generated: 2025-11-28T20:28:38.885580
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_nerve_dysfunction (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_mechanical_neuropathy_treatment" JSONB,  -- Neuropathy Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_nerve_dysfunction
CREATE INDEX IF NOT EXISTS idx_general_nerve_dysfunction_encounter ON general_nerve_dysfunction(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_nerve_dysfunction_created ON general_nerve_dysfunction(created_at);

-- Foreign key constraint
ALTER TABLE general_nerve_dysfunction
    ADD CONSTRAINT fk_general_nerve_dysfunction_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_history
-- Generated: 2025-11-28T20:28:38.901535
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_history (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_record_history_for_the_encounter" VARCHAR(50),  -- Record history for the encounter
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_history
CREATE INDEX IF NOT EXISTS idx_shoulder_history_encounter ON shoulder_history(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_history_created ON shoulder_history(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_history
    ADD CONSTRAINT fk_shoulder_history_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_other
-- Generated: 2025-11-28T20:28:38.915258
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_other (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_other_diagnostic_pathological_information" TEXT,  -- Other diagnostic / pathological information
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_other
CREATE INDEX IF NOT EXISTS idx_elbow_other_encounter ON elbow_other(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_other_created ON elbow_other(created_at);

-- Foreign key constraint
ALTER TABLE elbow_other
    ADD CONSTRAINT fk_elbow_other_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_olecranon_treatment
-- Generated: 2025-11-28T20:28:38.885690
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_olecranon_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_olecranon_tx" JSONB,  -- Olecranon Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_olecranon_treatment
CREATE INDEX IF NOT EXISTS idx_general_olecranon_treatment_encounter ON general_olecranon_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_olecranon_treatment_created ON general_olecranon_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_olecranon_treatment
    ADD CONSTRAINT fk_general_olecranon_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_clinical
-- Generated: 2025-11-28T20:28:38.901647
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_clinical (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_clin_examination_to_record" JSONB,  -- Examination to record
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_clinical
CREATE INDEX IF NOT EXISTS idx_shoulder_clinical_encounter ON shoulder_clinical(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_clinical_created ON shoulder_clinical(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_clinical
    ADD CONSTRAINT fk_shoulder_clinical_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


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


-- Table: general_coronoid_process_treatment
-- Generated: 2025-11-28T20:28:38.886932
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_coronoid_process_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_coronoid_tx" JSONB,  -- Coronoid Process Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_coronoid_process_treatment
CREATE INDEX IF NOT EXISTS idx_general_coronoid_process_treatment_encounter ON general_coronoid_process_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_coronoid_process_treatment_created ON general_coronoid_process_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_coronoid_process_treatment
    ADD CONSTRAINT fk_general_coronoid_process_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_proms
-- Generated: 2025-11-28T20:28:38.901774
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_proms (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_proms_shoulder_rom_passive_flexion" VARCHAR(50),  -- Shoulder ROM passive flexion
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_proms
CREATE INDEX IF NOT EXISTS idx_shoulder_proms_encounter ON shoulder_proms(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_proms_created ON shoulder_proms(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_proms
    ADD CONSTRAINT fk_shoulder_proms_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_peripheral_nerves_around_the_elbow
-- Generated: 2025-11-28T20:28:38.915503
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_peripheral_nerves_around_the_elbow (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_nerve_location_involvement_aetiology" JSONB,  -- Nerve location involvement / aetiology
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for elbow_peripheral_nerves_around_the_elbow
CREATE INDEX IF NOT EXISTS idx_elbow_peripheral_nerves_around_the_elbow_encounter ON elbow_peripheral_nerves_around_the_elbow(encounter_id);
CREATE INDEX IF NOT EXISTS idx_elbow_peripheral_nerves_around_the_elbow_created ON elbow_peripheral_nerves_around_the_elbow(created_at);

-- Foreign key constraint
ALTER TABLE elbow_peripheral_nerves_around_the_elbow
    ADD CONSTRAINT fk_elbow_peripheral_nerves_around_the_elbow_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_radial_head_neck_treatment
-- Generated: 2025-11-28T20:28:38.887392
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_radial_head_neck_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_radial_head_neck_tx" JSONB,  -- Radial Head / Neck Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_radial_head_neck_treatment
CREATE INDEX IF NOT EXISTS idx_general_radial_head_neck_treatment_encounter ON general_radial_head_neck_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_radial_head_neck_treatment_created ON general_radial_head_neck_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_radial_head_neck_treatment
    ADD CONSTRAINT fk_general_radial_head_neck_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_shoulder_lag_signs
-- Generated: 2025-11-28T20:28:38.901889
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_shoulder_lag_signs (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_shoulder_lag_drop_arm" VARCHAR(50),  -- Shoulder lag drop arm
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_shoulder_lag_signs
CREATE INDEX IF NOT EXISTS idx_shoulder_shoulder_lag_signs_encounter ON shoulder_shoulder_lag_signs(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_shoulder_lag_signs_created ON shoulder_shoulder_lag_signs(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_shoulder_lag_signs
    ADD CONSTRAINT fk_shoulder_shoulder_lag_signs_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: elbow_treatment_plan
-- Generated: 2025-11-28T20:28:38.915611
-- Fields: 1

CREATE TABLE IF NOT EXISTS elbow_treatment_plan (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_el_tp_injectable_treatment" JSONB,  -- Injectable treatment
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


-- Table: general_radial_diaphysis_treatment
-- Generated: 2025-11-28T20:28:38.887590
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_radial_diaphysis_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_radial_diaphysis_tx" JSONB,  -- Radial Diaphysis Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_radial_diaphysis_treatment
CREATE INDEX IF NOT EXISTS idx_general_radial_diaphysis_treatment_encounter ON general_radial_diaphysis_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_radial_diaphysis_treatment_created ON general_radial_diaphysis_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_radial_diaphysis_treatment
    ADD CONSTRAINT fk_general_radial_diaphysis_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_shoulder_power
-- Generated: 2025-11-28T20:28:38.901998
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_shoulder_power (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_shoulder_power_flexion" VARCHAR(50),  -- Shoulder power flexion
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_shoulder_power
CREATE INDEX IF NOT EXISTS idx_shoulder_shoulder_power_encounter ON shoulder_shoulder_power(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_shoulder_power_created ON shoulder_shoulder_power(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_shoulder_power
    ADD CONSTRAINT fk_shoulder_shoulder_power_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_ulna_diaphysis_treatment
-- Generated: 2025-11-28T20:28:38.887702
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_ulna_diaphysis_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_ulna_diaphysis_tx" JSONB,  -- Ulna Diaphysis Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_ulna_diaphysis_treatment
CREATE INDEX IF NOT EXISTS idx_general_ulna_diaphysis_treatment_encounter ON general_ulna_diaphysis_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_ulna_diaphysis_treatment_created ON general_ulna_diaphysis_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_ulna_diaphysis_treatment
    ADD CONSTRAINT fk_general_ulna_diaphysis_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_clinical
-- Generated: 2025-11-28T20:28:38.902104
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_clinical (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_clin_sct_crepitus" VARCHAR(50),  -- ScT crepitus
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_clinical
CREATE INDEX IF NOT EXISTS idx_shoulder_clinical_encounter ON shoulder_clinical(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_clinical_created ON shoulder_clinical(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_clinical
    ADD CONSTRAINT fk_shoulder_clinical_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_fascia_treatment
-- Generated: 2025-11-28T20:28:38.887805
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_fascia_treatment (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_fascia_tx" JSONB,  -- Fascia Treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_fascia_treatment
CREATE INDEX IF NOT EXISTS idx_general_fascia_treatment_encounter ON general_fascia_treatment(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_fascia_treatment_created ON general_fascia_treatment(created_at);

-- Foreign key constraint
ALTER TABLE general_fascia_treatment
    ADD CONSTRAINT fk_general_fascia_treatment_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_muscle_power
-- Generated: 2025-11-28T20:28:38.902206
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_muscle_power (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_trapezius" VARCHAR(50),  -- Trapezius
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_muscle_power
CREATE INDEX IF NOT EXISTS idx_shoulder_muscle_power_encounter ON shoulder_muscle_power(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_muscle_power_created ON shoulder_muscle_power(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_muscle_power
    ADD CONSTRAINT fk_shoulder_muscle_power_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: general_amputation
-- Generated: 2025-11-28T20:28:38.888005
-- Fields: 1

CREATE TABLE IF NOT EXISTS general_amputation (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "dem_amputation_level" JSONB,  -- Amputation Level
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for general_amputation
CREATE INDEX IF NOT EXISTS idx_general_amputation_encounter ON general_amputation(encounter_id);
CREATE INDEX IF NOT EXISTS idx_general_amputation_created ON general_amputation(created_at);

-- Foreign key constraint
ALTER TABLE general_amputation
    ADD CONSTRAINT fk_general_amputation_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_clinical
-- Generated: 2025-11-28T20:28:38.902310
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_clinical (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_clin_impingement_signs" VARCHAR(50),  -- Impingement signs
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_clinical
CREATE INDEX IF NOT EXISTS idx_shoulder_clinical_encounter ON shoulder_clinical(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_clinical_created ON shoulder_clinical(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_clinical
    ADD CONSTRAINT fk_shoulder_clinical_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_clinical
-- Generated: 2025-11-28T20:28:38.902425
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_clinical (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_clin_acj_tenderness" VARCHAR(50),  -- ACJ tenderness
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_clinical
CREATE INDEX IF NOT EXISTS idx_shoulder_clinical_encounter ON shoulder_clinical(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_clinical_created ON shoulder_clinical(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_clinical
    ADD CONSTRAINT fk_shoulder_clinical_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_clinical
-- Generated: 2025-11-28T20:28:38.902539
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_clinical (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_clin_lhb_tenderness" JSONB,  -- LHB tenderness
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_clinical
CREATE INDEX IF NOT EXISTS idx_shoulder_clinical_encounter ON shoulder_clinical(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_clinical_created ON shoulder_clinical(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_clinical
    ADD CONSTRAINT fk_shoulder_clinical_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_clinical
-- Generated: 2025-11-28T20:28:38.902645
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_clinical (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_clin_sulcus_sign" VARCHAR(50),  -- Sulcus sign
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_clinical
CREATE INDEX IF NOT EXISTS idx_shoulder_clinical_encounter ON shoulder_clinical(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_clinical_created ON shoulder_clinical(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_clinical
    ADD CONSTRAINT fk_shoulder_clinical_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_clinical
-- Generated: 2025-11-28T20:28:38.902761
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_clinical (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_clin_scj_tenderness" VARCHAR(50),  -- SCJ tenderness
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_clinical
CREATE INDEX IF NOT EXISTS idx_shoulder_clinical_encounter ON shoulder_clinical(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_clinical_created ON shoulder_clinical(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_clinical
    ADD CONSTRAINT fk_shoulder_clinical_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_tos_nspcn
-- Generated: 2025-11-28T20:28:38.902871
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_tos_nspcn (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_tos_signs" JSONB,  -- TOS signs
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_tos_nspcn
CREATE INDEX IF NOT EXISTS idx_shoulder_tos_nspcn_encounter ON shoulder_tos_nspcn(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_tos_nspcn_created ON shoulder_tos_nspcn(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_tos_nspcn
    ADD CONSTRAINT fk_shoulder_tos_nspcn_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_clinical
-- Generated: 2025-11-28T20:28:38.902981
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_clinical (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_clin_peripheral_nerve_examination" JSONB,  -- Peripheral nerve examination
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_clinical
CREATE INDEX IF NOT EXISTS idx_shoulder_clinical_encounter ON shoulder_clinical(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_clinical_created ON shoulder_clinical(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_clinical
    ADD CONSTRAINT fk_shoulder_clinical_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_clinical
-- Generated: 2025-11-28T20:28:38.903095
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_clinical (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_clin_bony_tenderness" JSONB,  -- Bony tenderness
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_clinical
CREATE INDEX IF NOT EXISTS idx_shoulder_clinical_encounter ON shoulder_clinical(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_clinical_created ON shoulder_clinical(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_clinical
    ADD CONSTRAINT fk_shoulder_clinical_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_treatment_plan
-- Generated: 2025-11-28T20:28:38.903573
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_treatment_plan (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_tp_treatment_plan" JSONB,  -- Treatment Plan
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_treatment_plan
CREATE INDEX IF NOT EXISTS idx_shoulder_treatment_plan_encounter ON shoulder_treatment_plan(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_treatment_plan_created ON shoulder_treatment_plan(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_treatment_plan
    ADD CONSTRAINT fk_shoulder_treatment_plan_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_surgery
-- Generated: 2025-11-28T20:28:38.903952
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_surgery (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_surg_surgery_side" VARCHAR(50),  -- Surgery side
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_surgery
CREATE INDEX IF NOT EXISTS idx_shoulder_surgery_encounter ON shoulder_surgery(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_surgery_created ON shoulder_surgery(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_surgery
    ADD CONSTRAINT fk_shoulder_surgery_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_scapulothoracic
-- Generated: 2025-11-28T20:28:38.904193
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_scapulothoracic (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_scapulothoracic_treatment" JSONB,  -- Scapulothoracic treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_scapulothoracic
CREATE INDEX IF NOT EXISTS idx_shoulder_scapulothoracic_encounter ON shoulder_scapulothoracic(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_scapulothoracic_created ON shoulder_scapulothoracic(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_scapulothoracic
    ADD CONSTRAINT fk_shoulder_scapulothoracic_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_manubriosternal_joint_msj_
-- Generated: 2025-11-28T20:28:38.904310
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_manubriosternal_joint_msj_ (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_msj_treatment" JSONB,  -- MSJ treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_manubriosternal_joint_msj_
CREATE INDEX IF NOT EXISTS idx_shoulder_manubriosternal_joint_msj__encounter ON shoulder_manubriosternal_joint_msj_(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_manubriosternal_joint_msj__created ON shoulder_manubriosternal_joint_msj_(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_manubriosternal_joint_msj_
    ADD CONSTRAINT fk_shoulder_manubriosternal_joint_msj__encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_sternoclavicular_joint_scj_
-- Generated: 2025-11-28T20:28:38.904425
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_sternoclavicular_joint_scj_ (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_scj_treatment" JSONB,  -- SCJ treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_sternoclavicular_joint_scj_
CREATE INDEX IF NOT EXISTS idx_shoulder_sternoclavicular_joint_scj__encounter ON shoulder_sternoclavicular_joint_scj_(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_sternoclavicular_joint_scj__created ON shoulder_sternoclavicular_joint_scj_(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_sternoclavicular_joint_scj_
    ADD CONSTRAINT fk_shoulder_sternoclavicular_joint_scj__encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_subacromial_subcoracoid_subdeltoid_sa_sc_sd_space
-- Generated: 2025-11-28T20:28:38.904541
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_subacromial_subcoracoid_subdeltoid_sa_sc_sd_space (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_sa_sc_sd_treatment" JSONB,  -- SA SC SD treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_subacromial_subcoracoid_subdeltoid_sa_sc_sd_space
CREATE INDEX IF NOT EXISTS idx_shoulder_subacromial_subcoracoid_subdeltoid_sa_sc_sd_space_encounter ON shoulder_subacromial_subcoracoid_subdeltoid_sa_sc_sd_space(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_subacromial_subcoracoid_subdeltoid_sa_sc_sd_space_created ON shoulder_subacromial_subcoracoid_subdeltoid_sa_sc_sd_space(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_subacromial_subcoracoid_subdeltoid_sa_sc_sd_space
    ADD CONSTRAINT fk_shoulder_subacromial_subcoracoid_subdeltoid_sa_sc_sd_space_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_biceps_anchor
-- Generated: 2025-11-28T20:28:38.904728
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_biceps_anchor (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_biceps_anchor_treatment" JSONB,  -- Biceps anchor treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_biceps_anchor
CREATE INDEX IF NOT EXISTS idx_shoulder_biceps_anchor_encounter ON shoulder_biceps_anchor(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_biceps_anchor_created ON shoulder_biceps_anchor(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_biceps_anchor
    ADD CONSTRAINT fk_shoulder_biceps_anchor_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_lhb
-- Generated: 2025-11-28T20:28:38.904909
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_lhb (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_lhb_treatment" JSONB,  -- LHB treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_lhb
CREATE INDEX IF NOT EXISTS idx_shoulder_lhb_encounter ON shoulder_lhb(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_lhb_created ON shoulder_lhb(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_lhb
    ADD CONSTRAINT fk_shoulder_lhb_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_glenhumeral_joint_ghj_
-- Generated: 2025-11-28T20:28:38.905073
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_glenhumeral_joint_ghj_ (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_ghj_treatment" JSONB,  -- GHJ treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_glenhumeral_joint_ghj_
CREATE INDEX IF NOT EXISTS idx_shoulder_glenhumeral_joint_ghj__encounter ON shoulder_glenhumeral_joint_ghj_(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_glenhumeral_joint_ghj__created ON shoulder_glenhumeral_joint_ghj_(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_glenhumeral_joint_ghj_
    ADD CONSTRAINT fk_shoulder_glenhumeral_joint_ghj__encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_thoracic_outlet_plexus
-- Generated: 2025-11-28T20:28:38.905187
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_thoracic_outlet_plexus (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_plexus_treatment" JSONB,  -- Plexus treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_thoracic_outlet_plexus
CREATE INDEX IF NOT EXISTS idx_shoulder_thoracic_outlet_plexus_encounter ON shoulder_thoracic_outlet_plexus(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_thoracic_outlet_plexus_created ON shoulder_thoracic_outlet_plexus(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_thoracic_outlet_plexus
    ADD CONSTRAINT fk_shoulder_thoracic_outlet_plexus_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_peripheral_nerves_around_shoulder
-- Generated: 2025-11-28T20:28:38.905293
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_peripheral_nerves_around_shoulder (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_peripheral_nerve_treatment_location" JSONB,  -- Peripheral nerve treatment location
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_peripheral_nerves_around_shoulder
CREATE INDEX IF NOT EXISTS idx_shoulder_peripheral_nerves_around_shoulder_encounter ON shoulder_peripheral_nerves_around_shoulder(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_peripheral_nerves_around_shoulder_created ON shoulder_peripheral_nerves_around_shoulder(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_peripheral_nerves_around_shoulder
    ADD CONSTRAINT fk_shoulder_peripheral_nerves_around_shoulder_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_teres_major
-- Generated: 2025-11-28T20:28:38.905403
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_teres_major (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_teres_major_treatment" JSONB,  -- Teres major treatment
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_teres_major
CREATE INDEX IF NOT EXISTS idx_shoulder_teres_major_encounter ON shoulder_teres_major(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_teres_major_created ON shoulder_teres_major(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_teres_major
    ADD CONSTRAINT fk_shoulder_teres_major_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_surgery
-- Generated: 2025-11-28T20:28:38.905584
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_surgery (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_surg_closure_details" JSONB,  -- Closure details
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_surgery
CREATE INDEX IF NOT EXISTS idx_shoulder_surgery_encounter ON shoulder_surgery(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_surgery_created ON shoulder_surgery(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_surgery
    ADD CONSTRAINT fk_shoulder_surgery_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_post_operative_instructions
-- Generated: 2025-11-28T20:28:38.906021
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_post_operative_instructions (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_dvt_prophyllaxis" JSONB,  -- DVT prophyllaxis
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_post_operative_instructions
CREATE INDEX IF NOT EXISTS idx_shoulder_post_operative_instructions_encounter ON shoulder_post_operative_instructions(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_post_operative_instructions_created ON shoulder_post_operative_instructions(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_post_operative_instructions
    ADD CONSTRAINT fk_shoulder_post_operative_instructions_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


-- Table: shoulder_follow_up
-- Generated: 2025-11-28T20:28:38.906248
-- Fields: 1

CREATE TABLE IF NOT EXISTS shoulder_follow_up (
    id SERIAL PRIMARY KEY,
    encounter_id VARCHAR(100) NOT NULL,
    "orth_sh_outcome" VARCHAR(50),  -- Outcome
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for shoulder_follow_up
CREATE INDEX IF NOT EXISTS idx_shoulder_follow_up_encounter ON shoulder_follow_up(encounter_id);
CREATE INDEX IF NOT EXISTS idx_shoulder_follow_up_created ON shoulder_follow_up(created_at);

-- Foreign key constraint
ALTER TABLE shoulder_follow_up
    ADD CONSTRAINT fk_shoulder_follow_up_encounter
    FOREIGN KEY (encounter_id)
    REFERENCES encounters(encounter_id)
    ON DELETE CASCADE;


