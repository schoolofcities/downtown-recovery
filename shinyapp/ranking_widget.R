source("load_data.R")
source("dtra_functions.R")



htmlwidgets::saveWidget(recovery_rankings_plot(recovery_rankings_df("downtown")), "../docs/widgets/recovery_rankings.html", selfcontained = FALSE)