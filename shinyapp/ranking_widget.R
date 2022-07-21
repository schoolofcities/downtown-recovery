source("load_data.R")
source("dtra_functions.R")


#plot_obj <- 

#htmlwidgets::saveWidget(plot_obj, "../docs/widgets/recovery_rankings.html", selfcontained = FALSE)

for (selected_metric in c("downtown", "city", "relative")) {
  htmlwidgets::saveWidget(recovery_rankings_plot(recovery_rankings_df(selected_metric)), paste0("../docs/widgets/recovery_rankings_", selected_metric, ".html"), selfcontained = FALSE)
}