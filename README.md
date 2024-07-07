# Potential-Predation-modulates-prey-morphology.

# Islands vs Mainland

This file contains R scripts for analyzing predation pressure on different species across islands and continents. The analysis includes generating plots and performing statistical tests.

## Data

Place your CSV files in the `data` directory. The required files are:
- `asap.csv`
- `data_tot.csv`

## Scripts

- `analysis.R`: Main script for data analysis and visualization.

## Plots

The generated plots will be saved in the `plots` directory.

## Setup

1. Install the necessary packages:
    ```R
    install.packages(c("tidyverse", "dplyr", "data.table", "plyr", "ggplot2", "nortest", "hrbrthemes", "viridis", "ggbeeswarm", "devtools", "Rmisc", "remotes", "see", "showtext"))
    devtools::install_github("kassambara/easyGgplot2")
    devtools::install_github("psyteachr/introdataviz")
    ```

2. Set your working directory to the project folder:
    ```R
    setwd("path/to/project")
    ```

3. Run the analysis script:
    ```R
    source("scripts/analysis.R")
    ```


**Disclaimer:** The code and configuration files may not be user-friendly, as they were not created by a professional computer scientist. If you encounter any difficulties or need assistance in executing the codes, please do not hesitate to contact us.

For further information, please contact Sofía M. Alfonso-Velasco at sofiamalfonsovelasco@gmail.com.
