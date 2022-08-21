

// load in data
Plotly.d3.csv('https://raw.githubusercontent.com/hmooreo/downtownrecovery/main/docs/model_data_metrics.csv', function (err, rows) {

    function unpack(rows, key) {
        return rows.map(function (row) { return row[key]; });
    }
    var plotDiv = document.getElementById('explanatory-plot');

    String.prototype.toProperCase = function () {
        return this.replace(/\w\S*/g, function (txt) { return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase(); });
    };

    
    const metricSelector = document.getElementById('select_metric');
    var seasonSelector = document.getElementById('select_explanatory_season');
    var xSelector = document.getElementById('x_vars');


    const resetCityButton = document.getElementById('explanatory_reset');

    const initCities = Array("Toronto, ON", "Chicago, IL", "New York, NY", "San Francisco, CA", "Atlanta, GA", "Salt Lake City, UT",
    "", "", "", "");

    const all_cities = unpack(Object.values(rows).filter(item => (item.x_var === xSelector.value) && (item.Season === seasonSelector.value)), 'display_title');




    function createCityTrace(y_val, x_val, x_name, season, city) {
        var trace = {
            x: unpack(Object.values(rows).filter(item => (item.x_var === x_val) && (item.Season === season.value) && (item.display_title === city)), 'x_val'),
            y: unpack(Object.values(rows).filter(item => (item.x_var === x_val) && (item.Season === season.value) && (item.display_title === city)), y_val),
            type: 'scatter',
            mode: 'markers+text',
           
            visible: 'legendonly',       
            transforms: [{
                type: 'groupby',
                groups: unpack(Object.values(rows).filter(item => (item.x_var === x_val) && (item.Season === season.value) && (item.display_title === city)), 'region'),
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
                  
            }
        ],
        marker: {
            color: unpack(Object.values(rows).filter(item => (item.x_var === x_val) && (item.Season === season.value) && (item.display_title === city)), 'color'),
            size: 14
        },
        legendgroup: unpack(Object.values(rows).filter(item => (item.x_var === x_val) && (item.Season === season.value) && (item.display_title === city)), 'region'),
        name: unpack(Object.values(rows).filter(item => (item.x_var === x_val) && (item.Season === season.value) && (item.display_title === city)), 'display_title'),
        text: unpack(Object.values(rows).filter(item => (item.x_var === x_val) && (item.Season === season.value) && (item.display_title === city)), 'display_title'),
        textposition: "top center",
        textfont: {
            color:unpack(Object.values(rows).filter(item => (item.x_var === x_val) && (item.Season === season.value) && (item.display_title === city)), 'color'),
            size: 14
        },
        hoverinfo:"x+y",
        hovertemplate:
            "<b>City: </b>%{text}<br>" +
            "<b>Recovery %{yaxis.title.text}: </b> %{y:.0%}<br>" +
            "<b>%{xaxis.title.text}: </b>%{x}<br>" +
            "<extra></extra>"
        };

        trace['name'] = city;

        return(trace);
    };

    // old below-





    function initScatterPlot(y_val, x_val, x_name, season, city_array) {

        var data = [];
        for (var i=0; i < all_cities.length; i++) {
            data[i] = createCityTrace(y_val, x_val, x_name, season, all_cities[i])

        }

        var layout = {
            hovermode:'closest',
            plot_bgcolor: 'rgba(0,0,0,0)',
            paper_bgcolor: 'rgba(0,0,0,0)',
            title: {
                text: y_val.toProperCase() + ' recovery: ' + season.options[season.selectedIndex].text,

                font: {
                    color: '#ffffff',
                    family: 'Open Sans, monospace',
                    size: 14
                }
            },
            xaxis: {
                gridcolor: '#bdbdbd',
                tickfont: {
                    family: 'Open Sans, monospace',
                    size: 12,
                    color: '#ffffff'
                  },
                showticklabels: true,


                title: {
                    text: x_name,
                    font: {
                        family: 'Open Sans, monospace',
                        size: 12,
                        color: '#ffffff'
                    }
                }
            },
            yaxis: {
                gridcolor: '#bdbdbd',
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


    function updateX() {
        initScatterPlot(metricSelector.value, xSelector.value, xSelector.options[xSelector.selectedIndex].text, seasonSelector, initCities);
    }

    function updateMetric() {
        initScatterPlot(metricSelector.value, xSelector.value, xSelector.options[xSelector.selectedIndex].text, seasonSelector, initCities);
    }

    function updateSeason() {
        initScatterPlot(metricSelector.value, xSelector.value, xSelector.options[xSelector.selectedIndex].text, seasonSelector, initCities);
    }

    function resetCities() {
        initScatterPlot(metricSelector.value, xSelector.value, xSelector.options[xSelector.selectedIndex].text, seasonSelector, initCities);
    }

    xSelector.addEventListener('change', updateX, false);

    metricSelector.addEventListener('change', updateMetric, false);
    resetCityButton.addEventListener('click', resetCities, false);
    seasonSelector.addEventListener('change', updateSeason, false);

    initScatterPlot(metricSelector.value, xSelector.value, xSelector.options[xSelector.selectedIndex].text, seasonSelector, initCities);
});
