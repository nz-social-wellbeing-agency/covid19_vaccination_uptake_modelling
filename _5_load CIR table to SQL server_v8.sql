/*
Loading CIR table from CSV to SQL server
Author: Simon Anastasiadis


File history:
2021-10-26 SA version 1
*/

/************************************************
Create empty table
*************************************************
This command requires one row for each column in the input file.
When updating, I recommend copying the column names from Excel directly
into this file. Best practice is for column names to use underscores ("_")
instead of spaces (" ") and to not contain any special characters.

The number in brackets after CHAR or VARCHAR is the maximum number of characters
for the column. Current values are based of the original input file. Importing
will likely fail if a cell contains more characters than allowed.
You can use the LEN() function in Excel to check the number of characters in a
cell should you need to update the size of these columns.
*/
drop table [IDI_Sandpit].[DL-MAA2021-49].[collaboration_ready_CIR20220329_UPLD20220414]

CREATE TABLE [IDI_Sandpit].[DL-MAA2021-49].[collaboration_ready_CIR20220329_UPLD20220414] (
snz_uid  INT ,
ASD_Indicator_1  INT ,
Birth_month  INT ,
Birth_year  INT ,
CIR_sequence_group  INT ,
COB_COC  INT ,
Current_HNZ_tenant_Dec21  INT ,
Decile  INT ,
DHB  VARCHAR(30) ,
EducationRegion  VARCHAR(30) ,
Enrolled_student  INT ,
GP_contacts  INT ,
ID_Indicator  INT ,
MOH_age_cats  VARCHAR(10) ,
MOH_age_grp  VARCHAR(10) ,
Meshblock  INT ,
OT_placement  INT ,
Occupation_Cen2018  INT ,
Offender_2020_2021  INT ,
PHO_enrolment  INT ,
Police_int_2020or2021  INT ,
Qual_lvl_0  INT ,
Qual_lvl_1  INT ,
Qual_lvl_2  INT ,
Qual_lvl_3  INT ,
Qual_lvl_4_to_6  INT ,
Qual_lvl_7_plus  INT ,
SchoolType  VARCHAR(45) ,
Sex  INT ,
T1Ben_20  INT ,
T1Ben_30  INT ,
T1Ben_180  INT ,
T1Ben_181  INT ,
T1Ben_313  INT ,
T1Ben_320  INT ,
T1Ben_365  INT ,
T1Ben_370  INT ,
T1Ben_603  INT ,
T1Ben_607  INT ,
T1Ben_611  INT ,
T1Ben_675  INT ,
T1Ben_Any_indicator  INT ,
T2Ben_40  INT ,
T2Ben_44  INT ,
T2Ben_64  INT ,
T2Ben_65  INT ,
T2Ben_340  INT ,
T2Ben_344  INT ,
T2Ben_425  INT ,
T2Ben_450  INT ,
T2Ben_460  INT ,
T2Ben_471  INT ,
T2Ben_472  INT ,
T2Ben_473  INT ,
T2Ben_474  INT ,
T2Ben_500  INT ,
T2Ben_833  INT ,
T2Ben_835  INT ,
T2Ben_836  INT ,
T2Ben_838  INT ,
T2Ben_Any_indicator  INT ,
Tax_year_total_income  FLOAT ,
tertiary_provider_code  INT ,
tec_it_provider_code  INT ,
Victimisation_2020_2021  INT ,
address_register_uid  INT ,
age  FLOAT ,
age_1_wk_ago  INT ,
age_2_wk_ago  INT ,
age_3_wk_ago  INT ,
age_4_wk_ago  INT ,
age_5_wk_ago  INT ,
age_6_wk_ago  INT ,
age_7_wk_ago  INT ,
age_8_wk_ago  INT ,
age_9_wk_ago  INT ,
age_10_wk_ago  INT ,
age_11_wk_ago  INT ,
age_12_wk_ago  INT ,
age_13_wk_ago  INT ,
age_14_wk_ago  INT ,
age_15_wk_ago  INT ,
age_16_wk_ago  INT ,
age_17_wk_ago  INT ,
age_18_wk_ago  INT ,
age_19_wk_ago  INT ,
age_20_wk_ago  INT ,
age_21_wk_ago  INT ,
age_22_wk_ago  INT ,
age_23_wk_ago  INT ,
agegrp9  VARCHAR(45) ,
agegrp11  VARCHAR(45) ,
age_5yr_bands  VARCHAR(45) ,
age_grps  VARCHAR(45) ,
age_grps_v2  VARCHAR(45) ,
age_5yr_grps  VARCHAR(45) ,
chips  INT ,
corrections_experience  INT ,
date_of_interest2  DATE ,
dob  DATE ,
dv_comt  INT ,
dv_disability  INT ,
dv_hearing  INT ,
dv_remembering  INT ,
dv_seeing  INT ,
dv_walking  INT ,
dv_washing  INT ,
emergency_housing  INT ,
enrolled_prim_secondary  INT ,
enrolled_tec_it_training  INT ,
enrolled_tertiary  INT ,
floor_age  INT ,
full_or_restricted_license  INT ,
gch  VARCHAR(45) ,
hhn  INT ,
highest_qualification  VARCHAR(45)  ,
iur2018_v1_00  INT ,
iur2018_v1_00_name  VARCHAR(45) ,
maorimedium  VARCHAR(45)  ,
moh_disability_funded  INT ,
nzdep2018  INT ,
offender_2020  INT ,
offender_2021  INT ,
ors  INT ,
prim_sec_provider_code  INT ,
regc2018_v1_00  INT ,
regc2018_v1_00_name  VARCHAR(45) ,
residential_type_ind  INT ,
sa12018_v1_00  INT ,
sa12018_v1_00_name  VARCHAR(45) ,
sa22018_v1_00  INT ,
sa22018_v1_00_name  VARCHAR(45) ,
snz_ethnicity_grp1_nbr  INT ,
snz_ethnicity_grp2_nbr  INT ,
snz_ethnicity_grp3_nbr  INT ,
snz_ethnicity_grp4_nbr  INT ,
snz_ethnicity_grp5_nbr  INT ,
snz_ethnicity_grp6_nbr  INT ,
ta2018_v1_00  INT ,
ta2018_v1_00_name  VARCHAR(45) ,
tax_inc_A2020toM2021_cats  VARCHAR(45) ,
tmp_date_wk_1  DATE ,
tmp_date_wk_2  DATE ,
tmp_date_wk_3  DATE ,
tmp_date_wk_4  DATE ,
tmp_date_wk_5  DATE ,
tmp_date_wk_6  DATE ,
tmp_date_wk_7  DATE ,
tmp_date_wk_8  DATE ,
tmp_date_wk_9  DATE ,
tmp_date_wk_10  DATE ,
tmp_date_wk_11  DATE ,
tmp_date_wk_12  DATE ,
tmp_date_wk_13  DATE ,
tmp_date_wk_14  DATE ,
tmp_date_wk_15  DATE ,
tmp_date_wk_16  DATE ,
tmp_date_wk_17  DATE ,
tmp_date_wk_18  DATE ,
tmp_date_wk_19  DATE ,
tmp_date_wk_20  DATE ,
tmp_date_wk_21  DATE ,
tmp_date_wk_22  DATE ,
tmp_date_wk_23  DATE ,
victimisation_2020  INT ,
victimisation_2021  INT ,
dose_count_tot_0  INT ,
dose_count_tot_1  INT ,
dose_count_tot_2  INT ,
dose_count_tot_3  INT ,
dose_count_tot_4  INT ,
dose_count_tot_5  INT ,
dose_count_tot_6  INT ,
dose_count_tot_7  INT ,
dose_count_tot_8  INT ,
dose_count_tot_9  INT ,
dose_count_tot_10  INT ,
dose_count_tot_11  INT ,
dose_count_tot_12  INT ,
dose_count_tot_13  INT ,
dose_count_tot_14  INT ,
dose_count_tot_15  INT ,
dose_count_tot_16  INT ,
dose_count_tot_17  INT ,
dose_count_tot_18  INT ,
dose_count_tot_19  INT ,
dose_count_tot_20  INT ,
dose_count_tot_21  INT ,
dose_count_tot_22  INT ,
dose_count_tot_23  INT ,
dose_count_tot_24  INT ,
dose_count_tot_25  INT ,
dose_count_tot_26  INT ,
dose_count_tot_27  INT ,
dose_count_tot_28  INT ,
dose_count_tot_29  INT ,
dose_count_tot_30  INT ,
dose_count_tot_31  INT ,
dose_count_tot_32  INT ,
dose_count_tot_33  INT ,
dose_count_tot_34  INT ,
dose_count_tot_35  INT ,
dose_count_tot_36  INT ,
dose_count_tot_37  INT ,
dose_count_tot_38  INT ,
dose_count_tot_39  INT ,
dose_count_tot_40  INT ,
dose_count_tot_41  INT ,
dose_count_tot_42  INT ,
dose_count_tot_43  INT ,
dose_count_tot_44  INT ,
dose_count_tot_45  INT ,
dose_count_tot_46  INT ,
dose_count_tot_47  INT ,
dose_count_tot_48  INT ,
dose_count_tot_49  INT ,
dose_count_tot_50  INT ,
dose_count_tot_51  INT ,
dose_count_tot_52  INT ,
dose_count_tot_53  INT ,
dose_count_tot_54  INT ,
dose_count_tot_55  INT ,
dose_count_tot_56  INT ,
dose_count_tot_57  INT ,
dose_count_tot_58  INT ,
dose_count_tot_59  INT ,
serious_mental_health  INT ,

);
GO

/************************************************
Read data file in to SQL
*************************************************
SQL Server requires the full file path when working on a network drive. It can not
use drive mappings. So "I:\my folder\my file.txt" will fail if "I:" is a network location.
Instead you will need to enter the drive name "\\drive\drive folder\my folder\my file.txt".

DATAFILETYPE = 'widechar' and CODEPAGE = '65001' are the settings for reading Unicode files.
FIRSTROW = 2 indicates that the data starts on row 2, because row 1 is column names.
FIELDTERMINATOR = '\t' indicates that the file is tab seperated.
*/
BULK INSERT [IDI_Sandpit].[DL-MAA2021-49].[collaboration_ready_CIR20220329_UPLD20220414]
FROM '\\prtprdsasnas01\DataLab\MAA\MAA2021-49\Cross-agency collaboration\Dataset creation\upload csv to sql\CIR_20220329_collab_dataset_20220407.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FORMAT = 'CSV'
);
GO

/************************************************
Compress and index the table
************************************************/
/* Add index */
CREATE NONCLUSTERED INDEX my_index_name ON [IDI_Sandpit].[DL-MAA2021-49].[collaboration_ready_CIR20220329_UPLD20220414] (snz_uid);
GO

/* Compress final table to save space */
ALTER TABLE [IDI_Sandpit].[DL-MAA2021-49].[collaboration_ready_CIR20220329_UPLD20220414] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE);
GO

/************************************************
View table contents to confirm performance
************************************************/
SELECT TOP 1000 *
FROM [IDI_Sandpit].[DL-MAA2021-49].[collaboration_ready_CIR20220329_UPLD20220414]
