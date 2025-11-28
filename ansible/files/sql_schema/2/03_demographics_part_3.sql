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
