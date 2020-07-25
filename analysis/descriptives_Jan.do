
** Reasons for not moving

local v = 1
foreach var of varlist qmv10_* {
    qui gen t`var' = inlist(`var',4,5)*100 if !mi(`var')
    qui sum t`var' [aw=rim_4_original]
    if "`v'"=="1" local N_all = `r(N)'
    local mu`v'_all = `r(mean)'
    local sd`v'_all = `r(sd)'
    local mn`v'_all = `r(min)'
    local mx`v'_all = `r(max)'
    forval x=1/3 {
        qui sum t`var' [aw=rim_4_original] if qmv12==`x'
        local mu`v'_`x' = `r(mean)'
        if "`v'"=="1" local N_`x' = `r(N)'
    }
local ++v
}

capture file close T3
file open T3 using "${tablepath}ReasonsNotMove.tex", write replace
file write T3 "\begin{table}[ht]" _n 
file write T3 "\caption{Most common reasons to not move (\%)}" _n 
file write T3 "\label{tab:descT3}" _n 
file write T3 "\centering" _n 
file write T3 "\begin{threeparttable}" _n 
file write T3 "\begin{tabular}{lcccc}" _n 
file write T3 "\toprule " _n 
file write T3 "Reason & All & Mobile & Stuck & Rooted \\" _n 
file write T3 "\midrule " _n 
file write T3 "Like current home                                    " " & " %2.0f  (`mu1_all')  " & " %2.0f  (`mu1_1')  " & " %2.0f  (`mu1_2')  " & " %2.0f  (`mu1_3')  " \\ "  _n 
file write T3 "Like neighborhood and climate                        " " & " %2.0f  (`mu22_all') " & " %2.0f  (`mu22_1') " & " %2.0f  (`mu22_2') " & " %2.0f  (`mu22_3') " \\ "  _n 
file write T3 "Can't afford to buy home in places I want to move    " " & " %2.0f  (`mu3_all')  " & " %2.0f  (`mu3_1')  " & " %2.0f  (`mu3_2')  " & " %2.0f  (`mu3_3')  " \\ "  _n 
file write T3 "Closeness to family and friends                      " " & " %2.0f  (`mu21_all') " & " %2.0f  (`mu21_1') " & " %2.0f  (`mu21_2') " & " %2.0f  (`mu21_3') " \\ "  _n 
file write T3 "Can't afford high cost of moving                     " " & " %2.0f  (`mu2_all')  " & " %2.0f  (`mu2_1')  " & " %2.0f  (`mu2_2')  " & " %2.0f  (`mu2_3')  " \\ "  _n 
file write T3 "Like my current job                                  " " & " %2.0f  (`mu8_all')  " & " %2.0f  (`mu8_1')  " & " %2.0f  (`mu8_2')  " & " %2.0f  (`mu8_3')  " \\ "  _n 
file write T3 "Worry about crime rates in other locations           " " & " %2.0f  (`mu24_all') " & " %2.0f  (`mu24_1') " & " %2.0f  (`mu24_2') " & " %2.0f  (`mu24_3') " \\ "  _n 
file write T3 "Hard to find job elsewhere                           " " & " %2.0f  (`mu9_all')  " & " %2.0f  (`mu9_1')  " & " %2.0f  (`mu9_2')  " & " %2.0f  (`mu9_3')  " \\ "  _n 
file write T3 "Hard for spouse to find job elsewhere                " " & " %2.0f  (`mu10_all') " & " %2.0f  (`mu10_1') " & " %2.0f  (`mu10_2') " & " %2.0f  (`mu10_3') " \\ "  _n 
file write T3 "Good quality of local schools                        " " & " %2.0f  (`mu20_all') " & " %2.0f  (`mu20_1') " & " %2.0f  (`mu20_2') " & " %2.0f  (`mu20_3') " \\ "  _n 
file write T3 "Very involved in community/church--share values      " " & " %2.0f  (`mu23_all') " & " %2.0f  (`mu23_1') " & " %2.0f  (`mu23_2') " & " %2.0f  (`mu23_3') " \\ "  _n 
file write T3 "Locked in low mortgage rate                          " " & " %2.0f  (`mu6_all')  " & " %2.0f  (`mu6_1')  " & " %2.0f  (`mu6_2')  " & " %2.0f  (`mu6_3')  " \\ "  _n 
file write T3 "Difficult to qualify for new mortgage                " " & " %2.0f  (`mu7_all')  " & " %2.0f  (`mu7_1')  " & " %2.0f  (`mu7_2')  " & " %2.0f  (`mu7_3')  " \\ "  _n 
file write T3 "May lose Medicaid coverage if I move to another state" " & " %2.0f  (`mu13_all') " & " %2.0f  (`mu13_1') " & " %2.0f  (`mu13_2') " & " %2.0f  (`mu13_3') " \\ "  _n  
file write T3 "Am not licensed to work in other states              " " & " %2.0f  (`mu11_all') " & " %2.0f  (`mu11_1') " & " %2.0f  (`mu11_2') " & " %2.0f  (`mu11_3') " \\ "  _n  
file write T3 "May lose or receive fewer welfare benefits           " " & " %2.0f  (`mu14_all') " & " %2.0f  (`mu14_1') " & " %2.0f  (`mu14_2') " & " %2.0f  (`mu14_3') " \\ "  _n  
file write T3 "\midrule " _n
file write T3 "Sample size                     " " & " %5.0fc (`N_all') " & " %5.0fc (`N_1') " & " %5.0fc (`N_2') " & " %5.0fc (`N_3') " \\ "  _n 
file write T3 "\bottomrule " _n 
file write T3 "\end{tabular} " _n 
file write T3 "\footnotesize{Source: Survey of Consumer Expectations collected in January 2018." _n 
file write T3 " " _n 
file write T3 "Note: Numbers are percentages of respondents who listed the reason as very important or extremely important. For details, see Section \ref{sec:data}.}" _n 
file write T3 "\end{threeparttable} " _n 
file write T3 "\end{table} " _n 
file close T3


** Reasons for moving

local v = 1
foreach var of varlist qmv11_* {
    qui gen t`var' = inlist(`var',4,5)*100 if !mi(`var')
    qui sum t`var' [aw=rim_4_original]
    if "`v'"=="1" local N_all = `r(N)'
    local mu`v'_all = `r(mean)'
    local sd`v'_all = `r(sd)'
    local mn`v'_all = `r(min)'
    local mx`v'_all = `r(max)'
    forval x=1/3 {
        qui sum t`var' [aw=rim_4_original] if qmv12==`x'
        local mu`v'_`x' = `r(mean)'
        *if "`v'"=="19" local N_`x' = `r(N)'
    }
local ++v
}

capture file close T4
file open T4 using "${tablepath}ReasonsToMove.tex", write replace
file write T4 "\begin{table}[ht]" _n 
file write T4 "\caption{Most common reasons to move (\%)}" _n 
file write T4 "\label{tab:descT4}" _n 
file write T4 "\centering" _n 
file write T4 "\begin{threeparttable}" _n 
file write T4 "\begin{tabular}{lcccc}" _n 
file write T4 "\toprule " _n 
file write T4 "Reason & All & Mobile & Stuck & Rooted \\" _n 
file write T4 "\midrule " _n 
file write T4 "To be in a more desirable neighborhood or climate       " " & " %2.0f  (`mu20_all') " & " %2.0f  (`mu20_1') " & " %2.0f  (`mu20_2') " & " %2.0f  (`mu20_3') " \\ "  _n 
file write T4 "To reduce housing costs                                 " " & " %2.0f  (`mu4_all')  " & " %2.0f  (`mu4_1')  " & " %2.0f  (`mu4_2')  " & " %2.0f  (`mu4_3')  " \\ "  _n 
file write T4 "To be closer to family and friends                      " " & " %2.0f  (`mu19_all') " & " %2.0f  (`mu19_1') " & " %2.0f  (`mu19_2') " & " %2.0f  (`mu19_3') " \\ "  _n 
file write T4 "To be in a safer neighborhood                           " " & " %2.0f  (`mu21_all') " & " %2.0f  (`mu21_1') " & " %2.0f  (`mu21_2') " & " %2.0f  (`mu21_3') " \\ "  _n 
file write T4 "To upgrade to a larger/better quality home              " " & " %2.0f  (`mu3_all')  " & " %2.0f  (`mu3_1')  " & " %2.0f  (`mu3_2')  " & " %2.0f  (`mu3_3')  " \\ "  _n 
file write T4 "A new job or job transfer                               " " & " %2.0f  (`mu6_all')  " & " %2.0f  (`mu6_1')  " & " %2.0f  (`mu6_2')  " & " %2.0f  (`mu6_3')  " \\ "  _n 
file write T4 "Better access to amenities (restaurants, theaters, etc.)" " & " %2.0f  (`mu25_all') " & " %2.0f  (`mu25_1') " & " %2.0f  (`mu25_2') " & " %2.0f  (`mu25_3') " \\ "  _n 
file write T4 "To be in better school district/access to better schools" " & " %2.0f  (`mu22_all') " & " %2.0f  (`mu22_1') " & " %2.0f  (`mu22_2') " & " %2.0f  (`mu22_3') " \\ "  _n 
file write T4 "A new job or job transfer of spouse/partner             " " & " %2.0f  (`mu7_all')  " & " %2.0f  (`mu7_1')  " & " %2.0f  (`mu7_2')  " & " %2.0f  (`mu7_3')  " \\ "  _n 
file write T4 "Don't like my current home                              " " & " %2.0f  (`mu2_all')  " & " %2.0f  (`mu2_1')  " & " %2.0f  (`mu2_2')  " & " %2.0f  (`mu2_3')  " \\ "  _n 
file write T4 "Change in household composition                         " " & " %2.0f  (`mu14_all') " & " %2.0f  (`mu14_1') " & " %2.0f  (`mu14_2') " & " %2.0f  (`mu14_3') " \\ "  _n 
file write T4 "Cultural values                                         " " & " %2.0f  (`mu26_all') " & " %2.0f  (`mu26_1') " & " %2.0f  (`mu26_2') " & " %2.0f  (`mu26_3') " \\ "  _n 
file write T4 "To reduce commuting time to work/school                 " " & " %2.0f  (`mu9_all')  " & " %2.0f  (`mu9_1')  " & " %2.0f  (`mu9_2')  " & " %2.0f  (`mu9_3')  " \\ "  _n 
file write T4 "To look for a job                                       " " & " %2.0f  (`mu10_all') " & " %2.0f  (`mu10_1') " & " %2.0f  (`mu10_2') " & " %2.0f  (`mu10_3') " \\ "  _n  
file write T4 "May gain Medicaid coverage if I move to another state   " " & " %2.0f  (`mu12_all') " & " %2.0f  (`mu12_1') " & " %2.0f  (`mu12_2') " & " %2.0f  (`mu12_3') " \\ "  _n  
file write T4 "May gain or receive more welfare benefits               " " & " %2.0f  (`mu13_all') " & " %2.0f  (`mu13_1') " & " %2.0f  (`mu13_2') " & " %2.0f  (`mu13_3') " \\ "  _n  
file write T4 "\midrule " _n
file write T4 "Sample size                     " " & " %5.0fc (`N_all') " & " %5.0fc (`N_1') " & " %5.0fc (`N_2') " & " %5.0fc (`N_3') " \\ "  _n 
file write T4 "\bottomrule " _n 
file write T4 "\end{tabular} " _n 
file write T4 "\footnotesize{Source: Survey of Consumer Expectations collected in January 2018." _n 
file write T4 " " _n 
file write T4 "Note: Numbers are percentages of respondents who listed the reason as very important or extremely important. For details, see Section \ref{sec:data}.}" _n 
file write T4 "\end{threeparttable} " _n 
file write T4 "\end{table} " _n 
file close T4

