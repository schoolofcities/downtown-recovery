source("load_data.R")
source("dtra_functions.R")


plot_df <- recovery_patterns_df("downtown", 11)


plot_obj <- recovery_patterns_plot(plot_df, "downtown", 11)



htmlwidgets::saveWidget(plot_obj, "../docs/widgets/raw_recovery_pattern.html", selfcontained = FALSE)
