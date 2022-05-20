/****** Script for SelectTopNRows command from SSMS  ******/
--VERSION: v8

--Author: Shaan Badenhorst
--Date: 2021/10/29
--Purpose: Create COVID-19 Immunisation Register table for feeding into Data Assembly Tool.
:setvar CIR_ref "moh_cir_vaccination_activity_20220405"
:setvar Adhoc_HSU_ref "moh_cir_hsu_20220405"
:setvar CIR_NHI_ref "moh_cir_nhi_20220405"
:setvar CIR_date 20220329

vacc_clean_moh_cir_vaccination_activity_20220405_202203




drop table #dhb_service_tmp

SELECT  snz_uid
,count([dhb_of_service]) as count_dhb
,[dhb_of_service]
into #dhb_service_tmp
FROM [IDI_Adhoc].[clean_read_MOH_CIR].[$(CIR_ref)] group by snz_uid, [dhb_of_service]

drop table #dhb_of_serv_tmp2
select snz_uid,
[dhb_of_service],
count_dhb,
rank() over (partition by snz_uid order by count_dhb desc) as rank 
into #dhb_of_serv_tmp2
from #dhb_service_tmp 


select top (100) * from #dhb_of_serv_tmp2 order by snz_uid

drop table #dhb_of_serv
select snz_uid,
[dhb_of_service]
into #dhb_of_serv
from #dhb_of_serv_tmp2 where rank = 1



-- 14 NULL values for vaccine administered;
-- 1 Covaxin;
-- 1 Novavax.
select count(*) as cnt, vaccine from [IDI_Adhoc].[clean_read_MOH_CIR].[$(CIR_ref)] group by vaccine


select top (10) activity_date from [IDI_Adhoc].[clean_read_MOH_CIR].[$(CIR_ref)] order by activity_date desc
--15/3/2022 using 20220322 tables.


-- dose numbers - as of 12/10/2021 no one had more than 2 doses recorded.
select count(*) as cnt, [dose_nbr] from [IDI_Adhoc].[clean_read_MOH_CIR].[$(CIR_ref)] group by [dose_nbr]

-- Create two new columns for dose 1 and dose 2
drop table #temp_CIR
SELECT	snz_moh_uid 
		,snz_uid
		,min(iif(dose_nbr = 1, activity_date, NULL)) as Dose_1_date
		,min(iif(dose_nbr = 2, activity_date, NULL)) as Dose_2_date
		,min(iif(dose_nbr = 3, activity_date, NULL)) as Dose_3_date
		,min(iif(dose_nbr = 4, activity_date, NULL)) as Dose_4_date
		,min(iif(dose_nbr = 5, activity_date, NULL)) as Dose_5_date
		,[sequence_group]
into #temp_CIR
FROM [IDI_Adhoc].[clean_read_MOH_CIR].[$(CIR_ref)]  group by snz_moh_uid, [sequence_group] , snz_uid




--select top (1000) * from  [IDI_Adhoc].[clean_read_MOH_CIR].[moh_cir_vaccination_activity_20220111]

--select * into #CIR_check_count1 from [IDI_Adhoc].[clean_read_MOH_CIR].[moh_cir_vaccination_activity_20220111] where snz_uid is not null

--select distinct snz_uid, dose_nbr, activity_date into #CIR_check_count2 from [IDI_Adhoc].[clean_read_MOH_CIR].[moh_cir_vaccination_activity_20220111] where snz_uid is not null
 

---- Create two new columns for dose 1 and dose 2
--drop table #temp_CIR_alt_method
--SELECT	snz_moh_uid 
--		,snz_uid
--		,min(iif(dose_nbr = 1, activity_date, NULL)) as Dose_1_date
--		,min(iif(dose_nbr = 2, activity_date, NULL)) as Dose_2_date
--		,min(iif(dose_nbr = 3, activity_date, NULL)) as Dose_3_date
--		,min(iif(dose_nbr = 4, activity_date, NULL)) as Dose_4_date
--		,min(iif(dose_nbr = 5, activity_date, NULL)) as Dose_5_date
--		,[sequence_group]
--		into #temp_CIR_alt_method
--FROM [IDI_Adhoc].[clean_read_MOH_CIR].[$(CIR_ref)] group by snz_moh_uid, [sequence_group] , snz_uid



drop table #tmp1
select distinct snz_uid into #tmp1 from #temp_CIR

drop table #tmp2
select distinct snz_moh_uid into #tmp2  from #temp_CIR
-- check these two numbers are similar

:setvar CIR_ref "moh_cir_vaccination_activity_20220405"
:setvar Adhoc_HSU_ref "moh_cir_hsu_20220405"
:setvar CIR_NHI_ref "moh_cir_nhi_20220405"
:setvar CIR_date 20220329

drop table #tmp_chk
select snz_moh_uid 
		,Dose_1_date
		,Dose_2_date
		,Dose_3_date
		,Dose_4_date
		,Dose_5_date
		,[sequence_group]
		,a.snz_uid
		,[dhb_of_service]
		,iif(a.snz_uid is not NULL, 1,0) as snz_uid_chk
		,iif(Dose_1_date is NULL, 1,0) as Dose_1_NULL_chk
into #tmp_chk from #temp_CIR as a left join #dhb_of_serv as b on a.snz_uid=b.snz_uid where a.snz_uid is not null

-- Check how many dose 1s are null ...
select count(*), Dose_1_NULL_chk from #tmp_chk group by Dose_1_NULL_chk

--select * from #tmp_chk where Dose_1_NULL_chk = 1


IF OBJECT_ID('[IDI_Sandpit].[DL-MAA2021-49].[vacc_clean_$(CIR_ref)_202203]', 'U') IS NOT NULL
	DROP TABLE [IDI_Sandpit].[DL-MAA2021-49].[vacc_clean_$(CIR_ref)_202203];
select   cast(day(Dose_1_date) as int) as Dose_1_Day
		,cast(month(Dose_1_date) as int)  as Dose_1_Month
		,cast(year(Dose_1_date) as int)  as Dose_1_Year
		,cast(day(Dose_2_date) as int)  as Dose_2_Day 
		,cast(month(Dose_2_date) as int)  as Dose_2_Month
		,cast(year(Dose_2_date) as int)  as Dose_2_Year
		,cast(day(Dose_3_date) as int)  as Dose_3_Day 
		,cast(month(Dose_3_date) as int)  as Dose_3_Month
		,cast(year(Dose_3_date) as int)  as Dose_3_Year
		,cast(day(Dose_4_date) as int)  as Dose_4_Day 
		,cast(month(Dose_4_date) as int)  as Dose_4_Month
		,cast(year(Dose_4_date) as int)  as Dose_4_Year
		,cast(day(Dose_5_date) as int)  as Dose_5_Day 
		,cast(month(Dose_5_date) as int)  as Dose_5_Month
		,cast(year(Dose_5_date) as int)  as Dose_5_Year
		,[sequence_group]
		,snz_uid
		,[dhb_of_service]
		,iif(snz_uid is not NULL, 1,0) as snz_uid_chk
		,iif(Dose_1_date is NULL, 1,0) as Dose_1_NULL_chk into [IDI_Sandpit].[DL-MAA2021-49].[vacc_clean_$(CIR_ref)_202203] from #tmp_chk
CREATE NONCLUSTERED INDEX my_index_name ON [IDI_Sandpit].[DL-MAA2021-49].[vacc_clean_$(CIR_ref)_202203] (snz_uid);




-- PERSONAL DETAILS FROM CIR TABLE AND HSU POPULATION DEATH DATA COLLECTED BELOW
drop table #temp_deets
--select top (1000) * from [IDI_Sandpit].[DL-MAA2021-49].[vacc_CIR]
SELECT		b.snz_moh_uid,
			[meshblock_2013],
			[dob_year],
			[dob_month],
			[gender_code],
			[ethnic_code_1],
			[ethnic_code_2],
			[ethnic_code_3],
			[priority_ethnic_code],
			b.snz_uid
			into #temp_deets
FROM ([IDI_Adhoc].[clean_read_MOH_CIR].[$(CIR_NHI_ref)] as a right join #tmp_chk as b
on a.snz_moh_uid = b.snz_moh_uid)


IF OBJECT_ID('[IDI_Sandpit].[DL-MAA2021-49].[vacc_202203_$(CIR_NHI_ref)]', 'U') IS NOT NULL
	DROP TABLE [IDI_Sandpit].[DL-MAA2021-49].[vacc_202203_$(CIR_NHI_ref)];

SELECT		a.snz_moh_uid,
			[meshblock_2013],
			[dob_year],
			[dob_month],
			[gender_code],
			[ethnic_code_1],
			[ethnic_code_2],
			[ethnic_code_3],
			[priority_ethnic_code],
			snz_uid,
			[MB2018_code]
INTO [IDI_Sandpit].[DL-MAA2021-49].[vacc_202203_$(CIR_NHI_ref)] 
FROM #temp_deets as a left join [IDI_Metadata].[clean_read_CLASSIFICATIONS].[meshblock_concordance] as b
on a.[meshblock_2013] = b.[MB2013_code]
CREATE NONCLUSTERED INDEX my_index_name ON [IDI_Sandpit].[DL-MAA2021-49].[vacc_202203_$(CIR_NHI_ref)] (snz_uid);
-- Note this table will have duplicates... will clean this up in Stata.




drop table [IDI_Sandpit].[DL-MAA2021-49].[HSU_death_data]
SELECT a.snz_uid
		,[dod_month] as [month_of_death]
		,[dod_year] as [year_of_death]
INTO [IDI_Sandpit].[DL-MAA2021-49].[HSU_death_data]
FROM [IDI_Sandpit].[DL-MAA2021-49].[cw_202203_pop_20210701_$(CIR_date)_uid] as a left join [IDI_Adhoc].[clean_read_MOH_CIR].[$(Adhoc_HSU_ref)] as b
on a.snz_uid = b.snz_uid










----------------------------------------
----------------------------------------
----------------------------------------



---- Historic checks:




--drop table #temp_sec_conc_snz_uids
--select distinct b.snz_uid
--into #temp_sec_conc_snz_uids from #temp_CIR as a left join [IDI_Clean_20211020].[security].[concordance] as b
--on a.snz_moh_uid = b.snz_moh_uid

--drop table #temp_sec_conc_snz_uids
--select distinct snz_uid
--into #temp_CIR_data_snz_uids from #temp_CIR as a left join [IDI_Clean_20211020].[security].[concordance] as b
--on a.snz_moh_uid = b.snz_moh_uid

--select distinct snz_uid into #chk_combined from (select snz_uid from #temp_CIR_snz_uids_CIRdata union all select snz_uid from #temp_CIR_snz_uids_v2) as a



---- Merge on snz_uids
--drop table #temp_CIR_snz_uids
--select distinct a.snz_moh_uid 
--		,Dose_1_date
--		,Dose_2_date
--		,Dose_3_date
--		,Dose_4_date
--		,[sequence_group]
--		,snz_uid
--into #temp_CIR_snz_uids from #temp_CIR as a left join [IDI_Clean_20211020].[security].[concordance] as b
--on a.snz_moh_uid = b.snz_moh_uid

--select distinct snz_uid into #SNZ_chk1 from #temp_CIR_snz_uids


--drop table #temp_CIR_snz_uids_v2
--select distinct a.snz_moh_uid 
--		,Dose_1_date
--		,Dose_2_date
--		,Dose_3_date
--		,Dose_4_date
--		,[sequence_group]
--		,a.snz_uid
--into #temp_CIR_snz_uids_v2 from #temp_CIR_snz_uids as a left join [IDI_Clean_20211020].[security].[concordance] as b
--on a.snz_moh_uid = b.snz_moh_uid

--select distinct snz_uid into #SNZ_chk2 from #temp_CIR_snz_uids_v2


--drop table #temp_CIR_snz_uids_v2
--select distinct a.snz_moh_uid 
--		,Dose_1_date
--		,Dose_2_date
--		,Dose_3_date
--		,Dose_4_date
--		,[sequence_group]
--		,a.snz_uid
--into #temp_CIR_snz_uids_v2 from #temp_CIR_snz_uids as a left join [IDI_Adhoc].[clean_read_MOH_CIR].[moh_cir_vaccination_activity_20211207] as b
--on a.snz_moh_uid = b.snz_moh_uid


---- Merge on snz_uids using CIR data
--drop table #temp_CIR_snz_uids
--select distinct a.snz_moh_uid 
--		,Dose_1_date
--		,Dose_2_date
--		,Dose_3_date
--		,Dose_4_date
--		,a.[sequence_group]
--		,snz_uid
--into #temp_CIR_snz_uids_CIRdata from #temp_CIR as a left join [IDI_Adhoc].[clean_read_MOH_CIR].[moh_cir_vaccination_activity_20211207] as b
--on a.snz_moh_uid = b.snz_moh_uid

--select distinct snz_uid into #check_temp_CIR_snz_uids_CIRdata from #temp_CIR_snz_uids_CIRdata

--select distinct snz_uid into #chk_combined from (select snz_uid from #temp_CIR_snz_uids_CIRdata union all select snz_uid from #temp_CIR_snz_uids_v2) as a



----select top(1000) * from #temp_CIR_snz_uids_v2

---- Create indicator for snz_uid being missing.
--drop table #tmp_chk
--select snz_moh_uid 
--		,Dose_1_date
--		,Dose_2_date
--		,Dose_3_date
--		,Dose_4_date
--		,[sequence_group]
--		,snz_uid
--		,iif(snz_uid is not NULL, 1,0) as snz_uid_chk
--		,iif(Dose_1_date is NULL, 1,0) as Dose_1_NULL_chk
--into #tmp_chk from #temp_CIR_snz_uids_v2 

