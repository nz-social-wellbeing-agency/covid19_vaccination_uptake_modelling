/**************************************************************************************************
Title: Postprocessing of DAT before importing into Stata

Author: Shaan Badenhorst

*/


drop table #tmp_table1
SELECT [identity_column] as snz_uid
      ,[CIR_sequence_group]
      ,[COB_COC]
      ,[Craig_sole_parent_ind]
      ,[Current_HNZ_tenant_Dec21]
      ,[Dose_1_Day]
      ,[Dose_1_Month]
      ,[Dose_1_Year]
      ,[Dose_2_Day]
      ,[Dose_2_Month]
      ,[Dose_2_Year]
      ,[Dose_3_Day]
      ,[Dose_3_Month]
      ,[Dose_3_Year]
	  ,[Dose_4_Day]
      ,[Dose_4_Month]
      ,[Dose_4_Year]
	  ,[Dose_5_Day]
      ,[Dose_5_Month]
      ,[Dose_5_Year]
      ,[emergency_housing]
      ,[full or restricted license]
      ,[GP_contacts]
      ,[Highest qualification: Level 0=1] as Qual_lvl_0
      ,[Highest qualification: Level 1=1] as Qual_lvl_1
      ,[Highest qualification: Level 2=1] as Qual_lvl_2
      ,[Highest qualification: Level 3=1]  as Qual_lvl_3
      ,[Highest qualification: Level 4-6=1] as Qual_lvl_4_to_6
      ,[Highest qualification: Level 7 and above=1] as Qual_lvl_7_plus
      ,[moh_disability_funded]
      ,[month_of_death]
      ,[Occupation_Cen2018]
      ,[offender_2020]
      ,[offender_2021]
      ,[OT_placement]
      ,[PHO enrolment]
      ,[residential_type_ind]
      ,[serious_mental_health]
      ,[Sex]
      ,[snz_birth_month_nbr]
      ,[snz_birth_year_nbr]
      ,[snz_ethnicity_grp1_nbr]
      ,[snz_ethnicity_grp2_nbr]
      ,[snz_ethnicity_grp3_nbr]
      ,[snz_ethnicity_grp4_nbr]
      ,[snz_ethnicity_grp5_nbr]
      ,[snz_ethnicity_grp6_nbr]
      ,[Tax_year_total_income]
      ,[victimisation_2020]
      ,[victimisation_2021]
      ,[year_of_death]
	  ,[ASD_Indicator_1]
	  ,[ID_Indicator]
	  ,[dv_comt]
      ,[dv_disability]
      ,[dv_hearing]
      ,[dv_remembering]
      ,[dv_seeing]
      ,[dv_walking]
      ,[dv_washing]
	  ,address_register_uid
	  ,Meshblock
	into #tmp_table1
  FROM [IDI_Sandpit].[DL-MAA2021-49].[tmp_vacc_rectangular] 



/* Clear existing table */
IF OBJECT_ID('[IDI_Sandpit].[DL-MAA2021-49].[tmp_202203_vacc_rectangular_20220405]', 'U') IS NOT NULL
	DROP TABLE [IDI_Sandpit].[DL-MAA2021-49].[tmp_202203_vacc_rectangular_20220405];

/* New table with some variables relabeled and others dropped (geography variables which are now created using the metadata tables */
SELECT  a.snz_uid
      ,[CIR_sequence_group]
      ,[COB_COC]
      ,[Craig_sole_parent_ind]
      ,[Current_HNZ_tenant_Dec21]
      ,[Dose_1_Day]
      ,[Dose_1_Month]
      ,[Dose_1_Year]
      ,[Dose_2_Day]
      ,[Dose_2_Month]
      ,[Dose_2_Year]
      ,[Dose_3_Day]
      ,[Dose_3_Month]
      ,[Dose_3_Year]
	  ,[Dose_4_Day]
      ,[Dose_4_Month]
      ,[Dose_4_Year]
	  ,[Dose_5_Day]
      ,[Dose_5_Month]
      ,[Dose_5_Year]
      ,[emergency_housing]
      ,[full or restricted license]
      ,[GP_contacts]
      , Qual_lvl_0
      ,Qual_lvl_1
      ,Qual_lvl_2
      ,Qual_lvl_3
      ,Qual_lvl_4_to_6
      ,Qual_lvl_7_plus
      ,[moh_disability_funded]
      ,[month_of_death]
      ,[Occupation_Cen2018]
      ,[offender_2020]
      ,[offender_2021]
      ,[OT_placement]
      ,[PHO enrolment]
      ,[residential_type_ind]
      ,[serious_mental_health]
      ,[Sex]
      ,[snz_birth_month_nbr]
      ,[snz_birth_year_nbr]
      ,[snz_ethnicity_grp1_nbr]
      ,[snz_ethnicity_grp2_nbr]
      ,[snz_ethnicity_grp3_nbr]
      ,[snz_ethnicity_grp4_nbr]
      ,[snz_ethnicity_grp5_nbr]
      ,[snz_ethnicity_grp6_nbr]
      ,[Tax_year_total_income]
      ,[victimisation_2020]
      ,[victimisation_2021]
      ,[year_of_death]
	  ,[ASD_Indicator_1]
	  ,[ID_Indicator]
	  ,[dv_comt]
      ,[dv_disability]
      ,[dv_hearing]
      ,[dv_remembering]
      ,[dv_seeing]
      ,[dv_walking]
      ,[dv_washing]
	  ,address_register_uid
	  ,Meshblock
	  ,b.chips
	  INTO [IDI_Sandpit].[DL-MAA2021-49].[tmp_202203_vacc_rectangular_20220405] 
	  from #tmp_table1 as a 
	  left join [IDI_Sandpit].[DL-MAA2021-49].[cw_202203_chips] as b on a.[address_register_uid] = b.[snz_idi_address_register_uid]


	  
  ALTER TABLE [IDI_Sandpit].[DL-MAA2021-49].[tmp_202203_vacc_rectangular_20220405] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE);

