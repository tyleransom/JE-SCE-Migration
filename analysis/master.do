clear all
version 14.1
set more off

global datapath "../RawData/"
global tablepath "../tables/"
global graphpath "../graphics/"
global temppath "../temp/"
global nreps 1000

*------------------------------------------------------------------------------
* Descriptives
*------------------------------------------------------------------------------
* Figure 1, Figure 2, Appendix Figure A1
include mobilityGraphs
    * dependencies: 
        * ${datapath}moveRates.csv (adapted from information at https://www.census.gov/data/tables/time-series/demo/geographic-mobility/historic.html)
    * outputs: (in graphics folder)
        * LongRunMigrationRates.eps

* Tables 3-4
include SCE_descriptives_Jan
    * dependencies: 
        * january data (${datapath}SCE_Jan_public.dta)
        * datacleaning_Jan.do
        * descriptives_Jan.do
    * outputs: (in tables folder)
        * ReasonsNotMove.tex
        * ReasonsToMove.tex

* Tables 1-2, Figure 6, Appendix Tables A1-A2 (scenarios per person for full sample and movers), Appendix Figure A2 (fraction of scenarios always stay), Appendix Tables A3-A4 (who are the never-movers)
include SCE_descriptives_SepDec
    * dependencies: 
        * september data (${datapath}SCE_Sep_public.dta)
        * december data (${datapath}SCE_Dec_public.dta)
        * unique IDs (${datapath}UniqueIDsSepDec.dta)
        * datacleaning_SepDec.do
        * descriptives_SepDec.do
        * ${datapath}UniqueIDsSepDec.dta (list of individual identifiers to be used in later estimation)
        * ACS data (${datapath}ACS/acs2017.dta.gz)
        * literacy/numeracy questions (${datapath}model_output_ids_merged_with_core_data.dta)
    * outputs: (in tables or graphics folder)
        * graphics
            * p*Sep.eps, p*Dec.eps, etc. (histograms of choice probabilities)
            * nm*.eps (histograms of percent of scenarios where pr move = 0)
        * tables
            * DistnScenPerPerson*.tex (Scenarios per person for full sample and ever-movers)
            * SampleDescriptivesSepDec.tex (compare SCE and ACS)
            * RootedDescriptivesSepDec.tex (who are mobile/stuck/rooted?)
            * NeverMoverDescriptiveTable.tex (mean differences between ever- and never-movers)
            * WhoAreNeverMovers.tex (LPM of never-mover on demographics, numeracy, literacy, etc.)

*------------------------------------------------------------------------------
* Estimation by mobile/stuck/rooted status
*------------------------------------------------------------------------------
* Tables 5-7 --- exclude never-movers and those with zero variation in p
include SCE_mobility_refb_full_intvws_noSepC4_p01_SepDec_noP0_samecity
    * dependencies: 
        * september data (${datapath}SCE_Sep_public.dta)
        * december data (${datapath}SCE_Dec_public.dta)
        * datacleaning_SepDec.do
        * createchoicedata_p2_0_1_samecity_SepDec.do
        * groupestimation_samecity_inclDec_newWTP_bswtp.do
    * outputs: (in tables folder)
        * model2EstRefBFullIntvwsNoSepC4p01SepDecNoP0SameCitybswtp.tex
        * model2WTPincomeRefBFullIntvwsNoSepC4p01SepDecNoP0SameCitybswtp.tex
        * model2WTPincomePctRefBFullIntvwsNoSepC4p01SepDecNoP0SameCitybswtp.tex

* Appendix table that includes multinomial logit and rank-ordered logit WTPs:
include SCE_mobility_refb_full_intvws_noSepC4_mlrologit_SepDec_noP0_samecity
    * dependencies: 
        * september data (${datapath}SCE_Sep_public.dta)
        * december data (${datapath}SCE_Dec_public.dta)
        * datacleaning_SepDec.do
        * createchoicedata_mlogit_samecity_SepDec.do
        * groupestimation_mlrologit_samecity_inclDec_newWTP
    * outputs: (in tables folder)
        * model2WTPincomePctRefBFullIntvwsNoSepC4MLROLSepDecNP0SameCity.tex

include SCE_mobility_refb_full_intvws_noSepC4_p01_SepDec_samecity
    * dependencies: 
        * september data (${datapath}SCE_Sep_public.dta)
        * december data (${datapath}SCE_Dec_public.dta)
        * datacleaning_SepDec.do
        * createchoicedata_p2_0_1_samecity_SepDec.do
        * groupestimation_samecity_inclDec_newWTP_bswtp.do
    * outputs: (in tables folder)
        * model2EstRefBFullIntvwsNoSepC4p01SepDecSameCitybswtp.tex
        * model2WTPincomeRefBFullIntvwsNoSepC4p01SepDecSameCitybswtp.tex
        * model2WTPincomePctRefBFullIntvwsNoSepC4p01SepDecSameCitybswtp.tex


*------------------------------------------------------------------------------
* Estimation at individual level
*------------------------------------------------------------------------------
* Fig 7 --- exclude never-movers and those with zero variation in p
*include SCE_mobility_refb_full_intvws_noSepC4_p01_SepDec_OLSindiv
include SCE_mobility_refb_full_intvws_noSepC4_p01_SepDec_indiv
    * dependencies: 
        * september data (${datapath}SCE_Sep_public.dta)
        * december data (${datapath}SCE_Dec_public.dta)
        * datacleaning_SepDec.do
        * createchoicedata_p2_0_1_samecity_SepDec.do
        * indivestimation_inclDec.do
    * outputs: (in temp folder)
        * ${temppath}individual_level_neighborhood_refb_full_intvws_no_sepC4_p01_SepDec_indiv.dta (individual-level estimates)

*------------------------------------------------------------------------------
* Preference heterogeneity analysis
*------------------------------------------------------------------------------
include lookAtIndivWTPs
    * dependencies: (these are all data sets)
        * ${temppath}alldata_refb_full_intvws_noSepC4_p01_SepDec_samecity (cleaned data from estimation including never-movers)
        * ${temppath}individual_level_neighborhood_refb_full_intvws_no_sepC4_p01_SepDec_indiv.dta (individual-level estimates)
        * literacy/numeracy questions (${datapath}model_output_ids_merged_with_core_data.dta)
    * outputs: (figures and tables)
        * graphics
            * histo_*.eps (histograms of WTP for each attribute)
        * tables
            * WhoAreZeroUndefInc.tex (LPM of zero or undefined income coefficient on individual characteristics)
            * BadBetaIncDescriptiveTable.tex (difference in means between those having valid and invalid income coeffs)
            * Sorting1.tex (comparison of WTP by level of attribute already chosen)
            * WTPdemogs1.tex (comparison of WTP by demographic characteristics)
            * MChet.tex (heterogeneity in moving costs by moving state variables)

*------------------------------------------------------------------------------
* Do actual choices relate to stated choices?
*------------------------------------------------------------------------------
include prepare_data_for_binscatters
    * dependencies: (these are all data sets)
        * ${datapath}sce_fullpanel_mobility.dta (data about mobility and mobility expectations from the entirety of the SCE panel)
        * ${datapath}dec19_experiment_respondents_move_prob.dta (data from the December 2019 experimental respondents with their most recent core data on mobility expectations merged in)
        * ${temppath}individual_level_neighborhood_refb_full_intvws_no_sepC4_p01_SepDec_indiv.dta (individual-level estimates)
    * outputs:
        * ${temppath}model_output.dta
        * ${temppath}sept_respondents_with_model_estimates

include make_binscatters
    * dependencies: (these are all data sets)
        * ${datapath}sce_fullpanel_mobility.dta (data about mobility and mobility expectations from the entirety of the SCE panel)
        * ${datapath}dec19_experiment_respondents_move_prob.dta (data from the December 2019 experimental respondents with their most recent core data on mobility expectations merged in)
        * ${temppath}individual_level_neighborhood_refb_full_intvws_no_sepC4_p01_SepDec_indiv.dta (individual-level estimates)
        * ${temppath}model_output.dta
        * ${temppath}sept_respondents_with_model_estimates
    * outputs: (graphics)
        * ${graphpath}mobility_expectations_actual_mobility_fullcore.eps
        * ${graphpath}mobility_expectations_actual_mobility_sept.eps
        * ${graphpath}mobility_expectations_wtp.eps

*------------------------------------------------------------------------------
* Robustness checks
*------------------------------------------------------------------------------
* question response time and response quality
include SCE_mobility_refb_full_intvws_noSepC4_p01_SepDec_noP0_samecity_cumscen
    * dependencies:
        * December data
    * outputs: (in tables folder)
        * QtimeQreg.tex

* run estimates separately for the employed and non-employed 
include SCE_mobility_refb_full_intvws_noSepC4_p01_SepDec_noP0_samecity_ENE
    * dependencies:
        * ${temppath}alldata_refb_full_intvws_noSepC4_p01_SepDec_noP0_samecity (data created in main group-level estimation file above)
        * groupestimation_samecity_inclDec_newWTP_ENE_bswtp.do
    * outputs: (in tables folder)
        * model2EstRefBFullIntvwsNoSepC4p01SepDecSameCityENEbswtp.tex
        * model2WTPincomeRefBFullIntvwsNoSepC4p01SepDecSameCityENEbswtp.tex
        * model2WTPincomePctRefBFullIntvwsNoSepC4p01SepDecSameCityENEbswtp.tex

capture log close
