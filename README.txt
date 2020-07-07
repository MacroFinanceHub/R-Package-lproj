#####################################################################
# This is a readme for the lproj.R smooth local projection R file
#####################################################################

A demo implementing the lproj.R file can be found in demo.R

The smooth local projection function lproj.R contains 4 functions:
1. lagmatrix()
2. lproj()
3. lproj.conf()
4. lproj.cv()

######################################################################
lagmatrix()

# Description #
Creates a lagged (shifted) version of a time series matrix. Essentially
the matlab function lagmatrix() transalted into R.

# Usage #
lagmatrix(X, lag)

# Arguments #
X - time-series matrix of values to be shifted
lag - number of lags

# Value #
A time series matrix with contemporaneous and lagged values of all
columns of X.

######################################################################
lproj()

# Description #
Runs instrumental local projections over a number of horizons.

# Usage #
lproj( y , x , w=NULL , const=TRUE , type='reg' , H , h1 , r=0 , zero=FALSE , lambda=0, trace=1 )

# Arguments #
y - Response (LHS) vector
x - Endogenous impulse vector
w - Optional matrix of all other RHS vectors, including the constant, instrumental variables, and lagged variables (if applicable)
const - logical. If TRUE, includes a constant when running the local projections
type - String value that dictates whether the local projection ran is regular or smooth ('reg' or 'smooth')
H - Number of periods the local projection spans
h1 - First period the shock hits (0 or 1)
r - Used in smooth local projection: order of the limit polynomial  (for example, r=2 implies the impulse response is shrunk towards a line)
zero - Normalize to 0 in the first period (?)
lambda - Used in smooth local projection: numeric vector of options for the shrinking parameter lamba
trace - numeric. Set to 1 to format the output in the R console to be more readable


# Value #
lproj returns an object of class "list" containing at least the following components:

type
	string. Type of local projection ran ('reg' or 'smooth')
h1
	numeric. First period the shock hits (0 or 1)
H
	numeric. Number of periods the local projection spans
XS
	numeric. Horizon dimensions
HR
	numeric. Actual number of periods the local projection is run on (H+1-h1)
T
	numeric. Number of observations of the data used to run the local projection
TS
	numeric. Total dimensions (T*HR)
IDX
	matrix. Observation horizon matrix
y
	numeric vector of response (LHS) values
x
	numeric vector of endogenous impulse values
w
	matrix of all other RHS vectors, including the constant, instrumental variables, and lagged variables (if applicable)
Y
	numeric. Shifted response (LHS) vector ran in local projection simulatenously over all horizons
X
	matrix. Shifted RHS matrix ran in local projection simultaenously over all horizons (includes all RHS vectors including the constant)
theta
	matrix. Theta matrix containing coefficient estimates for all variables, for each value of labmda (a vector if running a regular local projection)
mul
	matrix containing estimations of the impulse coefficient for each value of lambda (a vector if running a regular local projection)
lambda
	Only returned in smooth local project. Numeric vector of all values of labmda
P
	Class dsCMatrix. Penalty matrix
ir
	matrix containing estimations of the instrumented impulse coefficient for each value of lambda (a vector if running a regular local projection)
delta
	numeric value containing the residual standard error from the first stage OLS regression of the endogenous impulse variable on other endogenous and exogenous RHS variables. (ir = mul*delta).

######################################################################
lproj.cv()

# Description #
For use with smooth local projections. Takes smooth local projection output from the lproj() function,
and runs a cross validation to choose the optimal value of lambda and return the corresponding estimates.

# Usage #
lproj.cv <- function( obj , K, trace=1 )

# Arguments #
obj - Object of class "list" returned by the lproj() function
K - (?)
trace - Set to 1 to format the output in the R console to be more readable

# Value #
lproj.cv returns an object of class "list" containing at least the following components:

rss
	numeric list of the residual sum of squares for the smooth local projections for each value of lambda
idx.opt
	numeric Index corresponding to the lambda value with the minimum RSS, i.e. the optimal lambda value and estimates
ir.opt
	numeric vector of the optimal coefficients over each horizon of the intrumented impulse variable

######################################################################
lproj.conf()

# Description #
Creates a 90% confidence interval around instrumented impulse variable coefficients using the normal distribution

# Usage #
lproj.conf <- function( obj , l=1 )

# Arguments #
obj - Object of class "list" returned by the lproj() function
l - numeric. Index of the theta matrix with the optimal estimates. Set to idx.opt if running smooth local projection, otherwise leave it at 1.
trace - Set to 1 to format the output in the R console to be more readable

# Value #
lproj.cv returns an object of class "list" containing at least the following components:

se
	numeric vector of the standard errors of the optimal instrumented impulse vector coefficients
irc
	matrix of the 90% confidence bands around the optimal instrumented impulse vector coefficients

######################################################################