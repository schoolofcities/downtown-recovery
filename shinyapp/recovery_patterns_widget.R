source("load_data.R")
source("dtra_functions.R")



plot_cities <- c("Washington DC", "Seattle, WA", "New York, NY","San Francisco, CA",
                 "Sacramento, CA", "Los Angeles, CA", "San Diego, CA", "Portland, OR",
                 "Boston, MA", "Chicago, IL", "Vancouver, BC", "Toronto, ON")

selected_metric <- "downtown"

g1 <- recovery_patterns_plot(recovery_patterns_df(selected_metric, plot_cities, 11), selected_metric, 11)

interactive_plot <- girafe(ggobj = g1, width_svg = 12, height_svg = 18,
                           options = list(
                             opts_tooltip(use_fill = TRUE),
                             opts_hover_inv(css = "opacity:0.1;"),
                             opts_hover(css = "stroke-width:2;"),
                             opts_sizing(rescale = TRUE, width = 1)
                           ))
interactive_plot
htmlwidgets::saveWidget(interactive_plot, "../docs/widgets/raw_recovery_pattern.html", selfcontained = FALSE)




for (selected_metric in c("downtown", "city", "relative")) {
   g1 <- recovery_patterns_plot(recovery_patterns_df(selected_metric, plot_cities, 11), selected_metric, 11)
   widget2save <- girafe(ggobj = g1, width_svg = 12, height_svg = 6,
                              options = list(
                                opts_tooltip(use_fill = TRUE),
                                opts_hover_inv(css = "opacity:0.1;"),
                                opts_hover(css = "stroke-width:2;"),
                                opts_sizing(rescale = TRUE, width = 1)
                              ))
   widget2save$sizingPolicy$padding <- 0
   htmlwidgets::saveWidget(widget2save, paste0("../docs/widgets/raw_recovery_pattern_", selected_metric, ".html"), selfcontained = FALSE)
}
