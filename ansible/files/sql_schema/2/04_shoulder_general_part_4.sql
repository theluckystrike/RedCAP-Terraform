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
