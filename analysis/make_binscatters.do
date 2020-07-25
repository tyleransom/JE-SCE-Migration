clear all
version 14.1
set more off
capture log close

log using "make_binscatters.log", replace


/*******************************************************************************

Plot three binscatters. Two of moving decisions vs. moving probability (1. for
the full SCE panel and 2. for the september experimental survey respondents), 
and one of WTP for moving vs. moving probability for all experimental survey 
respondents (september 2018 and december 2019). 

Outputs: 
1. mobility_expectations_actual_mobility_fullcore.eps
2. mobility_expectations_actual_mobility_sept.eps
3. mobility_expectations_wtp.eps

*******************************************************************************/





/*******************************************************************************

Binscatter of moving decisions vs. moving probability

*******************************************************************************/

foreach data in "${datapath}sce_fullpanel_mobility" "${temppath}sept_respondents_with_model_estimates" {
    *
    * Loop over the two samples we use to make the binscatters
    *
    use `data', clear 

    *
    * Calculate individual's panel length in calendar months
    *
    bys scuid: egen maxmosnum = max(month)
    bys scuid: egen minmosnum = min(month)
    gen mosdiff = maxmosnum - minmosnum
    
    *
    * Dummy for ever moving in their time in the panel
    *
    bysort scuid (date): egen evermov=min(d3)
    replace evermov=0 if evermov==2
    
    *
    * Take moving prob for their first month of participation, collapse
    *
    gen mvprob=chance_move_residence if tenure==1
    collapse evermov mvprob mosdiff, by(scuid)
        
    *
    * Binscatter using respondents with a panel length of 12 calendar mos
    *
    if "`data'"=="${datapath}sce_fullpanel_mobility" {
        local suffix fullcore
    }
    if "`data'"=="${temppath}sept_respondents_with_model_estimates" {
        local suffix sept
    }

    binscatter evermov mvprob if mosdiff==11                    ///
        ,                                                       ///
        xtitle("Probability of moving (next 12 months)")        ///
        ytitle("Proportion of respondents who ever moved")      ///
        ylab(0(.2).8) msymbol(circle_hollow) mcolor(black)      ///
        lcolor(red) line(qfit)
    gr export ${graphpath}mobility_expectations_actual_mobility_`suffix'.eps, replace
}





/*******************************************************************************

Binscatter of WTP for moving vs. moving probability

*******************************************************************************/

*
* Keep moving probability for Sept 2018 respondents
*
use ${datapath}sce_fullpanel_mobility, clear 
keep if date==201809
keep scuid date chance_move_residence 

*
* Add on Dec 2019 respondents with their most recent core data merged on
*
append using ${datapath}dec19_experiment_respondents_move_prob 

*
* Merge with the individual model estimates 
*
merge 1:1 scuid using ${temppath}model_output, keep(3)

*
* Save binscatter median data to fit a quadratic later
* 
binscatter wtp_frac_moved chance_move_residence     ///
    ,                                               ///
    graphregion(color(white))                       ///
    median linetype(none) replace                   ///
    savedata(${temppath}binscatter_data_mobexpect_wtp)  

*
* Bring back data, make the figure
*
import delimited using ${temppath}binscatter_data_mobexpect_wtp.csv, clear

twoway  (scatter wtp_frac_moved chance_move_residence       ///
    ,                                                       ///
    msymbol(circle_hollow) mcolor(black))                   ///
    (qfit wtp_frac_moved chance_move_residence              ///
    ,                                                       ///
    lcolor(red))                                            ///
    ,                                                       ///
    legend(off)                                             ///
    graphregion(color(white))                               ///
    xtitle("Probability of moving (next 12 months)")        ///
    ytitle("Median WTP (% of income) for moving")               
gr export ${graphpath}mobility_expectations_wtp.eps, replace


log close


