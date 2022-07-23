source("load_data.R")
source("dtra_functions.R")


#htmlwidgets::saveWidget(recovery_rankings_plot(recovery_rankings_df("downtown")), "../docs/widgets/recovery_rankings.html", selfcontained = FALSE)

for (selected_metric in c("downtown", "city", "relative")) {
  g1 <- recovery_rankings_plot(recovery_rankings_df(selected_metric))
  widget2save <- girafe(ggobj = g1, width_svg = 12, height_svg = 12,
                             options = list(
                               opts_tooltip(use_fill = TRUE),
                               opts_hover_inv(css = "opacity:0.1;"),
                               opts_hover(css = "stroke-width:2;"),
                               opts_sizing(rescale = TRUE, width = 1)
                             ))
  widget2save$sizingPolicy$padding <- 0
  htmlwidgets::saveWidget(widget2save, paste0("../docs/widgets/recovery_rankings_", selected_metric, ".html"), selfcontained = FALSE)
}