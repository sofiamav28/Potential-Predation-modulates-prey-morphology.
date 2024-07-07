# Load required libraries
library(tidyverse)
library(dplyr)
library(data.table)
library(plyr)
library(ggplot2)
library(stats)
library(nortest)
library(hrbrthemes)
library(viridis)
library(ggbeeswarm)
library(devtools)
library(easyGgplot2)
library(Rmisc)
library(remotes)
library(see)
library(introdataviz)
library(showtext)

# Set working directory
setwd("path/to/your/project")

# Load data
asap <- read.csv("data/asap.csv")
asap$region1 <- as.factor(asap$region1)

# Separate islands and continents
islands <- filter(asap, region1 == "1")
continents <- filter(asap, region1 == "0")

# Load and configure the Lato font
showtext_auto()
font_add_google("Lato", "myfont")

# Define a ggplot2 theme using the Lato font
theme_set(
  theme_minimal() +
    theme(
      axis.text = element_text(family = "myfont", size = 12),
      axis.title = element_text(family = "myfont", size = 14, face = "bold")
    )
)

# Function to create and save plots
create_and_save_plot <- function(data, x, y, title, filename) {
  plot <- ggplot(data = data, aes_string(x = x, y = y, fill = x)) +
    geom_violin(width = 0.9, alpha = 1, position = position_dodge(width = 1), size = 0.5, color = "#a8a8a8", fill = "#a8a8a8") +
    geom_boxplot(width = 0.1, notch = FALSE, outlier.size = -1, color = "gray27", lwd = 1.5, alpha = 0.8, show.legend = FALSE) +
    scale_fill_manual(values = c("#d37012", "#ab2e5f"), breaks = c("b-continental", "a-insular"), labels = c("Continental", "Insular")) +
    theme_minimal() +
    labs(title = title, x = "", y = "PPP") +
    theme(
      legend.position = "none",
      plot.title = element_text(size = 20, hjust = 0.5, face = "bold", family = "Lato"),
      axis.title = element_text(family = "Lato"),
      axis.text = element_text(size = 14, color = "black", family = "Lato"),
      axis.line.x = element_blank(),
      axis.ticks.x = element_blank(),
      axis.text.x = element_blank(),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      axis.line.y = element_line(colour = "black", size = 0.8),
      axis.ticks.y = element_line(colour = "black"),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank()
    ) +
    scale_x_discrete(limit = c("b-continental", "a-insular"), labels = c("Continental", "Insular")) +
    scale_y_continuous()
  
  # Show the plot
  print(plot)
  
  # Save the plot
  ggsave(filename, plot = plot, dpi = 300, width = 10, height = 6)
}

# Create and save plots for different groups
create_and_save_plot(asap, "region", "median_ppp_aves", "Birds", "plots/aves_plot.png")
create_and_save_plot(asap, "region", "median_ppp_rept", "Reptiles", "plots/rept_plot.png")
create_and_save_plot(asap, "region", "median_ppp_mam", "Mammals", "plots/mam_plot.png")
create_and_save_plot(asap, "region", "median_ppp_tot", "Total", "plots/tot_plot.png")

# Statistical analysis
island_ppp_tot <- as.vector(islands$median_ppp_tot)
island_ppp_aves <- as.vector(islands$median_ppp_aves)
island_ppp_mam <- as.vector(islands$median_ppp_mam)
island_ppp_rept <- as.vector(islands$median_ppp_rept)

continent_ppp_tot <- as.vector(continents$median_ppp_tot)
continent_ppp_aves <- as.vector(continents$median_ppp_aves)
continent_ppp_mam <- as.vector(continents$median_ppp_mam)
continent_ppp_rept <- as.vector(continents$median_ppp_rept)

# Kolmogorov-Smirnov normality tests
lillie.test(island_ppp_tot)
lillie.test(island_ppp_aves)
lillie.test(island_ppp_mam)
lillie.test(island_ppp_rept)

lillie.test(continent_ppp_tot)
lillie.test(continent_ppp_aves)
lillie.test(continent_ppp_mam)
lillie.test(continent_ppp_rept)

# Mann-Whitney U tests
wilcox.test(island_ppp_aves, continent_ppp_aves)
wilcox.test(island_ppp_mam, continent_ppp_mam)
wilcox.test(island_ppp_rept, continent_ppp_rept)
wilcox.test(island_ppp_tot, continent_ppp_tot)

# Morphology analysis
# Plots for different morphological measurements
create_and_save_plot(asap, "region", "median_log10_svl", "SVL (log10)", "plots/svl_plot.png")
create_and_save_plot(asap, "region", "median_fml", "FML/SVL", "plots/fml_plot.png")
create_and_save_plot(asap, "region", "median_hdl", "HDL/SVL", "plots/hdl_plot.png")
create_and_save_plot(asap, "region", "median_tol", "TOL/SVL", "plots/tol_plot.png")

# Statistical analysis for morphology
island_svl <- as.vector(islands$median_log10_svl)
island_hdl <- as.vector(islands$median_hdl)
island_fml <- as.vector(islands$median_fml)
island_tol <- as.vector(islands$median_tol)

continent_svl <- as.vector(continents$median_log10_svl)
continent_hdl <- as.vector(continents$median_hdl)
continent_fml <- as.vector(continents$median_fml)
continent_tol <- as.vector(continents$median_tol)

# Kolmogorov-Smirnov normality tests for morphology
lillie.test(island_svl)
lillie.test(island_hdl)
lillie.test(island_fml)
lillie.test(island_tol)

lillie.test(continent_svl)
lillie.test(continent_hdl)
lillie.test(continent_fml)
lillie.test(continent_tol)

# Mann-Whitney U tests for morphology
wilcox.test(island_svl, continent_svl)
wilcox.test(island_hdl, continent_hdl)
wilcox.test(island_fml, continent_fml)
wilcox.test(island_tol, continent_tol)

# Cross-species approach
data_tot <- read.csv("data/data_tot.csv")
data_tot <- na.omit(data_tot)

# Separate islands and continents for cross-species data
