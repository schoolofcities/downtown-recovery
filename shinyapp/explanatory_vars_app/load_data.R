## includes code adapted from the following sources:
# https://github.com/rstudio/shiny-examples/blob/master/087-crandash/
# https://github.com/eparker12/nCoV_tracker
# https://rviews.rstudio.com/2019/10/09/building-interactive-world-maps-in-shiny/
# https://github.com/rstudio/shiny-examples/tree/master/063-superzip-example

# shinyapps.io compatible package loading
# cannot use anything other than explicitly listing library(package)
library(ggplot2)
library(thematic)
library(markdown)
library(readxl)
library(glue)
library(bsselectR)
library(stringr)
library(ggrepel)
library(ggpmisc)
library(shiny.router)
library(ggiraph)
library(shinyLP)
library(shinyBS)
library(crosstalk)
library(zoo)
library(tidyverse)
library(broom)
library(dplyr)
library(htmlwidgets)
library(leaflet)
library(scales)
library(shiny)
library(shinyWidgets)
library(shinythemes)
library(sf)
library(sp)
library(spdep)
library(plotly)
library(geojsonio)

explanatory_vars <- read.csv("input_data/explanatory_vars.csv")

# 2022-07-15: updates: anything pertaining to single city map tab has been removed
# this is a 'policy brief only' version of the app

all_weekly_metrics <- read.csv("input_data/all_weekly_metrics.csv")
all_weekly_metrics$metric <- str_replace(all_weekly_metrics$metric, "metro", "city")
all_city_coords <- read.csv("input_data/all_city_coords.csv")
all_seasonal_metrics <- read.csv("input_data/all_seasonal_metrics.csv")

# to automatically apply the shinytheme to all ggplots for consistency's sake
thematic_shiny()

all_seasonal_metrics <- all_seasonal_metrics %>%
  dplyr::select(
    city,
    display_title,
    metric,
    starts_with("Season"),
    region
  )

# 2022/07/15: remove outlier cities 
outlier_cities <- c("Dallas", "Hamilton", "Mississauga", "Orlando", "Oklahoma City")

all_seasonal_metrics <- all_seasonal_metrics %>%
  dplyr::filter(!(city %in% outlier_cities))

all_weekly_metrics <- all_weekly_metrics %>%
  dplyr::filter(!(city %in% outlier_cities))

all_city_coords <- all_city_coords %>%
  dplyr::filter(!(city %in% outlier_cities))

explanatory_vars <- explanatory_vars %>%
  dplyr::filter(!(city %in% outlier_cities))

# the 26th most populous city is denver, that is the cutoff point for large/medium
# this is using the population data from can_city_with_pop.csv and us_city_with_pop.csv from 03/22/2022
# this was manually set but can be updated with however you want to define metro_size
# you can drop the population col from regions_df and left_join with some other table with city and population info and use this

# also maybe save a lat and long col to this so that way all the geographic information is in one table
regions_df <- read.csv("input_data/regions.csv")

regions_df <- regions_df %>%
  dplyr::filter(!(city %in% outlier_cities))


n = 26
largest_n_cities <- regions_df %>%
  dplyr::filter(!(city %in% outlier_cities)) %>%
  dplyr::arrange(-population) %>%
  mutate(pop_rank = rank(-population)) %>%
  dplyr::filter(pop_rank <= n) %>%
  dplyr::select(city)

# explanatory_vars already has a metro_size col from when it was created on databricks, but it's reassigned here just in case
# you did want to do a quick change in definition to metro_size without having to recreate or redownload anything
explanatory_vars <- explanatory_vars %>%
   #mutate(metro_size = case_when(
  #   city %in% largest_n_cities$city ~ "large",!(city %in% largest_n_cities$city) ~ "medium"
  # )) %>%
  dplyr::filter(Season == "Season_9")

all_weekly_metrics$week <-
  as.Date(all_weekly_metrics$week, format = "%Y-%m-%d")

all_city_coords <- all_city_coords %>%
  dplyr::select(lat, long, city)

all_seasonal_metrics <- all_seasonal_metrics %>%
  inner_join(all_city_coords, by = "city") %>%
  #mutate(metro_size = case_when(
  #  city %in% largest_n_cities$city ~ "large",!(city %in% largest_n_cities$city) ~ "medium"
  #)) %>%
  dplyr::filter(Season == "Season_9")

# 2022/07/15 TODO: whittle this down a bit more
named_factors <- c(
  # census vars - these have both city and downtown geographies
  #"Total Jobs in Downtown" = "total_jobs", # always downtown (note: this does not actually exist in the us_can_census_vars table)
  # city
  "Total Population in City" = "total_pop_city", 
  "Population Density in City" = "population_density_city",
  "Total Housing Stock in City" = "housing_units_city", 
  "Housing Density in City" = "housing_density_city", 
  "Percentage of Rented-Occupied Units in City" = "pct_renter_city", 
  "Percentage of Single-Family Homes in City" = "pct_singlefam_city", 
  "Percentage of Multi-Family Homes in City" = "pct_multifam_city",
  #"Percentage of Mobile Homes and Others" = "pct_mobile_home_and_others",
  "Median Age of Residents in City" = "median_age_city",
  "Percentage of Residents with a Bachelor's Degree or Higher in City" = "bachelor_plus_city",
  "Percentage of Vacant Housing Units in City" = "pct_vacant_city",
  "Median Rent of Housing Units in City" = "median_rent_city",
  "Median Household Income of Residents in City" = "median_hhinc_city",
  # downtown
  "Total Population in Downtown" = "total_pop_downtown", 
  "Population Density in Downtown" = "population_density_downtown",
  "Total Housing Stock in Downtown" = "housing_units_downtown", 
  "Housing Density in Downtown" = "housing_density_downtown", 
  "Percentage of Rented-Occupied Units in Downtown" = "pct_renter_downtown", 
  "Percentage of Single-Family Homes in Downtown" = "pct_singlefam_downtown", 
  "Percentage of Multi-Family Homes in Downtown" = "pct_multifam_downtown",
  #"Percentage of Mobile Homes and Others" = "pct_mobile_home_and_others",
  "Median Age of Residents in Downtown" = "median_age_downtown",
  "Percentage of Residents with a Bachelor's Degree or Higher in Downtown" = "bachelor_plus_downtown",
  "Percentage of Vacant Housing Units in Downtown" = "pct_vacant_downtown",
  "Median Rent of Housing Units in Downtown" = "median_rent_downtown",
  "Median Household Income of Residents in Downtown" = "median_hhinc_downtown",
  
  "Percentage of White Residents in City" = "pct_nhwhite_city", # always city
  "Percentage of Black Residents in City" = "pct_nhblack_city", # always city
  "Percentage of Hispanic Residents in City" = "pct_hisp_city", # always city
  "Percentage of Asian Residents in City" = "pct_nhasian_city", # always city
  #"Percentage of Residents with Other Races" = "pct_other", # always city
  "Percentage of Residents in City who Commute to Work by Car" = "pct_commute_auto_city", # always city
  "Percentage of Residents in City who Commute to Work by Public Transit" = "pct_commute_public_transit_city", # always city
  "Percentage of Residents in City who Commute to Work by Bicycle" = "pct_commute_bicycle_city", # always city
  "Percentage of Residents in City who Commute to Work by Walking" = "pct_commute_walk_city", # always city
  "Percentage of Residents in City who Commute to Work by Other Modes" = "pct_commute_others_city", # always city
  "Average City-wide Commute Time" = "average_commute_time_city", #always city
  # LEHD / employment vars, always downtown
  "Employment Density in Downtown" = "employment_density_downtown",
  "Employment Entropy in Downtown" = "employment_entropy",
  "Percentage of Jobs in Agriculture, Forestry, Fishing, and Hunting in Downtown" = "pct_jobs_agriculture_forestry_fishing_hunting",
  "Percentage of Jobs in Mining, Quarrying, Oil, and Gas in Downtown" = "pct_jobs_mining_quarrying_oil_gas",
  "Percentage of Jobs in Utilities in Downtown" = "pct_jobs_utilities",
  "Percentage of Jobs in Construction in Downtown" = "pct_jobs_construction",
  "Percentage of Jobs in Manufacturing in Downtown" = "pct_jobs_manufacturing",
  "Percentage of Jobs in Wholesale Trade in Downtown" = "pct_jobs_wholesale_trade",
  "Percentage of Jobs in Retail Trade in Downtown" = "pct_jobs_retail_trade",
  "Percentage of Jobs in Transportation and Warehousing in Downtown" = "pct_jobs_transport_warehouse",
  "Percentage of Jobs in Information in Downtown" = "pct_jobs_information",
  "Percentage of Jobs in Finance & Insurance in Downtown" = "pct_jobs_finance_insurance",
  "Percentage of Jobs in Real Estate in Downtown" = "pct_jobs_real_estate",
  "Percentage of Jobs in Professional, Scientific, and Management in Downtown" = "pct_jobs_professional_science_techical",
  "Percentage of Jobs in Management in Downtown" = "pct_jobs_management_of_companies_enterprises",
  "Percentage of Jobs in Administrative Support & Waste Management in Downtown" = "pct_jobs_administrative_support_waste",
  "Percentage of Jobs in Educational Services in Downtown" = "pct_jobs_educational_services",
  "Percentage of Jobs in Healthcare & Social Assistance in Downtown" = "pct_jobs_healthcare_social_assistance",
  "Percentage of Jobs in Arts, Entertainment, and Recreation in Downtown" = "pct_jobs_arts_entertainment_recreation",
  "Percentage of Jobs in Accommodation & Food Services in Downtown" = "pct_jobs_accomodation_food_services",
  "Percentage of Jobs in Public Administration in Downtown" = "pct_jobs_public_administration",
  #"Percentage of Jobs in Other Categories in Downtown" = "pct_jobs_other",
  # covid policies, all at city level
  "Composite of COVID-19 Closing Policies" = "composite_closing",
  "Composite of COVID-19 Economic Policies" = "composite_economic",
  #"Average of C1_School closing" = "school_closing",
  #"Average of C2_Workplace closing" = "workplace_closing",
  #"Average of C3_Cancel public events" = "cancel_public_events",
  #"Average of C4_Restrictions on gatherings" = "restrict_gatherings",
  #"Average of C6_Stay at home requirements" = "stay_at_home",
  #"Average of E1_Income support" = "income_support",
  #"Average of E2_Debt relief" = "debt_relief",
  #"Average of H6_Facial Coverings" = "facial_coverings",
  #"Average of H7_Vaccination policy" = "vaccination_policy",
  # political leaning - city level
  "Percentage Liberal Leaning" = "pct_liberal_leaning",
  "Percentage Conservative Leaning" = "pct_conservative_leaning"
  # "Percentage Other Leaning" = "pct_other"
  #weather - all at city level
)

# 2022/07/15 update: everything is a 3 month season
named_periods <- c(
  "Spring: Mar 2020 - May 2020" = "Season_1",
  "Summer: June 2020 - Aug 2020" = "Season_2",
  "Fall: Sept 2020 - Nov 2020" = "Season_3",
  "Winter: Dec 2020 - Feb 2021" = "Season_4",
  "Spring: Mar 2021 - May 2021" = "Season_5",
  "Summer: June 2021 - Aug 2021" = "Season_6",
  "Fall: Sept 2021 - Nov 2021" = "Season_7",
  "Winter: Dec 2021 - Feb 2022" = "Season_8",
  "Spring: Mar 2022 - May 2022" = "Season_9"
  
)

named_metrics <- c(
  "Recovery Quotient (RQ) Downtown" = "downtown",
  "Recovery Quotient (RQ) City" = "city",
  "Location Quotient (LQ)" = "relative"
)

# 2022/07/15 update: use normalized_visits_by_total_visits
# named_sg_field_type <- c(
#   "Normalized visits by total visits" = "normalized_visits_by_total_visits",
#   "Normalized visits by state scaling" = "normalized_visits_by_state_scaling"
#   
# )

# create single var explanatory plot df
# downtown_attributes <- explanatory_vars_wide %>%
#   dplyr::select(-ends_with("_city")) %>%
#   dplyr::rename_with(~str_remove(., "_downtown")) %>%
#   dplyr::mutate(geography = "downtown")
# 
# city_attributes <- explanatory_vars_wide %>%
#   dplyr::select(-ends_with("_downtown"), -employment_entropy, -starts_with("pct_jobs")) %>%
#   dplyr::rename_with(~str_remove(., "_city")) %>%
#   dplyr::mutate(geography = "city")
# 
# explanatory_vars <- dplyr::bind_rows(downtown_attributes, city_attributes)


# selects the top 3 of each region to plot by default
explanatory_cities <- regions_df %>%
  group_by(region) %>%
  dplyr::arrange(-population) %>%
  dplyr::slice_head(n = 3)

patterns_cities <- regions_df %>%
  group_by(region) %>%
  dplyr::arrange(-population) %>%
  dplyr::slice_head(n = 1)

ranking_cities <- regions_df %>%
  group_by(region) %>%
  dplyr::arrange(-population) %>%
  dplyr::slice_head(n = 5)

# get random subset of those cities to initialize city select plots
regions_choices <- lapply(split(regions_df$display_title, regions_df$region), as.list)

selected_regions <- unlist(lapply(regions_choices, sample, 5))

card <- function(.img, .title, .text, .tab) {
  # creates a card with the provided background image, title, text, and tab that it should link to
  HTML(
    paste0(
      '
       <div class="col-md-4">
          <div class="card mb-4 box-shadow">
            <img class="bg-img card-img-top" width="100%" height="100%" src="', .img, '" role="img"aria-label="Recovery ranking: Thumbnail" preserveAspectRatio="xMidYMid slice" focusable="false"/>
              <div class="card-body">
                <h5 class="card-title">', .title, '</h5>
                <p class="card-text">', .text, '</p>
                <div class="d-flex align-items-start">
                  <div class="btn btn-primary data-page-btn" onclick="fakeClick(\'', .tab,'\')">View</div>
                </div>
              </div>
            </div>
      </div>'
    )
  )
}

# all_shapefile <- st_read("shp/study_area_all.shp")
# 
# all_shapefile <-
#   st_transform(all_shapefile, st_crs("+proj=longlat +datum=WGS84"))
# colnames(all_shapefile) <- c("postal_code", "geometry")

all_city_index <- read.csv("input_data/all_city_index.csv")

#all_shapefile <- inner_join(all_shapefile, all_city_index, by = "postal_code")