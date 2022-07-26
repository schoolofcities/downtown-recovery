

// load in data
Plotly.d3.csv('https://raw.githubusercontent.com/hmooreo/downtownrecovery/main/docs/model_data_long.csv', function (err, rows) {

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
                text: y_val.toProperCase() + ' recovery: Mar 2022 - May 2022',
                font: {
                    color: '#ffffff',
                    family: 'Courier New, monospace',
                    size: 14
                }
            },
            xaxis: {
                tickfont: {
                    family: 'Courier New, monospace',
                    size: 12,
                    color: '#ffffff'
                  },
                showticklabels: true,
                title: {
                    text: 'Recovery value',
                    font: {
                        family: 'Courier New, monospace',
                        size: 12,
                        color: '#ffffff'
                    }
                }
            },
            yaxis: {
                showticklabels: true,
                tickfont: {
                    family: 'Courier New, monospace',
                    size: 12,
                    color: '#ffffff'
                  },
                autorange: 'reversed',
             
                title: {
                    text: 'Ranking',
                    font: {
                        family: 'Courier New, monospace',
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
                    family: 'Courier New, monospace',
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

    function updateMetric() {
        setHBarPlot(metricSelector.value);
    }
   
    metricSelector.addEventListener('change', updateMetric, false);
    setHBarPlot(metricSelector.value);
});
