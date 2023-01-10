source("load_data.R")
source("dtra_functions.R")



plot_cities <- c("Washington DC", "Seattle, WA", "New York, NY","San Francisco, CA",
                 "Sacramento, CA", "Los Angeles, CA", "San Diego, CA", "Portland, OR",
                 "Boston, MA", "Chicago, IL", "Vancouver, BC", "Toronto, ON")



plot_data <- recovery_patterns_df_long(11) %>%
  inner_join(regions_df %>% dplyr::select(display_title, region, color), by = "display_title")

plot_data$week <- as.Date(plot_data$week)

plot_data <- plot_data %>%
  arrange(week, region, display_title)

recovery_patterns_plot(plot_data, "downtown", 11)

plot_data %>% glimpse()

summary(plot_data)


write.csv(plot_data, "../docs/all_weekly_metrics_plot_cuebiq_update.csv")
