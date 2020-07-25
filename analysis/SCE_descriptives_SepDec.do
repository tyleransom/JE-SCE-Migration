clear all
version 14.1
set more off
capture log close

log using "SCE_descriptives_SepDec.log", replace

tempfile september
preserve
    use "${datapath}SCE_Sep_public", clear
    **destring q7_1, force replace
    * convert time stamp data to Stata-readable format
    foreach var of varlist timecapture* {
        local newvar = subinstr("`var'","timecapture","tc",1)
        capture gen `newvar' = Clock(`var',"#DMYhms#")
        capture format `newvar' %tC
    }
    * rename some variables that have same names in both waves, but that collected different data
    foreach var of varlist dumx?_?_?_? {
        local newvar = subinstr("`var'","x","y",1)
        ren `var' `newvar'
    }
    foreach var of varlist qmv20_?_?_? {
        local newvar = subinstr("`var'","20","30",1)
        ren `var' `newvar'
    }
    save `september', replace
restore

tempfile december
preserve
    use "${datapath}SCE_Dec_public", clear
    **destring q7_1, force replace
    **capture drop male retired black asian white race married student homemaker numjobs zip state
    * convert time stamp data to Stata-readable format
    foreach var of varlist timecapture* {
        local newvar = subinstr("`var'","timecapture","tc",1)
        capture gen `newvar' = Clock(`var',"#DMYhms#")
        capture format `newvar' %tC
    }
    * rename some variables that have same names in both waves, but that collected different data
    foreach var of varlist dumx?_?_?_? {
        local newvar = subinstr("`var'","x","z",1)
        ren `var' `newvar'
    }
    foreach var of varlist qmv20_?_?_? {
        local newvar = subinstr("`var'","20","40",1)
        ren `var' `newvar'
    }
    save `december', replace
restore

* Combine all three waves (January, September, December) 
use `september', clear
append using `december', gen(wave) force
recode wave (1 = 2) (0 = 1)

*------------------------------------------------------------------------------
* Data cleaning
*------------------------------------------------------------------------------
include datacleaning_SepDec

merge 1:1 scuid wave using ${datapath}UniqueIDsSepDec, keep(matched)

*------------------------------------------------------------------------------
* Compute descriptives
*------------------------------------------------------------------------------
include descriptives_SepDec

log close


