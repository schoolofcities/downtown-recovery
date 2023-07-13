library(readxl)
library(R.utils)
library(colorspace)
library(bit64)
library(readxl)
library(sf)
library(sp)
library(rgdal)
library(geojsonsf)
library(data.table)
library(geojsonio)
library(tidyverse)

all_shapefile <- st_read("shp/study_area_all.shp")

all_shapefile <-
  st_transform(all_shapefile, st_crs("+proj=longlat +datum=WGS84"))
colnames(all_shapefile) <- c("postal_code", "geometry")

all_city_index <- read.csv("input_data/all_city_index.csv")

all_shapefile <- inner_join(all_shapefile, all_city_index, by = "postal_code")


output$city_map <- renderLeaflet({
  ## single city map
  
  plot_map <- getCityMapDF()
  
  downtown_pal <-
    colorFactor("#f1a340", domain = TRUE, na.color = "transparent")
  
  plot_map_sf = inner_join(all_shapefile, plot_map, by = "postal_code")
  
  city_map <- leaflet(plot_map_sf) %>%
    addMapPane(name = "polygons", zIndex = 410) %>%
    addMapPane(name = "maplabels", zIndex = 420) %>% # higher zIndex rendered on top
    addProviderTiles("CartoDB.DarkMatterNoLabels") %>%
    addProviderTiles(
      "CartoDB.DarkMatterOnlyLabels",
      options = leafletOptions(pane = "maplabels"),
      group = "map labels"
    ) %>% # see: http://leaflet-extras.github.io/leaflet-providers/preview/index.html
    addEasyButton(easyButton(
      icon = "fa-crosshairs",
      title = "My Location",
      onClick = JS("function(btn, map){ map.locate({setView: true}); }")
    )) %>%
    addLegend(
      pal = avg_lq_pal,
      values = ~avg_lq,
      title = "Monthly Average RQ",
      position = "bottomleft"
    ) %>%
    addPolygons(
      layerId = ~postal_code,
      data = plot_map_sf,
      fillOpacity = .7,
      fillColor = ~avg_lq_pal(avg_lq),
      color = ~downtown_pal(is_downtown),
      opacity = ~as.numeric(is_downtown),
      weight = 2,
      stroke = TRUE,
      highlightOptions = highlightOptions(
        color = "#ff4a4a",
        weight = 5,
        bringToFront = TRUE,
        opacity = 1
      ),
      popup = ~popup,
      popupOptions = popupOptions(maxHeight = 215, closeOnClick = TRUE)
    ) %>%
    addLegend(color = "#d94801",
              labels = "Downtown area",
              "bottomleft")
})