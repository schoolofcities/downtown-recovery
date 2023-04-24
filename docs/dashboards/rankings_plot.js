

// load in data
Plotly.d3.csv('https://raw.githubusercontent.com/schoolofcities/downtown-recovery/stoppers_hll_update/docs/ranking_data_hll.csv', function (err, rows) {

    function unpack(rows, key) {
        return rows.map(function (row) { return row[key]; });
    }
    var plotDiv = document.getElementById('rankings-plot');

    String.prototype.toProperCase = function () {
        return this.replace(/\w\S*/g, function (txt) { return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase(); });
    };

    const update_seasons = ["Season_10", "Season_11", "Season_12"];
    var seasonSelector = document.getElementById('select_ranking_season');

    seasonSelector.addEventListener('change', function(e) {
        if (update_seasons.includes(seasonSelector.value) & (document.getElementById('select_ranking_metric').value != "downtown")) {
            document.getElementById('select_ranking_metric').value = "downtown";
        }
      });

    

    document.getElementById('select_ranking_metric').addEventListener('change', function(e) {
        if (update_seasons.includes(seasonSelector.value) & (document.getElementById('select_ranking_metric').value != "downtown")) {
            document.getElementById('select_ranking_metric').value = "downtown";
        }
      });





    var metricSelector = document.getElementById('select_ranking_metric');
    

    function rankDuplicate(arr) {
        const sorted = [...new Set(arr)].sort((a, b) => b - a);
        const rank = new Map(sorted.map((x, i) => [x, i + 1]));
        return arr.map((x) => rank.get(x));
    }
    
    function setHBarPlot(metric, season) {
        var regions = unpack(Object.values(rows).filter(item => ((item.Season === season.value) && (item.metric === metric))), 'region');

        var trace = [{
            x: unpack(Object.values(rows).filter(item => ((item.Season === season.value) && (item.metric === metric))), 'seasonal_average'),
            y: unpack(Object.values(rows).filter(item => ((item.Season === season.value) && (item.metric === metric))), 'lq_rank'),
            type: 'bar',
            orientation: 'h',
            hoverinfo:"x+y",
            hovertemplate:

            "<b>City: </b>%{text}<br>" +

            "<b>Recovery ranking: </b> %{y}<br>" +

            "<b>%{xaxis.title.text}: </b>%{x:.0%}<br>" +

            "<extra></extra>",
            transforms: [{
                type: 'groupby',
                groups: regions,
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
            }],
            text: unpack(Object.values(rows).filter(item => ((item.Season === season.value) && (item.metric === metric))), 'display_title'),
            texttemplate:
            "<b>%{y} %{text} : </b> %{x}<br>",
            textposition: 'inside',
            marker: {
                color: unpack(Object.values(rows).filter(item => ((item.Season === season.value) && (item.metric === metric))), 'color'),
                size: 50,
                opacity: .9,
                line : {
                    color: '#ffffff',
                    width: 1.5
                }
            },
            insidetextfont: {
                size: 64
            }
            //width: 3
            //offset: 5
        }];

        var layout = {
            plot_bgcolor: 'rgba(0,0,0,0)',
            paper_bgcolor: 'rgba(0,0,0,0)',
            hovermode: 'closest',
            height: 1800,
            title: {
                text: metric.toProperCase() + ' Recovery -- ' + season.options[season.selectedIndex].text,
                font: {
                    color: '#ffffff',
                    family: 'Open Sans, monospace',
                    size: 18
                }
            },
            xaxis: {
                gridcolor: '#5c5c5c',
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
            },
            bargap:2
        };

        var config = {
            responsive: true,
            //displayModeBar: false
        }
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

    setHBarPlot(metricSelector.value, seasonSelector);
});
