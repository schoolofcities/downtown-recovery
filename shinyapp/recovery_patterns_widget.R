source("load_data.R")
source("dtra_functions.R")


#plot_df <- recovery_patterns_df("downtown", 11)


#plot_obj <- recovery_patterns_plot(plot_df, "downtown", 11)



#htmlwidgets::saveWidget(plot_obj, "../docs/widgets/raw_recovery_pattern.html", selfcontained = FALSE)

plot_cities <- c("Washington DC", "Seattle, WA", "New York, NY", 
                 "Sacramento, CA", "Los Angeles, CA", "San Diego, CA", "Portland, OR",
                 "Boston, MA", "Chicago, IL", "Vancouver, BC", "Toronto, ON")


for (selected_metric in c("downtown", "city", "relative")) {
   widget2save <- recovery_patterns_plot(recovery_patterns_df(selected_metric, plot_cities, 11), selected_metric, 11)
   widget2save$sizingPolicy$padding <- 0
   htmlwidgets::saveWidget(widget2save, paste0("../docs/widgets/raw_recovery_pattern_", selected_metric, ".html"), selfcontained = FALSE)
 }