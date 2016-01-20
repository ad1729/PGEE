\name{CVfit}
\alias{CVfit}
\alias{print.CVfit}

\title{Function to compute cross-validated tuning parameter value}

\description{This function computes cross-validated tuning parameter value for 
longitudinal data with working independence structure.
}

\usage{
CVfit(formula, id, data, family, fold, lambda.vec, eps, maxiter, tol)
}

\arguments{
\item{formula}{A formula expression in the form of \code{response~predictors}.}
\item{id}{A vector for identifying subjects/clusters.}
\item{data}{A data frame which stores the variables in \code{formula} with \code{id} variable.}
\item{family}{A \code{family} object in \code{\link{PGee}}.}
\item{fold}{The number of folds used in cross-validation.}
\item{lambda.vec}{A vector of tuning parameters that will be used in the cross-validation.}
\item{eps}{A numerical value for the epsilon used in minorization-maximization algorithm. The default value is 
\code{10^-6}.}
\item{maxiter}{The number of iterations that is used in the estimation algorithm. The default value is \code{25}.}
\item{tol}{The tolerance level that is used in the estimation algorithm. The default value is \code{10^-3}.} 
}

\value{An object class of \code{CVfit}.}

\references{
Wang, L., Zhou, J., and Qu, A. (2012). Penalized generalized estimating equations 
for high-dimensional longitudinal data anaysis. \emph{Biometrics}, \bold{68}, 353--360.
}

\seealso{
\code{\link{PGee}}
}

