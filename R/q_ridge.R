q_ridge <- function(theta, lambda) {
  # derivative of the ridge / L2 penalty
  # p(theta) = lambda * (theta ^ 2)
  # p'(theta) = 2 * lambda * theta
  2 * lambda * abs(theta)
}
