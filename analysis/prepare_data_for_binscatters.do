clear all
version 14.1
set more off
capture log close

log using "prepare_data_for_binscatters.log", replace





/*******************************************************************************

Formats the individual-level model output and creates a seperate sample of 
SCE core mobility data for respondents who participated in the september 2018 
experimental survey. 

Outputs:
1. model_output.dta
2. sept_respondents_with_model_estimates.dta

*******************************************************************************/





/*******************************************************************************

Format the model output

*******************************************************************************/
local rawmodelout individual_level_neighborhood_refb_full_intvws_no_sepC4_p01_SepDec_indiv
local wtplist income homecost crime dist family size mvcost taxes norms schqual copyhome moved

use ${temppath}`rawmodelout'.dta, clear

foreach v in `wtplist' {	
	*
	* Set wtp values to missing if missing t statistic
	*
	replace wtp_`v' = . if missing(t_`v')
	replace wtp_frac_`v' = . if missing(t_`v')
	
    /*
	*
	* Flip sign
	*
	replace wtp_`v' = wtp_`v'*-1
	replace wtp_frac_`v' = wtp_frac_`v'*-1
    */
}

save ${temppath}model_output, replace 





/*******************************************************************************

Select sample of core with model estimates from the september 2018 experiment

*******************************************************************************/
use ${datapath}sce_fullpanel_mobility, clear

*
* Keep sept respondents' full panel data
*
gen sept_dummy = 0
replace sept_dummy = 1 if date==201809
bys scuid: egen present_in_sept = max(sept_dummy)
keep if present_in_sept==1

merge m:1 scuid using ${temppath}model_output, keep(3) nogen

save ${temppath}sept_respondents_with_model_estimates, replace 


log close
