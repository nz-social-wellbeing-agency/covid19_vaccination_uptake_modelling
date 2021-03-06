/**************************************************************************************************
Title: Tax year income summary
Author: Simon Anastasiadis, Modified for Nga Tapuae by Joel Bancolita
Reviewer:

Acknowledgements:
Informatics for Social Services and Wellbeing (terourou.org) supported the publishing of these definitions

Inputs & Dependencies:
- [IDI_Clean].[data].[income_tax_yr_summary]
Outputs:
- [IDI_UserCode].[DL-MAA2021-49].[vacc_income_tax_year]

Intended use: Calculating annual income from different sources and in grand total.
Summary of income for each tax year.
 
Notes:
1) Following a conversatiON with a staff member FROMIRD we were advised to use
   - IR3 data where possible.
   - PTS data where IR3 is not available
   - EMS date where IR3 and PTS are not available.
2) A comparison of total incomes from these three sources showed excellent consistency
   between [ir_ir3_gross_earnings_407_amt], [ir_pts_tot_gross_earnings_amt], [ir_ems_gross_earnings_amt]
   with more than 90% of our sample of records having identical values across all three.
3) However, rather than combine IR3, PTS and EMS ourselves we use the existing [income_tax_yr_summary]
   table AS it addresses the same concern and is already a standard table.
4) Unlike EMS where W&S and WHP are reported directly, the tax year summary table re-assigns some
   W&S and WHP to the S0*, P0*, C0* categories. Hence sum(WHP) FROM tax year summary will not be
   consistent with sum(WHP) FROMIRD-EMS. You can see in the descriptions that S/C/P01 have PAYE
   and hence will (probably) appear in IRD-EMS AS W&S, while S/C/P02 have WHT deducted and hence
   will (probably) appear in IRD-EMS AS WHP.

Parameters & Present values:
  Current refresh = IDI_Clean_20211020
  Prefix = vacc_
  Project schema = [DL-MAA2021-49]
 
Issues:
- IR3 records in the IDI do not capture all income reported to IRD via IR3 records. AS per the data
  dictionary only "active items that have non-zero partnership, self-employment, or shareholder salary
  income" are included. So people with IR3 income that is of a different type (e.g. rental income)
  may not appear in the data.
 
History (reverse order):
2021-08-31 MP modifications for vaccine rollout modelling (MP), partner w. income removed, and non-banded numeric income measure added
2020-07-02 JB modifications for NT
2020-03-02 SA v1
**************************************************************************************************/

/* Establish database for writing views */
USE IDI_UserCode
GO

/* Wages and salaries by tax year */
DROP VIEW IF EXISTS [DL-MAA2021-49].[vacc_income_tax_year];
GO

CREATE VIEW [DL-MAA2021-49].[vacc_income_tax_year] AS
SELECT [snz_uid]
	,[inc_tax_yr_sum_year_nbr]
	,DATEFROMPARTS([inc_tax_yr_sum_year_nbr], 3, 31) AS [event_date]
	,DATEFROMPARTS([inc_tax_yr_sum_year_nbr], 1, 1) AS [start_date]
	,DATEFROMPARTS([inc_tax_yr_sum_year_nbr], 12, 31) AS [end_date]
	,[inc_tax_yr_sum_WAS_tot_amt] /* wages & salaries */
	,[inc_tax_yr_sum_WHP_tot_amt] /* withholding payments (schedular payments with withholding taxes) */
	,[inc_tax_yr_sum_BEN_tot_amt] /* benefits */
	,[inc_tax_yr_sum_ACC_tot_amt] /* ACC claimants compensatiON */
	,[inc_tax_yr_sum_PEN_tot_amt] /* pensions (superannuation) */
	,[inc_tax_yr_sum_PPL_tot_amt] /* Paid parental leave */
	,[inc_tax_yr_sum_STU_tot_amt] /* Student allowance */
	,[inc_tax_yr_sum_C00_tot_amt] /* Company director/shareholder income FROMIR4S */
	,[inc_tax_yr_sum_C01_tot_amt] /* Comapny director/shareholder receiving PAYE deducted income */
	,[inc_tax_yr_sum_C02_tot_amt] /* Company director/shareholder receiving WHT deducted income */
	,[inc_tax_yr_sum_P00_tot_amt] /* Partnership income FROMIR20 */
	,[inc_tax_yr_sum_P01_tot_amt] /* Partner receiving PAYE deducted income */
	,[inc_tax_yr_sum_P02_tot_amt] /* Partner receiving withholding tax deducted income */
	,[inc_tax_yr_sum_S00_tot_amt] /* Sole trader income FROMIR3 */
	,[inc_tax_yr_sum_S01_tot_amt] /* Sole Trader receiving PAYE deducted income */
	,[inc_tax_yr_sum_S02_tot_amt] /* Sole trader receiving withholding tax deducted income */
	,[inc_tax_yr_sum_S03_tot_amt] /* Rental income FROMIR3 */
	,[inc_tax_yr_sum_all_srces_tot_amt] AS [total_income]
	,CASE 
		WHEN [inc_tax_yr_sum_all_srces_tot_amt] < 0 THEN 'income: Loss'
		WHEN [inc_tax_yr_sum_all_srces_tot_amt] = 0 THEN 'income: Zero'
		WHEN [inc_tax_yr_sum_all_srces_tot_amt] BETWEEN     0 AND  5000 THEN 'income: 0 to 5000'
		WHEN [inc_tax_yr_sum_all_srces_tot_amt] BETWEEN  5000 AND 10000 THEN 'income: 5000 to 10000'
		WHEN [inc_tax_yr_sum_all_srces_tot_amt] BETWEEN 10000 AND 15000 THEN 'income: 10000 to 15000'
		WHEN [inc_tax_yr_sum_all_srces_tot_amt] BETWEEN 15000 AND 20000 THEN 'income: 15000 to 20000'
		WHEN [inc_tax_yr_sum_all_srces_tot_amt] BETWEEN 20000 AND 25000 THEN 'income: 20000 to 25000'
		WHEN [inc_tax_yr_sum_all_srces_tot_amt] BETWEEN 25000 AND 30000 THEN 'income: 25000 to 30000'
		WHEN [inc_tax_yr_sum_all_srces_tot_amt] BETWEEN 30000 AND 35000 THEN 'income: 30000 to 35000'
		WHEN [inc_tax_yr_sum_all_srces_tot_amt] BETWEEN 35000 AND 40000 THEN 'income: 35000 to 40000'
		WHEN [inc_tax_yr_sum_all_srces_tot_amt] BETWEEN 40000 AND 50000 THEN 'income: 40000 to 50000'
		WHEN [inc_tax_yr_sum_all_srces_tot_amt] BETWEEN 50000 AND 60000 THEN 'income: 50000 to 60000'
		WHEN [inc_tax_yr_sum_all_srces_tot_amt] BETWEEN 60000 AND 70000 THEN 'income: 60000 to 70000'
		WHEN [inc_tax_yr_sum_all_srces_tot_amt] BETWEEN 70000 AND 80000 THEN 'income: 70000 to 80000'
		WHEN [inc_tax_yr_sum_all_srces_tot_amt] BETWEEN 80000 AND 90000 THEN 'income: 80000 to 90000'
		WHEN [inc_tax_yr_sum_all_srces_tot_amt] BETWEEN 90000 AND 100000 THEN 'income: 90000 to 100000'
		WHEN [inc_tax_yr_sum_all_srces_tot_amt] > 100000 THEN 'income: above 100000'
		ELSE 'income: unclassified' END AS [description]
FROM [IDI_Clean_20211020].[data].[income_tax_yr_summary]
WHERE year([inc_tax_yr_sum_year_nbr]) = 2020;
GO
