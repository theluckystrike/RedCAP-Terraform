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
