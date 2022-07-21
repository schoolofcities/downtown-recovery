source("load_data.R")
source("dtra_functions.R")

#plot_obj <- 

#htmlwidgets::saveWidget(plot_obj, "../docs/widgets/explanatory_variables.html", selfcontained = FALSE)

for (selected_metric in c("downtown", "city", "relative")) {
  htmlwidgets::saveWidget(explanatory_plot(selected_metric, "pct_jobs_information", "Season_9"), paste0("../docs/widgets/explanatory_variables_", selected_metric, ".html"), selfcontained = FALSE)
}