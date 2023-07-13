library(readxl)
library(dplyr)
library(stringr)
library(tidyverse)
library(lubridate)

# clear environment
rm(list = ls())
path <- "~/git/mc-covid19-dtra/shinyapp/"

all_dc <- read.csv(paste0(path, "device_counts/all_dc.csv"))
all_city_index <- read.csv(paste0(path, "input_data/all_city_index.csv"))

placekeys <- read.csv(paste0(path, "device_counts/placekeys.csv"))

# rename this to whatever the new_weekly_counts is when you get it
new_counts <- read.csv(paste0(path, "device_counts/counts_2022_primary.csv"))

new_counts <- left_join(new_counts, placekeys %>% dplyr::select(placekey, postal_code), by = "placekey") %>%
  left_join(all_city_index, by = "postal_code")

all_dc$city <- str_replace(all_dc$city, "Ã©", "e")

all_dc <- all_dc %>%
  dplyr::select(-raw_visit_counts, -X, -normalized_visits_by_total_visits)

# always necessary whenever reading in csv so the dates aren't treated like string literals
all_dc$date_range_start <- as.Date(all_dc$date_range_start, format = "%Y-%m-%d")

all_dc <- all_dc %>%
  group_by(postal_code, city, is_downtown, date_range_start) %>%
  summarise(nvs = sum(normalized_visits_by_state_scaling)) %>%
  ungroup()


all_dc <- all_dc %>%
  mutate(year = lubridate::year(all_dc$date_range_start),
         isoweek_num = lubridate::isoweek(all_dc$date_range_start))



all_nvs_w_weekly_lq <- all_dc %>%
  dplyr::select(-date_range_start) %>%
  distinct(postal_code, city, is_downtown, isoweek_num, year, .keep_all = TRUE) %>%
  pivot_wider(names_from = year, names_prefix = "nvs_", values_from = nvs) %>%
  mutate(weekly_lq_2022 = as.numeric(nvs_2022) / as.numeric(nvs_2019),
         weekly_lq_2021 = as.numeric(nvs_2021) / as.numeric(nvs_2019),
         weekly_lq_2020 = as.numeric(nvs_2020) / as.numeric(nvs_2019)) %>%
  pivot_longer(cols = starts_with("weekly"), names_to = "year", values_to = "weekly_lq")

all_nvs_w_weekly_lq$year <- substr(all_nvs_w_weekly_lq$year, 11, 14)
all_nvs_w_weekly_lq$date_range_start <- as.Date(paste(all_nvs_w_weekly_lq$year, all_nvs_w_weekly_lq$isoweek_num, 1, sep = "-"),
                                                  format = "%Y-%W-%u")

all_nvs_w_weekly_lq <- all_nvs_w_weekly_lq[!is.na(all_nvs_w_weekly_lq$date_range_start),]

#all_nvs_w_weekly_lq[(all_nvs_w_weekly_lq$date_range_start >= as.Date("2020-03-01")) &
#                      (all_nvs_w_weekly_lq$date_range_start <= as.Date("2020-08-31")), "Period"] = "Period_1"

# all_nvs_w_weekly_lq[(all_nvs_w_weekly_lq$date_range_start >= as.Date("2020-09-01")) &
#                       (all_nvs_w_weekly_lq$date_range_start <= as.Date("2021-02-28")), "Period"] = "Period_2"
# 
# all_nvs_w_weekly_lq[(all_nvs_w_weekly_lq$date_range_start >= as.Date("2021-03-01")) &
#                       (all_nvs_w_weekly_lq$date_range_start <= as.Date("2021-08-31")), "Period"] = "Period_3"

# all_nvs_w_weekly_lq[(all_nvs_w_weekly_lq$date_range_start >= as.Date("2021-09-01")) &
#                       (all_nvs_w_weekly_lq$date_range_start <= as.Date("2022-02-21")), "Period"] = "Period_4"
# 
# 
# all_nvs_w_weekly_lq <- all_nvs_w_weekly_lq[!is.na(all_nvs_w_weekly_lq$Period),]

outlier_cities <-
  c("Dallas", "Mississauga", "Orlando", "Oklahoma City")

city_attributes <-
  read.csv(paste0(path, "input_data/master_factors_display.csv"))
regions_df <- unique(
  city_attributes %>%
    dplyr::select(city, display_title, region, state))

all_nvs_w_weekly_lq <- inner_join(all_nvs_w_weekly_lq %>%
  dplyr::select(postal_code, city, is_downtown, weekly_lq, date_range_start) %>%
  dplyr::filter(!(city %in% outlier_cities)), regions_df, by = "city")

summary(all_nvs_w_weekly_lq$weekly_lq)

# what are the top 5% of LQs?
extreme_weekly_lqs <- all_nvs_w_weekly_lq %>%
  dplyr::arrange(-weekly_lq) %>%
  distinct(postal_code, city, .keep_all = TRUE) %>%
  dplyr::filter(weekly_lq > quantile(all_nvs_w_weekly_lq$weekly_lq, probs = .99, na.rm = TRUE))

# november 9th 2020: washington DC has a weekly LQ of 2,519: the election! 
extreme_weekly_lqs

summary(extreme_weekly_lqs)
all_nvs_w_weekly_lq$postal_code <- as.character(all_nvs_w_weekly_lq$postal_code)

all_nvs_w_monthly_lq_plot <- all_nvs_w_weekly_lq %>% 
  dplyr::filter(weekly_lq <= quantile(all_nvs_w_weekly_lq$weekly_lq, probs = .99, na.rm = TRUE)) %>%
  mutate(month = lubridate::floor_date(date_range_start, unit = "month")) %>%
  group_by(postal_code, is_downtown, region, city, month) %>%
  summarise(avg_lq = mean(weekly_lq)) %>%
  ungroup()



# density plots of cities + weekly lqs
plot_df <- all_nvs_w_monthly_lq_plot %>% dplyr::filter(city == sample(unique(all_nvs_w_monthly_lq_plot$city), 1))
ggplot(plot_df) +
  geom_line(aes(x = month, y = avg_lq, color = is_downtown, group = postal_code), size = 1, alpha = as.numeric(plot_df$is_downtown) + .5) + 
  theme_bw()  +
  labs(title = unique(plot_df$city)) +
  #theme(legend.position = "none")
    scale_color_manual(
      values = c(
        "TRUE" = "#f1a340",
        "FALSE" = "#998ec3"
      )
    ) +
  scale_alpha(limits=c(0.2,1))
  
#write.csv(all_nvs_w_monthly_lq_plot, paste0(path, "aggregates/monthly_lq_by_postal_code.csv"))


test_df <- read.csv(paste0(path, "input_data/metro_rec_df_0407.csv"))

test_df  %>%
  dplyr::filter(city %in% c("Bakersfield", "San Francisco", "Seattle")) %>%
  dplyr::select(city, rec_2022.01:rec_2022.08) %>%
  group_by(city) %>%
  summarise(avg_lq = mean(rec_2022.01:rec_2022.08))








# all_dc[(all_dc$date_range_start >= as.Date("2021-08-30")) &
#                       (all_dc$date_range_start <= as.Date("2022-02-21")), "Period"] = "Period_4"
# 
# all_dc[(all_dc$date_range_start >= as.Date("2019-09-01")) &
#          (all_dc$date_range_start <= as.Date("2020-02-29")), "Period"] = "Pre_COVID"

# all_dc <- all_dc[!is.na(all_dc$Period),]

# these are both already sorted from earlier to later
# period_4_weeks <- unique(all_dc %>% 
#                            dplyr::filter(Period == "Period_4") %>%
#                            dplyr::select(date_range_start))
# period_4_weeks$week_num <- order(period_4_weeks$date_range_start)
# 
# pre_covid_weeks <- unique(all_dc %>% 
#                                dplyr::filter(Period == "Pre_COVID") %>%
#                                dplyr::select(date_range_start))
# 
# pre_covid_weeks$week_num <- order(pre_covid_weeks$date_range_start)
# 
# study_weeks <- rbind(pre_covid_weeks, period_4_weeks)
# 
# all_dc <- inner_join(all_dc, study_weeks, by = "date_range_start")

# canada
#can_city_index <- read.csv(paste0(path, "input_data/can_city_index.csv"))
# can_dc1 <- read.csv(paste0(path, "device_counts/can_0_to_1mil.csv"))
# can_dc2 <- read.csv(paste0(path, "device_counts/can_1mil_to_2mil.csv"))
# can_dc3 <- read.csv(paste0(path, "device_counts/can_2mil_end.csv"))
# 
# all_can_dc <- rbind(can_dc1, can_dc2, can_dc3)
# all_can_dc <- all_can_dc %>%
#   dplyr::select(-city)
# all_can_dc <- semi_join(all_can_dc, can_city_index, by = "postal_code")
# write.csv(all_can_dc, paste0(path, "device_counts/all_can.csv"))
# all_can_dc <- read.csv(paste0(path, "device_counts/all_can.csv"))
# all_can_dc <- left_join(all_can_dc, can_city_index, by = "postal_code")
# all_can_dc <- all_can_dc %>% 
#   dplyr::select(-starts_with("X"))
# 
# 
# # US
# all_us_dc <- read.csv(paste0(path, "device_counts/all_us.csv"))
# # fix this so it's logical instead of character
# us_city_index <- read.csv(paste0(path, "input_data/us_city_index.csv"))
# us_city_index$is_downtown <- as.logical(us_city_index$is_downtown)
# 
# all_us_dc <- inner_join(all_us_dc, us_city_index, by = c("postal_code", "city"))
# 
# all_dc <- rbind(all_can_dc , all_us_dc %>% dplyr::select(-X))
# 
# all_city_index <- rbind(can_city_index %>% dplyr::select(-X), us_city_index)

# write.csv(all_dc, paste0(path, "device_counts/all_dc.csv"))
# write.csv(all_city_index, paste0(path, "input_data/all_city_index.csv"))
#write.csv(all_cities_metro, paste(path, "aggregates/all_metro.csv", sep = ""))
#write.csv(all_cities_downtown, paste(path, "aggregates/all_downtown.csv", sep = ""))


### used to sum by period for requested visualization
# sum_by_date <- function(df) {
#   df %>%
#     dplyr::group_by(date_range_start, Period) %>%
#     dplyr::summarise(raw_visit_counts = sum(raw_visit_counts),
#                      normalized_visits_by_total_visits = sum(normalized_visits_by_total_visits),
#                      normalized_visits_by_state_scaling = sum(normalized_visits_by_state_scaling)) %>%
#     ungroup()
# }
# 
# sum_by_geog <- function(df) {
#   df %>%
#     dplyr::group_by(city, postal_code, Period, is_downtown) %>%
#     dplyr::summarise(raw_visit_counts = sum(raw_visit_counts) / area_m2,
#                      normalized_visits_by_total_visits = sum(normalized_visits_by_total_visits)/ area_m2,
#                      normalized_visits_by_state_scaling = sum(normalized_visits_by_state_scaling)/ area_m2) %>%
#     ungroup()
# }
# 
# all_dc_sum <- na.omit(sum_by_date(all_dc))
# all_dc_sum_downtown <- na.omit(sum_by_date(all_dc %>% dplyr::filter(is_downtown == TRUE)))
# 
# device_counts_viz <- function(df) {
#   plot_df <- df
#   
#   plot_df[plot_df$date_range_start %in% period_1, "Period"] = "Period 1"
#   plot_df[plot_df$date_range_start %in% period_2, "Period"] = "Period 2"
#   plot_df[plot_df$date_range_start %in% period_3, "Period"] = "Period 3"
#   plot_df[plot_df$date_range_start %in% period_4, "Period"] = "Period 4"
#   #plot_df[plot_df$date_range_start %in% period_4a, "Period"] = "Period 4a"
#   #plot_df[plot_df$date_range_start %in% period_4b, "Period"] = "Period 4b"
#   
#   
#   ggplot(plot_df, aes(x = date_range_start, y = raw_visit_counts, color = Period, group = 1)) +
#     geom_line(size = 1) +
#     theme_modern_rc() +
#     theme(axis.text.x = element_text(angle = 45, vjust = .5, hjust = .5)) +
#     theme(axis.title.x = element_text(hjust = .5)) +
#     theme(axis.title.y = element_text(vjust = .5, hjust = .5)) +
#     theme(axis.text.y = element_text(hjust = .5)) +
#     theme(plot.title = element_text(hjust = .5)) + 
#     ggtitle("All cities: raw visit count over time") +
#     scale_x_date(breaks = "2 months", date_labels = "%Y-%m") +
#     ylab("Raw visit count (millions)") +
#     scale_y_continuous(labels = label_number_si()) +
#     xlab("Month")
#   
# }
# 
# device_counts_viz(all_dc_sum)
# 
# 
# 
