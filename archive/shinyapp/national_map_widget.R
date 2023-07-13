source("load_data.R")
source("dtra_functions.R")

create_national_map <-
  function(selected_metric) {
    plot_metrics <- all_seasonal_metrics %>%
      dplyr::filter(metric == selected_metric) %>%
      # mutate(popup =  str_c(
      #   '<b>City: </b>',
      #   city,
      #   '<br>',
      #   '<b>Seasonal average: </b>',
      #   percent(round(seasonal_average, 2), 1),
      #   '<br>'
      # )) %>%
      dplyr::select(lat, long, city, metric, Season, seasonal_average) %>%
      distinct() %>%
      pivot_wider(names_from = "Season", values_from = "seasonal_average")
      
    
    
    can_us_map <- leaflet(plot_metrics) %>%
      addTiles() %>%
      addProviderTiles(providers$CartoDB.DarkMatter)
    lq_spectrum <- 100 * unlist(plot_metrics %>% dplyr::select(starts_with("Season")))
    lq_pal <- colorBin("PiYG",
                       domain = lq_spectrum)
    for (x in 1:9) {
     
      can_us_map <- can_us_map %>% addCircleMarkers(
        data = plot_metrics,
        lat = ~ lat,
        lng = ~ long,
        weight = 1,
        group = names(named_periods[named_periods == paste("Season", x, sep = "_")]),
        label = lapply(str_c(
             '<b>City: </b>',
             unlist(plot_metrics[,"city"]),
             '<br>',
             '<b>Seasonal average: </b>',
             percent(round(unlist(plot_metrics[,paste("Season", x, sep = "_")]), 2), 1),
             '<br>'), htmltools::HTML),
        fillOpacity = .9,
        color = ~lq_pal(100 * unlist(plot_metrics[,paste("Season", x, sep = "_")]))
      ) 
      
    }
    can_us_map <- can_us_map %>%
      addLayersControl(baseGroups = names(named_periods),
                       options = layersControlOptions(collapsed = FALSE),
                       
                       position = "bottomright") %>%
      showGroup(names(named_periods[9])) %>%
      addLegend(
        pal = lq_pal,
        values = lq_spectrum,
        position = "bottomleft",
        labFormat = labelFormat(suffix = "%"),
        title = "Average metric over season"
      ) %>%
      setView(lng = -95.35,
              lat = 41.1164,
              zoom = 5)
  }
for (selected_metric in c("downtown", "city", "relative")) {
htmlwidgets::saveWidget(create_national_map(selected_metric), paste0("../docs/widgets/national_map_", selected_metric, ".html"), selfcontained = FALSE)
}