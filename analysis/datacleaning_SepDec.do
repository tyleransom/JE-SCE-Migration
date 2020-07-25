* Jan only
drop if wave==0

* only use repeat respondents  
drop if respondent !=2

* drop those missing demographics or geography
drop if mi(q33) | mi(qmv12)

* drop some scuids that have problems
drop if inlist(scuid,894857,894957,909527,32219007,48700908,66588007)

global demogs prefgroup pgsize agenew female race educ grad4yr married hhsizenew haskids_in_home hasyoungkids_in_home hasteenagers_in_home hasadultkids_in_home health hiIncome loIncome residence blockmv
global labmkt empFT empPT sp_empFT sp_empPT bgmincome hhincome
global migrat yrsCurrRes yrsCurrState ownhome movedthismonth
global pushpullvars qmv12 qmv11a_1 qmv11b_1 qmv11c_1 qmv7_1 qmv1_1 qmv1a_1 qmv3 medhvalsqft region division divname regname
global timevars total_svy_time long_svy_time short_svy_time rim_4_original scenord_*
* sorting vars: cost of housing, crime, near family, home size, tax rate, norms, sch quality, 
global sortvars medhvalsqft nearfam qmv1a_1 currtaxrate agreenorms hiqualsch loqualsch violcrimerate salt qmv6b
global keepers ${demogs} ${labmkt} ${migrat} ${pushpullvars} ${timevars} ${sortvars}

* make rim weights integers
gen long rim1000 = rim_4_original*1000

* compute length to take entire survey (in minutes)
gen total_svy_time = (tc_intend-tc_intstart)/60000
gen long_svy_time  = total_svy_time>=90 if !mi(total_svy_time)
gen short_svy_time = total_svy_time<=15 if !mi(total_svy_time)


****************
* Demographics
****************
* age
gen agenew = q32_1

* gender
gen female = q33==1
gen   male = q33==2

* race / ethnicity
* q34: hispanic (1) or not (2)
* q35: white (1) black (2) native am (3) asian (4) polynesian (5) other (6)
gen m_race = mi(q34) | mi(q35_1) | mi(q35_2) | mi(q35_3) | mi(q35_4) | mi(q35_5) | mi(q35_6)
gen latin = q34==1
gen black = q35_2==1 & !m_race & !latin
gen asian = q35_4==1 & !m_race & !latin & !black
gen white = q35_1==1 & !m_race & !latin & !black & !asian & q35_3==0 & q35_5==0
gen other =(q35_3==1 | q35_5==1 | q35_6==1 | m_race==1 | mi(q35_1) | mi(q34)) & !latin & !black & !asian & !white
replace other = 1 if latin==0 & black==0 & asian==0 & white==0 & other==0

assert latin+black+asian+white+other==1

gen     race = 1
replace race = 2 if black==1
replace race = 3 if latin==1
replace race = 4 if asian==1
replace race = 5 if other==1
lab def vlrace 1 "White" 2 "Black" 3 "Latin" 4 "Asian" 5 "Other"
lab val race vlrace
tab race, mi

* education
lab var q36 "Highest level of education"
lab def vleduc 1 "Less than HS" 2 "HS diploma" 3 "Some college" 4 "Associate's" 5 "Bachelor's" 6 "Master's" 7 "Doctoral" 8 "Professional" 9 "Other"
lab val q36 vleduc

clonevar educ = q36
recode educ (6 7 8 = 4) (5 = 3) (3 4 = 2) (2 1 = 1)
lab def vleducabb 1 "HS grad or below" 2 "Some college" 3 "Bachelor's" 4 "Advanced degree"
lab val educ vleducabb

gen grad4yr = inrange(educ,3,4) // BA grad or above

* marital status
gen married = q38==1

* household structure
egen hhsizenew = rowtotal(q45new_*)
replace hhsizenew = hhsizenew+1
corr hhsizenew hhsize

gen    numkids_25plus = q45new_2
recode numkids_25plus (. = 0)

gen    numkids_18_24 = q45new_3
recode numkids_18_24 (. = 0) (21 = 1)

gen    numkids_6_17 = q45new_4
recode numkids_6_17 (. = 0)

gen    numkids_0_5 = q45new_5
recode numkids_0_5 (. = 0)

gen hasyoungkids_in_home = numkids_0_5 >0
gen hasteenagers_in_home = numkids_6_17>0
gen hasadultkids_in_home = numkids_18_24+numkids_25plus>0
gen haskids_in_home      = numkids_0_5 >0 | numkids_6_17>0 | numkids_18_24>0 | numkids_25plus>0

* health status
ren q45b health
lab def vlhealth 1 "Excellent" 2 "Very Good" 3 "Good" 4 "Fair" 5 "Poor"
lab val health vlhealth
*/

* household income
replace q47 = d6 if mi(q47) & !mi(d6)
clonevar hhincome = q47
recode hhincome (1 = 5000) (2=15000) (3 = 25000) (4 = 35000) (5 = 45000) (6 = 55000) (7 = 67500) (8 = 87500) (9 = 125000) (10 = 175000) (11 = 225000)

* block group income
lab var bgmincome "Census block group median income"

* calculate median block group income (for WTPs later on)
sum hhincome [w=rim_4_original] if inlist(wave,1,2), d
global medinc `r(p50)'

gen hiIncome = hhincome>=${medinc}
gen loIncome = hhincome< ${medinc}



****************
* Labor Mkt Vars
****************
* employment status // need to think more about how to code it so that all cases are mutually exclusive
gen empFT       = q10_1 ==1
gen empPT       = q10_2 ==1
gen unemp       = q10_3 ==1
gen laidoff     = q10_4 ==1
gen sickleave   = q10_5 ==1
gen disabledEmp = q10_6 ==1
gen retired     = q10_7 ==1
gen student     = q10_8 ==1
gen homemaker   = q10_9 ==1
gen otherEmp    = q10_10==1

* number of jobs
gen     numjobs = q11_1 if !mi(q11_1)
replace numjobs = 3 if inrange(numjobs,4,.)
recode  numjobs (. = 0)

* self-employment
gen    selfEmployed = q12new==2 if !mi(q12new)
recode selfEmployed (. = 0)

* spouse's employment status
gen sp_empFT       = hh2new_1 ==1
gen sp_empPT       = hh2new_2 ==1
gen sp_selfEmp     = hh2new_3 ==1
gen sp_unemp       = hh2new_4 ==1
gen sp_laidoff     = hh2new_5 ==1
gen sp_sickleave   = hh2new_6 ==1
gen sp_disabledEmp = hh2new_7 ==1
gen sp_retired     = hh2new_8 ==1
gen sp_student     = hh2new_9 ==1
gen sp_homemaker   = hh2new_10==1
gen sp_otherEmp    = hh2new_11==1


*******************
* Current Residence
*******************
gen yrsCurrRes   = q41_1
gen yrsCurrState = q42_1

gen ownhome      = q43==1
gen ownMultHomes = q44==1

gen movedthismonth = d3==1

gen residence = .
replace residence = 1 if qmv2==1
replace residence = 2 if inlist(qmv2,2,3)
replace residence = 3 if inlist(qmv2,4,5,6)

lab def vlres 1 "City" 2 "Suburbs" 3 "Rural / Other"
lab var residence "City / Suburbs / Rural residence status"
lab val residence vlres

* fix outliers in sqft
replace qmv1a_1 =  500 if qmv1a_1<500
replace qmv1a_1 = 4000 if qmv1a_1>4000 & !mi(qmv1a_1)

* Lives near family
gen nearfam = qmv5==1 if !mi(qmv5)

* Agreeable norms
gen agreenorms = inlist(qmv6_1,4,5) if !mi(qmv6_1)

* Top quartile of schools
gen hiqualsch = inlist(qmv6b,4) if !mi(qmv6b)
gen loqualsch = inlist(qmv6b,1) if !mi(qmv6b)

* Tax rate
gen currtaxrate = qmv6a


****************
* Migration
****************

lab var qmv1_1 "Years lived at current location"
lab var qmv1a_1 "Size of current residence (sq. ft.)"
lab var qmv2 "Type of current residence"
tab qmv2 [aw=rim_4_original]

lab var qmv3 "Where lived before moving here"
tab qmv3 [aw=rim_4_original]

gen samecounty  = qmv3==1
gen samestate   = qmv3==2
gen diffstate   = qmv3==3
gen diffcountry = qmv3==4

* indicator for having moved into current location at some point  
gen mvhere=0 if !mi(qmv1_1)
replace mvhere=1 if age>4+qmv1_1 & !mi(qmv1_1)
tab mvhere [aw=rim_4_original]

* qmv7= prob of moving in next 2 years  
lab var qmv7_1 "Likelihood of moving in next 2 years"

* share with prob >=1% of moving in next 2 years  
gen nvrmove=0 if !mi(qmv7_1)
replace nvrmove=1 if qmv7_1==0 & !mi(qmv7_1)
tab nvrmove [aw=rim_4_original]

replace qmv14_1=0 if nvrmove==0 & qmv14_1==.
replace qmv14_2=0 if nvrmove==0 & qmv14_2==.
replace qmv14_3=0 if nvrmove==0 & qmv14_3==.
replace qmv14_4=0 if nvrmove==0 & qmv14_4==.

* qmv14= if move prob it will be this far ..  
lab var qmv14_1 "Likelihood of moving <10 miles in next 2 years"
lab var qmv14_2 "Likelihood of moving 10-100 miles in next 2 years"
lab var qmv14_3 "Likelihood of moving 100-500 miles in next 2 years"
lab var qmv14_4 "Likelihood of moving 500+ miles in next 2 years"



****************************************
* September Wave neighborhood choice data
****************************************
gen     Block=. 
replace Block=2 if wave==1 &  mi(dumy1_1_4_1)
replace Block=1 if wave==1 & !mi(dumy1_1_4_1)
replace Block=2 if wave==2 & blockmv==2
replace Block=1 if wave==2 & blockmv==1
* Case 1 (both blocks of wave 1)
gen     qmv31_scen1_a=0 if wave==1 
gen     qmv31_scen1_b=0 if wave==1 
gen     qmv31_scen1_c=0 if wave==1
replace qmv31_scen1_a=qmv30_1_1_1 if !mi(qmv30_1_1_1) & wave==1
replace qmv31_scen1_b=qmv30_2_1_1 if !mi(qmv30_2_1_1) & wave==1
replace qmv31_scen1_c=qmv30_3_1_1 if !mi(qmv30_3_1_1) & wave==1
gen     sum31_scen1=qmv31_scen1_a+qmv31_scen1_b+qmv31_scen1_c 
replace qmv31_scen1_a=. if sum31_scen1!=100 & wave==1
replace qmv31_scen1_b=. if sum31_scen1!=100 & wave==1
replace qmv31_scen1_c=. if sum31_scen1!=100 & wave==1
lab var qmv31_scen1_a "A: distance / crime / income scenario 1"
lab var qmv31_scen1_b "B: distance / crime / income scenario 1"
lab var qmv31_scen1_c "C: distance / crime / income scenario 1"

gen     qmv31_scen2_a=0 if wave==1 
gen     qmv31_scen2_b=0 if wave==1 
gen     qmv31_scen2_c=0 if wave==1
replace qmv31_scen2_a=qmv30_1_1_2 if !mi(qmv30_1_1_2) & wave==1
replace qmv31_scen2_b=qmv30_2_1_2 if !mi(qmv30_2_1_2) & wave==1
replace qmv31_scen2_c=qmv30_3_1_2 if !mi(qmv30_3_1_2) & wave==1
gen     sum31_scen2=qmv31_scen2_a+qmv31_scen2_b+qmv31_scen2_c 
replace qmv31_scen2_a=. if sum31_scen2!=100 & wave==1
replace qmv31_scen2_b=. if sum31_scen2!=100 & wave==1
replace qmv31_scen2_c=. if sum31_scen2!=100 & wave==1
lab var qmv31_scen2_a "A: distance / crime / income scenario 2"
lab var qmv31_scen2_b "B: distance / crime / income scenario 2"
lab var qmv31_scen2_c "C: distance / crime / income scenario 2"

gen     qmv31_scen3_a=0 if wave==1 
gen     qmv31_scen3_b=0 if wave==1 
gen     qmv31_scen3_c=0 if wave==1
replace qmv31_scen3_a=qmv30_1_1_3 if !mi(qmv30_1_1_3) & wave==1
replace qmv31_scen3_b=qmv30_2_1_3 if !mi(qmv30_2_1_3) & wave==1
replace qmv31_scen3_c=qmv30_3_1_3 if !mi(qmv30_3_1_3) & wave==1
gen     sum31_scen3=qmv31_scen3_a+qmv31_scen3_b+qmv31_scen3_c 
replace qmv31_scen3_a=. if sum31_scen3!=100 & wave==1
replace qmv31_scen3_b=. if sum31_scen3!=100 & wave==1
replace qmv31_scen3_c=. if sum31_scen3!=100 & wave==1
lab var qmv31_scen3_a "A: distance / crime / income scenario 3"
lab var qmv31_scen3_b "B: distance / crime / income scenario 3"
lab var qmv31_scen3_c "C: distance / crime / income scenario 3"

gen     qmv31_scen4_a=0 if wave==1 
gen     qmv31_scen4_b=0 if wave==1 
gen     qmv31_scen4_c=0 if wave==1
replace qmv31_scen4_a=qmv30_1_1_4 if !mi(qmv30_1_1_4) & wave==1
replace qmv31_scen4_b=qmv30_2_1_4 if !mi(qmv30_2_1_4) & wave==1
replace qmv31_scen4_c=qmv30_3_1_4 if !mi(qmv30_3_1_4) & wave==1
gen     sum31_scen4=qmv31_scen4_a+qmv31_scen4_b+qmv31_scen4_c 
replace qmv31_scen4_a=. if sum31_scen4!=100 & wave==1
replace qmv31_scen4_b=. if sum31_scen4!=100 & wave==1
replace qmv31_scen4_c=. if sum31_scen4!=100 & wave==1
lab var qmv31_scen4_a "A: distance / crime / income scenario 4"
lab var qmv31_scen4_b "B: distance / crime / income scenario 4"
lab var qmv31_scen4_c "C: distance / crime / income scenario 4"


* Case 2 (Block 2 of wave 1)
gen     qmv32_scen1_a=0 if Block==2 & wave==1 
gen     qmv32_scen1_b=0 if Block==2 & wave==1 
gen     qmv32_scen1_c=0 if Block==2 & wave==1
replace qmv32_scen1_a=qmv30_1_2_1 if !mi(qmv30_1_2_1) & Block==2 & wave==1
replace qmv32_scen1_b=qmv30_2_2_1 if !mi(qmv30_2_2_1) & Block==2 & wave==1
replace qmv32_scen1_c=qmv30_3_2_1 if !mi(qmv30_3_2_1) & Block==2 & wave==1
gen     sum32_scen1=qmv32_scen1_a+qmv32_scen1_b+qmv32_scen1_c 
replace qmv32_scen1_a=. if sum32_scen1!=100 & Block==2 & wave==1
replace qmv32_scen1_b=. if sum32_scen1!=100 & Block==2 & wave==1
replace qmv32_scen1_c=. if sum32_scen1!=100 & Block==2 & wave==1
lab var qmv32_scen1_a "A: distance / movecost / income scenario 1"
lab var qmv32_scen1_b "B: distance / movecost / income scenario 1"
lab var qmv32_scen1_c "C: distance / movecost / income scenario 1"

gen     qmv32_scen2_a=0 if Block==2 & wave==1 
gen     qmv32_scen2_b=0 if Block==2 & wave==1 
gen     qmv32_scen2_c=0 if Block==2 & wave==1
replace qmv32_scen2_a=qmv30_1_2_2 if !mi(qmv30_1_2_2) & Block==2 & wave==1
replace qmv32_scen2_b=qmv30_2_2_2 if !mi(qmv30_2_2_2) & Block==2 & wave==1
replace qmv32_scen2_c=qmv30_3_2_2 if !mi(qmv30_3_2_2) & Block==2 & wave==1
gen     sum32_scen2=qmv32_scen2_a+qmv32_scen2_b+qmv32_scen2_c 
replace qmv32_scen2_a=. if sum32_scen2!=100 & Block==2 & wave==1
replace qmv32_scen2_b=. if sum32_scen2!=100 & Block==2 & wave==1
replace qmv32_scen2_c=. if sum32_scen2!=100 & Block==2 & wave==1
lab var qmv32_scen2_a "A: distance / movecost / income scenario 2"
lab var qmv32_scen2_b "B: distance / movecost / income scenario 2"
lab var qmv32_scen2_c "C: distance / movecost / income scenario 2"

gen     qmv32_scen3_a=0 if Block==2 & wave==1 
gen     qmv32_scen3_b=0 if Block==2 & wave==1 
gen     qmv32_scen3_c=0 if Block==2 & wave==1
replace qmv32_scen3_a=qmv30_1_2_3 if !mi(qmv30_1_2_3) & Block==2 & wave==1
replace qmv32_scen3_b=qmv30_2_2_3 if !mi(qmv30_2_2_3) & Block==2 & wave==1
replace qmv32_scen3_c=qmv30_3_2_3 if !mi(qmv30_3_2_3) & Block==2 & wave==1
gen     sum32_scen3=qmv32_scen3_a+qmv32_scen3_b+qmv32_scen3_c 
replace qmv32_scen3_a=. if sum32_scen3!=100 & Block==2 & wave==1
replace qmv32_scen3_b=. if sum32_scen3!=100 & Block==2 & wave==1
replace qmv32_scen3_c=. if sum32_scen3!=100 & Block==2 & wave==1
lab var qmv32_scen3_a "A: distance / movecost / income scenario 3"
lab var qmv32_scen3_b "B: distance / movecost / income scenario 3"
lab var qmv32_scen3_c "C: distance / movecost / income scenario 3"

gen     qmv32_scen4_a=0 if Block==2 & wave==1 
gen     qmv32_scen4_b=0 if Block==2 & wave==1 
gen     qmv32_scen4_c=0 if Block==2 & wave==1
replace qmv32_scen4_a=qmv30_1_2_4 if !mi(qmv30_1_2_4) & Block==2 & wave==1
replace qmv32_scen4_b=qmv30_2_2_4 if !mi(qmv30_2_2_4) & Block==2 & wave==1
replace qmv32_scen4_c=qmv30_3_2_4 if !mi(qmv30_3_2_4) & Block==2 & wave==1
gen     sum32_scen4=qmv32_scen4_a+qmv32_scen4_b+qmv32_scen4_c 
replace qmv32_scen4_a=. if sum32_scen4!=100 & Block==2 & wave==1
replace qmv32_scen4_b=. if sum32_scen4!=100 & Block==2 & wave==1
replace qmv32_scen4_c=. if sum32_scen4!=100 & Block==2 & wave==1
lab var qmv32_scen4_a "A: distance / movecost / income scenario 4"
lab var qmv32_scen4_b "B: distance / movecost / income scenario 4"
lab var qmv32_scen4_c "C: distance / movecost / income scenario 4"


* Case 3 (both Blocks of wave 1)
gen     qmv33_scen1_a=0 if wave==1 
gen     qmv33_scen1_b=0 if wave==1 
gen     qmv33_scen1_c=0 if wave==1
replace qmv33_scen1_a=qmv30_1_3_1 if !mi(qmv30_1_3_1) & wave==1
replace qmv33_scen1_b=qmv30_2_3_1 if !mi(qmv30_2_3_1) & wave==1
replace qmv33_scen1_c=qmv30_3_3_1 if !mi(qmv30_3_3_1) & wave==1
gen     sum33_scen1=qmv33_scen1_a+qmv33_scen1_b+qmv33_scen1_c 
replace qmv33_scen1_a=. if sum33_scen1!=100 & wave==1
replace qmv33_scen1_b=. if sum33_scen1!=100 & wave==1
replace qmv33_scen1_c=. if sum33_scen1!=100 & wave==1
lab var qmv33_scen1_a "A: distance / family / income scenario 1"
lab var qmv33_scen1_b "B: distance / family / income scenario 1"
lab var qmv33_scen1_c "C: distance / family / income scenario 1"

gen     qmv33_scen2_a=0 if wave==1 
gen     qmv33_scen2_b=0 if wave==1 
gen     qmv33_scen2_c=0 if wave==1
replace qmv33_scen2_a=qmv30_1_3_2 if !mi(qmv30_1_3_2) & wave==1
replace qmv33_scen2_b=qmv30_2_3_2 if !mi(qmv30_2_3_2) & wave==1
replace qmv33_scen2_c=qmv30_3_3_2 if !mi(qmv30_3_3_2) & wave==1
gen     sum33_scen2=qmv33_scen2_a+qmv33_scen2_b+qmv33_scen2_c 
replace qmv33_scen2_a=. if sum33_scen2!=100 & wave==1
replace qmv33_scen2_b=. if sum33_scen2!=100 & wave==1
replace qmv33_scen2_c=. if sum33_scen2!=100 & wave==1
lab var qmv33_scen2_a "A: distance / family / income scenario 2"
lab var qmv33_scen2_b "B: distance / family / income scenario 2"
lab var qmv33_scen2_c "C: distance / family / income scenario 2"

gen     qmv33_scen3_a=0 if wave==1 
gen     qmv33_scen3_b=0 if wave==1 
gen     qmv33_scen3_c=0 if wave==1
replace qmv33_scen3_a=qmv30_1_3_3 if !mi(qmv30_1_3_3) & wave==1
replace qmv33_scen3_b=qmv30_2_3_3 if !mi(qmv30_2_3_3) & wave==1
replace qmv33_scen3_c=qmv30_3_3_3 if !mi(qmv30_3_3_3) & wave==1
gen     sum33_scen3=qmv33_scen3_a+qmv33_scen3_b+qmv33_scen3_c 
replace qmv33_scen3_a=. if sum33_scen3!=100 & wave==1
replace qmv33_scen3_b=. if sum33_scen3!=100 & wave==1
replace qmv33_scen3_c=. if sum33_scen3!=100 & wave==1
lab var qmv33_scen3_a "A: distance / family / income scenario 3"
lab var qmv33_scen3_b "B: distance / family / income scenario 3"
lab var qmv33_scen3_c "C: distance / family / income scenario 3"

gen     qmv33_scen4_a=0 if wave==1 
gen     qmv33_scen4_b=0 if wave==1 
gen     qmv33_scen4_c=0 if wave==1
replace qmv33_scen4_a=qmv30_1_3_4 if !mi(qmv30_1_3_4) & wave==1
replace qmv33_scen4_b=qmv30_2_3_4 if !mi(qmv30_2_3_4) & wave==1
replace qmv33_scen4_c=qmv30_3_3_4 if !mi(qmv30_3_3_4) & wave==1
gen     sum33_scen4=qmv33_scen4_a+qmv33_scen4_b+qmv33_scen4_c 
replace qmv33_scen4_a=. if sum33_scen4!=100 & wave==1
replace qmv33_scen4_b=. if sum33_scen4!=100 & wave==1
replace qmv33_scen4_c=. if sum33_scen4!=100 & wave==1
lab var qmv33_scen4_a "A: distance / family / income scenario 4"
lab var qmv33_scen4_b "B: distance / family / income scenario 4"
lab var qmv33_scen4_c "C: distance / family / income scenario 4"


* Case 4 (Block 1 of wave 1)
gen     qmv34_scen1_a=0 if Block==1 & wave==1 
gen     qmv34_scen1_b=0 if Block==1 & wave==1 
gen     qmv34_scen1_c=0 if Block==1 & wave==1
replace qmv34_scen1_a=qmv30_1_4_1 if !mi(qmv30_1_4_1) & Block==1 & wave==1
replace qmv34_scen1_b=qmv30_2_4_1 if !mi(qmv30_2_4_1) & Block==1 & wave==1
replace qmv34_scen1_c=qmv30_3_4_1 if !mi(qmv30_3_4_1) & Block==1 & wave==1
gen     sum34_scen1=qmv34_scen1_a+qmv34_scen1_b+qmv34_scen1_c 
replace qmv34_scen1_a=. if sum34_scen1!=100 & Block==1 & wave==1
replace qmv34_scen1_b=. if sum34_scen1!=100 & Block==1 & wave==1
replace qmv34_scen1_c=. if sum34_scen1!=100 & Block==1 & wave==1
lab var qmv34_scen1_a "A: distance / values / housingcost scenario 1"
lab var qmv34_scen1_b "B: distance / values / housingcost scenario 1"
lab var qmv34_scen1_c "C: distance / values / housingcost scenario 1"

gen     qmv34_scen2_a=0 if Block==1 & wave==1 
gen     qmv34_scen2_b=0 if Block==1 & wave==1 
gen     qmv34_scen2_c=0 if Block==1 & wave==1
replace qmv34_scen2_a=qmv30_1_4_2 if !mi(qmv30_1_4_2) & Block==1 & wave==1
replace qmv34_scen2_b=qmv30_2_4_2 if !mi(qmv30_2_4_2) & Block==1 & wave==1
replace qmv34_scen2_c=qmv30_3_4_2 if !mi(qmv30_3_4_2) & Block==1 & wave==1
gen     sum34_scen2=qmv34_scen2_a+qmv34_scen2_b+qmv34_scen2_c 
replace qmv34_scen2_a=. if sum34_scen2!=100 & Block==1 & wave==1
replace qmv34_scen2_b=. if sum34_scen2!=100 & Block==1 & wave==1
replace qmv34_scen2_c=. if sum34_scen2!=100 & Block==1 & wave==1
lab var qmv34_scen2_a "A: distance / values / housingcost scenario 2"
lab var qmv34_scen2_b "B: distance / values / housingcost scenario 2"
lab var qmv34_scen2_c "C: distance / values / housingcost scenario 2"

gen     qmv34_scen3_a=0 if Block==1 & wave==1 
gen     qmv34_scen3_b=0 if Block==1 & wave==1 
gen     qmv34_scen3_c=0 if Block==1 & wave==1
replace qmv34_scen3_a=qmv30_1_4_3 if !mi(qmv30_1_4_3) & Block==1 & wave==1
replace qmv34_scen3_b=qmv30_2_4_3 if !mi(qmv30_2_4_3) & Block==1 & wave==1
replace qmv34_scen3_c=qmv30_3_4_3 if !mi(qmv30_3_4_3) & Block==1 & wave==1
gen     sum34_scen3=qmv34_scen3_a+qmv34_scen3_b+qmv34_scen3_c 
replace qmv34_scen3_a=. if sum34_scen3!=100 & Block==1 & wave==1
replace qmv34_scen3_b=. if sum34_scen3!=100 & Block==1 & wave==1
replace qmv34_scen3_c=. if sum34_scen3!=100 & Block==1 & wave==1
lab var qmv34_scen3_a "A: distance / values / housingcost scenario 3"
lab var qmv34_scen3_b "B: distance / values / housingcost scenario 3"
lab var qmv34_scen3_c "C: distance / values / housingcost scenario 3"

gen     qmv34_scen4_a=0 if Block==1 & wave==1 
gen     qmv34_scen4_b=0 if Block==1 & wave==1 
gen     qmv34_scen4_c=0 if Block==1 & wave==1
replace qmv34_scen4_a=qmv30_1_4_4 if !mi(qmv30_1_4_4) & Block==1 & wave==1
replace qmv34_scen4_b=qmv30_2_4_4 if !mi(qmv30_2_4_4) & Block==1 & wave==1
replace qmv34_scen4_c=qmv30_3_4_4 if !mi(qmv30_3_4_4) & Block==1 & wave==1
gen     sum34_scen4=qmv34_scen4_a+qmv34_scen4_b+qmv34_scen4_c 
replace qmv34_scen4_a=. if sum34_scen4!=100 & Block==1 & wave==1
replace qmv34_scen4_b=. if sum34_scen4!=100 & Block==1 & wave==1
replace qmv34_scen4_c=. if sum34_scen4!=100 & Block==1 & wave==1
lab var qmv34_scen4_a "A: distance / values / housingcost scenario 4"
lab var qmv34_scen4_b "B: distance / values / housingcost scenario 4"
lab var qmv34_scen4_c "C: distance / values / housingcost scenario 4"


* Case 5 (Block 2 of wave 1)
gen     qmv35_scen1_a=0 if Block==2 & wave==1 
gen     qmv35_scen1_b=0 if Block==2 & wave==1 
gen     qmv35_scen1_c=0 if Block==2 & wave==1
replace qmv35_scen1_a=qmv30_1_5_1 if !mi(qmv30_1_5_1) & Block==2 & wave==1
replace qmv35_scen1_b=qmv30_2_5_1 if !mi(qmv30_2_5_1) & Block==2 & wave==1
replace qmv35_scen1_c=qmv30_3_5_1 if !mi(qmv30_3_5_1) & Block==2 & wave==1
gen     sum35_scen1=qmv35_scen1_a+qmv35_scen1_b+qmv35_scen1_c 
replace qmv35_scen1_a=. if sum35_scen1!=100 & Block==2 & wave==1
replace qmv35_scen1_b=. if sum35_scen1!=100 & Block==2 & wave==1
replace qmv35_scen1_c=. if sum35_scen1!=100 & Block==2 & wave==1
lab var qmv35_scen1_a "A: income / sqft / movecost scenario 1"
lab var qmv35_scen1_b "B: income / sqft / movecost scenario 1"
lab var qmv35_scen1_c "C: income / sqft / movecost scenario 1"

gen     qmv35_scen2_a=0 if Block==2 & wave==1 
gen     qmv35_scen2_b=0 if Block==2 & wave==1 
gen     qmv35_scen2_c=0 if Block==2 & wave==1
replace qmv35_scen2_a=qmv30_1_5_2 if !mi(qmv30_1_5_2) & Block==2 & wave==1
replace qmv35_scen2_b=qmv30_2_5_2 if !mi(qmv30_2_5_2) & Block==2 & wave==1
replace qmv35_scen2_c=qmv30_3_5_2 if !mi(qmv30_3_5_2) & Block==2 & wave==1
gen     sum35_scen2=qmv35_scen2_a+qmv35_scen2_b+qmv35_scen2_c 
replace qmv35_scen2_a=. if sum35_scen2!=100 & Block==2 & wave==1
replace qmv35_scen2_b=. if sum35_scen2!=100 & Block==2 & wave==1
replace qmv35_scen2_c=. if sum35_scen2!=100 & Block==2 & wave==1
lab var qmv35_scen2_a "A: income / sqft / movecost scenario 2"
lab var qmv35_scen2_b "B: income / sqft / movecost scenario 2"
lab var qmv35_scen2_c "C: income / sqft / movecost scenario 2"

gen     qmv35_scen3_a=0 if Block==2 & wave==1 
gen     qmv35_scen3_b=0 if Block==2 & wave==1 
gen     qmv35_scen3_c=0 if Block==2 & wave==1
replace qmv35_scen3_a=qmv30_1_5_3 if !mi(qmv30_1_5_3) & Block==2 & wave==1
replace qmv35_scen3_b=qmv30_2_5_3 if !mi(qmv30_2_5_3) & Block==2 & wave==1
replace qmv35_scen3_c=qmv30_3_5_3 if !mi(qmv30_3_5_3) & Block==2 & wave==1
gen     sum35_scen3=qmv35_scen3_a+qmv35_scen3_b+qmv35_scen3_c 
replace qmv35_scen3_a=. if sum35_scen3!=100 & Block==2 & wave==1
replace qmv35_scen3_b=. if sum35_scen3!=100 & Block==2 & wave==1
replace qmv35_scen3_c=. if sum35_scen3!=100 & Block==2 & wave==1
lab var qmv35_scen3_a "A: income / sqft / movecost scenario 3"
lab var qmv35_scen3_b "B: income / sqft / movecost scenario 3"
lab var qmv35_scen3_c "C: income / sqft / movecost scenario 3"

gen     qmv35_scen4_a=0 if Block==2 & wave==1 
gen     qmv35_scen4_b=0 if Block==2 & wave==1 
gen     qmv35_scen4_c=0 if Block==2 & wave==1
replace qmv35_scen4_a=qmv30_1_5_4 if !mi(qmv30_1_5_4) & Block==2 & wave==1
replace qmv35_scen4_b=qmv30_2_5_4 if !mi(qmv30_2_5_4) & Block==2 & wave==1
replace qmv35_scen4_c=qmv30_3_5_4 if !mi(qmv30_3_5_4) & Block==2 & wave==1
gen     sum35_scen4=qmv35_scen4_a+qmv35_scen4_b+qmv35_scen4_c 
replace qmv35_scen4_a=. if sum35_scen4!=100 & Block==2 & wave==1
replace qmv35_scen4_b=. if sum35_scen4!=100 & Block==2 & wave==1
replace qmv35_scen4_c=. if sum35_scen4!=100 & Block==2 & wave==1
lab var qmv35_scen4_a "A: income / sqft / movecost scenario 4"
lab var qmv35_scen4_b "B: income / sqft / movecost scenario 4"
lab var qmv35_scen4_c "C: income / sqft / movecost scenario 4"


* Case 6 (Block 1 of wave 1)
gen     qmv36_scen1_a=0 if Block==1 & wave==1 
gen     qmv36_scen1_b=0 if Block==1 & wave==1 
gen     qmv36_scen1_c=0 if Block==1 & wave==1
replace qmv36_scen1_a=qmv30_1_6_1 if !mi(qmv30_1_6_1) & Block==1 & wave==1
replace qmv36_scen1_b=qmv30_2_6_1 if !mi(qmv30_2_6_1) & Block==1 & wave==1
replace qmv36_scen1_c=qmv30_3_6_1 if !mi(qmv30_3_6_1) & Block==1 & wave==1
gen     sum36_scen1=qmv36_scen1_a+qmv36_scen1_b+qmv36_scen1_c 
replace qmv36_scen1_a=. if sum36_scen1!=100 & Block==1 & wave==1
replace qmv36_scen1_b=. if sum36_scen1!=100 & Block==1 & wave==1
replace qmv36_scen1_c=. if sum36_scen1!=100 & Block==1 & wave==1
lab var qmv36_scen1_a "A: distance / SALT / income scenario 1"
lab var qmv36_scen1_b "B: distance / SALT / income scenario 1"
lab var qmv36_scen1_c "C: distance / SALT / income scenario 1"

gen     qmv36_scen2_a=0 if Block==1 & wave==1 
gen     qmv36_scen2_b=0 if Block==1 & wave==1 
gen     qmv36_scen2_c=0 if Block==1 & wave==1
replace qmv36_scen2_a=qmv30_1_6_2 if !mi(qmv30_1_6_2) & Block==1 & wave==1
replace qmv36_scen2_b=qmv30_2_6_2 if !mi(qmv30_2_6_2) & Block==1 & wave==1
replace qmv36_scen2_c=qmv30_3_6_2 if !mi(qmv30_3_6_2) & Block==1 & wave==1
gen     sum36_scen2=qmv36_scen2_a+qmv36_scen2_b+qmv36_scen2_c 
replace qmv36_scen2_a=. if sum36_scen2!=100 & Block==1 & wave==1
replace qmv36_scen2_b=. if sum36_scen2!=100 & Block==1 & wave==1
replace qmv36_scen2_c=. if sum36_scen2!=100 & Block==1 & wave==1
lab var qmv36_scen2_a "A: distance / SALT / income scenario 2"
lab var qmv36_scen2_b "B: distance / SALT / income scenario 2"
lab var qmv36_scen2_c "C: distance / SALT / income scenario 2"

gen     qmv36_scen3_a=0 if Block==1 & wave==1 
gen     qmv36_scen3_b=0 if Block==1 & wave==1 
gen     qmv36_scen3_c=0 if Block==1 & wave==1
replace qmv36_scen3_a=qmv30_1_6_3 if !mi(qmv30_1_6_3) & Block==1 & wave==1
replace qmv36_scen3_b=qmv30_2_6_3 if !mi(qmv30_2_6_3) & Block==1 & wave==1
replace qmv36_scen3_c=qmv30_3_6_3 if !mi(qmv30_3_6_3) & Block==1 & wave==1
gen     sum36_scen3=qmv36_scen3_a+qmv36_scen3_b+qmv36_scen3_c 
replace qmv36_scen3_a=. if sum36_scen3!=100 & Block==1 & wave==1
replace qmv36_scen3_b=. if sum36_scen3!=100 & Block==1 & wave==1
replace qmv36_scen3_c=. if sum36_scen3!=100 & Block==1 & wave==1
lab var qmv36_scen3_a "A: distance / SALT / income scenario 3"
lab var qmv36_scen3_b "B: distance / SALT / income scenario 3"
lab var qmv36_scen3_c "C: distance / SALT / income scenario 3"

gen     qmv36_scen4_a=0 if Block==1 & wave==1 
gen     qmv36_scen4_b=0 if Block==1 & wave==1 
gen     qmv36_scen4_c=0 if Block==1 & wave==1
replace qmv36_scen4_a=qmv30_1_6_4 if !mi(qmv30_1_6_4) & Block==1 & wave==1
replace qmv36_scen4_b=qmv30_2_6_4 if !mi(qmv30_2_6_4) & Block==1 & wave==1
replace qmv36_scen4_c=qmv30_3_6_4 if !mi(qmv30_3_6_4) & Block==1 & wave==1
gen     sum36_scen4=qmv36_scen4_a+qmv36_scen4_b+qmv36_scen4_c 
replace qmv36_scen4_a=. if sum36_scen4!=100 & Block==1 & wave==1
replace qmv36_scen4_b=. if sum36_scen4!=100 & Block==1 & wave==1
replace qmv36_scen4_c=. if sum36_scen4!=100 & Block==1 & wave==1
lab var qmv36_scen4_a "A: distance / SALT / income scenario 4"
lab var qmv36_scen4_b "B: distance / SALT / income scenario 4"
lab var qmv36_scen4_c "C: distance / SALT / income scenario 4"


****************************************
* December Wave neighborhood choice data
****************************************
* Case 1 (Block 1 only)
gen     qmv41_scen1_a=0 if Block==1 & wave==2 
gen     qmv41_scen1_b=0 if Block==1 & wave==2 
gen     qmv41_scen1_c=0 if Block==1 & wave==2
replace qmv41_scen1_a=qmv40_1_1_1 if !mi(qmv40_1_1_1) & Block==1 & wave==2
replace qmv41_scen1_b=qmv40_2_1_1 if !mi(qmv40_2_1_1) & Block==1 & wave==2
replace qmv41_scen1_c=qmv40_3_1_1 if !mi(qmv40_3_1_1) & Block==1 & wave==2
gen     sum41_scen1=qmv41_scen1_a+qmv41_scen1_b+qmv41_scen1_c 
replace qmv41_scen1_a=. if sum41_scen1!=100 & Block==1 & wave==2
replace qmv41_scen1_b=. if sum41_scen1!=100 & Block==1 & wave==2
replace qmv41_scen1_c=. if sum41_scen1!=100 & Block==1 & wave==2
lab var qmv41_scen1_a "A: distance / crime / income scenario 1"
lab var qmv41_scen1_b "B: distance / crime / income scenario 1"
lab var qmv41_scen1_c "C: distance / crime / income scenario 1"

gen     qmv41_scen2_a=0 if Block==1 & wave==2 
gen     qmv41_scen2_b=0 if Block==1 & wave==2 
gen     qmv41_scen2_c=0 if Block==1 & wave==2
replace qmv41_scen2_a=qmv40_1_1_2 if !mi(qmv40_1_1_2) & Block==1 & wave==2
replace qmv41_scen2_b=qmv40_2_1_2 if !mi(qmv40_2_1_2) & Block==1 & wave==2
replace qmv41_scen2_c=qmv40_3_1_2 if !mi(qmv40_3_1_2) & Block==1 & wave==2
gen     sum41_scen2=qmv41_scen2_a+qmv41_scen2_b+qmv41_scen2_c 
replace qmv41_scen2_a=. if sum41_scen2!=100 & Block==1 & wave==2
replace qmv41_scen2_b=. if sum41_scen2!=100 & Block==1 & wave==2
replace qmv41_scen2_c=. if sum41_scen2!=100 & Block==1 & wave==2
lab var qmv41_scen2_a "A: distance / crime / income scenario 2"
lab var qmv41_scen2_b "B: distance / crime / income scenario 2"
lab var qmv41_scen2_c "C: distance / crime / income scenario 2"

gen     qmv41_scen3_a=0 if Block==1 & wave==2 
gen     qmv41_scen3_b=0 if Block==1 & wave==2 
gen     qmv41_scen3_c=0 if Block==1 & wave==2
replace qmv41_scen3_a=qmv40_1_1_3 if !mi(qmv40_1_1_3) & Block==1 & wave==2
replace qmv41_scen3_b=qmv40_2_1_3 if !mi(qmv40_2_1_3) & Block==1 & wave==2
replace qmv41_scen3_c=qmv40_3_1_3 if !mi(qmv40_3_1_3) & Block==1 & wave==2
gen     sum41_scen3=qmv41_scen3_a+qmv41_scen3_b+qmv41_scen3_c 
replace qmv41_scen3_a=. if sum41_scen3!=100 & Block==1 & wave==2
replace qmv41_scen3_b=. if sum41_scen3!=100 & Block==1 & wave==2
replace qmv41_scen3_c=. if sum41_scen3!=100 & Block==1 & wave==2
lab var qmv41_scen3_a "A: distance / crime / income scenario 3"
lab var qmv41_scen3_b "B: distance / crime / income scenario 3"
lab var qmv41_scen3_c "C: distance / crime / income scenario 3"

gen     qmv41_scen4_a=0 if Block==1 & wave==2 
gen     qmv41_scen4_b=0 if Block==1 & wave==2 
gen     qmv41_scen4_c=0 if Block==1 & wave==2
replace qmv41_scen4_a=qmv40_1_1_4 if !mi(qmv40_1_1_4) & Block==1 & wave==2
replace qmv41_scen4_b=qmv40_2_1_4 if !mi(qmv40_2_1_4) & Block==1 & wave==2
replace qmv41_scen4_c=qmv40_3_1_4 if !mi(qmv40_3_1_4) & Block==1 & wave==2
gen     sum41_scen4=qmv41_scen4_a+qmv41_scen4_b+qmv41_scen4_c 
replace qmv41_scen4_a=. if sum41_scen4!=100 & Block==1 & wave==2
replace qmv41_scen4_b=. if sum41_scen4!=100 & Block==1 & wave==2
replace qmv41_scen4_c=. if sum41_scen4!=100 & Block==1 & wave==2
lab var qmv41_scen4_a "A: distance / crime / income scenario 4"
lab var qmv41_scen4_b "B: distance / crime / income scenario 4"
lab var qmv41_scen4_c "C: distance / crime / income scenario 4"


* Case 2 (Block 1 only)
gen     qmv42_scen1_a=0 if Block==1 & wave==2 
gen     qmv42_scen1_b=0 if Block==1 & wave==2 
gen     qmv42_scen1_c=0 if Block==1 & wave==2
replace qmv42_scen1_a=qmv40_1_2_1 if !mi(qmv40_1_2_1) & Block==1 & wave==2
replace qmv42_scen1_b=qmv40_2_2_1 if !mi(qmv40_2_2_1) & Block==1 & wave==2
replace qmv42_scen1_c=qmv40_3_2_1 if !mi(qmv40_3_2_1) & Block==1 & wave==2
gen     sum42_scen1=qmv42_scen1_a+qmv42_scen1_b+qmv42_scen1_c 
replace qmv42_scen1_a=. if sum42_scen1!=100 & Block==1 & wave==2
replace qmv42_scen1_b=. if sum42_scen1!=100 & Block==1 & wave==2
replace qmv42_scen1_c=. if sum42_scen1!=100 & Block==1 & wave==2
lab var qmv42_scen1_a "A: distance / schquality / income scenario 1"
lab var qmv42_scen1_b "B: distance / schquality / income scenario 1"
lab var qmv42_scen1_c "C: distance / schquality / income scenario 1"

gen     qmv42_scen2_a=0 if Block==1 & wave==2 
gen     qmv42_scen2_b=0 if Block==1 & wave==2 
gen     qmv42_scen2_c=0 if Block==1 & wave==2
replace qmv42_scen2_a=qmv40_1_2_2 if !mi(qmv40_1_2_2) & Block==1 & wave==2
replace qmv42_scen2_b=qmv40_2_2_2 if !mi(qmv40_2_2_2) & Block==1 & wave==2
replace qmv42_scen2_c=qmv40_3_2_2 if !mi(qmv40_3_2_2) & Block==1 & wave==2
gen     sum42_scen2=qmv42_scen2_a+qmv42_scen2_b+qmv42_scen2_c 
replace qmv42_scen2_a=. if sum42_scen2!=100 & Block==1 & wave==2
replace qmv42_scen2_b=. if sum42_scen2!=100 & Block==1 & wave==2
replace qmv42_scen2_c=. if sum42_scen2!=100 & Block==1 & wave==2
lab var qmv42_scen2_a "A: distance / schquality / income scenario 2"
lab var qmv42_scen2_b "B: distance / schquality / income scenario 2"
lab var qmv42_scen2_c "C: distance / schquality / income scenario 2"

gen     qmv42_scen3_a=0 if Block==1 & wave==2 
gen     qmv42_scen3_b=0 if Block==1 & wave==2 
gen     qmv42_scen3_c=0 if Block==1 & wave==2
replace qmv42_scen3_a=qmv40_1_2_3 if !mi(qmv40_1_2_3) & Block==1 & wave==2
replace qmv42_scen3_b=qmv40_2_2_3 if !mi(qmv40_2_2_3) & Block==1 & wave==2
replace qmv42_scen3_c=qmv40_3_2_3 if !mi(qmv40_3_2_3) & Block==1 & wave==2
gen     sum42_scen3=qmv42_scen3_a+qmv42_scen3_b+qmv42_scen3_c 
replace qmv42_scen3_a=. if sum42_scen3!=100 & Block==1 & wave==2
replace qmv42_scen3_b=. if sum42_scen3!=100 & Block==1 & wave==2
replace qmv42_scen3_c=. if sum42_scen3!=100 & Block==1 & wave==2
lab var qmv42_scen3_a "A: distance / schquality / income scenario 3"
lab var qmv42_scen3_b "B: distance / schquality / income scenario 3"
lab var qmv42_scen3_c "C: distance / schquality / income scenario 3"

gen     qmv42_scen4_a=0 if Block==1 & wave==2 
gen     qmv42_scen4_b=0 if Block==1 & wave==2 
gen     qmv42_scen4_c=0 if Block==1 & wave==2
replace qmv42_scen4_a=qmv40_1_2_4 if !mi(qmv40_1_2_4) & Block==1 & wave==2
replace qmv42_scen4_b=qmv40_2_2_4 if !mi(qmv40_2_2_4) & Block==1 & wave==2
replace qmv42_scen4_c=qmv40_3_2_4 if !mi(qmv40_3_2_4) & Block==1 & wave==2
gen     sum42_scen4=qmv42_scen4_a+qmv42_scen4_b+qmv42_scen4_c 
replace qmv42_scen4_a=. if sum42_scen4!=100 & Block==1 & wave==2
replace qmv42_scen4_b=. if sum42_scen4!=100 & Block==1 & wave==2
replace qmv42_scen4_c=. if sum42_scen4!=100 & Block==1 & wave==2
lab var qmv42_scen4_a "A: distance / schquality / income scenario 4"
lab var qmv42_scen4_b "B: distance / schquality / income scenario 4"
lab var qmv42_scen4_c "C: distance / schquality / income scenario 4"


* Case 3 (Block 2 only)
gen     qmv43_scen1_a=0 if Block==2 & wave==2 
gen     qmv43_scen1_b=0 if Block==2 & wave==2 
gen     qmv43_scen1_c=0 if Block==2 & wave==2
replace qmv43_scen1_a=qmv40_1_3_1 if !mi(qmv40_1_3_1) & Block==2 & wave==2
replace qmv43_scen1_b=qmv40_2_3_1 if !mi(qmv40_2_3_1) & Block==2 & wave==2
replace qmv43_scen1_c=qmv40_3_3_1 if !mi(qmv40_3_3_1) & Block==2 & wave==2
gen     sum43_scen1=qmv43_scen1_a+qmv43_scen1_b+qmv43_scen1_c 
replace qmv43_scen1_a=. if sum43_scen1!=100 & Block==2 & wave==2
replace qmv43_scen1_b=. if sum43_scen1!=100 & Block==2 & wave==2
replace qmv43_scen1_c=. if sum43_scen1!=100 & Block==2 & wave==2
lab var qmv43_scen1_a "A: distance / family / income scenario 1"
lab var qmv43_scen1_b "B: distance / family / income scenario 1"
lab var qmv43_scen1_c "C: distance / family / income scenario 1"

gen     qmv43_scen2_a=0 if Block==2 & wave==2 
gen     qmv43_scen2_b=0 if Block==2 & wave==2 
gen     qmv43_scen2_c=0 if Block==2 & wave==2
replace qmv43_scen2_a=qmv40_1_3_2 if !mi(qmv40_1_3_2) & Block==2 & wave==2
replace qmv43_scen2_b=qmv40_2_3_2 if !mi(qmv40_2_3_2) & Block==2 & wave==2
replace qmv43_scen2_c=qmv40_3_3_2 if !mi(qmv40_3_3_2) & Block==2 & wave==2
gen     sum43_scen2=qmv43_scen2_a+qmv43_scen2_b+qmv43_scen2_c 
replace qmv43_scen2_a=. if sum43_scen2!=100 & Block==2 & wave==2
replace qmv43_scen2_b=. if sum43_scen2!=100 & Block==2 & wave==2
replace qmv43_scen2_c=. if sum43_scen2!=100 & Block==2 & wave==2
lab var qmv43_scen2_a "A: distance / family / income scenario 2"
lab var qmv43_scen2_b "B: distance / family / income scenario 2"
lab var qmv43_scen2_c "C: distance / family / income scenario 2"

gen     qmv43_scen3_a=0 if Block==2 & wave==2 
gen     qmv43_scen3_b=0 if Block==2 & wave==2 
gen     qmv43_scen3_c=0 if Block==2 & wave==2
replace qmv43_scen3_a=qmv40_1_3_3 if !mi(qmv40_1_3_3) & Block==2 & wave==2
replace qmv43_scen3_b=qmv40_2_3_3 if !mi(qmv40_2_3_3) & Block==2 & wave==2
replace qmv43_scen3_c=qmv40_3_3_3 if !mi(qmv40_3_3_3) & Block==2 & wave==2
gen     sum43_scen3=qmv43_scen3_a+qmv43_scen3_b+qmv43_scen3_c 
replace qmv43_scen3_a=. if sum43_scen3!=100 & Block==2 & wave==2
replace qmv43_scen3_b=. if sum43_scen3!=100 & Block==2 & wave==2
replace qmv43_scen3_c=. if sum43_scen3!=100 & Block==2 & wave==2
lab var qmv43_scen3_a "A: distance / family / income scenario 3"
lab var qmv43_scen3_b "B: distance / family / income scenario 3"
lab var qmv43_scen3_c "C: distance / family / income scenario 3"

gen     qmv43_scen4_a=0 if Block==2 & wave==2 
gen     qmv43_scen4_b=0 if Block==2 & wave==2 
gen     qmv43_scen4_c=0 if Block==2 & wave==2
replace qmv43_scen4_a=qmv40_1_3_4 if !mi(qmv40_1_3_4) & Block==2 & wave==2
replace qmv43_scen4_b=qmv40_2_3_4 if !mi(qmv40_2_3_4) & Block==2 & wave==2
replace qmv43_scen4_c=qmv40_3_3_4 if !mi(qmv40_3_3_4) & Block==2 & wave==2
gen     sum43_scen4=qmv43_scen4_a+qmv43_scen4_b+qmv43_scen4_c 
replace qmv43_scen4_a=. if sum43_scen4!=100 & Block==2 & wave==2
replace qmv43_scen4_b=. if sum43_scen4!=100 & Block==2 & wave==2
replace qmv43_scen4_c=. if sum43_scen4!=100 & Block==2 & wave==2
lab var qmv43_scen4_a "A: distance / family / income scenario 4"
lab var qmv43_scen4_b "B: distance / family / income scenario 4"
lab var qmv43_scen4_c "C: distance / family / income scenario 4"


* Case 4 (Both Blocks)
gen     qmv44_scen1_a=0 if wave==2 
gen     qmv44_scen1_b=0 if wave==2 
gen     qmv44_scen1_c=0 if wave==2
replace qmv44_scen1_a=qmv40_1_4_1 if !mi(qmv40_1_4_1) & wave==2
replace qmv44_scen1_b=qmv40_2_4_1 if !mi(qmv40_2_4_1) & wave==2
replace qmv44_scen1_c=qmv40_3_4_1 if !mi(qmv40_3_4_1) & wave==2
gen     sum44_scen1=qmv44_scen1_a+qmv44_scen1_b+qmv44_scen1_c 
replace qmv44_scen1_a=. if sum44_scen1!=100 & wave==2
replace qmv44_scen1_b=. if sum44_scen1!=100 & wave==2
replace qmv44_scen1_c=. if sum44_scen1!=100 & wave==2
lab var qmv44_scen1_a "A: distance / values / housingcost scenario 1"
lab var qmv44_scen1_b "B: distance / values / housingcost scenario 1"
lab var qmv44_scen1_c "C: distance / values / housingcost scenario 1"

gen     qmv44_scen2_a=0 if wave==2 
gen     qmv44_scen2_b=0 if wave==2 
gen     qmv44_scen2_c=0 if wave==2
replace qmv44_scen2_a=qmv40_1_4_2 if !mi(qmv40_1_4_2) & wave==2
replace qmv44_scen2_b=qmv40_2_4_2 if !mi(qmv40_2_4_2) & wave==2
replace qmv44_scen2_c=qmv40_3_4_2 if !mi(qmv40_3_4_2) & wave==2
gen     sum44_scen2=qmv44_scen2_a+qmv44_scen2_b+qmv44_scen2_c 
replace qmv44_scen2_a=. if sum44_scen2!=100 & wave==2
replace qmv44_scen2_b=. if sum44_scen2!=100 & wave==2
replace qmv44_scen2_c=. if sum44_scen2!=100 & wave==2
lab var qmv44_scen2_a "A: distance / values / housingcost scenario 2"
lab var qmv44_scen2_b "B: distance / values / housingcost scenario 2"
lab var qmv44_scen2_c "C: distance / values / housingcost scenario 2"

gen     qmv44_scen3_a=0 if wave==2 
gen     qmv44_scen3_b=0 if wave==2 
gen     qmv44_scen3_c=0 if wave==2
replace qmv44_scen3_a=qmv40_1_4_3 if !mi(qmv40_1_4_3) & wave==2
replace qmv44_scen3_b=qmv40_2_4_3 if !mi(qmv40_2_4_3) & wave==2
replace qmv44_scen3_c=qmv40_3_4_3 if !mi(qmv40_3_4_3) & wave==2
gen     sum44_scen3=qmv44_scen3_a+qmv44_scen3_b+qmv44_scen3_c 
replace qmv44_scen3_a=. if sum44_scen3!=100 & wave==2
replace qmv44_scen3_b=. if sum44_scen3!=100 & wave==2
replace qmv44_scen3_c=. if sum44_scen3!=100 & wave==2
lab var qmv44_scen3_a "A: distance / values / housingcost scenario 3"
lab var qmv44_scen3_b "B: distance / values / housingcost scenario 3"
lab var qmv44_scen3_c "C: distance / values / housingcost scenario 3"

gen     qmv44_scen4_a=0 if wave==2 
gen     qmv44_scen4_b=0 if wave==2 
gen     qmv44_scen4_c=0 if wave==2
replace qmv44_scen4_a=qmv40_1_4_4 if !mi(qmv40_1_4_4) & wave==2
replace qmv44_scen4_b=qmv40_2_4_4 if !mi(qmv40_2_4_4) & wave==2
replace qmv44_scen4_c=qmv40_3_4_4 if !mi(qmv40_3_4_4) & wave==2
gen     sum44_scen4=qmv44_scen4_a+qmv44_scen4_b+qmv44_scen4_c 
replace qmv44_scen4_a=. if sum44_scen4!=100 & wave==2
replace qmv44_scen4_b=. if sum44_scen4!=100 & wave==2
replace qmv44_scen4_c=. if sum44_scen4!=100 & wave==2
lab var qmv44_scen4_a "A: distance / values / housingcost scenario 4"
lab var qmv44_scen4_b "B: distance / values / housingcost scenario 4"
lab var qmv44_scen4_c "C: distance / values / housingcost scenario 4"


* Case 5 (Block 2 of wave 1)
gen     qmv45_scen1_a=0 if Block==2 & wave==2 
gen     qmv45_scen1_b=0 if Block==2 & wave==2 
gen     qmv45_scen1_c=0 if Block==2 & wave==2
replace qmv45_scen1_a=qmv40_1_5_1 if !mi(qmv40_1_5_1) & Block==2 & wave==2
replace qmv45_scen1_b=qmv40_2_5_1 if !mi(qmv40_2_5_1) & Block==2 & wave==2
replace qmv45_scen1_c=qmv40_3_5_1 if !mi(qmv40_3_5_1) & Block==2 & wave==2
gen     sum45_scen1=qmv45_scen1_a+qmv45_scen1_b+qmv45_scen1_c 
replace qmv45_scen1_a=. if sum45_scen1!=100 & Block==2 & wave==2
replace qmv45_scen1_b=. if sum45_scen1!=100 & Block==2 & wave==2
replace qmv45_scen1_c=. if sum45_scen1!=100 & Block==2 & wave==2
lab var qmv45_scen1_a "A: distance / schquality / housingcost scenario 1"
lab var qmv45_scen1_b "B: distance / schquality / housingcost scenario 1"
lab var qmv45_scen1_c "C: distance / schquality / housingcost scenario 1"

gen     qmv45_scen2_a=0 if Block==2 & wave==2 
gen     qmv45_scen2_b=0 if Block==2 & wave==2 
gen     qmv45_scen2_c=0 if Block==2 & wave==2
replace qmv45_scen2_a=qmv40_1_5_2 if !mi(qmv40_1_5_2) & Block==2 & wave==2
replace qmv45_scen2_b=qmv40_2_5_2 if !mi(qmv40_2_5_2) & Block==2 & wave==2
replace qmv45_scen2_c=qmv40_3_5_2 if !mi(qmv40_3_5_2) & Block==2 & wave==2
gen     sum45_scen2=qmv45_scen2_a+qmv45_scen2_b+qmv45_scen2_c 
replace qmv45_scen2_a=. if sum45_scen2!=100 & Block==2 & wave==2
replace qmv45_scen2_b=. if sum45_scen2!=100 & Block==2 & wave==2
replace qmv45_scen2_c=. if sum45_scen2!=100 & Block==2 & wave==2
lab var qmv45_scen2_a "A: distance / schquality / housingcost scenario 2"
lab var qmv45_scen2_b "B: distance / schquality / housingcost scenario 2"
lab var qmv45_scen2_c "C: distance / schquality / housingcost scenario 2"

gen     qmv45_scen3_a=0 if Block==2 & wave==2 
gen     qmv45_scen3_b=0 if Block==2 & wave==2 
gen     qmv45_scen3_c=0 if Block==2 & wave==2
replace qmv45_scen3_a=qmv40_1_5_3 if !mi(qmv40_1_5_3) & Block==2 & wave==2
replace qmv45_scen3_b=qmv40_2_5_3 if !mi(qmv40_2_5_3) & Block==2 & wave==2
replace qmv45_scen3_c=qmv40_3_5_3 if !mi(qmv40_3_5_3) & Block==2 & wave==2
gen     sum45_scen3=qmv45_scen3_a+qmv45_scen3_b+qmv45_scen3_c 
replace qmv45_scen3_a=. if sum45_scen3!=100 & Block==2 & wave==2
replace qmv45_scen3_b=. if sum45_scen3!=100 & Block==2 & wave==2
replace qmv45_scen3_c=. if sum45_scen3!=100 & Block==2 & wave==2
lab var qmv45_scen3_a "A: distance / schquality / housingcost scenario 3"
lab var qmv45_scen3_b "B: distance / schquality / housingcost scenario 3"
lab var qmv45_scen3_c "C: distance / schquality / housingcost scenario 3"

gen     qmv45_scen4_a=0 if Block==2 & wave==2 
gen     qmv45_scen4_b=0 if Block==2 & wave==2 
gen     qmv45_scen4_c=0 if Block==2 & wave==2
replace qmv45_scen4_a=qmv40_1_5_4 if !mi(qmv40_1_5_4) & Block==2 & wave==2
replace qmv45_scen4_b=qmv40_2_5_4 if !mi(qmv40_2_5_4) & Block==2 & wave==2
replace qmv45_scen4_c=qmv40_3_5_4 if !mi(qmv40_3_5_4) & Block==2 & wave==2
gen     sum45_scen4=qmv45_scen4_a+qmv45_scen4_b+qmv45_scen4_c 
replace qmv45_scen4_a=. if sum45_scen4!=100 & Block==2 & wave==2
replace qmv45_scen4_b=. if sum45_scen4!=100 & Block==2 & wave==2
replace qmv45_scen4_c=. if sum45_scen4!=100 & Block==2 & wave==2
lab var qmv45_scen4_a "A: distance / schquality / housingcost scenario 4"
lab var qmv45_scen4_b "B: distance / schquality / housingcost scenario 4"
lab var qmv45_scen4_c "C: distance / schquality / housingcost scenario 4"


* Case 6 (Both Blocks)
gen     qmv46_scen1_a=0 if wave==2 
gen     qmv46_scen1_b=0 if wave==2 
gen     qmv46_scen1_c=0 if wave==2
replace qmv46_scen1_a=qmv40_1_6_1 if !mi(qmv40_1_6_1) & wave==2
replace qmv46_scen1_b=qmv40_2_6_1 if !mi(qmv40_2_6_1) & wave==2
replace qmv46_scen1_c=qmv40_3_6_1 if !mi(qmv40_3_6_1) & wave==2
gen     sum46_scen1=qmv46_scen1_a+qmv46_scen1_b+qmv46_scen1_c 
replace qmv46_scen1_a=. if sum46_scen1!=100 & wave==2
replace qmv46_scen1_b=. if sum46_scen1!=100 & wave==2
replace qmv46_scen1_c=. if sum46_scen1!=100 & wave==2
lab var qmv46_scen1_a "A: distance / hometype / subsidy scenario 1"
lab var qmv46_scen1_b "B: distance / hometype / subsidy scenario 1"
lab var qmv46_scen1_c "C: distance / hometype / subsidy scenario 1"

gen     qmv46_scen2_a=0 if wave==2 
gen     qmv46_scen2_b=0 if wave==2 
gen     qmv46_scen2_c=0 if wave==2
replace qmv46_scen2_a=qmv40_1_6_2 if !mi(qmv40_1_6_2) & wave==2
replace qmv46_scen2_b=qmv40_2_6_2 if !mi(qmv40_2_6_2) & wave==2
replace qmv46_scen2_c=qmv40_3_6_2 if !mi(qmv40_3_6_2) & wave==2
gen     sum46_scen2=qmv46_scen2_a+qmv46_scen2_b+qmv46_scen2_c 
replace qmv46_scen2_a=. if sum46_scen2!=100 & wave==2
replace qmv46_scen2_b=. if sum46_scen2!=100 & wave==2
replace qmv46_scen2_c=. if sum46_scen2!=100 & wave==2
lab var qmv46_scen2_a "A: distance / hometype / subsidy scenario 2"
lab var qmv46_scen2_b "B: distance / hometype / subsidy scenario 2"
lab var qmv46_scen2_c "C: distance / hometype / subsidy scenario 2"

gen     qmv46_scen3_a=0 if wave==2 
gen     qmv46_scen3_b=0 if wave==2 
gen     qmv46_scen3_c=0 if wave==2
replace qmv46_scen3_a=qmv40_1_6_3 if !mi(qmv40_1_6_3) & wave==2
replace qmv46_scen3_b=qmv40_2_6_3 if !mi(qmv40_2_6_3) & wave==2
replace qmv46_scen3_c=qmv40_3_6_3 if !mi(qmv40_3_6_3) & wave==2
gen     sum46_scen3=qmv46_scen3_a+qmv46_scen3_b+qmv46_scen3_c 
replace qmv46_scen3_a=. if sum46_scen3!=100 & wave==2
replace qmv46_scen3_b=. if sum46_scen3!=100 & wave==2
replace qmv46_scen3_c=. if sum46_scen3!=100 & wave==2
lab var qmv46_scen3_a "A: distance / hometype / subsidy scenario 3"
lab var qmv46_scen3_b "B: distance / hometype / subsidy scenario 3"
lab var qmv46_scen3_c "C: distance / hometype / subsidy scenario 3"

gen     qmv46_scen4_a=0 if wave==2 
gen     qmv46_scen4_b=0 if wave==2 
gen     qmv46_scen4_c=0 if wave==2
replace qmv46_scen4_a=qmv40_1_6_4 if !mi(qmv40_1_6_4) & wave==2
replace qmv46_scen4_b=qmv40_2_6_4 if !mi(qmv40_2_6_4) & wave==2
replace qmv46_scen4_c=qmv40_3_6_4 if !mi(qmv40_3_6_4) & wave==2
gen     sum46_scen4=qmv46_scen4_a+qmv46_scen4_b+qmv46_scen4_c 
replace qmv46_scen4_a=. if sum46_scen4!=100 & wave==2
replace qmv46_scen4_b=. if sum46_scen4!=100 & wave==2
replace qmv46_scen4_c=. if sum46_scen4!=100 & wave==2
lab var qmv46_scen4_a "A: distance / hometype / subsidy scenario 4"
lab var qmv46_scen4_b "B: distance / hometype / subsidy scenario 4"
lab var qmv46_scen4_c "C: distance / hometype / subsidy scenario 4"





****************************************
* Summary stats on neighborhood choice data
****************************************
* How often are the three choice probabilities within a scenario summing to something not equal to 100?
tab sum31_scen1 [aw=rim_4_original]
tab sum31_scen2 [aw=rim_4_original]
tab sum31_scen3 [aw=rim_4_original]
tab sum31_scen4 [aw=rim_4_original]
tab sum32_scen1 [aw=rim_4_original]
tab sum32_scen2 [aw=rim_4_original]
tab sum32_scen3 [aw=rim_4_original]
tab sum32_scen4 [aw=rim_4_original]
tab sum33_scen1 [aw=rim_4_original]
tab sum33_scen2 [aw=rim_4_original]
tab sum33_scen3 [aw=rim_4_original]
tab sum33_scen4 [aw=rim_4_original]
tab sum34_scen1 [aw=rim_4_original]
tab sum34_scen2 [aw=rim_4_original]
tab sum34_scen3 [aw=rim_4_original]
tab sum34_scen4 [aw=rim_4_original]
tab sum35_scen1 [aw=rim_4_original]
tab sum35_scen2 [aw=rim_4_original]
tab sum35_scen3 [aw=rim_4_original]
tab sum35_scen4 [aw=rim_4_original]
tab sum36_scen1 [aw=rim_4_original]
tab sum36_scen2 [aw=rim_4_original]
tab sum36_scen3 [aw=rim_4_original]
tab sum36_scen4 [aw=rim_4_original]

tab sum41_scen1 [aw=rim_4_original]
tab sum41_scen2 [aw=rim_4_original]
tab sum41_scen3 [aw=rim_4_original]
tab sum41_scen4 [aw=rim_4_original]
tab sum42_scen1 [aw=rim_4_original]
tab sum42_scen2 [aw=rim_4_original]
tab sum42_scen3 [aw=rim_4_original]
tab sum42_scen4 [aw=rim_4_original]
tab sum43_scen1 [aw=rim_4_original]
tab sum43_scen2 [aw=rim_4_original]
tab sum43_scen3 [aw=rim_4_original]
tab sum43_scen4 [aw=rim_4_original]
tab sum44_scen1 [aw=rim_4_original]
tab sum44_scen2 [aw=rim_4_original]
tab sum44_scen3 [aw=rim_4_original]
tab sum44_scen4 [aw=rim_4_original]
tab sum45_scen1 [aw=rim_4_original]
tab sum45_scen2 [aw=rim_4_original]
tab sum45_scen3 [aw=rim_4_original]
tab sum45_scen4 [aw=rim_4_original]
tab sum46_scen1 [aw=rim_4_original]
tab sum46_scen2 [aw=rim_4_original]
tab sum46_scen3 [aw=rim_4_original]
tab sum46_scen4 [aw=rim_4_original]


* What is the distribution of choice probabilities within a given alternative and scenario?
sum qmv31_scen1_a qmv31_scen1_b qmv31_scen1_c [w=rim_4_original],d
sum qmv31_scen2_a qmv31_scen2_b qmv31_scen2_c [w=rim_4_original],d
sum qmv31_scen3_a qmv31_scen3_b qmv31_scen3_c [w=rim_4_original],d
sum qmv31_scen4_a qmv31_scen4_b qmv31_scen4_c [w=rim_4_original],d

sum qmv32_scen1_a qmv32_scen1_b qmv32_scen1_c [w=rim_4_original],d
sum qmv32_scen2_a qmv32_scen2_b qmv32_scen2_c [w=rim_4_original],d
sum qmv32_scen3_a qmv32_scen3_b qmv32_scen3_c [w=rim_4_original],d
sum qmv32_scen4_a qmv32_scen4_b qmv32_scen4_c [w=rim_4_original],d

sum qmv33_scen1_a qmv33_scen1_b qmv33_scen1_c [w=rim_4_original],d
sum qmv33_scen2_a qmv33_scen2_b qmv33_scen2_c [w=rim_4_original],d
sum qmv33_scen3_a qmv33_scen3_b qmv33_scen3_c [w=rim_4_original],d
sum qmv33_scen4_a qmv33_scen4_b qmv33_scen4_c [w=rim_4_original],d

sum qmv34_scen1_a qmv34_scen1_b qmv34_scen1_c [w=rim_4_original],d
sum qmv34_scen2_a qmv34_scen2_b qmv34_scen2_c [w=rim_4_original],d
sum qmv34_scen3_a qmv34_scen3_b qmv34_scen3_c [w=rim_4_original],d
sum qmv34_scen4_a qmv34_scen4_b qmv34_scen4_c [w=rim_4_original],d

sum qmv35_scen1_a qmv35_scen1_b qmv35_scen1_c [w=rim_4_original],d
sum qmv35_scen2_a qmv35_scen2_b qmv35_scen2_c [w=rim_4_original],d
sum qmv35_scen3_a qmv35_scen3_b qmv35_scen3_c [w=rim_4_original],d
sum qmv35_scen4_a qmv35_scen4_b qmv35_scen4_c [w=rim_4_original],d

sum qmv36_scen1_a qmv36_scen1_b qmv36_scen1_c [w=rim_4_original],d
sum qmv36_scen2_a qmv36_scen2_b qmv36_scen2_c [w=rim_4_original],d
sum qmv36_scen3_a qmv36_scen3_b qmv36_scen3_c [w=rim_4_original],d
sum qmv36_scen4_a qmv36_scen4_b qmv36_scen4_c [w=rim_4_original],d

sum qmv41_scen1_a qmv41_scen1_b qmv41_scen1_c [w=rim_4_original],d
sum qmv41_scen2_a qmv41_scen2_b qmv41_scen2_c [w=rim_4_original],d
sum qmv41_scen3_a qmv41_scen3_b qmv41_scen3_c [w=rim_4_original],d
sum qmv41_scen4_a qmv41_scen4_b qmv41_scen4_c [w=rim_4_original],d

sum qmv42_scen1_a qmv42_scen1_b qmv42_scen1_c [w=rim_4_original],d
sum qmv42_scen2_a qmv42_scen2_b qmv42_scen2_c [w=rim_4_original],d
sum qmv42_scen3_a qmv42_scen3_b qmv42_scen3_c [w=rim_4_original],d
sum qmv42_scen4_a qmv42_scen4_b qmv42_scen4_c [w=rim_4_original],d

sum qmv43_scen1_a qmv43_scen1_b qmv43_scen1_c [w=rim_4_original],d
sum qmv43_scen2_a qmv43_scen2_b qmv43_scen2_c [w=rim_4_original],d
sum qmv43_scen3_a qmv43_scen3_b qmv43_scen3_c [w=rim_4_original],d
sum qmv43_scen4_a qmv43_scen4_b qmv43_scen4_c [w=rim_4_original],d

sum qmv44_scen1_a qmv44_scen1_b qmv44_scen1_c [w=rim_4_original],d
sum qmv44_scen2_a qmv44_scen2_b qmv44_scen2_c [w=rim_4_original],d
sum qmv44_scen3_a qmv44_scen3_b qmv44_scen3_c [w=rim_4_original],d
sum qmv44_scen4_a qmv44_scen4_b qmv44_scen4_c [w=rim_4_original],d

sum qmv45_scen1_a qmv45_scen1_b qmv45_scen1_c [w=rim_4_original],d
sum qmv45_scen2_a qmv45_scen2_b qmv45_scen2_c [w=rim_4_original],d
sum qmv45_scen3_a qmv45_scen3_b qmv45_scen3_c [w=rim_4_original],d
sum qmv45_scen4_a qmv45_scen4_b qmv45_scen4_c [w=rim_4_original],d

sum qmv46_scen1_a qmv46_scen1_b qmv46_scen1_c [w=rim_4_original],d
sum qmv46_scen2_a qmv46_scen2_b qmv46_scen2_c [w=rim_4_original],d
sum qmv46_scen3_a qmv46_scen3_b qmv46_scen3_c [w=rim_4_original],d
sum qmv46_scen4_a qmv46_scen4_b qmv46_scen4_c [w=rim_4_original],d


****************************************
* Richard Florida-style questions
****************************************
lab def vlagree  1 "Strongly disagree" 2 "Somewhat disagree" 3 "Neither agree nor disagree" 4 "Somewhat agree" 5 "Strongly agree"
lab var qmv11a_1 "Willing to move to avoid unemployment"
lab val qmv11a_1 vlagree
lab var qmv11b_1 "Moving is best way for people to improve their lives"
lab val qmv11b_1 vlagree
lab var qmv11c_1 "Moving required in order to pursue better job opportunities"
lab val qmv11c_1 vlagree
lab var qmv12    "Mobile / Stuck / Rooted"
lab def vlroot    1 "Mobile" 2 "Stuck" 3 "Rooted"
lab val qmv12  vlroot

tab qmv11a_1 [aw=rim_4_original]
tab qmv11b_1 [aw=rim_4_original]
tab qmv11c_1 [aw=rim_4_original]
tab qmv12    [aw=rim_4_original]

isid scuid wave


* calculate group-specific household income (for WTPs later on)
qui sum hhincome [w=rim_4_original] if female==1, d
global FemaleMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if female==0, d
global MaleMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if agenew<50, d
global YoungMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if agenew>=50, d
global OldMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if !married, d
global SingleMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if married, d
global MarriedMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if grad4yr==0, d
global NoGradMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if grad4yr==1, d
global GradMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if !haskids_in_home, d
global NoKidsMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if haskids_in_home, d
global KidsMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if inlist(health,1,2), d
global HealthyMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if inlist(health,3,4,5), d
global LessHealthyMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if ownhome==0, d
global RenterMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if ownhome==1, d
global OwnerMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if loIncome==1, d
global PoorMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if hiIncome==1, d
global RichMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if residence==1, d
global CityMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if residence==2, d
global SuburbMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if residence==3, d
global RuralMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if inrange(qmv7_1,33,.), d
global pmoveG33Medinc `r(p50)'
qui sum hhincome [w=rim_4_original] if inrange(qmv7_1,2.000001,32.9999999), d
global pmove332Medinc `r(p50)'
qui sum hhincome [w=rim_4_original] if inrange(qmv7_1,0,2), d
global pmove02Medinc `r(p50)'
qui sum hhincome [w=rim_4_original] if inrange(qmv1_1,0,5), d
global livedHereL5Medinc `r(p50)'
qui sum hhincome [w=rim_4_original] if inrange(qmv1_1,5.00001,10), d
global livedHere510Medinc `r(p50)'
qui sum hhincome [w=rim_4_original] if inrange(qmv1_1,10.00001,.), d
global livedHereG10Medinc `r(p50)'
qui sum hhincome [w=rim_4_original] if inrange(qmv1a_1,500,1500), d
global smallhouseMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if inrange(qmv1a_1,1500.00001,.), d
global bighouseMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if inrange(medhvalsqft,0,150), d
global cheaphouseMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if inrange(medhvalsqft,150.00001,.), d
global expensivehouseMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if qmv12==1, d
global MobileMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if qmv12==2, d
global StuckMedinc `r(p50)'
qui sum hhincome [w=rim_4_original] if qmv12==3, d
global RootedMedinc `r(p50)'

**** Histograms of choice probabilities across all alternatives and scenarios, by survey wave
preserve
    keep scuid wave rim_4_original qmv??_scen?_?
    reshape long qmv31_scen1_ qmv31_scen2_ qmv31_scen3_ qmv31_scen4_ qmv32_scen1_ qmv32_scen2_ qmv32_scen3_ qmv32_scen4_ qmv33_scen1_ qmv33_scen2_ qmv33_scen3_ qmv33_scen4_ qmv34_scen1_ qmv34_scen2_ qmv34_scen3_ qmv34_scen4_ qmv35_scen1_ qmv35_scen2_ qmv35_scen3_ qmv35_scen4_ qmv36_scen1_ qmv36_scen2_ qmv36_scen3_ qmv36_scen4_ qmv41_scen1_ qmv41_scen2_ qmv41_scen3_ qmv41_scen4_ qmv42_scen1_ qmv42_scen2_ qmv42_scen3_ qmv42_scen4_ qmv43_scen1_ qmv43_scen2_ qmv43_scen3_ qmv43_scen4_ qmv44_scen1_ qmv44_scen2_ qmv44_scen3_ qmv44_scen4_ qmv45_scen1_ qmv45_scen2_ qmv45_scen3_ qmv45_scen4_ qmv46_scen1_ qmv46_scen2_ qmv46_scen3_ qmv46_scen4_ , i(scuid wave) j(alt) string
    foreach x of varlist qmv??_scen?_ {
        local newname = substr("`x'",1,length("`x'")-1)
        ren `x' `newname'
    }
    reshape long qmv31_scen qmv32_scen qmv33_scen qmv34_scen qmv35_scen qmv36_scen qmv41_scen qmv42_scen qmv43_scen qmv44_scen qmv45_scen qmv46_scen, i(scuid wave alt) j(scen)
    foreach x of varlist qmv??_scen {
        local newname = substr("`x'",1,length("`x'")-5)
        ren `x' `newname'
    }
    reshape long qmv, i(scuid wave alt scen) j(blk)
    ren qmv p
    generat alternative = .
    replace alternative = 1 if alt=="a"
    replace alternative = 2 if alt=="b"
    replace alternative = 3 if alt=="c"
    save ${datapath}long_panel_SepDec, replace

    /*
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
    */
restore


tempfile grouper
preserve
    * temp variables to create groups
    generat tempbigh = inrange(qmv1a_1,1500.00001,.)
    generat tempold = agenew>=50
    generat pmoveterc = .
    replace pmoveterc = 1 if inrange(qmv7_1,0,2)
    replace pmoveterc = 2 if inrange(qmv7_1,2.0000001,32.9999999)
    replace pmoveterc = 3 if inrange(qmv7_1,33,.)
    generat censusreg = .
    replace censusreg = 1 if regNE==1
    replace censusreg = 2 if regMW==1
    replace censusreg = 3 if regS ==1
    replace censusreg = 4 if regW ==1

    * create groups at varying levels of aggregation
    * first pass
    egen g0 = group(female grad4yr qmv12 ownhome married tempold)
    egen groupsize = count(scuid), by(g0)
    gen drilldown = groupsize>10
    * second pass
    egen gsmall = group(female grad4yr qmv12 ownhome tempold) if drilldown==0
    egen gbig   = group(female grad4yr qmv12 ownhome married tempold censusreg) if drilldown==1
    replace gsmall = 300+gsmall
    * make one group with two different levels of detail
    generat gg = .
    replace gg = gsmall if drilldown==0
    replace gg = gbig   if drilldown==1

    * hand edits to make it so each group has at least two people:
    recode gg (12 = 13) (90 = 91) (120 = 121) (131 = 132) (136 = 137) (138 = 139) (177/180 = 180) (199 = 200)

    * look at output
    egen ggsize = count(scuid), by(gg)
    sort gg
    l gg female grad4yr qmv12 ownhome married tempold censusreg drilldown ggsize scuid if ggsize<5, sepby(gg)
    sum ggsize, d

    * drop missing groupid
    drop if mi(gg)

    * renumber groups in ascending order
    egen prefgroup = group(gg)
    egen pgsize = count(scuid), by(prefgroup)
    keep prefgroup scuid pgsize

    * save groups to merge in with main data
    save `grouper', replace
    codebook prefgroup
    tab prefgroup, mi
restore

merge m:1 scuid using `grouper', keep(match master) nogen

egen id = group(scuid)
tab wave
tempfile incomedata
preserve
    collapse mincome=hhincome id, by(scuid)
    save `incomedata', replace
restore
tempfile groupincomedata
preserve
    collapse mincome=hhincome, by(prefgroup)
    save `groupincomedata', replace
restore
tempfile maindata
save `maindata', replace

* check balance in demographics across waves
tab wave health, mi row nofreq
tab wave female, mi row nofreq
tab wave grad4yr, mi row nofreq
tab wave qmv12, mi row nofreq
tab wave ownhome, mi row nofreq
tab wave married, mi row nofreq
*tab wave censusreg, mi
tab wave white, mi row nofreq
isid scuid wave

