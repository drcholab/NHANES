////////////////////////////////////////////////////////
// Stata code to replicate tables of the paper below.
//
// Hirode G, Wong RJ. Trends in the Prevalence of Metabolic Syndrome in the United States, 2011-2016. JAMA. 2020
// Chen-Xu M, Yokose C, Rai SK, Pillinger MH, Choi HK. Contemporary Prevalence of Gout and Hyperuricemia in the United States and Decadal Trends: The National Health and Nutrition Examination Survey, 2007-2016. Arthritis Rheumatol. 2019
/////////////////////////////////////////////////////////

use "D:/dtas/NHANES_merged_99_20.dta", clear

** Create a new variable with age categories **
recode ridageyr (0/19 = .) (20/39 = 1) (40/59 = 2) (60/79 = 3) (80/200 = 4), generate(Age_Group)
recode ridageyr (0/19 = .) (20/39 = 1) (40/59 = 2) (60/200 = 3), generate(Age_Group2)


** Labels for categorized variables **
label define Gender_Labels 1 "Male" 2 "Female"
label values riagendr Gender_Labels

label define Age_Labels 1 "20-39" 2 "40-59" 3 "60-79" 4 "80+"
label values Age_Group Age_Labels

recode ridreth1 (3=1)(4=2)(1=3)(2=3)(5=4)
label define Ethnicity 1 "White" 2 "Black" 3 "Hispanic" 4 "Other"
label values ridreth1 Ethnicity

recode ridreth3 (3=1)(4=2)(1=3)(2=3)(6=5)(7=6)
label define EthnicityA 1 "White" 2 "Black" 3 "Hispanic" 5 "Asian" 6 "The other"
label values ridreth3 EthnicityA



//////////////////////  PREVALENCE OF GOUT  /////////////////////////
//////////////////////      2015-2016       /////////////////////////

recode mcq160n (7/9 = .)
recode mcq160n (1 = 100) (2 = 0), generate(gout100)

gen inanalysis=0
replace inanalysis=1 if sddsrvyr ==9 & !missing(mcq160n)

svyset [w=wtint2yr], psu(sdmvpsu) strata(sdmvstra) vce(linearized) //wtint2yr or wtmec2yr

svy, subpop(inanalysis): mean gout100
svy, subpop(inanalysis): mean gout100, over(riagendr)
svy, subpop(inanalysis): mean gout100, over(Age_Group)
svy, subpop(inanalysis): mean gout100, over(ridreth1)
svy, subpop(inanalysis): mean gout100, over(ridreth3)



//////////////////////  PREVALENCE OF HYPERURICEMIA  /////////////////////////
//////////////////////  MEAN SERUM URIC ACID LEVEL  /////////////////////////
//////////////////////          2015-2016          /////////////////////////

gen hyperuricemia=0 if lbxsua!=.
replace hyperuricemia=100 if lbxsua>7 & lbxsua!=. & riagendr == 1
replace hyperuricemia=100 if lbxsua>5.7 & lbxsua!=. & riagendr == 2

gen inua=0
replace inua=1 if sddsrvyr == 9 & !missing(hyperuricemia) // add [& !missing(mcq160n)] to exclude missing of mcq160n.

svyset [w=wtmec2yr], psu(sdmvpsu) strata(sdmvstra) vce(linearized)

svy, subpop(inua): mean hyperuricemia
svy, subpop(inua): mean hyperuricemia, over(riagendr)
svy, subpop(inua): mean hyperuricemia, over(Age_Group)
svy, subpop(inua): mean hyperuricemia, over(ridreth1)
svy, subpop(inua): mean hyperuricemia, over(ridreth3)


svy, subpop(inua): mean lbxsua
svy, subpop(inua): mean lbxsua, over(riagendr)
svy, subpop(inua): mean lbxsua, over(Age_Group)
svy, subpop(inua): mean lbxsua, over(ridreth1)
svy, subpop(inua): mean lbxsua, over(ridreth3)




//////////////////////  PREVALENCE OF METABOLIC SYNDROME  ////////////////////////////
//////////////////////             2015-2016               /////////////////////////



**********  DROP IF ONE OF THE FIVE COMPONENTS OF METABOLIC SYNDROME IS NOT MEASURED **********

capture drop bpxsy_mean bpxdi_mean wc hdl tg bp fglu metsyn inA

egen bpxsy_mean=rmean(bpxsy1 bpxsy2 bpxsy3 bpxsy4)
egen bpxdi_mean=rmean(bpxdi1 bpxdi2 bpxdi3 bpxdi4)

drop if bmxwaist == . | lbdhdd == . | lbxtr == . | lbxglu == . | bpxsy_mean == . | bpxdi_mean == .

gen wc = 0
replace wc = 1 if riagendr == 1 & bmxwaist >= 102
replace wc = 1 if riagendr == 2 & bmxwaist >= 88

gen hdl = 0
replace hdl = 1 if riagendr == 1 & lbdhdd < 40
replace hdl = 1 if riagendr == 2 & lbdhdd < 50
replace hdl = 1 if bpq100d == 1

gen tg = 0
replace tg = 1 if lbxtr >= 150
replace tg = 1 if bpq100d == 1

gen fglu = 0
replace fglu = 1 if lbxglu >= 100
replace fglu = 1 if diq070 == 1

gen bp = 0 
replace bp = 1 if bpxsy_mean >= 130 | bpxdi_mean >= 85
replace bp = 1 if bpq050a == 1

gen metsyn = 0
replace metsyn = 100 if (hdl + tg + wc + bp + fglu) >= 3

gen inA=0
replace inA=1 if sddsrvyr ==9 & ridageyr>=20

svyset [w=wtmec2yr], psu(sdmvpsu) strata(sdmvstra) vce(linearized)

svy, subpop(inA): mean metsyn // 47.8%
svy, subpop(inA): mean metsyn, over(riagendr)
svy, subpop(inA): mean metsyn, over(Age_Group2)
svy, subpop(inA): mean metsyn, over(ridreth1)
replace wc = 1 if ridreth3 == 5 & riagendr == 1 & bmxwaist >= 90  //waist circumference cut-off points for asian men
replace wc = 1 if ridreth3 == 5 & riagendr == 2 & bmxwaist >= 80  //waist circumference cut-off points for asian women
svy, subpop(inA): mean metsyn, over(ridreth3)



 


**********  NO DROP  **********

capture drop bpxsy_mean bpxdi_mean wc hdl tg bp fglu metsyn inA

gen wc = 0 
replace wc = 1 if riagendr == 1 & bmxwaist >= 102 & bmxwaist != .
replace wc = 1 if riagendr == 2 & bmxwaist >= 88 & bmxwaist != .

gen hdl = 0 
replace hdl = 1 if riagendr == 1 & lbdhdd < 40 & lbdhdd != .
replace hdl = 1 if riagendr == 2 & lbdhdd < 50 & lbdhdd != .
replace hdl = 1 if bpq100d == 1

gen tg = 0 
replace tg = 1 if lbxtr >= 150 & lbxtr != . 
replace tg = 1 if bpq100d == 1

gen fglu = 0
replace fglu = 1 if lbxglu >= 100 & lbxglu != .
replace fglu = 1 if diq070 == 1

egen bpxsy_mean=rmean(bpxsy1 bpxsy2 bpxsy3 bpxsy4)
egen bpxdi_mean=rmean(bpxdi1 bpxdi2 bpxdi3 bpxdi4)
gen bp = 0
replace bp = 1 if (bpxsy_mean >= 130 & bpxsy_mean != .) | (bpxdi_mean >= 85 & bpxdi_mean != .)
replace bp = 1 if bpq050a == 1

gen metsyn = 0 
replace metsyn = 100 if (wc + tg + hdl + bp + fglu) >= 3

gen inA=0
replace inA=1 if sddsrvyr ==9 & ridageyr >= 20

svyset [w=wtmec2yr], psu(sdmvpsu) strata(sdmvstra) vce(linearized)
svy, subpop(inA): mean metsyn  //33.73%
svy, subpop(inA): mean metsyn, over(riagendr)
svy, subpop(inA): mean metsyn, over(Age_Group2)
svy, subpop(inA): mean metsyn, over(ridreth1)
replace wc = 1 if ridreth3 == 5 & riagendr == 1 & bmxwaist >= 90  //waist circumference cut-off points for asian men
replace wc = 1 if ridreth3 == 5 & riagendr == 2 & bmxwaist >= 80  //waist circumference cut-off points for asian women
svy, subpop(inA): mean metsyn, over(ridreth3)




**********  NO DROP  **********
**********  bpq090d INSTEAD OF bpq100d  **********

capture drop bpxsy_mean bpxdi_mean wc hdl tg bp fglu metsyn inA

gen wc = 0 
replace wc = 1 if riagendr == 1 & bmxwaist >= 102 & bmxwaist != .
replace wc = 1 if riagendr == 2 & bmxwaist >= 88 & bmxwaist != .

gen hdl = 0 
replace hdl = 1 if riagendr == 1 & lbdhdd < 40 & lbdhdd != .
replace hdl = 1 if riagendr == 2 & lbdhdd < 50 & lbdhdd != .
replace hdl = 1 if bpq090d == 1

gen tg = 0 
replace tg = 1 if lbxtr >= 150 & lbxtr != . 
replace tg = 1 if bpq090d == 1

gen fglu = 0
replace fglu = 1 if lbxglu >= 100 & lbxglu != .
replace fglu = 1 if diq070 == 1

egen bpxsy_mean=rmean(bpxsy1 bpxsy2 bpxsy3 bpxsy4)
egen bpxdi_mean=rmean(bpxdi1 bpxdi2 bpxdi3 bpxdi4)
gen bp = 0
replace bp = 1 if (bpxsy_mean >= 130 & bpxsy_mean != .) | (bpxdi_mean >= 85 & bpxdi_mean <.)
replace bp = 1 if bpq050a == 1

gen metsyn = 0 
replace metsyn = 100 if (wc + tg + hdl + bp + fglu) >= 3

gen inA=0
replace inA=1 if sddsrvyr ==9 & ridageyr >= 20

svyset [w=wtmec2yr], psu(sdmvpsu) strata(sdmvstra) vce(linearized)
svy, subpop(inA): mean metsyn  //37.07%
svy, subpop(inA): mean metsyn, over(riagendr)
svy, subpop(inA): mean metsyn, over(Age_Group2)
svy, subpop(inA): mean metsyn, over(ridreth1)
replace wc = 1 if ridreth3 == 5 & riagendr == 1 & bmxwaist >= 90  //waist circumference cut-off points for asian men
replace wc = 1 if ridreth3 == 5 & riagendr == 2 & bmxwaist >= 80  //waist circumference cut-off points for asian women
svy, subpop(inA): mean metsyn, over(ridreth3)



