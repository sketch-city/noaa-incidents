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

dieselclean$description <- gsub('\\\v', '', dieselclean$description, perl=T)
fuelclean$description <- gsub('\\\v', '', fuelclean$description, perl=T)
oilclean$description <- gsub('\\\v', '', oilclean$description, perl=T)

noaamap <- leaflet() %>% 
  addTiles() %>% 
  addProviderTiles("CartoDB.Positron") %>%
  setView(-95.37, 29.75, zoom = 8) %>% 
  addCircles(data = dieselclean, lng = ~ lon, lat = ~ lat, color= ~ "red", radius = ~ sqrt(max_ptl_release_gallons * 4), popup = paste("<div style='max-height:200px; overflow-y:hidden; overflow:auto;'><strong>",dieselclean$name,"</strong><br/>", dieselclean$description,"</div>"), group="Diesel") %>% 
  addCircles(data = fuelclean, lng = ~ lon, lat = ~ lat, color= ~ "blue", radius = ~ sqrt(max_ptl_release_gallons * 4), popup = paste("<div style='max-height:200px; overflow-y:hidden; overflow:auto;'><strong>",fuelclean$name,"</strong><br/>", fuelclean$description, "</div>"), group="Fuel") %>% 
  addCircles(data = oilclean, lng = ~ lon, lat = ~ lat, color= ~ "green", radius = ~ sqrt(max_ptl_release_gallons * 4), popup = paste("<div style='max-height:200px; overflow-y:hidden; overflow:auto;'><strong>",oilclean$name,"</strong><br/>", oilclean$description, "</div>"), group="Oil") %>% 
  addLayersControl(overlayGroups = c("Diesel", "Fuel", "Oil"), 
                   options = layersControlOptions(collapsed = FALSE)) 
noaamap