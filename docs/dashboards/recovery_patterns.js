

// load in data
Plotly.d3.csv('https://raw.githubusercontent.com/hmooreo/downtownrecovery/main/docs/all_weekly_metrics_plot.csv', function(err, rows){

  function unpack(rows, key) {
    return rows.map(function(row) { return row[key]; });
}
var plotDiv = document.getElementById('patterns-plot');

String.prototype.toProperCase = function () {
    return this.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
};

var regions = unpack(rows, 'region');
//var display_title = unpack(rows, 'display_title');


    var metricSelector = document.getElementById('select_pattern_metric');
    var selected_metric = metricSelector.options[metricSelector.selectedIndex].value;

    var citiesSelector = document.getElementById('patterns_cities');
    var x_variable = citiesSelector.options[citiesSelector.selectedIndex].value;
    //var x_name = xSelector.options[xSelector.selectedIndex].text;

   

    function setLinePlot(y_val, cities) {

        var data =[];
    
        var trace = [{
            x: unpack(rows, 'week'),
            y: unpack(rows, y_val),
            type: 'scatter',
            mode: 'lines',
          
            transforms: [{
                type: 'groupby',
                groups: regions
            }],
           text: unpack(rows, 'display_title'),
            line: {
                color: unpack(rows, 'color'),
                size:20
                },
          }];
    
        var layout = {
            plot_bgcolor: 'rgba(0,0,0,0)',
            paper_bgcolor: 'rgba(0,0,0,0)',
            title: {
                text: y_val.toProperCase() + ' recovery',
                
                font: {
                  color: '#ffffff',
                  family: 'Courier New, monospace',
                  size: 24
                }
              },
            xaxis: {
                tickcolor: '#ffffff',
                showticklabels:true,


                title: {
                    text: 'Month',
                    font: {
                      family: 'Courier New, monospace',
                      size: 16,
                      color: '#ffffff'
                    }
                  }
              },
              yaxis: {
                showticklabels:true,
                tickcolor: '#ffffff',
                title: {
                    text: 'Metric',
                    font: {
                      family: 'Courier New, monospace',
                      size: 16,
                      color: '#ffffff'
                    }
                  }
              }
        };
    
        var config = {
            displayModeBar: false
        }
    
        Plotly.react(plotDiv, trace, layout, config);
    
    };
   

    function updateCities(){
      //updateMetric();
      setLinePlot(metricSelector.value, citiesSelector.value, citiesSelector.options[citiesSelector.selectedIndex].text);


/*
        var trace = [{
            x: unpack(rows, xSelector.value),
            y: unpack(rows, selected_metric),
            type: 'scatter',
            mode: 'markers',
            
           
            text: unpack(rows, 'display_title'),
            marker: {
                color: unpack(rows, 'color'),
                size:12
                },
            textfont: {
                color: unpack(rows, 'color'),
                family:'Open Sans'
            },
            hoverlabel: {
                bgcolor: unpack(rows, 'color'),
                hoveron:'points',
                font: {family:'Open Sans'}
            }
        }];


        var layout = {
            title: selected_metric.toProperCase() + ' recovery',
            plot_bgcolor: 'rgba(0,0,0,0)',
            paper_bgcolor: 'rgba(0,0,0,0)'
        };

        var config = {
            displayModeBar: false
        }
        Plotly.react(plotDiv, trace, layout, config);*/
    }

    function updateMetric(){
       // updateX();
       setLinePlot(metricSelector.value, citiesSelector.value, citiesSelector.options[citiesSelector.selectedIndex].text);

        /*
        var trace = [{
            x: unpack(rows, x_variable),
            y: unpack(rows, metricSelector.value),
            type: 'scatter',
            mode: 'markers',
            

            text: unpack(rows, 'display_title'),
            marker: {
                color: unpack(rows, 'color'),
                size:12
                },
            textfont: {
                color: unpack(rows, 'color'),
                family:'Open Sans'
            },
            hoverlabel: {
                bgcolor: unpack(rows, 'color'),
                hoveron:'points',
                font: {family:'Open Sans'}
            }
        }];


        var layout = {
            title: metricSelector.value.toProperCase() + ' recovery',
            plot_bgcolor: 'rgba(0,0,0,0)',
            paper_bgcolor: 'rgba(0,0,0,0)'
        };

        var config = {
            displayModeBar: false
        }
        Plotly.react(plotDiv, trace, layout, config);*/
    }
     // default plot
     //setScatterPlot(metricSelector.value, xSelector.value, xSelector.options[xSelector.selectedIndex].text);
      
     citiesSelector.addEventListener('change', updateCities, false);

    metricSelector.addEventListener('change', updateMetric, false);


    // default plot
    setLinePlot(metricSelector.value, citiesSelector.value, citiesSelector.options[citiesSelector.selectedIndex].text);
});
