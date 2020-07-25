clear all
version 14.1
set more off
capture log close

log using "SCE_descriptives_Jan.log", replace

use "${datapath}SCE_Jan_public", clear

*------------------------------------------------------------------------------
* Data cleaning
*------------------------------------------------------------------------------
include datacleaning_Jan

*------------------------------------------------------------------------------
* Compute descriptives
*------------------------------------------------------------------------------
include descriptives_Jan

log close


