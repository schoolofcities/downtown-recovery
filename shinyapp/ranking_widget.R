source("load_data.R")
source("dtra_functions.R")


plot_obj <- recovery_rankings_plot(recovery_rankings_df("downtown"))

htmlwidgets::saveWidget(plot_obj, "../docs/widgets/recovery_rankings.html", selfcontained = FALSE)