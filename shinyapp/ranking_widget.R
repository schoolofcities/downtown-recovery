# creates data ready for ranking plot in javascript on downtownrecovery.com

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


all_seasonal_metrics <- read.csv("input_data/all_seasonal_metrics_cuebiq_update_hll.csv")

all_seasonal_metrics <- all_seasonal_metrics %>%
  filter(!(city %in% outlier_cities))

rankings_df <-
  unique(
    
    all_seasonal_metrics %>%
           dplyr::select(display_title,
                         seasonal_average,
                         region,
                         metric,
                         city,
                         Season)) %>%
    dplyr::filter(!is.na(seasonal_average)) %>%
    group_by(metric, Season) %>%
    dplyr::arrange(-seasonal_average) %>%
    mutate(lq_rank = rank(-seasonal_average, ties.method = "first")) %>%
    ungroup()

plot_data <- rankings_df %>%
  inner_join(colors_df, by = "region") %>%
  distinct() %>%
  arrange(region, display_title) #%>%
  #filter(!(city %in% outlier_cities))

plot_data %>% glimpse()


write.csv(plot_data, "../docs/ranking_data_hll.csv")

