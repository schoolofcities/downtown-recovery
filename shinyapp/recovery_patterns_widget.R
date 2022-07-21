source("load_data.R")
source("dtra_functions.R")


#plot_df <- recovery_patterns_df("downtown", 11)


#plot_obj <- recovery_patterns_plot(plot_df, "downtown", 11)



#htmlwidgets::saveWidget(plot_obj, "../docs/widgets/raw_recovery_pattern.html", selfcontained = FALSE)
for (selected_metric in c("downtown", "city", "relative")) {
  htmlwidgets::saveWidget(recovery_patterns_plot(recovery_patterns_df(selected_metric, 11), selected_metric, 11), paste0("../docs/widgets/raw_recovery_pattern_", selected_metric, ".html"), selfcontained = FALSE)
}