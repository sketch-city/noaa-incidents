library(dplyr)
library(leaflet)
setwd("/noaa-incidents")
diesel <- read.csv(file="diesel.csv", header=T)
fuel <- read.csv(file="fuel.csv", header=T)
oil <- read.csv(file="oil.csv", header=T)

diesel$max_ptl_release_gallons <- as.numeric(diesel$max_ptl_release_gallons)
fuel$max_ptl_release_gallons <- as.numeric(fuel$max_ptl_release_gallons)
oil$max_ptl_release_gallons <- as.numeric(oil$max_ptl_release_gallons)

diesel$lat <- as.numeric(diesel$lat)
diesel$lon <- as.numeric(diesel$lon)
fuel$lat <- as.numeric(fuel$lat)
fuel$lon <- as.numeric(fuel$lon)
oil$lat <- as.numeric(oil$lat)
oil$lon <- as.numeric(oil$lon)

dieselclean <- diesel[!is.na(diesel$lat), ]
fuelclean <- fuel[!is.na(fuel$lat), ]
oilclean <- oil[!is.na(oil$lat), ]

noaamap <- leaflet() %>% 
  addTiles() %>% 
  addProviderTiles("CartoDB.Positron") %>%
  setView(-95.37, 29.75, zoom = 8) %>% 
  addCircleMarkers(data = dieselclean, lng = ~ lon, lat = ~ lat, color= ~ "red", radius = ~ sqrt(max_ptl_release_gallons * .002), popup = paste("<strong>",dieselclean$name,"<strong><br/>"), group="Diesel") %>% 
  addCircleMarkers(data = fuelclean, lng = ~ lon, lat = ~ lat, color= ~ "blue", radius = ~ sqrt(max_ptl_release_gallons * .002), popup = paste("<strong>",fuelclean$name,"<strong><br/>"), group="Fuel") %>% 
  addCircleMarkers(data = oilclean, lng = ~ lon, lat = ~ lat, color= ~ "green", radius = ~ sqrt(max_ptl_release_gallons * .002), popup = paste("<strong>",oilclean$name,"<strong><br/>"), group="Oil") %>% 
  addLayersControl(overlayGroups = c("Diesel", "Fuel", "Oil"), 
                   options = layersControlOptions(collapsed = FALSE)) 
noaamap