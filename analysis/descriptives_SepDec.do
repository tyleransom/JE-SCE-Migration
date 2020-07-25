/*
*---------------------------------------------
* Histograms of time spent on survey
*---------------------------------------------
forv w=0/2 {
    sum total_svy_time [w=rim_4_original] if total_svy_time<120,d
    local meany = `: di %4.2f `r(mean)''
    local medy  = `: di %4.2f `r(p50)''
    local ny = `: di %4.0fc `r(N)''
    twoway histogram total_svy_time [fw=rim1000] if wave==`w' & total_svy_time<120, discrete width(1) start(0) vertical graphregion(color(white)) ytitle("Proportion") xtitle("Time spent on survey (in minutes)" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
    graph export ${graphpath}timeSpentW`w'.eps, replace
    twoway histogram total_svy_time  if wave==`w' & total_svy_time<120, discrete width(1) start(0) vertical graphregion(color(white)) ytitle("Proportion") xtitle("Time spent on survey (in minutes)" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
    graph export ${graphpath}timeSpentNoWgtW`w'.eps, replace
}
*/

*---------------------------------------------
* Distribution of scenarios per person, fraction of never-movers
*---------------------------------------------
d
codebook scuid
tempfile nevermovers
preserve
    use ${datapath}long_panel_SepDec, clear
    sort scuid wave blk scen alt
    drop if mi(p)
    bys scuid (blk scen alt): egen choicenum = seq()
    xtset scuid choicenum
    bys scuid (choicenum): egen maxchoicenum = total(choicenum>0)
    replace maxchoicenum = maxchoicenum/3 // divide by three since each scenario has two probabilities, but I just want to see how many scenarios there were
    bys scuid (choicenum): gen firstObs = _n==1
    distinct scuid
    keep if inlist(maxchoicenum,16)
    distinct scuid
    tab maxchoicenum if firstObs
    * sample size if include Case 4 of Sep
    xtsum scuid if inlist(alt,"a","b")

    * drop Case 4 of Sep
    drop if blk==34
    distinct scuid
    drop maxchoicenum
    bys scuid (choicenum): egen maxchoicenum = total(choicenum>0)
    replace maxchoicenum = maxchoicenum/3 
    tab maxchoicenum if firstObs
    tabout maxchoicenum if firstObs using ${tablepath}DistnScenPerPerson.tex, c(freq col) replace format(0c 1) h3("Number of scenarios & Number of individuals & Percent of sample \\") bt style(tex)
    !sed -i '5i\ \\\midrule' ${tablepath}DistnScenPerPerson.tex
    * sample size if exclude Case 4 of Sep
    xtsum scuid if inlist(alt,"a","b")

    * zero variation in p across all scenarios within individual:
    gen altnum = cond(alt=="a",1,   cond(alt=="b",2,   cond(alt=="c",3,.    ))) 
    forv x=1/3 {
        egen mSDp`x' = sd(p) if altnum==`x', by(wave scuid)
        egen  SDp`x' = mean(mSDp`x'), by(wave scuid)
        drop mSDp`x'
    }
    gen zeroSDpall = SDp1==0 & SDp2==0 & SDp3==0


    * never-movers
    keep if altnum==1
    distinct scuid
    egen nm = total(p==100), by(wave scuid)
    gen never_mover = nm==maxchoicenum

    tab never_mover if firstObs, mi

    tab zeroSDpall if firstObs, mi
    
    tab maxchoicenum if zeroSDpall==0 & firstObs
    tabout maxchoicenum if zeroSDpall==0 & firstObs using ${tablepath}DistnScenPerPersonNM.tex, c(freq col) replace format(0c 1) h3("Number of scenarios & Number of individuals & Percent of sample \\") bt style(tex)
    !sed -i '5i\ \\\midrule' ${tablepath}DistnScenPerPersonNM.tex


    * histograms
    gen nm_round = round(nm/maxchoicenum*100) if firstObs
    
    sum nm_round, d
    local meany = `: di %4.2f `r(mean)''
    local medy  = `: di %4.2f `r(p50)''
    local ny = `: di %4.0fc `r(N)''
    twoway histogram nm_round , discrete width(1) start(0) vertical graphregion(color(white)) ytitle("Proportion") xtitle("Percent of alternatives with 100% Pr(stay)" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
    graph export ${graphpath}nmSepDec.eps, replace

    sum nm_round if wave==1,d
    local meany = `: di %4.2f `r(mean)''
    local medy  = `: di %4.2f `r(p50)''
    local ny = `: di %4.0fc `r(N)''
    twoway histogram nm_round if wave==1 , discrete width(1) start(0) vertical graphregion(color(white)) ytitle("Proportion") xtitle("Percent of alternatives with 100% Pr(stay)" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
    graph export ${graphpath}nmSep.eps, replace
    
    sum nm_round if wave==2,d
    local meany = `: di %4.2f `r(mean)''
    local medy  = `: di %4.2f `r(p50)''
    local ny = `: di %4.0fc `r(N)''
    twoway histogram nm_round if wave==2 , discrete width(1) start(0) vertical graphregion(color(white)) ytitle("Proportion") xtitle("Percent of alternatives with 100% Pr(stay)" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
    graph export ${graphpath}nmDec.eps, replace

    keep if firstObs
    codebook scuid if inlist(wave,1,2)
    keep scuid zeroSDpall never_mover
    mdesc 
    mdesc  if zeroSDpall==0
    save `nevermovers', replace
    drop never_mover
    ren zeroSDpall nevermover
    save ${datapath}never_movers.dta, replace
restore



*---------------------------------------------
* who are the never-movers?
*---------------------------------------------
preserve
    count
    codebook scuid if wave>=1
    distinct scuid
    gen healthy = inlist(health,1,2)
    * exclude January wave
    *drop if wave==0
    count
    * merge in never mover calculations from just above
    merge m:1 scuid using `nevermovers', nogen keep(match master)
    distinct scuid
    * merge in data on risk attitudes, etc.
    capture drop q46b_1 q46c_1 qnum8 qnum9
    capture drop _merge
    merge 1:1 scuid using ${datapath}model_output_ids_merged_with_core_data.dta, keepusing(q46b_1 q46c_1 qnum8 qnum9) keep(match master)
    *tostring scuid, gen(strid)
    *tab strid if _merge==1
    *tab strid if _merge==2
    tab qnum8, mi
    tab qnum9, mi
    gen confused_inflation = inlist(qnum8,1,2) if qnum8<=3
    gen confused_risk = inlist(qnum9,1) if qnum9<=2
    sum confused*
    gen risky1 = inlist(q46b_1,6,7) if inrange(q46b_1,1,7)
    gen risky2 = inlist(q46c_1,6,7) if inrange(q46c_1,1,7)
    sum risky?
    * regression (LPM)
    local covars total_svy_time i.long_svy_time i.short_svy_time i.qmv12 c.agenew i.female i.white i.grad4yr i.married i.haskids_in_home i.healthy i.residence i.empFT i.ownhome
    local risk_lit_vars risky1 risky2 confused_inflation confused_risk
    reg never_mover `covars', r
    reg zeroSDpall  `covars', r
    reg zeroSDpall `covars' `risk_lit_vars', r
    qui outreg2 using ${tablepath}WhoAreNeverMovers.tex, replace se bdec(3) sdec(3) tex(frag) ctitle("Full Sample")
    !sed -i "s|VARIABLES|Characteristic|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|bad\\\_income|\\`=char(36)'1\[\\\beta_\{inc\}<0.1\]\`=char(36)'|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|total\\\_svy\\\_time|Time spent on survey|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|confused\\\_inflation|Questionable numeracy|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|confused\\\_risk|Questionable financial literacy|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|risky1|Willing to take risks in financial matters|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|risky2|Willing to take risks in everyday activities|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|1\.long\\\_svy\\\_time|Took more than 90 minutes on survey|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|1\.short\\\_svy\\\_time|Took fewer than 15 minutes on survey|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|2\.qmv12|Stuck|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|3\.qmv12|Rooted|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|agenew|Age|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|1\.female|Female|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|1\.white|White|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|1\.grad4yr|College graduate|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|1\.married|Married|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|1\.haskids\\\_in\\\_home|Lives with children|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|1\.healthy|Healthy|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|2\.residence|Lives in Suburb|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|3\.residence|Lives in Rural|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|1\.empFT|Employed full-time|ig" "${tablepath}WhoAreNeverMovers.tex"
    !sed -i "s|1\.ownhome|Homeowner|ig" "${tablepath}WhoAreNeverMovers.tex"
    * remove rows that talk about statistical significance or standard errors
    !sed -i '/multicolumn/d' ${tablepath}WhoAreNeverMovers.tex
    reg zeroSDpall `covars' risky?, r


    *gen healthy = inlist(health,1,2)
    gen city    = residence==1
    gen suburb  = residence==2
    gen inc000  = hhincome/1000
    gen movep   = qmv7_1/100
    gen movedLY = inrange(qmv1_1,0,1)
    gen mobile  = qmv12==1
    gen stuck   = qmv12==2
    gen rooted  = qmv12==3
    *gen nearfam = qmv5==1 if !mi(qmv5)
    local v = 1
    foreach var in movep female white black latin asian agenew married haskids_in_home grad4yr ownhome healthy inc000 qmv1_1 samecounty samestate diffstate diffcountry city suburb regNE regMW regS movedLY mobile stuck rooted nearfam {
        qui sum `var' [aw=rim_4_original]
        if "`v'"=="2" local N_all = `r(N)'
        local mu`v'_all = `r(mean)'
        local sd`v'_all = `r(sd)'
        local mn`v'_all = `r(min)'
        local mx`v'_all = `r(max)'
        qui sum `var' [aw=rim_4_original] if zeroSDpall==1
        local N`v'_1 = `r(N)'
        local mu`v'_1 = `r(mean)'
        qui sum `var' [aw=rim_4_original] if zeroSDpall==0
        local N`v'_0 = `r(N)'
        local mu`v'_0 = `r(mean)'
        quietly ttest `var'==`mu`v'_1' if zeroSDpall==0
        local star`v'_1 = "" 
        if `r(p)'<0.05 local star`v'_1 = "*"
    local ++v
    }
    ** Descriptives SCE by mobile/stuck/rooted
    capture file close TAx
    file open TAx using "${tablepath}NeverMoverDescriptiveTable.tex", write replace
    file write TAx "\begin{table}[ht]" _n 
    file write TAx "\caption{Characteristics of Ever- and Never-Movers}" _n 
    file write TAx "\label{tab:descEverNeverMover}" _n 
    file write TAx "\centering" _n 
    file write TAx "\begin{threeparttable}" _n 
    file write TAx "\begin{tabular}{lccc}" _n 
    file write TAx "\toprule " _n 
    file write TAx "Variable & Ever-Mover & Never-Mover & Total \\" _n 
    file write TAx "\midrule " _n 
*file write T4 "To be in a more desirable neighborhood or climate       " " & " %2.0f  (`mu20_all') " & " %2.0f  (`mu20_1') " & " %2.0f  (`mu20_2') " & " %2.0f  (`mu20_3') " \\ "  _n 
    di %4.2f `mu2_0'
    di %4.2f `mu2_1'
    di "`star2_1'"
    di %4.2f `mu2_all'
    file write TAx "Female                                   " " & " %4.2f  (`mu2_0')   " & " %4.2f  (`mu2_1')  "`star2_1'"  " & " %4.2f  (`mu2_all')  " \\ "  _n 
    file write TAx "White                                    " " & " %4.2f  (`mu3_0')   " & " %4.2f  (`mu3_1')  "`star3_1'"  " & " %4.2f  (`mu3_all')  " \\ "  _n 
    file write TAx "Age                                      " " & " %4.2f  (`mu7_0')   " & " %4.2f  (`mu7_1')  "`star7_1'"  " & " %4.2f  (`mu7_all')  " \\ "  _n 
    file write TAx "Married                                  " " & " %4.2f  (`mu8_0')   " & " %4.2f  (`mu8_1')  "`star8_1'"  " & " %4.2f  (`mu8_all')  " \\ "  _n 
    file write TAx "Lives with children                      " " & " %4.2f  (`mu9_0')   " & " %4.2f  (`mu9_1')  "`star9_1'"  " & " %4.2f  (`mu9_all')  " \\ "  _n 
    file write TAx "College graduate                         " " & " %4.2f  (`mu10_0')  " & " %4.2f  (`mu10_1') "`star10_1'" " & " %4.2f  (`mu10_all') " \\ "  _n 
    file write TAx "Owns home                                " " & " %4.2f  (`mu11_0')  " & " %4.2f  (`mu11_1') "`star11_1'" " & " %4.2f  (`mu11_all') " \\ "  _n 
    *file write TAx "Healthy                                  " " & " %4.2f  (`mu12_0')  " & " %4.2f  (`mu12_1') "`star12_1'" " & " %4.2f  (`mu12_all') " \\ "  _n 
    file write TAx "Income (\\$1000)                         " " & " %4.2f  (`mu13_0')  " & " %4.2f  (`mu13_1') "`star13_1'" " & " %4.2f  (`mu13_all') " \\ "  _n 
    *file write TAx "Lives near family                        " " & " %4.2f  (`mu28_0')  " & " %4.2f  (`mu28_1') "`star28_1'" " & " %4.2f  (`mu28_all') " \\ "  _n 
    file write TAx "Pr(move) in next two years               " " & " %4.2f  (`mu1_0')   " & " %4.2f  (`mu1_1')  "`star1_1'"  " & " %4.2f  (`mu1_all')  " \\ "  _n 
    file write TAx "Moved during previous year               " " & " %4.2f  (`mu24_0')  " & " %4.2f  (`mu24_1') "`star24_1'" " & " %4.2f  (`mu24_all') " \\ "  _n  
    file write TAx "Years lived in current residence         " " & " %4.2f  (`mu14_0')  " & " %4.2f  (`mu14_1') "`star14_1'" " & " %4.2f  (`mu14_all') " \\ "  _n  
    file write TAx "Mobile                                   " " & " %4.2f  (`mu25_0')  " & " %4.2f  (`mu25_1') "`star25_1'" " & " %4.2f  (`mu25_all') " \\ "  _n  
    file write TAx "Stuck                                    " " & " %4.2f  (`mu26_0')  " & " %4.2f  (`mu26_1') "`star26_1'" " & " %4.2f  (`mu26_all') " \\ "  _n  
    file write TAx "Rooted                                   " " & " %4.2f  (`mu27_0')  " & " %4.2f  (`mu27_1') "`star27_1'" " & " %4.2f  (`mu27_all') " \\ "  _n  
    *file write TAx "Prior to moving to current residence: \\ "  _n                                                                         
    *file write TAx "~~Lived in same county                   " " & " %4.2f  (`mu15_0')  " & " %4.2f  (`mu15_1') "`star15_1'" " & " %4.2f  (`mu15_all') " \\ "  _n  
    *file write TAx "~~Lived in same state, diff county       " " & " %4.2f  (`mu16_0')  " & " %4.2f  (`mu16_1') "`star16_1'" " & " %4.2f  (`mu16_all') " \\ "  _n  
    *file write TAx "~~Lived in different state               " " & " %4.2f  (`mu17_0')  " & " %4.2f  (`mu17_1') "`star17_1'" " & " %4.2f  (`mu17_all') " \\ "  _n  
    *file write TAx "~~Lived in different country             " " & " %4.2f  (`mu18_0')  " & " %4.2f  (`mu18_1') "`star18_1'" " & " %4.2f  (`mu18_all') " \\ "  _n  
    *file write TAx "Lives in city                            " " & " %4.2f  (`mu19_0')  " & " %4.2f  (`mu19_1') "`star19_1'" " & " %4.2f  (`mu19_all') " \\ "  _n  
    *file write TAx "Lives in suburb                          " " & " %4.2f  (`mu20_0')  " & " %4.2f  (`mu20_1') "`star20_1'" " & " %4.2f  (`mu20_all') " \\ "  _n  
    *file write TAx "Lives in Northeast                       " " & " %4.2f  (`mu21_0')  " & " %4.2f  (`mu21_1') "`star21_1'" " & " %4.2f  (`mu21_all') " \\ "  _n  
    *file write TAx "Lives in Midwest                         " " & " %4.2f  (`mu22_0')  " & " %4.2f  (`mu22_1') "`star22_1'" " & " %4.2f  (`mu22_all') " \\ "  _n  
    *file write TAx "Lives in South                           " " & " %4.2f  (`mu23_0')  " & " %4.2f  (`mu23_1') "`star23_1'" " & " %4.2f  (`mu23_all') " \\ "  _n  
    file write TAx "\midrule " _n
    file write TAx "Sample size                     " " & " %5.0fc (`N2_0') " & " %5.0fc (`N2_1') " & " %5.0fc (`N_all') " \\ "  _n 
    file write TAx "\bottomrule " _n 
    file write TAx "\end{tabular} " _n 
    file write TAx "\footnotesize{Source: Survey of Consumer Expectations collected in September 2018 and December 2019. " _n
    file write TAx " " _n 
    file write TAx "\bigskip{} " _n 
    file write TAx " " _n 
    file write TAx "Notes: Never-mover refers to an individual who reported the same exact choice probability in every single scenario. * indicates significantly different from ever-movers at the 5\% level. Family proximity was only collected for the September and December waves. For further details, see Section \ref{sec:data} and notes to Table \ref{tab:descT1}.}" _n 
    file write TAx "\end{threeparttable} " _n 
    file write TAx "\end{table} " _n 
    file close TAx


restore
    

*---------------------------------------------
* Histograms of choice probabilities
*---------------------------------------------
preserve
    use ${datapath}long_panel_SepDec, clear
    * Histograms
    sum p if wave==1,d
    local meany = `: di %4.2f `r(mean)''
    local medy  = `: di %4.2f `r(p50)''
    local ny = `: di %4.0fc `r(N)''
    twoway histogram p if wave==1 , discrete width(1) start(0) vertical graphregion(color(white)) ytitle("Proportion") xtitle("Percentage chance of choosing a given alternative" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
    graph export ${graphpath}pSep.eps, replace

    sum p if wave==2,d
    local meany = `: di %4.2f `r(mean)''
    local medy  = `: di %4.2f `r(p50)''
    local ny = `: di %4.0fc `r(N)''
    twoway histogram p if wave==2 , discrete width(1) start(0) vertical graphregion(color(white)) ytitle("Proportion") xtitle("Percentage chance of choosing a given alternative" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
    graph export ${graphpath}pDec.eps, replace

    sum p if wave==1 & alternative==1,d
    local meany = `: di %4.2f `r(mean)''
    local medy  = `: di %4.2f `r(p50)''
    local ny = `: di %4.0fc `r(N)''
    twoway histogram p if wave==1 & alternative==1 , discrete width(1) start(0) vertical graphregion(color(white)) yscale(range(0 .6)) ylabel(0(.1).6) ytitle("Proportion") xtitle("Percentage chance of choosing alternative 1" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
    graph export ${graphpath}p1Sep.eps, replace

    sum p if wave==1 & alternative==2,d
    local meany = `: di %4.2f `r(mean)''
    local medy  = `: di %4.2f `r(p50)''
    local ny = `: di %4.0fc `r(N)''
    twoway histogram p if wave==1 & alternative==2 , discrete width(1) start(0) vertical graphregion(color(white)) yscale(range(0 .6)) ylabel(0(.1).6) ytitle("Proportion") xtitle("Percentage chance of choosing alternative 2" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
    graph export ${graphpath}p2Sep.eps, replace

    sum p if wave==1 & alternative==3,d
    local meany = `: di %4.2f `r(mean)''
    local medy  = `: di %4.2f `r(p50)''
    local ny = `: di %4.0fc `r(N)''
    twoway histogram p if wave==1 & alternative==3 , discrete width(1) start(0) vertical graphregion(color(white)) yscale(range(0 .6)) ylabel(0(.1).6) ytitle("Proportion") xtitle("Percentage chance of choosing alternative 3" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
    graph export ${graphpath}p3Sep.eps, replace

    sum p if wave==2 & alternative==1,d
    local meany = `: di %4.2f `r(mean)''
    local medy  = `: di %4.2f `r(p50)''
    local ny = `: di %4.0fc `r(N)''
    twoway histogram p if wave==1 & alternative==1 , discrete width(1) start(0) vertical graphregion(color(white)) yscale(range(0 .6)) ylabel(0(.1).6) ytitle("Proportion") xtitle("Percentage chance of choosing alternative 1" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
    graph export ${graphpath}p1Dec.eps, replace

    sum p if wave==2 & alternative==2,d
    local meany = `: di %4.2f `r(mean)''
    local medy  = `: di %4.2f `r(p50)''
    local ny = `: di %4.0fc `r(N)''
    twoway histogram p if wave==1 & alternative==2 , discrete width(1) start(0) vertical graphregion(color(white)) yscale(range(0 .6)) ylabel(0(.1).6) ytitle("Proportion") xtitle("Percentage chance of choosing alternative 2" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
    graph export ${graphpath}p2Dec.eps, replace

    sum p if wave==2 & alternative==3,d
    local meany = `: di %4.2f `r(mean)''
    local medy  = `: di %4.2f `r(p50)''
    local ny = `: di %4.0fc `r(N)''
    twoway histogram p if wave==1 & alternative==3 , discrete width(1) start(0) vertical graphregion(color(white)) yscale(range(0 .6)) ylabel(0(.1).6) ytitle("Proportion") xtitle("Percentage chance of choosing alternative 3" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
    graph export ${graphpath}p3Dec.eps, replace

    graph bar p if wave==1, over(alternative) graphregion(color(white)) ytitle("Mean percentage chance") b1title("Choice alternative")
    graph export ${graphpath}pAltSep.eps, replace

    graph bar p if wave==2, over(alternative) graphregion(color(white)) ytitle("Mean percentage chance") b1title("Choice alternative")
    graph export ${graphpath}pAltDec.eps, replace
restore

/*
*---------------------------------------------
* Migration histograms
*---------------------------------------------

* qmv1= how many years lived at current location  
sum qmv1_1 [w=rim_4_original],d
local meany = `: di %4.2f `r(mean)''
local medy  = `: di %4.2f `r(p50)''
local ny = `: di %4.0fc `r(N)''
twoway histogram qmv1_1 [fw=rim1000], discrete width(1) start(0) vertical graphregion(color(white)) ytitle("Proportion") xtitle("Years lived at current location" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
graph export ${graphpath}yrsCurrLoc.eps, replace
twoway histogram qmv1_1 , discrete width(1) start(0) vertical graphregion(color(white)) ytitle("Proportion") xtitle("Years lived at current location" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
graph export ${graphpath}yrsCurrLocNoWgt.eps, replace

* qmv1a= size of current residence  
sum qmv1a_1 [w=rim_4_original],d
local meany = `: di %4.2f `r(mean)''
local medy  = `: di %4.2f `r(p50)''
local ny = `: di %4.0fc `r(N)''
twoway histogram qmv1a_1 [fw=rim1000], start(400) vertical graphregion(color(white)) ytitle("Proportion") xtitle("Size of current residence (sq. ft.)" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
graph export ${graphpath}sizeCurrRes.eps, replace
*/

* qmv7= prob of moving in next 2 years  
sum qmv7_1 [w=rim_4_original],d
local meany = `: di %4.2f `r(mean)''
local medy  = `: di %4.2f `r(p50)''
local ny = `: di %4.0fc `r(N)''
twoway histogram qmv7_1 [fw=rim1000], discrete width(1) start(0) vertical graphregion(color(white)) ytitle("Proportion") xtitle("Likelihood of moving in next 2 years" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
graph export ${graphpath}migrationLikelihood_SepDec.eps, replace

/*
* qmv14= if move prob it will be this far ..  
sum qmv14_1 [w=rim_4_original],d
local meany = `: di %4.2f `r(mean)''
local medy  = `: di %4.2f `r(p50)''
local ny = `: di %4.0fc `r(N)''
twoway histogram qmv14_1 [fw=rim1000], discrete width(1) start(0) vertical graphregion(color(white)) ytitle("Proportion") xtitle("Likelihood of moving <10 miles in next 2 years" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
graph export ${graphpath}migrationLikelihoodLT10mi_SepDec.eps, replace

sum qmv14_2 [w=rim_4_original],d
local meany = `: di %4.2f `r(mean)''
local medy  = `: di %4.2f `r(p50)''
local ny = `: di %4.0fc `r(N)''
twoway histogram qmv14_2 [fw=rim1000], discrete width(1) start(0) vertical graphregion(color(white)) ytitle("Proportion") xtitle("Likelihood of moving 10-100 miles in next 2 years" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
graph export ${graphpath}migrationLikelihood10_100mi_SepDec.eps, replace

sum qmv14_3 [w=rim_4_original],d
local meany = `: di %4.2f `r(mean)''
local medy  = `: di %4.2f `r(p50)''
local ny = `: di %4.0fc `r(N)''
twoway histogram qmv14_3 [fw=rim1000], discrete width(1) start(0) vertical graphregion(color(white)) ytitle("Proportion") xtitle("Likelihood of moving 100-500 miles in next 2 years" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
graph export ${graphpath}migrationLikelihood100_500mi_SepDec.eps, replace

sum qmv14_4 [w=rim_4_original],d
local meany = `: di %4.2f `r(mean)''
local medy  = `: di %4.2f `r(p50)''
local ny = `: di %4.0fc `r(N)''
twoway histogram qmv14_4 [fw=rim1000], discrete width(1) start(0) vertical graphregion(color(white)) ytitle("Proportion") xtitle("Likelihood of moving 500+ in next 2 years" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
graph export ${graphpath}migrationLikelihoodGT500mi_SepDec.eps, replace

* median house value per sq ft in zip code
sum medhvalsqft [w=rim_4_original],d
local meany = `: di %4.2f `r(mean)''
local medy  = `: di %4.2f `r(p50)''
local ny = `: di %4.0fc `r(N)''
twoway histogram medhvalsqft [fw=rim1000], start(10) vertical graphregion(color(white)) ytitle("Proportion") xtitle("Median house value (\\$) per sq. ft. in ZIP code" "({&mu} = `meany'; median = `medy'; N = `ny')") color(navy)
graph export ${graphpath}medhvalsqft_SepDec.eps, replace
*/

*---------------------------------------------
* Sample Summary Stats (Tables 1 and 2)
*---------------------------------------------
preserve
    !gunzip -fc ${datapath}ACS/acs2017.dta.gz > tmp.dta
    use tmp, clear
    !rm -f tmp.dta
    gen inc000 = hhinc/1000 if inrange(hhinc,5000,225000)
    local v = 1
    foreach var in female white black latin asian age married lives_with_kids colgrad owner inc000 samecounty samestate diffstate diffcountry urban suburb regNE regMW regS moved {
        qui sum `var' [aw=perwt], d
        if "`v'"=="1" local ACS_N_all = `r(N)'
        local ACS_mu`v'_all = `r(mean)'
        local ACS_sd`v'_all = `r(sd)'
        local ACS_mn`v'_all = `r(min)'
        local ACS_mx`v'_all = `r(max)'
    local ++v
    }
restore





gen healthy = inlist(health,1,2)
gen city    = residence==1
gen suburb  = residence==2
gen inc000  = hhincome/1000
gen movep   = qmv7_1/100
gen movedLY = inrange(qmv1_1,0,1)
gen mobile  = qmv12==1
gen stuck   = qmv12==2
gen rooted  = qmv12==3
*gen nearfam = qmv5==1 if !mi(qmv5)
local v = 1
foreach var in movep female white black latin asian agenew married haskids_in_home grad4yr ownhome healthy inc000 qmv1_1 samecounty samestate diffstate diffcountry city suburb regNE regMW regS movedLY mobile stuck rooted nearfam agreenorms {
    qui sum `var' [aw=rim_4_original]
    if "`v'"=="2" local N_all = `r(N)'
    local mu`v'_all = `r(mean)'
    local sd`v'_all = `r(sd)'
    local mn`v'_all = `r(min)'
    local mx`v'_all = `r(max)'
    forval x=3(-1)1 {
        qui sum `var' [aw=rim_4_original] if qmv12==`x'
        local mu`v'_`x' = `r(mean)'
        if `x'<3 {
            quietly ttest `var'==`mu`v'_3' if qmv12==`x'
            local star`v'_`x' = "" 
            if `r(p)'<0.05 local star`v'_`x' = "*"
        }
    }
local ++v
}

capture drop temp
gen temp_mobile = qmv12==1
egen temp = total(temp_mobile)
qui sum temp
local mu`v'_1 = `r(mean)'

gen temp_stuck  = qmv12==2
capture drop temp
egen temp = total(temp_stuck)
qui sum temp
local mu`v'_2 = `r(mean)'

gen temp_rooted = qmv12==3
capture drop temp
egen temp = total(temp_rooted)
qui sum temp
local mu`v'_3 = `r(mean)'

local mu`v'_all = `mu`v'_1'+`mu`v'_2'+`mu`v'_3'


** Descriptives SCE vs ACS
capture file close T1
file open T1 using "${tablepath}SampleDescriptivesSepDec.tex", write replace
file write T1 "\begin{table}[ht]" _n 
file write T1 "\caption{Characteristics of SCE sample compared to 2017 ACS}" _n 
file write T1 "\label{tab:descT1}" _n 
file write T1 "\centering" _n 
file write T1 "\begin{footnotesize}" _n 
file write T1 "\begin{threeparttable}" _n 
file write T1 "\begin{tabular}{lcccc}" _n 
file write T1 "\toprule " _n 
file write T1 "         & SCE  & ACS  \\" _n 
file write T1 "Variable & Mean & Mean \\" _n 
file write T1 "\midrule " _n 
file write T1 "Female                                   " " & " %4.2f (`mu2_all')  "                        & " %4.2f (`ACS_mu1_all')  "                            \\ "  _n 
file write T1 "White                                    " " & " %4.2f (`mu3_all')  "                        & " %4.2f (`ACS_mu2_all')  "                            \\ "  _n 
file write T1 "Black                                    " " & " %4.2f (`mu4_all')  "                        & " %4.2f (`ACS_mu3_all')  "                            \\ "  _n 
file write T1 "Hispanic                                 " " & " %4.2f (`mu5_all')  "                        & " %4.2f (`ACS_mu4_all')  "                            \\ "  _n 
file write T1 "Asian                                    " " & " %4.2f (`mu6_all')  "                        & " %4.2f (`ACS_mu5_all')  "                            \\ "  _n 
file write T1 "Age                                      " " & " %4.2f (`mu7_all')  "                        & " %4.2f (`ACS_mu6_all')  "                            \\ "  _n 
file write T1 "                                         " " &(" %4.2f (`sd7_all')  ")                       &(" %4.2f (`ACS_sd6_all')  ")                           \\ "  _n 
file write T1 "                                         " " &[" %2.0f (`mn7_all')  " , " %2.0f (`mx7_all')  "]&[" %2.0f (`ACS_mn6_all')  " , " %2.0f (`ACS_mx6_all')  "]\\ "  _n 
file write T1 "Married                                  " " & " %4.2f (`mu8_all')  "                        & " %4.2f (`ACS_mu7_all')  "                            \\ "  _n 
file write T1 "Lives with children                      " " & " %4.2f (`mu9_all')  "                        & " %4.2f (`ACS_mu8_all')  "                            \\ "  _n 
file write T1 "College graduate                         " " & " %4.2f (`mu10_all') "                        & " %4.2f (`ACS_mu9_all')  "                            \\ "  _n 
file write T1 "Owns home                                " " & " %4.2f (`mu11_all') "                        & " %4.2f (`ACS_mu10_all') "                            \\ "  _n 
file write T1 "Healthy                                  " " & " %4.2f (`mu12_all') "                        & ---                                                   \\ "  _n 
file write T1 "Income (\\$1,000)                        " " & " %4.2f (`mu13_all') "                        & " %4.2f (`ACS_mu11_all') "                            \\ "  _n 
file write T1 "                                         " " &(" %4.2f (`sd13_all') ")                       &(" %4.2f (`ACS_sd11_all') ")                           \\ "  _n 
file write T1 "                                         " " &[" %2.0f (`mn13_all') " , " %2.0f (`mx13_all') "]&[" %2.0f (`ACS_mn11_all') " , " %2.0f (`ACS_mx11_all') "]\\ "  _n 
file write T1 "Lives near family                        " " & " %4.2f (`mu28_all') "                        & ---                                                   \\ "  _n 
file write T1 "Pr(move) in next two years               " " & " %4.2f (`mu1_all')  "                        & ---                                                   \\ "  _n 
file write T1 "                                         " " &(" %4.2f (`sd1_all')  ")                       & (---)                                                 \\ "  _n 
file write T1 "                                         " " &[" %1.0f (`mn1_all')  " , " %1.0f (`mx1_all')  "]& [--- , ---]                                         \\ "  _n 
file write T1 "Moved during previous year               " " & " %4.2f (`mu24_all') "                        & " %4.2f (`ACS_mu21_all') "                            \\ "  _n 
file write T1 "Years lived in current residence         " " & " %4.2f (`mu14_all') "                        & ---                                                   \\ "  _n 
file write T1 "                                         " " &(" %4.2f (`sd14_all')  ")                      & (---)                                                 \\ "  _n 
file write T1 "                                         " " &[" %1.0f (`mn14_all')  " , " %1.0f (`mx14_all')  "]& [--- , ---]                                         \\ "  _n 
file write T1 "Prior to moving to current residence: \\ "  _n 
file write T1 "~~Lived in same county                   " " & " %4.2f (`mu15_all') "                        & " %4.2f (`ACS_mu12_all') "                            \\ "  _n 
file write T1 "~~Lived in same state, diff county       " " & " %4.2f (`mu16_all') "                        & " %4.2f (`ACS_mu13_all') "                            \\ "  _n 
file write T1 "~~Lived in different state               " " & " %4.2f (`mu17_all') "                        & " %4.2f (`ACS_mu14_all') "                            \\ "  _n 
file write T1 "~~Lived in different country             " " & " %4.2f (`mu18_all') "                        & " %4.2f (`ACS_mu15_all') "                            \\ "  _n 
file write T1 "Lives in city                            " " & " %4.2f (`mu19_all') "                        & " %4.2f (`ACS_mu16_all') "                            \\ "  _n 
file write T1 "Lives in suburb                          " " & " %4.2f (`mu20_all') "                        & " %4.2f (`ACS_mu17_all') "                            \\ "  _n 
file write T1 "Lives in Northeast                       " " & " %4.2f (`mu21_all') "                        & " %4.2f (`ACS_mu18_all') "                            \\ "  _n 
file write T1 "Lives in Midwest                         " " & " %4.2f (`mu22_all') "                        & " %4.2f (`ACS_mu19_all') "                            \\ "  _n 
file write T1 "Lives in South                           " " & " %4.2f (`mu23_all') "                        & " %4.2f (`ACS_mu20_all') "                            \\ "  _n 
file write T1 "Mobile                                   " " & " %4.2f (`mu25_all') "                        & ---                                                   \\ "  _n 
file write T1 "Stuck                                    " " & " %4.2f (`mu26_all') "                        & ---                                                   \\ "  _n 
file write T1 "Rooted                                   " " & " %4.2f (`mu27_all') "                        & ---                                                   \\ "  _n 
file write T1 "\midrule " _n 
file write T1 "N                                        " " & " %10.0fc (`N_all') "                         & " %10.0fc (`ACS_N_all') "                             \\ "  _n 
file write T1 "\bottomrule " _n 
file write T1 "\end{tabular} " _n 
file write T1 "\footnotesize{Sources: Survey of Consumer Expectations collected in September 2018 and December 2019, and 2017 American Community Survey \citep{IPUMS2019}. " _n
file write T1 " " _n
file write T1 "Notes: Statistics are weighted using the weights provided by each survey. Standard deviation listed below continuous variables in parentheses. Minimum and maximum listed below continuous variables in brackets. ACS sample consists of household heads ages 18--96 to match the SCE age ranges. Income in both surveys is total household income from all sources. In the ACS, income is computed conditional on \\$5,000--\\$225,000 to match the SCE range. ACS migration distance uses PUMAs instead of counties. ACS urbanicity is computed only using households whose urbanicity is known. For further details, see Section \ref{sec:data}.}" _n 
file write T1 "\end{threeparttable} " _n 
file write T1 "\end{footnotesize} " _n 
file write T1 "\end{table} " _n 
file close T1



** Descriptives SCE by mobile/stuck/rooted
capture file close T2
file open T2 using "${tablepath}RootedDescriptivesSepDec.tex", write replace
file write T2 "\begin{table}[ht]" _n 
file write T2 "\caption{Average Characteristics of Mobile, Stuck, and Rooted}" _n 
file write T2 "\label{tab:descT2}" _n 
file write T2 "\centering" _n 
file write T2 "\begin{threeparttable}" _n 
file write T2 "\begin{tabular}{lcccc}" _n 
file write T2 "\toprule " _n 
file write T2 "Variable & Mobile & Stuck & Rooted & Total \\" _n 
file write T2 "\midrule " _n 
file write T2 "Female                                   " " & " %4.2f  (`mu2_1')  "`star2_1'"  " & " %4.2f  (`mu2_2')  "`star2_2'"  " & " %4.2f  (`mu2_3')  " & " %4.2f  (`mu2_all')  " \\ "  _n 
file write T2 "White                                    " " & " %4.2f  (`mu3_1')  "`star3_1'"  " & " %4.2f  (`mu3_2')  "`star3_2'"  " & " %4.2f  (`mu3_3')  " & " %4.2f  (`mu3_all')  " \\ "  _n 
file write T2 "Black                                    " " & " %4.2f  (`mu4_1')  "`star4_1'"  " & " %4.2f  (`mu4_2')  "`star4_2'"  " & " %4.2f  (`mu4_3')  " & " %4.2f  (`mu4_all')  " \\ "  _n 
file write T2 "Hispanic                                 " " & " %4.2f  (`mu5_1')  "`star5_1'"  " & " %4.2f  (`mu5_2')  "`star5_2'"  " & " %4.2f  (`mu5_3')  " & " %4.2f  (`mu5_all')  " \\ "  _n 
file write T2 "Asian                                    " " & " %4.2f  (`mu6_1')  "`star6_1'"  " & " %4.2f  (`mu6_2')  "`star6_2'"  " & " %4.2f  (`mu6_3')  " & " %4.2f  (`mu6_all')  " \\ "  _n 
file write T2 "Age                                      " " & " %4.2f  (`mu7_1')  "`star7_1'"  " & " %4.2f  (`mu7_2')  "`star7_2'"  " & " %4.2f  (`mu7_3')  " & " %4.2f  (`mu7_all')  " \\ "  _n 
file write T2 "Married                                  " " & " %4.2f  (`mu8_1')  "`star8_1'"  " & " %4.2f  (`mu8_2')  "`star8_2'"  " & " %4.2f  (`mu8_3')  " & " %4.2f  (`mu8_all')  " \\ "  _n 
file write T2 "Lives with children                      " " & " %4.2f  (`mu9_1')  "`star9_1'"  " & " %4.2f  (`mu9_2')  "`star9_2'"  " & " %4.2f  (`mu9_3')  " & " %4.2f  (`mu9_all')  " \\ "  _n 
file write T2 "College graduate                         " " & " %4.2f  (`mu10_1') "`star10_1'" " & " %4.2f  (`mu10_2') "`star10_2'" " & " %4.2f  (`mu10_3') " & " %4.2f  (`mu10_all') " \\ "  _n 
file write T2 "Owns home                                " " & " %4.2f  (`mu11_1') "`star11_1'" " & " %4.2f  (`mu11_2') "`star11_2'" " & " %4.2f  (`mu11_3') " & " %4.2f  (`mu11_all') " \\ "  _n 
file write T2 "Healthy                                  " " & " %4.2f  (`mu12_1') "`star12_1'" " & " %4.2f  (`mu12_2') "`star12_2'" " & " %4.2f  (`mu12_3') " & " %4.2f  (`mu12_all') " \\ "  _n 
file write T2 "Income (\\$1000)                         " " & " %4.2f  (`mu13_1') "`star13_1'" " & " %4.2f  (`mu13_2') "`star13_2'" " & " %4.2f  (`mu13_3') " & " %4.2f  (`mu13_all') " \\ "  _n 
file write T2 "Lives near family                        " " & " %4.2f  (`mu28_1') "`star28_1'" " & " %4.2f  (`mu28_2') "`star28_2'" " & " %4.2f  (`mu28_3') " & " %4.2f  (`mu28_all') " \\ "  _n 
file write T2 "Rates current norms as agreeable         " " & " %4.2f  (`mu29_1') "`star29_1'" " & " %4.2f  (`mu29_2') "`star29_2'" " & " %4.2f  (`mu29_3') " & " %4.2f  (`mu29_all') " \\ "  _n 
file write T2 "Pr(move) in next two years               " " & " %4.2f  (`mu1_1')  "`star1_1'"  " & " %4.2f  (`mu1_2')  "`star1_2'"  " & " %4.2f  (`mu1_3')  " & " %4.2f  (`mu1_all')  " \\ "  _n 
file write T2 "Moved during previous year               " " & " %4.2f  (`mu24_1') "`star24_1'" " & " %4.2f  (`mu24_2') "`star24_2'" " & " %4.2f  (`mu24_3') " & " %4.2f  (`mu24_all') " \\ "  _n  
file write T2 "Years lived in current residence         " " & " %4.2f  (`mu14_1') "`star14_1'" " & " %4.2f  (`mu14_2') "`star14_2'" " & " %4.2f  (`mu14_3') " & " %4.2f  (`mu14_all') " \\ "  _n  
file write T2 "Prior to moving to current residence: \\ "  _n                                                                            
file write T2 "~~Lived in same county                   " " & " %4.2f  (`mu15_1') "`star15_1'" " & " %4.2f  (`mu15_2') "`star15_2'" " & " %4.2f  (`mu15_3') " & " %4.2f  (`mu15_all') " \\ "  _n  
file write T2 "~~Lived in same state, diff county       " " & " %4.2f  (`mu16_1') "`star16_1'" " & " %4.2f  (`mu16_2') "`star16_2'" " & " %4.2f  (`mu16_3') " & " %4.2f  (`mu16_all') " \\ "  _n  
file write T2 "~~Lived in different state               " " & " %4.2f  (`mu17_1') "`star17_1'" " & " %4.2f  (`mu17_2') "`star17_2'" " & " %4.2f  (`mu17_3') " & " %4.2f  (`mu17_all') " \\ "  _n  
file write T2 "~~Lived in different country             " " & " %4.2f  (`mu18_1') "`star18_1'" " & " %4.2f  (`mu18_2') "`star18_2'" " & " %4.2f  (`mu18_3') " & " %4.2f  (`mu18_all') " \\ "  _n  
file write T2 "Lives in city                            " " & " %4.2f  (`mu19_1') "`star19_1'" " & " %4.2f  (`mu19_2') "`star19_2'" " & " %4.2f  (`mu19_3') " & " %4.2f  (`mu19_all') " \\ "  _n  
file write T2 "Lives in suburb                          " " & " %4.2f  (`mu20_1') "`star20_1'" " & " %4.2f  (`mu20_2') "`star20_2'" " & " %4.2f  (`mu20_3') " & " %4.2f  (`mu20_all') " \\ "  _n  
file write T2 "Lives in Northeast                       " " & " %4.2f  (`mu21_1') "`star21_1'" " & " %4.2f  (`mu21_2') "`star21_2'" " & " %4.2f  (`mu21_3') " & " %4.2f  (`mu21_all') " \\ "  _n  
file write T2 "Lives in Midwest                         " " & " %4.2f  (`mu22_1') "`star22_1'" " & " %4.2f  (`mu22_2') "`star22_2'" " & " %4.2f  (`mu22_3') " & " %4.2f  (`mu22_all') " \\ "  _n  
file write T2 "Lives in South                           " " & " %4.2f  (`mu23_1') "`star23_1'" " & " %4.2f  (`mu23_2') "`star23_2'" " & " %4.2f  (`mu23_3') " & " %4.2f  (`mu23_all') " \\ "  _n  
file write T2 "\midrule " _n
file write T2 "Sample size                     " " & " %5.0fc (`mu30_1') " & " %5.0fc (`mu30_2') " & " %5.0fc (`mu30_3') " & " %5.0fc (`mu30_all') " \\ "  _n 
file write T2 "\bottomrule " _n 
file write T2 "\end{tabular} " _n 
file write T2 "\footnotesize{Source: Survey of Consumer Expectations collected in September 2018 and December 2019. " _n
file write T2 " " _n 
file write T2 "\bigskip{} " _n 
file write T2 " " _n 
file write T2 "Notes: * indicates significantly different from Rooted at the 5\% level. For further details, see Section \ref{sec:data} and notes to Table \ref{tab:descT1}.}" _n 
file write T2 "\end{threeparttable} " _n 
file write T2 "\end{table} " _n 
file close T2

* multinomial logit to see what correlates with rooted/stuck/mobile
mlogit qmv12 female white black latin age married haskids_in_home grad4yr ownhome   healthy hhincome i.wave i.residence, base(1)

