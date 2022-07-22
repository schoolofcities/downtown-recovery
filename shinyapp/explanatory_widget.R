source("load_data.R")
source("dtra_functions.R")



#g1 <- explanatory_plot(selected_metric, "pct_jobs_information", "Season_9")
#interactive_plot <- girafe(ggobj = g1, width_svg = 10, height_svg = 10,
#                            options = list(
#                              opts_tooltip(use_fill = TRUE),
#                              opts_hover_inv(css = "opacity:0.1;"),
#                              opts_hover(css = "stroke-width:2;"),
#                              opts_sizing(rescale = TRUE, width = 1)
#                            ))
# interactive_plot




#htmlwidgets::saveWidget(explanatory_plot("downtown", "pct_jobs_information", "Season_9"), "../docs/widgets/explanatory_variables.html", selfcontained = FALSE)

for (selected_metric in c("downtown", "city", "relative")) {
  g1 <- explanatory_plot(selected_metric, "pct_jobs_information", "Season_9")
  widget2save <- girafe(ggobj = g1, width_svg = 12, height_svg = 8,
                             options = list(
                               opts_tooltip(use_fill = TRUE),
                               opts_hover_inv(css = "opacity:0.1;"),
                               opts_hover(css = "stroke-width:2;"),
                               opts_sizing(rescale = TRUE, width = .8)
                             ))
  widget2save$sizingPolicy$padding <- 0
  htmlwidgets::saveWidget(widget2save, paste0("../docs/widgets/explanatory_variables_", selected_metric, ".html"), selfcontained = FALSE)
}