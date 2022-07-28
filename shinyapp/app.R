## includes code adapted from the following sources:
# https://github.com/rstudio/shiny-examples/blob/master/087-crandash/
# https://github.com/eparker12/nCoV_tracker
# https://rviews.rstudio.com/2019/10/09/building-interactive-world-maps-in-shiny/
# https://github.com/rstudio/shiny-examples/tree/master/063-superzip-example

source("load_data.R")
source("dtra_modules.R")
source("dtra_functions.R")

# all globally defined variables and functions loaded up to this point are never to be edited by app.R script. 
# these are hard coded the way that they are based on input from the policy brief, suggested changes, and caveats
# as decided over the course of the study. they remain like this should someone else ever repurpose this script and want to know
# exactly where the information deviates from the cleaned source material, ie; which cities are and aren't decided to be outliers,
# what is and isn't a 'large city'

### SHINY UI ###
ui <- bootstrapPage(
  navbarPage(
    theme = bslib::bs_theme(version = 4, bootswatch = "darkly"),
    collapsible = TRUE,
    HTML(
      '<a style="text-decoration:none;cursor:default;color:#FFFFFF;" class="active" href="#"></a>'
    ),
    id = "main_navbar",
    windowTitle = "Downtown Recovery",
    
    tabPanel(
      value = "home",
      "Home",
      tags$head(includeCSS("www/styles.css"),
                tags$script(HTML('
        var fakeClick = function(tabName) {
          var dropdownList = document.getElementsByTagName("a");
          for (var i = 0; i < dropdownList.length; i++) {
            var link = dropdownList[i];
            if(link.getAttribute("data-value") == tabName) {
              link.click();
            };
          }
        };
      '))),
      
      uiOutput("home_cards")
    ),
    tabPanel(value = "recovery_rankings", "Recovery Rankings",
             fillRow(
               sidebarLayout(
                 sidebarPanel(
                   pickerInput(
                     "recovery_rankings_metric",
                     span(tags$i(
                       h6(
                         "Select which metric to use in the ranking. Only one metric can be selected at a time."
                       )
                     )),
                     choices = named_metrics,
                     selected = "downtown",
                     multiple = FALSE,
                     pickerOptions(mobile = TRUE)
                   ),
                   # pickerInput(
                   #   inputId = "rankings_metro_size",
                   #   label = span(tags$i(
                   #     h6(
                   #       "Select which city size to include in ranking. Multiple sizes can be selected at a time."
                   #     )
                   #   )),
                   #   choices = c("Large" = "large",
                   #               "Medium" = "medium"),
                   #   selected = c("large", "medium"),
                   #   multiple = TRUE,
                   #   options = list(
                   #     `actions-box` = FALSE,
                   #     `none-selected-text` = "Please make a selection!"
                   #   )
                   # ),
                   pickerInput(
                     inputId = "rankings_regions",
                     label = span(tags$i(
                       h6(
                         "Select which regions to include in ranking. Multiple regions can be selected at a time."
                       )
                     )),
                     choices = sort(unique(regions_df$region)),
                     selected = sort(unique(regions_df$region)),
                     multiple = TRUE, 
                     options = list(
                       `actions-box` = FALSE,
                       `none-selected-text` = "Please make a selection!"
                     )
                   ),
                    pickerInput(
                      "rankings_cities",
                      span(tags$i(
                        h6(
                          "Select which cities to include in ranking. Cities are filtered according to region."
                      )
                      )),
                      choices = regions_choices,
                      options = list(`actions-box` = TRUE, `none-selected-text` = "Please make a selection!"),
                      multiple = TRUE,
                      selected = unlist(regions_choices),
                      pickerOptions(mobile = TRUE)
                    ),
                   
                    pickerInput(
                      "recovery_rankings_period",
                      span(tags$i(
                        h6(
                          "Select the comparison period. Only one period can be selected at a time."
                        )
                      )),
                      choices = named_periods,
                      selected = named_periods[9],
                      multiple = FALSE,
                      pickerOptions(mobile = TRUE)
                    )
                 ),
                 mainPanel(
                    tags$style(
                      type = "text/css",
                      "#recovery_ranking {height: calc(100vh) !important;}"
                    ),
                   tabsetPanel(
                   tabPanel(value = "ranking", "Recovery Rankings",
                            plotOutput("recovery_ranking")),
                   tabPanel("About this tool",
                            includeMarkdown("text_files/ranking_README.md"))
                   
                 )
                 )
               )
             )
    ),
    tabPanel(value = "recovery_patterns", "Recovery Patterns",
             fillRow(
               sidebarLayout(
                 sidebarPanel(
                   pickerInput(
                     "recovery_patterns_metric",
                     span(tags$i(
                       h6(
                         "Select which metric to use in the ranking. Only one metric can be selected at a time."
                       )
                     )),
                     choices = named_metrics,
                     selected = "downtown",
                     multiple = FALSE,
                     pickerOptions(mobile = TRUE)
                   ),
                   pickerInput(
                     "recovery_patterns_cities",
                     span(tags$i(
                       h6(
                         "Select cities to include in the plot. Multiple cities can be selected at a time."
                       )
                     )),
                     choices = regions_choices,
                     options = list(`actions-box` = TRUE, `none-selected-text` = "Please make a selection!"),
                     selected = patterns_cities$display_title,
                     multiple = TRUE,
                     pickerOptions(mobile = TRUE)
                     
                   ),
                   

                   sliderInput(
                     "rolling_window",
                     span(tags$i(
                       h6(
                         "Selecting rolling average window to smooth weekly variation."
                       )
                     )),
                     min = 1,
                     max = 25,
                     value = 15,
                     step = 2
                   )
                 ),
                 mainPanel(
                   tags$style(
                     type = "text/css",
                     "#raw_recovery_plot {height: calc(100vh - 125px) !important;}"
                   ),
                   tabsetPanel(
                   tabPanel(
                     value = "weekly_pattern",
                     "Raw recovery pattern",
                     plotOutput("raw_recovery_plot")
                   ),
                   tabPanel("About this tool",
                            includeMarkdown("text_files/pattern_README.md"))
                   )
                 )
               )
             )
    ),
    tabPanel(value = "explanatory_variables", "Explanatory Variables",
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
                      "y",
                      span(tags$i(
                        h6(
                          "Select dependent variable. Only one variable can be selected at a time."
                        )
                      )),
                      choices = named_periods,
                      selected = named_periods[9],
                      multiple = FALSE,
                      pickerOptions(mobile = TRUE)
                    ),
                   
                  
                   verbatimTextOutput("slr_summary")
                 ),
                 
                 mainPanel(tabsetPanel(
                   tabPanel(
                     "Single variable plot",
                     tags$style(
                       type = "text/css",
                       "#explanatory_plot {height: calc(100vh - 140px) !important;}"
                     ),
                     # TODO: simplify this
                     plotOutput(
                       "explanatory_plot"
                       #dblclick = "plot_dblclick",
                       #brush = brushOpts(id = "plot_brush",
                      #                   resetOnNew = TRUE),
                       #click = clickOpts(id = "plot_click")
                     ),
                     uiOutput("click_info")
                   ),
                   tabPanel("Model summary",
                            DT::dataTableOutput("slr_coeffs")
                            ),
                   tabPanel("About this tool",
                            includeMarkdown("text_files/explanatory_README.md"))
                 )))
             )),
    tabPanel(
      value = "comparative_map",
      "Comparative Map",
      tabsetPanel(
        tabPanel(
          value = "north_america_map",
          "All",
          div(
            class = "outer",
            tags$head(includeCSS("www/styles.css")),
            leafletOutput("can_us_map", width =
                            "100%", height = "100%"),
            absolutePanel(
              id = "controls",
              class = "panel panel-default",
              bottom = 5,
              right = 5,
              width = 350,
              fixed = TRUE,
              draggable = TRUE,
              height = "auto",
              
              span(tags$i(
                h6(
                  "Location Quotient (LQ): Measures the proportion of POI visits in downtown vs. the rest of the city in post-COVID period vs. pre-COVID period."
                )
              ), style = "color:#045a8d"),
              span(tags$i(
                h6(
                  "Recovery Quotient (RQ): Measures the number of raw POI visits (scaled by state sampling rate) in post-COVID period vs. pre-COVID period."
                )
              ), style = "color:#045a8d"),
              
              pickerInput(
                "map_metric",
                label = span(tags$i(h5("Select metric:")), style = "color:#045a8d"),
                choices = named_metrics,
                selected = "downtown",
                multiple = FALSE,
                pickerOptions(mobile = TRUE)
              ),
               pickerInput(
                 "map_period",
                 label = span(tags$i(h5("Select recovery period:")), style = "color:#045a8d"),
                 choices = named_periods,
                 selected = named_periods[9],
                 multiple = FALSE,
                 pickerOptions(mobile = TRUE)
               )
            )
          )
        ),
        tabPanel(
          value = "single_city_map",
          "Single city",
          
          sidebarLayout(
            sidebarPanel(pickerInput(
              "city_map_select",
              label = "City: ",
              choices = regions_choices,
              # options = list(`actions-box` = TRUE, `none-selected-text` = "Please make a selection!"),
              selected = "San Francisco, CA",
              multiple = FALSE,
              pickerOptions(mobile = TRUE)
            )
            ),
            mainPanel(
              tags$style(
                type = "text/css",
                "#city_map {height: calc(100vh) !important;}"
              ),
              leafletOutput("city_map", width = "100%", height = "100%")
        )
            
            
          )
          
        ),
        tabPanel(
          "About this tool",
          includeMarkdown("text_files/maps_README.md")
        )
      )
    ),
    # TODO: turn these into a slideshow; add support for other cities beyond toronto

  
           # tabPanel(value = "kepler_maps", "Raw Device Counts",
           #          fluidPage(fluidRow(
           #            sidebarLayout(
           #              sidebarPanel(
           #                pickerInput(
           #                  "kepler_city",
           #                  "City:",
           #                  choices = c("Toronto"),
           #                  # options = list(`actions-box` = TRUE, `none-selected-text` = "Please make a selection!"),
           #                  selected = c("Toronto"),
           #                  multiple = FALSE,
           #                  pickerOptions(mobile = TRUE)
           #                )
           #              ),
           #              mainPanel(
           #                imageOutput("image1", height = 400, width = 400),
           #                imageOutput("image2", height = 400, width = 400),
           #                imageOutput("image3", height = 400, width = 400)
           #              )
           #            )
           #          ))),
  tabPanel(value = "documentation", "Documentation",
            includeMarkdown("text_files/documentation.md")
  ), 
  tabPanel(value = "methods", "Methodology & Sources",
            includeMarkdown("text_files/methods.md")
  ),
  tabPanel(value = "future", "Contact",
           includeMarkdown("text_files/contact_info_future.md")
  )
  )
)



### SHINY SERVER ###

server = function(input, output, session) {
  

  city1_vars <- callModule(singleCitySelectorServer, "city_1")
  city2_vars <- callModule(singleCitySelectorServer, "city_2")

  res1 <- callModule(singleCityMapServer, "citymap_1", city_vars = city1_vars)
  res2 <- callModule(singleCityMapServer, "citymap_2", city_vars = city2_vars)

  # reactive helper 'get' functions that respond to user selections
  # access user inputs by using input$name_of_ui_element[1]
  # use reactive functions to filter/select/mutate dataframes, do not overwrite them
  
  # commented out because a better way was found, but in the event a direct page link to a tab is ever
  # needed again, leaving it in
  # observeEvent(input$viewer, {
  #   updateNavbarPage(session, inputId = "main_navbar", selected = "Tab 3")
  # }, priority = 2)
  
  # observeEvent(getQueryString(session)$page, {
  #   currentQueryString <-
  #     parseQueryString(session$clientData$url_search)$page # alternative:
  #   if (is.null(input$main_navbar) ||
  #       !is.null(currentQueryString) &&
  #       currentQueryString != input$main_navbar) {
  #     freezeReactiveValue(input, "main_navbar")
  #     updateNavbarPage(session, "main_navbar", selected = currentQueryString)
  #   }
  # }, priority = 1)
  # 
  # observeEvent(input$main_navbar, {
  #   currentQueryString <-
  #     parseQueryString(session$clientData$url_search)$page # alternative: parseQueryString(session$clientData$url_search)$page
  #   pushQueryString <- paste0("?page=", input$main_navbar)
  #   if (is.null(currentQueryString) ||
  #       currentQueryString != input$main_navbar) {
  #     freezeReactiveValue(input, "main_navbar")
  #     updateQueryString(pushQueryString, mode = "push", session)
  #   }
  # }, priority = 0)
  
  getRegressionDF <- reactive({
    # getRegressionDF is meant to be used with SLR
    # allows multi-city selection, but only one x or y can be selected at a time
    # filters on user selected metric as well as multi-city choice
    
    y <- all_seasonal_metrics %>%
      dplyr::filter((metric == input$slr_metric) &
                    (Season == input$y)
                    ) %>%
      dplyr::select(city, display_title, Season, seasonal_average)
    
    X <- explanatory_vars %>%
        dplyr::filter(Season == input$y) %>%
        dplyr::select(city, region, starts_with(input$x)) %>%
        distinct(city, region, all_of(input$x), .keep_all = TRUE)
    
    unique(y %>%
      inner_join(X, by = "city") %>%
      mutate(key_study_case = display_title %in% input$slr_cities))
      
  })
  
  
  
  getRawRecoveryDF <- reactive({
    # getRawRecoveryDF is meant to be used with raw recovery plots
    # allows multi-city selection
    # filters on user selected metric as well as multi-city choice

    all_weekly_metrics %>%
      dplyr::filter((metric == input$recovery_patterns_metric[1]) &
                    (display_title %in% input$recovery_patterns_cities)) %>%
      arrange(week) %>%
      group_by(city) %>%
      mutate(rolling_avg = rollmean(
        normalized_visits_by_total_visits,
        as.numeric(input$rolling_window[1]),
        na.pad = TRUE,
        align = "center"
      )) %>%
      ungroup()
  })
  
  getRawRankingDF <- reactive({
    # creates the df to be used in generating bar chart ranking plot
    # the first filter is on city size
    # from that, the user is allowed to select cities to include or exclude
    # selecting large will omit all medium sized cities from the selection and vice versa
    # to mix and match, the user must select all then manually deselect cities
    # this is to avoid confusion between dropdowns and removes the need for multiple legends 
    
    # largest_n_cities is defined globally with a hard coded number for largest. this should not be up to the user to define,
    # but rather something that is adjusted by the authors of the script at their discretion and what aligns with 
    # definitions used in the study
    
    ranking_df <- unique(all_seasonal_metrics %>%
      dplyr::filter(
        (metric == input$recovery_rankings_metric[1]) &
        #(metro_size %in% input$rankings_metro_size) &
        (region %in% input$rankings_regions) &
        (display_title %in% input$rankings_cities) &
        (Season == input$recovery_rankings_period)
        ) %>%
      dplyr::select(display_title,
                    #metro_size,
                    seasonal_average,
                    region,
                    metric,
                    Season,
                    city))

    colnames(ranking_df) <-
      c("display_title",
        #"metro_size",
        "recovery_rankings_period",
        "region",
        "metric",
        "Season",
        "city")
    ranking_df
  })
  
  getCityMapDF <- reactive({
    ## filter city and set up a simple popup with postal_code / explicit RQ4
    
    city_dc <- inner_join(all_shapefile, regions_df %>% dplyr::select(display_title, city), by = "city")
    
    plot_map <- city_dc %>%
      dplyr::filter((display_title == input$city_map_select[1])) %>%
      mutate(
        popup = str_c(
          '<b>Region: </b>',
          postal_code
        )
      )
    
    plot_map
  })
  
  points_df <- reactiveValues(df_data = NULL)
  
  
  
  map_postal_code <- reactiveValues(highlight_region = NULL)
  
  # observeEvent(input$city_map_mouseover, {
  #   city_map_postal_code <- input$city_map_mouseover$postal_code
  #   if (single_map_postal_code %in% unique(all_shapefile$postal_code)) {
  #     map_postal_code$highlight_region <- single_map_postal_code
  #   } else {
  #     map_postal_code$highlight_region <- NULL
  #   }
  #   
  #   
  #   
  # })
  
  
  
  
  # When a double-click happens, check if there's a brush on the plot.
  # If so, print the df rows in the brush bounds; if not do nothing
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
  
  output$home_cards <- renderUI({
    img_srcs <- c(
      "recovery_rankings.png",
      "raw_recovery_pattern.png",
      "explanatory_variables.png",
      "can_us_map.png"#,
      #"kepler_toronto_2019_01_12.png",
      #"clustering.png"
    )
    
    card_titles <- c(
      "Recovery Rankings",
      "Recovery Patterns",
      "Explanatory Variables",
      "Comparative Map"#,
      #"Raw Device Counts",
      #"Predicting & Classifying Recovery"
    )
    
    card_text <-
      c(
        "Comparison of overall recovery in activity levels in our downtown and urban areas.",
        "Explore weekly activity levels during different phases of the pandemic.",
        "Experiment with downtown recovery correlations with employment, land use, and socioeconomic data from cities.",
        "Visualize our urban recovery comparatively across the United States and Canada."#,
        #"Visualize mobile phone data agglomerated by dissemination areas in select metropolitan areas.",
        #"Coming soon"
      )
    
    card_tabs <- c(
      "recovery_rankings",
      "recovery_patterns",
      "explanatory_variables",
      "comparative_map"#,
      #"kepler_maps",
      #"future"
    )
    
    cards_df <-
      as.data.frame(list(img_srcs, card_titles, card_text, card_tabs))
    colnames(cards_df) <- c("imgs", "titles", "text", "tabs")
    
    
    
    
    args <- lapply(1:4, function(x)
      card(cards_df[x, "imgs"],
           cards_df[x, "titles"],
           cards_df[x, "text"],
           cards_df[x, "tabs"]))
    
    args$cellArgs <- list(style = "
        width: 100%;
        height: 100%;
        margin: 0;
        ")
    
    HTML(
      paste0(
        '
     <section class="py-1 text-center container-fluid">
      <div class="row py-sm-1">
        <div class="col-sm-6 col-sm-8 mx-auto">
          <h2 class="fw-dark">Death of Downtown?</h2>
          <h3 class = "fw-normal">Pandemic Recovery Trajectories across 62 North American Cities</h3>
          <p>
            <a href="death_of_downtown_policy_brief.pdf" class="btn btn-primary my-2">Read policy brief</a>
          </p>
        </div>
      </div>
    </section>
  <div class= "album py-5 bg-dark">
    <div class="container">',
        do.call(shiny::fluidRow, args),
    '</div> 
  </div>'
      )
    )
    
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
           y = names(named_periods[named_periods == input$y[1]]),
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
  #})
  
  output$subset_points <- renderPrint({
    if (!is.null(points_df$df_data)) {
      xy_df <- points_df$df_data %>%
        dplyr::filter(key_study_case == TRUE) %>%
        distinct(city, input$x[1], input$y[1], .keep_all = TRUE)
      print(xy_df %>%
              dplyr::select(c("city", input$x[1], seasonal_average)))
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
                  "</br>",
          
                  "<b>",
                  names(named_factors[named_factors == input$x[1]]),
                  ": </b>",
                  round(point[,input$x[1]], 2),
                  "<br/>",
                  "<b>",
                  names(named_periods[named_periods == input$y[1]]),
                  ": </b>",
                  round(point[,input$y[1]], 2),
                  "<br/>"
                )
              )))
  })
  
  output$slr_summary <- renderPrint({
    plot_df <- getRegressionDF()
    plot_df[,input$x[1]] <- as.numeric(plot_df[,input$x[1]])
    plot_df <- plot_df[!is.na(plot_df[,input$x[1]]),] %>% distinct()
    model.formula <- as.formula(paste0("seasonal_average~", input$x[1]))
    model.ols <- lm(model.formula, plot_df)
    print(summary(model.ols))
  })
  
  
  output$can_us_map <- renderLeaflet({
    
    plot_metrics <- all_seasonal_metrics %>%
      dplyr::filter((metric == input$map_metric[1]) &
                    (Season == input$map_period[1]))%>%
       mutate(popup =  str_c(
         '<b>City: </b>', city, '<br>',
         '<b>Seasonal average: </b>', percent(round(seasonal_average, 2), 1),'<br>'
       )) %>%
      dplyr::select(lat, long, city, metric, Season, popup, seasonal_average)
    
    lq_spectrum <- 100 * round(plot_metrics$seasonal_average, 2)
    bins <- c(0, 50, 75, 125, 150, 200)
    
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
        group = "Average metric over period",
        labFormat = labelFormat(suffix = "%"),
        title = "Average metric over period"
      ) %>%
      addCircleMarkers(
        lat = ~ lat,
        lng = ~ long,
        weight = 1,
        group = "Average metric over period",
        label = ~lapply(popup, htmltools::HTML),
        fillOpacity = .9,
        color = ~lq_pal(100 * seasonal_average)#,
        #popup = ~popup,
        #popupOptions = popupOptions(maxHeight = 215, closeOnClick = TRUE)
      ) %>%
      setView(lng = -95.35,
              lat = 41.1164,
              zoom = 5)
  })
  
  
   output$city_map <- renderLeaflet({
     # single city map
   
     downtown_pal <-
       colorFactor(c("#8856a7", "#f1a340"), domain = c(TRUE,FALSE), na.color = "transparent")
     
     plot_map_sf <- getCityMapDF()
     plot_map_sf$is_downtown <- as.logical(plot_map_sf$is_downtown)
     
     city_map <- leaflet(plot_map_sf) %>%
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
         data = plot_map_sf,
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
         ),
         popup = ~popup,
         popupOptions = popupOptions(maxHeight = 215, closeOnClick = TRUE)
       ) %>%
       addLegend(color = "#d94801",
                 labels = "Downtown area",
                 "bottomleft")
   })
  
  # output$city_map_morans <- renderUI({
  #   set.seed(101)
  #   plot_map <- getCityMapDF()
  #   df_sf <- inner_join(all_shapefile, plot_map, by ="postal_code") 
  #   neighbors <- poly2nb(df_sf, queen = TRUE)
  #   set.ZeroPolicyOption(TRUE)
  #   set.ZeroPolicyOption(TRUE)
  #   # row standardize spatial weights matrix
  #   spatial_weights <- nb2listw(neighbors, style = "B", zero.policy = TRUE)
  #   
  #   # the moran statistic is already looking at the value of a census tract vs the rest of the dataset,
  #   # so no need to scale
  #   # change nsim to 999 for easily viewing the map
  #   moran_MC <- moran.mc(as.numeric(df_sf$avg_lq), spatial_weights, zero.policy = TRUE, nsim = 999L)
  # 
  #   method <- moran_MC$method
  #   std_deviate <-
  #     paste("Moran I statistic:", round(moran_MC$statistic, 2))
  #   
  #   p_val <-
  #     paste("p-value:", round(moran_MC$p.value, 5))
  # 
  #   HTML(
  #     paste0(
  #       '<h5 style = "color: #045a8d;">',
  #       method,
  #               '</h5>
  #                 <p style="color: #045a8d; margin-left: 10%;">',
  #      
  #       std_deviate,
  #       '<br/>',
  #       p_val,
  #       '</p>'
  #     )
  #   )
  #   
  # })
  
  
  # getTimeSeriesDF <- reactive({
  #   city_dc <- inner_join(all_dc, regions_df %>% dplyr::select(display_title, city), by = "city")
  #   
  #   plot_map <- city_dc %>%
  #     dplyr::filter(display_title == input$city_map_select[1]) 
  #   plot_map
  #   
  # })
  
  # rv_location <- reactiveValues(id = NULL, lat = NULL, lon = NULL)
  
  # observeEvent(input$city_map_shape_mouseover, {
  #   city_map_hover_info <- input$city_map_shape_mouseover
  #   rv_location$id <- city_map_hover_info$id
  #   rv_location$lat <- city_map_hover_info$lat
  #   rv_location$lon <- city_map_hover_info$lon
  # })
  
  
  
  # TODO: if this is worth keeping, (maybe) add support to highlight the line of the postal code cursor is hovering over?
  # this could be done with an observeEvent function
  # output$single_city_time_series <- renderPlot({
  #   
  #   plot_df <- getTimeSeriesDF()
  #   plot_df$month <- as.Date(plot_df$month)
  #   #plot_df$is_highlighted <- plot_df$postal_code %in% rv_location$id
  #   plot_df$postal_code <- as.character(plot_df$postal_code)
  #   avgs_df <- plot_df %>%
  #     group_by(month, is_downtown) %>%
  #     summarise(avg_lq = mean(avg_lq)) %>%
  #     ungroup()
  #   
  #   ggplot(plot_df) +
  #     geom_line(aes(x = month, y = avg_lq, color = is_downtown, group = postal_code), alpha = .1, size = .5) +
  #     geom_line(data = avgs_df, aes(x = month, y = avg_lq, color = is_downtown), size = 1.5) +
  #     theme_bw() + 
  #     theme(legend.position = "none") +
  #     scale_color_manual(
  #       values = c(
  #         "TRUE" = "#f1a340",
  #         "FALSE" = "#998ec3"
  #       )
  #     )
  #   
  # })
  
  
  
  
  #observeEvent(input$recovery_patterns_updater, {
  # raw recovery patterns plot - reactive
  output$raw_recovery_plot <- renderPlot({
    df <- na.omit(getRawRecoveryDF())
    starting_lqs <- df %>%
      dplyr::filter(week == min(week)) %>%
      dplyr::select(city, region, week, rolling_avg) %>%
      dplyr::arrange(desc(rolling_avg))
    
    ending_lqs <- df %>%
      group_by(city) %>%
      mutate(latest_data = max(week)) %>%
      ungroup() %>%
      dplyr::filter(week == latest_data) %>%
      dplyr::select(city, region, week, rolling_avg) %>%
      dplyr::arrange(desc(rolling_avg))
    
    total_cities <- length(unique(df$city))
    total_weeks <- length(unique(df$week))
    
    ggplot(df) + aes(
      x = week,
      y = rolling_avg,
      group = city,
      color = region,
      label = city
    ) + geom_line(size = 1) +
      geom_label_repel(
        data = starting_lqs,
        size = 5,
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
      geom_label_repel(
        data = ending_lqs,
        size = 5,
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
      labs(title = paste(names(named_metrics[named_metrics == input$recovery_patterns_metric[1]])),
           subtitle = paste(input$rolling_window[1], "week rolling average"),
           color = "Region",
           y = "Metric",
           x = "Month"
      ) +
      theme(
        #legend.position = "none",
        axis.text.x = element_text(size = 10, angle = 45, vjust = 1, hjust = 1),
        axis.title = element_text(size = 12, hjust = .5),
        plot.title = element_text(size = 16, hjust = .5),
        plot.subtitle = element_text(size = 12, hjust = .5)
      ) +
      scale_x_date(
        breaks = "4 weeks",
        date_labels = "%Y.%m",
        expand = expansion(mult = .15)
      ) +
      scale_y_continuous("", labels = scales::percent) +
      scale_color_manual(values = c("Canada" = "#e41a1c",
                                    "Midwest" = "#377eb8",
                                    "Northeast" = "#4daf4a",
                                    "Pacific" = "#984ea3",
                                    "Southeast" = "#ff7f00",
                                    "Southwest" = "#e6ab02"))
    })
  #})
  
  # recovery ranking plot - reactive
 # observeEvent(input$recovery_rankings_updater, {
  output$recovery_ranking <- renderPlot({
    df <- na.omit(getRawRankingDF()) %>%
      dplyr::filter(!is.na(recovery_rankings_period)) %>%
      dplyr::arrange(-recovery_rankings_period) %>%
      mutate(lq_rank = rank(-recovery_rankings_period, ties.method = "first")) %>%
      #dplyr::filter(lq_rank <= input$top_n_recovery_rankings[1]) %>%
      ungroup()
    g1 <-
      ggplot(df) + aes(lq_rank,
                       group = display_title,
                       fill = region) +
      geom_tile(
        aes(y = recovery_rankings_period / 2, height = recovery_rankings_period, width = .8), 
        alpha = .8,
        color = "white") +
      
      geom_text(
        aes(y = 0, label = paste("", display_title,  ":", percent(round(recovery_rankings_period, 2), 1))),
        color = "white",
        hjust = "inward",
        size = 5
      ) +
      coord_flip(clip = "off", expand = FALSE) +
      labs(title = paste(names(named_metrics[named_metrics == input$recovery_rankings_metric[1]]), "Recovery Rankings"),
           subtitle = names(named_periods[named_periods == input$recovery_rankings_period[1]]),
           fill = "Region") +
      scale_y_continuous("", labels = scales::percent) +
      scale_x_reverse("") +
      theme(panel.grid = element_blank(),
            axis.text.y = element_blank(),
            axis.title = element_blank(),
            axis.title.y = element_blank(),
            plot.title = element_text(size = 20, hjust = .5),
            plot.subtitle = element_text(size = 14, hjust = .5)
            #plot.margin = unit(c(1, 1, 1, 3), "cm")
            ) +
      scale_fill_manual(values = c("Canada" = "#e41a1c",
                                    "Midwest" = "#377eb8",
                                    "Northeast" = "#4daf4a",
                                    "Pacific" = "#984ea3",
                                    "Southeast" = "#ff7f00",
                                    "Southwest" = "#e6ab02"))
    g1
  }, height = function(){540 + 12 * length(input$rankings_cities)})
  #})
  
  output$image1 <- renderImage({
    return(list(
      src = paste(
        "media/kepler",
        tolower(input$kepler_city[1]),
        "2019_01_12.png",
        sep = "_"
      ),
      contentType = "image/png"
    ))
  }, deleteFile = FALSE)
  
  output$image2 <- renderImage({
    return(list(
      src = paste(
        "media/kepler",
        tolower(input$kepler_city[1]),
        "2020_03_08.png",
        sep = "_"
      ),
      contentType = "image/png"
    ))
  }, deleteFile = FALSE)
  
  output$image3 <- renderImage({
    return(list(
      src = paste(
        "media/kepler",
        tolower(input$kepler_city[1]),
        "2021_03_04.png",
        sep = "_"
      ),
      contentType = "image/png"
    ))
  }, deleteFile = FALSE)
  
  output$bar_chart_race <- renderUI({
    tags$video(
      src = paste0(input$recovery_rankings_metric[1], ".mov"),
      type = "video/mov",
      controls = "controls",
      autoplay = NA
    )
  })
  
  output$slr_coeffs <- DT::renderDataTable({
    models <- data.frame(matrix(ncol = 5, nrow = 0))
    
    y <- all_seasonal_metrics %>%
      dplyr::filter((metric == input$slr_metric) &
                      (Season == input$y)) %>%
      dplyr::select(city, Season, seasonal_average)
    
    X <- explanatory_vars %>%
      dplyr::filter(Season == input$y) %>%
      distinct(city, .keep_all = TRUE)
    
    model_df <- unique(y %>%
             inner_join(X, by = "city"))
    
    for (x in colnames(X %>% dplyr::select(-Season, -city, -state))) {
      model.formula <- as.formula(paste("seasonal_average~", x, sep = " "))
      model.ols <- lm(model.formula, model_df)
      models <-
        do.call(rbind, list(models, tidy(summary(model.ols))))
    }
    models %>%
      dplyr::filter(term != "(Intercept)")
    #write.csv(models, paste("output_data/", input$slr_metric[1], "_", input$y[1], ".csv"))
  }, options = list(scrollY = TRUE))
  
  
  
  
  output$model_summary <- renderPrint({
    
    model_df <- getRegressionDF()
    
    model.formula <- as.formula(paste(seasonal_average, "~", input$x[1], sep = " "))
    model.ols <- lm(model.formula, model_df)
    print(summary(model.ols))
  })
  
  
  observe({
     # get regions according to selected metro_size
       regions_by_metro <- regions_df %>%
         dplyr::filter(#(metro_size %in% input$rankings_metro_size) &
                         (region %in% input$rankings_regions))

     region_choices_by_metro <- lapply(split(regions_by_metro$display_title, regions_by_metro$region), as.list)
     
     updatePickerInput(session,
                       "rankings_cities",
                       selected = unlist(region_choices_by_metro),
                       choices = region_choices_by_metro)
   })
  
  
  
  
  
}



shinyApp(ui = ui, server = server)
