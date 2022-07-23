## includes code adapted from the following sources:
# https://github.com/rstudio/shiny-examples/blob/master/087-crandash/
# https://github.com/eparker12/nCoV_tracker
# https://rviews.rstudio.com/2019/10/09/building-interactive-world-maps-in-shiny/
# https://github.com/rstudio/shiny-examples/tree/master/063-superzip-example

source("load_data.R")


ui <- bootstrapPage(
    theme = bslib::bs_theme(version = 4, bootswatch = "darkly"),
    HTML(
      '<a style="text-decoration:none;cursor:default;color:#FFFFFF;" class="active" href="#"></a>'
    ),
             fillRow(
               sidebarLayout(
                 sidebarPanel(
                   pickerInput(
                     "slr_metric",
                     span(tags$i(
                       h6(
                         "Select which metric to plot. Only one metric can be selected at a time."
                       )
                     )),
                     choices = named_metrics,
                     selected = "downtown",
                     multiple = FALSE,
                     pickerOptions(mobile = TRUE)
                   ),
                   pickerInput(
                     "x",
                     span(tags$i(
                       h6(
                         "Select independent variable. Only one variable can be selected at a time."
                       )
                     )),
                     choices = named_factors,
                     selected = "pct_jobs_information",
                     multiple = FALSE,
                     pickerOptions(mobile = TRUE)
                   ),
                   pickerInput(
                     "slr_cities",
                     span(tags$i(
                       h6(
                         "Select which cities to highlight in the plot. Multiple cities can be selected at a time."
                       )
                     )),
                     choices = regions_choices,
                     options = list(`actions-box` = TRUE, `none-selected-text` = "Please make a selection!"),
                     selected = explanatory_cities$display_title,
                     multiple = TRUE,
                     pickerOptions(mobile = TRUE)
                   )
                 ),
                 mainPanel(
                     tags$style(
                       type = "text/css",
                       "#explanatory_plot {height: calc(100vh - 140px) !important;}"
                     ),
                     # TODO: simplify this
                     plotOutput(
                       "explanatory_plot",
                       dblclick = "plot_dblclick",
                       brush = brushOpts(id = "plot_brush",
                                         resetOnNew = TRUE),
                       click = clickOpts(id = "plot_click")
                     ),
                     uiOutput("click_info")
                     )
                   )
                 )
               )



### SHINY SERVER ###

server = function(input, output, session) {
  
  getRegressionDF <- reactive({
    # getRegressionDF is meant to be used with SLR
    # allows multi-city selection, but only one x or y can be selected at a time
    # filters on user selected metric as well as multi-city choice
    
    y <- all_seasonal_metrics %>%
      dplyr::filter((metric == input$slr_metric) &
                    (Season == "Season_9")) %>%
      dplyr::select(city, display_title, Season, seasonal_average)
    
    X <- explanatory_vars %>%
      dplyr::filter(Season == "Season_9") %>%
      dplyr::select(city, region, starts_with(input$x)) %>%
      distinct(city, region, all_of(input$x), .keep_all = TRUE)
    
    unique(y %>%
             inner_join(X, by = "city") %>%
             mutate(key_study_case = display_title %in% input$slr_cities))
    
  })
  
  # explanatory plot - reactive
  #observeEvent(input$explanatory_plot_updater, {
  output$explanatory_plot <- renderPlot({
    plot_df <- getRegressionDF()
    plot_df[,input$x] <- as.numeric(plot_df[,input$x])
    plot_df <- plot_df[!is.na(plot_df[,input$x]),]
    
    key_study_cases_df <- plot_df %>%
      filter(key_study_case == TRUE) 
    leftover_cities <- plot_df %>%
      filter(key_study_case == FALSE)
    model.formula <- paste0("seasonal_average~", input$x) %>% as.formula()
    model.ols <- lm(model.formula, plot_df)
    coeffs <- coef(model.ols)
    
    
    ### get equation and r-squared as string ###
    ### adapted from: https://groups.google.com/forum/#!topic/ggplot2/1TgH-kG5XMA ###
    eq <- as.expression(substitute(italic(hat(y)) == a + b * italic(x),
                                   list(a = format(unname(coeffs[1]), digits = 2),
                                        b = format(unname(coeffs[2]), digits = 2))))
    
    r_squared <- as.expression(substitute(italic(R)^2~"="~r2,
                                          list(r2 = format(summary(model.ols)$r.squared, digits = 3))))
    
    g1 <- ggplot(plot_df, aes_string(x = input$x, y = "seasonal_average")) +
      geom_point(
        data = leftover_cities,
        alpha = .01,
        na.rm = TRUE,
        fill = "gray85",
        size = 3,
        show.legend = FALSE
      ) +
      geom_smooth(
        data = plot_df,
        method = "lm",
        formula = "y~x",
        alpha = 0.3,
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
      geom_point(data = key_study_cases_df,
                 aes(color = region),
                 size = 5) +
      xlim(min(key_study_cases_df[,input$x[1]]), max(key_study_cases_df[,input$x[1]])) +
      
      geom_text_repel(
        data = key_study_cases_df,
        aes(color = region),
        label = key_study_cases_df$city,
        size = 6,
        point.size = 8,
        min.segment.length = 0,
        segment.curvature = -1,
        segment.ncp = 3,
        segment.angle = 20,
        show.legend = FALSE
      ) +
      theme(plot.title = element_text(size = 16, hjust = .5),
            axis.title = element_text(size = 12),
            plot.subtitle = element_text(size = 14, hjust = .5)) +
      labs(x = names(named_factors[named_factors == input$x[1]]),
           y = names(named_metrics[named_metrics == input$slr_metric[1]]),
           title = eq,
           subtitle = r_squared,
           color = "Region") +
      scale_y_continuous(labels = scales::percent, limits = c(min(key_study_cases_df$seasonal_average), max(key_study_cases_df$seasonal_average))) +
      scale_color_manual(values = c("Canada" = "#e41a1c",
                                    "Midwest" = "#377eb8",
                                    "Northeast" = "#4daf4a",
                                    "Pacific" = "#984ea3",
                                    "Southeast" = "#ff7f00",
                                    "Southwest" = "#e6ab02"))
    g1
  })

  observeEvent(input$plot_dblclick, {
    brush <- input$plot_brush
    if (!is.null(brush)) {
      points_df$df_data <-
        brushedPoints(getRegressionDF(),
                      brush,
                      xvar = input$x[1],
                      yvar = input$y[1])
    } else {
      points_df$df_data <- NULL
    }
  })
  
  output$click_info <- renderUI({
    plot_df <- getRegressionDF()
    click <- input$plot_click
    point <-
      nearPoints(
        plot_df,
        click,
        threshold = 5,
        maxpoints = 1,
        addDist = TRUE
      )
    if (nrow(point) == 0)
      return(NULL)
    
    # calculate point position INSIDE the image as percent of total dimensions
    # from left (horizontal) and from top (vertical)
    left_pct <-
      (click$x - click$domain$left) / (click$domain$right - click$domain$left)
    top_pct <-
      (click$domain$top - click$y) / (click$domain$top - click$domain$bottom)
    
    # calculate distance from left and bottom side of the picture in pixels
    left_px <-
      click$range$left + left_pct * (click$range$right - click$range$left)
    top_px <-
      click$range$top + top_pct * (click$range$bottom - click$range$top)
    
    # create style property for tooltip
    # background color is set so tooltip is a bit transparent
    # z-index is set so we are sure are tooltip will be on top
    style <-
      paste0(
        "position:absolute; z-index:100; background-color: rgba(5, 5, 5, 0.85); ",
        "left:",
        left_px - 2,
        "px; top:",
        top_px - 2,
        "px;"
      )
    
    # actual tooltip created as wellPanel
    wellPanel(style = style,
              p(HTML(
                paste0(
                  "<b> City: </b>",
                  point$city,
                  "<br/>",
                  "<b>",
                  names(named_factors[named_factors == input$x[1]]),
                  ": </b>",
                  round(point[, input$x[1]], 2),
                  "<br/>",
                  "<b>",
                  names(named_metrics[named_metrics == input$slr_metric[1]]),
                  " recovery: </b>",
                  round(point[, "seasonal_average"], 2),
                  "<br/>"
                )
              )))
  })
  
  
  
  
}



shinyApp(ui = ui, server = server)
