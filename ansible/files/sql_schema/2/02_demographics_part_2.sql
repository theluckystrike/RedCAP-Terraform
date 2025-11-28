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
