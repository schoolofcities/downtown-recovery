library(ggplot2)
library(thematic)
library(markdown)
library(readxl)
library(stringr)
library(ggrepel)
library(ggpmisc)
library(shiny.router)
library(shinyLP)
library(shinyBS)
library(zoo)
library(tidyverse)
library(broom)
library(dplyr)
library(leaflet)
library(scales)
library(shiny)
library(shinyWidgets)
library(shinythemes)
library(sf)
library(sp)
library(spdep)
library(geojsonio)

oxford_vars <- read.csv("input_data/oxford_explanatory_vars.csv")

all_attributes <- read.csv("input_data/us_can_census_variables_0626.csv")

voter_results <- read.csv("input_data/political_leaning.csv")

oxford_vars$city <- str_replace(oxford_vars$city, "é", "e")
all_attributes$city <- str_replace(all_attributes$city, "é", "e")
voter_results$city <- str_replace(voter_results$city, "é", "e")



explanatory_vars <- oxford_vars %>% inner_join(all_attributes, by = "city") %>% inner_join(voter_results %>% select(-state), by = "city")

write.csv(explanatory_vars, "input_data/explanatory_vars.csv")
