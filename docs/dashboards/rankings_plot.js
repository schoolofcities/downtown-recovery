

// load in data
Plotly.d3.csv('https://raw.githubusercontent.com/hmooreo/downtownrecovery/main/docs/model_data_metrics.csv', function (err, rows) {

    function unpack(rows, key) {
        return rows.map(function (row) { return row[key]; });
    }
    var plotDiv = document.getElementById('rankings-plot');

    String.prototype.toProperCase = function () {
        return this.replace(/\w\S*/g, function (txt) { return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase(); });
    };

    var regions = unpack(rows, 'region');
    var metricSelector = document.getElementById('select_ranking_metric');

    function rankDuplicate(arr) {
        const sorted = [...new Set(arr)].sort((a, b) => b - a);
        const rank = new Map(sorted.map((x, i) => [x, i + 1]));
        return arr.map((x) => rank.get(x));
      }

    function setHBarPlot(y_val) {
        var trace = [{
            x: unpack(rows, y_val),
            y: rankDuplicate(unpack(rows, y_val)),
            type: 'bar',
            orientation: 'h',
            transforms: [{
                type: 'groupby',
                groups: regions
            }],
            text: unpack(rows, 'display_title'),
            marker: {
                color: unpack(rows, 'color'),
                size: 20
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
                
                showticklabels: true
            },
            yaxis: {
                showticklabels: true,
                tickcolor: '#ffffff',
                autorange: 'reversed',
                title: {
                    text: 'City',
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


    function updateX() {
        //updateMetric();
        setHBarPlot(metricSelector.value);


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

    function updateMetric() {
        // updateX();
        setHBarPlot(metricSelector.value);

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

    //xSelector.addEventListener('change', updateX, false);

    metricSelector.addEventListener('change', updateMetric, false);


    // default plot
    setHBarPlot(metricSelector.value);
});
