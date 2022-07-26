source("load_data.R")
source("dtra_functions.R")








plot_data <- recovery_rankings_df_widget()
write.csv(plot_data, "../docs/ranking_data.csv")

