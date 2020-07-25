
egen id = group(scuid)
tab wave
codebook scuid if wave==1
codebook scuid if wave==2

tempfile zeroSDers nevermovers
preserve
    use ${datapath}long_panel_SepDec, clear
    sort scuid wave blk scen alt
    drop if wave==0
    drop if mi(p)
    bys scuid (blk scen alt): egen choicenum = seq()
    xtset scuid choicenum
    bys scuid (choicenum): egen maxchoicenum = total(choicenum>0)
    replace maxchoicenum = maxchoicenum/3 // divide by three since each scenario has two probabilities, but I just want to see how many scenarios there were
    bys scuid (choicenum): gen firstObs = _n==1
    keep if inlist(maxchoicenum,16)
    tab maxchoicenum if firstObs
    * sample size if include Case 4 of Sep
    xtsum scuid if inlist(alt,"a","b")

    * drop Case 4 of Sep
    drop if blk==34
    drop maxchoicenum
    bys scuid (choicenum): egen maxchoicenum = total(choicenum>0)
    replace maxchoicenum = maxchoicenum/3 
    tab maxchoicenum if firstObs
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
    egen nm = total(p==100), by(wave scuid)
    gen never_mover = nm==maxchoicenum

    tab never_mover if firstObs, mi

    tab zeroSDpall if firstObs, mi
    
    tab maxchoicenum if zeroSDpall==0 & firstObs

    keep if firstObs
    codebook scuid if inlist(wave,1,2)
    keep scuid wave zeroSDpall never_mover blk
    save `nevermovers', replace

    * block identifiers: SepC5, DecC1
    gen rdmblk = .
    gen tempS1 = blk==35
   egen blkS1a = mean(tempS1), by(wave scuid)
    gen blkS1  = blkS1a>0
    gen tempD1 = blk==41
   egen blkD1a = mean(tempD1), by(wave scuid)
    gen blkD1  = blkD1a>0
    replace rdmblk = 1 if (blkD1==1 & wave==2) | (blkS1==1 & wave==1)
    replace rdmblk = 0 if (blkD1==0 & wave==2) | (blkS1==0 & wave==1)

    duplicates drop scuid, force
    tab wave rdmblk
    keep scuid zeroSDpall rdmblk
    ren zeroSDpall never_mover

    save `zeroSDers', replace
restore

/*
tempfile zeroSDers
preserve
    use ${temppath}alldata_refb_full_intvws_noSepC4_mlogit_inclDec, clear
    keep if wave>=1
    forv x=1/3 {
        egen mSDp`x' = sd(pchoice) if altnum==`x', by(wave scuid)
        egen  SDp`x' = mean(mSDp`x'), by(wave scuid)
        drop mSDp`x'
    }
    gen zeroSDpall = SDp1==0 & SDp2==0 & SDp3==0
    l wave scuid pchoice SDp? in 1/40, sepby(scuid)

    * block identifiers: SepC5, DecC1
    gen rdmblk = .
    gen tempS1 = svyblk==35
   egen blkS1a = mean(tempS1), by(wave scuid)
    gen blkS1  = blkS1a>0
    gen tempD1 = svyblk==41
   egen blkD1a = mean(tempD1), by(wave scuid)
    gen blkD1  = blkD1a>0
    replace rdmblk = 1 if (blkD1==1 & wave==2) | (blkS1==1 & wave==1)
    replace rdmblk = 0 if (blkD1==0 & wave==2) | (blkS1==0 & wave==1)

    duplicates drop scuid, force
    merge 1:1 scuid using ${datapath}cross_sectionSepDec, nogen keep(match)
    tab wave rdmblk

    keep scuid zeroSDpall rdmblk
    ren zeroSDpall never_mover

    save `zeroSDers', replace
restore
*/

preserve
    contract id scuid wave
    l in 1/5
    drop _freq

    merge 1:1 scuid using `zeroSDers', nogen 
    l in 1/5
    count if never_mover==1
    count if never_mover==0
    tab wave rdmblk
    
    foreach var in `scenarios' {
        gen b_`var'        = .o
        gen se_`var'       = .o
        gen t_`var'        = .o
        gen wtp_`var'      = .o
        gen wtp_frac_`var' = .o
    }
    
    gen converge_error= .
    
    merge m:1 id using `incomedata', nogen keepusing(mincome) keep(match master)
    ren mincome hhincome
    
    tempfile    parameters
    save        `parameters'
    d
    l scuid id *dist* hhincome in 1/5
restore


sum ratio `scenarios'
sum id
local max = r(max)
*forval id = 1/10 {
forval id = 1/`max' {
    if mod(`id',10)==0 di "ID=`=`id'-1'; `=`=`id'-1'/`max'*100'% done"
    * baseline estimation
    set seed 1001
    cap qui qreg ratio `scenarios' if id ==`id'
    local colnms: coln e(b)
    preserve
        drop _all
        label drop _all
        use `parameters'
        if _rc == 0 {
            foreach var in `scenarios' {
                if strpos("`colnms'","o.`var'")==0 {
                    replace b_`var'  = _b[`var'] if id == `id'
                    replace se_`var' = _se[`var'] if id == `id'
                    replace t_`var'  = abs(_b[`var']/_se[`var']) if id == `id'
                    if inlist("`var'","income","crime") {
                        qui replace wtp_`var'      = -(exp(-_b[`var']/_b[income]*ln(2))-1)*hhincome if id == `id'
                        qui replace wtp_frac_`var' = -(exp(-_b[`var']/_b[income]*ln(2))-1)*100      if id == `id'
                    }
                    else if inlist("`var'","homecost") {
                        qui replace wtp_`var'      = -(exp(-_b[`var']/_b[income]*ln(1.2))-1)*hhincome if id == `id'
                        qui replace wtp_frac_`var' = -(exp(-_b[`var']/_b[income]*ln(1.2))-1)*100      if id == `id'
                    }
                    else if inlist("`var'","taxes","mvcost") {
                        qui replace wtp_`var'      = -(exp(-_b[`var']/_b[income]*5)-1)*hhincome if id == `id'
                        qui replace wtp_frac_`var' = -(exp(-_b[`var']/_b[income]*5)-1)*100      if id == `id'
                    }
                    else {
                        qui replace wtp_`var'      = -(exp(-_b[`var']/_b[income])-1)*hhincome if id == `id'
                        qui replace wtp_frac_`var' = -(exp(-_b[`var']/_b[income])-1)*100      if id == `id'
                    }
                }
            }
        }
        replace converge_error = e(convcode)  if id == `id'
        save `parameters', replace  
        
        if `id' == `max' {
            save ${temppath}individual_level_neighborhood${suffix}, replace
            export excel using ${temppath}individual_level_neighborhood${suffix}.xlsx, replace  first(variables)
        }
    restore
}
