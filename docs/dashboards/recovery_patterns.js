

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
    var cities = [];
        for (var i=0; i < Array.from(citiesSelector.selectedOptions).length; i++) {
            cities.push(Array.from(citiesSelector.selectedOptions)[i].text);
        }
    var regions = unpack(Object.values(data).filter(item => (item.metric === metricSelector.value) && (cities.includes(item.display_title))), 'region');
    var regions_colors = unpack(Object.values(data).filter(item => (item.metric === metricSelector.value) && (cities.includes(item.display_title))), 'color');
    

    function setLinePlot(y_val) {
        

        var trace = [{
            x: unpack(Object.values(data).filter(item => (item.metric === y_val) && (cities.includes(item.display_title))), 'week'),
            y: unpack(Object.values(data).filter(item => (item.metric === y_val) && (cities.includes(item.display_title))), 'rolling_avg'),
            type: 'scatter',
            mode: 'lines',
            lines: {
                color: regions_colors,
                shape: 'spline'
            },
            transforms: [{
                type: 'groupby',
                groups: regions
            }/*, {
                type: 'groupby',
                groups: unpack(Object.values(data).filter(item => (item.metric === y_val) && (cities.sort().includes(item.display_title))), 'display_title'),
            } */],
            
            
            text: unpack(Object.values(data).filter(item => (item.metric === y_val) && (cities.includes(item.display_title))), 'display_title')
           
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
                showticklabels: true,
                range: ['2020-04-01', '2022-05-01'],
                tickfont: {
                    family: 'Courier New, monospace',
                    size: 14,
                    color: '#ffffff'
                  },
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
                tickfont: {
                    family: 'Courier New, monospace',
                    size: 14,
                    color: '#ffffff'
                  },
                title: {
                    text: 'Metric',
                    font: {
                        family: 'Courier New, monospace',
                        size: 16,
                        color: '#ffffff'
                    }
                }
            },
            legend: {
                font: {
                    family: 'Courier New, monospace',
                    size: 16,
                    color: '#ffffff'
                }
            }
        };

        var config = {
            displayModeBar: false
        }

        Plotly.react(plotDiv, trace, layout, config);

    };


    function updateCities() {
        setLinePlot(metricSelector.value);
    }

    function updateMetric() {
        setLinePlot(metricSelector.value);
    }
   
    citiesSelector.addEventListener('change', updateCities, false);

    metricSelector.addEventListener('change', updateMetric, false);

    setLinePlot(metricSelector.value);
});
