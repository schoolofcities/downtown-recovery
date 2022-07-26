source("load_data.R")
source("dtra_functions.R")








plot_data <- recovery_rankings_df_widget() %>%
  inner_join(regions_df %>% dplyr::select(region, color), by = "region") %>%
  distinct() %>%
  arrange(region, display_title)
write.csv(plot_data, "../docs/ranking_data.csv")

