
#
library(lproj)

data(us_macro)

head(us_macro)
matplot(us_macro,t='l')

T <- length(nrow(us_macro))
P <- 4
h1<- 1
H <- 20

y  <- us_macro$yg
x  <- us_macro$ir
w  <- cbind( us_macro$yg , us_macro$pi , lagmatrix( cbind(us_macro$yg,us_macro$pi,us_macro$ir) , P ) )

lambda <- c(0.0001,0.01,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,1.0,9,10)/1000

ir.regular  <- lproj( y=y , x=x , w=w , const=TRUE , type='reg' , H=H , h1=h1 )
ir.smooth   <- lproj( y=y , x=x , w=w , const=TRUE , type='smooth' , H=H , h1=h1 , r=2 , lambda=lambda )

ir.smooth   <- lproj.cv( ir.smooth , 5 )

matplot( cbind(ir.regular$ir,ir.smooth$ir.opt) , t='l' )
abline(h=0)
