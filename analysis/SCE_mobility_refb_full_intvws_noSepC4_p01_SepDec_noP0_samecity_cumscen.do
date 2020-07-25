clear all
version 14.1
set more off
capture log close

log using "SCE_mobility_refb_full_intvws_noSepC4_p01_SepDec_noP0_samecity_cumscen.log", replace

use ${temppath}alldata_refb_full_intvws_noSepC4_p01_SepDec_noP0_samecity, clear

*------------------------------------------------------------------------------
* create cumulative scenario variable and format time stamp data
*------------------------------------------------------------------------------
/*
tempfile september
preserve
    use "${datapath}SCE_Sep_public.dta", clear
    keep scuid scenord_?
    forval x=1/6 {
        forval y=1/4 {
            gen scenord_`x'_`y' = scenord_`x'
        }
        drop scenord_`x'
    }
    reshape long scenord_1_ scenord_2_ scenord_3_ scenord_4_ scenord_5_ scenord_6_, i(scuid) j(scennum)
    forval x=1/6 {
        ren scenord_`x'_ scenord_`x'
    }
    reshape long scenord_ , i(scuid scennum) j(case)
    ren scenord_ scenario_order
    sort scuid case scennum
    l in 1/30, sepby(scuid)
    save `september', replace
restore
*/

tempfile december
preserve
    use "${datapath}SCE_Dec_public.dta", clear
    keep scuid qmvt_?? scenord_?
    forval x=1/6 {
        forval y=1/4 {
            ren qmvt_`x'`y' qmvt_`x'_`y'
            gen scenord_`x'_`y' = scenord_`x'
        }
        drop scenord_`x'
    }
    reshape long qmvt_1_ qmvt_2_ qmvt_3_ qmvt_4_ qmvt_5_ qmvt_6_ scenord_1_ scenord_2_ scenord_3_ scenord_4_ scenord_5_ scenord_6_, i(scuid) j(scennum)
    forval x=1/6 {
        ren qmvt_`x'_ qmvt_`x'
        ren scenord_`x'_ scenord_`x'
    }
    reshape long qmvt_ scenord_ , i(scuid scennum) j(case)
    ren qmvt_ timespentans
    ren scenord_ scenario_order
    sort scuid case scennum
    l in 1/30, sepby(scuid)
    save `december', replace
restore

/*
tempfile both
preserve
    use `september', clear
    append using `december', gen(wave) force
    recode wave (1=2) (0=1)
    save `both'
restore
*/

gen casestr = substr(svyblk,-1,.)
destring casestr, gen(case)

*merge m:1 scuid case scennum using `both', keep(match master) nogen
merge m:1 scuid case scennum using `december', keep(match master) nogen

gen cumscen = 4*(scenario_order-1)+scennum
preserve
    drop if wave==1
    l scuid case scennum scenario_order cumscen in 1/30, sepby(scuid)
restore

drop if wave==1
*------------------------------------------------------------------------------
* Are people taking shorter or longer to answer the questions as the survey progresses?
*------------------------------------------------------------------------------
preserve 
    * remove unneeded obs
    drop if wave<2
    drop if altnum==3
    ** sequentialize case numbers
    *egen min_case = min(case), by(scuid)
    *gen seq_case = case
    *replace seq_case = 1 if case==1 & min_case==1
    *replace seq_case = 2 if case==2 & min_case==1
    *replace seq_case = 3 if case==4 & min_case==1
    *replace seq_case = 4 if case==6 & min_case==1
    *replace seq_case = 1 if case==3 & min_case==3
    *replace seq_case = 2 if case==4 & min_case==3
    *replace seq_case = 3 if case==5 & min_case==3
    *replace seq_case = 4 if case==6 & min_case==3

    * cross-tabs
    tab scenario_order if scennum==1, sum(timespentans)
    tab scenario_order if scennum==2, sum(timespentans)
    tab scenario_order if scennum==3, sum(timespentans)
    tab scenario_order if scennum==4, sum(timespentans)

    * medians
    table scenario_order if scennum==1, c(p50 timespentans)
    table scenario_order if scennum==2, c(p50 timespentans)
    table scenario_order if scennum==3, c(p50 timespentans)
    table scenario_order if scennum==4, c(p50 timespentans)

    * regression models
    reg timespentans i.scenario_order i.scennum
    reg timespentans c.scenario_order i.scennum
    reg timespentans c.scenario_order c.scennum

    * regression models
    qreg timespentans i.scenario_order i.scennum
    qui outreg2 using ${tablepath}QtimeQreg.tex, replace se bdec(1) sdec(1) tex(frag) ctitle("December")
    !sed -i "s|VARIABLES|Characteristic|ig" "${tablepath}QtimeQreg.tex"
    !sed -i "s|2\.scenario\\\_order|2nd block|ig" "${tablepath}QtimeQreg.tex"
    !sed -i "s|3\.scenario\\\_order|3rd block|ig" "${tablepath}QtimeQreg.tex"
    !sed -i "s|4\.scenario\\\_order|4th block|ig" "${tablepath}QtimeQreg.tex"
    !sed -i "s|seq\\\_case|Block trend|ig" "${tablepath}QtimeQreg.tex"
    !sed -i "s|2\.scennum|2nd scenario|ig" "${tablepath}QtimeQreg.tex"
    !sed -i "s|3\.scennum|3rd scenario|ig" "${tablepath}QtimeQreg.tex"
    !sed -i "s|4\.scennum|4th scenario|ig" "${tablepath}QtimeQreg.tex"
    !sed -i "s|scennum|Scenario trend|ig" "${tablepath}QtimeQreg.tex"
    * remove rows that talk about statistical significance or standard errors
    !sed -i '/multicolumn/d' ${tablepath}QtimeQreg.tex
restore

/*
*------------------------------------------------------------------------------
* Estimate location attribute models with cumulative scenario trend
*------------------------------------------------------------------------------
global Suffix = "RefBFullIntvwsNoSepC4p01SepDecNoP0SameCityCSbswtp"

* estimate group-level models including cumulative scenario trends
local  scenarios income homecost crime dist family size mvcost taxes norms schqual withincitymove copyhome moved cumscen c.moved#c.cumscen
global Suffix = "RefBFullIntvwsNoSepC4p01SepDecNoP0SameCityCSbswtp"

include groupestimation_samecity_inclDec_newWTP_CS_bswtp
*/

log close

