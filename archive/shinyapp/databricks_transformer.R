library(readxl)
library(stringr)
library(zoo)
library(tidyverse)
library(broom)
library(dplyr)
library(sf)
library(sp)
library(geojsonio)


# details the minor cleaning and transformations of csvs downloaded from databricks 
# for the sake of recordkeeping and reproducability

#study_das$country <- "CAN"
#write.csv(study_das, paste0(input_path, "input_data/study_area_canada.csv"))

#study_postal_codes$country <- "USA"
#write.csv(study_postal_codes, paste0(input_path, "input_data/study_area_us.csv"))
#all_city_index <- rbind(study_das %>% dplyr::select(-X), study_postal_codes)
#write.csv(all_city_index, paste0(input_path, "input_data/all_city_index.csv"))

#can_shapefile <- st_transform(can_shapefile, st_crs("+proj=longlat +datum=WGS84"))
#(can_shapefile) <- c("postal_code", "geometry")
#us_shapefile <- st_transform(us_shapefile, st_crs("+proj=longlat +datum=WGS84"))
#colnames(us_shapefile) <- c("postal_code", "geometry")
#all_shapefile <- rbind(can_shapefile, us_shapefile)








