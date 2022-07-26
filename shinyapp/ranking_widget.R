source("load_data.R")
source("dtra_functions.R")








plot_data <- recovery_rankings_df_widget()
write.csv(plot_data, "../docs/ranking_data.csv")

plot_data <- read.csv("../docs/model_data.csv")

write.csv(plot_data %>%
            dplyr::select(-city) %>%
            pivot_wider(names_from = "metric", values_from = "y") %>%
            distinct(), "../docs/model_data_metrics.csv")
