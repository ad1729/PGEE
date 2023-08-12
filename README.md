
# PGEE

<!-- badges: start -->
<!-- badges: end -->

This fork of the `{PGEE}` R package is modified from the original by adding the option of applying a ridge / $\text{L}_2$ penalty to the coefficients instead of the usual SCAD penalty.

## Installation

You can install the development version of PGEE from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ad1729/PGEE")
```

## Example

The ridge penalty can be specified by passing the `penalty_type = "ridge"` argument to the `PGEE()` call. By default, `penalty_type = "SCAD"`.

``` r
library(PGEE)
# library(dplyr)

n <- 1000

set.seed(5)
dat <- dplyr::tibble(
  exposure = rbinom(n, size = 1, prob = 0.6),
  # adding a small factor to the time runif endpoints here to avoid spline warnings 
  # regarding predictions at boundary knots
  time = round(runif(n, min = -3.05, max = 12.05), 2), 
  #time = sample(x = -4:13, size = n, replace = TRUE),
  logodds = -0.1 + (-0.2 * (time ^ 2)) + (0.7 * exposure),
  response = rbinom(n, size = 1, prob = plogis(logodds)), 
  id = factor(rep(LETTERS[1:10], each = 100))
) %>% 
  dplyr::mutate(exposure = factor(exposure, levels = c(0, 1))) %>% 
  dplyr::arrange(id)

# pindex = c(1, 2) indicates that the intercept and exposure terms should not be penalized
mod <- PGEE(
  response ~ exposure + splines2::bSpline(time, knots = seq(-2, 10, 1)),
  data = dat, family = "binomial", corstr = "exchangeable", id = id, 
  lambda = 0.001, scale.fix = TRUE, pindex = c(1, 2), silent = FALSE, 
  penalty_type = "ridge"
)

mod
```

