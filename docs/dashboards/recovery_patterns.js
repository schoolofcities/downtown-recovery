

// load in data
Plotly.d3.csv('https://raw.githubusercontent.com/hmooreo/downtownrecovery/main/docs/all_weekly_metrics_plot.csv', function (err, rows) {

    function unpack(data, key) {
        return data.map(function (row) { return row[key]; });
    }
    var plotDiv = document.getElementById('patterns-plot');

    String.prototype.toProperCase = function () {
        return this.replace(/\w\S*/g, function (txt) { return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase(); });
    };

    const metricSelector = document.getElementById('select_pattern_metric');

    const citiesSelector = document.getElementById('patterns_cities');

    const all_cities = unpack(Object.values(rows).filter(item => ((item.metric === metricSelector.value) &&
    (item.week === '2022-01-31'))), 'display_title');

    function createCityTrace(y_val, city) {
        var trace = {
            x: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (item.display_title === city)), 'week'),
            y: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (item.display_title === city)), 'rolling_avg'),
            type: 'scatter',
            mode: 'lines',
            visible: 'legendonly',       
            //ids: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (item.display_title === city)), 'display_title'),
            transforms: [{
                type: 'groupby',
                groups: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (item.display_title === city)), 'region'),
                styles: {
                    Canada: {
                        line: {
                            color: '#e41a1c'
                        }
                    },
                    Midwest: {
                        line: {
                            color: '#377eb8'
                        }
                    },
                    Northeast: {
                        line: {
                            color: '#4daf4a'
                        }
                    },
                    Pacific: {
                        line: {
                            color: '#984ea3'
                        }
                    },
                    Southeast: {
                        line: {
                            color: '#ff7f00'
                        }
                    },
                    Southwest: {
                        line: {
                            color: '#e6ab02'
                        }
                    }
                }
                  
            }/*, {
                type: 'groupby',
                groups: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (item.display_title === city)), 'display_title')
            }*/
        ],
        line: {
            color: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (item.display_title === city)), 'color'),
            shape: 'spline'
        },
        legendgroup: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (item.display_title === city)), 'region'),
        name: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (item.display_title === city)), 'display_title'),
    
        text: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (item.display_title === city)), 'display_title'),
        hoverinfo:"x+y",
            hovertemplate:
            "<b>City: </b>%{text}<br>" +
            "<b>Recovery %{yaxis.title.text}: </b> %{y:.0%}<br>" +
            "<extra></extra>"
        };

        trace['name'] = city;

        return(trace);
    };





    function initLinePlot(y_val, city_array) {
        
        var data = [];
        for (var i=0; i < all_cities.length; i++) {
            data[i] = createCityTrace(y_val, all_cities[i])

        }
        var layout = {
            plot_bgcolor: 'rgba(0,0,0,0)',
            paper_bgcolor: 'rgba(0,0,0,0)',
            title: {
                text: y_val.toProperCase() + ' recovery: 11 week rolling average',
                font: {
                    color: '#ffffff',
                    family: 'Open Sans, monospace',
                    size: 14
                }
            },
            xaxis: {
                showticklabels: true,
                range: ['2020-04-01', '2022-05-01'],
                tickfont: {
                    family: 'Open Sans, monospace',
                    size: 12,
                    color: '#ffffff'
                  },
                title: {
                    text: 'Month',
                    font: {
                        family: 'Open Sans, monospace',
                        size: 12,
                        color: '#ffffff'
                    }
                }
            },
            yaxis: {
                showticklabels: true,
                tickformat: ".0%",
                tickfont: {
                    family: 'Open Sans, monospace',
                    size: 12,
                    color: '#ffffff'
                  },
                title: {
                    text: 'Metric',
                    font: {
                        family: 'Open Sans, monospace',
                        size: 12,
                        color: '#ffffff'
                    }
                }
            },
            legend: {
                font: {
                    family: 'Open Sans, monospace',
                    size: 12,
                    color: '#ffffff'
                }
            }
        };

        var config = {
            responsive: true,
            displayModeBar: false
        };

        Plotly.react(plotDiv, data, layout, config);
        


        Plotly.restyle(plotDiv, update, indices);




        var highlighted_cities = [];
        for (var i=0; i < city_array.length; i++) {
            highlighted_cities.push(city_array[i].text);
        }
        var indices = all_cities.map(elem => highlighted_cities.includes(elem)).reduce(
            (out, bool, index) => bool ? out.concat(index) : out, 
            []
          );
        var update = {
            visible: true
        };

        Plotly.restyle(plotDiv, update, indices);
    };


    function updateCities() {
        initLinePlot(metricSelector.value, Array.from(citiesSelector.selectedOptions));
    }

    function updateMetric() {
        initLinePlot(metricSelector.value, Array.from(citiesSelector.selectedOptions));
    }
   
    citiesSelector.addEventListener('change', updateCities, false);

    metricSelector.addEventListener('change', updateMetric, false);

    initLinePlot(metricSelector.value, Array.from(citiesSelector.selectedOptions));
});
