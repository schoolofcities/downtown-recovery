

// load in data
Plotly.d3.csv('https://raw.githubusercontent.com/schoolofcities/downtown-recovery/stoppers_hll_update/docs/all_weekly_metrics_plot_cuebiq_update_hll.csv', function (err, rows) {

    function unpack(data, key) {
        return data.map(function (row) { return row[key]; });
    }
    var plotDiv = document.getElementById('patterns-plot');

    String.prototype.toProperCase = function () {
        return this.replace(/\w\S*/g, function (txt) { return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase(); });
    };

    const metricSelector = document.getElementById('select_pattern_metric');

    const resetCityButton = document.getElementById('patterns_cities');

    const initCities = Array("Toronto, ON", "Chicago, IL", "New York, NY", "San Francisco, CA", "Atlanta, GA", "Salt Lake City, UT");

    const all_cities = unpack(Object.values(rows).filter(item => ((item.metric === metricSelector.value) &&
    (item.week === '2022-01-31'))), 'display_title');

    function createCityTrace(y_val, city) {
        var trace = {
            x: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (item.display_title === city)), 'week'),
            y: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (item.display_title === city)), 'rolling_avg'),
            type: 'scatter',
            mode: 'lines',
            visible: 'legendonly',       
            transforms: [{
                type: 'groupby',
                groups: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (item.display_title === city)), 'region'),
                styles: {
                    Canada: {
                        line: {
                            color: '#DC4633'
                        }
                    },
                    Midwest: {
                        line: {
                            color: '#6FC7EA'
                        }
                    },
                    Northeast: {
                        line: {
                            color: '#8DBF2E'
                        }
                    },
                    Pacific: {
                        line: {
                            color: '#00A189'
                        }
                    },
                    Southeast: {
                        line: {
                            color: '#AB1368'
                        }
                    },
                    Southwest: {
                        line: {
                            color: '#F1C500'
                        }
                    }
                }
                  
            }
        ],
        line: {
            color: unpack(Object.values(rows).filter(item => (item.metric === y_val) && (item.display_title === city)), 'color'),
            width: 3,
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
                text: y_val.toProperCase() + ' Recovery -- 11 week rolling average',
                font: {
                    color: '#ffffff',
                    family: 'Open Sans, monospace',
                    size: 18
                }
            },
            xaxis: {
                gridcolor: '#4f4f4f',
                showticklabels: true,
                range: ['2020-05-10', '2023-04-10'],
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
                gridcolor: '#4f4f4f',
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
    

        var highlighted_cities = [];
        for (var i=0; i < city_array.length; i++) {
            highlighted_cities.push(city_array[i]);
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


    function resetCities() {
        initLinePlot(metricSelector.value, initCities);
    }

    function updateMetric() {
        initLinePlot(metricSelector.value, initCities);
    }
   
    resetCityButton.addEventListener('click', resetCities, false);

    metricSelector.addEventListener('change', updateMetric, false);

    initLinePlot(metricSelector.value, initCities);
});
