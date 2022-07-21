library(readxl)
library(stringr)
library(glue)
library(zoo)
library(tidyverse)
library(broom)
library(dplyr)
library(scales)
library(sf)
library(sp)
library(geojsonio)
library(lehdr)
options(scipen = 999)
rm(list = ls())
path <- path <- "E:\\jup/multi_city_covid19_recovery_analysis_website/shinyapp/"
all_city_coords_lqs <- read.csv(paste(path, "input_data/all_city_coords_lqs.csv", sep = ""))
us_states <- all_city_coords_lqs %>%
  dplyr::filter(country == "USA")
all_states <- unique(us_states$state)
lodes_types <- c("od", "rac", "wac")
job_types <- c("JT00", "JT01", "JT02", "JT03", "JT04", "JT05")
segments <- c("S000", "SA01", "SA02", "SA03", "SE01", "SE02", "SE03", "SI01", "SI02", "SI03")
agg_geo <- "bg"
year <- 2019
state_parts <- c("main","aux")

downtown_cbgs <- read.csv(paste0(path, "input_data/downtown_cbg_2010.csv"))
downtown_cbgs <- downtown_cbgs %>%
  mutate(downtown_cbg = as.numeric(downtown_cbg))


all_lodes <- as.data.frame(grab_lodes(state = all_states[1],
                        year = 2019,
                        lodes_type = lodes_types[3],
                        job_type = job_types[1],
                        segment = segments[1],
                        agg_geo = "bg",
                        state_part = state_parts[1],
                        download_dir = paste0(path, "lodes"),
                        use_cache = TRUE))
all_lodes <- all_lodes %>%
  mutate(w_bg = as.numeric(w_bg))


all_lodes <- inner_join(all_lodes, downtown_cbgs, by = c("w_bg" = "downtown_cbg"))

for (states in all_states[-1]) {
  
  cities <- us_states %>%
    dplyr::filter(state == states) %>%
    dplyr::select(city)
  
  dt_cbg_cities <- downtown_cbgs %>%
    dplyr::filter(city %in% cities$city)
  
  
  
  aggregated_lodes <- as.data.frame(grab_lodes(state = states,
             year = 2019,
             lodes_type = lodes_types[3],
             job_type = job_types[1],
             segment = segments[1],
             agg_geo = "bg",
             state_part = state_parts[1],
             download_dir = paste0(path, "lodes"),
             use_cache = TRUE))
  
  aggregated_lodes <- aggregated_lodes %>%
    mutate(w_bg = as.numeric(w_bg))
  
  aggregated_lodes <- inner_join(aggregated_lodes, downtown_cbgs, by = c("w_bg" = "downtown_cbg"))
  
  print(unique(cities$city))
  
  downtown_cbgs_state <- dt_cbg_cities %>%
    dplyr::arrange(-downtown_cbg) %>%
    dplyr::select(downtown_cbg)
  aggregated_lodes_state <- aggregated_lodes %>%
    dplyr::arrange(-w_bg) %>%
    dplyr::select(w_bg)
  
  print(dim(dt_cbg_cities)[1])
  print(setdiff(downtown_cbgs_state$downtown_cbg, aggregated_lodes_state$w_bg))
  print(dim(aggregated_lodes)[1])
  print(setdiff(aggregated_lodes_state$w_bg, downtown_cbgs_state$downtown_cbg))
  print(intersect(aggregated_lodes_state$w_bg, downtown_cbgs_state$downtown_cbg))
  
  all_lodes <- rbind(all_lodes, aggregated_lodes)
}

all_lodes <- left_join(downtown_cbgs, all_lodes, by = c("downtown_cbg" = "w_bg"))




write.csv(all_lodes, paste0(path, "input_data/downtown_cbg_lodes.csv"))
