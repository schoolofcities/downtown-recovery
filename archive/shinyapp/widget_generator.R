library(ggplot2)
library(markdown)
library(readxl)
library(stringr)
library(ggrepel)
library(ggpmisc)
library(plotly)
library(cowplot)
library(glue)
library(webshot)
library(zoo)
library(tidyverse)
library(hrbrthemes)
library(ggiraph)
library(widgetframe)
library(broom)
library(gganimate)
library(dplyr)
library(leaflet)
library(scales)
library(sf)
library(sp)
library(geojsonio)
library(htmlwidgets)
# when sourcing this file, clear the environment 
rm(list = ls())
testing_widgets = FALSE
input_path <- "E:\\jup/multi_city_covid19_recovery_analysis_website/shinyapp/"
if (testing_widgets) {
  output_path_widgets <- "E:\\jup/multi_city_covid19_recovery_analysis_website/shinyapp/test_widgets/"
} else{
  output_path_widgets <- "E:\\jup/multi_city_covid19_recovery_analysis_website/docs/widgets/"
  setwd(choose.dir())
}
# featured_cities <- c("San Francisco")
featured_cities <- c("Chicago", "Houston", "Los Angeles", "Montreal",
                    "New York", "San Francisco", "Toronto", "Vancouver")

if (TRUE) {
  weekly_concurrent_vars <- read.csv(paste0(input_path, "input_data/weekly_concurrent_vars.csv"))
  monthly_concurrent_vars <- read.csv(paste0(input_path, "input_data/monthly_concurrent_vars.csv"))
  city_attributes <- read.csv(paste0(input_path, "input_data/city_attributes.csv"))
  all_city_index <- read.csv(paste0(input_path, "input_data/all_city_index.csv"))
  
  all_shapefile <- st_read(paste0(input_path, "shp/all_shapefile_area.shp"))
  all_shapefile <- st_transform(all_shapefile, st_crs("+proj=longlat +datum=WGS84"))
  ### 2022.04.07 updated metrics appened together and pivoted to longform for time series plotting  ###
  all_weekly_lqs <- read.csv(paste0(input_path, "input_data/all_weekly_lqs.csv"))
  all_city_coords <- geojson_read(paste0(input_path, "input_data/can_us_cities.geojson"), what = "sp")
  all_city_coords_lqs <- read.csv(paste0(input_path, "input_data/all_city_coords_lqs.csv"))
  data_df <- read.csv(paste0(input_path, "input_data/data_df.csv"))
  model_df <- read.csv(paste0(input_path, "input_data/model_df.csv"))
  
  rate_of_recovery_postal_code <- read.csv(paste0(input_path, "aggregates/rate_of_recovery_by_postal_code.csv"))
  covid_cases_all <- read.csv(paste0(input_path, "input_data/covid_cases_all.csv"))
  unemployment_rates_all <- read.csv(paste0(input_path, "input_data/unemployment_rates_all.csv"))
  
}
# necessary to get around the ESRI column name length limit
colnames(all_shapefile) <- c("postal_code", "area_m2", "geometry")
all_areas <- st_drop_geometry(all_shapefile)
data_df <- inner_join(data_df, unique(all_city_coords_lqs %>%
                                        dplyr::select(display_title, lat, long)), by = "display_title")

rate_of_recovery_postal_code <- inner_join(rate_of_recovery_postal_code, unique(data_df %>%
                                      dplyr::select(city, country)), by = "city")



unique(rate_of_recovery_postal_code %>%
         dplyr::filter(city %in% featured_cities) %>%
         dplyr::select(city, postal_code)) %>%
  group_by(city) %>%
  summarise(n = n()) %>%
  arrange(n)

all_weekly_lqs$week <- as.Date(all_weekly_lqs$week, format = "%m/%d/%Y")

### national map widget generator ###
can_us_map <- function(df, metrics = c("downtown", "metro"),
                       periods = c("rate_of_recovery")) {
  
  # the popup when you click on a circle marker will have info on all of the periods for the filtered metric, 
  # but the actual map layers you can choose from will be restricted to the most interesting subset
  plot_metrics <- df %>%
    dplyr::filter((metric %in% metrics) &
                    (city != "Dallas")) %>%
    dplyr::select(lat, long, city, metric, starts_with("period"), rate_of_recovery, omicron_resilience) %>%
    mutate(popup = str_c('<b>City:</b> ', city, '<br>',
                         #'<b>Period 1: </b>', period_1, '<br>',
                         #'<b>Period 2: </b>', period_2, '<br>',
                         #'<b>Period 3: </b>', period_3, '<br>',
                         #'<b>Period 4: </b>', period_4, '<br>',
                         '<b>Rate of recovery: </b>', rate_of_recovery, '<br>'#,
                         #'<b>Omicron resilience: </b>', omicron_resilience, '<br>'
                         )) %>%
    pivot_longer(cols = all_of(periods), names_to = "Period")
    
    plot_metrics$metric <- str_replace(plot_metrics$metric, "downtown", "Downtown")
    plot_metrics$metric <- str_replace(plot_metrics$metric, "metro", "City")
    
    pretty_metrics <- unique(plot_metrics$metric)
    
    
  # palette is strictly the values that appear in the union of all selected metrics & periods
  # unselected values will not be included in palette
  lq_pal <- colorBin("RdYlGn", domain = plot_metrics$value)
  
  basemap <- leaflet(plot_metrics) %>% 
    addTiles() %>%
    addLayersControl(
      baseGroups = pretty_metrics,
      options = layersControlOptions(collapsed = FALSE)) %>%
      hideGroup("City") %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
    setView(lng = -95.35, lat = 41.1164, zoom = 5) %>%
    addLegend(
      pal = lq_pal, 
      values = ~value,
      group = ~metric,
      title = "Rate of recovery") %>%
      addCircleMarkers(lat = ~ lat, lng = ~ long, weight = 1, group = ~metric,
                       label = ~city, fillOpacity = .8, color = ~lq_pal(value), popup = ~popup, 
                       popupOptions = popupOptions(maxHeight = 215, closeOnClick = TRUE)) 

  basemap
  }
  
can_us_map_widget <- can_us_map(data_df)
if (testing_widgets) {
  can_us_map_widget
} else {
  htmlwidgets::saveWidget(can_us_map_widget, file = paste0(output_path_widgets, "can_us_map.html"), selfcontained = FALSE)
  webshot::webshot(paste0("can_us_map.html"), paste0("can_us_map.png"))
  
  }

getRawRecoveryDF <- function(recov_metric, rolling_window){
  # getRawRecoveryDF is meant to be used with raw recovery plots
  # allows multi-city selection
  # filter on user selected metric as well as multi-city choice
  # this does not have default arguments since it is only ever called inside of a function that does have default arguments
  all_weekly_lqs %>%
    dplyr::filter((metric == recov_metric) &
                    (city %in% featured_cities)) %>%
    group_by(city) %>%
    mutate(rolling_avg = rollmean(weekly_lq, rolling_window, na.pad = TRUE, align = "center")) %>%
    ungroup()
}

getRawRankingDF <- function(ranking_metric, recov_period){
  # this does not have default arguments since it is only ever called inside of a function that does have default arguments
  ranking_df <- data_df %>%
    dplyr::filter((metric == ranking_metric) &
                    (city %in% featured_cities)) %>%
    dplyr::select(city, recov_period, metric)
  colnames(ranking_df) <- c("city", "ranking_period", "metric")
  ranking_df
}

### raw recovery patterns widget generator ###
raw_recovery_patterns <- function(recov_metric = "downtown", rolling_window = 25) { 
  
  df <- na.omit(getRawRecoveryDF(recov_metric, rolling_window))
  significant_date_labels = c("Vaccinations begin", "Delta becomes dominant variant")
  significant_dates = as.Date(c("2020-12-01", "2021-07-01"))
  datelines = data.frame("significant_dates" = significant_dates,
                         "significant_date_labels" = significant_date_labels)
  starting_lqs <- df %>%
    dplyr::filter(week == min(week)) %>%
    dplyr::select(city, week, rolling_avg) %>%
    dplyr::arrange(desc(rolling_avg))
  
  ending_lqs <- df %>%
    dplyr::filter(week == max(week)) %>%
    dplyr::select(city, week, rolling_avg) %>%
    dplyr::arrange(desc(rolling_avg))
  
  total_cities <- length(unique(df$city))
  total_weeks <- length(unique(df$week))
  
  gg <- ggplot(df, aes(x = week, y = rolling_avg, colour = city, label = city)) +
    geom_point_interactive(aes(tooltip = rolling_avg, data_id = city, hover_css = "fill:none;"), size = 2) +
    geom_line_interactive(aes(data_id = city,tooltip = rolling_avg, hover_css = "fill:none;"), size = 2) +
    geom_text_repel_interactive(data = starting_lqs, aes(data_id = city), size = 4, direction = "y", hjust = "right", force = 5, 
                                na.rm  = TRUE, min.segment.length = Inf, 
                    nudge_x = rep(-2*total_weeks / rolling_window, times = total_cities)
                    #nudge_y = seq(from = max(weekly_lq), to = min(weekly_lq), length.out = total_cities)
    ) +
    geom_text_repel_interactive(data = ending_lqs, aes(data_id = city), size = 4, direction = "y", hjust = "left", force = 5, 
                                na.rm = TRUE, min.segment.length = Inf,
                    nudge_x = rep(2*total_weeks / rolling_window, times = total_cities)
                    #nudge_y = seq(from = max(weekly_lq), to = min(weekly_lq), length.out = total_cities)
    ) +
    geom_vline_interactive(data = datelines, aes(xintercept = significant_dates,
                               tooltip = significant_date_labels), alpha = .5,
                           linetype = 2) +
    ylab("Downtown weekly RQ") + 
    xlab("Week") + 
    ggtitle(paste(str_to_title(recov_metric), as.character(rolling_window), "week rolling average")) +
    theme(legend.position = "none", 
          axis.text = element_text(size = 10, angle = 45, colour = "black", vjust = 1, hjust = 1),
          plot.title = element_text(size = 15, hjust = .5)) + 
    scale_x_date(breaks = "4 weeks", date_labels = "%Y.%m", expand = expansion(mult = .15))
  
  interactive_plot <- girafe(ggobj = gg, width_svg = 12, height_svg = 12,
                             options = list(
                               opts_hover_inv(css = "opacity:0.5;"),
                               opts_hover(css = "stroke-width:3;"),
                               opts_sizing(rescale = TRUE),
                               opts_selection(only_shiny = FALSE, type = "single", css = "opacity:1")
                             ))
  interactive_plot
}
# create widget with default arguments
raw_recovery_widget <- raw_recovery_patterns()
if (testing_widgets) {
  raw_recovery_widget
} else {
  htmlwidgets::saveWidget(raw_recovery_widget, file = paste0(output_path_widgets, "raw_recovery_pattern.html"), selfcontained = FALSE)
  
  htmlwidgets::saveWidget(frameableWidget(raw_recovery_widget), file = paste0(output_path_widgets, "_iframed_raw_recovery_pattern.html"), selfcontained = FALSE)
  webshot::webshot(paste0("raw_recovery_pattern.html"), paste0("raw_recovery_pattern.png"))
  }


### recovery rankings widget generator ###
recovery_rankings <- function(ranking_metric = "downtown", ranking_period = "period_4") { 
  df <- na.omit(getRawRankingDF(ranking_metric, ranking_period)) %>%
    dplyr::arrange(-ranking_period) %>%
    mutate(lq_rank = rank(-ranking_period, ties.method = "first")) %>%
    ungroup()
  
  gg <- ggplot(df, aes(lq_rank, group = metric, fill = metric, color = metric)) +
    geom_tile_interactive(aes(y = ranking_period / 2, height = ranking_period, width = 0.75, tooltip = ranking_period, data_id = city), alpha = 0.8, color = NA) +
    geom_text(aes(y = 0, label = paste(city, " ")), vjust = 0.2, hjust = 1, color = "black", size = 4) +
    coord_flip(clip = "off", expand = FALSE) +
    labs(title = "Ranked downtown RQ",
         subtitle = "Sep 2021 - Feb 2022",) +
    scale_y_continuous("", labels = scales::comma) +
    scale_x_reverse("") +
    guides(color = FALSE, fill = FALSE, scale = "none") +
    #theme_modern_rc() +
    theme(panel.grid = element_blank()) + 
    theme(axis.text.y = element_blank()) + 
    theme(axis.title = element_blank()) + 
    theme(axis.title.y = element_blank()) + 
    theme(legend.position = "none") + 
    theme(plot.title = element_text(size = 20, hjust = .5)) + 
    theme(plot.subtitle = element_text(color = "black", size = 14, hjust = .5)) +
    theme(strip.background = element_rect(fill = "black")) +
    theme(strip.text = element_text(color = "black", size = 10, hjust = .5)) +
    theme(panel.spacing.x = unit(3, "cm")) + 
    theme(plot.margin = unit(c(1, 1, 1, 3), "cm"))
  interactive_plot <- girafe(ggobj = gg, width_svg = 8, height_svg = 6,
                             options = list(
                               opts_hover_inv(css = "opacity:0.1;"),
                               opts_hover(css = "stroke-width:2;"),
                               opts_sizing(rescale = TRUE, width = .8)
                             ))
  interactive_plot
  
}

# create widget with default args
recovery_rankings_widget <- recovery_rankings()
if (testing_widgets) {
  recovery_rankings_widget
} else {
  htmlwidgets::saveWidget(recovery_rankings_widget, file = paste0(output_path_widgets, "recovery_rankings.html"), selfcontained = FALSE)
  
  htmlwidgets::saveWidget(frameableWidget(recovery_rankings_widget), file = paste0(output_path_widgets, "_iframed_recovery_rankings.html"), selfcontained = FALSE)
  webshot::webshot(paste0("recovery_rankings.html"), paste0("recovery_rankings.png"))
  
  }

getRegressionDF <- function(x, y, regression_metric){
  # getRegressionDF is meant to be used with linear regression. 
  # allows multi-city selection, but only one x or y can be selected at a time
  
  # filter on user selected metric as well as multi-city choice
  regression_df <- data_df %>%
    dplyr::filter((metric == regression_metric) &
                    (city != "Dallas")) %>%
    mutate(key_study_case = city %in% featured_cities) %>%
    dplyr::select(city, x, key_study_case, y)
  colnames(regression_df) <- c("city", "x", "key_study_case", "y")
  regression_df
}

### explanatory variable generator ###
explanatory_variables <- function(x = "business_density", y = "period_4", regression_metric = "downtown") { 
  plot_df <- getRegressionDF(x, y, regression_metric)
  
  key_study_cases_df <- plot_df %>%
    filter(key_study_case == TRUE)
  leftover_cities <- plot_df %>%
    filter(key_study_case == FALSE)
  
  model.ols <- lm("y ~ x", plot_df)
  coeffs <- coef(model.ols)
  
  ### get equation and r-squared as string ###
  ### adapted from: https://groups.google.com/forum/#!topic/ggplot2/1TgH-kG5XMA ###
  eq <- as.expression(substitute(italic(hat(y)) == a + b * italic(x),
                   list(a = format(unname(coeffs[1]), digits = 2),
                        b = format(unname(coeffs[2]), digits = 2))))
  
  r_squared <- as.expression(substitute(italic(R)^2~"="~r2,
                          list(r2 = format(summary(model.ols)$r.squared, digits = 3))))

  #eq_point <- data.frame(c(.6 * max(plot_df$x), .6 * max(plot_df$x)),
  #                       c(.6 * max(plot_df$y),  .6 * max(plot_df$y)),
  #                      c(eq, r_squared))
  # colnames(eq_point) <- c("point_x", "point_y", "label")

  
  gg <- ggplot(plot_df, aes(x = x, y = y)) +
    geom_point_interactive(data = leftover_cities, aes(tooltip = glue("City: {city}\n X: {x}\n Y: {y}"), data_id = city), alpha = .5, na.rm = TRUE, color = "gray70", size = 3) +
    geom_smooth(data = plot_df, method = "lm", formula = "y ~ x", 
                alpha = 0.3, linetype = 0, na.rm = TRUE, fullrange = TRUE) + 
    stat_smooth(geom = "line", data = plot_df,  method = "lm", formula = "y ~ x",
                alpha = .3, linetype = "dashed", na.rm = TRUE, colour = "black", fullrange = TRUE) +
    
    geom_point_interactive(data = key_study_cases_df, aes(color = city, tooltip = glue("X: {x}\n Y: {y}"), data_id = city), size = 5) + 
    xlim(min(key_study_cases_df$x), max(key_study_cases_df$x)) +
    ylim(min(key_study_cases_df$y), max(key_study_cases_df$y)) +
    geom_text_repel(data = key_study_cases_df, 
                    label = key_study_cases_df$city, 
                    aes(color = city), 
                    size = 4, 
                    point.size = 4, 
                    min.segment.length = 0, 
                    segment.curvature = -1, 
                    segment.ncp = 3, 
                    segment.angle = 20) +
    theme(legend.position = "none",
          plot.title = element_text(size = 12, hjust = .5),
          plot.subtitle = element_text(size = 10, hjust = .5)
          ) + 
    labs(x = "Business density",
         y = "Downtown RQ4",
         title = eq,
         subtitle = r_squared)
    #geom_text_repel(data = eq_point, aes(x = point_x, y = point_y, label = label), direction = "y", parse = TRUE, na.rm = TRUE)
    
  
  gg
  interactive_plot <- girafe(ggobj = gg, width_svg = 8, height_svg = 6,
                              options = list(
                                opts_hover_inv(css = "opacity:0.1;"),
                                opts_hover(css = "stroke-width:2;"),
                                opts_sizing(rescale = TRUE, width = .8)
                              ))
   interactive_plot
}

explanatory_variables_widget <- explanatory_variables()
if (testing_widgets) {
  explanatory_variables_widget
} else {
  htmlwidgets::saveWidget(explanatory_variables_widget, file = paste0(output_path_widgets, "explanatory_variables.html"), selfcontained = FALSE)
  
  htmlwidgets::saveWidget(frameableWidget(explanatory_variables_widget), file = paste0(output_path_widgets, "_iframed_explanatory_variables.html"), selfcontained = FALSE)
  webshot::webshot(paste0("explanatory_variables.html"), paste0("explanatory_variables.png"))
  
  }

### single city map generator ###
single_city_map <- function(city_map) { 
  # this is meant to work with the rate_of_recovery_postal_code dataframe. could possibly be adapated to other use cases but for the time being,
  # all columns, data types, and information contained therein of rate_of_recovery_postal_code.csv are assumed to be ready and working for mapping
  no_outliers <- rate_of_recovery_postal_code %>%
    dplyr::filter(rate_of_recovery <= 2)
  
  
  plot_map <- rate_of_recovery_postal_code %>%
    dplyr::select(-X) %>%
    dplyr::filter((city == city_map))
  
  
  plot_map <- plot_map %>%
     mutate(
            popup = case_when(
              country == 1 ~ str_c('<b>Rate of recovery:</b> ', rate_of_recovery, '<br> <br>',
                                   '<b>ZIP code:</b> ', postal_code, '<br> <br>'
              ),
              country == 0 ~ str_c('<b>Rate of recovery:</b> ', rate_of_recovery, '<br> <br>',
                                   '<b>Dissemination area:</b> ', postal_code, '<br> <br>'
              )
            )) %>%
    dplyr::select(postal_code, city, is_downtown, rate_of_recovery, popup) %>%
    dplyr::filter(rate_of_recovery <= 2)
  
  plot_map_sf = inner_join(all_shapefile, plot_map, by = "postal_code")
  ror_pal <- colorBin("RdYlGn", domain = no_outliers$rate_of_recovery, 5)
  downtown_pal <- colorFactor("yellow", domain = TRUE, na.color = "transparent")
  
    
  city_map <- leaflet(plot_map_sf) %>%
    addMapPane(name = "polygons", zIndex = 410) %>% 
    addMapPane(name = "maplabels", zIndex = 420) %>% # higher zIndex rendered on top
    addProviderTiles("CartoDB.PositronNoLabels") %>%
    addProviderTiles("CartoDB.PositronOnlyLabels", 
                     options = leafletOptions(pane = "maplabels"),
                     group = "map labels") %>% # see: http://leaflet-extras.github.io/leaflet-providers/preview/index.html
    addLegend(
      pal = ror_pal, 
      values = ~rate_of_recovery,
      title = "Individual rate of recovery") %>%
    addPolygons(
      data = plot_map_sf, 
      fillOpacity = .7, 
      #group = ~Period,
      fillColor = ~ror_pal(rate_of_recovery),
      color = ~downtown_pal(is_downtown),
      opacity = ~as.numeric(is_downtown),
      weight = 3,
      stroke = TRUE, 
      highlightOptions = highlightOptions(
        color = "#ff4a4a",
        weight = 5,
        bringToFront = TRUE,
        opacity = 1
      ),
      popup = ~popup, 
      popupOptions = popupOptions(maxHeight = 215, closeOnClick = TRUE)
    ) %>%
    addLegend(
      color = "yellow",
      labels = "Downtown area"
    )
  
  city_map
}
# run this for all featured cities with the default period arguments. 
# this is because filtering to the extent that this would be snappy and reactive is impossible in html. 
# there will simply be length(featured_cities) of separate widgets or html pages entirely that can be 
# linked through buttons in the website
# a test

# colorbins are [, )
if (testing_widgets) {
  test_city <- featured_cities[sample(1:length(featured_cities), 1)]
  single_city_map_widget <- single_city_map(test_city)
  single_city_map_widget
} else {
  # the rest
  for (city in featured_cities) {
    single_city_map_widget <- single_city_map(city)
    htmlwidgets::saveWidget(single_city_map_widget, file = paste0(output_path_widgets, city, "_map.html"), selfcontained = FALSE)
    webshot::webshot(paste0(city, "_map.html"), paste0(city, "_map.png"))
    
    }
}



### save the widget .htmls as .jsons to be able to load them dynamically?? ###
setwd("E:\\jup/multi_city_covid19_recovery_analysis_website/docs/scripts")

script_info <- data.frame(cbind(c(list.files(path = "./", pattern = "*.html", full.names = TRUE)), 
                     c(23, 27, 19, 27, 27, 27, 27, 19, 19, 27, 27, 27)))

script_info_list <- split(script_info, seq(nrow(script_info)))

jsonReader <- function(x) {
  c(x[[1]], readLines(x[[1]])[as.numeric(x[[2]])])
  }

json_dat <- lapply(script_info_list, jsonReader)
gsub('.{4}$', '', json_dat[[1]][1])


lapply(json_dat, function(x) {cat(sub("</script>","", sub('<script type=\"application/json\" data-for=.*\">', "", x[[2]])), file = paste0(gsub('.{4}$', '', x[[1]][1]), "json"))})


#htmlwidgets::saveWidget(recovery_rankings_plot(recovery_rankings_df("downtown")), "../docs/widgets/recovery_rankings.html", selfcontained = FALSE)

# for (selected_metric in c("downtown", "city", "relative")) {
#   g1 <- recovery_rankings_plot(recovery_rankings_df(selected_metric))
#   widget2save <- girafe(ggobj = g1, width_svg = 12, height_svg = 12,
#                              options = list(
#                                opts_tooltip(use_fill = TRUE),
#                                opts_hover_inv(css = "opacity:0.1;"),
#                                opts_hover(css = "stroke-width:2;"),
#                                opts_sizing(rescale = TRUE, width = 1)
#                              ))
#   widget2save$sizingPolicy$padding <- 0
#   htmlwidgets::saveWidget(widget2save, paste0("../docs/widgets/recovery_rankings_", selected_metric, ".html"), selfcontained = FALSE)
# }

# for (selected_metric in c("downtown", "city", "relative")) {
#    g1 <- recovery_patterns_plot(recovery_patterns_df(selected_metric, plot_cities, 11), selected_metric, 11)
#    widget2save <- girafe(ggobj = g1, width_svg = 12, height_svg = 6,
#                               options = list(
#                                 opts_tooltip(use_fill = TRUE),
#                                 opts_hover_inv(css = "opacity:0.1;"),
#                                 opts_hover(css = "stroke-width:2;"),
#                                 opts_sizing(rescale = TRUE, width = 1)
#                               ))
#    widget2save$sizingPolicy$padding <- 0
#    htmlwidgets::saveWidget(widget2save, paste0("../docs/widgets/raw_recovery_pattern_", selected_metric, ".html"), selfcontained = FALSE)
# }

# selected_metric <- "downtown"
# 
# g1 <- recovery_patterns_plot(recovery_patterns_df(selected_metric, plot_cities, 11), selected_metric, 11)
# 
# interactive_plot <- girafe(ggobj = g1, width_svg = 12, height_svg = 18,
#                            options = list(
#                              opts_tooltip(use_fill = TRUE),
#                              opts_hover_inv(css = "opacity:0.1;"),
#                              opts_hover(css = "stroke-width:2;"),
#                              opts_sizing(rescale = TRUE, width = 1)
#                            ))
# interactive_plot
# htmlwidgets::saveWidget(interactive_plot, "../docs/widgets/raw_recovery_pattern.html", selfcontained = FALSE)