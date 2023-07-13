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


path <- "E:\\jup/multi_city_covid19_recovery_analysis_website/shinyapp/"

### CANADA ###
canadian_shapefile_full <- st_read("E:\\jup/multi_city_covid_19_recovery_analysis/lda_000b16a_e.shp")
canadian_shapefile_full <- canadian_shapefile_full %>%
  mutate(DAUID = as.numeric(DAUID))

can_city_index <- read.csv(paste(path, "input_data/can_city_index.csv", sep = ""))

canadian_shapefile <- inner_join(canadian_shapefile_full, can_city_index, by = c("DAUID" = "postal_code"))

st_write(canadian_shapefile, paste(path, "can_shp/study_area_canada.shp", sep = ""))

### US ###
us_shapefile_full <- st_read(paste(path, "us_shp/cb_2018_us_zcta510_500k.shp", sep = ""))
us_shapefile_full <- us_shapefile_full %>%
  mutate(ZCTA5CE10 = as.numeric(ZCTA5CE10))

study_postal_codes <- read.csv(paste(path, "input_data/study_area_us.csv", sep = ""))
study_postal_codes <- study_postal_codes %>%
  mutate(postal_code = as.numeric(postal_code))

us_shapefile <- inner_join(us_shapefile_full, study_postal_codes, by = c("ZCTA5CE10" = "postal_code"))

st_write(us_shapefile, paste(path, "us_shp/study_area_us.shp", sep = ""))


all_city_coords$lat  <- as.numeric(all_city_coords$lat)
all_city_coords$long  <- as.numeric(all_city_coords$long)

all_city_coords.SP <- SpatialPointsDataFrame(all_city_coords[,c(3, 2)], all_city_coords[,-c(3, 2)] %>% as.data.frame())

all_city_coords <- st_as_sf(all_city_coords, coords = c("long", "lat"), crs = 4326)
st_write(all_city_coords, "E:\\jup/multi_city_covid19_recovery_analysis_website/mc_cov19_ra/input_data/can_us_cities.geojson")
#writeOGR(all_city_coords.SP, 'can_us_cities.geojson', 'can_us_cities', driver = 'GeoJSON')


weekly_concurrent_vars <- read.csv(paste(path, "input_data/weekly_concurrent_vars.csv", sep = ""))
monthly_concurrent_vars <- read.csv(paste(path, "input_data/monthly_concurrent_vars.csv", sep = ""))
city_lqs_with_attributes_0322 <- read.csv(paste(path, "input_data/city_attributes.csv", sep = ""))

study_das <- read.csv(paste(path, "input_data/study_area_canada.csv", sep = ""))
study_postal_codes <- read.csv(paste(path, "input_data/study_area_us.csv", sep = ""))
can_shapefile <- st_read(paste(path, "shp/study_area_canada.shp", sep = ""))
us_shapefile <- st_read(paste(path, "shp/study_area_us.shp", sep = ""))

### updated metrics - 2022.04.07 ###
downtown_rec <- read.csv(paste(path, "input_data/downtown_rec_df_0407.csv", sep = ""))
metro_rec <- read.csv(paste(path, "input_data/metro_rec_df_0407.csv", sep = ""))
relative_rec <- read.csv(paste(path, "input_data/relative_rec_df_0407.csv", sep = ""))
all_city_coords <- geojson_read(paste(path, "input_data/can_us_cities.geojson", sep = ""), what = "sp")
#all_city_coords_lqs <- read.csv(paste(path, "input_data/all_city_coords_lqs.csv", sep = ""))

city_attributes <- city_lqs_with_attributes_0322 %>%
  dplyr::select(-starts_with("lq"), -ends_with("recovery"), -omicron_resilience)

downtown_rec <- downtown_rec %>%
  dplyr::select(city, state, period_1, period_2, period_3, period_4, rate_of_recovery, omicron_resilience)
city_downtown_rec_with_attributes <- inner_join(city_attributes, downtown_rec, on = "city")
city_downtown_rec_with_attributes$metric <- "downtown"

metro_rec <- metro_rec %>%
  dplyr::select(city, state, period_1, period_2, period_3, period_4, rate_of_recovery, omicron_resilience)

city_metro_rec_with_attributes <- inner_join(city_attributes, metro_rec, on = "city")
city_metro_rec_with_attributes$metric <- "metro"

relative_rec <- relative_rec %>%
  dplyr::select(city, state, period_1, period_2, period_3, period_4, rate_of_recovery, omicron_resilience)
city_relative_rec_with_attributes <- inner_join(city_attributes, relative_rec, on = "city")
city_relative_rec_with_attributes$metric <- "relative"

data_df <- rbind(city_downtown_rec_with_attributes,
                 city_metro_rec_with_attributes,
                 city_relative_rec_with_attributes)

data_df$state <- str_replace(data_df$state, " ", "")


#weekly_concurrent_vars$date <- as.Date(weekly_concurrent_vars$date)
#monthly_concurrent_vars$date <- as.Date(monthly_concurrent_vars$date)
#lq_rankings$date <- as.Date(lq_rankings$dates)
#lq_rankings <- lq_rankings %>%
#  dplyr::select(-dates)

# city <-> postal_code / DAUID files

# canada

study_das <- study_das %>%
  mutate(postal_code = as.numeric(DAUID))
study_das <- study_das %>%
  dplyr::select(-DAUID)
study_das <- study_das %>%
  dplyr::filter(city != "Hamilton")

# lat/long coordinates for cities
can_cities_df <- canada_cities
can_cities_df$city <- substr(can_cities_df$name, 1, (nchar(can_cities_df$name) - 3))
can_cities_df[can_cities_df$city == "OTTAWA","city"] <- "Ottawa"

can_cities_study <- semi_join(can_cities_df, data_df, by = c("city" = "city", "country.etc" = "state"))
can_cities_study <- can_cities_study %>%
  dplyr::select(city, country.etc, lat, long)

# us

study_postal_codes <- study_postal_codes %>%
  mutate(postal_code = as.numeric(postal_code))

us_cities_df <- us_cities
us_cities_df$city <- substr(us_cities_df$name, 1, (nchar(us_cities_df$name) - 3))
us_cities_df[us_cities_df$city == "WASHINGTON", "city"] <- "Washington DC"
us_cities_df[us_cities_df$city == "Saint Louis", "city"] <- "St Louis"

relative_rec %>%
  dplyr::filter(!(city %in% us_cities_df$city)
                  #(state %in% us_cities_df$country.etc) &
                  #(metric == "downtown")
                  ) %>%
  dplyr::select(city, state)



us_cities_study <- semi_join(us_cities_df, data_df, by = c("city" = "city", "country.etc" = "state"))
us_cities_study <- us_cities_study %>%
  dplyr::select(city, country.etc, lat, long)


all_city_coords <- rbind(can_cities_study, us_cities_study)

sort(unique(data_df$city))
sort(unique(all_city_coords$city))
all_city_coords_lqs <- left_join(data_df, all_city_coords, by = c("city" = "city", "state" = "country.etc"))
write.csv(all_city_coords_lqs, paste(path, "input_data/all_city_coords_lqs.csv", sep = ""))


all_city_coords <- st_as_sf(all_city_coords, coords = c("long", "lat"), crs = 4326)
st_write(all_city_coords, "E:\\jup/multi_city_covid19_recovery_analysis_website/mc_cov19_ra/input_data/can_us_cities.geojson")

# altogether
all_postal_codes_to_city <- rbind(study_das, study_postal_codes)


# import shapefiles
# canada
can_shapefile <- st_read(paste0(path, "can_shp/study_area_canada.shp"))
can_census_data <- read.csv("E:\\jup/multi_city_covid_19_recovery_analysis/canadian_census_data_da.csv")
can_census_data <- can_census_data %>%
  dplyr::select(GeoUID, Area..sq.km.)

can_shapefile <- st_transform(can_shapefile, st_crs("+proj=longlat +datum=WGS84"))
can_shapefile <- can_shapefile %>%
  dplyr::select(DAUID, geometry)

can_shapefile_area <- inner_join(can_shapefile, can_census_data, by = c("DAUID" = "GeoUID"))

colnames(can_shapefile_area) <- c("postal_code", "area_m2", "geometry")
can_shapefile_area$area_m2 <- 1000 * can_shapefile_area$area_m2
# us
us_shapefile <- st_read(paste0(path, "us_shp/study_area_us.shp"))
us_shapefile <- st_transform(us_shapefile, st_crs("+proj=longlat +datum=WGS84"))
us_shapefile <- us_shapefile %>%
  dplyr::select(ZCTA5CE, ALAND10, geometry)

colnames(us_shapefile) <- c("postal_code", "area_m2", "geometry")

# altogether
all_shapefile <- rbind(can_shapefile_area, us_shapefile)

# altogether with city
#all_shapefile <- left_join(all_shapefile, all_postal_codes_to_city, on = "postal_code")
st_write(all_shapefile, paste0(path, "shp/all_shapefile_area.shp"))

#df_sf <- left_join(all_shapefile, city_lqs_with_attributes_0322, on = "city")




