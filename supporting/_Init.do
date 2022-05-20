/////////INITILIALISATION FILE



adopath + "//${DL_DRIVE}/Gendata/dl common files/stata ado files/"
adopath + "//${DL_DRIVE}/Gendata/Stata common files/"
 run "I:\MAA2021-49\SWA_development\Main\Staging\Stata_code\mmerge.ado" 
adopath + "K:\Stata Common Files\estout"
adopath + "I:\MAA2021-49\SWA_development\Main\Staging\Stata_code/"
capture run "tabout.ado" 
do "I:\MAA2021-49\SWA_development\Main\Staging\Stata_code\grr.ado"
run "I:\MAA2021-49\SWA_development\Main\Staging\Stata_code\grrnum.ado"

