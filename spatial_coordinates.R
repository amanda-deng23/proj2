## sp and rgdal are used to assign and transform Coordinate Reference Systems in R
library(rgdal)
library(sp)

# This document is valid for systems with PROJ4 support in the rgdal package.
# New installations can have PROJ6 support, which has other features, but
# is largely backwards compatible with PROJ4

## In R, the notation used to describe the CRS is proj4string from the
## PROJ.4 library.
## Some spatial data files have associated projection data, such as
## ESRI shapefiles.  When readOGRis used to import these data this
## information is automatically linked to the R spatial object. To
## retrieve the CRS for a spatial object use proj4string

## Map of scotland from shapefiles and its CRS
## Note: make sure shapefiles are all in working directory
scotland     <- readOGR("District_16_1.shp",verbose=TRUE)  #or street postcode shapefile
head(coordinates(scotland))
plot(scotland, axes = TRUE)
proj4string(scotland)


## There are various attributes of the CRS, such as the projection and
## ellipsoid. Some of the options for each variable can be obtained in
## R with projInfo
projInfo(type =  "proj")
projInfo(type  = "ellps")


## Some projections have predefined definition codes that are
## expanded to full definitions internally:
ukgrid  <- "+init=epsg:27700"
longlat <- "+init=epsg:4326"

# Compare this to the proj4string for the map (see above)
CRSargs(CRS(ukgrid))

# The longitude/latidude system is different:
CRSargs(CRS(longlat))

## To transform from one CRS to another
scotland_longlat <- spTransform(scotland, longlat)
plot(scotland_longlat, axes = TRUE)
head(coordinates(scotland_longlat))

# Setting CRS information when it's not already given:
data <- readr::read_csv("LeadPipes.csv")
# Make a spatial object:
coordinates(data) <- c("Easting", "Northing")
proj4string(data) <- ukgrid
# Convert to longitude/latitude:
data_longlat <- spTransform(data, longlat)

# Plotting multiple spatial objects:
plot(scotland, axes = TRUE)
plot(data, pch = 20, col = 2, add = TRUE)

plot(scotland_longlat, axes = TRUE)
plot(data_longlat, pch = 20, col = 2, add = TRUE)

# With ggplot and the inlabru package
library(ggplot2)
ggplot() +
  inlabru::gg(scotland) +
  inlabru::gg(data, col = "red")
ggplot() +
  inlabru::gg(scotland_longlat) +
  inlabru::gg(data_longlat, col = "red")
