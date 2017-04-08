*Load data

use "/Users/HomelandofLiz/Box Sync/SP17 - Linear Models/JBW files/Data/WAGE2.DTA"

*LOG VARIABLES EXAMPLE

****Log Dependent Variable

*Create a log term of wage
gen logwage = log(wage)
*note - the data set already has this variable generated (lwage) but this is practice. 

*Check y distribution of logged vs unlogged outcome
hist wage, normal
hist logwage, normal
*Which better fits the normal curve? 

*Another way to evaluate whether to use a log is to compare residuals of unlogged and logged regression

*Unlogged
regress wage IQ exper
*Save the residuals
predict uhat, residual
*Inspect the residual distribution
hist uhat, normal

*Logged
regress logwage IQ exper
*Save residuals
predict loguhat, residuals
*Inspect the resideal distribution
hist loguhat, normal
*Which better fits the normality assumption?

*How would you intrepret the coefficient of IQ?
*A  1 unit increase in IQ, predicts a 100?.009 percent change in wages, accounting for exper”
*NOTE: Percent change is a close approximation if coef small (< ~.1 or .2),
* otherwise change in y = 100*((exp^beta)-1) see Wooldridge 6.2


****Log Dependent and Covariate

*What if we have a log of a coefficient too
*(note - this is for intrepretation practice, logging IQ isn't a standard practice)

*Before logging IQ, check for 0 or negative values
tab IQ

*Log IQ
gen logIQ = log(IQ)

*Regression
regress logwage logIQ exper

*How would you intrepret IQ now?
*if IQ is changed by one percent, we’d predict wage to change by ?1 percent

****Log Only Covariate
regress wage logIQ exper

*How would you intrepret IQ
*If we increase IQ by one percent, we predict y to increase by (?1/100) units of wage.



*QUADRATIC TERM EXAMPLE

*Lets generate a model and look at the residuals with and without the square term
clear
*Set observations
set obs 1000

**Generate x1 and x2 (relevant variables), and x3
gen x1=10*rnormal()
gen x2=5*rnormal()
sum x1 x2
corr x1 x2

**Generate an x2sq term
gen x2sq = x2*x2

*Generate a u term to be used in creation of y
gen u=2*rnormal() 
sum u

**Generate y so that its includes a square term
gen y = 1 + 2*x1 + 5*x2 + x2sq + u
sum y
corr y x1 x2
corr y x1 x2sq

**Regress without the sq term
regress y x1 x2

**Take a look at the residuals plotted against x2
predict usq, residuals
scatter usq x2
**Curve suggests that we may have an unaccounted for quadratic term

**Now try with the square term
regress y x1 x2 x2sq

*Take another look at the residuals
predict usq2, residuals
scatter usq2 x2


*FIND THE BEST MODEL

*I made simulated data as above. Using this data, try to determine what the best model is

*Things to think about: 
    *What does your data look like?
    *Do you have any multicollinearity concerns?
    *How is your outcome distributed?
    *Think about interactions, quadratic and log terms
    *Look at significance of terms and overall model fit as you add things


*I won't give you exact steps (bc this is similar to a homework problem) but will 
*give you the model I used to generate the y at the end of class so you can see how you did

clear

set obs 1000

*Load data
gen x1=.1*rnormal()
gen x2=3*rnormal()
gen x3=.17*rnormal()
gen x4=.4*rnormal()

gen u= rnormal()

gen y2 = x1 + 2*x3 + 4*x4 + 6*x3*x4 + u
gen y = exp(y2)

gen logy = log(y)


gen x3x4 = x3*x4
gen x1x3 = x1*x3
gen x1x4 = x1*x4

*Look at fit of simple model
regress y x1

*Look at outcome distribution
hist y, normal
hist logy, normal
*Looks like y is better fit when logged

*Check by running regression
regress y x1 x2 x3 x4

regress logy x1 x2 x3 x4
*logy higher R-sq, drop x2

*Probe interaction terms
regress logy x1 x3 x4 x1x3

regress logy x1 x3 x4 x1x4

regress logy x1 x3 x4 x3x4
*x2x4 significant

*check residual scatter to see if there is evidence for a quadratic term
predict uh, residual
scatter uh x1

*Check if x1 should be logged
gen logx1=log(x1)
regress logy logx1 x3 x4 x3x4
*Not sig, go back to level x1
