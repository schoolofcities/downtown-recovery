

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

    function setLinePlot(y_val, city_array) {
        var cities = [];
        for (var i=0; i < city_array.length; i++) {
            cities.push(city_array[i].text);
        }
        var trace = [{
            x: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (cities.includes(item.display_title))), 'week'),
            y: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (cities.includes(item.display_title))), 'rolling_avg'),
            type: 'scatter',
            mode: 'lines',        
            ids: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (cities.includes(item.display_title))), 'display_title'),
            transforms: [{
                type: 'groupby',
                groups: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (cities.includes(item.display_title))), 'region'),
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
                  
            }, {
                type: 'groupby',
                groups: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (cities.includes(item.display_title))), 'display_title')
            }
        ],
        line: {
            color: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (cities.includes(item.display_title))), 'color'),
            shape: 'spline'
        },
        name: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (cities.includes(item.display_title))), 'region'),
       // hoverinfo:"x+y",
        text: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (cities.includes(item.display_title))), 'display_title')
        }];

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
        }

        Plotly.react(plotDiv, trace, layout, config);

    };


    function updateCities() {
        setLinePlot(metricSelector.value, Array.from(citiesSelector.selectedOptions));
    }

    function updateMetric() {
        setLinePlot(metricSelector.value, Array.from(citiesSelector.selectedOptions));
    }
   
    citiesSelector.addEventListener('change', updateCities, false);

    metricSelector.addEventListener('change', updateMetric, false);

    setLinePlot(metricSelector.value, Array.from(citiesSelector.selectedOptions));
});
