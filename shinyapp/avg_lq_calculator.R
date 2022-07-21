library(readxl)
library(dplyr)
library(stringr)
library(tidyverse)
library(lubridate)
# clear environment
# computes the metrics by averaged by season from all_weekly_lqs
# the concept of the season is defined in this script, it can be changed if needed
rm(list = ls())
path <- "~/git/mc-covid19-dtra/shinyapp/"


all_weekly_lqs <-
  read.csv(paste0(path, "input_data/all_weekly_lqs.csv"))

# new_weekly_lqs <- 
#   read.csv(paste0(path, "input_data/new_weekly_lq.csv"))
# 
# # always necessary whenever reading in csv so the dates aren't treated like string literals
# new_weekly_lqs$week <-
#   as.Date(new_weekly_lqs$week, format = "%Y-%m-%d")
# 
# new_weekly_lqs$week <-
#   as.Date(new_weekly_lqs$week, format = "%m/%d/%Y")
# 
# 
# # always necessary whenever reading in csv so the dates aren't treated like string literals
# all_weekly_lqs$week <-
#   as.Date(all_weekly_lqs$week, format = "%m/%d/%Y")
# 
# all_weekly_lqs <- rbind(all_weekly_lqs %>%
#                           dplyr::select(-X),
#                         new_weekly_lqs)
# 
# # consistency
# all_weekly_lqs$metric <-
#   str_replace(all_weekly_lqs$metric, "metro", "city")
# 
# write.csv(all_weekly_lqs, paste0(path, "input_data/all_weekly_lqs.csv"))

# create year and week number definitions
all_weekly_lqs <- all_weekly_lqs %>%
  mutate(year = lubridate::year(all_weekly_lqs$week),
         isoweek_num = lubridate::isoweek(all_weekly_lqs$week))

# seasons definition: every 3 months / 12 weeks, starting from march 2020 is a season

# mar - may
# june - aug
# sept - nov
# dec - feb
# repeat

# 2020
all_weekly_lqs[(all_weekly_lqs$week >= as.Date("2020-03-01")) &
                      (all_weekly_lqs$week <= as.Date("2020-05-31")), "Season"] = "Season_1"

all_weekly_lqs[(all_weekly_lqs$week >= as.Date("2020-06-01")) &
                 (all_weekly_lqs$week <= as.Date("2020-08-31")), "Season"] = "Season_2"

all_weekly_lqs[(all_weekly_lqs$week >= as.Date("2020-09-01")) &
                       (all_weekly_lqs$week <= as.Date("2020-11-30")), "Season"] = "Season_3"
 
all_weekly_lqs[(all_weekly_lqs$week >= as.Date("2020-12-01")) &
                       (all_weekly_lqs$week <= as.Date("2021-02-28")), "Season"] = "Season_4"

# 2021
all_weekly_lqs[(all_weekly_lqs$week >= as.Date("2021-03-01")) &
                 (all_weekly_lqs$week <= as.Date("2021-05-31")), "Season"] = "Season_5"

all_weekly_lqs[(all_weekly_lqs$week >= as.Date("2021-06-01")) &
                 (all_weekly_lqs$week <= as.Date("2021-08-31")), "Season"] = "Season_6"

all_weekly_lqs[(all_weekly_lqs$week >= as.Date("2021-09-01")) &
                 (all_weekly_lqs$week <= as.Date("2021-11-30")), "Season"] = "Season_7"

all_weekly_lqs[(all_weekly_lqs$week >= as.Date("2021-12-01")) &
                 (all_weekly_lqs$week <= as.Date("2022-02-28")), "Season"] = "Season_8"

# 2022
all_weekly_lqs[(all_weekly_lqs$week >= as.Date("2022-03-01")) &
                 (all_weekly_lqs$week <= as.Date("2022-05-31")), "Season"] = "Season_9"

# all_weekly_lqs[(all_weekly_lqs$week >= as.Date("2022-06-01")) &
#                  (all_weekly_lqs$week <= as.Date("2022-08-31")), "Season"] = "Season_10"
# 
# all_weekly_lqs[(all_weekly_lqs$week >= as.Date("2022-09-01")) &
#                  (all_weekly_lqs$week <= as.Date("2022-11-30")), "Season"] = "Season_11"
# 
# all_weekly_lqs[(all_weekly_lqs$week >= as.Date("2022-12-01")) &
#                  (all_weekly_lqs$week <= as.Date("2023-02-28")), "Season"] = "Season_12"

#all_weekly_lqs <- all_weekly_lqs[!is.na(all_weekly_lqs$Season),]

city_attributes <-
  read.csv(paste0(path, "input_data/master_factors_display.csv"))
regions_df <- unique(
  city_attributes %>%
    dplyr::select(city, display_title, region, state))

all_weekly_lqs <- inner_join(all_weekly_lqs %>%
                                    dplyr::select(city, metric, weekly_lq, week, Season), regions_df, by = "city")

summary(all_weekly_lqs$weekly_lq)


avg_by_season_lqs <- all_weekly_lqs %>% 
  group_by(city, metric, Season) %>%
  summarise(avg_lq = mean(weekly_lq)) %>%
  ungroup()





avg_by_season_lqs <- left_join(avg_by_season_lqs, regions_df, by = "city")


avg_by_season_lqs <- avg_by_season_lqs %>%
  pivot_wider(id_cols = c("city", "display_title", "metric", "region"),
              names_from = "Season",
              values_from = "avg_lq")

write.csv(avg_by_season_lqs, paste0(path, "input_data/metrics_df.csv"))
### end of metrics_df.csv creation ### 


# optional visualizations of density plots of cities + weekly lqs
plot_df <- avg_by_season_lqs %>% dplyr::filter(city == sample(unique(avg_by_season_lqs$city), 1))
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
