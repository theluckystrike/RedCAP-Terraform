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
