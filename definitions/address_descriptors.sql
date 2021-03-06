/**************************************************************************************************
Title: Neighbourhood descriptors
Author: Simon Anastasiadis, Marianna Pekar, Shaan Badenhorst
Review: Simon Anastasiadis

Acknowledgements:
Informatics for Social Services and Wellbeing (terourou.org) supported the publishing of these definitions

Inputs & Dependencies:
- [IDI_Clean].[data].[address_notification]
- [IDI_Metadata].[clean_read_CLASSIFICATIONS].[meshblock_concordance_2019]
- [IDI_Metadata].[clean_read_CLASSIFICATIONS].[meshblock_current_higher_geography]
- [IDI_Metadata].[clean_read_CLASSIFICATIONS].[DepIndex2018_MB2018]
Outputs:
- [IDI_Sandpit].[DL-MAA2021-49].[vacc_addr_desc]

Description:
Summary description of a person's neighbourhood including: urban/rural, meshblock, SA2, TA, region,
deprivation

Intended purpose:
Identifying the region, urban/rural-ness, and other characteristics of where a person lives
at a specific point in time.

Notes:
1) Address information in the IDI is not of sufficient quality to determine who shares an
   address. We would also be cautious about claiming that a person lives at a specific
   address on a specific date. However, we are confident using address information for the
   purpose of "this location has the characteristics of the place this person lives", and
   "this person has the characteristics of the people who live in this location".
2) Despite the limitations of address, it is the best source for determining whether a person
   lives in a household with dependent children. Hence, we use it for this purpose. However
   we note that this is a low quality measure.
3) The year of the meshblock codes used for the address notification could not be found in
   data documentation. A quality of range of different years/joins were tried the final
   choice represents the best join available at time of creation.
   Another cause for this join being imperfect is not every meshblock contains residential
   addresses (e.g. some CBD areas may contain hotels but not residential addresses, and
   some meshblocks are uninhabited - such as mountains or ocean areas).
   Re-assessment of which meshblock code to use for joining to address_notifications
   is recommended each refresh.
4) For simplicity this table considers address at a specific date.

Parameters & Present values:
  Current refresh = 20211020
  Prefix = vacc_
  Project schema = DL-MAA2021-49
  Date of interest = '2021-10-13'
 
Issues:

History (reverse order):
2021-11-25 SA review and tidy
2021-10-29 SB version for vaccination analysis
2021-09-02 MP incorporate Census 2018 information and updated geographical concordance information
2020-03-03 SA v1
**************************************************************************************************/

USE IDI_UserCode
GO

/* Clear existing table */
DROP TABLE IF EXISTS [IDI_Sandpit].[DL-MAA2021-49].[vacc_addr_read];
GO

/* Create definition */
SELECT [snz_uid]
	,a.[ant_notification_date]
	,a.[ant_replacement_date]
	,a.[snz_idi_address_register_uid]
	,CAST(a.[ant_ta_code] AS INTEGER) AS [ant_ta_code]
	,CAST(a.[ant_region_code] AS INTEGER) AS [ant_region_code]
	,CAST(a.[ant_meshblock_code] AS INTEGER) AS [ant_meshblock_code]
	,b.[IUR2018_V1_00] -- urban/rural classification
	,b.[IUR2018_V1_00_NAME]
	,CAST(b.[SA22018_V1_00] AS INT) AS [SA22018_V1_00]	-- Statistical Area 2 (neighbourhood)
	,b.[SA22018_V1_00_NAME]
	,CAST(b.[SA12018_V1_00] AS INT) AS [SA12018_V1_00]	-- Statistical Area 1
	,b.[SA12018_V1_00_NAME]
	,CAST(b.[DHB2015_V1_00] AS INT) AS [DHB2015_V1_00]	-- DHB 
    ,b.[DHB2015_V1_00_NAME]
	,CAST(c.[NZDep2018] AS INTEGER) AS [NZDep2018]
	,c.[NZDep2018_Score]
INTO [IDI_Sandpit].[DL-MAA2021-49].[vacc_addr_read]
FROM [IDI_Clean_20211020].[data].[address_notification] AS a
INNER JOIN [IDI_Metadata].[clean_read_CLASSIFICATIONS].[meshblock_concordance_2019] AS conc
ON conc.[MB2019_code] = a.[ant_meshblock_code]	-- Checked, the number of MBs in meshblock_concordance_2019 and higher_geography_2020_V1_00 are the same
LEFT JOIN [IDI_Metadata].[clean_read_CLASSIFICATIONS].[meshblock_current_higher_geography] AS b
ON conc.[MB2018_code] = b.[MB2018_V1_00]
LEFT JOIN [IDI_Metadata].[clean_read_CLASSIFICATIONS].[DepIndex2018_MB2018] AS c -- Updated to 2018 Dep Index
ON conc.[MB2018_code] = c.[MB2018_code]
WHERE a.[ant_meshblock_code] IS NOT NULL 
AND '2021-10-13' BETWEEN [ant_notification_date] AND [ant_replacement_date]
GO

/* index */
CREATE NONCLUSTERED INDEX my_index_name ON [IDI_Sandpit].[DL-MAA2021-49].[vacc_addr_read] (snz_uid);
GO
