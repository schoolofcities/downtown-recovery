

// load in data
Plotly.d3.csv('https://raw.githubusercontent.com/hmooreo/downtownrecovery/main/docs/model_data.csv', function(err, rows){

  function unpack(rows, key) {
    return rows.map(function(row) { return row[key]; });
}

    /*var x_vals = [], y_vals = [], x_vars = []; cities = []; regions = []; metrics = [];
  
        for (var i = 0; i < unfilteredData.length; i++) {
  
            row = unfilteredData[i];
  
            x_vals.push(row['x_val']);
            x_vars.push(row['x_var']);
            cities.push(row['display_title']);
            regions.push(row['region']);
            metrics.push(row['metric']);
            y_vals.push(row['y']);
  
            }

        return({x : x_vals, variable : x_vars, y : y_vals, city : cities, region : regions, metric : metrics});*/

    var plotDiv = document.getElementById('explanatory_plot');

    var e_x = document.getElementById('x_vars');

    var x_variable = e_x.options[e_x.selectedIndex].value;

    var e_m = document.getElementsByName('metric');

    for (var i = 0; i < e_m.length; i++) {
        var this_metric = e_m[i];
        if (this_metric.checked) {
            var selected_metric = this_metric.value;
        }
    }

    var trace = [{
        type: "scatter",
        mode: "markers",
        x: unpack(rows, x_variable),
        y: unpack(rows, 'y'),
        metric: unpack(rows, 'metric'),
        city: unpack(rows, 'city'),
        region: unpack(rows, 'region')
      }];

    const plot_data = Object.entries(trace).filter(currentElement => {
        return(currentElement.metric === selected_metric);
    });
    
      Plotly.newPlot(plotDiv, plot_data, {title: 'Plotting CSV data from AJAX call'});
})
