library(ggplot2)
library(thematic)
library(markdown)
library(readxl)
library(stringr)
library(ggrepel)
library(ggpmisc)
library(zoo)
library(tidyverse)
library(broom)
library(dplyr)
library(htmlwidgets)
library(leaflet)
library(scales)
library(sf)
library(sp)
library(spdep)
library(plotly)
library(geojsonio)

# expects source("load_data.R") has been run and its variables are in the environment

create_buttons <- function(df, var_names, axis_type) {
  # axis_type should be either 'x' or 'y'
  lapply(
    var_names,
    FUN = function(var_name, df) {
      button <- list(
        method = 'restyle',
        args = list(paste0(axis_type), list(df[, var_name])),
        label = sprintf('Show %s', var_name)
      )
    },
    df
  )
}



map_df_widget <- function() {
  unique(all_seasonal_metrics %>%
           dplyr::select(display_title,
                         seasonal_average,
                         region,
                         metric,
                         lat, 
                         city,
                         Season)) %>%
    dplyr::filter(!is.na(seasonal_average))
}







recovery_rankings_df <- function(selected_metric) {
  unique(all_seasonal_metrics %>%
           dplyr::filter(metric == selected_metric) %>%
           dplyr::select(display_title,
                         seasonal_average,
                         region,
                         metric,
                         city,
                         Season)) %>%
    dplyr::filter(!is.na(seasonal_average)) %>%
    dplyr::arrange(-seasonal_average) %>%
    mutate(lq_rank = rank(-seasonal_average, ties.method = "first")) %>%
    ungroup()
}

recovery_rankings_plot <- function(df) {
  
  g1 <-
    ggplot(df) + aes(lq_rank,
                     group = display_title,
                     fill = region) +
    geom_tile_interactive(
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

recovery_patterns_df <- function(selected_metric, selected_cities, rolling_window) {
  
  na.omit(all_weekly_metrics %>%
            dplyr::filter((metric == selected_metric) &
                            (display_title %in% selected_cities))%>%
            arrange(week) %>%
            group_by(city) %>%
            mutate(rolling_avg = rollmean(
              normalized_visits_by_total_visits,
              as.numeric(rolling_window),
              na.pad = TRUE,
              align = "center"
            )) %>%
            ungroup() %>%
            mutate(color = region_colors[region]))
  
  
}

recovery_patterns_df_long <- function(rolling_window) {
  all_weekly_metrics %>%
    arrange(week) %>%
    group_by(city, metric) %>%
    mutate(rolling_avg = rollmean(
      normalized_visits_by_total_visits,
      as.numeric(rolling_window),
      na.pad = TRUE,
      align = "center"
    )) %>%
    ungroup() %>%
    dplyr::select(-city, -normalized_visits_by_total_visits, -region, -metro_size, -X) %>%
    dplyr::filter(!is.na(rolling_avg))
}

recovery_patterns_plot <- function(df, metric, n) {
  starting_lqs <- df %>%
    dplyr::filter(week == min(week)) %>%
    dplyr::select(city, region, week, rolling_avg) %>%
    dplyr::arrange(desc(rolling_avg))
  
  ending_lqs <- df %>%
    group_by(city) %>%
    mutate(latest_data = max(week)) %>%
    ungroup() %>%
    dplyr::filter(week == latest_data) %>%
    dplyr::select(region, week, rolling_avg) %>%
    dplyr::arrange(desc(rolling_avg))
  
  total_cities <- length(unique(df$display_title))
  total_weeks <- length(unique(df$week))
  
  g1 <- ggplot(df) + aes(
    x = week,
    y = rolling_avg,
    group = city,
    color = region,
    label = city,
    
  ) + geom_line_interactive(aes(data_id = city), size = 1) +
    geom_point_interactive(aes(tooltip =
                                 paste0(
                                   "<b>City:</b> ", city, "<br>",
                                   "<b>Week:</b> ", week, "<br>",
                                   n, " <b>week rolling average:</b> ", percent(round(rolling_avg, 2), 1), "<br>"
                                 ),
                               data_id = city), size = 1, alpha = .1) +
    geom_label_repel_interactive(
      data = starting_lqs,
      size = 3,
      direction = "y",
      hjust = "right",
      force = 1,
      na.rm  = TRUE,
      min.segment.length = 0,
      segment.curvature = 1e-20,
      segment.angle = 20,
      # this was determined to be a decent offset based on the commented out line below
      # leaving it in as future reference 
      nudge_x = rep(-35, times = total_cities),
      show.legend = FALSE
      #nudge_x = rep(-total_weeks / as.numeric(input$rolling_window[1]), times = total_cities),
    ) +
    geom_label_repel_interactive(
      data = ending_lqs,
      size = 3,
      direction = "y",
      hjust = "left",
      force = 1,
      na.rm = TRUE,
      min.segment.length = 0,
      segment.curvature =  1e-20,
      segment.angle = 20,
      # this was determined to be a decent offset based on the commented out line below
      # leaving it in as future reference 
      nudge_x = rep(35, times = total_cities),
      show.legend = FALSE
      #nudge_x = rep(total_weeks / as.numeric(input$rolling_window[1]), times = total_cities),
    ) +
    labs(title = paste(names(named_metrics[named_metrics == metric])),
         subtitle = paste(n, " week rolling average"),
         color = "Region",
         y = "Metric",
         x = "Month"
    ) +
    theme(
      axis.text.x = element_text(size = 10, angle = 45, vjust = 1, hjust = 1),
      axis.title = element_text(size = 10, hjust = .5),
      plot.title = element_text(size = 12, hjust = .5),
      plot.subtitle = element_text(size = 10, hjust = .5)
    ) +
    scale_x_date(
      breaks = "4 weeks",
      date_labels = "%Y.%m",
      expand = expansion(mult = .15)
    ) +
    scale_y_continuous("Metric", labels = scales::percent) +
    # 2023/01 update: changed to school of cities colors
    scale_color_manual(values = region_colors)
  g1
  
}

create_model_df <- function(x_var) {
  y <- all_seasonal_metrics %>%
    #dplyr::filter((metric == selected_metric) &
    #                (Season == y_var)) %>%
    dplyr::select(city, display_title, Season, seasonal_average, metric)
  
  X <- explanatory_vars %>%
    # dplyr::filter(Season == y_var) %>%
    dplyr::select(city, region, all_of(x_var))
  
  #colnames(X) <- c("city", "region", "x")
  
  #colnames(y) <- c("city", "display_title", "Season", "y", "metric")
  unique(y %>%
           inner_join(X, by = c("city")) %>%
         dplyr::filter(!is.na(seasonal_average))
  )
  
}

create_model_df_long <- function(chosen_x_vars) {
  y <- all_seasonal_metrics %>%
    dplyr::select(city, display_title, Season, seasonal_average, metric)
  
  X <- explanatory_vars %>%
    dplyr::select(-display_title, -state, -metro_size, chosen_x_vars)
  
  colnames(y) <- c("city", "display_title", "Season", "y", "metric")
  
  model_df <- unique(y %>%
                       inner_join(X, by = c("city", "Season")))
  
  
  model_df %>%
    pivot_longer(cols = !c("city", "metric", "region", "Season", "display_title", "y"), names_to = "x_var", values_to = "x_val")
}



explanatory_plot <- function(selected_metric, y_var, x_var) {
  # y <- all_seasonal_metrics %>%
  #   dplyr::filter((metric == selected_metric) &
  #                   (Season == y_var)) %>%
  #   dplyr::select(city, display_title, Season, seasonal_average, metric)
  # 
  # X <- explanatory_vars %>%
  #   dplyr::filter(Season == y_var) %>%
  #   dplyr::select(city, region, all_of(x_var))
  # 
  # colnames(X) <- c("city", "region", "x")
  # 
  # colnames(y) <- c("city", "display_title", "Season", "y", "metric")
  plot_df <- create_model_df(selected_metric, y_var, x_var)
  
  key_study_cases_df <- plot_df %>%
    dplyr::filter(key_study_case == TRUE) 
  leftover_cities <- plot_df %>%
    dplyr::filter(key_study_case == FALSE)
  model.formula <- paste0("y~x") %>% as.formula()
  model.ols <- lm(model.formula, plot_df)
  coeffs <- coef(model.ols)
  
  
  ### get equation and r-squared as string ###
  ### adapted from: https://groups.google.com/forum/#!topic/ggplot2/1TgH-kG5XMA ###
  eq <- as.expression(substitute(italic(hat(y)) == a + b * italic(x),
                                 list(a = format(unname(coeffs[1]), digits = 2),
                                      b = format(unname(coeffs[2]), digits = 2))))
  
  r_squared <- as.expression(substitute(italic(R)^2~"="~r2,
                                        list(r2 = format(summary(model.ols)$r.squared, digits = 3))))
  
  g1 <- ggplot(plot_df, aes(x = x, y = y)) +
    geom_point_interactive(data = plot_df,
                           aes(color = region,
                               tooltip = paste0("<b>City:</b> ", city, "<br>",
                                                "<b>", names(named_factors[named_factors == x_var]), ":</b> ", round(x, 2),"<br>",
                                                "<b>", names(named_metrics[named_metrics == selected_metric]), " recovery:</b> ", percent(round(y, 2), 1),  "<br>"
                               ),
                               data_id = region),
                           
                           alpha = .25,
                           size = 4) +
    geom_text_repel(
      data = key_study_cases_df,
      aes(color = region),
      label = key_study_cases_df$city,
      size = 4,
      point.size = 4,
      min.segment.length = 0,
      segment.curvature = -1,
      segment.ncp = 3,
      segment.angle = 20,
      show.legend = FALSE
    ) +
    geom_point_interactive(data = key_study_cases_df, aes(color = region, 
                                                          tooltip = paste0("<b>City:</b> ", city, "<br>",
                                                                           "<b>", names(named_factors[named_factors == x_var]), ":</b> ", round(x, 2),"<br>",
                                                                           "<b>", names(named_metrics[named_metrics == selected_metric]), " recovery:</b> ", percent(round(y, 2), 1),  "<br>"
                                                          ),
                                                          data_id = city),
                           size = 4) + 
    geom_smooth(
      data = plot_df,
      method = "lm",
      formula = "y~x",
      alpha = 0.75,
      linetype = 0,
      na.rm = TRUE,
      fullrange = TRUE
    ) +
    stat_smooth(
      geom = "line",
      data = plot_df,
      method = "lm",
      formula = "y~x",
      alpha = .75,
      linetype = "dashed",
      na.rm = TRUE,
      fullrange = TRUE
    ) +
    xlim(min(key_study_cases_df$x), max(key_study_cases_df$x)) +
    
    
    
    theme(plot.title = element_text(size = 12, hjust = .5),
          axis.title = element_text(size = 10),
          plot.subtitle = element_text(size = 10, hjust = .5)) +
    labs(x = names(named_factors[named_factors == x_var]),
         y = names(named_periods[named_periods == y_var]),
         title = eq,
         subtitle = r_squared,
         color = "Region") +
    scale_y_continuous(labels = scales::percent, limits = c(min(key_study_cases_df$y), max(key_study_cases_df$y))) +
    scale_color_manual(values = region_colors)
  g1
  
}

explanatory_plot_long <- function(plot_df, selected_metric) {
  
  plot_df <- plot_df %>%
    dplyr::filter(metric == selected_metric)
  
  
  
  #model.formula <- paste0("y~x") %>% as.formula()
  #model.ols <- lm(model.formula, plot_df)
  #coeffs <- coef(model.ols)
  
  
  ### get equation and r-squared as string ###
  ### adapted from: https://groups.google.com/forum/#!topic/ggplot2/1TgH-kG5XMA ###
  #eq <- as.expression(substitute(italic(hat(y)) == a + b * italic(x),
  #                               list(a = format(unname(coeffs[1]), digits = 2),
  #                                    b = format(unname(coeffs[2]), digits = 2))))
  
  #r_squared <- as.expression(substitute(italic(R)^2~"="~r2,
  #                                      list(r2 = format(summary(model.ols)$r.squared, digits = 3))))
  
  g1 <- ggplot(plot_df, aes(x = x_var, y = y, group = x_var)) +
    geom_point_interactive(data = plot_df,
                           aes(color = region,
                               text = paste0("<b>City:</b> ", city, "<br>",
                                             "<b>", names(named_factors[named_factors == x_var]), ":</b> ", round(x, 2),"<br>",
                                             "<b>", names(named_metrics[named_metrics == selected_metric]), " recovery:</b> ", percent(round(y, 2), 1),  "<br>"
                               )),
                           
                           
                           size = 4) +
    # geom_text(
    #   data = key_study_cases_df,
    #   aes(color = region),
    #   label = key_study_cases_df$city,
    #   size = 4,
    #   point.size = 4,
    #   min.segment.length = 0,
    #   segment.curvature = -1,
    #   segment.ncp = 3,
    #   segment.angle = 20,
    #   show.legend = FALSE
  # ) +
  # geom_point(data = key_study_cases_df, aes(color = region, 
  #                                                       tooltip = paste0("<b>City:</b> ", city, "<br>",
  #                                                                        "<b>", names(named_factors[named_factors == x_var]), ":</b> ", round(x, 2),"<br>",
  #                                                                        "<b>", names(named_metrics[named_metrics == selected_metric]), " recovery:</b> ", percent(round(y, 2), 1),  "<br>"
  #                                                       ),
  #                                                       data_id = city),
  #                        size = 4) + 
  geom_smooth(
    data = plot_df,
    method = "lm",
    formula = "y~x",
    alpha = 0.75,
    linetype = 0,
    na.rm = TRUE,
    fullrange = TRUE
  ) +
    stat_smooth(
      geom = "line",
      data = plot_df,
      method = "lm",
      formula = "y~x",
      alpha = .75,
      linetype = "dashed",
      na.rm = TRUE,
      fullrange = TRUE
    ) +
    #xlim(min(key_study_cases_df$x), max(key_study_cases_df$x)) +
    
    
    
    theme(plot.title = element_text(size = 12, hjust = .5),
          axis.title = element_text(size = 10),
          plot.subtitle = element_text(size = 10, hjust = .5)) +
    labs(x = names(named_factors[named_factors == x_var]),
         y = names(named_periods[named_periods == y_var]),
         #title = eq,
         #subtitle = r_squared,
         color = "Region") +
    scale_y_continuous(labels = scales::percent, limits = c(min(key_study_cases_df$y), max(key_study_cases_df$y))) +
    scale_color_manual(values = region_colors)
  g1
  
}







single_city_map <- function(df_sf, df, city) {
  
  plot_df <- inner_join(df_sf, df %>% dplyr::filter(display_title == city), by = "city")
  # single city map that highlights downtown area
  downtown_pal <-
    colorFactor("#f1a340", domain = TRUE, na.color = "transparent")
  
  return(leaflet(plot_df) %>%
           addMapPane(name = "polygons", zIndex = 410) %>%
           addMapPane(name = "maplabels", zIndex = 420) %>% # higher zIndex rendered on top
           addProviderTiles("CartoDB.DarkMatterNoLabels") %>%
           addProviderTiles(
             "CartoDB.DarkMatterOnlyLabels",
             options = leafletOptions(pane = "maplabels"),
             group = "map labels"
           ) %>% # see: http://leaflet-extras.github.io/leaflet-providers/preview/index.html
           addEasyButton(easyButton(
             icon = "fa-crosshairs",
             title = "My Location",
             onClick = JS("function(btn, map){ map.locate({setView: true}); }")
           )) %>%
           addPolygons(
             fillOpacity = .5,
             fillColor = ~downtown_pal(is_downtown),
             color = ~downtown_pal(is_downtown),
             opacity = ~as.numeric(is_downtown),
             weight = 2,
             stroke = TRUE,
             highlightOptions = highlightOptions(
               color = "#ff4a4a",
               weight = 5,
               bringToFront = TRUE,
               opacity = 1
             )
           ) %>%
           addLegend(color = "#d94801",
                     labels = "Downtown area",
                     "bottomleft"))
}
