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
