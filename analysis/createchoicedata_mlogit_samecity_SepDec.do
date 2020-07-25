
* Initialize temporary files (for later use)

* September 2018 wave
tempfile m31a m31b m31c m31d m31e m31f m31g m31h m31i m31j m31k m31l m32a m32b m32c m32d m32e m32f m32g m32h m32i m32j m32k m32l ///
         m33a m33b m33c m33d m33e m33f m33g m33h m33i m33j m33k m33l m34a m34b m34c m34d m34e m34f m34g m34h m34i m34j m34k m34l ///
         m35a m35b m35c m35d m35e m35f m35g m35h m35i m35j m35k m35l m36a m36b m36c m36d m36e m36f m36g m36h m36i m36j m36k m36l 

* December 2019 wave
tempfile m41a m41b m41c m41d m41e m41f m41g m41h m41i m41j m41k m41l m42a m42b m42c m42d m42e m42f m42g m42h m42i m42j m42k m42l ///
         m43a m43b m43c m43d m43e m43f m43g m43h m43i m43j m43k m43l m44a m44b m44c m44d m44e m44f m44g m44h m44i m44j m44k m44l ///
         m45a m45b m45c m45d m45e m45f m45g m45h m45i m45j m45k m45l m46a m46b m46c m46d m46e m46f m46g m46h m46i m46j m46k m46l 

*------------------------------------------------------------------------------
* September 2018 wave
*------------------------------------------------------------------------------
use `maindata', clear
***************************
* CASE 1
***************************
* Scenario 1
gen     chosen = qmv31_scen1_a>qmv31_scen1_b & qmv31_scen1_a>qmv31_scen1_c
gen     pchoice = qmv31_scen1_a
gen     x1=0
gen     x2=ln( 1 )
gen     x3=ln( 1 )
gen     x4=0
gen     x5=0 
gen     x10="SepC1"
gen     x11=1
gen     x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob31a if sum31_scen1==100,  replace nolab

replace chosen = qmv31_scen1_b>qmv31_scen1_c & qmv31_scen1_b>qmv31_scen1_a
replace pchoice = qmv31_scen1_b
replace x1=500
replace x2=ln( 2 )
replace x3=ln( 1.2 )
replace x5=1
replace x10="SepC1"
replace x11=1
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob31b if sum31_scen1==100,  replace nolab

replace chosen = qmv31_scen1_c>qmv31_scen1_b & qmv31_scen1_c>qmv31_scen1_a
replace pchoice = qmv31_scen1_c
replace x1=1000
replace x2=ln( 0.5 )
replace x3=ln( 1.1 )
replace x5=1
replace x10="SepC1"
replace x11=1
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob31c if sum31_scen1==100,  replace nolab


* Scenario 2
replace chosen = qmv31_scen2_a>qmv31_scen2_b & qmv31_scen2_a>qmv31_scen2_c
replace pchoice = qmv31_scen2_a
replace x1=0
replace x2=ln( 1 ) //0
replace x3=ln( 1 )
replace x5=0
replace x10="SepC1"
replace x11=2
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob31d if sum31_scen2==100, replace nolab
 
replace chosen = qmv31_scen2_b>qmv31_scen2_c & qmv31_scen2_b>qmv31_scen2_a
replace pchoice = qmv31_scen2_b
replace x1=500
replace x2=ln( 1 ) //0
replace x3=ln( 1.05 )
replace x5=1
replace x10="SepC1"
replace x11=2
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob31e if sum31_scen2==100, replace nolab
 
replace chosen = qmv31_scen2_c>qmv31_scen2_b & qmv31_scen2_c>qmv31_scen2_a
replace pchoice = qmv31_scen2_c
replace x1=500
replace x2=ln( 0.5 )
replace x3=ln( 1 )
replace x5=1
replace x10="SepC1"
replace x11=2
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob31f if sum31_scen2==100,  replace nolab
  

* Scenario 3
replace chosen = qmv31_scen3_a>qmv31_scen3_b & qmv31_scen3_a>qmv31_scen3_c
replace pchoice = qmv31_scen3_a
replace x1=0
replace x2=ln( 1 )
replace x3=ln( 0.85 )
replace x5=0
replace x10="SepC1"
replace x11=3
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob31g if sum31_scen3==100,  replace nolab
 
replace chosen = qmv31_scen3_b>qmv31_scen3_c & qmv31_scen3_b>qmv31_scen3_a
replace pchoice = qmv31_scen3_b
replace x1=500
replace x2=ln( 0.5 )
replace x3=ln( 0.90 )
replace x5=1
replace x10="SepC1"
replace x11=3
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob31h if sum31_scen3==100,  replace nolab
 
replace chosen = qmv31_scen3_c>qmv31_scen3_b & qmv31_scen3_c>qmv31_scen3_a
replace pchoice = qmv31_scen3_c
replace x1=1000
replace x2=ln(2)
replace x3=ln( 1.05 )
replace x5=1
replace x10="SepC1"
replace x11=3
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob31i if sum31_scen3==100,  replace nolab
 

* Scenario 4
replace chosen = qmv31_scen4_a>qmv31_scen4_b & qmv31_scen4_a>qmv31_scen4_c
replace pchoice = qmv31_scen4_a
replace x1=0
replace x2=ln( 1 )
replace x3=ln( 0.8 )
replace x5=0
replace x10="SepC1"
replace x11=4
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob31j if sum31_scen4==100,  replace nolab

replace chosen = qmv31_scen4_b>qmv31_scen4_c & qmv31_scen4_b>qmv31_scen4_a
replace pchoice = qmv31_scen4_b
replace x1=500
replace x2=ln( 0.5 )
replace x3=ln( 1 )
replace x5=1
replace x10="SepC1"
replace x11=4
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob31k if sum31_scen4==100,  replace nolab

replace chosen = qmv31_scen4_c>qmv31_scen4_b & qmv31_scen4_c>qmv31_scen4_a
replace pchoice = qmv31_scen4_c
replace x1=1000
replace x2=ln( 0.5 ) //0
replace x3=ln( 1.05 )
replace x5=1
replace x10="SepC1"
replace x11=4
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob31l if sum31_scen4==100,  replace nolab


***************************
* CASE 2
***************************
* Scenario 1
replace chosen = qmv32_scen1_a>qmv32_scen1_b & qmv32_scen1_a>qmv32_scen1_c
replace pchoice = qmv32_scen1_a
replace x1=0
replace x2=0
replace x3=ln( 1 )
replace x5=0
replace x10="SepC2"
replace x11=1
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob32a if sum32_scen1==100,  replace nolab

replace chosen = qmv32_scen1_b>qmv32_scen1_c & qmv32_scen1_b>qmv32_scen1_a
replace pchoice = qmv32_scen1_b
replace x1=500
replace x2=10
replace x3=ln( 1.2 )
replace x5=1
replace x10="SepC2"
replace x11=1
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob32b if sum32_scen1==100,  replace nolab

replace chosen = qmv32_scen1_c>qmv32_scen1_b & qmv32_scen1_c>qmv32_scen1_a
replace pchoice = qmv32_scen1_c
replace x1=1000
replace x2=15
replace x3=ln( 1.2 ) //0
replace x5=1
replace x10="SepC2"
replace x11=1
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob32c if sum32_scen1==100,  replace nolab



* Scenario 2
replace chosen = qmv32_scen2_a>qmv32_scen2_b & qmv32_scen2_a>qmv32_scen2_c
replace pchoice = qmv32_scen2_a
replace x1=0
replace x2=0
replace x3=ln( 1 ) //0
replace x5=0
replace x10="SepC2"
replace x11=2
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob32d if sum32_scen2==100,  replace nolab

replace chosen = qmv32_scen2_b>qmv32_scen2_c & qmv32_scen2_b>qmv32_scen2_a
replace pchoice = qmv32_scen2_b
replace x1=500
replace x2=15
replace x3=ln( 1 ) //0
replace x5=1
replace x10="SepC2"
replace x11=2
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob32e if sum32_scen2==100,  replace nolab

replace chosen = qmv32_scen2_c>qmv32_scen2_b & qmv32_scen2_c>qmv32_scen2_a
replace pchoice = qmv32_scen2_c
replace x1=1000
replace x2=15
replace x3=ln( 1.1 )
replace x5=1
replace x10="SepC2"
replace x11=2
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob32f if sum32_scen2==100,  replace nolab
 

* Scenario 3
replace chosen = qmv32_scen3_a>qmv32_scen3_b & qmv32_scen3_a>qmv32_scen3_c
replace pchoice = qmv32_scen3_a
replace x1=0
replace x2=0
replace x3=ln( 1 )
replace x5=0
replace x10="SepC2"
replace x11=3
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob32g if sum32_scen3==100,  replace  nolab

replace chosen = qmv32_scen3_b>qmv32_scen3_c & qmv32_scen3_b>qmv32_scen3_a
replace pchoice = qmv32_scen3_b
replace x1=500
replace x2=15
replace x3=ln( 1.15 )
replace x5=1
replace x10="SepC2"
replace x11=3
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob32h if sum32_scen3==100,  replace  nolab

replace chosen = qmv32_scen3_c>qmv32_scen3_b & qmv32_scen3_c>qmv32_scen3_a
replace pchoice = qmv32_scen3_c
replace x1=300
replace x2=10
replace x3=ln( 1.05 )
replace x5=1
replace x10="SepC2"
replace x11=3
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob32i if sum32_scen3==100,  replace nolab


* Scenario 4
replace chosen = qmv32_scen4_a>qmv32_scen4_b & qmv32_scen4_a>qmv32_scen4_c
replace pchoice = qmv32_scen4_a
replace x1=0
replace x2=0
replace x3=ln( 1 )
replace x5=0
replace x10="SepC2"
replace x11=4
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob32j if sum32_scen4==100,  replace nolab

replace chosen = qmv32_scen4_b>qmv32_scen4_c & qmv32_scen4_b>qmv32_scen4_a
replace pchoice = qmv32_scen4_b
replace x1=500
replace x2=30
replace x3=ln( 1.3 )
replace x5=1
replace x10="SepC2"
replace x11=4
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob32k if sum32_scen4==100,  replace nolab

replace chosen = qmv32_scen4_c>qmv32_scen4_b & qmv32_scen4_c>qmv32_scen4_a
replace pchoice = qmv32_scen4_c
replace x1=1000
replace x2=10
replace x3=ln( 1.1 )
replace x5=1
replace x10="SepC2"
replace x11=4
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob32l if sum32_scen4==100,  replace  nolab



***************************
* CASE 3
***************************
* Scenario 1
replace chosen = qmv33_scen1_a>qmv33_scen1_b & qmv33_scen1_a>qmv33_scen1_c
replace pchoice = qmv33_scen1_a
replace x1=0
replace x2=0
replace x3=ln( 0.9 )
replace x5=0
replace x10="SepC3"
replace x11=1
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob33a if sum33_scen1==100,  replace nolab

replace chosen = qmv33_scen1_b>qmv33_scen1_c & qmv33_scen1_b>qmv33_scen1_a
replace pchoice = qmv33_scen1_b
replace x1=1000
replace x2=1
replace x3=ln( 1 )
replace x5=1
replace x10="SepC3"
replace x11=1
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob33b if sum33_scen1==100,  replace nolab

replace chosen = qmv33_scen1_c>qmv33_scen1_b & qmv33_scen1_c>qmv33_scen1_a
replace pchoice = qmv33_scen1_c
replace x1=1000
replace x2=0
replace x3=ln( 1.1 )
replace x5=1
replace x10="SepC3"
replace x11=1
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob33c if sum33_scen1==100,  replace nolab



* Scenario 2
replace chosen = qmv33_scen2_a>qmv33_scen2_b & qmv33_scen2_a>qmv33_scen2_c
replace pchoice = qmv33_scen2_a
replace x1=0
replace x2=1
replace x3=ln( 0.9 )
replace x5=0
replace x10="SepC3"
replace x11=2
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob33d if sum33_scen2==100,  replace nolab

replace chosen = qmv33_scen2_b>qmv33_scen2_c & qmv33_scen2_b>qmv33_scen2_a
replace pchoice = qmv33_scen2_b
replace x1=500
replace x2=1
replace x3=ln( 1.5 )
replace x5=1
replace x10="SepC3"
replace x11=2
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob33e if sum33_scen2==100,  replace nolab

replace chosen = qmv33_scen2_c>qmv33_scen2_b & qmv33_scen2_c>qmv33_scen2_a
replace pchoice = qmv33_scen2_c
replace x1=100
replace x2=0
replace x3=ln( 1.2 )
replace x5=1
replace x10="SepC3"
replace x11=2
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob33f if sum33_scen2==100,  replace nolab
 

* Scenario 3
replace chosen = qmv33_scen3_a>qmv33_scen3_b & qmv33_scen3_a>qmv33_scen3_c
replace pchoice = qmv33_scen3_a
replace x1=0
replace x2=0
replace x3=ln( 0.95 )
replace x5=0
replace x10="SepC3"
replace x11=3
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob33g if sum33_scen3==100,  replace  nolab

replace chosen = qmv33_scen3_b>qmv33_scen3_c & qmv33_scen3_b>qmv33_scen3_a
replace pchoice = qmv33_scen3_b
replace x1=250
replace x2=1
replace x3=ln( 1.1 )
replace x5=1
replace x10="SepC3"
replace x11=3
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob33h if sum33_scen3==100,  replace  nolab

replace chosen = qmv33_scen3_c>qmv33_scen3_b & qmv33_scen3_c>qmv33_scen3_a
replace pchoice = qmv33_scen3_c
replace x1=10
replace x2=1
replace x3=ln( 0.8 )
replace x5=1
replace x10="SepC3"
replace x11=3
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob33i if sum33_scen3==100,  replace nolab


* Scenario 4
replace chosen = qmv33_scen4_a>qmv33_scen4_b & qmv33_scen4_a>qmv33_scen4_c
replace pchoice = qmv33_scen4_a
replace x1=0
replace x2=1
replace x3=ln( 0.85 )
replace x5=0
replace x10="SepC3"
replace x11=4
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob33j if sum33_scen4==100,  replace nolab

replace chosen = qmv33_scen4_b>qmv33_scen4_c & qmv33_scen4_b>qmv33_scen4_a
replace pchoice = qmv33_scen4_b
replace x1=350
replace x2=1
replace x3=ln( 1 )
replace x5=1
replace x10="SepC3"
replace x11=4
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob33k if sum33_scen4==100,  replace nolab

replace chosen = qmv33_scen4_c>qmv33_scen4_b & qmv33_scen4_c>qmv33_scen4_a
replace pchoice = qmv33_scen4_c
replace x1=500
replace x2=0
replace x3=ln( 2 )
replace x5=1
replace x10="SepC3"
replace x11=4
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob33l if sum33_scen4==100,  replace  nolab



***************************
* CASE 4
***************************
* Scenario 1
replace chosen = qmv34_scen1_a>qmv34_scen1_b & qmv34_scen1_a>qmv34_scen1_c
replace pchoice = qmv34_scen1_a
replace x1=0
replace x2=0
replace x3=ln( 1 )
replace x4=ln( 1 )
replace x5=0
replace x10="SepC4"
replace x11=1
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob34a if sum34_scen1==100,  replace nolab

replace chosen = qmv34_scen1_b>qmv34_scen1_c & qmv34_scen1_b>qmv34_scen1_a
replace pchoice = qmv34_scen1_b
replace x1=500
replace x2=1
replace x3=ln( 0.9 )
replace x4=ln( 1.1 )
replace x5=1
replace x10="SepC4"
replace x11=1
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob34b if sum34_scen1==100,  replace nolab

replace chosen = qmv34_scen1_c>qmv34_scen1_b & qmv34_scen1_c>qmv34_scen1_a
replace pchoice = qmv34_scen1_c
replace x1=500
replace x2=0
replace x3=ln( 0.8 )
replace x4=ln( 1.1 ) //0
replace x5=1
replace x10="SepC4"
replace x11=1
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob34c if sum34_scen1==100,  replace nolab



* Scenario 2
replace chosen = qmv34_scen2_a>qmv34_scen2_b & qmv34_scen2_a>qmv34_scen2_c
replace pchoice = qmv34_scen2_a
replace x1=0
replace x2=0
replace x3=ln( 1 )
replace x4=ln( 1 )
replace x5=0
replace x10="SepC4"
replace x11=2
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob34d if sum34_scen2==100,  replace nolab

replace chosen = qmv34_scen2_b>qmv34_scen2_c & qmv34_scen2_b>qmv34_scen2_a
replace pchoice = qmv34_scen2_b
replace x1=500
replace x2=1
replace x3=ln( 0.9 )
replace x4=ln( 1.1 )
replace x5=1
replace x10="SepC4"
replace x11=2
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob34e if sum34_scen2==100,  replace nolab

replace chosen = qmv34_scen2_c>qmv34_scen2_b & qmv34_scen2_c>qmv34_scen2_a
replace pchoice = qmv34_scen2_c
replace x1=1000
replace x2=0
replace x3=ln( 1.3 )
replace x4=ln( 1.1 ) //0
replace x5=1
replace x10="SepC4"
replace x11=2
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob34f if sum34_scen2==100,  replace nolab
 

* Scenario 3
replace chosen = qmv34_scen3_a>qmv34_scen3_b & qmv34_scen3_a>qmv34_scen3_c
replace pchoice = qmv34_scen3_a
replace x1=0
replace x2=0
replace x3=ln( 1 )
replace x4=ln( 1 )
replace x5=0
replace x10="SepC4"
replace x11=3
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob34g if sum34_scen3==100,  replace  nolab

replace chosen = qmv34_scen3_b>qmv34_scen3_c & qmv34_scen3_b>qmv34_scen3_a
replace pchoice = qmv34_scen3_b
replace x1=600
replace x2=1
replace x3=ln( 0.5 )
replace x4=ln( 1.1 )
replace x5=1
replace x10="SepC4"
replace x11=3
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob34h if sum34_scen3==100,  replace  nolab

replace chosen = qmv34_scen3_c>qmv34_scen3_b & qmv34_scen3_c>qmv34_scen3_a
replace pchoice = qmv34_scen3_c
replace x1=500
replace x2=-1
replace x3=ln( 1 )
replace x4=ln( 1.1 ) //0
replace x5=1
replace x10="SepC4"
replace x11=3
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob34i if sum34_scen3==100,  replace nolab


* Scenario 4
replace chosen = qmv34_scen4_a>qmv34_scen4_b & qmv34_scen4_a>qmv34_scen4_c
replace pchoice = qmv34_scen4_a
replace x1=0
replace x2=1
replace x3=ln(1)
replace x4=ln(1)
replace x5=0
replace x10="SepC4"
replace x11=4
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob34j if sum34_scen4==100,  replace nolab

replace chosen = qmv34_scen4_b>qmv34_scen4_c & qmv34_scen4_b>qmv34_scen4_a
replace pchoice = qmv34_scen4_b
replace x1=500
replace x2=-1
replace x3=ln(0.8)
replace x4=ln(1.1)
replace x5=1
replace x10="SepC4"
replace x11=4
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob34k if sum34_scen4==100,  replace nolab

replace chosen = qmv34_scen4_c>qmv34_scen4_b & qmv34_scen4_c>qmv34_scen4_a
replace pchoice = qmv34_scen4_c
replace x1=300
replace x2=1
replace x3=ln( 1.1 )
replace x4=ln( 1.1 ) //0
replace x5=1
replace x10="SepC4"
replace x11=4
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob34l if sum34_scen4==100,  replace  nolab



***************************
* CASE 5
***************************
* Scenario 1
replace chosen = qmv35_scen1_a>qmv35_scen1_b & qmv35_scen1_a>qmv35_scen1_c
replace pchoice = qmv35_scen1_a
replace x1=ln( 1 )
replace x2=0
replace x3=0
replace x4=0
replace x5=0
replace x10="SepC5"
replace x11=1
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob35a if sum35_scen1==100,  replace nolab

replace chosen = qmv35_scen1_b>qmv35_scen1_c & qmv35_scen1_b>qmv35_scen1_a
replace pchoice = qmv35_scen1_b
replace x1=ln( 1.08 )
replace x2=-500
replace x3=2
replace x4=250
replace x5=1
replace x10="SepC5"
replace x11=1
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob35b if sum35_scen1==100,  replace nolab

replace chosen = qmv35_scen1_c>qmv35_scen1_b & qmv35_scen1_c>qmv35_scen1_a
replace pchoice = qmv35_scen1_c
replace x1=ln( 0.92 )
replace x2=1000
replace x3=10
replace x4=250
replace x5=1
replace x10="SepC5"
replace x11=1
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob35c if sum35_scen1==100,  replace nolab



* Scenario 2
replace chosen = qmv35_scen2_a>qmv35_scen2_b & qmv35_scen2_a>qmv35_scen2_c
replace pchoice = qmv35_scen2_a
replace x1=ln( 1 )
replace x2=0
replace x3=0
replace x4=0
replace x5=0
replace x10="SepC5"
replace x11=2
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob35d if sum35_scen2==100,  replace nolab

replace chosen = qmv35_scen2_b>qmv35_scen2_c & qmv35_scen2_b>qmv35_scen2_a
replace pchoice = qmv35_scen2_b
replace x1=ln( 1.02 )
replace x2=-500
replace x3=2
replace x4=250
replace x5=1
replace x10="SepC5"
replace x11=2
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob35e if sum35_scen2==100,  replace nolab

replace chosen = qmv35_scen2_c>qmv35_scen2_b & qmv35_scen2_c>qmv35_scen2_a
replace pchoice = qmv35_scen2_c
replace x1=ln( 1.12 )
replace x2=-500
replace x3=10
replace x4=250
replace x5=1
replace x10="SepC5"
replace x11=2
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob35f if sum35_scen2==100,  replace nolab
 

* Scenario 3
replace chosen = qmv35_scen3_a>qmv35_scen3_b & qmv35_scen3_a>qmv35_scen3_c
replace pchoice = qmv35_scen3_a
replace x1=ln( 1 )
replace x2=0
replace x3=0
replace x4=0
replace x5=0
replace x10="SepC5"
replace x11=3
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob35g if sum35_scen3==100,  replace  nolab

replace chosen = qmv35_scen3_b>qmv35_scen3_c & qmv35_scen3_b>qmv35_scen3_a
replace pchoice = qmv35_scen3_b
replace x1=ln( 1.1 )
replace x2=1000
replace x3=15
replace x4=250
replace x5=1
replace x10="SepC5"
replace x11=3
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob35h if sum35_scen3==100,  replace  nolab

replace chosen = qmv35_scen3_c>qmv35_scen3_b & qmv35_scen3_c>qmv35_scen3_a
replace pchoice = qmv35_scen3_c
replace x1=ln( 1.1 ) //0
replace x2=500
replace x3=4
replace x4=250
replace x5=1
replace x10="SepC5"
replace x11=3
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob35i if sum35_scen3==100,  replace nolab


* Scenario 4
replace chosen = qmv35_scen4_a>qmv35_scen4_b & qmv35_scen4_a>qmv35_scen4_c
replace pchoice = qmv35_scen4_a
replace x1=ln( 1 )
replace x2=0
replace x3=0
replace x4=0
replace x5=0
replace x10="SepC5"
replace x11=4
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob35j if sum35_scen4==100,  replace nolab

replace chosen = qmv35_scen4_b>qmv35_scen4_c & qmv35_scen4_b>qmv35_scen4_a
replace pchoice = qmv35_scen4_b
replace x1=ln( 1.08 )
replace x2=-200
replace x3=6
replace x4=250
replace x5=1
replace x10="SepC5"
replace x11=4
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob35k if sum35_scen4==100,  replace nolab

replace chosen = qmv35_scen4_c>qmv35_scen4_b & qmv35_scen4_c>qmv35_scen4_a
replace pchoice = qmv35_scen4_c
replace x1=ln( 0.92 )
replace x2=100
replace x3=6
replace x4=250
replace x5=1
replace x10="SepC5"
replace x11=4
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob35l if sum35_scen4==100,  replace  nolab



***************************
* CASE 6
***************************
* Scenario 1
replace chosen = qmv36_scen1_a>qmv36_scen1_b & qmv36_scen1_a>qmv36_scen1_c
replace pchoice = qmv36_scen1_a
replace x1=0
replace x2=0
replace x3=ln( 1 )
replace x5=0
replace x10="SepC6"
replace x11=1
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob36a if sum36_scen1==100,  replace nolab

replace chosen = qmv36_scen1_b>qmv36_scen1_c & qmv36_scen1_b>qmv36_scen1_a
replace pchoice = qmv36_scen1_b
replace x1=150
replace x2=5
replace x3=ln( 1.1 )
replace x5=1
replace x10="SepC6"
replace x11=1
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob36b if sum36_scen1==100,  replace nolab

replace chosen = qmv36_scen1_c>qmv36_scen1_b & qmv36_scen1_c>qmv36_scen1_a
replace pchoice = qmv36_scen1_c
replace x1=250
replace x2=0
replace x3=ln( 0.9 )
replace x5=1
replace x10="SepC6"
replace x11=1
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob36c if sum36_scen1==100,  replace nolab



* Scenario 2
replace chosen = qmv36_scen2_a>qmv36_scen2_b & qmv36_scen2_a>qmv36_scen2_c
replace pchoice = qmv36_scen2_a
replace x1=0
replace x2=0
replace x3=ln( 1 ) //0
replace x5=0
replace x10="SepC6"
replace x11=2
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob36d if sum36_scen2==100,  replace nolab

replace chosen = qmv36_scen2_b>qmv36_scen2_c & qmv36_scen2_b>qmv36_scen2_a
replace pchoice = qmv36_scen2_b
replace x1=150
replace x2=-5
replace x3=ln( 1 ) //0
replace x5=1
replace x10="SepC6"
replace x11=2
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob36e if sum36_scen2==100,  replace nolab

replace chosen = qmv36_scen2_c>qmv36_scen2_b & qmv36_scen2_c>qmv36_scen2_a
replace pchoice = qmv36_scen2_c
replace x1=550
replace x2=-5
replace x3=ln( 1.1 )
replace x5=1
replace x10="SepC6"
replace x11=2
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob36f if sum36_scen2==100,  replace nolab
 

* Scenario 3
replace chosen = qmv36_scen3_a>qmv36_scen3_b & qmv36_scen3_a>qmv36_scen3_c
replace pchoice = qmv36_scen3_a
replace x1=0
replace x2=0
replace x3=ln( 1 )
replace x5=0
replace x10="SepC6"
replace x11=3
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob36g if sum36_scen3==100,  replace  nolab

replace chosen = qmv36_scen3_b>qmv36_scen3_c & qmv36_scen3_b>qmv36_scen3_a
replace pchoice = qmv36_scen3_b
replace x1=250
replace x2=10
replace x3=ln( 1.15 )
replace x5=1
replace x10="SepC6"
replace x11=3
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob36h if sum36_scen3==100,  replace  nolab

replace chosen = qmv36_scen3_c>qmv36_scen3_b & qmv36_scen3_c>qmv36_scen3_a
replace pchoice = qmv36_scen3_c
replace x1=300
replace x2=0
replace x3=ln( 1.05 )
replace x5=1
replace x10="SepC6"
replace x11=3
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob36i if sum36_scen3==100,  replace nolab


* Scenario 4
replace chosen = qmv36_scen4_a>qmv36_scen4_b & qmv36_scen4_a>qmv36_scen4_c
replace pchoice = qmv36_scen4_a
replace x1=0
replace x2=0
replace x3=ln( 1 )
replace x5=0
replace x10="SepC6"
replace x11=4
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob36j if sum36_scen4==100,  replace nolab

replace chosen = qmv36_scen4_b>qmv36_scen4_c & qmv36_scen4_b>qmv36_scen4_a
replace pchoice = qmv36_scen4_b
replace x1=550
replace x2=-5
replace x3=ln( 1.1 )
replace x5=1
replace x10="SepC6"
replace x11=4
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob36k if sum36_scen4==100,  replace nolab

replace chosen = qmv36_scen4_c>qmv36_scen4_b & qmv36_scen4_c>qmv36_scen4_a
replace pchoice = qmv36_scen4_c
replace x1=100
replace x2=5
replace x3=ln( 1.1 ) //0
replace x5=1
replace x10="SepC6"
replace x11=4
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob36l if sum36_scen4==100,  replace  nolab



** 31 
local alphabet a b c d e f g h i j k l
foreach letter in `alphabet' {
    import delimited using ${temppath}SCEmlb_mob31`letter', varn(1) clear case(preserve)
    rename (chosen pchoice x1 x2 x3 x5 x10 x11 x12) (chosen pchoice dist crime income moved svyblk scennum altnum)
    gen wave=1
    replace dist = dist/100
    save `m31`letter'', replace
}

** 32
foreach letter in `alphabet' {
    import delimited using ${temppath}SCEmlb_mob32`letter', varn(1) clear case(preserve)
    rename (chosen pchoice x1 x2 x3 x5 x10 x11 x12) (chosen pchoice dist mvcost income moved svyblk scennum altnum)
    gen wave=1
    replace dist = dist/100
    save `m32`letter'', replace
}

** 33 
foreach letter in `alphabet' {
    import delimited using ${temppath}SCEmlb_mob33`letter', varn(1) clear case(preserve)
    rename (chosen pchoice x1 x2 x3 x5 x10 x11 x12) (chosen pchoice  dist family income moved svyblk scennum altnum)
    gen wave=1
    replace dist = dist/100
    save `m33`letter'', replace
}
** 34
foreach letter in `alphabet' {
    import delimited using ${temppath}SCEmlb_mob34`letter', varn(1) clear case(preserve)
    rename (chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12) (chosen pchoice dist norms homecost income moved svyblk scennum altnum)
    gen wave=1
    replace dist = dist/100
    save `m34`letter'', replace
}
** 35
local alphabet a b c d e f g h i j k l
foreach letter in `alphabet' {
    import delimited using ${temppath}SCEmlb_mob35`letter', varn(1) clear case(preserve)
    rename (chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12) (chosen pchoice income size mvcost dist moved svyblk scennum altnum)
    gen wave=1
    replace dist = dist/100
    replace size = size/1000
    save `m35`letter'', replace
}

** 36
foreach letter in `alphabet' {
    import delimited using ${temppath}SCEmlb_mob36`letter', varn(1) clear case(preserve)
    rename (chosen pchoice x1 x2 x3 x5 x10 x11 x12) (chosen pchoice dist taxes income moved svyblk scennum altnum)
    gen wave=1
    replace dist = dist/100
    save `m36`letter'', replace
}


*------------------------------------------------------------------------------
* December 2019 wave
*------------------------------------------------------------------------------
use `maindata', clear
***************************
* CASE 1
***************************
* Scenario 1
gen     chosen = qmv41_scen1_a>qmv41_scen1_b & qmv41_scen1_a>qmv41_scen1_c
gen     pchoice = qmv41_scen1_a
gen     x1=0
gen     x2=ln( 1 )
gen     x3=ln( 1 )
gen     x4=0
gen     x5=0 
gen     x10="DecC1"
gen     x11=1
gen     x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob41a if sum41_scen1==100,  replace nolab

replace chosen = qmv41_scen1_b>qmv41_scen1_c & qmv41_scen1_b>qmv41_scen1_a
replace pchoice = qmv41_scen1_b
replace x1=500
replace x2=ln( 2 )
replace x3=ln( 1.4 )
replace x5=1
replace x10="DecC1"
replace x11=1
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob41b if sum41_scen1==100,  replace nolab

replace chosen = qmv41_scen1_c>qmv41_scen1_b & qmv41_scen1_c>qmv41_scen1_a
replace pchoice = qmv41_scen1_c
replace x1=1000
replace x2=ln( 0.5 )
replace x3=ln( 1.2 )
replace x5=1
replace x10="DecC1"
replace x11=1
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob41c if sum41_scen1==100,  replace nolab


* Scenario 2
replace chosen = qmv41_scen2_a>qmv41_scen2_b & qmv41_scen2_a>qmv41_scen2_c
replace pchoice = qmv41_scen2_a
replace x1=0
replace x2=ln( 1 ) //0
replace x3=ln( 1 )
replace x5=0
replace x10="DecC1"
replace x11=2
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob41d if sum41_scen2==100, replace nolab
 
replace chosen = qmv41_scen2_b>qmv41_scen2_c & qmv41_scen2_b>qmv41_scen2_a
replace pchoice = qmv41_scen2_b
replace x1=500
replace x2=ln( 1 ) //0
replace x3=ln( 1.1 )
replace x5=1
replace x10="DecC1"
replace x11=2
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob41e if sum41_scen2==100, replace nolab
 
replace chosen = qmv41_scen2_c>qmv41_scen2_b & qmv41_scen2_c>qmv41_scen2_a
replace pchoice = qmv41_scen2_c
replace x1=500
replace x2=ln( 0.5 )
replace x3=ln( 1 )
replace x5=1
replace x10="DecC1"
replace x11=2
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob41f if sum41_scen2==100,  replace nolab
  

* Scenario 3
replace chosen = qmv41_scen3_a>qmv41_scen3_b & qmv41_scen3_a>qmv41_scen3_c
replace pchoice = qmv41_scen3_a
replace x1=0
replace x2=ln( 1 )
replace x3=ln( 0.7 )
replace x5=0
replace x10="DecC1"
replace x11=3
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob41g if sum41_scen3==100,  replace nolab
 
replace chosen = qmv41_scen3_b>qmv41_scen3_c & qmv41_scen3_b>qmv41_scen3_a
replace pchoice = qmv41_scen3_b
replace x1=500
replace x2=ln( 0.5 )
replace x3=ln( 0.80 )
replace x5=1
replace x10="DecC1"
replace x11=3
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob41h if sum41_scen3==100,  replace nolab
 
replace chosen = qmv41_scen3_c>qmv41_scen3_b & qmv41_scen3_c>qmv41_scen3_a
replace pchoice = qmv41_scen3_c
replace x1=1000
replace x2=ln( 2 )
replace x3=ln( 1.1 )
replace x5=1
replace x10="DecC1"
replace x11=3
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob41i if sum41_scen3==100,  replace nolab
 

* Scenario 4
replace chosen = qmv41_scen4_a>qmv41_scen4_b & qmv41_scen4_a>qmv41_scen4_c
replace pchoice = qmv41_scen4_a
replace x1=0
replace x2=ln( 1 )
replace x3=ln( 0.6 )
replace x5=0
replace x10="DecC1"
replace x11=4
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob41j if sum41_scen4==100,  replace nolab

replace chosen = qmv41_scen4_b>qmv41_scen4_c & qmv41_scen4_b>qmv41_scen4_a
replace pchoice = qmv41_scen4_b
replace x1=500
replace x2=ln( 0.5 )
replace x3=ln( 1 )
replace x5=1
replace x10="DecC1"
replace x11=4
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob41k if sum41_scen4==100,  replace nolab

replace chosen = qmv41_scen4_c>qmv41_scen4_b & qmv41_scen4_c>qmv41_scen4_a
replace pchoice = qmv41_scen4_c
replace x1=1000
replace x2=ln( 0.5 )
replace x3=ln( 1.1 )
replace x5=1
replace x10="DecC1"
replace x11=4
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob41l if sum41_scen4==100,  replace nolab


***************************
* CASE 2
***************************
gen wye = qmv6b
gen zee = inlist(wye,3,4)*-1 + inlist(wye,1,2)*1
* Scenario 1
replace chosen = qmv42_scen1_a>qmv42_scen1_b & qmv42_scen1_a>qmv42_scen1_c
replace pchoice = qmv42_scen1_a
replace x1=0
replace x2=wye
replace x3=ln( 1 )
replace x5=0
replace x10="DecC2"
replace x11=1
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob42a if sum42_scen1==100,  replace nolab

replace chosen = qmv42_scen1_b>qmv42_scen1_c & qmv42_scen1_b>qmv42_scen1_a
replace pchoice = qmv42_scen1_b
replace x1=500
replace x2=wye+zee
replace x3=ln( 1-.15*zee )
replace x5=1
replace x10="DecC2"
replace x11=1
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob42b if sum42_scen1==100,  replace nolab

replace chosen = qmv42_scen1_c>qmv42_scen1_b & qmv42_scen1_c>qmv42_scen1_a
replace pchoice = qmv42_scen1_c
replace x1=1000
replace x2=wye+2*zee
replace x3=ln( 1-.15*zee )
replace x5=1
replace x10="DecC2"
replace x11=1
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob42c if sum42_scen1==100,  replace nolab



* Scenario 2
replace chosen = qmv42_scen2_a>qmv42_scen2_b & qmv42_scen2_a>qmv42_scen2_c
replace pchoice = qmv42_scen2_a
replace x1=0
replace x2=wye
replace x3=ln( 1 ) //0
replace x5=0
replace x10="DecC2"
replace x11=2
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob42d if sum42_scen2==100,  replace nolab

replace chosen = qmv42_scen2_b>qmv42_scen2_c & qmv42_scen2_b>qmv42_scen2_a
replace pchoice = qmv42_scen2_b
replace x1=500
replace x2=wye+2*zee
replace x3=ln( 1-.05*zee ) //0
replace x5=1
replace x10="DecC2"
replace x11=2
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob42e if sum42_scen2==100,  replace nolab

replace chosen = qmv42_scen2_c>qmv42_scen2_b & qmv42_scen2_c>qmv42_scen2_a
replace pchoice = qmv42_scen2_c
replace x1=1000
replace x2=wye+2*zee
replace x3=ln( 1-.15*zee )
replace x5=1
replace x10="DecC2"
replace x11=2
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob42f if sum42_scen2==100,  replace nolab
 

* Scenario 3
replace chosen = qmv42_scen3_a>qmv42_scen3_b & qmv42_scen3_a>qmv42_scen3_c
replace pchoice = qmv42_scen3_a
replace x1=0
replace x2=wye
replace x3=ln( 1 )
replace x5=0
replace x10="DecC2"
replace x11=3
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob42g if sum42_scen3==100,  replace  nolab

replace chosen = qmv42_scen3_b>qmv42_scen3_c & qmv42_scen3_b>qmv42_scen3_a
replace pchoice = qmv42_scen3_b
replace x1=500
replace x2=wye+2*zee
replace x3=ln( 1-.15*zee )
replace x5=1
replace x10="DecC2"
replace x11=3
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob42h if sum42_scen3==100,  replace  nolab

replace chosen = qmv42_scen3_c>qmv42_scen3_b & qmv42_scen3_c>qmv42_scen3_a
replace pchoice = qmv42_scen3_c
replace x1=300
replace x2=wye+zee
replace x3=ln( 1-.05*zee )
replace x5=1
replace x10="DecC2"
replace x11=3
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob42i if sum42_scen3==100,  replace nolab


* Scenario 4
replace chosen = qmv42_scen4_a>qmv42_scen4_b & qmv42_scen4_a>qmv42_scen4_c
replace pchoice = qmv42_scen4_a
replace x1=0
replace x2=wye
replace x3=ln( 1 )
replace x5=0
replace x10="DecC2"
replace x11=4
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob42j if sum42_scen4==100,  replace nolab

replace chosen = qmv42_scen4_b>qmv42_scen4_c & qmv42_scen4_b>qmv42_scen4_a
replace pchoice = qmv42_scen4_b
replace x1=500
replace x2=wye+2*zee
replace x3=ln( 1-.3*zee )
replace x5=1
replace x10="DecC2"
replace x11=4
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob42k if sum42_scen4==100,  replace nolab

replace chosen = qmv42_scen4_c>qmv42_scen4_b & qmv42_scen4_c>qmv42_scen4_a
replace pchoice = qmv42_scen4_c
replace x1=1000
replace x2=wye
replace x3=ln( 1-.2*zee )
replace x5=1
replace x10="DecC2"
replace x11=4
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob42l if sum42_scen4==100,  replace  nolab



***************************
* CASE 3
***************************
* Scenario 1
replace chosen = qmv43_scen1_a>qmv43_scen1_b & qmv43_scen1_a>qmv43_scen1_c
replace pchoice = qmv43_scen1_a
replace x1=0
replace x2=0
replace x3=ln( 0.7 )
replace x5=0
replace x10="DecC3"
replace x11=1
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob43a if sum43_scen1==100,  replace nolab

replace chosen = qmv43_scen1_b>qmv43_scen1_c & qmv43_scen1_b>qmv43_scen1_a
replace pchoice = qmv43_scen1_b
replace x1=1000
replace x2=1
replace x3=ln( 1 )
replace x5=1
replace x10="DecC3"
replace x11=1
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob43b if sum43_scen1==100,  replace nolab

replace chosen = qmv43_scen1_c>qmv43_scen1_b & qmv43_scen1_c>qmv43_scen1_a
replace pchoice = qmv43_scen1_c
replace x1=1000
replace x2=0
replace x3=ln( 1.3 )
replace x5=1
replace x10="DecC3"
replace x11=1
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob43c if sum43_scen1==100,  replace nolab



* Scenario 2
replace chosen = qmv43_scen2_a>qmv43_scen2_b & qmv43_scen2_a>qmv43_scen2_c
replace pchoice = qmv43_scen2_a
replace x1=0
replace x2=1
replace x3=ln( 0.7 )
replace x5=0
replace x10="DecC3"
replace x11=2
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob43d if sum43_scen2==100,  replace nolab

replace chosen = qmv43_scen2_b>qmv43_scen2_c & qmv43_scen2_b>qmv43_scen2_a
replace pchoice = qmv43_scen2_b
replace x1=500
replace x2=1
replace x3=ln( 2.5 )
replace x5=1
replace x10="DecC3"
replace x11=2
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob43e if sum43_scen2==100,  replace nolab

replace chosen = qmv43_scen2_c>qmv43_scen2_b & qmv43_scen2_c>qmv43_scen2_a
replace pchoice = qmv43_scen2_c
replace x1=100
replace x2=0
replace x3=ln( 1.6 )
replace x5=1
replace x10="DecC3"
replace x11=2
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob43f if sum43_scen2==100,  replace nolab
 

* Scenario 3
replace chosen = qmv43_scen3_a>qmv43_scen3_b & qmv43_scen3_a>qmv43_scen3_c
replace pchoice = qmv43_scen3_a
replace x1=0
replace x2=0
replace x3=ln( 0.85 )
replace x5=0
replace x10="DecC3"
replace x11=3
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob43g if sum43_scen3==100,  replace  nolab

replace chosen = qmv43_scen3_b>qmv43_scen3_c & qmv43_scen3_b>qmv43_scen3_a
replace pchoice = qmv43_scen3_b
replace x1=250
replace x2=1
replace x3=ln( 1.3 )
replace x5=1
replace x10="DecC3"
replace x11=3
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob43h if sum43_scen3==100,  replace  nolab

replace chosen = qmv43_scen3_c>qmv43_scen3_b & qmv43_scen3_c>qmv43_scen3_a
replace pchoice = qmv43_scen3_c
replace x1=50
replace x2=1
replace x3=ln( 0.7 )
replace x5=1
replace x10="DecC3"
replace x11=3
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob43i if sum43_scen3==100,  replace nolab


* Scenario 4
replace chosen = qmv43_scen4_a>qmv43_scen4_b & qmv43_scen4_a>qmv43_scen4_c
replace pchoice = qmv43_scen4_a
replace x1=0
replace x2=1
replace x3=ln( 0.55 )
replace x5=0
replace x10="DecC3"
replace x11=4
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob43j if sum43_scen4==100,  replace nolab

replace chosen = qmv43_scen4_b>qmv43_scen4_c & qmv43_scen4_b>qmv43_scen4_a
replace pchoice = qmv43_scen4_b
replace x1=350
replace x2=1
replace x3=ln( 1 )
replace x5=1
replace x10="DecC3"
replace x11=4
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob43k if sum43_scen4==100,  replace nolab

replace chosen = qmv43_scen4_c>qmv43_scen4_b & qmv43_scen4_c>qmv43_scen4_a
replace pchoice = qmv43_scen4_c
replace x1=500
replace x2=0
replace x3=ln( 3 )
replace x5=1
replace x10="DecC3"
replace x11=4
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob43l if sum43_scen4==100,  replace  nolab



***************************
* CASE 4
***************************
* Scenario 1
replace chosen = qmv44_scen1_a>qmv44_scen1_b & qmv44_scen1_a>qmv44_scen1_c
replace pchoice = qmv44_scen1_a
replace x1=0
replace x2=0
replace x3=ln( 1 )
replace x4=ln( 1 )
replace x5=0
replace x10="DecC4"
replace x11=1
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob44a if sum44_scen1==100,  replace nolab

replace chosen = qmv44_scen1_b>qmv44_scen1_c & qmv44_scen1_b>qmv44_scen1_a
replace pchoice = qmv44_scen1_b
replace x1=500
replace x2=1
replace x3=ln( 1.2 )
replace x4=ln( 1.1 )
replace x5=1
replace x10="DecC4"
replace x11=1
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob44b if sum44_scen1==100,  replace nolab

replace chosen = qmv44_scen1_c>qmv44_scen1_b & qmv44_scen1_c>qmv44_scen1_a
replace pchoice = qmv44_scen1_c
replace x1=500
replace x2=0
replace x3=ln( 0.9 )
replace x4=ln( 1.1 )
replace x5=1
replace x10="DecC4"
replace x11=1
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob44c if sum44_scen1==100,  replace nolab



* Scenario 2
replace chosen = qmv44_scen2_a>qmv44_scen2_b & qmv44_scen2_a>qmv44_scen2_c
replace pchoice = qmv44_scen2_a
replace x1=0
replace x2=0
replace x3=ln( 1 )
replace x4=ln( 1 )
replace x5=0
replace x10="DecC4"
replace x11=2
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob44d if sum44_scen2==100,  replace nolab

replace chosen = qmv44_scen2_b>qmv44_scen2_c & qmv44_scen2_b>qmv44_scen2_a
replace pchoice = qmv44_scen2_b
replace x1=500
replace x2=-1
replace x3=ln( 1.1 )
replace x4=ln( 1.1 )
replace x5=1
replace x10="DecC4"
replace x11=2
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob44e if sum44_scen2==100,  replace nolab

replace chosen = qmv44_scen2_c>qmv44_scen2_b & qmv44_scen2_c>qmv44_scen2_a
replace pchoice = qmv44_scen2_c
replace x1=1000
replace x2=1
replace x3=ln( 1.1 )
replace x4=ln( 1.1 )
replace x5=1
replace x10="DecC4"
replace x11=2
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob44f if sum44_scen2==100,  replace nolab
 

* Scenario 3
replace chosen = qmv44_scen3_a>qmv44_scen3_b & qmv44_scen3_a>qmv44_scen3_c
replace pchoice = qmv44_scen3_a
replace x1=0
replace x2=0
replace x3=ln( 1 )
replace x4=ln( 1 )
replace x5=0
replace x10="DecC4"
replace x11=3
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob44g if sum44_scen3==100,  replace  nolab

replace chosen = qmv44_scen3_b>qmv44_scen3_c & qmv44_scen3_b>qmv44_scen3_a
replace pchoice = qmv44_scen3_b
replace x1=600
replace x2=1
replace x3=ln( 0.8 )
replace x4=ln( 1.1 )
replace x5=1
replace x10="DecC4"
replace x11=3
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob44h if sum44_scen3==100,  replace  nolab

replace chosen = qmv44_scen3_c>qmv44_scen3_b & qmv44_scen3_c>qmv44_scen3_a
replace pchoice = qmv44_scen3_c
replace x1=500
replace x2=-1
replace x3=ln( 1 )
replace x4=ln( 1.1 )
replace x5=1
replace x10="DecC4"
replace x11=3
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob44i if sum44_scen3==100,  replace nolab


* Scenario 4
replace chosen = qmv44_scen4_a>qmv44_scen4_b & qmv44_scen4_a>qmv44_scen4_c
replace pchoice = qmv44_scen4_a
replace x1=0
replace x2=0
replace x3=ln(1)
replace x4=ln(1)
replace x5=0
replace x10="DecC4"
replace x11=4
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob44j if sum44_scen4==100,  replace nolab

replace chosen = qmv44_scen4_b>qmv44_scen4_c & qmv44_scen4_b>qmv44_scen4_a
replace pchoice = qmv44_scen4_b
replace x1=500
replace x2=-1
replace x3=ln(0.8)
replace x4=ln(1.1)
replace x5=1
replace x10="DecC4"
replace x11=4
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob44k if sum44_scen4==100,  replace nolab

replace chosen = qmv44_scen4_c>qmv44_scen4_b & qmv44_scen4_c>qmv44_scen4_a
replace pchoice = qmv44_scen4_c
replace x1=300
replace x2=1
replace x3=ln( 1.1 )
replace x4=ln( 1.1 )
replace x5=1
replace x10="DecC4"
replace x11=4
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob44l if sum44_scen4==100,  replace  nolab



***************************
* CASE 5
***************************
drop wye zee
gen wye = qmv6b
gen dub = inlist(wye,4)*-1 + inlist(wye,1,2,3)*1
* Scenario 1
replace chosen = qmv45_scen1_a>qmv45_scen1_b & qmv45_scen1_a>qmv45_scen1_c
replace pchoice = qmv45_scen1_a
replace x1=0
replace x2=wye
replace x3=ln( 1 )
replace x4=ln( 1 )
replace x5=0
replace x10="DecC5"
replace x11=1
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob45a if sum45_scen1==100,  replace nolab

replace chosen = qmv45_scen1_b>qmv45_scen1_c & qmv45_scen1_b>qmv45_scen1_a
replace pchoice = qmv45_scen1_b
replace x1=500
replace x2=wye+dub
replace x3=ln( 1+.1*dub )
replace x4=ln( 1.1 )
replace x5=1
replace x10="DecC5"
replace x11=1
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob45b if sum45_scen1==100,  replace nolab

replace chosen = qmv45_scen1_c>qmv45_scen1_b & qmv45_scen1_c>qmv45_scen1_a
replace pchoice = qmv45_scen1_c
replace x1=500
replace x2=wye
replace x3=ln( 0.95 )
replace x4=ln( 1.1 )
replace x5=1
replace x10="DecC5"
replace x11=1
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob45c if sum45_scen1==100,  replace nolab



* Scenario 2
drop wye dub
gen wye = qmv6b
replace chosen = qmv45_scen2_a>qmv45_scen2_b & qmv45_scen2_a>qmv45_scen2_c
replace pchoice = qmv45_scen2_a
replace x1=0
replace x2=wye
replace x3=ln( 1 )
replace x4=ln( 1 )
replace x5=0
replace x10="DecC5"
replace x11=2
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob45d if sum45_scen2==100,  replace nolab

replace chosen = qmv45_scen2_b>qmv45_scen2_c & qmv45_scen2_b>qmv45_scen2_a
replace pchoice = qmv45_scen2_b
replace x1=500
replace x2=2*(wye==1)+1*(wye==2)+2*(wye==3)+3*(wye==4)
replace x3=ln( 1.15 )*(wye==1) + ln( 0.85 )*(wye==2) + ln( 0.85 )*(wye==3) + ln( 0.95 )*(wye==4)
replace x4=ln( 1.1 )
replace x5=1
replace x10="DecC5"
replace x11=2
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob45e if sum45_scen2==100,  replace nolab

replace chosen = qmv45_scen2_c>qmv45_scen2_b & qmv45_scen2_c>qmv45_scen2_a
replace pchoice = qmv45_scen2_c
replace x1=1000
replace x2=2*(wye==1)+3*(wye==2)+4*(wye==3)+3*(wye==4)
replace x3=ln( 1.05 )*(wye==1) + ln( 1.05 )*(wye==2) + ln( 1.05 )*(wye==3) + ln( 0.85 )*(wye==4)
replace x4=ln( 1.1 )
replace x5=1
replace x10="DecC5"
replace x11=2
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob45f if sum45_scen2==100,  replace nolab
 

* Scenario 3
drop wye
gen wye = qmv6b
gen zee = inlist(wye,2,3,4)*-1 + inlist(wye,1)*1
gen dub = inlist(wye,4)*-1 + inlist(wye,1,2,3)*1
replace chosen = qmv45_scen3_a>qmv45_scen3_b & qmv45_scen3_a>qmv45_scen3_c
replace pchoice = qmv45_scen3_a
replace x1=0
replace x2=wye
replace x3=ln( 1 )
replace x4=ln( 1 )
replace x5=0
replace x10="DecC5"
replace x11=3
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob45g if sum45_scen3==100,  replace  nolab

replace chosen = qmv45_scen3_b>qmv45_scen3_c & qmv45_scen3_b>qmv45_scen3_a
replace pchoice = qmv45_scen3_b
replace x1=600
replace x2=wye+dub
replace x3=ln( 1+.2*dub )
replace x4=ln( 1.1 )
replace x5=1
replace x10="DecC5"
replace x11=3
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob45h if sum45_scen3==100,  replace  nolab

replace chosen = qmv45_scen3_c>qmv45_scen3_b & qmv45_scen3_c>qmv45_scen3_a
replace pchoice = qmv45_scen3_c
replace x1=500
replace x2=wye+zee
replace x3=ln( 1-.1*zee )
replace x4=ln( 1.1 )
replace x5=1
replace x10="DecC5"
replace x11=3
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob45i if sum45_scen3==100,  replace nolab


* Scenario 4
replace chosen = qmv45_scen4_a>qmv45_scen4_b & qmv45_scen4_a>qmv45_scen4_c
replace pchoice = qmv45_scen4_a
replace x1=0
replace x2=wye
replace x3=ln( 1 )
replace x4=ln( 1 )
replace x5=0
replace x10="DecC5"
replace x11=4
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob45j if sum45_scen4==100,  replace nolab

replace chosen = qmv45_scen4_b>qmv45_scen4_c & qmv45_scen4_b>qmv45_scen4_a
replace pchoice = qmv45_scen4_b
replace x1=500
replace x2=wye+zee
replace x3=ln( 1+0.4*zee )
replace x4=ln( 1.1 )
replace x5=1
replace x10="DecC5"
replace x11=4
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob45k if sum45_scen4==100,  replace nolab

replace chosen = qmv45_scen4_c>qmv45_scen4_b & qmv45_scen4_c>qmv45_scen4_a
replace pchoice = qmv45_scen4_c
replace x1=300
replace x2=wye+dub
replace x3=ln( 1+0.2*dub )
replace x4=ln( 1.1 )
replace x5=1
replace x10="DecC5"
replace x11=4
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12 using ${temppath}SCEmlb_mob45l if sum45_scen4==100,  replace  nolab



***************************
* CASE 6
***************************
gen x2n = 0 // same city
gen x2w = 0 // within city move
gen x2e = 0 // exact same house
gen x2c = 0 // copy of exact same house
gen x2d = 0 // different house
gen x2wc = 0 // within-city copy
* Scenario 1
replace chosen = qmv46_scen1_a>qmv46_scen1_b & qmv46_scen1_a>qmv46_scen1_c
replace pchoice = qmv46_scen1_a
replace x1=0
replace x2n=1
replace x2w=0
replace x2e=1
replace x2c=0
replace x2d=0
replace x2wc=0
replace x3=ln( 1 )
replace x5=0
replace x10="DecC6"
replace x11=1
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2n x2w x2e x2c x2d x2wc x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob46a if sum46_scen1==100,  replace nolab

replace chosen = qmv46_scen1_b>qmv46_scen1_c & qmv46_scen1_b>qmv46_scen1_a
replace pchoice = qmv46_scen1_b
replace x1=0.2
replace x2n=1
replace x2w=1
replace x2e=0
replace x2c=1
replace x2d=0
replace x2wc=1
replace x3=ln( 1.05 )
replace x5=1
replace x10="DecC6"
replace x11=1
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2n x2w x2e x2c x2d x2wc x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob46b if sum46_scen1==100,  replace nolab

replace chosen = qmv46_scen1_c>qmv46_scen1_b & qmv46_scen1_c>qmv46_scen1_a
replace pchoice = qmv46_scen1_c
replace x1=200
replace x2n=0
replace x2w=0
replace x2e=0
replace x2c=0
replace x2d=1
replace x2wc=0
replace x3=ln( 1.15 )
replace x5=1
replace x10="DecC6"
replace x11=1
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2n x2w x2e x2c x2d x2wc x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob46c if sum46_scen1==100,  replace nolab



* Scenario 2
replace chosen = qmv46_scen2_a>qmv46_scen2_b & qmv46_scen2_a>qmv46_scen2_c
replace pchoice = qmv46_scen2_a
replace x1=0
replace x2n=1
replace x2w=0
replace x2e=1
replace x2c=0
replace x2d=0
replace x2wc=0
replace x3=ln( 1 ) //0
replace x5=0
replace x10="DecC6"
replace x11=2
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2n x2w x2e x2c x2d x2wc x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob46d if sum46_scen2==100,  replace nolab

replace chosen = qmv46_scen2_b>qmv46_scen2_c & qmv46_scen2_b>qmv46_scen2_a
replace pchoice = qmv46_scen2_b
replace x1=200
replace x2n=0
replace x2w=0
replace x2e=0
replace x2c=1
replace x2d=0
replace x2wc=0
replace x3=ln( 1.25 ) //0
replace x5=1
replace x10="DecC6"
replace x11=2
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2n x2w x2e x2c x2d x2wc x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob46e if sum46_scen2==100,  replace nolab

replace chosen = qmv46_scen2_c>qmv46_scen2_b & qmv46_scen2_c>qmv46_scen2_a
replace pchoice = qmv46_scen2_c
replace x1=200
replace x2n=0
replace x2w=0
replace x2e=0
replace x2c=0
replace x2d=1
replace x2wc=0
replace x3=ln( 1.5 )
replace x5=1
replace x10="DecC6"
replace x11=2
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2n x2w x2e x2c x2d x2wc x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob46f if sum46_scen2==100,  replace nolab
 

* Scenario 3
replace chosen = qmv46_scen3_a>qmv46_scen3_b & qmv46_scen3_a>qmv46_scen3_c
replace pchoice = qmv46_scen3_a
replace x1=0
replace x2n=1
replace x2w=0
replace x2e=1
replace x2c=0
replace x2d=0
replace x2wc=0
replace x3=ln( 1 )
replace x5=0
replace x10="DecC6"
replace x11=3
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2n x2w x2e x2c x2d x2wc x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob46g if sum46_scen3==100,  replace  nolab

replace chosen = qmv46_scen3_b>qmv46_scen3_c & qmv46_scen3_b>qmv46_scen3_a
replace pchoice = qmv46_scen3_b
replace x1=0.2
replace x2n=1
replace x2w=1
replace x2e=0
replace x2c=0
replace x2d=1
replace x2wc=0
replace x3=ln( 1.25 )
replace x5=1
replace x10="DecC6"
replace x11=3
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2n x2w x2e x2c x2d x2wc x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob46h if sum46_scen3==100,  replace  nolab

replace chosen = qmv46_scen3_c>qmv46_scen3_b & qmv46_scen3_c>qmv46_scen3_a
replace pchoice = qmv46_scen3_c
replace x1=200
replace x2n=0
replace x2w=0
replace x2e=0
replace x2c=1
replace x2d=0
replace x2wc=0
replace x3=ln( 1.25 )
replace x5=1
replace x10="DecC6"
replace x11=3
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2n x2w x2e x2c x2d x2wc x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob46i if sum46_scen3==100,  replace nolab


* Scenario 4
replace chosen = qmv46_scen4_a>qmv46_scen4_b & qmv46_scen4_a>qmv46_scen4_c
replace pchoice = qmv46_scen4_a
replace x1=0
replace x2n=1
replace x2w=0
replace x2e=1
replace x2c=0
replace x2d=0
replace x2wc=0
replace x3=ln( 1 )
replace x5=0
replace x10="DecC6"
replace x11=4
replace x12=1
export delimited scuid ${keepers} chosen pchoice x1 x2n x2w x2e x2c x2d x2wc x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob46j if sum46_scen4==100,  replace nolab

replace chosen = qmv46_scen4_b>qmv46_scen4_c & qmv46_scen4_b>qmv46_scen4_a
replace pchoice = qmv46_scen4_b
replace x1=0.2
replace x2n=1
replace x2w=1
replace x2e=0
replace x2c=0
replace x2d=1
replace x2wc=0
replace x3=ln( 1.1 )
replace x5=1
replace x10="DecC6"
replace x11=4
replace x12=2
export delimited scuid ${keepers} chosen pchoice x1 x2n x2w x2e x2c x2d x2wc x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob46k if sum46_scen4==100,  replace nolab

replace chosen = qmv46_scen4_c>qmv46_scen4_b & qmv46_scen4_c>qmv46_scen4_a
replace pchoice = qmv46_scen4_c
replace x1=200
replace x2n=0
replace x2w=0
replace x2e=0
replace x2c=0
replace x2d=1
replace x2wc=0
replace x3=ln( 2 )
replace x5=1
replace x10="DecC6"
replace x11=4
replace x12=3
export delimited scuid ${keepers} chosen pchoice x1 x2n x2w x2e x2c x2d x2wc x3 x5 x10 x11 x12 using ${temppath}SCEmlb_mob46l if sum46_scen4==100,  replace  nolab



** 41 
foreach letter in `alphabet' {
    import delimited using ${temppath}SCEmlb_mob41`letter', varn(1) clear case(preserve)
    rename (chosen pchoice x1 x2 x3 x5 x10 x11 x12) (chosen pchoice dist crime income moved svyblk scennum altnum)
    gen wave=2
    replace dist = dist/100
    save `m41`letter'', replace
}

** 42
foreach letter in `alphabet' {
    import delimited using ${temppath}SCEmlb_mob42`letter', varn(1) clear case(preserve)
    rename (chosen pchoice x1 x2 x3 x5 x10 x11 x12) (chosen pchoice dist schqual income moved svyblk scennum altnum)
    gen wave=2
    replace dist = dist/100
    save `m42`letter'', replace
}

** 43 
foreach letter in `alphabet' {
    import delimited using ${temppath}SCEmlb_mob43`letter', varn(1) clear case(preserve)
    rename (chosen pchoice x1 x2 x3 x5 x10 x11 x12) (chosen pchoice  dist family income moved svyblk scennum altnum)
    gen wave=2
    replace dist = dist/100
    save `m43`letter'', replace
}
** 44
foreach letter in `alphabet' {
    import delimited using ${temppath}SCEmlb_mob44`letter', varn(1) clear case(preserve)
    rename (chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12) (chosen pchoice dist norms homecost income moved svyblk scennum altnum)
    gen wave=2
    replace dist = dist/100
    save `m44`letter'', replace
}
** 45
local alphabet a b c d e f g h i j k l
foreach letter in `alphabet' {
    import delimited using ${temppath}SCEmlb_mob45`letter', varn(1) clear case(preserve)
    rename (chosen pchoice x1 x2 x3 x4 x5 x10 x11 x12) (chosen pchoice dist schqual homecost income moved svyblk scennum altnum)
    gen wave=2
    replace dist = dist/100
    save `m45`letter'', replace
}

** 46
foreach letter in `alphabet' {
    import delimited using ${temppath}SCEmlb_mob46`letter', varn(1) clear case(preserve)
    rename (chosen pchoice x1 x2n x2w x2e x2c x2d x2wc x3 x5 x10 x11 x12) (chosen pchoice dist samecity withincitymove exacthome copyhome diffhome wincitycopy income moved svyblk scennum altnum)
    gen wave=2
    replace dist = dist/100
    save `m46`letter'', replace
}


