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
write.csv(plot_data, "../docs/all_weekly_metrics_plot.csv")

plot_data <- read.csv("../docs/model_data.csv")

write.csv(plot_data %>%
            dplyr::select(-city, -state, -Season, -X) %>%
            pivot_wider(names_from = "metric", values_from = "y") %>%
            distinct(), "../docs/model_data_metrics.csv")



