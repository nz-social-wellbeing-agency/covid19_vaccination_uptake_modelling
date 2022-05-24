# CIR Vaccination Uptake Data Development Process

Construction of the COVID19 vaccination update dataset.

Repositry: covid19_vaccination_update_modelling

## Overview

To understand vaccination patterns and support all New Zealanders getting vaccinated, the Social Wellbeing Agency undertook analysis of COVID19 vaccination uptake in the IDI. As part of this research, we recreated the vaccination research dataset each time new vaccination data was provided by the Ministry of Health.

To support the efforts of other researchers, we made this research dataset available to other researchers. This improved consistency across research projects and saved time by reducing duplication. This repositry contains the code to build the research dataset we used, so that future researchers might benefit.

## Instructions to assemble vaccination dataset

It is necessary to have an IDI project if you wish to run the code.  Visit the Stats NZ website for more information about this. 

This analysis has been developed for a particular refresh of the IDI. As changes in database structure can occur between refreshes, the initial preparation of the input information may require updating to run the code in other refreshes.

#### Definitions

1)  Execute all the input definitions

    All the underlying data definitions used in the assembly process (steps 4-6) must have been created prior to the data assembly. Depending on what measures you need for your analysis, you may not need to run every definition in the **definitions** folder. These definitions do __not__ need to be rerun when the input population or immunisation record is updated.

#### SQL table updates

2)  Population creation & CIR data grab

    The population is created in SQL using a number of sources. To update the population – required every time MOH uploads additional CIR, HSU, and NHI data – the latest version of **CODE_40_population_and_CIR.sql** needs to be updated and re-run. Save the new version dated as of the date that the code was edited.

    There are **four table references at the top of the script (CIR_date, CIR_ref, Adhoc_HSU_ref, CIR_NHI_ref)** which correspond to MOH’s ad hoc tables. The latter three references' dates correspond do the date the CIR and associated tables are updated, NOT the latest date of the CIR activity.
   
3)  CIR data tables creation

    There is a section of code at the end of the **CODE_40_population_and_CIR.sql** file which also produces three tables using the CIR data. Two are read into Stata and one is used by the DAT. These tables are: 
	
       *   [IDI_Sandpit].[DL-MAA2021-49].[HSU_death_data];
       *   [IDI_Sandpit].[DL-MAA2021-49].[vacc_clean_DHB_of_service_202203]; and
       *   [IDI_Sandpit].[DL-MAA2021-49].[vacc_202203_$(CIR_NHI_ref)]
	   
    **To conserve the amount of space the project uses it is recommended to periodically delete the older population and CIR related tables.**

#### Data Assembly Tool (Excel files and R studio)

4)  Updating the ‘measures’ file’s table references

    The Data Assembly Tool is used to merge together the bulk of the data used to create the collaboration file. It must be re-run following the updating of the population and CIR data and its relevant files can be found on [GitHub](https://github.com/nz-social-wellbeing-agency/dataset_assembly_tool).

    The **‘measures.xlsx’** file contains a list of indicators. The table references currently only require updating when the IDI refresh changes. You may also need to include additional rows for the newly created dose indicators as required.
	
    The ‘Measure_period_start_date’ and ‘Measure_period_end_date’ columns should also be periodically updated, and should correspond to the periods specified within the **‘population_and_period.xlsx’** file (summary_period_start_date and summary_period_end_date).
	
5)	Updating the ‘population_and_period’ file’s references

    The ‘Table_name’, ‘Summary_period_start_date’, ‘Summary_period_end_date’ need to be updated over time. Table_name references the population table created in step 1, above. 
	
    The ‘Summary_period_end_date’ column should ideally correspond to the date of the latest CIR activity. The CIR data is currently being updated on a monthly basis.
	
6)	Running the Dataset Assembly Tool

    R studio is opened in the Start Menu of windows via a web browser shortcut. The script which runs the assembly tool is called **run_assembly.R**. You may need to see the setup instructions ([available here](https://swa.govt.nz/assets/Publications/guidance/Dataset-Assembly-Tool-introduction-and-training-presentation.pdf)) to configure the tool if you have not used it before.
	
    Within the script, the references to the measures and population files need to be updated (or files need to be changed to have a static name). 
	
    The script should run seamlessly if only being re-run to update the CIR data. Adding additional indicators to the assembly process can be tricky and should occur in collaboration with an experienced researcher.
	
#### Data cleaning and collaboration file creation (SQL and Stata)

7)	Creating a Stata friendly sandpit table

    To create the SQL table that Stata reads we clean the assembled table (rename a few variables and drop others that are created during the assembly process). The SQL code which does this is located here: **SQL_Prepare_DAT_rectangular_table.sql**.
	
    The script always references the same input table ([tmp_vacc_rectangular]), so only the output table’s name needs to be changed to reflect the new date. This code also merges on the CHiPs data which is address based and therefore cannot be merged using the Dataset Assembly Tool.
	
8)	Data cleaning and final table creation using Stata

    To create the .dta file for our own analysis, and an excel spreadsheet for the collaboration file, we update and run **_2_DAT_cleaning_vXX.do**.
	
    Before running the script the user needs to update the six macros at the top of the code. These inform the script of the date of the CIR’s latest vaccination data, the names of the SQL tables to read in, and today’s date for naming of collaboration files.
	
    You also need to update the dates of interest (the dates for which you want the dose counts for each individual). The code will use CIR activity data to check if a dose fell before or after a date and then sum accordingly. **See line 38 of the script for more direction.**
	
    **Other than when the refresh changes or new variables are required (though these can be added in SQL later), you should just be able to press Control + A to select all the code and then Control + D to run it.**
	
    Lastly, the script creates a ~8GB excel spreadsheet which can then be loaded back into SQL for use by collaborators. The SQL script **‘load CIR table to SQL server_vX.sql’** loads the spreadsheet into SQL.
	
    Note that if variables are added or removed from the dataset then this needs to be reflected in this script as it relies on the correct ordering, and number, of columns. This can be done relatively quickly in excel by copying the variables out of Stata and attaching the variable type info with a concatenate function. 

## Citation

Social Wellbeing Agency (2022). COVID19 vaccination update modelling. Source code. https://github.com/nz-social-wellbeing-agency/covid19_vaccination_update_modelling

## Getting Help
If you have any questions email info@swa.govt.nz
