

// load in data
Plotly.d3.csv('https://raw.githubusercontent.com/hmooreo/downtownrecovery/main/docs/model_data_metrics.csv', function(err, rows){

  function unpack(rows, key) {
    return rows.map(function(row) { return row[key]; });
}
var plotDiv = document.getElementById('explanatory-plot');

String.prototype.toProperCase = function () {
    return this.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
};

function getPlotData(selected_metric, x_variable) {
    x_vals = [];
    y_vals = [];
    x_vals = unpack(rows, x_variable);
    y_vals = unpack(rows, selected_metric);
  };

// default plot
setScatterPlot('downtown', 'pct_jobs_information');

const regions = ['Canada', 'Midwest', 'Northeast', 'Pacific', 'Southeast', 'Southwest']
const regions_colors = ['#e41a1c', '#377eb8', '#4daf4a', '#984ea3', '#ff7f00', '#e6ab02']




function setScatterPlot(selected_metric, x_variable) {

    var trace = [{
        type: 'scatter',
        mode: 'markers',
        x: unpack(rows, x_variable),
        y: unpack(rows, selected_metric),
        city: unpack(rows, 'city'),
        region: unpack(rows, 'region')
      }];

    var layout = {
      title: selected_metric.toProperCase() + ' recovery',
      plot_bgcolor: 'rgba(0,0,0,0)',
      paper_bgcolor: 'rgba(0,0,0,0)'
    };

    var config = {
        displayModeBar: false
    }
    Plotly.react(plotDiv, trace, layout, config);

};



    var xSelector = document.getElementById('x_vars');

    var x_variable = xSelector.options[xSelector.selectedIndex].value;

    var metricSelector = document.getElementById('select_metric');

    var selected_metric = metricSelector.options[metricSelector.selectedIndex].value;


   

    function updateX(){
      
        var trace = [{
            type: 'scatter',
            mode: 'markers',
            x: unpack(rows, xSelector.value),
            y: unpack(rows, selected_metric),
            city: unpack(rows, 'city'),
            region: unpack(rows, 'region')
        }];


        var layout = {
            title: selected_metric.toProperCase() + ' recovery',
            plot_bgcolor: 'rgba(0,0,0,0)',
            paper_bgcolor: 'rgba(0,0,0,0)'
        };

        var config = {
            displayModeBar: false
        }
        Plotly.react(plotDiv, trace, layout, config);
    }

    function updateMetric(){
       
        var trace = [{
            type: 'scatter',
            mode: 'markers',
            x: unpack(rows, x_variable),
            y: unpack(rows, metricSelector.value),
            city: unpack(rows, 'city'),
            region: unpack(rows, 'region')
        }];


        var layout = {
            title: metricSelector.value.toProperCase() + ' recovery',
            plot_bgcolor: 'rgba(0,0,0,0)',
            paper_bgcolor: 'rgba(0,0,0,0)'
        };

        var config = {
            displayModeBar: false
        }
        Plotly.react(plotDiv, trace, layout, config);
    }

      
    xSelector.addEventListener('change', updateX, false);

    metricSelector.addEventListener('change', updateMetric, false);



});
