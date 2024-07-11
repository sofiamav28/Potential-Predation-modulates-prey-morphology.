# Potential-Predation-modulates-prey-morphology.

# Islands vs Mainland Analysis

This repository contains R scripts for analyzing predation pressure on different species across islands and continents. The analysis includes generating plots and performing statistical tests.

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
   
   Ensure compatibility with specific package versions needed for your project.

2. Set your working directory to the project folder:
    ```R
    setwd("path/to/project")
    ```

3. Run the analysis script:
    ```R
    source("scripts/analysis.R")
    ```

# PPP and Morphology Raster Mapping

This section of the project involves mapping species richness (ppp) and morphological variables across geographic locations using raster maps. Due to compatibility issues with the current version of R, specific spatial analysis packages (MapTools, rgdal, rgeos) are not available directly from CRAN. However, you can obtain formerly available versions from the CRAN archive:

- [MapTools](https://cran.r-project.org/src/contrib/Archive/maptools/)
- [rgdal](https://cran.r-project.org/src/contrib/Archive/rgdal/)
- [rgeos](https://cran.r-project.org/src/contrib/Archive/rgeos/)

To install a specific version from the archive, use commands like:
```R
install.packages("rgdal", repos = "https://cran.r-project.org/src/contrib/Archive/rgdal/", type = "source")


**Disclaimer:** The code and configuration files may not be user-friendly, as they were not created by a professional computer scientist. If you encounter any difficulties or need assistance in executing the codes, please do not hesitate to contact us.

For further information, please contact Sofía M. Alfonso-Velasco at sofiamalfonsovelasco@gmail.com.
