# creates data ready for scatter plot in javascript on downtownrecovery.com

rm(list = ls())
gc()

setwd("~/git/downtown-recovery/shinyapp")

outlier_cities <- c("Dallas", "Oklahoma City", "Orlando")

# 2023-01: cuebiq data and color update
region_colors <- c("Canada" = "#DC4633",
                   "Midwest" = "#6FC7EA",
                   "Northeast" = "#8DBF2E",
                   "Pacific" = "#00A189",
                   "Southeast" = "#AB1368",
                   "Southwest" = "#F1C500")

colors_df <- data.frame(region = names(region_colors), color = region_colors)
colors_df

plot_x_vars  <- c(
  # census vars - these have both city and downtown geographies
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
  #"Percentage of Mobile Homes and Others in Downtown" = "pct_mobile_home_and_others",
  "Median Age of Residents in Downtown" = "median_age_downtown",
  "Percentage of Residents with a Bachelor's Degree or Higher in Downtown" = "bachelor_plus_downtown",
  "Percentage of Vacant Housing Units in Downtown" = "pct_vacant_downtown",
  "Median Rent of Housing Units Downtown" = "median_rent_downtown",
  "Median Household Income of Residents in Downtown" = "median_hhinc_downtown",
  "Percentage of White Residents in Downtown" = "pct_nhwhite_downtown", # always city
  "Percentage of Black Residents in Downtown" = "pct_nhblack_downtown", # always city
  "Percentage of Hispanic Residents in Downtown" = "pct_hisp_downtown", # always city
  "Percentage of Asian Residents in Downtown" = "pct_nhasian_downtown", # always city
  
  
  "Percentage of White Residents in City" = "pct_nhwhite_city", # always city
  "Percentage of Black Residents in City" = "pct_nhblack_city", # always city
  "Percentage of Hispanic Residents in City" = "pct_hisp_city", # always city
  "Percentage of Asian Residents in City" = "pct_nhasian_city", # always city
  #"Percentage of Residents with Other Races in City" = "pct_other", # always city
  "Percentage of Residents in City who Commute to Work by Car" = "pct_commute_auto_city", # always city
  "Percentage of Residents in City who Commute to Work by Public Transit" = "pct_commute_public_transit_city", # always city
  "Percentage of Residents in City who Commute to Work by Bicycle" = "pct_commute_bicycle_city", # always city
  "Percentage of Residents in City who Commute to Work by Walking" = "pct_commute_walk_city", # always city
  #"Percentage of Residents in City who Commute to Work by Other Modes" = "pct_commute_others_city", # always city
  "Average City-wide Commute Time (Minutes)" = "average_commute_time_city", #always city
  # LEHD / employment vars, always downtown
  "Employment Density" = "employment_density_downtown",
  "Employment Entropy" = "employment_entropy",
  "Percentage of Jobs in Agriculture, Forestry, Fishing, and Hunting" = "pct_jobs_agriculture_forestry_fishing_hunting",
  "Percentage of Jobs in Mining, Quarrying, Oil, and Gas" = "pct_jobs_mining_quarrying_oil_gas",
  "Percentage of Jobs in Utilities" = "pct_jobs_utilities",
  "Percentage of Jobs in Construction" = "pct_jobs_construction",
  "Percentage of Jobs in Manufacturing" = "pct_jobs_manufacturing",
  "Percentage of Jobs in Wholesale Trade" = "pct_jobs_wholesale_trade",
  "Percentage of Jobs in Retail Trade" = "pct_jobs_retail_trade",
  "Percentage of Jobs in Transportation and Warehousing" = "pct_jobs_transport_warehouse",
  "Percentage of Jobs in Information" = "pct_jobs_information",
  "Percentage of Jobs in Finance & Insurance" = "pct_jobs_finance_insurance",
  "Percentage of Jobs in Real Estate" = "pct_jobs_real_estate",
  "Percentage of Jobs in Professional, Scientific, and Technical" = "pct_jobs_professional_science_techical",
  "Percentage of Jobs in Management" = "pct_jobs_management_of_companies_enterprises",
  "Percentage of Jobs in Administrative Support & Waste Management" = "pct_jobs_administrative_support_waste",
  "Percentage of Jobs in Educational Services" = "pct_jobs_educational_services",
  "Percentage of Jobs in Healthcare & Social Assistance" = "pct_jobs_healthcare_social_assistance",
  "Percentage of Jobs in Arts, Entertainment, and Recreation" = "pct_jobs_arts_entertainment_recreation",
  "Percentage of Jobs in Accommodation & Food Services" = "pct_jobs_accomodation_food_services",
  "Percentage of Jobs in Public Administration" = "pct_jobs_public_administration",
  #"Percentage of Jobs in Other Categories" = "pct_jobs_other",
  # covid policies, all at city level
  #"Composite of COVID-19 Closing Policies" = "composite_closing",
  #"Composite of COVID-19 Economic Policies" = "composite_economic",
  
  "Number of days with required school closure" = "days_school_closing",
  "Number of days with required workplace closure" = "days_workplace_closing",
  "Number of days with required large event cancellation" = "days_cancel_large_events",
  "Number of days with required cancellation of all events" = "days_cancel_all_events",
  "Number of days with stay at home requirements" = "days_stay_home_requirements",
  "Number of days with income support policy" = "days_income_support",
  "Number of days with mask mandates" = "days_mask_mandates",
  # political leaning - city level
  #"Percentage Liberal Leaning" = "pct_liberal_leaning",
  #"Percentage Conservative Leaning" = "pct_conservative_leaning"
  # "Percentage Other Leaning" = "pct_other"
  #weather - all at city level
  "Average Winter Temperature (F)" = "winter_avg_temp",
  "Average Spring Temperature (F)" = "spring_avg_temp",
  "Average Summer Temperature (F)" = "summer_avg_temp",
  "Average Fall Temperature (F)" = "fall_avg_temp"
)

all_seasonal_metrics <- read.csv("input_data/all_seasonal_metrics_cuebiq_update_hll.csv")

all_seasonal_metrics <- all_seasonal_metrics %>%
  filter(!(city %in% outlier_cities))
explanatory_vars <- read.csv("input_data/all_model_features_1015_weather.csv")

y <- all_seasonal_metrics %>%
  dplyr::select(city, display_title, Season, seasonal_average, metric)

X <- explanatory_vars %>%
  left_join(all_seasonal_metrics %>% distinct(city, region)) %>%
  dplyr::select(city, region, all_of(unname(plot_x_vars)))

plot_data <- unique(y %>%
                      inner_join(X, by = c("city")) %>%
                      dplyr::filter(!is.na(seasonal_average))
)

plot_data %>% glimpse()

plot_data %>%
  group_by(Season) %>%
  count()


summary(plot_data)

write.csv(plot_data, "../docs/model_data_full_cuebiq_update_hll.csv")

metrics_format <- plot_data %>%
  dplyr::select(-city) %>%
  pivot_wider(names_from = "metric", values_from = "seasonal_average") %>%
  inner_join(colors_df) %>%
  distinct() %>%
  arrange(region, display_title) %>%
  replace_na(list(city = 0, relative = 0))

write.csv(metrics_format, "../docs/model_data_metrics_cuebiq_update_hll.csv")
