

**Now let's run some simulations:

**IRRELEVANT VARIABLES
clear
*Set observations
set obs 200

**Generate x1 and x2 (relevant variables), and x3
gen x1=20*rnormal()
gen x2=20*rnormal()
gen x3=20*rnormal()
sum x1 x2 x3
corr x1 x2 x3

*Generate a u term to be used in creation of y
gen u=20*rnormal() 
sum u

**Generate y so that its related to x1 and x2
gen y = 1 + 2*x1 + 3*x2 + u
sum y
corr y x1 x2 x3

**Run the regression
regress y x1 x2 x3

*How do the coefficients compare to the population coefficients?

*Draw a new sample (i.e. generate a new set of data) - do you get similar results?



**OMITTED VARIABLES
clear

*Set 500 observations
set obs 500

*Generate x1 and x2 (x2 = our omitted variable)
gen x1 = 36*rnormal()
gen x2 = .8*x1 + 36*rnormal()
* .6*x1 terms creates a relationship between x1 and x2
sum x1 x2
corr x1 x2

*Generate u (used in the next step to generate y)
gen u = 10*rnormal()
sum u

*Generate y
gen y = 1 + 2*x1 + x2 + u
corr y x1 x2

*Estimate the model excluding x2
regress y x1

*How does your estimated x1 coefficient compare to your population x1 coefficient?

*Estimate the model including x2 to compare
regress y x1 x2

*Try running this code again on a new sample (generating x1, x2, u, and y again)

**Try it again creating a new data set with the population model y = 5 - x1 + 3x2 + u





***IF WE HAVE TIME: Example of 'partialling out' 

*This gives the association between y and x1, after the linear relationship 
*between x1 and x2 is removed

clear

*Set observations
set obs 1000

*Generate x1 and x2 
gen x1 = 30*rnormal()
gen x2 = 2*x1 + 10*rnormal()
* 2*x1 terms creates a relationship between x1 and x2
sum x1 x2
corr x1 x2

*Generate y
gen y = 1 + 10*x1 + 5*x2 + 10*rnormal()
**Here we add the "noise" into the equation with 10*rnormal. It's the same as when we created a u variable above

**Run the regression
regress y x1 x2

*Now Regress x1 & x2 to account for relationship bt x1 & x2
regress x1 x2
*Save the residuals of x1
predict r_x1 , resid
*NOTE: this code computes & stores the residuals - it must be run immediately following the regression
*r_x1 is the name you give the stored residuals, resid is the code to say that you want to predict the residuals

*Now regress residuals of x1 (the remains of x1 not explained by x2)
regress y r_x1

*How does the r_x1 coefficient compare to the x1 coeff when we ran both regressors?



log close
