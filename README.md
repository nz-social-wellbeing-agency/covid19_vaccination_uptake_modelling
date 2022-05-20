# CIR Vaccination Uptake Data Development Process

Repositry: covid19_vaccination_update_modelling

## SQL table updates

1)  Population creation & CIR data grab

    The population is created in SQL using a number of sources. To update the population – required every time MOH uploads additional CIR, HSU, and NHI data – the following file (latest version) needs to be updated and re-run. Save the new version dated as of the date that the code was edited. 
   
    ```
    I:\MAA2021-49\SWA_development\Main\Staging\Population definitions\YYYYMMDD_CODE_40_population_and_CIR.sql
    ```

    There are **four table references at the top of the script (CIR_date, CIR_ref, Adhoc_HSU_ref, CIR_NHI_ref)** which correspond to MOH’s ad hoc tables. The dates correspond do the day the CIR and associated tables are updated, NOT the latest date of the CIR activity.
   
2)  CIR data tables creation

    There is a section of code at the end of the **YYYYMMDD_CODE_40_population_and_CIR.sql** file which also produces three tables using the CIR data. Two are read into Stata and one is used by the DAT. These tables are: 
	
       *   [IDI_Sandpit].[DL-MAA2021-49].[HSU_death_data];
       *   [IDI_Sandpit].[DL-MAA2021-49].[vacc_clean_DHB_of_service_202203]; and
       *   [IDI_Sandpit].[DL-MAA2021-49].[vacc_202203_$(CIR_NHI_ref)]
	   
    **To conserve the amount of space the project uses it is recommended to periodically delete the older population and CIR related tables.**

## Data Assembly Tool (Excel files and R studio)

3)  Updating the ‘measures’ file’s table references

    The Data Assembly Tool is used to merge together the bulk of the data used to create the collaboration file. It must be re-run following the updating of the population and CIR data and its relevant files can be found here: 

    ```
    I:\MAA2021-49\SWA_development\Main\tool_accelerating_dataset_assembly-master\
    ```

    The **‘measures_vX_DD_MM_YYYY.xlsx’** file contains a list of indicators. The table references currently only require updating when the IDI refresh changes. You may also need to include additional rows for the newly created dose indicators as required.
	
    The ‘Measure_period_start_date’ and ‘Measure_period_end_date’ columns should also be periodically updated, and should correspond to the periods specified within the **‘population_and_period_DD_MM_YYYY.xlsx’** file (summary_period_start_date and summary_period_end_date).
	
4)	Updating the ‘population_and_period’ file’s references

    The ‘Table_name’, ‘Summary_period_start_date’, ‘Summary_period_end_date’ need to be updated over time. Table_name references the population table created in step 1, above. 
	
    The ‘Summary_period_end_date’ column should ideally correspond to the date of the latest CIR activity. 
	
5)	Running the DAT

    R studio is opened in the Start Menu of windows via a web browser shortcut. The script which runs the DAT process for this project can be found in the same folder as the measures and population files (I:\MAA2021-49\SWA_development\Main\tool_accelerating_dataset_assembly-master), and is called **‘run_assembly_DD_MM_YYYY.R’**.
	
    Within the script, the references to the measures and population files need to be updated (or files need to be changed to have a static name). 
	
    The script should run seamlessly if only being re-run to update the CIR data. Adding additional indicators to the DAT merge process can be tricky and should occur in collaboration with Simon.
	
## Data cleaning and collaboration file creation (SQL and Stata)

6)	Creating a Stata friendly sandpit table

    To create the SQL table that Stata reads we clean the DAT table (rename a few variables and drop others that are created during the DAT process). The SQL code which does this is located here:
	
    ```
    I:\MAA2021-49\SWA_development\Main\Staging\Stata_code\SQL_code\ YYYYMMDD_SQL_Prepare_DAT_rectangular_table.sql
    ```
	
    The script always references the same input table ([tmp_vacc_rectangular]), so only the output table’s name needs to be changed to reflect the new date. This code also merges on the CHiPs data which is address based and therefore cannot be merged using the DAT.
	
7)	Data cleaning and final table creation using Stata

    To create the .dta file for our own analysis, and an excel spreadsheet for the collaboration file, we update and run ‘DAT_cleaning_v10.do’ which can be found here:
	
    ```
    I:\MAA2021-49\SWA_development\Main\Staging\Stata_code\Phase_2
    ```
	
    Before running the script the user needs to update the six macros at the top of the code. These inform the script of the date of the CIR’s latest vaccination data, the names of the SQL tables to read in, and today’s date for naming of collaboration files.
	
    You also need to update the dates of interest (the dates for which you want the dose counts for each individual). The code will use CIR activity data to check if a dose fell before or after a date and then sum accordingly. **See line 38 of the script for more direction.**
	
    **Other than when the refresh changes or new variables are required (though these can be added in SQL later), you should just be able to press Control + A to select all the code and then Control + D to run it.**
	
    Lastly, the script creates a ~8GB excel spreadsheet which can then be loaded back into SQL for use by collaborators. The SQL script **‘load CIR table to SQL server_vX.sql’** loads the spreadsheet into SQL. It can be found here:
	
    ```
    I:\MAA2021-49\Cross-agency collaboration\Dataset creation\upload csv to sql
    ```
	
    Note that if variables are added or removed from the dataset then this needs to be reflected in this script as it relies on the correct ordering, and number, of columns. This can be done relatively quickly in excel by copying the variables out of Stata and attaching the variable type info with a concatenate function. 

