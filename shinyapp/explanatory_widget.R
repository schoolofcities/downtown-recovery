source("load_data.R")
source("dtra_functions.R")

plot_obj <- explanatory_plot("downtown", "pct_jobs_information", "Season_9")

htmlwidgets::saveWidget(plot_obj, "../docs/widgets/explanatory_variables.html", selfcontained = FALSE)