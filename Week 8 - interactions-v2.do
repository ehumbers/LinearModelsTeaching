**Discussion Week 8 - Interactions Review

*Load data
use http://www.ats.ucla.edu/stat/data/hsbdemo, clear

*DUMMY BY DUMMY

*Lets take a look at our data
sum math read female honors write socst

*Check out our reading and math scores on a histogram
hist read
hist math
*If you want to overlay a normal curve, add
hist read, normal
hist math, normal

*There are two ways to call interactions in Stata

*First you can use ##
regress read female##honors
*Interpret the coefficients

*Alternatively you can create your own interaction term
gen femalehonors = 0
replace femalehonors = 1 if female == 1 & honors == 1

*When you make your own interaction, remember to include the main effects (female and honors separately)
regress read female honors  femalehonors
*You should get the same results as ##

*Compare results of interaction with model where you make four dummies for the female/honors categories
*female honors - already created above
*female no honors
gen femnohon = 0
replace femnohon=1 if female==1 & honors==0
*male honors
gen malehon = 0
replace malehon=1 if female==0 & honors ==1
*male no honors
gen malenohon =0
replace malenohon=1 if female==0 & honors == 0

*run regression
regress read femalehonors femnohon malehon
*leave off a group to avoid perfect collinearity, males no honors is reference group

*DUMMY BY CONTINUOUS
*When you use ## with continuous variables, you need to include c. before the var name
regress write female##c.socst
*Interpret the coefficients
*What would be your null hypothesis of the interaction term?
	
*Bonus Stata note (admittedly a command I haven't used much)
*Use stata to calculate the different slopes for males and females
margins female, dydx(socst)
*Margins command: The margins command estimates margins of responses for specified values
*of covariates and presents the results as a table. Run after your regression
*Stata manual for margins command: https://www.stata.com/help.cgi?margins
*Description of dydx from manual: dydx calculate derivatives and integrals of numeric “functions”.

*You may also see this way of looking at different slopes bt groups
sort female
by female: regress write socst
*Caveat: Here though you're running on subsamples so you have different sample sizes, different R squares, etc. 

*Graphing the results helps to visualize
twoway (scatter write socst) ///
       (lfit write socst if ~female)(lfit write socst if female), ///
       legend(order(2 "male" 3 "female"))
*Why would we expect the line for female to be above the line for male?


*CONTINUOUS BY CONTINUOUS
*Significant cont x cont interaction means the slope of one continuous variable 
*on the response variable changes as the values on a second continuous change
*"If we want to ask, “What is the effect of X1 on Y”, the answer is “It depends on what X2 equals.”

regress read c.math##c.socst

*Take a look at the changes in the math slope for different values of socst
margins, dydx(math) at(socst=(30(5)75)) 
*socst=(30(5)75) indicates we want to return slopes for socst values bt 30 and 75, in 5 unit intervals


*Multiple interactions in one model: 
**Here is an overview if you plan to do this in your final project
*http://stats.idre.ucla.edu/stata/faq/how-can-i-use-the-margins-command-to-understand-multiple-interactions-in-regression-and-anova-stata-11/
