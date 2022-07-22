source("load_data.R")
source("dtra_functions.R")


#htmlwidgets::saveWidget(recovery_rankings_plot(recovery_rankings_df("downtown")), "../docs/widgets/recovery_rankings.html", selfcontained = FALSE)

for (selected_metric in c("downtown", "city", "relative")) {
  widget2save <- recovery_rankings_plot(recovery_rankings_df(selected_metric))
  widget2save$sizingPolicy$padding <- 0
  htmlwidgets::saveWidget(widget2save, paste0("../docs/widgets/recovery_rankings_", selected_metric, ".html"), selfcontained = FALSE)
}