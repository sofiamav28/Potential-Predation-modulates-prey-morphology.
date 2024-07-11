# Load required libraries
library(raster)
library(sp)
library(maptools)
library(rgdal)
library(sf)
library(terra)
library(dismo)
library(XML)
library(maps)
library(letsR)
library(plyr)
library(phytools)
library(geiger)
library(vegan)
library(PVR)
library(nlme)
library(picante)
library(rgeos)
library(spDataLarge)
library(spgwr)
library(classInt)
library(RColorBrewer)
library(rcompanion)
library(lmtest)
library(spdep)
library(spatialreg)
library(utils)
library(beepr)
library(ggplot2)
library(viridis)
library(fields)
library(ggpubr)
library(knitr)
library(xtable)
library(texreg)
library(ggResidpanel)
library(lme4)
library(MASS)
library(nortest)
library(car)

# Set working directory
# Replace this path with the path to your project directory
setwd("path/to/your/project")

# Load Velasco et al's dataset convex hulls
ranges <- readOGR("./src/maps/ANOLE_RANGE_MAPS_POE_etal_TAXONOMY_27032017.shp")
proj4string(ranges) <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")
crs.geo <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")  # geographical, datum WGS84
projection(ranges) <- crs.geo

# Subset columns
ranges <- ranges[, c(1, 3)]

# Check if 'ranges' is a data frame
is.data.frame(ranges)
# View column names
names(ranges)

# Create presence-absence matrix of species' geographic ranges within a grid
PAM_convex <- lets.presab(ranges, xmn = -115, xmx = -36, ymn = -23, ymx = 36, resol = 0.5,
                          remove.cells = TRUE, remove.sp = TRUE, show.matrix = FALSE,
                          crs = CRS("+proj=longlat +ellps=WGS84 +datum=WGS84"), cover = 0, presence = NULL,
                          origin = NULL, seasonal = NULL, count = FALSE)
beep(sound = 1, expr = NULL)

# Plot species richness map
plot(PAM_convex, main = "Species Richness")

# Add data from 'data_tot.csv'
data_tot <- read.csv("./src/data/data_tot.csv", row.names = 1)

# Extract variables
totppp <- data_tot[, 4]
names(totppp) <- row.names(data_tot)

birdppp <- data_tot[, 1]
names(birdppp) <- row.names(data_tot)

mamppp <- data_tot[, 2]
names(mamppp) <- row.names(data_tot)

mamppp <- data_tot[, 3]
names(mamppp) <- row.names(data_tot)

## PPP TOTAL
# Create a matrix summarizing species attributes within cells of a presence-absence object
totppp_pam <- lets.maplizer(PAM_convex, totppp, PAM_convex$Species_name, func = median, ras = T)

# Add this matrix as a variable to 'PAM_convex'
totppp_pam.obs <- lets.addvar(x = PAM_convex, y = totppp_pam$Raster, fun = median)
totppp_pam.obs <- as.data.frame(totppp_pam.obs[, c(1, 2, 381)])
totppp_pam.obs <- rename(totppp_pam.obs, replace = c("last_median" = "median_totppp"))

# View data
colnames(totppp_pam.obs)
write.csv(totppp_pam.obs, file = "outputs/totppp_pam.csv")

# Read data
totppp_pam.obs <- read.csv("outputs/totppp_pam.csv")

# Plot
p <- ggplot(totppp_pam.obs, aes(long, lat)) +
  borders("world", xlim = c(-115, -36), ylim = c(-23, 36)) +
  geom_raster(data = totppp_pam.obs, aes(x = Lon, y = Lat, fill = median_totppp)) +
  scale_fill_viridis(option = "magma", direction = -1) +
  theme(panel.border = element_rect(colour = "gray50", fill = NA, size = 1)) +
  theme_classic()

p + coord_fixed(ratio = 1, xlim = c(-117, -34), ylim = c(-30, 45), expand = FALSE, clip = "on")

## PPP BIRDS
# Create a matrix summarizing species attributes within cells of a presence-absence object
birdppp_pam <- lets.maplizer(PAM_convex, birdppp, PAM_convex$Species_name, func = median, ras = T)

# Add this matrix as a variable to 'PAM_convex'
birdppp_pam.obs <- lets.addvar(x = PAM_convex, y = birdppp_pam$Raster, fun = median)
birdppp_pam.obs <- as.data.frame(birdppp_pam.obs[, c(1, 2, 381)])
birdppp_pam.obs <- rename(birdppp_pam.obs, replace = c("last_median" = "median_birdppp"))

# View data
colnames(birdppp_pam.obs)
write.csv(birdppp_pam.obs, file = "outputs/birdppp_pam.csv")

# Read data
birdppp_pam.obs <- read.csv("outputs/birdppp_pam.csv")

# Plot
p <- ggplot(birdppp_pam.obs, aes(long, lat)) +
  borders("world", xlim = c(-115, -36), ylim = c(-23, 36)) +
  geom_raster(data = birdppp_pam.obs, aes(x = Lon, y = Lat, fill = median_birdppp)) +
  scale_fill_viridis(option = "magma", direction = -1) +
  theme(panel.border = element_rect(colour = "gray50", fill = NA, size = 1)) +
  theme_classic()

p + coord_fixed(ratio = 1, xlim = c(-117, -34), ylim = c(-30, 45), expand = FALSE, clip = "on")

## PPP MAMMALS
# Create a matrix summarizing species attributes within cells of a presence-absence object
mamppp_pam <- lets.maplizer(PAM_convex, mamppp, PAM_convex$Species_name, func = median, ras = T)

# Add this matrix as a variable to 'PAM_convex'
mamppp_pam.obs <- lets.addvar(x = PAM_convex, y = mamppp_pam$Raster, fun = median)
mamppp_pam.obs <- as.data.frame(mamppp_pam.obs[, c(1, 2, 381)])
mamppp_pam.obs <- rename(mamppp_pam.obs, replace = c("last_median" = "median_mamppp"))

# View data
colnames(mamppp_pam.obs)
write.csv(mamppp_pam.obs, file = "outputs/mamppp_pam.csv")

# Read data
mamppp_pam.obs <- read.csv("outputs/mamppp_pam.csv")

# Plot
p <- ggplot(mamppp_pam.obs, aes(long, lat)) +
  borders("world", xlim = c(-115, -36), ylim = c(-23, 36)) +
  geom_raster(data = mamppp_pam.obs, aes(x = Lon, y = Lat, fill = median_mamppp)) +
  scale_fill_viridis(option = "magma", direction = -1) +
  theme(panel.border = element_rect(colour = "gray50", fill = NA, size = 1)) +
  theme_classic()

p + coord_fixed(ratio = 1, xlim = c(-117, -34), ylim = c(-30, 45), expand = FALSE, clip = "on")

### PPP REPTILES
# Create a matrix summarizing species attributes within cells of a presence-absence object
mamppp_pam <- lets.maplizer(PAM_convex, mamppp, PAM_convex$Species_name, func = median, ras = T)

# Add this matrix as a variable to 'PAM_convex'
mamppp_pam.obs <- lets.addvar(x = PAM_convex, y = mamppp_pam$Raster, fun = median)
mamppp_pam.obs <- as.data.frame(mamppp_pam.obs[, c(1, 2, 381)])
mamppp_pam.obs <- rename(mamppp_pam.obs, replace = c("last_median" = "median_mamppp"))

# View data
colnames(mamppp_pam.obs)
write.csv(mamppp_pam.obs, file = "outputs/mamppp_pam.csv")

# Read data
mamppp_pam.obs <- read.csv
