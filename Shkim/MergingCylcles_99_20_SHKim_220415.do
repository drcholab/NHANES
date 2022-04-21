** ###############################################################
** ###################  Merging each files #######################
** ##################  10cycles (1999-2020) ######################
** ###############################################################

cd "/Users/uratedynamics/Desktop/seonghwan/xpts"

ssc install fs
ssc install save12


//Demographic data
// convert xpt to dta format

import sasxport5 "DEMO.XPT", clear
save demo_99_00, replace
import sasxport5 "DEMO_B.XPT", clear
save demo_01_02, replace
import sasxport5 "DEMO_C.XPT", clear
save demo_03_04, replace
import sasxport5 "DEMO_D.XPT", clear
save demo_05_06, replace
import sasxport5 "DEMO_E.XPT", clear
save demo_07_08, replace
import sasxport5 "DEMO_F.XPT", clear
save demo_09_10, replace
import sasxport5 "DEMO_G.XPT", clear
save demo_11_12, replace
import sasxport5 "DEMO_H.XPT", clear
save demo_13_14, replace
import sasxport5 "DEMO_I.XPT", clear
save demo_15_16, replace
import sasxport5 "P_DEMO.XPT", clear
save demo_17_20, replace

// Then merge all the data sets
//ssc install fs
clear
fs "demo_*.dta"
append using `r(files)'
sort seqn

//omit the duplcates
duplicates drop

save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/demo_99_20", replace

preserve
    describe, replace
    export excel using demo_99_20.xlsx, replace
restore






// Uric Acid Data
// convert xpt to dta format

import sasxport5 "LAB18.XPT", clear
save StBiochemPro_99_00, replace
import sasxport5 "L40_B.XPT", clear
save StBiochemPro_01_02, replace
import sasxport5 "L40_C.XPT", clear
save StBiochemPro_03_04, replace
import sasxport5 "BIOPRO_D.XPT", clear
save StBiochemPro_05_06, replace
import sasxport5 "BIOPRO_E.XPT", clear
save StBiochemPro_07_08, replace
import sasxport5 "BIOPRO_F.XPT", clear
save StBiochemPro_09_10, replace
import sasxport5 "BIOPRO_G.XPT", clear
save StBiochemPro_11_12, replace
import sasxport5 "BIOPRO_H.XPT", clear
save StBiochemPro_13_14, replace
import sasxport5 "BIOPRO_I.XPT", clear
save StBiochemPro_15_16, replace
import sasxport5 "P_BIOPRO.XPT", clear
save StBiochemPro_17_20, replace

// Then merge all the data sets
//ssc install fs
clear
fs "StBiochemPro_*.dta"
append using `r(files)'

//omit the duplcates
duplicates drop
sort seqn

save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/StBiochemPro_99_20", replace

preserve
    describe, replace
    export excel using StBiochemPro_99_20.xlsx, replace
restore

// Step 1.1. Check the outlier

histogram lbxsua, normal
histogram lbdsuasi, normal
describe
summarize
mdesc lbxsua

// subsetting the file to include only sUA
keep seqn lbxsua lbxsbu
sort seqn
save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/sUA_BUN_99_20", replace





// Smoking
// convert xpt to dta format

import sasxport5 "SMQ.XPT", clear
save Smoking_99_00, replace
import sasxport5 "SMQ_B.XPT", clear
save Smoking_01_02, replace
import sasxport5 "SMQ_C.XPT", clear
save Smoking_03_04, replace
import sasxport5 "SMQ_D.XPT", clear
save Smoking_05_06, replace
import sasxport5 "SMQ_E.XPT", clear
save Smoking_07_08, replace
import sasxport5 "SMQ_F.XPT", clear
save Smoking_09_10, replace
import sasxport5 "SMQ_G.XPT", clear
save Smoking_11_12, replace
import sasxport5 "SMQ_H.XPT", clear
save Smoking_13_14, replace
import sasxport5 "SMQ_I.XPT", clear
save Smoking_15_16, replace
import sasxport5 "P_SMQ.XPT", clear
save Smoking_17_20, replace

// Then merge all the data sets
//ssc install fs
clear
fs "Smoking_*.dta"
append using `r(files)'

summarize
replace smq020 = . if smq020 == 7
replace smq020 = . if smq020 == 9
replace smq040 = . if smq040 == 7
replace smq040 = . if smq040 == 9

summarize

keep seqn smq020 smq040

save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/Smoking_99_20.dta", replace

preserve
    describe, replace
    export excel using Smoking_99_20.xlsx, replace
restore





// BloodPressure: Systolic/Diastolic
// convert xpt to dta format

import sasxport5 "BPX.XPT", clear
save BloodD_99_00, replace
import sasxport5 "BPX_B.XPT", clear
save BloodD_01_02, replace
import sasxport5 "BPX_C.XPT", clear
save BloodD_03_04, replace
import sasxport5 "BPX_D.XPT", clear
save BloodD_05_06, replace
import sasxport5 "BPX_E.XPT", clear
save BloodD_07_08, replace
import sasxport5 "BPX_F.XPT", clear
save BloodD_09_10, replace
import sasxport5 "BPX_G.XPT", clear
save BloodD_11_12, replace
import sasxport5 "BPX_H.XPT", clear
save BloodD_13_14, replace
import sasxport5 "BPX_I.XPT", clear
save BloodD_15_16, replace
import sasxport5 "P_BPXO.XPT", clear
save BloodD_17_20, replace

// Then merge all the data sets
//ssc install fs
clear
fs "BloodD*.dta"
append using `r(files)'
sort seqn
summarize

replace bpxsy1 = bpxosy1 if bpxsy1 == .
replace bpxsy2 = bpxosy2 if bpxsy2 == .
replace bpxsy3 = bpxosy3 if bpxsy3 == .

replace bpxdi1 = bpxodi1 if bpxdi1 == .
replace bpxdi2 = bpxodi2 if bpxdi2 == .
replace bpxdi3 = bpxodi3 if bpxdi3 == .

keep seqn bpxsy1 bpxsy2 bpxsy3 bpxsy4 bpxdi1 bpxdi2 bpxdi3 bpxdi4


save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/BloodD_99_20.dta", replace

preserve
    describe, replace
    export excel BloodD_99_20.xlsx, replace
restore






// BloodPressure: hypertension
// convert xpt to dta format

import sasxport5 "BPQ.XPT", clear
save BloodP_99_00, replace
import sasxport5 "BPQ_B.XPT", clear
save BloodP_01_02, replace
import sasxport5 "BPQ_C.XPT", clear
save BloodP_03_04, replace
import sasxport5 "BPQ_D.XPT", clear
save BloodP_05_06, replace
import sasxport5 "BPQ_E.XPT", clear
save BloodP_07_08, replace
import sasxport5 "BPQ_F.XPT", clear
save BloodP_09_10, replace
import sasxport5 "BPQ_G.XPT", clear
save BloodP_11_12, replace
import sasxport5 "BPQ_H.XPT", clear
save BloodP_13_14, replace
import sasxport5 "BPQ_I.XPT", clear
save BloodP_15_16, replace
import sasxport5 "P_BPQ.XPT", clear
save BloodP_17_20, replace

// Then merge all the data sets
//ssc install fs
clear
fs "BloodP_*.dta"
append using `r(files)'
sort seqn
summarize

replace bpq020 = . if bpq020 == 7
replace bpq020 = . if bpq020 == 9
replace bpq030 = . if bpq030 == 7
replace bpq030 = . if bpq030 == 9
replace bpq040a = . if bpq040a == 7
replace bpq040a = . if bpq040a == 9
replace bpq050a = . if bpq050a == 7
replace bpq050a = . if bpq050a == 9
replace bpq080 = . if bpq080 == 7
replace bpq080 = . if bpq080 == 9
replace bpq090d = . if bpq090d == 7
replace bpq090d = . if bpq090d == 9
replace bpq100d = . if bpq100d == 7
replace bpq100d = . if bpq100d == 9

summarize

keep seqn bpq020 bpq030 bpq040a bpq050a bpq080 bpq090d bpq100d

save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/BloodP_99_20.dta", replace

preserve
    describe, replace
    export excel BloodP_99_20.xlsx, replace
restore







// Diabetes
// convert xpt to dta format

import sasxport5 "DIQ.XPT", clear
save Diabetes_99_00, replace
import sasxport5 "DIQ_B.XPT", clear
save Diabetes_01_02, replace
import sasxport5 "DIQ_C.XPT", clear
save Diabetes_03_04, replace
import sasxport5 "DIQ_D.XPT", clear
save Diabetes_05_06, replace
import sasxport5 "DIQ_E.XPT", clear
save Diabetes_07_08, replace
import sasxport5 "DIQ_F.XPT", clear
save Diabetes_09_10, replace
import sasxport5 "DIQ_G.XPT", clear
save Diabetes_11_12, replace
import sasxport5 "DIQ_H.XPT", clear
save Diabetes_13_14, replace
import sasxport5 "DIQ_I.XPT", clear
save Diabetes_15_16, replace
import sasxport5 "P_DIQ.XPT", clear
save Diabetes_17_20, replace

// Then merge all the data sets
//ssc install fs
clear
fs "Diabetes_*.dta"
append using `r(files)'

summarize
replace diq070 = did070 if diq070 == .
replace diq010 = . if diq010 == 7
replace diq010 = . if diq010 == 9
replace diq050 = . if diq050 == 7
replace diq050 = . if diq050 == 9
replace diq070 = . if diq070 == 7
replace diq070 = . if diq070 == 9
summarize

keep seqn diq050 diq010 diq070

sort seqn

save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/Diabetes_99_20.dta", replace

preserve
    describe, replace
    export excel Diabetes_99_20.xlsx, replace
restore





// Body measures
// convert xpt to dta format

import sasxport5 "BMX.XPT", clear
save BodyMS_99_00, replace
import sasxport5 "BMX_B.XPT", clear
save BodyMS_01_02, replace
import sasxport5 "BMX_C.XPT", clear
save BodyMS_03_04, replace
import sasxport5 "BMX_D.XPT", clear
save BodyMS_05_06, replace
import sasxport5 "BMX_E.XPT", clear
save BodyMS_07_08, replace
import sasxport5 "BMX_F.XPT", clear
save BodyMS_09_10, replace
import sasxport5 "BMX_G.XPT", clear
save BodyMS_11_12, replace
import sasxport5 "BMX_H.XPT", clear
save BodyMS_13_14, replace
import sasxport5 "BMX_I.XPT", clear
save BodyMS_15_16, replace
import sasxport5 "P_BMX.XPT", clear
save BodyMS_17_20, replace

// Then merge all the data sets
//ssc install fs
clear
fs "BodyMS*.dta"
append using `r(files)'

//omit the duplcates
duplicates drop
sort seqn

save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/BodyMS_99_20.dta", replace

preserve
    describe, replace
    export excel using BodyMS_99_20.xlsx, replace
restore





// SerumCreatinine
// convert xpt to dta format

import sasxport5 "LAB18.XPT", clear
save Creatinine_99_00, replace
import sasxport5 "L40_B.XPT", clear
save Creatinine_01_02, replace
import sasxport5 "L40_C.XPT", clear
save Creatinine_03_04, replace
import sasxport5 "BIOPRO_D.XPT", clear
save Creatinine_05_06, replace
import sasxport5 "BIOPRO_E.XPT", clear
save Creatinine_07_08, replace
import sasxport5 "BIOPRO_F.XPT", clear
save Creatinine_09_10, replace
import sasxport5 "BIOPRO_G.XPT", clear
save Creatinine_11_12, replace
import sasxport5 "BIOPRO_H.XPT", clear
save Creatinine_13_14, replace
import sasxport5 "BIOPRO_I.XPT", clear
save Creatinine_15_16, replace
import sasxport5 "P_BIOPRO.XPT", clear
save Creatinine_17_20, replace

// Then merge all the data sets
//ssc install fs
clear
fs "Creatinine*.dta"
append using `r(files)'
sort seqn
summarize

replace lbxscr = lbdscr if lbxscr == .
keep seqn lbxscr lbdscr lbxsal lbxsgl

save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/SerumCreatinine_99_20.dta", replace

preserve
    describe, replace
    export excel using SerumCreatinine_99_20.xlsx, replace
restore





// UrinCreatinine
// convert xpt to dta format

import sasxport5 "LAB16.XPT", clear
save Creatinine_99_00, replace
import sasxport5 "L16_B.XPT", clear
save Creatinine_01_02, replace
import sasxport5 "L16_C.XPT", clear
save Creatinine_03_04, replace
import sasxport5 "ALB_CR_D.XPT", clear
save Creatinine_05_06, replace
import sasxport5 "ALB_CR_E.XPT", clear
save Creatinine_07_08, replace
import sasxport5 "ALB_CR_F.XPT", clear
save Creatinine_09_10, replace
import sasxport5 "ALB_CR_G.XPT", clear
save Creatinine_11_12, replace
import sasxport5 "ALB_CR_H.XPT", clear
save Creatinine_13_14, replace
import sasxport5 "ALB_CR_I.XPT", clear
save Creatinine_15_16, replace
import sasxport5 "P_ALB_CR.XPT", clear
save Creatinine_17_20, replace

// Then merge all the data sets
//ssc install fs
clear
fs "Creatinine*.dta"
append using `r(files)'
sort seqn
summarize

keep seqn urxuma urxucr urdact

save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/UrinCreatinine_99_20.dta", replace

preserve
    describe, replace
    export excel using UrinCreatinine_99_20.xlsx, replace
restore






// Medical condition: gout
// convert xpt to dta format

import sasxport5 "MCQ_E.XPT", clear
save gout_07_08, replace
import sasxport5 "MCQ_F.XPT", clear
save gout_09_10, replace
import sasxport5 "MCQ_G.XPT", clear
save gout_11_12, replace
import sasxport5 "MCQ_H.XPT", clear
save gout_13_14, replace
import sasxport5 "MCQ_I.XPT", clear
save gout_15_16, replace
import sasxport5 "P_MCQ.XPT", clear
save gout_17_20, replace

// Then merge all the data sets
//ssc install fs
clear
fs "gout*.dta"
append using `r(files)'
sort seqn

keep seqn mcq160n

save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/gout_07_20.dta", replace

preserve
    describe, replace
    export excel using gout_07_20.xlsx, replace
restore




// Drinking
// convert xpt to dta format

import sasxport5 "ALQ.XPT", clear
save drinking_99_00, replace
import sasxport5 "ALQ_B.XPT", clear
save drinking_01_02, replace
import sasxport5 "ALQ_C.XPT", clear
save drinking_03_04, replace
import sasxport5 "ALQ_D.XPT", clear
save drinking_05_06, replace
import sasxport5 "ALQ_E.XPT", clear
save drinking_07_08, replace
import sasxport5 "ALQ_F.XPT", clear
save drinking_09_10, replace
import sasxport5 "ALQ_G.XPT", clear
save drinking_11_12, replace
import sasxport5 "ALQ_H.XPT", clear
save drinking_13_14, replace
import sasxport5 "ALQ_I.XPT", clear
save drinking_15_16, replace
import sasxport5 "P_ALQ.XPT", clear
save drinking_17_20, replace

// Then merge all the data sets
//ssc install fs
clear
fs "drinking*.dta"
append using `r(files)'
sort seqn
summarize

save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/drinking_99_20.dta", replace

preserve
    describe, replace
    export excel using drinking_99_20.xlsx, replace
restore




// alcohol
// convert xpt to dta format

import sasxport5 "DRXIFF.XPT", clear
save IndItem_D1_99_00, replace
import sasxport5 "DRXIFF_B.XPT", clear
save IndItem_D1_01_02, replace
import sasxport5 "DR1IFF_C.XPT", clear
save IndItem_D1_03_04, replace
import sasxport5 "DR1IFF_D.XPT", clear
save IndItem_D1_05_06, replace
import sasxport5 "DR1IFF_E.XPT", clear
save IndItem_D1_07_08, replace
import sasxport5 "DR1IFF_F.XPT", clear
save IndItem_D1_09_10, replace
import sasxport5 "DR1IFF_G.XPT", clear
save IndItem_D1_11_12, replace
import sasxport5 "DR1IFF_H.XPT", clear
save IndItem_D1_13_14, replace
import sasxport5 "DR1IFF_I.XPT", clear
save IndItem_D1_15_16, replace
import sasxport5 "DR1IFF_J.XPT", clear
save IndItem_D1_17_18, replace

// Then merge all the data sets
//ssc install fs
clear
fs "IndItem_D1_*.dta"
append using `r(files)'
sort seqn

replace dr1ialco = drxialco if dr1ialco == .
keep seqn dr1ialco

save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/IndItem_D1_alcohol_99_18.dta", replace

preserve
    describe, replace
    export excel using Indi_alcohol_99_18.xlsx, replace
restore






// HDL
// convert xpt to dta format

import sasxport5 "LAB13.XPT", clear
save IndItem_HDL_99_00, replace
import sasxport5 "L13_B.XPT", clear
save IndItem_HDL_01_02, replace
import sasxport5 "L13_C.XPT", clear
save IndItem_HDL_03_04, replace
import sasxport5 "HDL_D.XPT", clear
save IndItem_HDL_05_06, replace
import sasxport5 "HDL_E.XPT", clear
save IndItem_HDL_07_08, replace
import sasxport5 "HDL_F.XPT", clear
save IndItem_HDL_09_10, replace
import sasxport5 "HDL_G.XPT", clear
save IndItem_HDL_11_12, replace
import sasxport5 "HDL_H.XPT", clear
save IndItem_HDL_13_14, replace
import sasxport5 "HDL_I.XPT", clear
save IndItem_HDL_15_16, replace
import sasxport5 "P_HDL.XPT", clear
save IndItem_HDL_17_20, replace

// Then merge all the data sets
//ssc install fs
clear
fs "IndItem_HDL_*.dta"
append using `r(files)'
sort seqn

replace lbdhdd = lbxhdd if lbdhdd == . & lbxhdd != .
replace lbdhdd = lbdhdl if lbdhdd == . & lbdhdl != .

keep seqn lbdhdd

save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/HDL_99_20.dta", replace




// TG
// convert xpt to dta format

import sasxport5 "LAB13AM.XPT", clear
save IndItem_TRIGLY_99_00, replace
import sasxport5 "L13AM_B.XPT", clear
save IndItem_TRIGLY_01_02, replace
import sasxport5 "L13AM_C.XPT", clear
save IndItem_TRIGLY_03_04, replace
import sasxport5 "TRIGLY_D.XPT", clear
save IndItem_TRIGLY_05_06, replace
import sasxport5 "TRIGLY_E.XPT", clear
save IndItem_TRIGLY_07_08, replace
import sasxport5 "TRIGLY_F.XPT", clear
save IndItem_TRIGLY_09_10, replace
import sasxport5 "TRIGLY_G.XPT", clear
save IndItem_TRIGLY_11_12, replace
import sasxport5 "TRIGLY_H.XPT", clear
save IndItem_TRIGLY_13_14, replace
import sasxport5 "TRIGLY_I.XPT", clear
save IndItem_TRIGLY_15_16, replace
import sasxport5 "P_TRIGLY.XPT", clear
save IndItem_TRIGLY_17_20, replace

// Then merge all the data sets
//ssc install fs
clear
fs "IndItem_TRIGLY_*.dta"
append using `r(files)'
sort seqn

keep seqn lbxtr

save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/TRIGLY_99_20.dta", replace






// Fasting Glucose
// convert xpt to dta format

import sasxport5 "LAB10AM.XPT", clear
save GLU_99_00, replace
import sasxport5 "L10AM_B.XPT", clear
save GLU_01_02, replace
import sasxport5 "L10AM_C.XPT", clear
save GLU_03_04, replace
import sasxport5 "GLU_D.XPT", clear
save GLU_05_06, replace
import sasxport5 "GLU_E.XPT", clear
save GLU_07_08, replace
import sasxport5 "GLU_F.XPT", clear
save GLU_09_10, replace
import sasxport5 "GLU_G.XPT", clear
save GLU_11_12, replace
import sasxport5 "GLU_H.XPT", clear
save GLU_13_14, replace
import sasxport5 "GLU_I.XPT", clear
save GLU_15_16, replace
import sasxport5 "P_GLU.XPT", clear
save GLU_17_20, replace

// Then merge all the data sets
//ssc install fs
clear
fs "GLU*.dta"
append using `r(files)'
sort seqn
summarize

keep seqn lbxglu

save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/GLU_99_20.dta", replace

preserve
    describe, replace
    export excel using GLU_99_20.xlsx, replace
restore




// Insulin
// convert xpt to dta format

import sasxport5 "LAB10AM.XPT", clear
save IndItem_INS_99_00, replace
import sasxport5 "L10AM_B.XPT", clear
save IndItem_INS_01_02, replace
import sasxport5 "L10AM_C.XPT", clear
save IndItem_INS_03_04, replace
import sasxport5 "GLU_D.XPT", clear
save IndItem_INS_05_06, replace
import sasxport5 "GLU_E.XPT", clear
save IndItem_INS_07_08, replace
import sasxport5 "GLU_F.XPT", clear
save IndItem_INS_09_10, replace
import sasxport5 "GLU_G.XPT", clear
save IndItem_INS_11_12, replace
import sasxport5 "INS_H.XPT", clear
save IndItem_INS_13_14, replace
import sasxport5 "INS_I.XPT", clear
save IndItem_INS_15_16, replace
import sasxport5 "P_INS.XPT", clear
save IndItem_INS_17_20, replace

// Then merge all the data sets
//ssc install fs
clear
fs "IndItem_INS_*.dta"
append using `r(files)'
sort seqn

keep seqn lbxin

save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/INS_99_20.dta", replace




// TotalIntake
// convert xpt to dta format

import sasxport5 "DRXTOT.XPT", clear
save TotalIntake_D1_99_00, replace
import sasxport5 "DRXTOT_B.XPT", clear
save TotalIntake_D1_01_02, replace
import sasxport5 "DR1TOT_C.XPT", clear
save TotalIntake_D1_03_04, replace
import sasxport5 "DR2TOT_C.XPT", clear
save TotalIntake_D2_03_04, replace
import sasxport5 "DR1TOT_D.XPT", clear
save TotalIntake_D1_05_06, replace
import sasxport5 "DR2TOT_D.XPT", clear
save TotalIntake_D2_05_06, replace
import sasxport5 "DR1TOT_E.XPT", clear
save TotalIntake_D1_07_08, replace
import sasxport5 "DR2TOT_E.XPT", clear
save TotalIntake_D2_07_08, replace
import sasxport5 "DR1TOT_F.XPT", clear
save TotalIntake_D1_09_10, replace
import sasxport5 "DR2TOT_F.XPT", clear
save TotalIntake_D2_09_10, replace
import sasxport5 "DR1TOT_G.XPT", clear
save TotalIntake_D1_11_12, replace
import sasxport5 "DR2TOT_G.XPT", clear
save TotalIntake_D2_11_12, replace
import sasxport5 "DR1TOT_H.XPT", clear
save TotalIntake_D1_13_14, replace
import sasxport5 "DR2TOT_H.XPT", clear
save TotalIntake_D2_13_14, replace
import sasxport5 "DR1TOT_I.XPT", clear
save TotalIntake_D1_15_16, replace
import sasxport5 "DR2TOT_I.XPT", clear
save TotalIntake_D2_15_16, replace
import sasxport5 "DR1TOT_J.XPT", clear
save TotalIntake_D1_17_18, replace
import sasxport5 "DR2TOT_J.XPT", clear
save TotalIntake_D2_17_18, replace

// Then merge all the data sets
//ssc install fs
clear
fs "TotalIntake_D1_*.dta"
append using `r(files)'
sort seqn
save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/TotalIntake_D1_99_18.dta", replace

// Then merge all the data sets
//ssc install fs
clear
fs "TotalIntake_D2_*.dta"
append using `r(files)'
sort seqn
save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/TotalIntake_D2_99_18.dta", replace





// Asthma
// convert xpt to dta format

import sasxport5 "MCQ.XPT", clear
save asthma_99_00, replace
import sasxport5 "MCQ_B.XPT", clear
save asthma_01_02, replace
import sasxport5 "MCQ_C.XPT", clear
save asthma_03_04, replace
import sasxport5 "MCQ_D.XPT", clear
save asthma_05_06, replace
import sasxport5 "MCQ_E.XPT", clear
save asthma_07_08, replace
import sasxport5 "MCQ_F.XPT", clear
save asthma_09_10, replace
import sasxport5 "MCQ_G.XPT", clear
save asthma_11_12, replace
import sasxport5 "MCQ_H.XPT", clear
save asthma_13_14, replace
import sasxport5 "MCQ_I.XPT", clear
save asthma_15_16, replace
import sasxport5 "P_MCQ.XPT", clear
save asthma_17_20, replace

// Then merge all the data sets
//ssc install fs
clear
fs "asthma*.dta"
append using `r(files)'
sort seqn

keep seqn mcq010

save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/asthma_99_20.dta", replace

preserve
    describe, replace
    export excel using asthma_99_20.xlsx, replace
restore






// Kidney Stone
// convert xpt to dta format

import sasxport5 "KIQ_U_E.XPT", clear
save kidneystone_07_08, replace
import sasxport5 "KIQ_U_F.XPT", clear
save kidneystone_09_10, replace
import sasxport5 "KIQ_U_G.XPT", clear
save kidneystone_11_12, replace
import sasxport5 "KIQ_U_H.XPT", clear
save kidneystone_13_14, replace
import sasxport5 "KIQ_U_I.XPT", clear
save kidneystone_15_16, replace
import sasxport5 "P_KIQ_U.XPT", clear
save kidneystone_17_20, replace

// Then merge all the data sets
//ssc install fs
clear
fs "kidneystone*.dta"
append using `r(files)'
sort seqn

keep seqn kiq026

save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/kidneystone_07_20.dta", replace

preserve
    describe, replace
    export excel using kidneystone_07_20.xlsx, replace
restore





// Prostate
// convert xpt to dta format

import sasxport5 "KIQ_P_B.XPT", clear
save prostate_01_02, replace
import sasxport5 "KIQ_P_C.XPT", clear
save prostate_03_04, replace
import sasxport5 "KIQ_P_D.XPT", clear
save prostate_05_06, replace
import sasxport5 "KIQ_P_E.XPT", clear
save prostate_07_08, replace

// Then merge all the data sets
//ssc install fs
clear
fs "prostate*.dta"
append using `r(files)'
sort seqn

replace kiq490 = kiq106 if kiq490 == .
keep seqn kiq081 kiq101 kiq490 kiq121 kiq141

save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/prostate_01_08.dta", replace

preserve
    describe, replace
    export excel using prostate_01_08.xlsx, replace
restore





// PSA
// convert xpt to dta format

import sasxport5 "L11PSA_B.XPT", clear
save psa_01_02, replace
import sasxport5 "L11PSA_C.XPT", clear
drop kid221
save psa_03_04, replace
import sasxport5 "PSA_D.XPT", clear
drop kid221
save psa_05_06, replace
import sasxport5 "PSA_E.XPT", clear
save psa_07_08, replace
import sasxport5 "PSA_F.XPT", clear
save psa_09_10, replace

// Then merge all the data sets
//ssc install fs
clear
fs "psa*.dta"
append using `r(files)'
sort seqn

keep seqn lbxp1 lbxp2 lbdp3

save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/psa_01_10.dta", replace

preserve
    describe, replace
    export excel using psa_01_10.xlsx, replace
restore




//Physical activity
// convert xpt to dta format

import sasxport5 "PAQ.XPT", clear
save physicalactivity_99_00, replace
import sasxport5 "PAQ_B.XPT", clear
save physicalactivity_01_02, replace
import sasxport5 "PAQ_C.XPT", clear
save physicalactivity_03_04, replace
import sasxport5 "PAQ_D.XPT", clear
save physicalactivity_05_06, replace
import sasxport5 "PAQ_E.XPT", clear
save physicalactivity_07_08, replace
import sasxport5 "PAQ_F.XPT", clear
save physicalactivity_09_10, replace
import sasxport5 "PAQ_G.XPT", clear
save physicalactivity_11_12, replace
import sasxport5 "PAQ_H.XPT", clear
save physicalactivity_13_14, replace
import sasxport5 "PAQ_I.XPT", clear
save physicalactivity_15_16, replace
import sasxport5 "P_PAQ.XPT", clear
save physicalactivity_17_20, replace

// Then merge all the data sets
//ssc install fs
clear
fs "physicalactivity*.dta"
append using `r(files)'
sort seqn

save12 "/Users/uratedynamics/Desktop/seonghwan/dtas/physicalactivity_99_20.dta", replace






** ###############################################################
** ################  Merging different cycles ####################
** ##################  10cycles (1999-2020) ######################
** ###############################################################

cd "/Users/uratedynamics/Desktop/seonghwan/dtas"

use "demo_99_20.dta", replace

merge 1:m seqn using sUA_BUN_99_20.dta
duplicates drop

drop _merge
merge 1:m seqn using Smoking_99_20.dta
duplicates drop

drop _merge
merge 1:m seqn using BloodP_99_20.dta
duplicates drop

drop _merge
merge 1:m seqn using BloodD_99_20.dta
duplicates drop

drop _merge
merge 1:m seqn using drinking_99_20.dta
duplicates drop

drop _merge
merge 1:m seqn using Diabetes_99_20.dta
duplicates drop

drop _merge
merge 1:m seqn using BodyMS_99_20.dta
duplicates drop

drop _merge
merge 1:m seqn using SerumCreatinine_99_20.dta
duplicates drop

drop _merge
merge 1:m seqn using UrinCreatinine_99_20.dta
duplicates drop

drop _merge
merge 1:m seqn using GLU_99_20.dta
duplicates drop

drop _merge
merge 1:m seqn using gout_07_20.dta
duplicates drop

drop _merge
merge 1:m seqn using TRIGLY_99_20.dta
duplicates drop

drop _merge
merge 1:m seqn using HDL_99_20.dta
duplicates drop

drop _merge
merge 1:m seqn using INS_99_20.dta
duplicates drop

drop _merge
merge 1:m seqn using asthma_99_20.dta
duplicates drop

drop _merge
merge 1:m seqn using kidneystone_07_20.dta
duplicates drop

drop _merge
merge 1:m seqn using prostate_01_08.dta
duplicates drop

drop _merge
merge 1:m seqn using psa_01_10.dta
duplicates drop

drop _merge

codebook seqn // n = 107,622

save12 NHANES_merged_99_20, replace



