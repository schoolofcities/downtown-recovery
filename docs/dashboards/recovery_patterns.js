

// load in data
Plotly.d3.csv('https://raw.githubusercontent.com/hmooreo/downtownrecovery/main/docs/all_weekly_metrics_plot.csv', function (err, data) {

    function unpack(data, key) {
        return data.map(function (row) { return row[key]; });
    }
    var plotDiv = document.getElementById('patterns-plot');

    String.prototype.toProperCase = function () {
        return this.replace(/\w\S*/g, function (txt) { return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase(); });
    };


    var metricSelector = document.getElementById('select_pattern_metric');

    var citiesSelector = document.getElementById('patterns_cities');



    function setLinePlot(y_val, cities) {

        var trace = [{
            x: unpack(Object.values(data).filter(item => item.metric === y_val), 'week'),
            y: unpack(Object.values(data).filter(item => item.metric === y_val), 'rolling_avg'),
            type: 'scatter',
            mode: 'lines',

            transforms: [{
                type: 'groupby',
                groups: unpack(Object.values(data).filter(item => item.metric === y_val), 'region'),
            }, {
                type: 'filter',
                target: unpack(Object.values(data).filter(item => item.metric === y_val), 'display_title'),
                operation: '=',
                value: cities
            }],
            text: unpack(Object.values(data).filter(item => item.metric === y_val), 'display_title'),
            lines: {
                color: unpack(Object.values(data).filter(item => item.metric === y_val), 'color')
            }
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
                showticklabels: true,
                range: ['2020-04-01', '2022-05-01'],

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
                showticklabels: true,
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


    function updateCities() {
        //updateMetric();
        setLinePlot(metricSelector.value, citiesSelector.options[citiesSelector.selectedIndex].text);


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
        setLinePlot(metricSelector.value, citiesSelector.options[citiesSelector.selectedIndex].text);

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
    setLinePlot(metricSelector.value, citiesSelector.options[citiesSelector.selectedIndex].text);
});
