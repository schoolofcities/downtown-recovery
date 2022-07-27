

// load in data
Plotly.d3.csv('https://raw.githubusercontent.com/hmooreo/downtownrecovery/main/docs/ranking_data.csv', function (err, rows) {

    function unpack(rows, key) {
        return rows.map(function (row) { return row[key]; });
    }
    var mapDiv = document.getElementById('map-container');

    String.prototype.toProperCase = function () {
        return this.replace(/\w\S*/g, function (txt) { return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase(); });
    };


    var cities = unpack(rows, 'display_title');



    var metricSelector = document.getElementById('select_ranking_metric');
    var seasonSelector = document.getElementById('select_ranking_season');
    
    function setMap(metric, season) {
        var regions = unpack(Object.values(rows).filter(item => ((item.Season === season.value) && (item.metric === metric))), 'region');
        var trace = [{
            x: unpack(Object.values(rows).filter(item => ((item.Season === season.value) && (item.metric === metric))), 'seasonal_average'),
            y: unpack(Object.values(rows).filter(item => ((item.Season === season.value) && (item.metric === metric))), 'lq_rank'),
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
            text: unpack(Object.values(rows).filter(item => ((item.Season === season.value) && (item.metric === metric))), 'display_title'),
            marker: {
                color: unpack(Object.values(rows).filter(item => ((item.Season === season.value) && (item.metric === metric))), 'color'),
                size: 20
            },
        }];

        var layout = {
            plot_bgcolor: 'rgba(0,0,0,0)',
            paper_bgcolor: 'rgba(0,0,0,0)',
            title: {
                text: metric.toProperCase() + ' recovery: ' + season.options[season.selectedIndex].text,
                font: {
                    color: '#ffffff',
                    family: 'Open Sans, monospace',
                    size: 14
                }
            },
            xaxis: {
                tickfont: {
                    family: 'Open Sans, monospace',
                    size: 12,
                    color: '#ffffff'
                  },
                tickformat: ".0%",
                showticklabels: true,
                title: {
                    text: 'Recovery value',
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
                autorange: 'reversed',
             
                title: {
                    text: 'Ranking',
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


        var map = L.map('mapDiv').setView([41.1164, -95.35], 5);
        var cities = L.layerGroup()
        var tiles = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19,
            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        }).addTo(map);



        Plotly.react(plotDiv, trace, layout, config);
    };

    function updateMetric() {
        setHBarPlot(metricSelector.value, seasonSelector);
    }

    function updateSeason() {
        setHBarPlot(metricSelector.value, seasonSelector);
    }


   
    metricSelector.addEventListener('change', updateMetric, false);

    seasonSelector.addEventListener('change', updateSeason, false);

    setMap(metricSelector.value, seasonSelector);
});
