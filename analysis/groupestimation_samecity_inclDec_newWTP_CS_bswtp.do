
xtset scuid
preserve
* now estimate for various subpopulations

local  scenarios income homecost crime dist family size mvcost taxes norms schqual withincitymove copyhome moved
set seed 1001
bootstrap, cluster(scuid) reps(${nreps}): qreg ratio `scenarios'
est sto all
qui outreg2 using ${tablepath}model2Est${Suffix}.tex, replace  se bdec(3) sdec(3) tex(frag)

local  scenarios income homecost crime dist family size mvcost taxes norms schqual withincitymove copyhome moved cumscen c.moved#c.cumscen
set seed 1001
bootstrap, cluster(scuid) reps(${nreps}): qreg ratio `scenarios'
est sto cumulative
qui outreg2 using ${tablepath}model2Est${Suffix}.tex, append   se bdec(3) sdec(3) tex(frag)
set seed 1001
*bootstrap homecost_wtp = (-(exp(-_b[homecost]/_b[income]*ln( 1.2 ))-1)*${medinc}) crime_wtp = (-(exp(-_b[crime]/_b[income]*ln( 2 ))-1)*${medinc}) dist_wtp = (-(exp(-_b[dist]/_b[income])-1)*${medinc}) family_wtp = (-(exp(-_b[family]/_b[income])-1)*${medinc}) size_wtp = (-(exp(-_b[size]/_b[income])-1)*${medinc}) mvcost_wtp = (-(exp(-_b[mvcost]/_b[income]*5)-1)*${medinc}) taxes_wtp = (-(exp(-_b[taxes]/_b[income]*5)-1)*${medinc}) norms_wtp = (-(exp(-_b[norms]/_b[income])-1)*${medinc}) schqual_wtp = (-(exp(-_b[schqual]/_b[income])-1)*${medinc}) withincity_wtp = (-(exp(-_b[withincitymove]/_b[income])-1)*${medinc}) copyhome_wtp = (-(exp(-_b[copyhome]/_b[income])-1)*${medinc}) moved_wtp = (-(exp(-_b[moved]/_b[income])-1)*${medinc}), cluster(scuid) reps(${nreps}): qreg ratio `scenarios'
*qui outreg2 using ${tablepath}model2WTPincome${Suffix}.tex, replace  se bdec(0) sdec(0) tex(frag) ctitle("all") 
*set seed 1001
*bootstrap homecost_wtp = (-(exp(-_b[homecost]/_b[income]*ln( 1.2 ))-1)*100) crime_wtp = (-(exp(-_b[crime]/_b[income]*ln( 2 ))-1)*100) dist_wtp = (-(exp(-_b[dist]/_b[income])-1)*100) family_wtp = (-(exp(-_b[family]/_b[income])-1)*100) size_wtp = (-(exp(-_b[size]/_b[income])-1)*100) mvcost_wtp = (-(exp(-_b[mvcost]/_b[income]*5)-1)*100) taxes_wtp = (-(exp(-_b[taxes]/_b[income]*5)-1)*100) norms_wtp = (-(exp(-_b[norms]/_b[income])-1)*100) schqual_wtp = (-(exp(-_b[schqual]/_b[income])-1)*100) withincity_wtp = (-(exp(-_b[withincitymove]/_b[income])-1)*100) copyhome_wtp = (-(exp(-_b[copyhome]/_b[income])-1)*100) moved_wtp = (-(exp(-_b[moved]/_b[income])-1)*100), cluster(scuid) reps(${nreps}): qreg ratio `scenarios'
*qui outreg2 using ${tablepath}model2WTPincomePct${Suffix}.tex, replace  se bdec(2) sdec(2) tex(frag) ctitle("all") 

est table all cumulative , b(%9.3f) stats(N) star keep(`scenarios') title("Estimates of migration tastes across various subpopulations")
restore

******* Clean up tex files
* change VARIABLES notation (default for outreg2)
!sed -i "s|3\.altnum|Alternative 3 dummy|ig"   "${tablepath}model2Est${Suffix}.tex"
!sed -i "s|VARIABLES|Characteristic|ig" "${tablepath}model2Est${Suffix}.tex"
*!sed -i "s|VARIABLES|Characteristic|ig" "${tablepath}model2WTPincome${Suffix}.tex"
*!sed -i "s|VARIABLES|Characteristic|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"

!sed -i "s|income|Income|ig" "${tablepath}model2Est${Suffix}.tex"
*!sed -i "s|income|Income|ig" "${tablepath}model2WTPincome${Suffix}.tex"
*!sed -i "s|income|Income|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"

!sed -i "s|homecost|Housing costs|ig"     "${tablepath}model2Est${Suffix}.tex"
*!sed -i "s|homecost\\\_wtp|Housing costs|ig" "${tablepath}model2WTPincome${Suffix}.tex"
*!sed -i "s|homecost\\\_wtp|Housing costs|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"

!sed -i "s|crime|Crime|ig"     "${tablepath}model2Est${Suffix}.tex"
*!sed -i "s|crime\\\_wtp|Crime|ig" "${tablepath}model2WTPincome${Suffix}.tex"
*!sed -i "s|crime\\\_wtp|Crime|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"

!sed -i "s|dist|Distance|ig"     "${tablepath}model2Est${Suffix}.tex"
*!sed -i "s|dist\\\_wtp|Distance|ig" "${tablepath}model2WTPincome${Suffix}.tex"
*!sed -i "s|dist\\\_wtp|Distance|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"

!sed -i "s|family|Family nearby|ig"     "${tablepath}model2Est${Suffix}.tex"
*!sed -i "s|family\\\_wtp|Family nearby|ig" "${tablepath}model2WTPincome${Suffix}.tex"
*!sed -i "s|family\\\_wtp|Family nearby|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"

!sed -i "s|size|House square footage|ig"     "${tablepath}model2Est${Suffix}.tex"
*!sed -i "s|size\\\_wtp|House square footage|ig" "${tablepath}model2WTPincome${Suffix}.tex"
*!sed -i "s|size\\\_wtp|House square footage|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"

!sed -i "s|mvcost|Financial moving costs|ig"     "${tablepath}model2Est${Suffix}.tex"
*!sed -i "s|mvcost\\\_wtp|Financial moving costs|ig" "${tablepath}model2WTPincome${Suffix}.tex"
*!sed -i "s|mvcost\\\_wtp|Financial moving costs|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"

!sed -i "s|taxes|Taxes|ig"     "${tablepath}model2Est${Suffix}.tex"
*!sed -i "s|taxes\\\_wtp|Taxes|ig" "${tablepath}model2WTPincome${Suffix}.tex"
*!sed -i "s|taxes\\\_wtp|Taxes|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"

!sed -i "s|norms|Local cultural norms|ig"     "${tablepath}model2Est${Suffix}.tex"
*!sed -i "s|norms\\\_wtp|Local cultural norms|ig" "${tablepath}model2WTPincome${Suffix}.tex"
*!sed -i "s|norms\\\_wtp|Local cultural norms|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"

!sed -i "s|copyhome|Exact copy of current home|ig"     "${tablepath}model2Est${Suffix}.tex"
*!sed -i "s|copyhome\\\_wtp|Exact copy of current home|ig" "${tablepath}model2WTPincome${Suffix}.tex"
*!sed -i "s|copyhome\\\_wtp|Exact copy of current home|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"

!sed -i "s|schqual|Local school quality|ig"     "${tablepath}model2Est${Suffix}.tex"
*!sed -i "s|schqual\\\_wtp|Local school quality|ig" "${tablepath}model2WTPincome${Suffix}.tex"
*!sed -i "s|schqual\\\_wtp|Local school quality|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"

!sed -i "s|withincitymove|Local move|ig"     "${tablepath}model2Est${Suffix}.tex"
*!sed -i "s|withincity\\\_wtp|Move within school district|ig" "${tablepath}model2WTPincome${Suffix}.tex"
*!sed -i "s|withincity\\\_wtp|Move within school district|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"

!sed -i "s|moved|Nonpecuniary moving costs|ig"     "${tablepath}model2Est${Suffix}.tex"
*!sed -i "s|moved\\\_wtp|Nonpecuniary moving costs|ig" "${tablepath}model2WTPincome${Suffix}.tex"
*!sed -i "s|moved\\\_wtp|Nonpecuniary moving costs|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"

!sed -i "s|c\.||ig"     "${tablepath}model2Est${Suffix}.tex"
!sed -i "s|\\\#| `=char(36)'\\\times`=char(36)' |ig"     "${tablepath}model2Est${Suffix}.tex"
*!sed -i "s|cumscen\\\_wtp|Nonpecuniary moving costs|ig" "${tablepath}model2WTPincome${Suffix}.tex"
*!sed -i "s|cumscen\\\_wtp|Nonpecuniary moving costs|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"

!sed -i "s|cumscen|Cumulative scenario|ig"     "${tablepath}model2Est${Suffix}.tex"
*!sed -i "s|cumscen\\\_wtp|Nonpecuniary moving costs|ig" "${tablepath}model2WTPincome${Suffix}.tex"
*!sed -i "s|cumscen\\\_wtp|Nonpecuniary moving costs|ig" "${tablepath}model2WTPincomePct${Suffix}.tex"


* remove rows that talk about statistical significance or standard errors
!sed -i '/multicolumn/d' ${tablepath}model2Est${Suffix}.tex
*!sed -i '/multicolumn/d' ${tablepath}model2WTPincome${Suffix}.tex
*!sed -i '/multicolumn/d' ${tablepath}model2WTPincomePct${Suffix}.tex

