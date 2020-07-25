
preserve

use ${temppath}alldata_refb_full_intvws_noSepC4_p01_SepDec_noP0_samecity, clear
xtset scuid 
egen indivscen = group(scuid svyblk scennum)

*set seed 1001
*bootstrap, cluster(scuid) reps(${nreps}): qreg ratio `scenarios'
*est sto all
set seed 1001
bootstrap homecost_wtp = (-(exp(-_b[homecost]/_b[income]*ln( 1.2 ))-1)*100) crime_wtp = (-(exp(-_b[crime]/_b[income]*ln( 2 ))-1)*100) dist_wtp = (-(exp(-_b[dist]/_b[income])-1)*100) family_wtp = (-(exp(-_b[family]/_b[income])-1)*100) size_wtp = (-(exp(-_b[size]/_b[income])-1)*100) mvcost_wtp = (-(exp(-_b[mvcost]/_b[income]*5)-1)*100) taxes_wtp = (-(exp(-_b[taxes]/_b[income]*5)-1)*100) norms_wtp = (-(exp(-_b[norms]/_b[income])-1)*100) schqual_wtp = (-(exp(-_b[schqual]/_b[income])-1)*100) withincity_wtp = (-(exp(-_b[withincitymove]/_b[income])-1)*100) copyhome_wtp = (-(exp(-_b[copyhome]/_b[income])-1)*100) moved_wtp = (-(exp(-_b[moved]/_b[income])-1)*100), cluster(scuid) reps(${nreps}): qreg ratio `scenarios'
qui distinct scuid if e(sample)
local N_unique = `r(ndistinct)'
qui distinct indivscen if e(sample)
local N_scen = `r(ndistinct)'
qui outreg2 using ${tablepath}model2WTPincomePct${Suffix}.tex, replace  se bdec(2) sdec(2) tex(frag) ctitle("Baseline") addstat("Individual-Scenarios",`N_scen',"Individuals",`N_unique')


restore

xtset scuid

preserve

egen indivscen = group(scuid svyblk scennum)

asclogit chosen `scenarios', case(caseid) alternatives(altnum) basealt(2) nocons vce(cluster scuid)
nlcom (homecost_wtp: (-(exp(-_b[homecost]/_b[income]*ln( 1.2 ))-1)*100)) (crime_wtp: (-(exp(-_b[crime]/_b[income]*ln( 2 ))-1)*100)) (dist_wtp: (-(exp(-_b[dist]/_b[income])-1)*100)) (family_wtp: (-(exp(-_b[family]/_b[income])-1)*100)) (size_wtp: (-(exp(-_b[size]/_b[income])-1)*100)) (mvcost_wtp: (-(exp(-_b[mvcost]/_b[income]*5)-1)*100)) (taxes_wtp: (-(exp(-_b[taxes]/_b[income]*5)-1)*100)) (norms_wtp: (-(exp(-_b[norms]/_b[income])-1)*100)) (schqual_wtp: (-(exp(-_b[schqual]/_b[income])-1)*100)) (withincity_wtp: (-(exp(-_b[withincitymove]/_b[income])-1)*100)) (copyhome_wtp: (-(exp(-_b[copyhome]/_b[income])-1)*100)) (moved_wtp: (-(exp(-_b[moved]/_b[income])-1)*100)), post iterate(1000)
qui distinct scuid if e(sample)
local N_unique = `r(ndistinct)'
qui distinct indivscen if e(sample)
local N_scen = `r(ndistinct)'
qui outreg2 using ${tablepath}model2WTPincomePct${Suffix}.tex, append se bdec(2) sdec(2) tex(frag) ctitle("Multinomial Logit") addstat("Individual-Scenarios",`N_scen',"Individuals",`N_unique')


rologit choicerank `scenarios', group(caseid) vce(cluster scuid)
nlcom (homecost_wtp: (-(exp(-_b[homecost]/_b[income]*ln( 1.2 ))-1)*100)) (crime_wtp: (-(exp(-_b[crime]/_b[income]*ln( 2 ))-1)*100)) (dist_wtp: (-(exp(-_b[dist]/_b[income])-1)*100)) (family_wtp: (-(exp(-_b[family]/_b[income])-1)*100)) (size_wtp: (-(exp(-_b[size]/_b[income])-1)*100)) (mvcost_wtp: (-(exp(-_b[mvcost]/_b[income]*5)-1)*100)) (taxes_wtp: (-(exp(-_b[taxes]/_b[income]*5)-1)*100)) (norms_wtp: (-(exp(-_b[norms]/_b[income])-1)*100)) (schqual_wtp: (-(exp(-_b[schqual]/_b[income])-1)*100)) (withincity_wtp: (-(exp(-_b[withincitymove]/_b[income])-1)*100)) (copyhome_wtp: (-(exp(-_b[copyhome]/_b[income])-1)*100)) (moved_wtp: (-(exp(-_b[moved]/_b[income])-1)*100)), post iterate(1000)
qui distinct scuid if e(sample)
local N_unique = `r(ndistinct)'
qui distinct indivscen if e(sample)
local N_scen = `r(ndistinct)'
qui outreg2 using ${tablepath}model2WTPincomePct${Suffix}.tex, append se bdec(2) sdec(2) tex(frag) ctitle("Rank-Ordered Logit") addstat("Individual-Scenarios",`N_scen',"Individuals",`N_unique')


restore

******* Clean up tex files
* change VARIABLES notation (default for outreg2)
!sed -i "s|VARIABLES|Characteristic|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"
!sed -i "s|income|Income|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"
!sed -i "s|homecost\\\_wtp|Housing costs|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"
!sed -i "s|crime\\\_wtp|Crime|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"
!sed -i "s|dist\\\_wtp|Distance|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"
!sed -i "s|family\\\_wtp|Family nearby|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"
!sed -i "s|size\\\_wtp|House square footage|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"
!sed -i "s|mvcost\\\_wtp|Financial moving costs|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"
!sed -i "s|taxes\\\_wtp|Taxes|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"
!sed -i "s|norms\\\_wtp|Local cultural norms|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"
!sed -i "s|copyhome\\\_wtp|Exact copy of current home|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"
!sed -i "s|schqual\\\_wtp|Local school quality|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"
!sed -i "s|withincity\\\_wtp|Move within school district|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"
!sed -i "s|moved\\\_wtp|Nonpecuniary moving costs|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"

* remove rows that talk about statistical significance or standard errors
!sed -i '/multicolumn/d' ${tablepath}model2WTPincomePct${Suffix}.tex

