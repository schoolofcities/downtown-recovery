// load in data
const unfilteredData = d3.csv("../model_data_long.csv").then(function(data){
    var x_vals = [], y_vals = [], x_vars = []; cities = []; regions = []; metrics = [];
  
    for (var i = 0; i < allRows.length; i++) {
  
      row = allRows[i];
  
      x_vals.push(row['x_val']);
      x_vars.push(row['x_var']);
      cities.push(row['display_title']);
      regions.push(row['region']);
      metrics.push(row['metric']);
      y_vals.push(row['y']);
  
    }

    return({x : x_vals, variable : x_vars, y : y_vals, city : cities, region : regions, metric : metrics});
});

function makePlotly(){
  
    var plotDiv = document.getElementById("explanatory_plot");

    var x_variable = document.getElementById("x_vars").value;

    var selected_metric = document.getElementById("select_metric").value;

    const plot_data = unfilteredData.filter(element => {
        return element.metric === selected_metric && element.x_var === x_variable;
    });

    var trace = [{
  
        x: plot_data['x'],
        y: plot_data['y'],
        mode: 'markers',
        type: 'scatter',
      }];
    
    
      Plotly.newPlot(plotDiv, trace,
    
        {title: 'Plotting CSV data from AJAX call'});

    }

makePlotly();