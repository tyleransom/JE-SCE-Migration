# SCEmigration

To replicate all results, simply run the file `analysis/master.do`. Details below: 

## Detailed steps for replication:

### 0. De-identify data for public use
 * code: `RawData/reduce_{Jan,Sep,Dec}.do`
 * dependencies:
    * Raw data files for January (`${datapath}1.1.12.3 SCE_January_data_updated_2.csv`), September (`${datapath}SCE_September_data.csv`) and December (`${datapath}mobility_201912fielding_coremerge.txt`)
     * data on locational attributes (`17zpallagi.csv.gz` [tax rates], `analytic_data2019.csv` [crime rates], and `medHomeValPerSqFt.csv` [home values per sq ft])
 * outputs (in RawData folder)
     * `SCE_{Jan,Sep,Dec}_public.dta`

### 1. Create mobility graphs.
 * code: `analysis/mobilityGraphs.do`
 * dependencies: 
     * `${datapath}moveRates.csv` (adapted from information at https://www.census.gov/data/tables/time-series/demo/geographic-mobility/historic.html)
     * `${datapath}moveReasons.csv` (adapted from information at https://www.census.gov/data/tables/time-series/demo/geographic-mobility/historic.html)
     * `${datapath}moveReasonsDetailed.csv` (adapted from information at https://www.census.gov/data/tables/time-series/demo/geographic-mobility/historic.html)
 * outputs: (in graphics folder)
     * `LongRunMigrationRates.eps`
     * `ReasonForMoving.eps`
     * `ReasonForMovingDetailedFamilyJob.eps`
     * `ReasonForMovingDetailedHousing.eps`

### 2. Create descriptive results reported in Tables 3-4
 * code: `SCE_descriptives_Jan.do`
 * dependencies: 
     * January data file (`${datapath}SCE_Jan_public.dta`)
     * `datacleaning_Jan.do`
     * `descriptives_Jan.do`
 * outputs: (in tables folder)
     * `ReasonsNotMove.tex`
     * `ReasonsToMove.tex`

### 3. Create descriptive tables and figures comparing SCE with ACS, as well as information on SCE samples
 * Tables 1-2, Figure 6, Appendix Tables A1-A2 (scenarios per person for full sample and movers), Appendix Figure A2 (fraction of scenarios always stay), Appendix Tables A3-A4 (who are the never-movers)

 * code: `SCE_descriptives_SepDec.do`
 * dependencies: 
     * September data (`${datapath}SCE_Sep_public.dta`)
     * December data (`${datapath}SCE_Dec_public.dta`)
     * unique IDs (`${datapath}UniqueIDsSepDec.dta`)
     * `datacleaning_SepDec.do`
     * `descriptives_SepDec.do`
     * `${datapath}UniqueIDsSepDec.dta` (list of individual identifiers to be used in later estimation)
     * ACS data (`${datapath}ACS/acs2017.dta.gz`)
     * literacy/numeracy questions (`${datapath}model_output_ids_merged_with_core_data.dta`)
 * outputs: (in tables or graphics folder)
     * graphics
         * `p*Sep.eps`, `p*Dec.eps`, etc. (histograms of choice probabilities)
         * `nm*.eps` (histograms of percent of scenarios where pr move = 0)
     * tables
         * `DistnScenPerPerson*.tex` (Scenarios per person for full sample and ever-movers)
         * `SampleDescriptivesSepDec.tex` (compare SCE and ACS)
         * `RootedDescriptivesSepDec.tex` (who are mobile/stuck/rooted?)
         * `NeverMoverDescriptiveTable.tex` (mean differences between ever- and never-movers)
         * `WhoAreNeverMovers.tex` (LPM of never-mover on demographics, numeracy, literacy, etc.)

### 4. Population-level estimates (Tables 5-7)
 * code: `SCE_mobility_refb_full_intvws_noSepC4_p01_SepDec_noP0_samecity.do`
 * dependencies: 
     * September data (`${datapath}SCE_Sep_public.dta`)
     * December data (`${datapath}SCE_Dec_public.dta`)
     * `datacleaning_SepDec.do`
     * `createchoicedata_p2_0_1_samecity_SepDec.do`
     * `groupestimation_samecity_inclDec_newWTP_bswtp.do`
 * outputs: (in tables folder)
     * model2EstRefBFullIntvwsNoSepC4p01SepDecNoP0SameCitybswtp.tex
     * model2WTPincomeRefBFullIntvwsNoSepC4p01SepDecNoP0SameCitybswtp.tex
     * model2WTPincomePctRefBFullIntvwsNoSepC4p01SepDecNoP0SameCitybswtp.tex

### 5. Create Appendix Table A7 which includes multinomial logit and rank-ordered logit WTPs:
 * code for 2nd and 3rd columns: `SCE_mobility_refb_full_intvws_noSepC4_mlrologit_SepDec_noP0_samecity.do`
 * dependencies: 
     * September data (`${datapath}SCE_Sep_public.dta`)
     * December data (`${datapath}SCE_Dec_public.dta`)
     * `datacleaning_SepDec.do`
     * `createchoicedata_mlogit_samecity_SepDec.do`
     * `groupestimation_mlrologit_samecity_inclDec_newWTP.do`
 * outputs: (in tables folder)
     * `model2WTPincomePctRefBFullIntvwsNoSepC4MLROLSepDecNP0SameCity.tex`

 * code for 1st column: `include SCE_mobility_refb_full_intvws_noSepC4_p01_SepDec_samecity.do`
 * dependencies: 
     * September data (`${datapath}SCE_Sep_public.dta`)
     * December data (`${datapath}SCE_Dec_public.dta`)
     * `datacleaning_SepDec.do`
     * `createchoicedata_p2_0_1_samecity_SepDec.do`
     * `groupestimation_samecity_inclDec_newWTP_bswtp.do`
 * outputs: (in tables folder)
     * `model2EstRefBFullIntvwsNoSepC4p01SepDecSameCitybswtp.tex`
     * `model2WTPincomeRefBFullIntvwsNoSepC4p01SepDecSameCitybswtp.tex`
     * `model2WTPincomePctRefBFullIntvwsNoSepC4p01SepDecSameCitybswtp.tex`

### 6. Individual-level estimation (not depicted in any exhibit in the paper)
 * code: `SCE_mobility_refb_full_intvws_noSepC4_p01_SepDec_indiv.do`
 * dependencies: 
     * September data (`${datapath}SCE_Sep_public.dta`)
     * December data (`${datapath}SCE_Dec_public.dta`)
     * `datacleaning_SepDec.do`
     * `createchoicedata_p2_0_1_samecity_SepDec.do`
     * `indivestimation_inclDec.do`
 * outputs: (in temp folder)
     * `${temppath}individual_level_neighborhood_refb_full_intvws_no_sepC4_p01_SepDec_indiv.dta` (individual-level estimates)

### 7. Preference heterogeneity analysis
 * code: `lookAtIndivWTPs.do`
 * dependencies: (these are all data sets)
     * `${temppath}alldata_refb_full_intvws_noSepC4_p01_SepDec_samecity` (cleaned data from estimation including never-movers)
     * `${temppath}individual_level_neighborhood_refb_full_intvws_no_sepC4_p01_SepDec_indiv.dta` (individual-level estimates)
     * literacy/numeracy questions (`${datapath}model_output_ids_merged_with_core_data.dta`)
 * outputs: (figures and tables)
     * graphics
         * `histo_*.eps` (histograms of WTP for each attribute)
     * tables
         * `WhoAreZeroUndefInc.tex` (LPM of zero or undefined income coefficient on individual characteristics)
         * `BadBetaIncDescriptiveTable.tex` (difference in means between those having valid and invalid income coeffs)
         * `Sorting1.tex` (comparison of WTP by level of attribute already chosen)
         * `WTPdemogs1.tex` (comparison of WTP by demographic characteristics)
         * `MChet.tex` (heterogeneity in moving costs by moving state variables)

### 8. Analysis of relationship between stated and actual choices
 * code: `prepare_data_for_binscatters.do`
 * dependencies: (these are all data sets)
     * `${datapath}sce_fullpanel_mobility.dta` (data about mobility and mobility expectations from the entirety of the SCE panel)
     * `${datapath}dec19_experiment_respondents_move_prob.dta` (data from the December 2019 experimental respondents with their most recent core data on mobility expectations merged in)
     * `${temppath}individual_level_neighborhood_refb_full_intvws_no_sepC4_p01_SepDec_indiv.dta` (individual-level estimates)
 * outputs (also data sets):
     * `${temppath}model_output.dta`
     * `${temppath}sept_respondents_with_model_estimates.dta`

 * doe: `make_binscatters.do`
 * dependencies: (these are all data sets)
     * `${datapath}sce_fullpanel_mobility.dta` (data about mobility and mobility expectations from the entirety of the SCE panel)
     * `${datapath}dec19_experiment_respondents_move_prob.dta` (data from the December 2019 experimental respondents with their most recent core data on mobility expectations merged in)
     * `${temppath}individual_level_neighborhood_refb_full_intvws_no_sepC4_p01_SepDec_indiv.dta` (individual-level estimates)
     * `${temppath}model_output.dta`
     * `${temppath}sept_respondents_with_model_estimates.dta`
 * outputs: (graphics)
     * `${graphpath}mobility_expectations_actual_mobility_fullcore.eps`
     * `${graphpath}mobility_expectations_actual_mobility_sept.eps`
     * `${graphpath}mobility_expectations_wtp.eps`

### 9. Robustness checks
 * __Question response time and response quality__
 * code: `SCE_mobility_refb_full_intvws_noSepC4_p01_SepDec_noP0_samecity_cumscen.do`
 * dependencies:
     * December data
 * outputs: (in tables folder)
     * `QtimeQreg.tex`

 * __Estimates separately for the employed and non-employed__
 * code: `include SCE_mobility_refb_full_intvws_noSepC4_p01_SepDec_noP0_samecity_ENE.do`
 * dependencies:
     * `${temppath}alldata_refb_full_intvws_noSepC4_p01_SepDec_noP0_samecity.dta` (data created in main group-level estimation file above)
     * `groupestimation_samecity_inclDec_newWTP_ENE_bswtp.do`
 * outputs: (in tables folder)
     * `model2EstRefBFullIntvwsNoSepC4p01SepDecSameCityENEbswtp.tex`
     * `model2WTPincomeRefBFullIntvwsNoSepC4p01SepDecSameCityENEbswtp.tex`
     * `model2WTPincomePctRefBFullIntvwsNoSepC4p01SepDecSameCityENEbswtp.tex`
