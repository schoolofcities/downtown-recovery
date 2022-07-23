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

plot_x_vars <- named_factors
plot_data <- create_model_df_long(plot_x_vars)
write.csv(plot_data, "../docs/model_data_long.csv")

#htmlwidgets::saveWidget(explanatory_plot("downtown", "pct_jobs_information", "Season_9"), "../docs/widgets/explanatory_variables.html", selfcontained = FALSE)

for (selected_metric in c("downtown", "city", "relative")) {

  
  
  pd <- highlight_key(plot_data, ~city)
  
  
  p <- plot_ly(pd, 
               color = ~region, 
               colors = c("Canada" = "#e41a1c",
                                               "Midwest" = "#377eb8",
                                               "Northeast" = "#4daf4a",
                                               "Pacific" = "#984ea3",
                                               "Southeast" = "#ff7f00",
                                               "Southwest" = "#e6ab02"),
               hovertext = ~paste("City: ", city, '<br>', x_var, x_val),
               hoverinfo = "x+y"
               ) %>% 
    group_by(x_var) %>%
    config(displayModeBar  = FALSE) %>%
    add_markers(x = ~x_val,
                y = ~y,
                hoverinfo = "x+y") %>%
    highlight(selectize = TRUE,
              dynamic = TRUE,
              persistent = FALSE)
  
  widget2save <- bscols(
    filter_select("x_vars", "Select a variable: ", pd, ~x_var),
    p,
    widths = c(2, 10)
  )
    

  
  #g1 <- explanatory_plot(selected_metric, "Season_9", x$x)
  # widget2save <- bscols(x,
  #                       girafe(ggobj = g1, width_svg = 12, height_svg = 8,
  #                            options = list(
  #                              opts_tooltip(use_fill = TRUE),
  #                              opts_hover_inv(css = "opacity:0.1;"),
  #                              opts_hover(css = "stroke-width:2;"),
  #                              opts_sizing(rescale = TRUE, width = .8)
  #                            )),
  #                       )
  widget2save$sizingPolicy$padding <- 0
  htmltools::save_html(widget2save, paste0("../docs/widgets/explanatory_variables_", selected_metric, ".html"))
}
