clear all
version 14.1
set more off
capture log close

log using "SCE_mobility_refb_full_intvws_noSepC4_mlrologit_SepDec_noP0_samecity.log", replace

tempfile september
preserve
    use "${datapath}SCE_Sep_public.dta", clear
    *destring q7_1, force replace
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
    *drop timecapture* //qtime*
    save `september', replace
    *capture d qmv20*
    *d qmv30*
restore

tempfile december
preserve
    * use "${datapath}mobility_201912fielding_coremerge.dta", clear
    use "${datapath}SCE_Dec_public.dta", clear
    *destring q7_1, force replace
    *foreach var of varlist respondent q33 q34 q36 q38 q43 q47 q48_1 d3 {
    *    encode `var', gen(XXX`var')
    *    drop `var'
    *    ren XXX`var' `var'
    *}
    *capture drop male retired black asian white race married student homemaker numjobs zip state
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
    *drop timecapture* //qtime*
    save `december', replace
    *capture d qmv20*
    *d qmv30*
restore

* Combine all three waves (January, September, December) 
use `september', clear
append using `december', gen(wave) force
recode wave (1=2) (0=1)

*------------------------------------------------------------------------------
* Data cleaning
*------------------------------------------------------------------------------
include datacleaning_SepDec

*------------------------------------------------------------------------------
* Prepare data for estimation of location attribute model
*------------------------------------------------------------------------------
include createchoicedata_mlogit_samecity_SepDec

* combine all data
use `m31a', clear
append using `m31b'
append using `m31c'
append using `m31d'
append using `m31e'
append using `m31f'
append using `m31g'
append using `m31h'
append using `m31i'
append using `m31j'
append using `m31k'
append using `m31l'
append using `m32a'
append using `m32b'
append using `m32c'
append using `m32d'
append using `m32e'
append using `m32f'
append using `m32g'
append using `m32h'
append using `m32i'
append using `m32j'
append using `m32k'
append using `m32l'
append using `m33a'
append using `m33b'
append using `m33c'
append using `m33d'
append using `m33e'
append using `m33f'
append using `m33g'
append using `m33h'
append using `m33i'
append using `m33j'
append using `m33k'
append using `m33l'
append using `m34a'
append using `m34b'
append using `m34c'
append using `m34d'
append using `m34e'
append using `m34f'
append using `m34g'
append using `m34h'
append using `m34i'
append using `m34j'
append using `m34k'
append using `m34l'
append using `m35a'
append using `m35b'
append using `m35c'
append using `m35d'
append using `m35e'
append using `m35f'
append using `m35g'
append using `m35h'
append using `m35i'
append using `m35j'
append using `m35k'
append using `m35l'
append using `m36a'
append using `m36b'
append using `m36c'
append using `m36d'
append using `m36e'
append using `m36f'
append using `m36g'
append using `m36h'
append using `m36i'
append using `m36j'
append using `m36k'
append using `m36l'
* Add in December 2019 data
append using `m41a', force
append using `m41b', force
append using `m41c', force
append using `m41d', force
append using `m41e', force
append using `m41f', force
append using `m41g', force
append using `m41h', force
append using `m41i', force
append using `m41j', force
append using `m41k', force
append using `m41l', force
append using `m42a', force
append using `m42b', force
append using `m42c', force
append using `m42d', force
append using `m42e', force
append using `m42f', force
append using `m42g', force
append using `m42h', force
append using `m42i', force
append using `m42j', force
append using `m42k', force
append using `m42l', force
append using `m43a', force
append using `m43b', force
append using `m43c', force
append using `m43d', force
append using `m43e', force
append using `m43f', force
append using `m43g', force
append using `m43h', force
append using `m43i', force
append using `m43j', force
append using `m43k', force
append using `m43l', force
append using `m44a', force
append using `m44b', force
append using `m44c', force
append using `m44d', force
append using `m44e', force
append using `m44f', force
append using `m44g', force
append using `m44h', force
append using `m44i', force
append using `m44j', force
append using `m44k', force
append using `m44l', force
append using `m45a', force
append using `m45b', force
append using `m45c', force
append using `m45d', force
append using `m45e', force
append using `m45f', force
append using `m45g', force
append using `m45h', force
append using `m45i', force
append using `m45j', force
append using `m45k', force
append using `m45l', force
append using `m46a', force
append using `m46b', force
append using `m46c', force
append using `m46d', force
append using `m46e', force
append using `m46f', force
append using `m46g', force
append using `m46h', force
append using `m46i', force
append using `m46j', force
append using `m46k', force
append using `m46l', force

bys scuid (svyblk scennum altnum): egen choicenum = seq()
isid scuid choicenum
xtset scuid choicenum
xtsum scuid

egen svyblknum = group(svyblk)
egen blkscen   = group(svyblk scennum)

* figure out how many people were in each wave of the survey
isid scuid svyblknum scennum altnum
bys scuid (svyblknum scennum altnum): egen maxwave = max(wave)
bys scuid (svyblknum scennum altnum): egen minwave = min(wave)
capture codebook scuid if maxwave!=minwave

* figure out how many people have how many choice scenario responses
isid scuid choicenum
bys scuid (choicenum): egen maxchoicenum = max(choicenum)
replace maxchoicenum = maxchoicenum/3 // divide by two since each scenario has two probabilities, but I just want to see how many scenarios there were
bys scuid (choicenum): gen firstObs = _n==1
*keep if (inlist(maxchoicenum,8,16,24) & inlist(wave,0,1)) | (inlist(maxchoicenum,15,16) & inlist(wave,2)) // for some reason Block 1 in December had most people answer 15 instead of 16 scenarios
keep if inlist(maxchoicenum,16)
drop if svyblk=="SepC4"
drop choicenum maxchoicenum
bys scuid (svyblk scennum altnum): egen choicenum = seq()
bys scuid (choicenum): egen maxchoicenum = max(choicenum)
replace maxchoicenum = maxchoicenum/3 // divide by two since each scenario has two probabilities, but I just want to see how many scenarios there were
tab maxchoicenum if firstObs
xtsum scuid

preserve
    keep scuid wave 
    codebook scuid
    bys scuid (wave): gen firstObs = _n==1
    drop if !firstObs
    save ${datapath}UniqueIDsMlogitSepDec, replace
restore

* check survey structure
tab choicenum wave // about 244 people have 48 choices because they got 16 from the January wave and 32 from the September wave
tab svyblk    wave
tab scennum   wave
tab altnum    wave

l scuid choicenum svyblk scennum altnum pchoice income crime mvcost taxes norms family dist size homecost in 1/16, sepby(scuid)

describe

gen     ihomecost=0
replace ihomecost=1 if homecost==.
replace homecost=0 if homecost==.
gen     icrime=0
replace icrime=1 if crime==.
replace crime=0 if crime==.
gen     idist=0
replace idist=1 if dist==.
replace dist=0 if dist==.
gen     ifamily=0
replace ifamily=1 if family==.
replace family=0 if family==.
gen     isize=0
replace isize=1 if size==.
replace size=0 if size==.
gen     imvcost=0
replace imvcost=1 if mvcost==.
replace mvcost=0 if mvcost==.
gen     itaxes=0
replace itaxes=1 if taxes==.
replace taxes=0 if taxes==.
gen     inorms=0
replace inorms=1 if norms==.
replace norms=0 if norms==.
gen     ischqual=0
replace ischqual=1 if schqual==.
replace schqual=0 if schqual==.
gen     isamecity=0
replace isamecity=1 if samecity==.
replace samecity=0 if samecity==.
gen     iwithincitymove=0
replace iwithincitymove=1 if withincitymove==.
replace withincitymove=0 if withincitymove==.
gen     iexacthome=0
replace iexacthome=1 if exacthome==.
replace exacthome=0 if exacthome==.
gen     icopyhome=0
replace icopyhome=1 if copyhome==.
replace copyhome=0 if copyhome==.
gen     idiffhome=0
replace idiffhome=1 if diffhome==.
replace diffhome=0 if diffhome==.
gen     iwincitycopy=0
replace iwincitycopy=1 if wincitycopy==.
replace wincitycopy=0 if wincitycopy==.

describe
local  scenarios income homecost crime dist family size mvcost taxes norms schqual samecity copyhome moved
local iscenarios 
local  altnums b1.altnum

l scuid choicenum svyblk scennum altnum pchoice income crime mvcost taxes norms family dist size homecost schqual samecity copyhome moved in 1/16, sepby(scuid)

egen caseid = group(scuid svyblk scennum)

* generate ranks of choices
set seed 1001
bys caseid: egen choicerank = rank(pchoice), unique // ties broken randomly
set seed 10001
bys caseid: egen choicerank2 = rank(pchoice), track

replace chosen = choicerank==3

* check rate of missingness
mdesc 

* double check data are in consistent units across waves
foreach x in `scenarios' {
    tab `x' wave
}


* drop those who never report moving, or who always report the exact same probabilities in every scenario
tempfile perfect_stayers
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

    * drop Case 4 of Sep
    drop if blk==34
    drop maxchoicenum
    bys scuid (choicenum): egen maxchoicenum = total(choicenum>0)
    replace maxchoicenum = maxchoicenum/3 
    tab maxchoicenum if firstObs

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
    
    keep if firstObs
    keep scuid zeroSDpall never_mover
    save `perfect_stayers', replace
restore

merge m:1 scuid using `perfect_stayers', nogen
drop if zeroSDpall

*save ${temppath}alldata_refb_full_intvws_noSepC4_mlogit_SepDec_noP0_samecity, replace




*------------------------------------------------------------------------------
* Estimate location attribute models
*------------------------------------------------------------------------------
sum pchoice `scenarios', sep(0)

sum pchoice `scenarios' if wave==1, sep(0)
sum pchoice `scenarios' if wave==1 & altnum==1, sep(0)
sum pchoice `scenarios' if wave==1 & altnum==3, sep(0)

sum pchoice `scenarios' if wave==2, sep(0)
sum pchoice `scenarios' if wave==2 & altnum==1, sep(0)
sum pchoice `scenarios' if wave==2 & altnum==3, sep(0)

* estimate group-level models
local  scenarios income homecost crime dist family size mvcost taxes norms schqual withincitymove copyhome moved

global Suffix = "RefBFullIntvwsNoSepC4MLROLSepDecNP0SameCity"
include groupestimation_mlrologit_samecity_inclDec_newWTP

log close

