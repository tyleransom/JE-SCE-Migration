clear all
version 14.1
set more off
capture log close

log using "lookAtIndivWTPs.log", replace

local  scenarios income homecost crime dist family size mvcost taxes norms schqual withincitymove copyhome moved


* bring in personal characteristics
tempfile chars
preserve
    use ${temppath}alldata_refb_full_intvws_noSepC4_p01_SepDec_samecity, clear // includes the never-movers
    keep if wave>=1 & altnum==1
    codebook scuid

    duplicates drop scuid, force

    * redefine some demographics
    gen white = race==1
    gen healthy = inlist(health,1,2)
    gen older = inrange(agenew,50,.) if !mi(agenew)
    gen hasyouth_in_home = hasyoungkids_in_home | hasteenagers_in_home

    * define high/low crime
    qui sum violcrimerate, d
    gen hiCrime = violcrimerate>=`r(p50)' if !mi(violcrimerate)
    gen loCrime = violcrimerate< `r(p50)' if !mi(violcrimerate)

    * define high/low income tax
    qui sum salt, d
    gen hiTax = salt>=`r(p50)' if !mi(salt)
    gen loTax = salt< `r(p50)' if !mi(salt)

    * define high/low sqft
    gen sqft000 = qmv1a_1/1000
    qui sum qmv1a_1, d
    gen big_house   = qmv1a_1>=`r(p50)' if !mi(qmv1a_1)
    gen small_house = qmv1a_1< `r(p50)' if !mi(qmv1a_1)

    * define high/low housing cost
    gen loghvalsqft = log(medhvalsqft)
    qui sum medhvalsqft, d
    gen pricey_house = medhvalsqft>=`r(p50)' if !mi(medhvalsqft)
    gen cheap_house  = medhvalsqft< `r(p50)' if !mi(medhvalsqft)

    * past and future move behavior
    gen movep   = qmv7_1/100
    gen futMover = movep>=0.1 if !mi(qmv7_1)
    gen movedLY = inrange(qmv1_1,0,1)

    * tenure of residence
    generat tenureCat = .
    replace tenureCat = 1 if inrange(qmv1_1,0,5)
    replace tenureCat = 2 if inrange(qmv1_1,5.00000000001,10)
    replace tenureCat = 3 if inrange(qmv1_1,10.0000000001,.)
    
    gen inc000 = hhincome/1000
    gen mobile = qmv12==1
    gen stuck  = qmv12==2
    gen rooted = qmv12==3
    
    keep scuid wave total_svy_time long_svy_time short_svy_time qmv12 female white grad4yr married hasteenagers_in_home hasyouth_in_home hasyoungkids_in_home haskids_in_home healthy agenew older residence bgmincome ownhome empFT medhvalsqft nearfam qmv1a_1 salt agreenorms hiqualsch loqualsch violcrimerate hiCrime hiTax big_house sqft000 pricey_house loghvalsqft hhincome hiIncome movep movedLY futMover qmv6b qmv1_1 tenureCat rim_4_original inc000 mobile stuck rooted

    save `chars', replace
restore

* bring in attention checks
tempfile attn
preserve
    use ${datapath}model_output_ids_merged_with_core_data.dta, clear
    keep scuid q46b_1 q46c_1 qnum8 qnum9
    tab qnum8, mi
    tab qnum9, mi
    gen confused_inflation = inlist(qnum8,1,2) if qnum8<=3
    gen confused_risk = inlist(qnum9,1) if qnum9<=2
    sum confused*
    gen risky1 = inlist(q46b_1,6,7) if inrange(q46b_1,1,7)
    gen risky2 = inlist(q46c_1,6,7) if inrange(q46c_1,1,7)
    
    keep scuid confu* risky*
    save `attn', replace
restore

* Individual-level median regressions: Alt 2 baseline
tempfile B
preserve 
    global suffix="_refb_full_intvws_no_sepC4_p01_SepDec_indiv"
    use ${temppath}individual_level_neighborhood${suffix}, clear
    
    d b_*

    foreach var in `scenarios' {
        tab b_`var' if mi(b_`var'), mi
    }
    save `B', replace
restore

use `B', clear
merge 1:1 scuid wave using `chars', nogen keep(match)
merge 1:1 scuid      using `attn', nogen keep(match)


gen bad_income = mi(b_income) | b_income<0.1

*------------------------------------------------------------------------------
* Who are the individuals with zero, negative, or indefined b_income?
*------------------------------------------------------------------------------
preserve 
    local covars i.qmv12 c.agenew i.female i.white i.grad4yr i.married i.haskids_in_home i.healthy i.residence i.empFT i.ownhome
    gen log_svy_time = log(total_svy_time)
    reg bad_income `covars'
    qui outreg2 using ${tablepath}WhoAreZeroUndefInc.tex, replace se bdec(3) sdec(3) tex(frag) ctitle("Full Sample")
    local covars i.never_mover c.log_svy_time i.long_svy_time i.short_svy_time confused* risky* i.qmv12 c.agenew i.female i.white i.grad4yr i.married i.haskids_in_home i.healthy i.residence i.empFT i.ownhome
    reg bad_income `covars'
    qui outreg2 using ${tablepath}WhoAreZeroUndefInc.tex, append  se bdec(3) sdec(3) tex(frag) ctitle("Full Sample")
    local covars c.log_svy_time i.long_svy_time i.short_svy_time confused* risky* i.qmv12 c.agenew i.female i.white i.grad4yr i.married i.haskids_in_home i.healthy i.residence i.empFT i.ownhome
    reg bad_income `covars' if never_mover==0
    qui outreg2 using ${tablepath}WhoAreZeroUndefInc.tex, append  se bdec(3) sdec(3) tex(frag) ctitle("Remove Never Movers")
    !sed -i "s|VARIABLES|Characteristic|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|bad\\\_income|\\`=char(36)'1\[\\\beta_\{inc\}<0.1\]\`=char(36)'|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|1\.never\\\_mover|Never mover|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|log\\\_svy\\\_time|log(time spent on survey)|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|confused\\\_inflation|Questionable numeracy|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|confused\\\_risk|Questionable financial literacy|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|risky1|Willing to take risks in financial matters|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|risky2|Willing to take risks in everyday activities|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|1\.long\\\_svy\\\_time|Took more than 90 minutes on survey|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|1\.short\\\_svy\\\_time|Took fewer than 15 minutes on survey|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|2\.qmv12|Stuck|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|3\.qmv12|Rooted|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|agenew|Age|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|1\.female|Female|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|1\.white|White|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|1\.grad4yr|College graduate|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|1\.married|Married|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|1\.haskids\\\_in\\\_home|Lives with children|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|1\.healthy|Healthy|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|2\.residence|Lives in Suburb|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|3\.residence|Lives in Rural|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|1\.empFT|Employed full-time|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    !sed -i "s|1\.ownhome|Homeowner|ig" "${tablepath}WhoAreZeroUndefInc.tex"
    * remove rows that talk about statistical significance or standard errors
    !sed -i '/multicolumn/d' ${tablepath}WhoAreZeroUndefInc.tex


    local v = 1
    foreach var in movep female white agenew married haskids_in_home grad4yr ownhome healthy inc000 qmv1_1 mobile stuck rooted {
        qui sum `var' [aw=rim_4_original] if never_mover==0 
        if "`v'"=="2" local N_all = `r(N)'
        local mu`v'_all = `r(mean)'
        local sd`v'_all = `r(sd)'
        local mn`v'_all = `r(min)'
        local mx`v'_all = `r(max)'
        qui sum `var' [aw=rim_4_original] if bad_income==1 & never_mover==0
        local N`v'_1 = `r(N)'
        local mu`v'_1 = `r(mean)'
        qui sum `var' if bad_income==1 & never_mover==0
        local mu_nowgt_`v'_1 = `r(mean)'
        qui sum `var' [aw=rim_4_original] if bad_income==0 & never_mover==0
        local N`v'_0 = `r(N)'
        local mu`v'_0 = `r(mean)'
        qui ttest `var'==`mu_nowgt_`v'_1' if bad_income==0 & never_mover==0
        local star`v'_1 = "" 
        if `r(p)'<0.05 local star`v'_1 = "*"
    local ++v
    }

    ** Descriptives of who has werid income coefficients
    capture file close TAx
    file open TAx using "${tablepath}BadBetaIncDescriptiveTable.tex", write replace
    file write TAx "\begin{table}[ht]" _n 
    file write TAx "\caption{Characteristics of Never-Movers with Small, Negative, or Undefined Income Elasticity}" _n 
    file write TAx "\label{tab:descBadInc}" _n 
    file write TAx "\centering" _n 
    file write TAx "\begin{threeparttable}" _n 
    file write TAx "\begin{tabular}{lccc}" _n 
    file write TAx "\toprule " _n 
    file write TAx "Variable & `=char(36)'\beta_{i,inc}\geq 0.1`=char(36)' & `=char(36)'\beta_{i,inc}<0.1`=char(36)' or undefined & Total \\" _n 
    file write TAx "\midrule " _n 
    file write TAx "Female                                   " " & " %4.2f  (`mu2_0')   " & " %4.2f  (`mu2_1')  "`star2_1'"  " & " %4.2f  (`mu2_all')  " \\ "  _n 
    file write TAx "White                                    " " & " %4.2f  (`mu3_0')   " & " %4.2f  (`mu3_1')  "`star3_1'"  " & " %4.2f  (`mu3_all')  " \\ "  _n 
    file write TAx "Age                                      " " & " %4.2f  (`mu4_0')   " & " %4.2f  (`mu4_1')  "`star4_1'"  " & " %4.2f  (`mu4_all')  " \\ "  _n 
    file write TAx "Married                                  " " & " %4.2f  (`mu5_0')   " & " %4.2f  (`mu5_1')  "`star5_1'"  " & " %4.2f  (`mu5_all')  " \\ "  _n 
    file write TAx "Lives with children                      " " & " %4.2f  (`mu6_0')   " & " %4.2f  (`mu6_1')  "`star6_1'"  " & " %4.2f  (`mu6_all')  " \\ "  _n 
    file write TAx "College graduate                         " " & " %4.2f  (`mu7_0')   " & " %4.2f  (`mu7_1')  "`star7_1'"  " & " %4.2f  (`mu7_all')  " \\ "  _n 
    file write TAx "Owns home                                " " & " %4.2f  (`mu8_0')   " & " %4.2f  (`mu8_1')  "`star8_1'"  " & " %4.2f  (`mu8_all')  " \\ "  _n 
    file write TAx "Healthy                                  " " & " %4.2f  (`mu9_0')   " & " %4.2f  (`mu9_1')  "`star9_1'"  " & " %4.2f  (`mu9_all')  " \\ "  _n 
    file write TAx "Income (\\$1000)                         " " & " %4.2f  (`mu10_0')  " & " %4.2f  (`mu10_1') "`star10_1'" " & " %4.2f  (`mu10_all') " \\ "  _n 
    file write TAx "Pr(move) in next two years               " " & " %4.2f  (`mu1_0')   " & " %4.2f  (`mu1_1')  "`star1_1'"  " & " %4.2f  (`mu1_all')  " \\ "  _n 
    file write TAx "Years lived in current residence         " " & " %4.2f  (`mu11_0')  " & " %4.2f  (`mu11_1') "`star11_1'" " & " %4.2f  (`mu11_all') " \\ "  _n  
    file write TAx "Mobile                                   " " & " %4.2f  (`mu12_0')  " & " %4.2f  (`mu12_1') "`star12_1'" " & " %4.2f  (`mu12_all') " \\ "  _n  
    file write TAx "Stuck                                    " " & " %4.2f  (`mu13_0')  " & " %4.2f  (`mu13_1') "`star13_1'" " & " %4.2f  (`mu13_all') " \\ "  _n  
    file write TAx "Rooted                                   " " & " %4.2f  (`mu14_0')  " & " %4.2f  (`mu14_1') "`star14_1'" " & " %4.2f  (`mu14_all') " \\ "  _n  
    file write TAx "\midrule " _n
    file write TAx "Sample size                     " " & " %5.0fc (`N2_0') " & " %5.0fc (`N2_1') " & " %5.0fc (`N_all') " \\ "  _n 
    file write TAx "\bottomrule " _n 
    file write TAx "\end{tabular} " _n 
    file write TAx "\footnotesize{Source: Survey of Consumer Expectations collected in September 2018 and December 2019. " _n
    file write TAx " " _n 
    file write TAx "\bigskip{} " _n 
    file write TAx " " _n 
    file write TAx "Notes: Never-mover refers to an individual who reported the same exact choice probability in every single scenario. * indicates significantly different at the 5\% level.}" _n 
    file write TAx "\end{threeparttable} " _n 
    file write TAx "\end{table} " _n 
    file close TAx
restore


*------------------------------------------------------------------------------
* Heterogeneity in WTP by demographics
*------------------------------------------------------------------------------
preserve
    keep if bad_income==0 & never_mover==0

    * first table: demographic variables
    local v = 0
    foreach var in samecounty female white qmv12 older married hasyouth_in_home ownhome grad4yr { // grad4yr ownhome healthy inc000 qmv1_1 samecounty samestate diffstate diffcountry city suburb regNE regMW regS movedLY  {
        if "`v'"=="0" {
            local vv = 1
            foreach attr in `scenarios' {
                if "`attr'"!="income" {
                    qui sum wtp_`attr', d
                    local med_`vv'_0 = `r(p50)'
                    local ++vv
                }
            }
        }
        else {
            if "`v'"!="3" {
                local vv = 1
                foreach attr in `scenarios' {
                    if "`attr'"!="income" {
                        bsqreg wtp_`attr' i.`var', reps(${nreps})
                        local b1_`vv'_`v' = _b[1.`var']+_b[_cons]
                        local b0_`vv'_`v' = _b[_cons]
                        local t1_`vv'_`v' = _b[1.`var']/_se[1.`var']
                        local t0_`vv'_`v' = _b[_cons]  /_se[_cons]
                        local star_`vv'_`v' = "" 
                        if `=abs(`t1_`vv'_`v'')'>1.96 local star_`vv'_`v' = "*"
                        local ++vv
                    }
                }
            }
            else {
                local vv = 1
                foreach attr in `scenarios' {
                    if "`attr'"!="income" {
                        bsqreg wtp_`attr' i.`var', reps(${nreps})
                        local b2_`vv'_`v' = _b[3.`var']+_b[_cons]
                        local b1_`vv'_`v' = _b[2.`var']+_b[_cons]
                        local b0_`vv'_`v' = _b[_cons]
                        local t2_`vv'_`v' = _b[3.`var']/_se[3.`var']
                        local t1_`vv'_`v' = _b[2.`var']/_se[2.`var']
                        local t0_`vv'_`v' = _b[_cons]  /_se[_cons]
                        local star_`vv'_`v' = "" 
                        if `=abs(`t1_`vv'_`v'')'>1.96 local star_`vv'_`v' = "*"
                        local star2_`vv'_`v' = "" 
                        if `=abs(`t2_`vv'_`v'')'>1.96 local star2_`vv'_`v' = "*"
                        local ++vv
                    }
                }
            }
        }
    local ++v
    }


    *foreach var in female white qmv12 older married hasyouth_in_home { // grad4yr ownhome healthy inc000 qmv1_1 samecounty samestate diffstate diffcountry city suburb regNE regMW regS movedLY  {
    *local  scenarios income homecost crime dist family size mvcost taxes norms schqual withincitymove copyhome moved
    ** WTP by demographics
    capture file close T1
    file open T1 using "${tablepath}WTPdemogs1.tex", write replace
    file write T1 "\begin{table}[ht]" _n 
    file write T1 "\caption{Median Willingness to Pay by Attribute and Demographic Group}" _n 
    file write T1 "\label{tab:WTPsummaryTable}" _n 
    file write T1 "\centering" _n 
    file write T1 "\resizebox{1.0\columnwidth}{!}{" _n 
    file write T1 "\begin{footnotesize}" _n 
    file write T1 "\begin{threeparttable}" _n 
    file write T1 "\begin{tabular}{lcc|cc|cc|cc|cc|cc|cc}" _n 
    file write T1 "\toprule " _n 
    file write T1 "Attribute & Men & Women & White & Non-white & Renter & Owner & Non-college & College & Young & Old & Single & Married & No Kids & Kids \\" _n 
    file write T1 "\midrule " _n 
    file write T1 "Housing Costs          " " & " %9.0fc (`b0_1_1')  " & " %9.0fc (`b1_1_1')  "`star_1_1'"  " & " %9.0fc (`b0_1_2')  " & " %9.0fc (`b1_1_2')  "`star_1_2'"  " & " %9.0fc (`b0_1_7')  " & " %9.0fc (`b1_1_7')  "`star_1_7'"  " & " %9.0fc (`b0_1_8')  " & " %9.0fc (`b1_1_8')  "`star_1_8'"  " & " %9.0fc (`b0_1_4')  " & " %9.0fc (`b1_1_4')  "`star_1_4'"  " & " %9.0fc (`b0_1_5')  " & " %9.0fc (`b1_1_5')  "`star_1_5'"   " & " %9.0fc (`b0_1_6')  " & " %9.0fc (`b1_1_6')  "`star_1_6'"  "  \\ "  _n 
    file write T1 "Crime                  " " & " %9.0fc (`b0_2_1')  " & " %9.0fc (`b1_2_1')  "`star_2_1'"  " & " %9.0fc (`b0_2_2')  " & " %9.0fc (`b1_2_2')  "`star_2_2'"  " & " %9.0fc (`b0_2_7')  " & " %9.0fc (`b1_2_7')  "`star_2_7'"  " & " %9.0fc (`b0_2_8')  " & " %9.0fc (`b1_2_8')  "`star_2_8'"  " & " %9.0fc (`b0_2_4')  " & " %9.0fc (`b1_2_4')  "`star_2_4'"  " & " %9.0fc (`b0_2_5')  " & " %9.0fc (`b1_2_5')  "`star_2_5'"   " & " %9.0fc (`b0_2_6')  " & " %9.0fc (`b1_2_6')  "`star_2_6'"  "  \\ "  _n 
    file write T1 "Distance               " " & " %9.0fc (`b0_3_1')  " & " %9.0fc (`b1_3_1')  "`star_3_1'"  " & " %9.0fc (`b0_3_2')  " & " %9.0fc (`b1_3_2')  "`star_3_2'"  " & " %9.0fc (`b0_3_7')  " & " %9.0fc (`b1_3_7')  "`star_3_7'"  " & " %9.0fc (`b0_3_8')  " & " %9.0fc (`b1_3_8')  "`star_3_8'"  " & " %9.0fc (`b0_3_4')  " & " %9.0fc (`b1_3_4')  "`star_3_4'"  " & " %9.0fc (`b0_3_5')  " & " %9.0fc (`b1_3_5')  "`star_3_5'"   " & " %9.0fc (`b0_3_6')  " & " %9.0fc (`b1_3_6')  "`star_3_6'"  "  \\ "  _n 
    file write T1 "Family Nearby          " " & " %9.0fc (`b0_4_1')  " & " %9.0fc (`b1_4_1')  "`star_4_1'"  " & " %9.0fc (`b0_4_2')  " & " %9.0fc (`b1_4_2')  "`star_4_2'"  " & " %9.0fc (`b0_4_7')  " & " %9.0fc (`b1_4_7')  "`star_4_7'"  " & " %9.0fc (`b0_4_8')  " & " %9.0fc (`b1_4_8')  "`star_4_8'"  " & " %9.0fc (`b0_4_4')  " & " %9.0fc (`b1_4_4')  "`star_4_4'"  " & " %9.0fc (`b0_4_5')  " & " %9.0fc (`b1_4_5')  "`star_4_5'"   " & " %9.0fc (`b0_4_6')  " & " %9.0fc (`b1_4_6')  "`star_4_6'"  "  \\ "  _n 
    file write T1 "Square footage         " " & " %9.0fc (`b0_5_1')  " & " %9.0fc (`b1_5_1')  "`star_5_1'"  " & " %9.0fc (`b0_5_2')  " & " %9.0fc (`b1_5_2')  "`star_5_2'"  " & " %9.0fc (`b0_5_7')  " & " %9.0fc (`b1_5_7')  "`star_5_7'"  " & " %9.0fc (`b0_5_8')  " & " %9.0fc (`b1_5_8')  "`star_5_8'"  " & " %9.0fc (`b0_5_4')  " & " %9.0fc (`b1_5_4')  "`star_5_4'"  " & " %9.0fc (`b0_5_5')  " & " %9.0fc (`b1_5_5')  "`star_5_5'"   " & " %9.0fc (`b0_5_6')  " & " %9.0fc (`b1_5_6')  "`star_5_6'"  "  \\ "  _n 
    file write T1 "Financial moving costs " " & " %9.0fc (`b0_6_1')  " & " %9.0fc (`b1_6_1')  "`star_6_1'"  " & " %9.0fc (`b0_6_2')  " & " %9.0fc (`b1_6_2')  "`star_6_2'"  " & " %9.0fc (`b0_6_7')  " & " %9.0fc (`b1_6_7')  "`star_6_7'"  " & " %9.0fc (`b0_6_8')  " & " %9.0fc (`b1_6_8')  "`star_6_8'"  " & " %9.0fc (`b0_6_4')  " & " %9.0fc (`b1_6_4')  "`star_6_4'"  " & " %9.0fc (`b0_6_5')  " & " %9.0fc (`b1_6_5')  "`star_6_5'"   " & " %9.0fc (`b0_6_6')  " & " %9.0fc (`b1_6_6')  "`star_6_6'"  "  \\ "  _n 
    file write T1 "Taxes                  " " & " %9.0fc (`b0_7_1')  " & " %9.0fc (`b1_7_1')  "`star_7_1'"  " & " %9.0fc (`b0_7_2')  " & " %9.0fc (`b1_7_2')  "`star_7_2'"  " & " %9.0fc (`b0_7_7')  " & " %9.0fc (`b1_7_7')  "`star_7_7'"  " & " %9.0fc (`b0_7_8')  " & " %9.0fc (`b1_7_8')  "`star_7_8'"  " & " %9.0fc (`b0_7_4')  " & " %9.0fc (`b1_7_4')  "`star_7_4'"  " & " %9.0fc (`b0_7_5')  " & " %9.0fc (`b1_7_5')  "`star_7_5'"   " & " %9.0fc (`b0_7_6')  " & " %9.0fc (`b1_7_6')  "`star_7_6'"  "  \\ "  _n 
    file write T1 "Norms                  " " & " %9.0fc (`b0_8_1')  " & " %9.0fc (`b1_8_1')  "`star_8_1'"  " & " %9.0fc (`b0_8_2')  " & " %9.0fc (`b1_8_2')  "`star_8_2'"  " & " %9.0fc (`b0_8_7')  " & " %9.0fc (`b1_8_7')  "`star_8_7'"  " & " %9.0fc (`b0_8_8')  " & " %9.0fc (`b1_8_8')  "`star_8_8'"  " & " %9.0fc (`b0_8_4')  " & " %9.0fc (`b1_8_4')  "`star_8_4'"  " & " %9.0fc (`b0_8_5')  " & " %9.0fc (`b1_8_5')  "`star_8_5'"   " & " %9.0fc (`b0_8_6')  " & " %9.0fc (`b1_8_6')  "`star_8_6'"  "  \\ "  _n 
    file write T1 "School quality         " " & " %9.0fc (`b0_9_1')  " & " %9.0fc (`b1_9_1')  "`star_9_1'"  " & " %9.0fc (`b0_9_2')  " & " %9.0fc (`b1_9_2')  "`star_9_2'"  " & " %9.0fc (`b0_9_7')  " & " %9.0fc (`b1_9_7')  "`star_9_7'"  " & " %9.0fc (`b0_9_8')  " & " %9.0fc (`b1_9_8')  "`star_9_8'"  " & " %9.0fc (`b0_9_4')  " & " %9.0fc (`b1_9_4')  "`star_9_4'"  " & " %9.0fc (`b0_9_5')  " & " %9.0fc (`b1_9_5')  "`star_9_5'"   " & " %9.0fc (`b0_9_6')  " & " %9.0fc (`b1_9_6')  "`star_9_6'"  "  \\ "  _n 
    file write T1 "Local move             " " & " %9.0fc (`b0_10_1') " & " %9.0fc (`b1_10_1') "`star_10_1'" " & " %9.0fc (`b0_10_2') " & " %9.0fc (`b1_10_2') "`star_10_2'" " & " %9.0fc (`b0_10_7') " & " %9.0fc (`b1_10_7') "`star_10_7'" " & " %9.0fc (`b0_10_8') " & " %9.0fc (`b1_10_8') "`star_10_8'" " & " %9.0fc (`b0_10_4') " & " %9.0fc (`b1_10_4') "`star_10_4'" " & " %9.0fc (`b0_10_5') " & " %9.0fc (`b1_10_5') "`star_10_5'"  " & " %9.0fc (`b0_10_6') " & " %9.0fc (`b1_10_6') "`star_10_6'" "  \\ "  _n 
    file write T1 "Same Residence         " " & " %9.0fc (`b0_11_1') " & " %9.0fc (`b1_11_1') "`star_11_1'" " & " %9.0fc (`b0_11_2') " & " %9.0fc (`b1_11_2') "`star_11_2'" " & " %9.0fc (`b0_11_7') " & " %9.0fc (`b1_11_7') "`star_11_7'" " & " %9.0fc (`b0_11_8') " & " %9.0fc (`b1_11_8') "`star_11_8'" " & " %9.0fc (`b0_11_4') " & " %9.0fc (`b1_11_4') "`star_11_4'" " & " %9.0fc (`b0_11_5') " & " %9.0fc (`b1_11_5') "`star_11_5'"  " & " %9.0fc (`b0_11_6') " & " %9.0fc (`b1_11_6') "`star_11_6'" "  \\ "  _n 
    file write T1 "Psychic moving cost    " " & " %9.0fc (`b0_12_1') " & " %9.0fc (`b1_12_1') "`star_12_1'" " & " %9.0fc (`b0_12_2') " & " %9.0fc (`b1_12_2') "`star_12_2'" " & " %9.0fc (`b0_12_7') " & " %9.0fc (`b1_12_7') "`star_12_7'" " & " %9.0fc (`b0_12_8') " & " %9.0fc (`b1_12_8') "`star_12_8'" " & " %9.0fc (`b0_12_4') " & " %9.0fc (`b1_12_4') "`star_12_4'" " & " %9.0fc (`b0_12_5') " & " %9.0fc (`b1_12_5') "`star_12_5'"  " & " %9.0fc (`b0_12_6') " & " %9.0fc (`b1_12_6') "`star_12_6'" "  \\ "  _n 
*   file write T1 "\midrule " _n 
*   file write T1 "N                      " " & " %10.0fc (`N_all') "                         & " %10.0fc (`ACS_N_all') "                             \\ "  _n 
    file write T1 "\bottomrule " _n 
    file write T1 "\end{tabular} " _n 
    file write T1 "\footnotesize{Note: Sample size differs across columns but removes never-movers and those with very small or negative income elasticities (36\\% of the full \$N=2,100\$ sample). * indicates that the difference in the medians is significant at the 5 percent level. Significance is based on bootstrapped standard errors (1000 replications).} " _n
    *file write T1 " " _n
    *file write T1 "Notes: Statistics are weighted using the weights provided by each survey. Standard deviation listed below continuous variables in parentheses. Minimum and maximum listed below continuous variables in brackets. For respondents who appear in both 2018 SCE waves, we present the characteristics as of January 2018. ACS sample consists of household heads ages 18--96 to match the SCE age ranges. Income in both surveys is total household income from all sources. In the ACS, income is computed conditional on \\$5,000--\\$225,000 to match the SCE range. ACS migration distance uses PUMAs instead of counties. ACS urbanicity is computed only using households whose urbanicity is known. For further details, see Section \ref{sec:data}.}" _n 
    file write T1 "\end{threeparttable} " _n 
    file write T1 "\end{footnotesize} " _n 
    file write T1 "} " _n 
    file write T1 "\end{table} " _n 
    file close T1
restore





*------------------------------------------------------------------------------
* Heterogeneity in WTP (frac) by demographics
*------------------------------------------------------------------------------
preserve
    keep if bad_income==0 & never_mover==0

    * first table: demographic variables
    local v = 0
    foreach var in samecounty female white qmv12 older married hasyouth_in_home ownhome grad4yr { // grad4yr ownhome healthy inc000 qmv1_1 samecounty samestate diffstate diffcountry city suburb regNE regMW regS movedLY  {
        if "`v'"=="0" {
            local vv = 1
            foreach attr in `scenarios' {
                if "`attr'"!="income" {
                    qui sum wtp_frac_`attr', d
                    local med_`vv'_0 = `r(p50)'
                    local ++vv
                }
            }
        }
        else {
            if "`v'"!="3" {
                local vv = 1
                foreach attr in `scenarios' {
                    if "`attr'"!="income" {
                        bsqreg wtp_frac_`attr' i.`var', reps(${nreps})
                        local b1_`vv'_`v' = _b[1.`var']+_b[_cons]
                        local b0_`vv'_`v' = _b[_cons]
                        local t1_`vv'_`v' = _b[1.`var']/_se[1.`var']
                        local t0_`vv'_`v' = _b[_cons]  /_se[_cons]
                        local star_`vv'_`v' = "" 
                        if `=abs(`t1_`vv'_`v'')'>1.96 local star_`vv'_`v' = "*"
                        local ++vv
                    }
                }
            }
            else {
                local vv = 1
                foreach attr in `scenarios' {
                    if "`attr'"!="income" {
                        bsqreg wtp_frac_`attr' i.`var', reps(${nreps})
                        local b2_`vv'_`v' = _b[3.`var']+_b[_cons]
                        local b1_`vv'_`v' = _b[2.`var']+_b[_cons]
                        local b0_`vv'_`v' = _b[_cons]
                        local t2_`vv'_`v' = _b[3.`var']/_se[3.`var']
                        local t1_`vv'_`v' = _b[2.`var']/_se[2.`var']
                        local t0_`vv'_`v' = _b[_cons]  /_se[_cons]
                        local star_`vv'_`v' = "" 
                        if `=abs(`t1_`vv'_`v'')'>1.96 local star_`vv'_`v' = "*"
                        local star2_`vv'_`v' = "" 
                        if `=abs(`t2_`vv'_`v'')'>1.96 local star2_`vv'_`v' = "*"
                        local ++vv
                    }
                }
            }
        }
    local ++v
    }


    *foreach var in female white qmv12 older married hasyouth_in_home { // grad4yr ownhome healthy inc000 qmv1_1 samecounty samestate diffstate diffcountry city suburb regNE regMW regS movedLY  {
    *local  scenarios income homecost crime dist family size mvcost taxes norms schqual withincitymove copyhome moved
    ** WTP by demographics
    capture file close T1
    file open T1 using "${tablepath}WTPfracDemogs1.tex", write replace
    file write T1 "\begin{table}[ht]" _n 
    file write T1 "\caption{Median Willingness to Pay by Attribute and Demographic Group}" _n 
    file write T1 "\label{tab:WTPfracsummaryTable}" _n 
    file write T1 "\centering" _n 
    file write T1 "\resizebox{1.0\columnwidth}{!}{" _n 
    file write T1 "\begin{footnotesize}" _n 
    file write T1 "\begin{threeparttable}" _n 
    file write T1 "\begin{tabular}{lcc|cc|cc|cc|cc|cc|cc}" _n 
    file write T1 "\toprule " _n 
    file write T1 "Attribute & Men & Women & White & Non-white & Renter & Owner & Non-college & College & Young & Old & Single & Married & No Kids & Kids \\" _n 
    file write T1 "\midrule " _n 
    file write T1 "Housing Costs          " " & " %9.2f (`b0_1_1')  " & " %9.2f (`b1_1_1')  "`star_1_1'"  " & " %9.2f (`b0_1_2')  " & " %9.2f (`b1_1_2')  "`star_1_2'"  " & " %9.2f (`b0_1_7')  " & " %9.2f (`b1_1_7')  "`star_1_7'"  " & " %9.2f (`b0_1_8')  " & " %9.2f (`b1_1_8')  "`star_1_8'"  " & " %9.2f (`b0_1_4')  " & " %9.2f (`b1_1_4')  "`star_1_4'"  " & " %9.2f (`b0_1_5')  " & " %9.2f (`b1_1_5')  "`star_1_5'"   " & " %9.2f (`b0_1_6')  " & " %9.2f (`b1_1_6')  "`star_1_6'"  "  \\ "  _n 
    file write T1 "Crime                  " " & " %9.2f (`b0_2_1')  " & " %9.2f (`b1_2_1')  "`star_2_1'"  " & " %9.2f (`b0_2_2')  " & " %9.2f (`b1_2_2')  "`star_2_2'"  " & " %9.2f (`b0_2_7')  " & " %9.2f (`b1_2_7')  "`star_2_7'"  " & " %9.2f (`b0_2_8')  " & " %9.2f (`b1_2_8')  "`star_2_8'"  " & " %9.2f (`b0_2_4')  " & " %9.2f (`b1_2_4')  "`star_2_4'"  " & " %9.2f (`b0_2_5')  " & " %9.2f (`b1_2_5')  "`star_2_5'"   " & " %9.2f (`b0_2_6')  " & " %9.2f (`b1_2_6')  "`star_2_6'"  "  \\ "  _n 
    file write T1 "Distance               " " & " %9.2f (`b0_3_1')  " & " %9.2f (`b1_3_1')  "`star_3_1'"  " & " %9.2f (`b0_3_2')  " & " %9.2f (`b1_3_2')  "`star_3_2'"  " & " %9.2f (`b0_3_7')  " & " %9.2f (`b1_3_7')  "`star_3_7'"  " & " %9.2f (`b0_3_8')  " & " %9.2f (`b1_3_8')  "`star_3_8'"  " & " %9.2f (`b0_3_4')  " & " %9.2f (`b1_3_4')  "`star_3_4'"  " & " %9.2f (`b0_3_5')  " & " %9.2f (`b1_3_5')  "`star_3_5'"   " & " %9.2f (`b0_3_6')  " & " %9.2f (`b1_3_6')  "`star_3_6'"  "  \\ "  _n 
    file write T1 "Family Nearby          " " & " %9.2f (`b0_4_1')  " & " %9.2f (`b1_4_1')  "`star_4_1'"  " & " %9.2f (`b0_4_2')  " & " %9.2f (`b1_4_2')  "`star_4_2'"  " & " %9.2f (`b0_4_7')  " & " %9.2f (`b1_4_7')  "`star_4_7'"  " & " %9.2f (`b0_4_8')  " & " %9.2f (`b1_4_8')  "`star_4_8'"  " & " %9.2f (`b0_4_4')  " & " %9.2f (`b1_4_4')  "`star_4_4'"  " & " %9.2f (`b0_4_5')  " & " %9.2f (`b1_4_5')  "`star_4_5'"   " & " %9.2f (`b0_4_6')  " & " %9.2f (`b1_4_6')  "`star_4_6'"  "  \\ "  _n 
    file write T1 "Square footage         " " & " %9.2f (`b0_5_1')  " & " %9.2f (`b1_5_1')  "`star_5_1'"  " & " %9.2f (`b0_5_2')  " & " %9.2f (`b1_5_2')  "`star_5_2'"  " & " %9.2f (`b0_5_7')  " & " %9.2f (`b1_5_7')  "`star_5_7'"  " & " %9.2f (`b0_5_8')  " & " %9.2f (`b1_5_8')  "`star_5_8'"  " & " %9.2f (`b0_5_4')  " & " %9.2f (`b1_5_4')  "`star_5_4'"  " & " %9.2f (`b0_5_5')  " & " %9.2f (`b1_5_5')  "`star_5_5'"   " & " %9.2f (`b0_5_6')  " & " %9.2f (`b1_5_6')  "`star_5_6'"  "  \\ "  _n 
    file write T1 "Financial moving costs " " & " %9.2f (`b0_6_1')  " & " %9.2f (`b1_6_1')  "`star_6_1'"  " & " %9.2f (`b0_6_2')  " & " %9.2f (`b1_6_2')  "`star_6_2'"  " & " %9.2f (`b0_6_7')  " & " %9.2f (`b1_6_7')  "`star_6_7'"  " & " %9.2f (`b0_6_8')  " & " %9.2f (`b1_6_8')  "`star_6_8'"  " & " %9.2f (`b0_6_4')  " & " %9.2f (`b1_6_4')  "`star_6_4'"  " & " %9.2f (`b0_6_5')  " & " %9.2f (`b1_6_5')  "`star_6_5'"   " & " %9.2f (`b0_6_6')  " & " %9.2f (`b1_6_6')  "`star_6_6'"  "  \\ "  _n 
    file write T1 "Taxes                  " " & " %9.2f (`b0_7_1')  " & " %9.2f (`b1_7_1')  "`star_7_1'"  " & " %9.2f (`b0_7_2')  " & " %9.2f (`b1_7_2')  "`star_7_2'"  " & " %9.2f (`b0_7_7')  " & " %9.2f (`b1_7_7')  "`star_7_7'"  " & " %9.2f (`b0_7_8')  " & " %9.2f (`b1_7_8')  "`star_7_8'"  " & " %9.2f (`b0_7_4')  " & " %9.2f (`b1_7_4')  "`star_7_4'"  " & " %9.2f (`b0_7_5')  " & " %9.2f (`b1_7_5')  "`star_7_5'"   " & " %9.2f (`b0_7_6')  " & " %9.2f (`b1_7_6')  "`star_7_6'"  "  \\ "  _n 
    file write T1 "Norms                  " " & " %9.2f (`b0_8_1')  " & " %9.2f (`b1_8_1')  "`star_8_1'"  " & " %9.2f (`b0_8_2')  " & " %9.2f (`b1_8_2')  "`star_8_2'"  " & " %9.2f (`b0_8_7')  " & " %9.2f (`b1_8_7')  "`star_8_7'"  " & " %9.2f (`b0_8_8')  " & " %9.2f (`b1_8_8')  "`star_8_8'"  " & " %9.2f (`b0_8_4')  " & " %9.2f (`b1_8_4')  "`star_8_4'"  " & " %9.2f (`b0_8_5')  " & " %9.2f (`b1_8_5')  "`star_8_5'"   " & " %9.2f (`b0_8_6')  " & " %9.2f (`b1_8_6')  "`star_8_6'"  "  \\ "  _n 
    file write T1 "School quality         " " & " %9.2f (`b0_9_1')  " & " %9.2f (`b1_9_1')  "`star_9_1'"  " & " %9.2f (`b0_9_2')  " & " %9.2f (`b1_9_2')  "`star_9_2'"  " & " %9.2f (`b0_9_7')  " & " %9.2f (`b1_9_7')  "`star_9_7'"  " & " %9.2f (`b0_9_8')  " & " %9.2f (`b1_9_8')  "`star_9_8'"  " & " %9.2f (`b0_9_4')  " & " %9.2f (`b1_9_4')  "`star_9_4'"  " & " %9.2f (`b0_9_5')  " & " %9.2f (`b1_9_5')  "`star_9_5'"   " & " %9.2f (`b0_9_6')  " & " %9.2f (`b1_9_6')  "`star_9_6'"  "  \\ "  _n 
    file write T1 "Local move             " " & " %9.2f (`b0_10_1') " & " %9.2f (`b1_10_1') "`star_10_1'" " & " %9.2f (`b0_10_2') " & " %9.2f (`b1_10_2') "`star_10_2'" " & " %9.2f (`b0_10_7') " & " %9.2f (`b1_10_7') "`star_10_7'" " & " %9.2f (`b0_10_8') " & " %9.2f (`b1_10_8') "`star_10_8'" " & " %9.2f (`b0_10_4') " & " %9.2f (`b1_10_4') "`star_10_4'" " & " %9.2f (`b0_10_5') " & " %9.2f (`b1_10_5') "`star_10_5'"  " & " %9.2f (`b0_10_6') " & " %9.2f (`b1_10_6') "`star_10_6'" "  \\ "  _n 
    file write T1 "Same Residence         " " & " %9.2f (`b0_11_1') " & " %9.2f (`b1_11_1') "`star_11_1'" " & " %9.2f (`b0_11_2') " & " %9.2f (`b1_11_2') "`star_11_2'" " & " %9.2f (`b0_11_7') " & " %9.2f (`b1_11_7') "`star_11_7'" " & " %9.2f (`b0_11_8') " & " %9.2f (`b1_11_8') "`star_11_8'" " & " %9.2f (`b0_11_4') " & " %9.2f (`b1_11_4') "`star_11_4'" " & " %9.2f (`b0_11_5') " & " %9.2f (`b1_11_5') "`star_11_5'"  " & " %9.2f (`b0_11_6') " & " %9.2f (`b1_11_6') "`star_11_6'" "  \\ "  _n 
    file write T1 "Psychic moving cost    " " & " %9.2f (`b0_12_1') " & " %9.2f (`b1_12_1') "`star_12_1'" " & " %9.2f (`b0_12_2') " & " %9.2f (`b1_12_2') "`star_12_2'" " & " %9.2f (`b0_12_7') " & " %9.2f (`b1_12_7') "`star_12_7'" " & " %9.2f (`b0_12_8') " & " %9.2f (`b1_12_8') "`star_12_8'" " & " %9.2f (`b0_12_4') " & " %9.2f (`b1_12_4') "`star_12_4'" " & " %9.2f (`b0_12_5') " & " %9.2f (`b1_12_5') "`star_12_5'"  " & " %9.2f (`b0_12_6') " & " %9.2f (`b1_12_6') "`star_12_6'" "  \\ "  _n 
*   file write T1 "\midrule " _n 
*   file write T1 "N                      " " & " %10.0fc (`N_all') "                         & " %10.0fc (`ACS_N_all') "                             \\ "  _n 
    file write T1 "\bottomrule " _n 
    file write T1 "\end{tabular} " _n 
    file write T1 "\footnotesize{Note: Sample size differs across columns but removes never-movers and those with very small or negative income elasticities (36\\% of the full \$ N=2,110 \$ sample). * indicates that the difference in the medians is significant at the 5 percent level. Significance is based on bootstrapped standard errors (1000 replications).} " _n
    *file write T1 " " _n
    *file write T1 "Notes: Statistics are weighted using the weights provided by each survey. Standard deviation listed below continuous variables in parentheses. Minimum and maximum listed below continuous variables in brackets. For respondents who appear in both 2018 SCE waves, we present the characteristics as of January 2018. ACS sample consists of household heads ages 18--96 to match the SCE age ranges. Income in both surveys is total household income from all sources. In the ACS, income is computed conditional on \\$5,000--\\$225,000 to match the SCE range. ACS migration distance uses PUMAs instead of counties. ACS urbanicity is computed only using households whose urbanicity is known. For further details, see Section \ref{sec:data}.}" _n 
    file write T1 "\end{threeparttable} " _n 
    file write T1 "\end{footnotesize} " _n 
    file write T1 "} " _n 
    file write T1 "\end{table} " _n 
    file close T1
restore


*------------------------------------------------------------------------------
* Replicate moving cost findings in literature
*------------------------------------------------------------------------------
gen wtp_closemove = wtp_moved+wtp_withincitymove

** median WTP for moving by group?
*qreg wtp_closemove i.qmv12           if bad_income==0 & never_mover==0
*qreg wtp_closemove i.ownhome         if bad_income==0 & never_mover==0
*qreg wtp_closemove i.older           if bad_income==0 & never_mover==0
*qreg wtp_closemove i.married         if bad_income==0 & never_mover==0
*qreg wtp_closemove i.hasyoungkids    if bad_income==0 & never_mover==0
*qreg wtp_closemove i.hasteenagers    if bad_income==0 & never_mover==0
*qreg wtp_closemove i.grad4yr         if bad_income==0 & never_mover==0
*qreg wtp_closemove i.empFT           if bad_income==0 & never_mover==0
*qreg wtp_closemove i.tenureCat       if bad_income==0 & never_mover==0
*qreg wtp_closemove i.ownhome i.older if bad_income==0 & never_mover==0

* Moving cost table
count
count if bad_income==0 & never_mover==0
qui bsqreg wtp_moved     i.ownhome                  i.grad4yr i.empFT           i.hasyouth_in_home if bad_income==0 & never_mover==0, wlsiter(500) reps(${nreps})
qui outreg2 using ${tablepath}MCheterog.tex, replace se bdec(0) sdec(0) tex(frag) ctitle("Non-monetary moving cost")
qui bsqreg wtp_moved     i.ownhome c.agenew         i.grad4yr i.empFT           i.hasyouth_in_home if bad_income==0 & never_mover==0, wlsiter(500) reps(${nreps})
qui outreg2 using ${tablepath}MCheterog.tex, append  se bdec(0) sdec(0) tex(frag) ctitle("Non-monetary moving cost")
qui bsqreg wtp_moved     i.ownhome c.agenew i.qmv12 i.grad4yr i.empFT           i.hasyouth_in_home if bad_income==0 & never_mover==0, wlsiter(500) reps(${nreps})
qui outreg2 using ${tablepath}MCheterog.tex, append  se bdec(0) sdec(0) tex(frag) ctitle("Non-monetary moving cost")
* qui bsqreg wtp_closemove i.ownhome c.agenew i.qmv12 i.grad4yr i.empFT i.married i.hasyouth_in_home if bad_income==0 & never_mover==0, wlsiter(500) reps(${nreps})
* qui outreg2 using ${tablepath}MCheterog.tex, append  se bdec(0) sdec(0) tex(frag) ctitle("Move within 0.5 miles")
* qui bsqreg wtp_closemove i.ownhome c.agenew         i.grad4yr i.empFT i.married i.hasyouth_in_home if bad_income==0 & never_mover==0, wlsiter(500) reps(${nreps})
* qui outreg2 using ${tablepath}MCheterog.tex, append  se bdec(0) sdec(0) tex(frag) ctitle("Move within 0.5 miles")
* qui bsqreg wtp_closemove i.ownhome                  i.grad4yr i.empFT i.married i.hasyouth_in_home if bad_income==0 & never_mover==0, wlsiter(500) reps(${nreps})
* qui outreg2 using ${tablepath}MCheterog.tex, append  se bdec(0) sdec(0) tex(frag) ctitle("Move within 0.5 miles")
!sed -i "s|VARIABLES|Characteristic|ig" "${tablepath}MCheterog.tex"
!sed -i "s|2\.qmv12|Stuck|ig" "${tablepath}MCheterog.tex"
!sed -i "s|3\.qmv12|Rooted|ig" "${tablepath}MCheterog.tex"
!sed -i "s|agenew|Age|ig" "${tablepath}MCheterog.tex"
!sed -i "s|1\.grad4yr|College graduate|ig" "${tablepath}MCheterog.tex"
!sed -i "s|1\.married|Married|ig" "${tablepath}MCheterog.tex"
!sed -i "s|1\.hasyouth\\\_in\\\_home|Lives with children|ig" "${tablepath}MCheterog.tex"
!sed -i "s|1\.empFT|Employed full-time|ig" "${tablepath}MCheterog.tex"
!sed -i "s|1\.ownhome|Homeowner|ig" "${tablepath}MCheterog.tex"
!sed -i '/multicolumn/d' ${tablepath}MCheterog.tex




*------------------------------------------------------------------------------
* Sorting analysis
*------------------------------------------------------------------------------
preserve
    keep if bad_income==0 & never_mover==0
    * housing costs
    qui bsqreg wtp_homecost c.loghvalsqft, reps(${nreps})
    qui outreg2 using ${tablepath}SortingAnalysis.tex, replace se bdec(0) sdec(0) tex(frag) ctitle("Housing Costs")
    qui bsqreg wtp_homecost i.pricey_house, reps(${nreps})
                        local b1_1 = _b[1.pricey_house]+_b[_cons]
                        local b0_1 = _b[_cons]
                        local t1_1 = _b[1.pricey_house]/_se[1.pricey_house]
                        local t0_1 = _b[_cons]  /_se[_cons]
                        local star_1 = "" 
                        if `=abs(`t1_1')'>1.96 local star_1 = "*"
    qui outreg2 using ${tablepath}SortingAnalysis.tex, append  se bdec(0) sdec(0) tex(frag) ctitle("Housing Costs")
    * crime
    qui bsqreg wtp_crime i.hiCrime, reps(${nreps})
                        local b1_2 = _b[1.hiCrime]+_b[_cons]
                        local b0_2 = _b[_cons]
                        local t1_2 = _b[1.hiCrime]/_se[1.hiCrime]
                        local t0_2 = _b[_cons]  /_se[_cons]
                        local star_2 = "" 
                        if `=abs(`t1_2')'>1.96 local star_2 = "*"
    qui outreg2 using ${tablepath}SortingAnalysis.tex, append  se bdec(0) sdec(0) tex(frag) ctitle("Crime")
    qui bsqreg wtp_crime violcrimerate, reps(${nreps})
    qui outreg2 using ${tablepath}SortingAnalysis.tex, append  se bdec(0) sdec(0) tex(frag) ctitle("Crime")
    * family
    qui bsqreg wtp_family i.nearfam, reps(${nreps})
                        local b1_3 = _b[1.nearfam]+_b[_cons]
                        local b0_3 = _b[_cons]
                        local t1_3 = _b[1.nearfam]/_se[1.nearfam]
                        local t0_3 = _b[_cons]  /_se[_cons]
                        local star_3 = "" 
                        if `=abs(`t1_3')'>1.96 local star_3 = "*"
    qui outreg2 using ${tablepath}SortingAnalysis.tex, append  se bdec(0) sdec(0) tex(frag) ctitle("Family")
    * square footage
    qui bsqreg wtp_size c.sqft000, reps(${nreps})
    qui outreg2 using ${tablepath}SortingAnalysis.tex, append  se bdec(0) sdec(0) tex(frag) ctitle("Size")
    qui bsqreg wtp_size i.big_house, reps(${nreps})
                        local b1_4 = _b[1.big_house]+_b[_cons]
                        local b0_4 = _b[_cons]
                        local t1_4 = _b[1.big_house]/_se[1.big_house]
                        local t0_4 = _b[_cons]  /_se[_cons]
                        local star_4 = "" 
                        if `=abs(`t1_4')'>1.96 local star_4 = "*"
    qui outreg2 using ${tablepath}SortingAnalysis.tex, append  se bdec(0) sdec(0) tex(frag) ctitle("Size")
    * box and truck costs
    qui bsqreg wtp_frac_mvcost i.hiIncome, reps(${nreps})
                        local b1_5 = _b[1.hiIncome]+_b[_cons]
                        local b0_5 = _b[_cons]
                        local t1_5 = _b[1.hiIncome]/_se[1.hiIncome]
                        local t0_5 = _b[_cons]  /_se[_cons]
                        local star_5 = "" 
                        if `=abs(`t1_5')'>1.96 local star_5 = "*"
    qui outreg2 using ${tablepath}SortingAnalysis.tex, append  se bdec(3) sdec(3) tex(frag) ctitle("Fin. Moving Cost (%)")
    * taxes
    qui bsqreg wtp_taxes i.hiTax, reps(${nreps})
                        local b1_6 = _b[1.hiTax]+_b[_cons]
                        local b0_6 = _b[_cons]
                        local t1_6 = _b[1.hiTax]/_se[1.hiTax]
                        local t0_6 = _b[_cons]  /_se[_cons]
                        local star_6 = "" 
                        if `=abs(`t1_6')'>1.96 local star_6 = "*"
    qui outreg2 using ${tablepath}SortingAnalysis.tex, append  se bdec(0) sdec(0) tex(frag) ctitle("Taxes")
    * norms
    qui bsqreg wtp_norms i.agreenorms, reps(${nreps})
                        local b1_7 = _b[1.agreenorms]+_b[_cons]
                        local b0_7 = _b[_cons]
                        local t1_7 = _b[1.agreenorms]/_se[1.agreenorms]
                        local t0_7 = _b[_cons]  /_se[_cons]
                        local star_7 = "" 
                        if `=abs(`t1_7')'>1.96 local star_7 = "*"
    qui outreg2 using ${tablepath}SortingAnalysis.tex, append  se bdec(0) sdec(0) tex(frag) ctitle("Norms")
    * school quality
    *qui qreg wtp_schqual i.loqualsch
    *qui qreg wtp_schqual i.hiqualsch
    *qui qreg wtp_schqual i.hiqualsch i.hasyoungkids_in_home
    *qui qreg wtp_schqual i.hiqualsch i.hasteenagers_in_home
    *qui qreg wtp_schqual i.loqualsch i.hasyoungkids_in_home i.hasteenagers_in_home
    qui bsqreg wtp_schqual i.hasyouth_in_home, reps(${nreps})
                        local b1_8 = _b[1.hasyouth_in_home]+_b[_cons]
                        local b0_8 = _b[_cons]
                        local t1_8 = _b[1.hasyouth_in_home]/_se[1.hasyouth_in_home]
                        local t0_8 = _b[_cons]  /_se[_cons]
                        local star_8 = "" 
                        if `=abs(`t1_8')'>1.96 local star_8 = "*"
    qui outreg2 using ${tablepath}SortingAnalysis.tex, append  se bdec(0) sdec(0) tex(frag) ctitle("School")
    qui bsqreg wtp_copyhome i.ownhome, reps(${nreps})
                        local b1_9 = _b[1.ownhome]+_b[_cons]
                        local b0_9 = _b[_cons]
                        local t1_9 = _b[1.ownhome]/_se[1.ownhome]
                        local t0_9 = _b[_cons]  /_se[_cons]
                        local star_9 = "" 
                        if `=abs(`t1_9')'>1.96 local star_9 = "*"
    qui outreg2 using ${tablepath}SortingAnalysis.tex, append  se bdec(0) sdec(0) tex(frag) ctitle("School")
    * moving costs
    qui bsqreg wtp_moved i.movedLY, reps(${nreps})
    qui bsqreg wtp_moved i.futMover, reps(${nreps})
                        local b1_10 = _b[1.futMover]+_b[_cons]
                        local b0_10 = _b[_cons]
                        local t1_10 = _b[1.futMover]/_se[1.futMover]
                        local t0_10 = _b[_cons]  /_se[_cons]
                        local star_10 = "" 
                        if `=abs(`t1_10')'>1.106 local star_10 = "*"
    qui outreg2 using ${tablepath}SortingAnalysis.tex, append  se bdec(0) sdec(0) tex(frag) ctitle("Moved")
    * clean up tex file
    !sed -i '/multicolumn/d' ${tablepath}SortingAnalysis.tex

    capture file close T1
    file open T1 using "${tablepath}Sorting1.tex", write replace
    file write T1 "\begin{table}[ht]" _n 
    file write T1 "\caption{Median Willingness to Pay by Attribute and Chosen Level of Attribute}" _n 
    file write T1 "\label{tab:SortingTable}" _n 
    file write T1 "\centering" _n 
    file write T1 "\begin{threeparttable}" _n 
    file write T1 "\begin{tabular}{lcc}" _n 
    file write T1 "\toprule " _n 
    file write T1 " & \multicolumn{2}{c}{Existing Amount of Attribute} \\" _n 
    file write T1 "\cmidrule{2-3} " _n 
    file write T1 "Attribute & Low  & High  \\" _n 
    file write T1 "\midrule " _n 
    file write T1 "Housing costs          " " & " %9.0fc (`b0_1')  " & " %9.0fc (`b1_1')  "`star_1'" " \\ "  _n 
    file write T1 "Crime                  " " & " %9.0fc (`b0_2')  " & " %9.0fc (`b1_2')  "`star_2'" "  \\ "  _n 
    file write T1 "Family nearby          " " & " %9.0fc (`b0_3')  " & " %9.0fc (`b1_3')  "`star_3'" "  \\ "  _n 
    file write T1 "Square footage         " " & " %9.0fc (`b0_4')  " & " %9.0fc (`b1_4')  "`star_4'" "  \\ "  _n 
    file write T1 "Financial moving costs (\%) " " & " %9.2fc (`b0_5')  " & " %9.2f (`b1_5')  "`star_5'" "  \\ "  _n 
    file write T1 "Taxes                  " " & " %9.0fc (`b0_6')  " & " %9.0fc (`b1_6')  "`star_6'" "  \\ "  _n 
    file write T1 "Norms                  " " & " %9.0fc (`b0_7')  " & " %9.0fc (`b1_7')  "`star_7'" "  \\ "  _n 
    file write T1 "School quality         " " & " %9.0fc (`b0_8')  " & " %9.0fc (`b1_8')  "`star_8'" "  \\ "  _n 
    file write T1 "Same residence         " " & " %9.0fc (`b0_9') " & " %9.0fc (`b1_9') "`star_9'" "  \\ "  _n 
    file write T1 "Nonpecuniary moving cost    " " & " %9.0fc (`b0_10') " & " %9.0fc (`b1_10') "`star_10'" "  \\ "  _n 
    file write T1 "\bottomrule " _n 
    file write T1 "\end{tabular} " _n 
    file write T1 "\footnotesize{Note: Sample size differs across rows but removes never-movers and those with very small or negative income elasticities (36\\% of the full \$ N=2,110 \$ sample). * indicates that the median difference is significant at the 5 percent level. Significance is based on bootstrapped standard errors. " _n
    file write T1 " " _n
    file write T1 "A high amount of the existing attribute refers to having an amount above the median for the following attributes: housing costs, crime, square footage, and taxes. For family, it refers to living within 50 miles of a family member. For financial moving costs, it refers to being in the top half of the income distribution. For norms, it refers to reporting the current agreeableness of norms as very or extremely. For school quality, it refers to having a child in the home under the age of 18. For  same residence, it refers to owning a home. For nonpecuniar moving costs, it refers to having an unconditional future move probability of 10\% or higher. }" _n 
    file write T1 "\end{threeparttable} " _n 
    file write T1 "\end{table} " _n 
    file close T1
restore


* Histograms
preserve
    * histograms (WTP)
    keep if bad_income==0 & never_mover==0

    capture file close T1
    file open T1 using "${tablepath}DistnBetas.tex", write replace
    file write T1 "\begin{table}[ht]" _n 
    file write T1 "\caption{Distribution of Individual Preference Parameters}" _n 
    file write T1 "\label{tab:DistnBetas}" _n 
    file write T1 "\centering" _n 
    file write T1 "\begin{threeparttable}" _n 
    file write T1 "\begin{tabular}{lcccc}" _n 
    file write T1 "\toprule " _n 
    file write T1 "Attribute & 10th percentile  & Median  & 90th percentile & N \\" _n 
    file write T1 "\midrule " _n 

    foreach var in `scenarios' {
        sum wtp_`var', d
        capture drop temp_touse_`var'
        if "`var'"!="moved" gen temp_touse_`var' = inrange(wtp_`var',r(p5),r(p95))
        if "`var'"=="moved" gen temp_touse_`var' = inrange(wtp_`var',r(p10),r(p90))
        sum wtp_`var' if temp_touse_`var'==1, d
        local meany = `: di %9.0f `r(mean)''
        local p10y  = `: di %9.0f `r(p10)''
        local medy  = `: di %9.0f `r(p50)''
        local p90y  = `: di %9.0f `r(p90)''
        local ny = `: di %4.0f `r(N)''
        if "`var'"=="income" local vartemp "Income"
        if "`var'"=="homecost" local vartemp "Cost of Housing"
        if "`var'"=="crime" local vartemp "Crime"
        if "`var'"=="taxes" local vartemp "Taxes"
        if "`var'"=="family" local vartemp "Family"
        if "`var'"=="norms" local vartemp "Norms"
        if "`var'"=="size" local vartemp "Square Footage"
        if "`var'"=="schqual" local vartemp "School Quality"
        if "`var'"=="dist" local vartemp "Distance"
        if "`var'"=="mvcost" local vartemp "Box and Truck Costs"
        if "`var'"=="withincitymove" local vartemp "Local Move"
        if "`var'"=="copyhome" local vartemp "Current Residence"
        if "`var'"=="moved" local vartemp "Nonpecuniary Moving Costs"
        twoway histogram wtp_`var' if temp_touse_`var'==1, vertical graphregion(color(white)) ytitle("Density") xtitle("WTP for `vartemp'" " " "({&mu} = `meany'; median = `medy'; p10 = `p10y'; p90 = `p90y'; N = `ny')") color(navy)
        graph export ${graphpath}histo_wtp_`var'.eps, replace

        sum b_`var', d

        local meany = `: di %4.2f `r(mean)''
        local p10y  = `: di %4.2f `r(p10)''
        local medy  = `: di %4.2f `r(p50)''
        local p90y  = `: di %4.2f `r(p90)''
        local ny = `: di %9.3f `r(N)''
        file write T1 "`vartemp'" " & " %4.2f (`p10y')  " & " %4.2f (`medy')    " & " %4.2f (`p90y')  " & " %9.0fc (`ny')    "  \\ "  _n 
    }
    file write T1 "\bottomrule " _n 
    file write T1 "\end{tabular} " _n 
    file write T1 "\footnotesize{Note: Estimates exclude those with very small, negative, or undefined income elasticity (36\% of the full \$ N = 2,110 \$ sample).}" _n
    file write T1 "\end{threeparttable} " _n 
    file write T1 "\end{table} " _n 
    file close T1
restore

log close

