

// load in data
Plotly.d3.csv('https://raw.githubusercontent.com/hmooreo/downtownrecovery/main/docs/model_data_metrics.csv', function (err, rows) {

    function unpack(rows, key) {
        return rows.map(function (row) { return row[key]; });
    }
    var plotDiv = document.getElementById('explanatory-plot');

    String.prototype.toProperCase = function () {
        return this.replace(/\w\S*/g, function (txt) { return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase(); });
    };

    
    var metricSelector = document.getElementById('select_metric');
    var seasonSelector = document.getElementById('select_explanatory_season');
    var xSelector = document.getElementById('x_vars');

    


    function setScatterPlot(y_val, x_val, x_name, season) {

        var regions = unpack(Object.values(rows).filter(item => (item.x_var === x_val) && (item.Season === season.value)), 'region');
        var trace = [{
            x: unpack(Object.values(rows).filter(item => (item.x_var === x_val) && (item.Season === season.value)), 'x_val'),
            y: unpack(Object.values(rows).filter(item => (item.x_var === x_val) && (item.Season === season.value)), y_val),
            type: 'scatter',
            mode: 'markers+text',
            text: unpack(Object.values(rows).filter(item => (item.x_var === x_val) && (item.Season === season.value)), 'display_title'),
            textposition: "top center",
            textfont: {
                color:unpack(Object.values(rows).filter(item => (item.x_var === x_val) && (item.Season === season.value)), 'color'),
                size: 10
            },
            hoverinfo:"x+y",
            hovertemplate:

            "<b>City: </b>%{text}<br>" +

            "<b>Recovery %{yaxis.title.text}: </b> %{y}<br>" +

            "<b>%{xaxis.title.text}: </b>%{x}<br>" +

            "<extra></extra>",
            transforms: [{
                type: 'groupby',
                groups: regions,
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
            }],
            
            
            marker: {
                color: unpack(Object.values(rows).filter(item => (item.x_var === x_val) && (item.Season === season.value)), 'color'),
                size: 6
            },
        }];

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
                "orientation": "h",
                x:0,
                y:1,
                
                xanchor:'left',
                yanchor:'bottom',
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


    function updateX() {
        setScatterPlot(metricSelector.value, xSelector.value, xSelector.options[xSelector.selectedIndex].text, seasonSelector);
    }

    function updateMetric() {
        setScatterPlot(metricSelector.value, xSelector.value, xSelector.options[xSelector.selectedIndex].text, seasonSelector);
    }

    function updateSeason() {
        setScatterPlot(metricSelector.value, xSelector.value, xSelector.options[xSelector.selectedIndex].text, seasonSelector);
    }

    xSelector.addEventListener('change', updateX, false);

    metricSelector.addEventListener('change', updateMetric, false);

    seasonSelector.addEventListener('change', updateSeason, false);

    setScatterPlot(metricSelector.value, xSelector.value, xSelector.options[xSelector.selectedIndex].text, seasonSelector);
});
