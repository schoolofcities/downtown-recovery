# creates data ready for ranking plot in javascript on downtownrecovery.com
library(ggplot2)
library(thematic)
library(markdown)
library(readxl)
library(glue)
library(stringr)
library(zoo)
library(tidyverse)
library(broom)
library(dplyr)
library(htmlwidgets)
library(scales)
library(plotly)
library(geojsonio)

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

all_weekly_metrics <- read.csv("input_data/all_weekly_metrics_cuebiq_update_hll.csv")
all_weekly_metrics$metric <- str_replace(all_weekly_metrics$metric, "metro", "city")

all_weekly_metrics <- all_weekly_metrics %>%
  filter(!(city %in% outlier_cities))

rolling_window <- 11

plot_data <-
  all_weekly_metrics %>%
    arrange(week) %>%
    group_by(city, metric) %>%
    mutate(rolling_avg = rollmean(
      normalized_visits_by_total_visits,
      as.numeric(rolling_window),
      na.pad = TRUE,
      align = "right"
    )) %>%
    ungroup() %>%
    dplyr::select(-city, -normalized_visits_by_total_visits, -metro_size, -X) %>%
  inner_join(colors_df) %>%
  filter(!is.na(rolling_avg))

plot_data$week <- as.Date(plot_data$week)

plot_data <- plot_data %>%
  arrange(week, region, display_title)


plot_data %>% glimpse()

plot_data %>%
  group_by(display_title) %>%
  count() %>%
  print(n = Inf)

summary(plot_data)


write.csv(plot_data, "../docs/all_weekly_metrics_plot_cuebiq_update_hll.csv")
