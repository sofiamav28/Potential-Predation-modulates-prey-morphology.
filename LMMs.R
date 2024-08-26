# Load Required Libraries
library(raster)
library(glmm)
library(ggplot2)
library(rcompanion)
library(lmtest)
library(spdep)
library(lme4)
library(Hmisc)
library(reshape2)
library(nlme)
library(r2glmm)
library(MuMIn)
library(sjPlot)
library(sjmisc)
library(glmmTMB)
library(ggpubr)
library(qpcR)
library(MASS)
library(minpack.lm)
library(rgl)
library(robustbase)
library(lm.beta)

# Load and Prepare Data
datos <- read.csv("data/asap.csv")
datos2 <- na.omit(datos)
datos2$region1 <- as.numeric(datos2$region1)
datos2$cell1 <- as.numeric(datos2$cell1)
names(datos2)[names(datos2) == "median_log10_svl"] <- "median_bl"

save(datos2, file = "data/processed_data.RData")


# 02_calculate_models.R

load("data/processed_data.RData")

# Define a function to fit LMMs
fit_lmm <- function(formula, data) {
  lmer(formula, data)
}

# Fit LMMs for Body Length (BL)
models_bl <- list(
  fm_bl_na = fit_lmm(median_bl ~ 1 + median_bio_1 + median_bio_4 + median_bio_12 + median_bio_15 + (1 | region1), datos2),
  fm_bl_na_cell = fit_lmm(median_bl ~ 1 + median_bio_1 + median_bio_4 + median_bio_12 + median_bio_15 + (1 | region1) + (1 | cell1), datos2),
  fm_bl_tot = fit_lmm(median_bl ~ 1 + median_ppp_tot + median_bio_1 + median_bio_4 + median_bio_12 + median_bio_15 + (1 | region1), datos2),
  fm_bl_tot_inter = fit_lmm(median_bl ~ 1 + median_ppp_tot + median_bio_1 + median_bio_4 + median_bio_12 + median_bio_15 + median_ppp_tot * median_bio_4 + median_ppp_tot * median_bio_15 + (1 | region1), datos2),
  # Add other models as necessary...
)

# Save the fitted models
save(models_bl, file = "results/models_bl.RData")

# Repeat for other morphological traits (Head Length, Toe Length, etc.)


# 03_model_selection.R

load("results/models_bl.RData")

# Function to calculate AIC and Akaike weights
calculate_aic_weights <- function(models) {
  aic_values <- sapply(models, AIC)
  delta_aic <- aic_values - min(aic_values)
  likelihoods <- exp(-0.5 * delta_aic)
  weights <- likelihoods / sum(likelihoods)
  data.frame(Model = names(models), AIC = aic_values, Akaike_Weight = weights)
}

# Calculate AIC and Akaike weights for Body Length models
results_bl <- calculate_aic_weights(models_bl)

# Export the results
write.csv(results_bl, file = "results/body_length_aic_weights.csv", row.names = FALSE)

# Convert Akaike Weights to decimal notation and export
convert_and_export <- function(input_file, output_file) {
  results <- read.csv(input_file)
  results$Akaike_Weight <- format(results$Akaike_Weight, scientific = FALSE)
  write.csv(results, file = output_file, row.names = FALSE)
}

convert_and_export("results/body_length_aic_weights.csv", "results/body_length_aic_weights_decimal.csv")

# Repeat for other morphological traits
