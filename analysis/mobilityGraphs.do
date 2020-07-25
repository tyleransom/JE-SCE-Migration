clear all
version 14.1
set more off
capture log close

log using "mobilityGraphs.log", replace

*migration rates by distance, 1948--2018
insheet using ${datapath}moveRates.csv, comma clear case
set obs `=_N+4'
replace year = 1972 in `=_N'
replace year = 1973 in `=_N-1'
replace year = 1974 in `=_N-2'
replace year = 1975 in `=_N-3'
replace type = "total" in `=_N'
replace type = "total" in `=_N-1'
replace type = "total" in `=_N-2'
replace type = "total" in `=_N-3'
fillin type year
drop _fillin
egen typegroup = group(type)
format year %ty
xtset typegroup year
lab var year "Year"

twoway (line rate year if type=="total"                       , cmissing(y) lpattern(_)     lcolor(black) ) ///
       (line rate year if type=="same county"                 , cmissing(y) lpattern(.)     lcolor(black) ) ///
       (line rate year if type=="different county"            , cmissing(y) lpattern(-)     lcolor(black) ) ///
       (line rate year if type=="different county same state" , cmissing(y) lpattern("-.-") lcolor(black) ) ///
       (line rate year if type=="different state"             , cmissing(y) lpattern("_._") lcolor(black) ), ///
       legend(label(1 "Total") label(2 "Same County") label(3 "Diff County") label(4 "Diff County, Same State") label(5 "Diff County, Diff State") cols(2)) ytitle("Annual Migration Rate (%)") xscale(range(1945(5)2020)) graphregion(color(white))
graph export ${graphpath}LongRunMigrationRates.eps, replace

log close

