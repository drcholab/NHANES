
use "D:/dtas/NHANES_merged_99_20.dta", clear


****** LABEL ******

label define Gender 1 "Male" 2 "Female"
label values riagendr Gender

recode ridreth1 (3=1)(4=2)(1=3)(2=3)(5=4), gen(eth)
label define Ethnicity 1 "White" 2 "Black" 3 "Hispanic" 4 "Other"
label values eth Ethnicity

recode ridreth3 (3=1)(4=2)(1=3)(2=3)(6=5)(7=6), gen(etha)
label define EthnicityA 1 "White" 2 "Black" 3 "Hispanic" 5 "Asian" 6 "The other"
label values etha EthnicityA



****** VARIABLES ******

//education level
gen edu=1 if dmdeduc2<=3 // less than college education
replace edu=2 if dmdeduc2==4 | dmdeduc2==5 // college education or more

//smoking
gen smoker=1 if smq020==2 //never
replace smoker=2 if smq020==1 & smq040==3 //past
replace smoker=3 if smq020==1 & (smq040==1 | smq040==2) //current

//alcohol intake
gen alc=1 if alq120q<366 | alq121<11
replace alc=2 if (alq120u==1 & alq120q>=2 & alq120q<366) | (alq120u==2 & alq120q>=8 & alq120q<366) | (alq120q>=100 & alq120q<366) //1999-2016 (>=2 time per week or >=8 time per month or >=100time per year)
replace alc=2 if alq121>=1 & alq121<=4 //2017-2020 (>=2 time per week)

//regular exercise (MET score>=4)
gen exc=1 if pad020!=. | paq560!=. | paq706!=. | paq605!=. //exclude missing from the first question
replace exc=2 if (paq050q>=12 & paq050q<700) | (pad120>=12 & pad120<700) | (pad460>=12 & pad460<700) | (paq560>=3 & paq560<700) //1999~2006, ≥3 times/week or ≥12 times/month
replace exc=2 if (paq610 >= 3 & paq610 <= 7) | (paq655 >= 3 & paq655 <= 7) | (paq625 >= 3 & paq625 <= 7) | (paq665 >= 3 & paq665 <= 7) | (paq640 >= 3 & paq640 <= 7) //2007~2020, ≥3 times/week

//eGFR (MDRD calculation)
gen egfr = 175*lbxscr^(-1.154)*ridageyr^(-0.203)*0.742*1.212 if riagendr == 2 & ridreth1 == 4 //female african
replace egfr = 175*lbxscr^(-1.154)*ridageyr^(-0.203)*0.742 if riagendr == 2 & ridreth1 != 4 //female non-african
replace egfr = 175*lbxscr^(-1.154)*ridageyr^(-0.203)*1.212 if riagendr == 1 & ridreth1 == 4 //male african
replace egfr = 175*lbxscr^(-1.154)*ridageyr^(-0.203) if riagendr == 1 & ridreth1 != 4 //male non-african


//COMPONENTS OF METABOLIC SYNDROME (NCEP ATP III 2005 criteria)
//waist circumference
gen wc = 0 if bmxwaist != .
replace wc = 1 if riagendr == 1 & bmxwaist >= 102 & bmxwaist != .
replace wc = 1 if riagendr == 2 & bmxwaist >= 88 & bmxwaist != .
//waist circumference cut-off points for asian
gen wc_asian = 0 if etha == 5  & bmxwaist != .
replace wc_asian = 1 if etha == 5  & riagendr == 1 & bmxwaist >= 90 & bmxwaist != .
replace wc_asian = 1 if etha == 5  & riagendr == 2 & bmxwaist >= 80 & bmxwaist != .

//triglyceride
gen tg = 0 if lbxtr != .
replace tg = 1 if lbxtr >= 150 & lbxtr != .
replace tg = 1 if bpq100d == 1 & lbxtr != . //on drug treatment 

//HDL cholesterol
gen hdl = 0 if lbdhdd != .
replace hdl = 1 if riagendr == 1 & lbdhdd < 40
replace hdl = 1 if riagendr == 2 & lbdhdd < 50
replace hdl = 1 if bpq100d == 1 & lbdhdd != . //on drug treatment 

//blood pressure
egen bpxsy_mean=rmean(bpxsy1 bpxsy2 bpxsy3 bpxsy4)
egen bpxdi_mean=rmean(bpxdi1 bpxdi2 bpxdi3 bpxdi4)
gen bp = 0 if bpxsy_mean != .
replace bp = 1 if (bpxsy_mean >= 130 & bpxsy_mean != .) | (bpxdi_mean >= 85 & bpxdi_mean != .)
replace bp = 1 if bpq050a == 1 & bpxsy_mean != . //on drug treatment 

//fasting glucose
gen fglu = 0 if lbxglu != .
replace fglu = 1 if lbxglu >= 100 & lbxglu != .
replace fglu = 1 if diq070 == 1 & lbxglu != . //on drug treatment 



//METABOLIC SYNDROME
gen metsyn = 0 if wc!=. & tg!=. & hdl!=. & bp!=. & fglu!=.
replace metsyn = 1 if metsyn==0 & (wc + tg + hdl + bp + fglu) >= 3
//METABOLIC SYNDROME for asian (waist circumference cut-off points for asian)
gen metsyn_asian = 0 if etha == 5 & wc_asian!=. & tg!=. & hdl!=. & bp!=. & fglu!=.
replace metsyn_asian = 1 if metsyn_asian==0 & (wc_asian + tg + hdl + bp + fglu) >= 3

//HYPERURICEMIA (men>7.0, women>5.7)
gen hyperuricemia=0 if lbxsua!=.
replace hyperuricemia=1 if lbxsua>7 & lbxsua!=. & riagendr == 1
replace hyperuricemia=1 if lbxsua>5.7 & lbxsua!=. & riagendr == 2

//GOUT (2007-2016)
recode mcq160n (7/9 = .)
recode mcq160n (2 = 0), generate(gout)

//KIDNEY STONE (2007-2020)
recode kiq026 (7/9 = .)
recode kiq026 (2 = 0), generate(stone)

//ASTHMA (1999-2020)
recode mcq010 (7/9 = .)
recode mcq010 (2 = 0), generate(asthma)



****** WEIGHT CALCULATION ******

//MEC212YR: 1999-2020 (21.2yr) 
gen MEC212YR = 4/21.2 * wtmec4yr if sddsrvyr == 1 | sddsrvyr == 2
replace MEC212YR = 2/21.2 * wtmec2yr if sddsrvyr > 2
replace MEC212YR = 3.2/21.2 * wtmecprp if sddsrvyr == 66

//wtmec4yr: two cycle
replace wtmec4yr=wtmec2yr/2 if sddsrvyr>2 & sddsrvyr<9
replace wtmec4yr=wtmec2yr*(2/5.2) if sddsrvyr==9
replace wtmec4yr=wtmecprp*(3.2/5.2) if sddsrvyr==66

//wtasian: 2011-2020, for asian
gen wtasian = wtmec2yr*(2/9.2) if sddsrvyr>=7 & sddsrvyr<=9
replace wtasian = wtmecprp*(3.2/9.2) if sddsrvyr==66

//wtgout: 2007-2016, for gout
gen wtgout =  wtmec2yr*(2/10) if sddsrvyr>=5 & sddsrvyr<=9




** #############################################################################################
** ############  LOGISTIC REGRESSION                                                ############
** ############  Y: hyperuricemia (men>7.0, women>5.7)                              ############
** ############  X: one component of metabolic syndrome                             ############
** ############  Model1: demographic features                                       ############
** ############  Model2: + lifestyle features                                       ############
** ############  Model3: + eGFR and all the other components of metabolic syndrome  ############
** #############################################################################################

//TOTAL POPULATION (GENDER-ADJUSTED)
svyset [w=MEC212YR], psu(sdmvpsu) strata(sdmvstra) vce(linearized)

capture drop inA
gen inA=0
replace inA=1 if sddsrvyr != . & ridageyr >= 20

tab wc hyperuricemia if inA //Count
svy, subpop(inA): tab wc hyperuricemia, row ci //Prevalence
xi: svy, subpop (inA): logistic hyperuricemia wc //Unadjusted
xi: svy, subpop (inA): logistic hyperuricemia wc i.riagendr c.ridageyr i.eth //model1
xi: svy, subpop (inA): logistic hyperuricemia wc i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc //model2

tab tg hyperuricemia if inA //Count
svy, subpop(inA): tab tg hyperuricemia, row ci //Prevalence
xi: svy, subpop (inA): logistic hyperuricemia tg //Unadjusted
xi: svy, subpop (inA): logistic hyperuricemia tg i.riagendr c.ridageyr i.eth //model1
xi: svy, subpop (inA): logistic hyperuricemia tg i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc //model2

tab hdl hyperuricemia if inA //Count
svy, subpop(inA): tab hdl hyperuricemia, row ci //Prevalence
xi: svy, subpop (inA): logistic hyperuricemia hdl //Unadjusted
xi: svy, subpop (inA): logistic hyperuricemia hdl i.riagendr c.ridageyr i.eth //model1
xi: svy, subpop (inA): logistic hyperuricemia hdl i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc //model2

tab bp hyperuricemia if inA //Count
svy, subpop(inA): tab bp hyperuricemia, row ci //Prevalence
xi: svy, subpop (inA): logistic hyperuricemia bp //Unadjusted
xi: svy, subpop (inA): logistic hyperuricemia bp i.riagendr c.ridageyr i.eth //model1
xi: svy, subpop (inA): logistic hyperuricemia bp i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc //model2

tab fglu hyperuricemia if inA //Count
svy, subpop(inA): tab fglu hyperuricemia, row ci //Prevalence
xi: svy, subpop (inA): logistic hyperuricemia fglu //Unadjusted
xi: svy, subpop (inA): logistic hyperuricemia fglu i.riagendr c.ridageyr i.eth //model1
xi: svy, subpop (inA): logistic hyperuricemia fglu i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc //model2

xi: svy, subpop (if ridageyr >= 20): logistic hyperuricemia wc tg hdl bp fglu i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr //model3





//ACCORDING TO GENDER
svyset [w=MEC212YR], psu(sdmvpsu) strata(sdmvstra) vce(linearized)

capture drop inA
gen inA=0
replace inA=1 if sddsrvyr != . & ridageyr >= 20 & riagendr == 1 //MEN: riagendr == 1  WOMEN: riagendr == 2

tab wc hyperuricemia if inA //Count
svy, subpop(inA): tab wc hyperuricemia, row ci //Prevalence
xi: svy, subpop (inA): logistic hyperuricemia wc //Unadjusted
xi: svy, subpop (inA): logistic hyperuricemia wc c.ridageyr i.eth //model1
xi: svy, subpop (inA): logistic hyperuricemia wc c.ridageyr i.eth i.edu i.smoker i.alc i.exc //model2

tab tg hyperuricemia if inA //Count
svy, subpop(inA): tab tg hyperuricemia, row ci //Prevalence
xi: svy, subpop (inA): logistic hyperuricemia tg //Unadjusted
xi: svy, subpop (inA): logistic hyperuricemia tg c.ridageyr i.eth //model1
xi: svy, subpop (inA): logistic hyperuricemia tg c.ridageyr i.eth i.edu i.smoker i.alc i.exc //model2

tab hdl hyperuricemia if inA //Count
svy, subpop(inA): tab hdl hyperuricemia, row ci //Prevalence
xi: svy, subpop (inA): logistic hyperuricemia hdl //Unadjusted
xi: svy, subpop (inA): logistic hyperuricemia hdl c.ridageyr i.eth //model1
xi: svy, subpop (inA): logistic hyperuricemia hdl c.ridageyr i.eth i.edu i.smoker i.alc i.exc //model2

tab bp hyperuricemia if inA //Count
svy, subpop(inA): tab bp hyperuricemia, row ci //Prevalence
xi: svy, subpop (inA): logistic hyperuricemia bp //Unadjusted
xi: svy, subpop (inA): logistic hyperuricemia bp c.ridageyr i.eth //model1
xi: svy, subpop (inA): logistic hyperuricemia bp c.ridageyr i.eth i.edu i.smoker i.alc i.exc //model2

tab fglu hyperuricemia if inA //Count
svy, subpop(inA): tab fglu hyperuricemia, row ci //Prevalence
xi: svy, subpop (inA): logistic hyperuricemia fglu //Unadjusted
xi: svy, subpop (inA): logistic hyperuricemia fglu c.ridageyr i.eth //model1
xi: svy, subpop (inA): logistic hyperuricemia fglu c.ridageyr i.eth i.edu i.smoker i.alc i.exc //model2

xi: svy, subpop (if ridageyr >= 20 & riagendr == 1): logistic hyperuricemia wc tg hdl bp fglu c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr //model3, MEN
xi: svy, subpop (if ridageyr >= 20 & riagendr == 2): logistic hyperuricemia wc tg hdl bp fglu c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr //model3, WOMEN





//ACCORDING TO ETNICITY
svyset [w=MEC212YR], psu(sdmvpsu) strata(sdmvstra) vce(linearized)

capture drop inA
gen inA=0
replace inA=1 if sddsrvyr != . & ridageyr >= 20 & eth == 1 // eth: 1 "White" 2 "Black" 3 "Hispanic" 4 "Other"

tab wc hyperuricemia if inA //Count
svy, subpop(inA): tab wc hyperuricemia, row ci //Prevalence
xi: svy, subpop (inA): logistic hyperuricemia wc //Unadjusted
xi: svy, subpop (inA): logistic hyperuricemia wc i.riagendr c.ridageyr //model1
xi: svy, subpop (inA): logistic hyperuricemia wc i.riagendr c.ridageyr i.edu i.smoker i.alc i.exc //model2

tab tg hyperuricemia if inA //Count
svy, subpop(inA): tab tg hyperuricemia, row ci //Prevalence
xi: svy, subpop (inA): logistic hyperuricemia tg //Unadjusted
xi: svy, subpop (inA): logistic hyperuricemia tg i.riagendr c.ridageyr //model1
xi: svy, subpop (inA): logistic hyperuricemia tg i.riagendr c.ridageyr i.edu i.smoker i.alc i.exc //model2

tab hdl hyperuricemia if inA //Count
svy, subpop(inA): tab hdl hyperuricemia, row ci //Prevalence
xi: svy, subpop (inA): logistic hyperuricemia hdl //Unadjusted
xi: svy, subpop (inA): logistic hyperuricemia hdl i.riagendr c.ridageyr //model1
xi: svy, subpop (inA): logistic hyperuricemia hdl i.riagendr c.ridageyr i.edu i.smoker i.alc i.exc //model2

tab bp hyperuricemia if inA //Count
svy, subpop(inA): tab bp hyperuricemia, row ci //Prevalence
xi: svy, subpop (inA): logistic hyperuricemia bp //Unadjusted
xi: svy, subpop (inA): logistic hyperuricemia bp i.riagendr c.ridageyr //model1
xi: svy, subpop (inA): logistic hyperuricemia bp i.riagendr c.ridageyr i.edu i.smoker i.alc i.exc //model2

tab fglu hyperuricemia if inA //Count
svy, subpop(inA): tab fglu hyperuricemia, row ci //Prevalence
xi: svy, subpop (inA): logistic hyperuricemia fglu //Unadjusted
xi: svy, subpop (inA): logistic hyperuricemia fglu i.riagendr c.ridageyr //model1
xi: svy, subpop (inA): logistic hyperuricemia fglu i.riagendr c.ridageyr i.edu i.smoker i.alc i.exc //model2

xi: svy, subpop (inA): logistic hyperuricemia wc tg hdl bp fglu i.riagendr c.ridageyr i.edu i.smoker i.alc i.exc c.egfr //model3

//ASIAN (2011-2020, different cutpoints of waist circuference)
svyset [w=wtasian], psu(sdmvpsu) strata(sdmvstra) vce(linearized)

tab wc_asian hyperuricemia if ridageyr >= 20 & etha == 5 //Count
svy, subpop(if ridageyr >= 20 & etha == 5): tab wc_asian hyperuricemia, row ci //Prevalence
xi: svy, subpop (if ridageyr >= 20 & etha == 5): logistic hyperuricemia wc_asian //Unadjusted
xi: svy, subpop (if ridageyr >= 20 & etha == 5): logistic hyperuricemia wc_asian i.riagendr c.ridageyr //model1
xi: svy, subpop (if ridageyr >= 20 & etha == 5): logistic hyperuricemia wc_asian i.riagendr c.ridageyr i.edu i.smoker i.alc i.exc //model2

tab tg hyperuricemia if ridageyr >= 20 & etha == 5 //Count
svy, subpop(if ridageyr >= 20 & etha == 5): tab tg hyperuricemia, row ci //Prevalence
xi: svy, subpop (if ridageyr >= 20 & etha == 5): logistic hyperuricemia tg //Unadjusted
xi: svy, subpop (if ridageyr >= 20 & etha == 5): logistic hyperuricemia tg i.riagendr c.ridageyr //model1
xi: svy, subpop (if ridageyr >= 20 & etha == 5): logistic hyperuricemia tg i.riagendr c.ridageyr i.edu i.smoker i.alc i.exc //model2

tab hdl hyperuricemia if ridageyr >= 20 & etha == 5 //Count
svy, subpop(if ridageyr >= 20 & etha == 5): tab hdl hyperuricemia, row ci //Prevalence
xi: svy, subpop (if ridageyr >= 20 & etha == 5): logistic hyperuricemia hdl //Unadjusted
xi: svy, subpop (if ridageyr >= 20 & etha == 5): logistic hyperuricemia hdl i.riagendr c.ridageyr //model1
xi: svy, subpop (if ridageyr >= 20 & etha == 5): logistic hyperuricemia hdl i.riagendr c.ridageyr i.edu i.smoker i.alc i.exc //model2

tab bp hyperuricemia if ridageyr >= 20 & etha == 5 //Count
svy, subpop(if ridageyr >= 20 & etha == 5): tab bp hyperuricemia, row ci //Prevalence
xi: svy, subpop (if ridageyr >= 20 & etha == 5): logistic hyperuricemia bp //Unadjusted
xi: svy, subpop (if ridageyr >= 20 & etha == 5): logistic hyperuricemia bp i.riagendr c.ridageyr //model1
xi: svy, subpop (if ridageyr >= 20 & etha == 5): logistic hyperuricemia bp i.riagendr c.ridageyr i.edu i.smoker i.alc i.exc //model2

tab fglu hyperuricemia if ridageyr >= 20 & etha == 5 //Count
svy, subpop(if ridageyr >= 20 & etha == 5): tab fglu hyperuricemia, row ci //Prevalence
xi: svy, subpop (if ridageyr >= 20 & etha == 5): logistic hyperuricemia fglu //Unadjusted
xi: svy, subpop (if ridageyr >= 20 & etha == 5): logistic hyperuricemia fglu i.riagendr c.ridageyr //model1
xi: svy, subpop (if ridageyr >= 20 & etha == 5): logistic hyperuricemia fglu i.riagendr c.ridageyr i.edu i.smoker i.alc i.exc //model2

xi: svy, subpop (if ridageyr >= 20 & etha == 5): logistic hyperuricemia wc_asian tg hdl bp fglu i.riagendr c.ridageyr i.edu i.smoker i.alc i.exc c.egfr //model3





//ACCORDING TO CYCLE
svyset [w=wtmec2yr], psu(sdmvpsu) strata(sdmvstra) vce(linearized)
xi: svy, subpop (if sddsrvyr == 1 & ridageyr >= 20): logistic hyperuricemia wc tg hdl bp fglu i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr  //model3
xi: svy, subpop (if sddsrvyr == 2 & ridageyr >= 20): logistic hyperuricemia wc tg hdl bp fglu i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr  //model3
xi: svy, subpop (if sddsrvyr == 3 & ridageyr >= 20): logistic hyperuricemia wc tg hdl bp fglu i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr  //model3
xi: svy, subpop (if sddsrvyr == 4 & ridageyr >= 20): logistic hyperuricemia wc tg hdl bp fglu i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr  //model3
xi: svy, subpop (if sddsrvyr == 5 & ridageyr >= 20): logistic hyperuricemia wc tg hdl bp fglu i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr  //model3
xi: svy, subpop (if sddsrvyr == 6 & ridageyr >= 20): logistic hyperuricemia wc tg hdl bp fglu i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr  //model3
xi: svy, subpop (if sddsrvyr == 7 & ridageyr >= 20): logistic hyperuricemia wc tg hdl bp fglu i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr  //model3
xi: svy, subpop (if sddsrvyr == 8 & ridageyr >= 20): logistic hyperuricemia wc tg hdl bp fglu i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr  //model3
xi: svy, subpop (if sddsrvyr == 9 & ridageyr >= 20): logistic hyperuricemia wc tg hdl bp fglu i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr  //model3
svyset [w=wtmecprp], psu(sdmvpsu) strata(sdmvstra) vce(linearized)
xi: svy, subpop (if sddsrvyr == 66 & ridageyr >= 20): logistic hyperuricemia wc tg hdl bp fglu i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr  //model3





//ACCORDING TO 2CYCLE
svyset [w=wtmec4yr], psu(sdmvpsu) strata(sdmvstra) vce(linearized)
xi: svy, subpop (if sddsrvyr < 3 & ridageyr >= 20): logistic hyperuricemia wc tg hdl bp fglu i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr  //model3, 1999-2002
xi: svy, subpop (if sddsrvyr < 5 & sddsrvyr >2 & ridageyr >= 20): logistic hyperuricemia wc tg hdl bp fglu i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr  //model3, 2003-2006
xi: svy, subpop (if sddsrvyr < 7 & sddsrvyr >4 & ridageyr >= 20): logistic hyperuricemia wc tg hdl bp fglu i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr  //model3, 2007-2010
xi: svy, subpop (if sddsrvyr < 9 & sddsrvyr >6 & ridageyr >= 20): logistic hyperuricemia wc tg hdl bp fglu i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr  //model3, 2011-2014
xi: svy, subpop (if sddsrvyr < 67 & sddsrvyr >8 & ridageyr >= 20): logistic hyperuricemia wc tg hdl bp fglu i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr  //model3, 2015-2020





** ############################################################################################
** ###############  LOGISTIC REGRESSION                                        ################
** ###############  Y: hyperuricemia (men>7.0, women>5.7)                      ################
** ###############  X: metabolic syndrome                                      ################
** ###############  Model3: demographic features + lifestyle features + eGFR   ################
** ############################################################################################

svyset [w=MEC212YR], psu(sdmvpsu) strata(sdmvstra) vce(linearized)
xi: svy, subpop (if ridageyr >= 20): logistic hyperuricemia metsyn i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr //model3, ALL
xi: svy, subpop (if ridageyr >= 20 & riagendr == 1): logistic hyperuricemia metsyn c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr //model3, MEN
xi: svy, subpop (if ridageyr >= 20 & riagendr == 2): logistic hyperuricemia metsyn c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr //model3, WOMEN

svyset [w=MEC212YR], psu(sdmvpsu) strata(sdmvstra) vce(linearized)
xi: svy, subpop (if ridageyr >= 20 & eth == 1): logistic hyperuricemia metsyn i.riagendr c.ridageyr i.edu i.smoker i.alc i.exc c.egfr //model3, WHITE
xi: svy, subpop (if ridageyr >= 20 & eth == 2): logistic hyperuricemia metsyn i.riagendr c.ridageyr i.edu i.smoker i.alc i.exc c.egfr //model3, BLACK
xi: svy, subpop (if ridageyr >= 20 & eth == 3): logistic hyperuricemia metsyn i.riagendr c.ridageyr i.edu i.smoker i.alc i.exc c.egfr //model3, HISPANIC
xi: svy, subpop (if ridageyr >= 20 & eth == 4): logistic hyperuricemia metsyn i.riagendr c.ridageyr i.edu i.smoker i.alc i.exc c.egfr //model3, OTHER
svyset [w=wtasian], psu(sdmvpsu) strata(sdmvstra) vce(linearized)
xi: svy, subpop (if ridageyr >= 20 & etha == 5): logistic hyperuricemia metsyn_asian i.riagendr c.ridageyr i.edu i.smoker i.alc i.exc c.egfr //model3, ASIAN

svyset [w=wtmec4yr], psu(sdmvpsu) strata(sdmvstra) vce(linearized)
xi: svy, subpop (if sddsrvyr < 3 & ridageyr >= 20): logistic hyperuricemia metsyn i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr  //model3, 1999-2002
xi: svy, subpop (if sddsrvyr < 5 & sddsrvyr >2 & ridageyr >= 20): logistic hyperuricemia metsyn i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr  //model3, 2003-2006
xi: svy, subpop (if sddsrvyr < 7 & sddsrvyr >4 & ridageyr >= 20): logistic hyperuricemia metsyn i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr  //model3, 2007-2010
xi: svy, subpop (if sddsrvyr < 9 & sddsrvyr >6 & ridageyr >= 20): logistic hyperuricemia metsyn i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr  //model3, 2011-2014
xi: svy, subpop (if sddsrvyr < 67 & sddsrvyr >8 & ridageyr >= 20): logistic hyperuricemia metsyn i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr  //model3, 2015-2020



** ############################################################################################
** ###############  LOGISTIC REGRESSION                                        ################
** ###############  Y: Gout                                                    ################
** ###############  X: one component of metabolic syndrome                     ################
** ###############  Model3: demographic features + lifestyle features + eGFR   ################
** ############################################################################################

svyset [w=wtgout], psu(sdmvpsu) strata(sdmvstra) vce(linearized)
xi: svy, subpop (if ridageyr >= 20): logistic gout c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr wc tg hdl bp fglu //model3, ALL
xi: svy, subpop (if ridageyr >= 20 & riagendr == 1): logistic gout c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr wc tg hdl bp fglu //model3, MEN
xi: svy, subpop (if ridageyr >= 20 & riagendr == 2): logistic gout c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr wc tg hdl bp fglu //model3, WOMEN


** ############################################################################################
** ###############  LOGISTIC REGRESSION                                        ################
** ###############  Y: Gout                                                    ################
** ###############  X: Metabolic syndrome                                      ################
** ###############  Model3: demographic features + lifestyle features + eGFR   ################
** ############################################################################################
svyset [w=wtgout], psu(sdmvpsu) strata(sdmvstra) vce(linearized)
xi: svy, subpop (if ridageyr >= 20): logistic gout metsyn i.riagendr c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr //model3, ALL
xi: svy, subpop (if ridageyr >= 20 & riagendr == 1): logistic gout metsyn c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr //model3, MEN
xi: svy, subpop (if ridageyr >= 20 & riagendr == 2): logistic gout metsyn c.ridageyr i.eth i.edu i.smoker i.alc i.exc c.egfr //model3, WOMEN


** ############################################################################################
** ###############  LOGISTIC REGRESSION                                        ################
** ###############  Y: Asthma                                                  ################
** ###############  X: Hyperuricemia (men>7.0, women>5.7)                      ################
** ###############  adjusted: demographic features                             ################
** ############################################################################################
svyset [w=MEC212YR], psu(sdmvpsu) strata(sdmvstra) vce(linearized)
xi: svy, subpop (if ridageyr >= 20): logistic asthma hyperuricemia i.riagendr c.ridageyr i.eth //adjusted, ALL
xi: svy, subpop (if ridageyr >= 20 & riagendr == 1): logistic asthma hyperuricemia c.ridageyr i.eth //adjusted, MEN
xi: svy, subpop (if ridageyr >= 20 & riagendr == 2): logistic asthma hyperuricemia c.ridageyr i.eth //adjusted, WOMEN

** ############################################################################################
** ###############  LOGISTIC REGRESSION                                        ################
** ###############  Y: Kidney stone                                            ################
** ###############  X: Hyperuricemia (men>7.0, women>5.7)                      ################
** ###############  adjusted: demographic features                             ################
** ############################################################################################
svyset [w=MEC212YR], psu(sdmvpsu) strata(sdmvstra) vce(linearized)
xi: svy, subpop (if ridageyr >= 20): logistic stone hyperuricemia i.riagendr c.ridageyr i.eth //adjusted, ALL
xi: svy, subpop (if ridageyr >= 20 & riagendr == 1): logistic stone hyperuricemia c.ridageyr i.eth //adjusted, MEN
xi: svy, subpop (if ridageyr >= 20 & riagendr == 2): logistic stone hyperuricemia c.ridageyr i.eth //adjusted, WOMEN

