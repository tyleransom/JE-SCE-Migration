* only use repeat respondents  
drop if respondent !=2

* drop those missing demographics
drop if mi(q33) | mi(qmv12)

* Reasons to stay/move
lab def vlimport 1 "Not at all important" 2 "A little important" 3 "Somewhat important" 4 "Very important" 5 "Extremely important"
* qmv10= reasons for not moving
lab var qmv10_1  "Stay: Like current home" 
lab var qmv10_2  "Stay: Can't afford cost of moving" 
lab var qmv10_3  "Stay: Can't afford to buy home in places I want to move to" 
lab var qmv10_4  "Stay: Difficult to find a new place to move into" 
lab var qmv10_5  "Stay: Current mortgage is underwater" 
lab var qmv10_6  "Stay: Current interest rate very low" 
lab var qmv10_7  "Stay: Difficult to qualify for new mortgage" 
lab var qmv10_8  "Stay: Like current job" 
lab var qmv10_9  "Stay: Hard to find job elsewhere" 
lab var qmv10_10 "Stay: Hard for spouse to find job elsewhere"
lab var qmv10_11 "Stay: Not licensed to work in other states" 
lab var qmv10_12 "Stay: Work experience would be less valuable elsewhere" 
lab var qmv10_13 "Stay: May lose Medicaid coverage" 
lab var qmv10_14 "Stay: May lose UI / other welfare benefits" 
lab var qmv10_15 "Stay: Financially dependent on local network (family, friends, church, etc.)" 
lab var qmv10_16 "Stay: Too much student debt" 
lab var qmv10_17 "Stay: Too much other debts / haven't saved enough" 
lab var qmv10_18 "Stay: Health reasons" 
lab var qmv10_19 "Stay: Children in school" 
lab var qmv10_20 "Stay: Good quality local schools" 
lab var qmv10_21 "Stay: Close to family / children" 
lab var qmv10_22 "Stay: Like current neighborhood / climate" 
lab var qmv10_23 "Stay: Involved in local community / church / share local values"
lab var qmv10_24 "Stay: Worry about high crime rates elsewhere" 
lab val qmv10_1  vlimport  
lab val qmv10_2  vlimport  
lab val qmv10_3  vlimport  
lab val qmv10_4  vlimport  
lab val qmv10_5  vlimport 
lab val qmv10_6  vlimport 
lab val qmv10_7  vlimport 
lab val qmv10_8  vlimport 
lab val qmv10_9  vlimport 
lab val qmv10_10 vlimport  
lab val qmv10_11 vlimport 
lab val qmv10_12 vlimport 
lab val qmv10_13 vlimport 
lab val qmv10_14 vlimport 
lab val qmv10_15 vlimport 
lab val qmv10_16 vlimport 
lab val qmv10_17 vlimport 
lab val qmv10_18 vlimport 
lab val qmv10_19 vlimport 
lab val qmv10_20 vlimport 
lab val qmv10_21 vlimport 
lab val qmv10_22 vlimport 
lab val qmv10_23 vlimport 
lab val qmv10_24 vlimport 
sum qmv10_1  [w=rim_4_original],d 
sum qmv10_2  [w=rim_4_original],d
sum qmv10_3  [w=rim_4_original],d
sum qmv10_4  [w=rim_4_original],d
sum qmv10_5  [w=rim_4_original],d
sum qmv10_6  [w=rim_4_original],d
sum qmv10_7  [w=rim_4_original],d
sum qmv10_8  [w=rim_4_original],d
sum qmv10_9  [w=rim_4_original],d
sum qmv10_10 [w=rim_4_original],d // TR: this one has tons of missing values because it was conditional on being married
sum qmv10_11 [w=rim_4_original],d
sum qmv10_12 [w=rim_4_original],d
sum qmv10_13 [w=rim_4_original],d
sum qmv10_14 [w=rim_4_original],d
sum qmv10_15 [w=rim_4_original],d
sum qmv10_16 [w=rim_4_original],d
sum qmv10_17 [w=rim_4_original],d
sum qmv10_18 [w=rim_4_original],d
sum qmv10_19 [w=rim_4_original],d
sum qmv10_20 [w=rim_4_original],d
sum qmv10_21 [w=rim_4_original],d
sum qmv10_22 [w=rim_4_original],d
sum qmv10_23 [w=rim_4_original],d
sum qmv10_24 [w=rim_4_original],d

* qmv11= reasons for moving
lab var qmv11_1  "Move: Expect to be evicted"
lab var qmv11_2  "Move: Don't like current home"
lab var qmv11_3  "Move: Upgrade to larger/better home"
lab var qmv11_4  "Move: Reduce housing costs"
lab var qmv11_5  "Move: Change ownership status (either direction)"
lab var qmv11_6  "Move: New job/job transfer"
lab var qmv11_7  "Move: New job/job transfer of spouse/partner"
lab var qmv11_8  "Move: Attend an educational institution"
lab var qmv11_9  "Move: Reduce commuting"
lab var qmv11_10 "Move: Look for a job"
lab var qmv11_11 "Move: Work experience would be more valuable elsewhere"
lab var qmv11_12 "Move: May gain Medicaid coverage"
lab var qmv11_13 "Move: May gain UI / other welfare benefits" 
lab var qmv11_14 "Move: Change in household / family size (any reason)"
lab var qmv11_15 "Move: Crowding, conflict, or violence in the household"
lab var qmv11_16 "Move: Health reasons"
lab var qmv11_17 "Move: Too much student debt"
lab var qmv11_18 "Move: Too much other debts"
lab var qmv11_19 "Move: Want to be closer to family / friends (any reason)"
lab var qmv11_20 "Move: Want more desirable neighborhood / climate"
lab var qmv11_21 "Move: Want a safer neighborhood"
lab var qmv11_22 "Move: Want better schools"
lab var qmv11_23 "Move: Want better access to public transportation"
lab var qmv11_24 "Move: Want access to public services (libraries, playgrounds, etc.)"
lab var qmv11_25 "Move: Want better access to amenities (restaurants, theaters, shopping, etc.)"
lab var qmv11_26 "Move: Cultural values in other places are too different"
lab val qmv11_1  vlimport
lab val qmv11_2  vlimport
lab val qmv11_3  vlimport
lab val qmv11_4  vlimport
lab val qmv11_5  vlimport
lab val qmv11_6  vlimport
lab val qmv11_7  vlimport
lab val qmv11_8  vlimport
lab val qmv11_9  vlimport
lab val qmv11_10 vlimport
lab val qmv11_11 vlimport
lab val qmv11_12 vlimport
lab val qmv11_13 vlimport
lab val qmv11_14 vlimport
lab val qmv11_15 vlimport
lab val qmv11_16 vlimport
lab val qmv11_17 vlimport
lab val qmv11_18 vlimport
lab val qmv11_19 vlimport
lab val qmv11_20 vlimport
lab val qmv11_21 vlimport
lab val qmv11_22 vlimport
lab val qmv11_23 vlimport
lab val qmv11_24 vlimport
lab val qmv11_25 vlimport
lab val qmv11_26 vlimport
sum qmv11_1  [w=rim_4_original],d
sum qmv11_2  [w=rim_4_original],d
sum qmv11_3  [w=rim_4_original],d
sum qmv11_4  [w=rim_4_original],d
sum qmv11_5  [w=rim_4_original],d
sum qmv11_6  [w=rim_4_original],d
sum qmv11_7  [w=rim_4_original],d // TR: this one has tons of missing values because it was conditional on being married
sum qmv11_8  [w=rim_4_original],d
sum qmv11_9  [w=rim_4_original],d
sum qmv11_10 [w=rim_4_original],d
sum qmv11_11 [w=rim_4_original],d
sum qmv11_12 [w=rim_4_original],d
sum qmv11_13 [w=rim_4_original],d
sum qmv11_14 [w=rim_4_original],d
sum qmv11_15 [w=rim_4_original],d
sum qmv11_16 [w=rim_4_original],d
sum qmv11_17 [w=rim_4_original],d
sum qmv11_18 [w=rim_4_original],d
sum qmv11_19 [w=rim_4_original],d
sum qmv11_20 [w=rim_4_original],d
sum qmv11_21 [w=rim_4_original],d
sum qmv11_22 [w=rim_4_original],d
sum qmv11_23 [w=rim_4_original],d
sum qmv11_24 [w=rim_4_original],d
sum qmv11_25 [w=rim_4_original],d
sum qmv11_26 [w=rim_4_original],d

