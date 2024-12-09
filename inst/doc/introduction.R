## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(AuxSurvey)

# Generate data
data = simulate(N = 3000, discretize = c(3, 5, 10), setting = 1, seed = 123)
population = data$population  # Full population data (3000 cases)
samples = data$samples  # Sample data (600 cases)
ipw = 1 / samples$true_pi  # True inverse probability weighting
est_ipw = 1 / samples$estimated_pi  # Estimated inverse probability weighting
true_mean = mean(population$Y1)  # True value of the estimator

## -----------------------------------------------------------------------------
# Unweighted sample mean
sample_mean = auxsurvey("~Y1", auxiliary = NULL, weights = NULL, samples = samples, population = NULL, method = "sample_mean", levels = 0.95)

## -----------------------------------------------------------------------------
# IPW sample mean
IPW_sample_mean = auxsurvey("~Y1", auxiliary = NULL, weights = ipw, samples = samples, population = population, method = "sample_mean", levels = 0.95)

## -----------------------------------------------------------------------------
# Unweighted Raking for auX_5 with interaction with Z1
rake_5_Z1 = auxsurvey("~Y1", auxiliary = "Z2 + Z3 + auX_5 * Z1", weights = NULL, samples = samples, population = population, method = "rake", levels = 0.95)

## -----------------------------------------------------------------------------
# IPW Raking for auX_10
rake_10 = auxsurvey("~Y1", auxiliary = "Z1 + Z2 + Z3 + auX_10", weights = ipw, samples = samples, population = population, method = "rake", levels = c(0.95, 0.8))

## ----eval=FALSE---------------------------------------------------------------
# # MRP with auX_3
# MRP_1 = auxsurvey("Y1 ~ Z1 + Z2", auxiliary = "Z3 + auX_3", samples = samples, population = population, method = "MRP", levels = 0.95)

## ----eval=FALSE---------------------------------------------------------------
# # GAMP with smooth functions
# GAMP_1 = auxsurvey("Y1 ~ 1 + Z1 + Z2 + Z3", auxiliary = "s(logit_estimated_pi) + s(auX_10)", samples = samples, population = population, method = "GAMP", levels = 0.95)

## ----eval=FALSE---------------------------------------------------------------
# # Linear regression with Bayesian estimation
# LR_1 = auxsurvey("Y1 ~ 1 + Z1 + Z2 + Z3", auxiliary = "auX_3", samples = samples, population = population, method = "linear", levels = 0.95)

## -----------------------------------------------------------------------------
# BART for estimation
BART_1 = auxsurvey("Y1 ~ Z1 + Z2 + Z3 + auX_3 + logit_true_pi", auxiliary = NULL, samples = samples, population = population, method = "BART", levels = 0.95)

