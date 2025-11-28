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
