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
