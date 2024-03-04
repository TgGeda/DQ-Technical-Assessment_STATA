********************************************************************************
*                                                                              *
* Laterite Technical Stata Analytic Assessment:                                *
* Author ID :59710                                                             *
* Date february 16,2023                                                        *
* I am using do-file to do my analysis since it only track commands.           *
* Windows -> Do-file Editor -> new Do-file Editor                              *
*                                                                              *
*                                                                              *
********************************************************************************


*******************************************************
*   Initial options for setting up working enviroment *
*******************************************************



cls                  // clear result
clear all           //  Remove any prior data from memory
cap log c          //Close the log in case if any was open   
log using "F:\Data Analysis\Stata\DQ Technical Assessment_STATA\", replace    
version 13.0         // Set the version of Stata I am using
cd " F:\DQ Technical Assessment_STATA\datasets " // changing working space 

set memory 200m  , perm   //  Set size of memory as needed
set more off        //  Run program without showing -more-






******************************************
*   Load data & labeling                 *
******************************************
 
 

*************************************************************
*  loading and cleaning RegionA_main dataset                *
*************************************************************

import delimited "F:\DQ Technical Assessment_STATA\datasets\regionA_main.csv",clear 
     //It consistes->(13 vars, 419 obs)
 
 // cleaning regionA_main in accordance to rosterA_criteria
keep if ( find_hh == 1 & consent == 1 & children_in_hh ==1) //to obtain roster A
    //(15 observations whitch don't fulfill roaster A criteria had been deleted)
	
************************************************************************
* Saving the regionA_main dataset to accommodate the changes           *
************************************************************************
save "regionA_main_edited.csv", replace
//It consistes-> (13 vars, 404 obs)

************************************
*** importing regionA_roster data **
************************************

import delimited "F:\DQ Technical Assessment_STATA\datasets\regionA_roster.csv", clear
   // It consistes->(5 vars, 2176 obs)
   


*************************************************************
*   loading and cleaning RegionB_main dataset               *
*************************************************************
 
   
import delimited "F:\DQ Technical Assessment_STATA\datasets\regionB_main.csv", clear
     //It consistes-> (13 vars, 281 obs)
	 
*** Renaming consent1 var to consent at regionB_main.csv ****
rename consent1 consent
rename hhmembers hh_members
  *** clean regionB_main  ***
keep if ( find_hh == 1 & consent == 1 & children_in_hh ==1) 
 //->(8 observations whitch don't fulfill roaster A criteria had been deleted  )

 ** ******************************************************************** 
 *  Saving the regionB_main dataset to accommodate the changes         *
 ***********************************************************************
save "regionB_main_edited.csv", replace
     // //It consistes-> (13 vars, 273 obs)
	 
	 
************************************
*** importing regionB_roster data **
************************************

import delimited "F:\DQ Technical Assessment_STATA\datasets\regionB_roster.csv", clear  
      //->(5 vars, 1571 obs)



pwd  // where I am now
//@ F:\DQ Technical Assessment_STATA\datasets 
 


*****************************************************************
*Q1a: Labeling Data Using variables names and Variable Label    *
*****************************************************************

/*
 By Selecting ONE of the listed use directive tag1 data with tag2 data we can 
 label each dataset accordingly and save thier corrosponding version such as 
 use "regionB_main_edited.csv",clear with all tag2 and save it 
 as "regionB_main_Labeled_edited.csv ".use "regionA_main_edited.csv" 
 with all tag2 listed label cammand and save it by "regionA_main_Labeled_edited.csv"
 name. Doing the same task for each roster data too. 
 */ 
 

#################################
 ****** tag1*****
use "regionB_main_edited.csv",clear
use "regionA_main_edited.csv",clear

use "regionA_roster.csv",clear
use "regionB_roster.csv",clear
****** tag1*****
###############################

##################################
************** Tag2***************
##################################
lab var region_number "Region code"
lab var region_name "Region of residence"
lab var woreda_number "Woreda code"
lab var woreda_name "Woreda of residence"
lab var kebele_number "Kebele code"
lab var kebele_name " Kebele of residence "
lab var hhid " Respondent ID "
lab var household_head " Household head names "
lab var find_hh " If the household was found "
lab var consent " Consent to list household members "
lab var children_in_hh " If there are children under 5 in the household "
lab var parent_key " uniqueID "
lab var hh_members " Number of household members "

* saving work
save "regionA_main_Labeled_edited.csv", replace
save "regionB_main_Labeled_edited.csv", replace


lab var name_hh_member " Name of household members"
lab var relation_to_hh_head "Relationship of household member to household head"
lab var gender_hh_member " Gender of household member "
lab var age_hh_member "Age of household member"

save "regionB_roster_Labeled_edited.csv", replace
save "regionA_roster_Labeled_edited.csv", replace
 
#############################################3
*******************tag2********************
##############################################


****************************************************************************
* 	Q1b: Labeling Data Using the variables names and values labels         * 
*   simply  the values of all categorical variables                        *
****************************************************************************

lab var find_hh " If the household was found "
   /* 
->  Make a value label called find_hhl to label the values of 
 the variable find_hh */
lab def find_hhl 1 " Yes" 0 " No " 
lab val find_hh find_hhl


lab var consent " Consent to list household members "
  /* 
-> Make a value label called consentl to label the values of 
 the variable consent */
 
lab def consentl 1 " Yes" 0 " No " 
lab val consent consentl

lab var children_in_hh " If there are children under 5 in the household "
/* 
->Make a value label called children_in_hhl to label the values of 
 the variable children_in_hh */
 
lab def children_in_hhl 1 " Yes" 0 " No "
lab val children_in_hh children_in_hhl

lab var gender_hh_member " Gender of household member "
/* 
-> Make a value label called sex to label the values of 
 the variable gender_hh_member */
 
lab def sex 1 " Female" 0 " Male"
lab val gender_hh_member sex

lab var relation_to_hh_head "Relationship of household member to household head"
/* 
-> Make a value label called relation_to_hh_headl to label the values of 
 the variable relation_to_hh_head */
 
lab def relation_to_hh_headl 0 "Other non-relative" 1 "Self" 2 "Spouse" ///
 3 "Child" 4 "Adopted child" 5 "Grandchild" 6 "Niece/Nephew"           ///
 7 "Father/mother" 8 "Sister/Brother" 9 "Cousin Sister/Brother"       ///
 10 "Son/Daughter in law" 11 "Brother/Sister-in-law"                 ///
 12 "Father/Mother-in-law" 13 "Other relative"                      ///
 
lab val relation_to_hh_head relation_to_hh_headl


 ************************************************************************* ****
 * Q2: Using the “code” variable values, create a single variable for each of *
 * Region, Woreda and Kebele that displays the name but also has the code     *
 * embedded                                                                   *
 ******************************************************************************
 
 
 ************************ 
 *     For Regions      *
 ************************ 
**** For Regions****
sort region_number
by region_number : gen region_fullname = region_name + string(region_number)

 ************************ 
 *     For Woredas      *
 ************************
sort woreda_number
by woreda_number : gen woreda_fullname = woreda_name + string(woreda_number)


 ************************ 
 *     For Kebele       *
 ************************

sort kebele_number
by kebele_number : gen kebele_fullname = kebele_name + string(kebele_number)


************************************************************************* ******
* Q3: Combining the main and roster data so that we have one observation per   *
* household with all household members                                         *
********************************************************************************


******************************************+***************
* -> Appending the two main                              *
*      regionA_main_Labeled_edited.csv                   *
*             and                                        *
*      regionB_main_Labeled_edited.csv                   *
**********************************************************

use "regionA_main_Labeled_edited.csv", clear
append using "F:\DQ Technical Assessment_STATA\datasets\regionB_main_Labeled_edited.csv"
save "Two_main_Combined.csv", replace

******************************************+***************
* -> Appending the two Roster                            *
*      regionA_roster_Labeled_edited.csv                 *
*             and                                        *
*      regionB_roster_Labeled_edited.csv                 *
**********************************************************


use "regionA_roster_Labeled_edited.csv", clear
append using "F:\DQ Technical Assessment_STATA\datasets\regionB_roster_Labeled_edited.csv"
save "Two_Roster_Combined.csv", replace
use "Two_Roster_Combined.csv" , clear


use "regionB_main_Labeled_edited.csv", replace
append using "F:\DQ Technical Assessment_STATA\datasets\regionB_roster.csv"
save "all_households_Birhan_Abuhay_20230216.csv", replace

******************************************+**************
* Merging the Two appended region datasets              *
*********************************************************

use "Two_main_Combined.csv", clear
tab region
tab woreda_name
merge 1:m parent_key  using "Two_Roster_Combined.csv"
rename _merge merge_matched
save "all_households_Birhan_Abuhay_20230216.csv", replace



************************************************************************* ***** 
* Q4: At the end of listing, there were enough households with children       *
* under 3 to meet the sampling requirements. Therefore, please output another *
* dataset consisting of only the eligible households that will be interviewed *
* during data collection. In this dataset, create additional variables for    *
* the eligible child or children, i.e., their names, age and gender.          *                                   
*******************************************************************************


******************************************************************
*   Extracting households those who have children under 3        *
******************************************************************

use "all_households_Birhan_Abuhay_20230216.csv", clear
order parent_key, first
keep if ( find_hh == 1 & consent == 1 & age_hh_member < 3) 
//-> (3209 observations deleted now it has 538 obs only )

 
gen chname = name_hh_member 
 
 
 // recode age
recode age_hh_member (0 1 = 0  "0 to 1" )  ///
 (1 2 = 1 " 1 to 2 ")                  ///
( 2 3 = 2 " 2 to 3 " ) , gen( agegroups) label(agegroups)

// recode gender
egen gender = cut (gender_hh_member), group( 2 )
 
 
// I can play with by droping previous variable but I think it is enough to demo 
save "all_eligible_Birhan_Abuhay_20230216.csv", replace



************************************************************************* ***** 
* Q5: To aid the data team in drafting a data collection field plan, 
*     please extract a list of eligible households per region in .xlsx format,
*     with each kebele on a separate worksheet.                                    
*******************************************************************************
 
 use "all_eligible_Birhan_Abuhay_20230216.csv", clear
 
 by (region_name kebele_name) sort: gen new_data = _n
 compress region_name kebele_name
 by region_name kebele_name, sort : keep if region_name !=0 & kebele_name!=0
 
save "all_eligible_Birhan_Abuhay_20230216_sheet1.xlsx ", replace


//keeping only in region_name with thier kebele_name

by (region_name kebele_name) sort: gen new_data = _n
keep region name kebele_name 
save "all_eligible_Birhan_Abuhay_20230216_kebele_sheet2.xlsx ", replace


**** Thank YOU ****





