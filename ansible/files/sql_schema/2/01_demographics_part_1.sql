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
