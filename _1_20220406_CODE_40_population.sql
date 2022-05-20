/****** Script for SelectTopNRows command from SSMS  ******/
--VERSION: v10

--Author: C Wright
--Date: 2021/10/29
--Purpose: Create COVID 19 population
--SNZ Estimated population
--V03 current version of denomoinator

-- Requires SQLCMD mode to be turned on for references to work

:setvar CIR_date 20220329
:setvar CIR_ref "moh_cir_vaccination_activity_20220405"
:setvar Adhoc_HSU_ref "moh_cir_hsu_20220405"

--AGE CUTOFF: 12/10/20211

--STage 1:
--ERP 
--MSD 
--HSU 
--CIR 
--Overseas spells arriving in NZ with no departure: 

--V03 
--v05 
--v05 
--v05

--V03 
--v05 

--include:
--1. SNZ_ERP for 2021 7 1
--1.a people with spells in the country who may be present but not with residents status
--2. MSD high frequecty load data spells in 2021
--3. IDI hsu for 2020 1 1 onwards
--XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
------3.a COVID vaccinations - add to population and add flag=0/1
--4. add spine and uids and moh indicators
--5. add dob,gender,dod
--6. add overseas flag - need to include the departure date
--6.1 last cir vaccination date is greater than last depart date
--7. create final table with target_population indicator = 1/0


--1. ERP 2021 

drop table ##erp_2021

SELECT [snz_uid],1 as y2021
into ##erp_2021
  FROM [IDI_Clean_202203].[data].[snz_res_pop]
    where year([srp_ref_date])=2021

--1.a non departing spells on the overseas spells tablw

--select distinct snz_uid 
--into #cus_nz
--from (
--SELECT snz_uid,pos_last_departure_ind,rank() over (partition by snz_uid order by pos_applied_date desc) as rank
--FROM [IDI_Clean_202203].[data].[person_overseas_spell] 
--) as a 
--where rank =1 and pos_last_departure_ind='n'


drop table ##cus_uid
drop table ##cus_uid_flag

SELECT distinct snz_uid
into ##cus_uid
FROM [IDI_Clean_202203].[data].[person_overseas_spell] 

SELECT distinct snz_uid
into ##cus_uid_flag
FROM [IDI_Clean_202203].[data].[person_overseas_spell] 
where pos_last_departure_ind='y'

drop table ##cus_nz

select a.snz_uid,case when b.snz_uid is not null then 0 else 1 end as nz
into ##cus_nz
from ##cus_uid as a left join ##cus_uid_flag as b 
on a.snz_uid=b.snz_uid


----2. MSD high frequecty load data spells for benefits ending in 2021
--drop table #msd_2021

--SELECT distinct b.[snz_uid]
--      --,a.[snz_msd_uid]
--      --,[serv]
--      --,[beg_date]
--      --,[end_date]
--	  into #msd_2021
--  FROM [IDI_Adhoc].[clean_read_MSD].[msd_sben_202107] as a , [IDI_Clean_202203].[security].[concordance] as b
--  where a.[snz_msd_uid]=b.[snz_msd_uid] and year([end_date]) =2021

--select distinct snz_uid from #msd_2021
--select distinct snz_msd_uid from [IDI_Adhoc].[clean_read_MSD].[msd_sben_202107]



--  select count(*) from #msd_2021

--3. IDI hsu for 2020 1 1 onwards
--All people receiving health data with services in IDI in 2020 and 2021
drop table ##moh_hsu
select distinct 
--a.snz_moh_uid,
snz_uid
into ##moh_hsu
from [IDI_Adhoc].[clean_read_MOH_CIR].[$(Adhoc_HSU_ref)] 

--SELECT distinct snz_moh_uid into #moh_uid_count FROM [IDI_Adhoc].[clean_read_MOH_CIR].[moh_cir_vaccination_activity_20220111]

----3.a covid 19 vaccination data
--drop table ##moh_cir1
--select distinct b.snz_uid, a.snz_moh_uid, case when b.[snz_spine_uid] is not null then 1 else 0 end as spine_ind 
--into ##moh_cir1
--from [IDI_Adhoc].[clean_read_MOH_CIR].[moh_cir_vaccination_activity_20220111] as a left join [IDI_Clean_202203].[security].[concordance] as b
--on a.snz_moh_uid = b.snz_moh_uid

--select distinct snz_moh_uid into #cnt_moh_uids from [IDI_Adhoc].[clean_read_MOH_CIR].[moh_cir_vaccination_activity_20220111]

--select top (1000) count(*) as cnt_snz_uid, snz_moh_uid from ##moh_cir1 group by snz_moh_uid order by cnt_snz_uid desc

--select top (1000) count(*) as cnt_snz_uid, spine_ind from ##moh_cir1 group by spine_ind 


drop table ##moh_cir2
select distinct a.snz_uid, a.snz_moh_uid, case when b.[snz_spine_uid] is not null then 1 else 0 end as spine_ind 
into ##moh_cir2
from  [IDI_Adhoc].[clean_read_MOH_CIR].[$(CIR_ref)] as a left join [IDI_Clean_202203].[security].[concordance] as b
on a.snz_uid = b.snz_uid

select top (1000) count(*) as cnt_snz_uid, spine_ind from ##moh_cir2 group by spine_ind 

-- Need to do a join to exclude these snz_uids from ##moh_cir2 and then combine ##moh_cir2 and ##moh_cir1
--drop table ##moh_cir_combined
--select distinct snz_uid, snz_moh_uid
--into ##moh_cir_combined
--from  (select snz_uid, snz_moh_uid from ##moh_cir2 where spine_ind = 1 union all select snz_uid, snz_moh_uid from ##moh_cir1  where spine_ind = 1) as a 
-- CIR1 doesn't add any additional people -> using SNZ linked UID's covers all potential spine_linked folk.



drop table ##denom
select distinct snz_uid 
into ##denom
from (
select snz_uid from ##erp_2021
UNION ALL
--select snz_uid from #msd_2021
--UNION ALL
select snz_uid from ##moh_hsu
UNION ALL
--any body with border spells putting them in NZ
select snz_uid from ##cus_nz where nz=1
UNION ALL
select snz_uid from ##moh_cir2 where spine_ind = 1

) as a

--drop table ##denom
--select distinct snz_uid 
--into ##denom
--from (
--select snz_uid from ##erp_2021
--UNION ALL
----select snz_uid from #msd_2021
----UNION ALL
--select snz_uid from ##moh_hsu
--UNION ALL
----any body with border spells putting them in NZ
--select snz_uid from ##cus_nz where nz=1
--UNION ALL
--select snz_uid from ##moh_cir1 where spine_ind = 1
--UNION ALL
----any body with border spells putting them in NZ
--select snz_uid from ##moh_cir2 where spine_ind = 1
--) as a



--EXLUDED as no longer needed
--drop table #denom_2

--select a.snz_uid,b.uids,b.moh,b.spine,b.msd
--into #denom_2
--from #denom as a , [IDI_Sandpit].[DL-MAA2021-49].[cw_202203_security_concordance] as b
--where a.snz_uid=b.snz_uid

--select count(*) from #denom_2 where moh=0

--add sex dob ethnic groups

drop table if exists #denom_3

select a.*
  ,[snz_sex_gender_code]
  ,[snz_birth_year_nbr]
  ,[snz_birth_month_nbr]
  ,[snz_birth_date_proxy]
  ,[snz_ethnicity_grp1_nbr]
  ,[snz_ethnicity_grp2_nbr]
  ,[snz_ethnicity_grp3_nbr]
  ,[snz_ethnicity_grp4_nbr]
  ,[snz_ethnicity_grp5_nbr]
  ,[snz_ethnicity_grp6_nbr]
  ,[snz_deceased_year_nbr]
  ,[snz_deceased_month_nbr]
  ,datefromparts([snz_deceased_year_nbr],[snz_deceased_month_nbr],1) as dod
into #denom_3
from ##denom as a ,[IDI_Clean_202203].[data].[personal_detail] as b
where a.snz_uid=b.snz_uid

select top 100 * from #denom_3

--6. observed departing NZ with no return	and include whether they 
drop table #dol_depart
SELECT distinct		[snz_uid]
					,1 as last_observed_departing
					,[pos_applied_date] as last_depart_date
					into #dol_depart
FROM [IDI_Clean_202203].[data].[person_overseas_spell] 
WHERE year([pos_ceased_date]) = 9999 and snz_uid is not null and pos_last_departure_ind='y'

drop table #denom_4

select a.*,case when b.last_observed_departing=1 then 1 else 0 end as last_observed_departing,
case when c.snz_uid is not null then 1 else 0 end as cir_202203
,last_depart_date
into #denom_4
from #denom_3 as a left join #dol_depart as b
on a.snz_uid=b.snz_uid
left join ##moh_cir2 as c 
on a.snz_uid=c.snz_uid

select top 100 * from #denom_4

drop table #cir_ld
--6.1 last CIR vaccination date and indicator for being a linked snz_uid
SELECT snz_uid 
  ,max([activity_date]) as last_vaccination_date
  ,1 as linked_snz_uid
into #cir_ld
FROM [IDI_Adhoc].[clean_read_MOH_CIR].[$(CIR_ref)] 
group by snz_uid

drop table #denom_5
select a.*,b.last_vaccination_date, linked_snz_uid
into #denom_5
from #denom_4 as a full outer join #cir_ld as b
on a.snz_uid=b.snz_uid

--	select * from #denom_5 ORDER BY last_vaccination_date desc

--7. final population table 


--exclusions
--a. spine
--b. no dod
--c. in NZ = (no last departing date or last vacc date is greater than last deppart date)

drop table #spine_check
select distinct  a.snz_uid, case when snz_spine_uid IS NOT NULL then  1 else 0 end as spine into #spine_check 
from #denom_5 as a LEFT JOIN  [IDI_Clean_202203].[security].[concordance] as b on a.snz_uid = b.snz_uid


drop table [IDI_Sandpit].[DL-MAA2021-49].[cw_202203_pop_$(CIR_date)]
-- Now keeping people who are not on the spine IFF they have been linked by stats specifically for the MOH work.
select a.* 
,case when spine=0 and linked_snz_uid is null then 0
when dod is not null then 0 
when last_observed_departing=1 and cir_202203=0 then 0
when last_observed_departing=1 and cir_202203=1 and last_depart_date>=last_vaccination_date then 0
when last_observed_departing=1 and cir_202203=1 and last_depart_date<last_vaccination_date then 1
else 1
end as target_population
,case when dod is not null then 1 else 0 end as died
into [IDI_Sandpit].[DL-MAA2021-49].[cw_202203_pop_$(CIR_date)]
from #denom_5 as a LEFT JOIN #spine_check as b
on a.snz_uid = b.snz_uid

--select count(*) as counter_snz_uid  from [IDI_Sandpit].[DL-MAA2021-49].[cw_202203_pop_v10] where last_observed_departing=1 and last_depart_date>=last_vaccination_date and linked_snz_uid = 1
---- people dropped due to being observed leaving the country after their latest vaccination record.

--select count(*) as counter_snz_uid  from [IDI_Sandpit].[DL-MAA2021-49].[cw_202203_pop_v10] where died =1 and linked_snz_uid = 1
---- people dropped due to death.

--select count(*) as counter_snz_uid, linked_snz_uid, target_population  from [IDI_Sandpit].[DL-MAA2021-49].[cw_202203_pop_v10] group by linked_snz_uid, target_population

--
--select distinct snz_uid into #cnt_snz_uids from [IDI_Sandpit].[DL-MAA2021-49].[cw_202203_pop_20210701_v09_uid]

--drop table #cnt_snz_uids2
--select snz_uid into #cnt_snz_uids2 from [IDI_Sandpit].[DL-MAA2021-49].[cw_202203_pop_v09] where target_population=1

drop table [IDI_Sandpit].[DL-MAA2021-49].[cw_202203_pop_20210701_$(CIR_date)_uid]

select snz_uid 
into [IDI_Sandpit].[DL-MAA2021-49].[cw_202203_pop_20210701_$(CIR_date)_uid]
from [IDI_Sandpit].[DL-MAA2021-49].[cw_202203_pop_$(CIR_date)]
where target_population=1

create index index_pop_v10_uid
on [IDI_Sandpit].[DL-MAA2021-49].[cw_202203_pop_20210701_$(CIR_date)_uid] (snz_uid);

select * from [IDI_Sandpit].[DL-MAA2021-49].[cw_202203_pop_20210701_$(CIR_date)_uid]
--final data table and population flag
--select * from [IDI_Sandpit].[DL-MAA2021-49].[cw_202203_pop_v05]
--where target_population=1 and last_depart_date<last_vaccination_date and last_depart_date is not null and last_vaccination_date is not null



/*


--- Checking pop size with updated HSU

select snz_uid, case when snz_spine_uid IS NOT NULL then  1 else 0 end as spine into #spine_check from [IDI_Clean_202203].[security].[concordance]

select a.* 
,case when spine=0 then 0
when dod is not null then 0 
when last_observed_departing=1 and cir_20102021=0 then 0
when last_observed_departing=1 and cir_20102021=1 and last_depart_date>=last_vaccination_date then 0
when last_observed_departing=1 and cir_20102021=1 and last_depart_date<last_vaccination_date then 1
else 1
end as target_population
,case when dod is not null then 1 else 0 end as died
into #pop_check
from #denom_5 as a LEFT JOIN #spine_check as b
on a.snz_uid = b.snz_uid

select snz_uid 
into #pop_check2
from #pop_check
where target_population=1

*/