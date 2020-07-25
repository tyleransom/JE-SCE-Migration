clear all
version 14.1
set more off
capture log close

log using "SCE_mobility_refb_full_intvws_noSepC4_p01_SepDec_noP0_samecity_ENE.log", replace

use ${temppath}alldata_refb_full_intvws_noSepC4_p01_SepDec_noP0_samecity, clear

preserve
    use ${temppath}alldata_refb_full_intvws_noSepC4_p01_SepDec_samecity, clear
    contract scuid rim_4_original hhincome empFT
    count
    
    qui sum hhincome [w=rim_4_original], d
    global medinc `r(p50)'
    qui sum hhincome [w=rim_4_original] if empFT==0, d
    global empFTmedinc `r(p50)'
    qui sum hhincome [w=rim_4_original] if empFT==1, d
    global nonempMedinc `r(p50)'
restore

*------------------------------------------------------------------------------
* Estimate location attribute models
*------------------------------------------------------------------------------
global Suffix = "RefBFullIntvwsNoSepC4p01SepDecNoP0SameCityENEbswtp"

* estimate group-level models by employed full-time/not
local  scenarios income homecost crime dist family size mvcost taxes norms schqual withincitymove copyhome moved
global Suffix = "RefBFullIntvwsNoSepC4p01SepDecNoP0SameCityENEbswtp"

include groupestimation_samecity_inclDec_newWTP_ENE_bswtp

log close

