# Define the UI for a module
source("load_data.R")
singleCitySelectorUI <- function(id, n, selected_city) {
  ns <- NS(id)
  tagList(
    pickerInput(ns("single_city_select"), 
                label = paste0("Select city :"),
                choices = regions_choices,
                # options = list(`actions-box` = TRUE, `none-selected-text` = "Please make a selection!"),
                selected = selected_city,
                multiple = FALSE,
                pickerOptions(mobile = TRUE))
  )
}

# Define the server logic for a module
singleCitySelectorServer <- function(input, output, session) {
  return(list(single_city_select <- reactive({input$single_city_select})))
}

singleCityMapUI <- function(id) {
  ns <- NS(id)
  tagList(
    leafletOutput(ns("citymap"))
  )
}

# Define the server logic for a module
singleCityMapServer <- function(input, output, session, city_vars) {
  
  map_obj <- reactive({
    m <- single_city_map(all_shapefile, regions_df, city = city_vars$single_city_select())
    return(m)
    })
  
  output$citymap <- renderLeaflet({
    map_obj()
  })
  
  
}






