# visualize ranking plot in R
# primarily used for internal EDA / if javascript is not readily available

rm(list = ls())
gc()

setwd("~/git/downtown-recovery/shinyapp")

# 2023-01: cuebiq data and color update
region_colors <- c("Canada" = "#DC4633",
                   "Midwest" = "#6FC7EA",
                   "Northeast" = "#8DBF2E",
                   "Pacific" = "#00A189",
                   "Southeast" = "#AB1368",
                   "Southwest" = "#F1C500")

colors_df <- data.frame(region = names(region_colors), color = region_colors)
colors_df


all_seasonal_metrics <- read.csv("input_data/all_seasonal_metrics_cuebiq_update_hll.csv")

rankings_df <-
  unique(
    
    all_seasonal_metrics %>%
      dplyr::select(display_title,
                    seasonal_average,
                    region,
                    metric,
                    city,
                    Season)) %>%
  dplyr::filter(!is.na(seasonal_average)) %>%
  group_by(metric, Season) %>%
  dplyr::arrange(-seasonal_average) %>%
  mutate(lq_rank = rank(-seasonal_average, ties.method = "first")) %>%
  ungroup()

plot_data <- rankings_df %>%
  inner_join(colors_df, by = "region") %>%
  distinct() %>%
  arrange(region, display_title)

plot_data %>% glimpse()

recovery_rankings_plot <- function(season = "Season_12", metric = "downtown") {
  
  g1 <-
    ggplot(plot_data) + aes(lq_rank,
                     group = display_title,
                     fill = region) +
    geom_tile(
      aes(y = seasonal_average / 2,
          height = seasonal_average,
          width = 1,
          tooltip = paste0("<b>City: </b>", display_title, "<br>",
                           "<b>Seasonal average: </b>", percent(round(seasonal_average, 2), 1)),
          data_id = city), 
      alpha = .8,
      color = "white") +
    
    geom_text(
      aes(y = 0, label = paste("", city,  ":", percent(round(seasonal_average, 2), 1))),
      color = "white",
      hjust = "inward",
      size = 4
    ) +
    coord_flip(clip = "off", expand = FALSE) +
    labs(title = paste(names(named_metrics[named_metrics == unique(df$metric)[1]]), "Recovery Rankings"),
         subtitle = names(named_periods[named_periods == unique(df$Season)[1]]),
         fill = "Region") +
    scale_y_continuous("", labels = scales::percent) +
    scale_x_reverse("") +
    theme(panel.grid = element_blank(),
          axis.text.y = element_blank(),
          axis.title = element_blank(),
          axis.title.y = element_blank(),
          plot.title = element_text(size = 12, hjust = .5),
          plot.subtitle = element_text(size = 10, hjust = .5),
          plot.margin = unit(c(1, 1, 1, 3), "cm")
    ) +
    scale_fill_manual(values = region_colors)
  g1
  
}

recovery_rankings_plot()



