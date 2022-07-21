source("load_data.R")

create_national_map <-
  function(selected_metric) {
    plot_metrics <- all_seasonal_metrics %>%
      dplyr::filter(metric == selected_metric) %>%
      mutate(popup =  str_c(
        '<b>City: </b>',
        city,
        '<br>',
        '<b>Seasonal average: </b>',
        percent(round(seasonal_average, 2), 1),
        '<br>'
      )) %>%
      dplyr::select(lat, long, city, metric, Season, popup, seasonal_average)
    
    lq_spectrum <- 100 * plot_metrics$seasonal_average
    bins <- c(0, 50, 75, 100, 125, 150, 200)
    lq_pal <- colorBin("PiYG",
                       domain = lq_spectrum,
                       na.color = "black",
                       bins = bins)
    can_us_map <- leaflet(plot_metrics) %>%
      addTiles() %>%
      addProviderTiles(providers$CartoDB.DarkMatter) %>%
      addLegend(
        pal = lq_pal,
        values = lq_spectrum,
        position = "bottomleft",
        group = "Average metric over season",
        labFormat = labelFormat(suffix = "%"),
        title = "Average metric over season"
      ) %>%
      addCircleMarkers(
        data = plot_metrics,
        lat = ~ lat,
        lng = ~ long,
        weight = 1,
        group = "Average metric over period",
        label = ~ lapply(popup, htmltools::HTML),
        fillOpacity = .9,
        color = ~lq_pal(100 * seasonal_average)#,
        #popup = ~popup,
        #popupOptions = popupOptions(maxHeight = 215, closeOnClick = TRUE)
      ) %>%
      setView(lng = -95.35,
              lat = 41.1164,
              zoom = 5)
  }
for (selected_metric in c("downtown", "city", "relative")) {
htmlwidgets::saveWidget(create_national_map(selected_metric), paste0("../docs/widgets/national_map_", selected_metric, ".html"), selfcontained = FALSE)
}