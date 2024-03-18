<script>

    import Header from "../../../lib/Header.svelte";
    import SelectSeason from "../../../lib/SelectSeason.svelte";
    import SelectRegions from "../../../lib/SelectRegions.svelte";
    import SelectVariable from "../../../lib/SelectVariable.svelte";

    import { onMount } from 'svelte';
    import { csvParse } from 'd3-dsv';
    import { sampleCorrelation, linearRegression } from 'simple-statistics';

    import { season, selectedRegions, regions, selectedVariable } from '../../../lib/stores.js';

    import "../../../assets/global.css";


    // initial loading data and dynamic filtering

    let recoveryData = [];
    let variablesData = [];
    let filteredData = [];
    let chartData = [];
    let dataDictionary = [];
    let dataCorrelation = 0;
    let dataLinearRegression;
    let dataTrendLineSlope = 0;
    let dataTrendLineIntercept = 0;
    let dataTrendLine = [[0,0],[1,1]];
    

    let selectedVariableTitle = "";
    let selectedVariableSource= "";
    let selectedVariableGroup= "";

    const regionColours = $regions;

    async function loadDataRecovery() {
        try {
            const response = await fetch('../recovery_rankings.csv');
            const csvData = await response.text();
            recoveryData = csvParse(csvData);
        } catch (error) {
            console.error('Error loading CSV data:', error);
        }
    }

    async function loadDataVariables() {
        try {
            const response = await fetch('../variables_data.csv');
            const csvData = await response.text();
            variablesData = csvParse(csvData);
        } catch (error) {
            console.error('Error loading CSV data:', error);
        }
    }

    async function loadDataDictionary() {
        try {
            const response = await fetch('../variables_data_dictionary.csv');
            const csvData = await response.text();
            dataDictionary = csvParse(csvData);
        } catch (error) {
            console.error('Error loading CSV data:', error);
        }
    }

    onMount(() => {
        loadDataRecovery();
        loadDataVariables();
        loadDataDictionary();
    });

    $: filteredData = recoveryData
        // .filter(item => item.metric === 'downtown')
        // .filter(item => item.region !== 'Europe')
        // .filter(item => item.Season === `Season_${$season}`)
        .filter(item => $selectedRegions.includes(item.region))
        .sort((a, b) => b.seasonal_average - a.seasonal_average);

    // joining in the variables data
    $: chartData = filteredData.map(function(obj1) {
        var matchedObj = variablesData.find(function(obj2) {
            return obj2.city === obj1.city;
        });
        return Object.assign({}, obj1, matchedObj);
    });




    // variable info to print at bottom

    $: selectedVariableSource = dataDictionary.length > 0 ? dataDictionary.filter(obj => obj.value === $selectedVariable)[0]["source"] : null;
    $: selectedVariableTitle = dataDictionary.length > 0 ? dataDictionary.filter(obj => obj.value === $selectedVariable)[0]["text"] : null;
    $: selectedVariableGroup = dataDictionary.length > 0 ? dataDictionary.filter(obj => obj.value === $selectedVariable)[0]["group"] : null;



    // // chart parameters

    let chartWidth;
    let chartHeight = 420;
    $: chartHeight = chartWidth * 0.666;



    // y-axis

    let maxRecoveryValue = 1; // for y-axis scale
    $: maxRecoveryValue = chartData.length !== 0 ? chartData[0].seasonal_average : 1;
    $: maxRecoveryValue = maxRecoveryValue < 1 ? 1 : maxRecoveryValue;

    function generateYaxisIntervals(maxValue, interval) {
        let values = [];
        for (let i = 0; i <= Math.ceil(maxValue / interval); i++) {
            values.push(i * interval);
        }
        return values;
    } 

    let yAxisIntervals = [0, 1];
    $: if (maxRecoveryValue < 2) {
        yAxisIntervals = generateYaxisIntervals(maxRecoveryValue, 0.2)
    }
    else 
        {yAxisIntervals = generateYaxisIntervals(maxRecoveryValue, 0.5)
    } ;

    $: yAxisIntervalSpacing = (chartHeight - 40) / (yAxisIntervals.length - 1);

    $: yAxisRange = [Math.min(...yAxisIntervals), Math.max(...yAxisIntervals)];


    // x axis

    let xVariable;
    $: xVariable = $selectedVariable;

    let xAxisWidth = 100;
    $: xAxisWidth = chartWidth - 45 - 10;

    let maxX = 1;
    $: maxX = Math.max(...chartData.map(obj => parseFloat(obj[xVariable])).filter(num => !isNaN(num)));

    function roundUpToNearestOrder(number) {
        const order = Math.pow(10, Math.floor(Math.log10(number)));
        return Math.ceil(number / order) * order;
    }

    let maxXaxis = 1;
    $: maxXaxis = roundUpToNearestOrder(maxX); 

    let xIntervalChart = 0.1;
    $: xIntervalChart = xAxisWidth / 4;

    let xIntervalUnits = 1;
    $: xIntervalUnits = maxXaxis / 4;

    function yScale(axisRange, axisHeight, yValue) {
        return axisHeight - axisHeight * yValue / (axisRange[1] - axisRange[0])
    }

    function xScale(axisRange, axisLength, xValue) {
        return axisLength * xValue / (axisRange[1] - axisRange[0])
    }


    // tooltip

    let selected_datapoint = undefined;
	let mouse_x, mouse_y;
	const setMousePosition = function (event) {
		mouse_x = event.clientX;
		mouse_y = event.clientY;
	};



    // correlation and trend line

    let filteredChartData = [];
    $: filteredChartData = chartData.filter(e => !isNaN(parseFloat(e[xVariable])));

    $: console.log(filteredChartData);


    $: dataCorrelation =
    filteredChartData.length > 0 ? 
        sampleCorrelation(
            filteredChartData.map(obj => parseFloat(obj[xVariable])), 
            filteredChartData.map(obj => parseFloat(obj.seasonal_average))
        ) : 0;

    $: dataLinearRegression =
    filteredChartData.length > 0 ? 
        linearRegression(
            filteredChartData.map(obj => [parseFloat(obj[xVariable]), parseFloat(obj.seasonal_average)])
        ) : null;

    function regressionLineSquare(m, b, xmin, ymin, xmax, ymax) {
        let x1, y1, x2, y2;

        let y_xmin = m * xmin + b;
        if (y_xmin >= ymin && y_xmin <= ymax) {
            x1 = xmin;
            y1 = y_xmin;
        } else if (m > 0) {
            x1 = (ymin - b) / m;
            y1 = ymin;
        } else {
            x1 = (ymax - b) / m;
            y1 = ymax;
        };

        let y_xmax = m * xmax + b
        if (y_xmax >= ymin && y_xmax <= ymax) {
            x2 = xmax;
            y2 = y_xmax;
        } else if (m > 0) {
            x2 = (ymax - b) / m;
            y2 = ymax;
        } else {
            x2 = (ymin - b) / m;
            y2 = ymin;
        }
        
        return [[x1, y1], [x2, y2]];
    }

    $: dataTrendLine = dataLinearRegression !== null ? regressionLineSquare(dataLinearRegression.m, dataLinearRegression.b, 0, 0, maxXaxis, Math.max(...yAxisIntervals)) : [[0,0],[1,1]];

    $: dataTrendLineSlope = dataLinearRegression !== null ? 100 * dataLinearRegression.m : 0;
    $: dataLinearRegression !== null ?  dataTrendLineIntercept = 100 * dataLinearRegression.b : 0;

    function formatNumber(x) {
    const threshold = 0.001; // Threshold for determining when to switch to scientific notation

    if (Math.abs(x) < threshold) {
        return x.toExponential(2); // Use scientific notation with two decimal points
    } else if (Math.abs(x) >= 1000) {
        return x.toLocaleString(undefined, { maximumFractionDigits: 0 }); // Use locale string with no decimal points for large numbers
    } else if (Math.abs(x) >= 10) {
        return x.toFixed(2);
    } else {
        return x.toFixed(4); // Round to two decimal points for other numbers
    }
    }

</script>




<Header/>

<main>

    <div class="text">

        <h1>
            Downtown Recovery Correlations
        </h1>
        <p><i>Updated October 16, 2023</i></p>
        <p>
            This page plots downtown recovery rates (y-axis) relative to a number of other urban variables (x-axis). While these charts indicate bivariate relationships, and in some cases reveal potential correlations, they should be interpreted with caution as they do not imply direct causation.
        </p>
        <p>
            The recovery metrics (y-axis) on these charts are based on a sample of mobile phone data. The recovery metrics on the charts and maps are computed by counting the number of unique visitors in a city's downtown area in the specified time period (standardized by region – see ‘Standardization’ section below), and then dividing it by the standardized number of unique visitors during the equivalent time period in 2019. Specifically, the rankings below compare the period from the beginning of March to mid-June in 2023 relative to the same period in 2019.
        </p>
        <p>
            A recovery metric greater than 100% means that for the selected inputs, the mobile device activity increased relative to the comparison period. A value less than 100% means the opposite, that the city's downtown has not recovered to pre-COVID activity levels. Click <a href="/recovery_rankings.csv">here</a> to download the y-axis data shown on this chart. 
        </p>
        <p>
            The data on the x-axis comes from a variety of sources. The full dataset including all variables in the drop-down can be downloaded <a href="/variables_data.csv">here</a>. You may also wish to download a <a href="/variables_data_dictionary.csv">data dictionary</a>, which includes the names of data sources for each variable.
        </p>
        <p>
            For more information, read our <a href="/methodology">Methodology</a> page.
        </p>

    </div>

    <div id="chart-wrapper" bind:offsetWidth={chartWidth}>

        
        
        <div id="options">
            <!-- <div id="options-season">
                <SelectSeason/>
            </div> -->
            <p>Select Regions:</p>
            <div id="options-region">
                <SelectRegions europe={"no"} canada={"yes"}/>
            </div>
            <SelectVariable/>
            
        </div>

        <svg height={chartHeight} width={chartWidth} id="chart">

            {#each yAxisIntervals.reverse() as yInterval, i}

                <line class="grid"
                    x1 = 40
                    y1 = {30 + i * yAxisIntervalSpacing}
                    x2 = {chartWidth}
                    y2 = {30 + i * yAxisIntervalSpacing}
                ></line>

                <text class="axis-label"
                    x = 35
                    y = {35 + i * yAxisIntervalSpacing}
                    text-anchor="end"
                >{(100 * yInterval).toFixed(0)}%</text>

                <line class="grid-white"
                    x1 = 37
                    y1 = {30 + i * yAxisIntervalSpacing}
                    x2 = 45
                    y2 = {30 + i * yAxisIntervalSpacing}
                ></line>

            {/each}

            {#each [0,1,2,3,4] as i}

                <line class="grid"
                    x1 = {45 + i * xIntervalChart}
                    y1 = 22
                    x2 = {45 + i * xIntervalChart}
                    y2 = {chartHeight}
                ></line>

                <text class="axis-label"
                    x = {47 + i * xIntervalChart}
                    y = 17
                    text-anchor="end"
                >{(i * xIntervalUnits).toLocaleString()}</text>

                <line class="grid-white"
                    x1 = {45 + i * xIntervalChart}
                    y1 = 22
                    x2 = {45 + i * xIntervalChart}
                    y2 = 31
                ></line>

            {/each}

            <line 
                x1={45 + xScale(
                    [0, maxXaxis],
                    xAxisWidth,
                    parseFloat(dataTrendLine[0][0])
                    )}
                y1={30 + yScale(
                    yAxisRange,
                    chartHeight - 40,
                    parseFloat(dataTrendLine[0][1])
                )} 
                x2={45 + xScale(
                    [0, maxXaxis],
                    xAxisWidth,
                    parseFloat(dataTrendLine[1][0])
                    )} 
                y2={30 + yScale(
                    yAxisRange,
                    chartHeight - 40,
                    parseFloat(dataTrendLine[1][1])
                )}  
                stroke="#D0D1C9"
                stroke-width="1.5"
                stroke-dasharray="4 2"
            />

            {#each chartData as d, i}

                {#if d[xVariable] >= 0 && !isNaN(parseFloat(d[xVariable]))}

                    <circle class="point-white"
                        cx={45 + xScale(
                            [0, maxXaxis],
                            xAxisWidth,
                            parseFloat(d[$selectedVariable])
                        )}
                        cy={30 + yScale(
                            yAxisRange,
                            chartHeight - 40,
                            d.seasonal_average
                        )}
                        r="6" 
                        fill="black"
                        stroke="white"
                        stroke-width="3"  
                    />

                {/if}

            {/each}

            {#each chartData as d, i}

            {#if d[xVariable] >= 0 && !isNaN(parseFloat(d[xVariable]))}

                <circle class="point"
                    cx={45 + xScale(
                        [0, maxXaxis],
                        xAxisWidth,
                        parseFloat(d[$selectedVariable])
                    )}
                    cy={30 + yScale(
                        yAxisRange,
                        chartHeight - 40,
                        d.seasonal_average
                    )}
                    r="6" 
                    fill={regionColours.find(region => region.name === d.region).colour}
                    stroke="white"
                    stroke-width="0"

                    on:mouseover={(event) => {
                        selected_datapoint = d;
                        setMousePosition(event);
                    }}
                    on:mouseout={() => {
                        selected_datapoint = undefined;
                    }}
                    
                />

                {/if}

            {/each}

            {#if selected_datapoint != undefined}

            <foreignObject
                x={(parseFloat(selected_datapoint[$selectedVariable]) < maxXaxis / 2 ? 0 : -145) + 55 + xScale(
                    [0, maxXaxis],
                    xAxisWidth,
                    parseFloat(selected_datapoint[$selectedVariable])
                )} 
                y={22 + yScale(
                    yAxisRange,
                    chartHeight - 40,
                    selected_datapoint.seasonal_average
                )} 
                width="125" 
                height="50">
                <div id="tooltip" 
                style="background-color: {regionColours.find(region => region.name === selected_datapoint.region).colour}">
                    <p id="tooltip-p"
                    style="color: {regionColours.find(region => region.name === selected_datapoint.region).text}">
                        <u>{selected_datapoint.city}</u>
                        <br> 
                        Recovery Rate: {Math.round(100 *selected_datapoint.seasonal_average)}%
                        <br>
                        X-Value: {(selected_datapoint[$selectedVariable]).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")}
                    </p>
                </div>
            </foreignObject>

            {/if}
            
        </svg>

        <div class="text">
            <p><i class="italic">X-Variable Name:</i> {selectedVariableTitle}</p>
            <p><i class="italic">Group:</i> {selectedVariableGroup}</p>
            <p><i class="italic">Correlation Coefficient:</i> {dataCorrelation.toFixed(3)}</p>
            <p><i class="italic">Trend Line Formula</i>: Recovery Rate (%) = {formatNumber(dataTrendLineSlope)} X + {dataTrendLineIntercept.toFixed(2)}</p>
            <p><i class="italic">Data Source:</i> {selectedVariableSource}</p>
            <br>
            <br>
        </div>

        <br>
        <br>
        <br>

    </div>

</main>




<style>

    main {
        margin: 0 auto;
        margin-left: 15px;
        margin-right: 15px;
        width: calc(100% - 30px);
        min-width: 320px;
        max-width: 1920px;
        position: relative;
    }

    #chart-wrapper {
        margin: 0 auto;
        max-width: 840px;
    }

    #options {
        margin: 0 auto;
        max-width: 750px;
    }

    #options-season {
        float: left;
        padding-right: 15px;
    }
    #options-region {
        overflow: hidden;
    }

    #chart {
        margin-top: 30px;
        margin-bottom: 10px;
        background-color: var(--brandGray90);
    }

    .grid {
        stroke: var(--brandDarkBlue);
        stroke-width: 1px;
    }

    .grid-white {
        stroke: var(--brandWhite);
        stroke-width: 1px;
    }

    .axis-label {
        fill: var(--brandGray);
        font-size: 14px;
    }

    .point-white {
        opacity: 0.9
    }

    .point:hover {
        cursor: pointer;
    }

    #tooltip {
		color: white;
        background-color: var(--brandGray90);
		font-family: Roboto, sans-serif;
		font-size: 12px;
        border: solid 2px var(--brandGray);
        border-radius: 4px;
        padding: 3px;
        z-index: 99999;
	}

    #tooltip-p {
        font-size: 12px;
        line-height: 13px;
        padding-top: 0px;
        padding-bottom: 0px;
        margin: 0px;
    }


</style>
