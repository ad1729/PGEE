\name{PGee}
\alias{PGee}
\alias{mycor_gee2}
\alias{q_scad}
\alias{S_H_E_M}
\alias{print.PGee}
\alias{print.summary.PGee}
\alias{summary.PGee}

\title{Function to fit penalized generalized estimating equations}

\description{This function fits a penalized generalized estimating equation model to longitudinal data.}

\usage{
PGee(formula, id, data, na.action = NULL, family = gaussian(link = "identity"), 
corstr = "independence", Mv = NULL, beta_int = NULL, R = NULL, scale.fix = FALSE, 
scale.value = 1, lambda, pindex = NULL,eps = 10^-6, maxiter = 30, tol = 10^-3, 
silent = FALSE)
}

\arguments{
\item{formula}{A formula expression in the form of \code{response~predictors}.}
\item{id}{A vector for identifying subjects/clusters.}
\item{data}{A data frame which stores the variables in \code{formula} with \code{id} variable.}
\item{na.action}{A function to remove missing values from the data. Only \code{na.omit} is allowed here.}
\item{family}{A \code{family} object: a list of functions and expressions for defining \code{link} and 
\code{variance} functions. Families supported in \code{PGee} are \code{binomial}, \code{gaussian}, \code{gamma} and 
\code{poisson}. The \code{links}, which are not available in \code{gee}, is not available here. The default family 
is \code{gaussian}.} 
\item{corstr}{A character string, which specifies the type of correlation structure. 
Structures supported in \code{PGee} are \code{"AR-1"},\code{"exchangeable"}, \code{"fixed"}, \code{"independence"},
\code{"stat_M_dep"},\code{"non_stat_M_dep"}, and \code{"unstructured"}. The default \code{corstr} type is 
\code{"independence"}.} 
\item{Mv}{If either \code{"stat_M_dep"}, or \code{"non_stat_M_dep"} is specified in \code{corstr}, then this 
assigns a numeric value for \code{Mv}. Otherwise, the default value is \code{NULL}.}
\item{beta_int}{User specified initial values for regression parameters. The default value is \code{NULL}.}
\item{R}{If \code{corstr="fixed"} is specified, then \code{R} is a square matrix of dimension maximum cluster 
size containing the user specified correlation. Otherwise, the default value is \code{NULL}.}
\item{scale.fix}{A logical variable; if true, the scale parameter is fixed at the value of \code{scale.value}. 
The default value is \code{FALSE}.}
\item{lambda}{A numerical value for the penalization parameter of the scad function, which is estimated via 
cross-validation.}
\item{pindex}{An index vector showing the parameters which are not subject to penalization. The default value
 is \code{NULL}. However, in case of a model with intercept, the intercept parameter should be never penalized.}
\item{eps}{A numerical value for the epsilon used in minorization-maximization algorithm. The default value is 
\code{10^-6}.}
\item{scale.value}{If \code{scale.fix=TRUE}, this assignes a numeric value to which the scale parameter should be 
fixed.}
\item{maxiter}{The number of iterations that is used in the estimation algorithm. The default value is \code{25}.}
\item{tol}{The tolerance level that is used in the estimation algorithm. The default value is \code{10^-3}.}
\item{silent}{A logical variable; if true, the regression parameter estimates at each iteration are
printed. The default value is \code{FALSE}.}
}

\value{An object class of \code{PGee} representing the fit.}

\references{
Wang, L., Zhou, J., and Qu, A. (2012). Penalized generalized estimating equations 
for high-dimensional longitudinal data anaysis. \emph{Biometrics}, \bold{68}, 353--360.
}

\seealso{
\code{\link{CVfit}}, \code{\link{MGee}}
}

\examples{
#Consider an example similar to example 1 
#in Wang et al. (2012).

#required R package 
library(mvtnorm)
#number of subjects
n=200
#number of covariates 
pn=10
#number of time points
m=4

#vector if subject ids
id.vect<-rep(1:n, each=m) 

#covariance matrix of (pn-1) number of continuous covariates 
X.sigma<-matrix(0,(pn-1),(pn-1))
{
for (i in 1:(pn-1))
X.sigma[i,]<-0.5^(abs((1:(pn-1))-i))  
}

#generate matrix of covariates    
x.mat<-as.matrix(rmvnorm(n*m, mean=rep(0,(pn-1)), X.sigma))
x.mat<-cbind(rbinom(n*m,1, 0.5), x.mat)

#true values
beta.true=c(2,3,1.5,2,rep(0,6))
sigma2=1
rho=0.5
R<-matrix(rho,m,m)+diag(rep(1-rho,m))

#covariance matrix of error
SIGMA<-sigma2*R
error<-rmvnorm(n, mean=rep(0,m),SIGMA)

#generate longitudinal data with continuous outcomes
y.temp<-x.mat%*%matrix(beta.true, ncol=1)
y.vect<-y.temp+as.vector(t(error))   

mydata<-data.frame(id.vect,y.vect,x.mat) 
colnames(mydata)=c("id","y",paste("x",1:length(beta.true),sep=""))


###Input Arguments for Cvfit fitting###
formula1=as.formula(paste("y~",paste(paste("x",1:length(beta.true),sep=""),collapse="+")))
formula<-update(formula1,~.-1)
data=mydata
family<-gaussian(link="identity")
fold=4
lambda.vec=seq(0.1,1,0.1)

\dontrun{
cv=CVfit(formula=formula,id=data[,1],data=data,family=family,
fold=fold,lambda.vec=lambda.vec, pindex = NULL, eps=10^-6,maxiter=30,tol=10^-3)

names(cv)
cv$lam.opt
}

lambda=0.1 #this value obtained through CVfit

#analyze the data through penalized generalized estimating equations

myfit1=PGee(formula=formula, id=data[,1], data=data, na.action = NULL, 
family = gaussian(link = "identity"),corstr = "exchangeable", Mv = NULL, 
beta_int = c(rep(0,length(beta.true))), R = NULL, scale.fix = FALSE, 
scale.value = 1, lambda=lambda, pindex = NULL, eps = 10^-6, maxiter = 30, 
tol = 10^-3, silent = FALSE)

summary(myfit1)

#analyze the data through unpenalized generalized estimating equations

myfit2=MGee(formula=formula, id=data[,1], data=data, na.action = NULL, 
family = gaussian(link = "identity"),corstr = "exchangeable", Mv = NULL, 
beta_int = c(rep(0,length(beta.true))), R = NULL, scale.fix = FALSE, 
scale.value = 1, maxiter = 30, tol = 10^-3, silent = FALSE)

summary(myfit2)
}