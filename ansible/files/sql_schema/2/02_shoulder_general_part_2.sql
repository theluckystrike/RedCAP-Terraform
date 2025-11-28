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
