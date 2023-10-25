<script>

    import Header from "../../../../lib/Header.svelte";
    import SelectSeason from "../../../../lib/SelectSeason.svelte";
    import SelectRegions from "../../../../lib/SelectRegions.svelte";
    import SelectVariable from "../../../../lib/SelectVariable.svelte";

    import { onMount } from 'svelte';
    import { csvParse } from 'd3-dsv';
    import { sampleCorrelation, linearRegression } from 'simple-statistics';

    import { season, selectedRegions, regions, selectedVariable, cities } from '../../../../lib/stores.js';

    import "../../../../assets/global.css";

    export let transitVariable;


    const modeDictionary = [
        {
            "id": "MB",
            "name": "Bus",
            "colour": "#6D247A"
        },
        {
            "id": "CR",
            "name": "Commuter Rail",
            "colour": "#8DBF2E"
        },
        {
            "id": "LR",
            "name": "Light Rail",
            "colour": "#DC4633"
        },
        {
            "id": "HR",
            "name": "Subway/Metro",
            "colour": "#6FC7EA"
        },
        {
            "id": "All",
            "name": "Transit",
            "colour": "#6FC7EA"
        }
    ];

    let modeName = modeDictionary.filter(item => item.id === transitVariable)[0].name;
    let modeColour = modeDictionary.filter(item => item.id === transitVariable)[0].colour;

    // initial loading data and dynamic filtering

    let recoveryData = [];
    let chartData = [];
    let dataCorrelation = 0;
    let dataLinearRegression;
    let dataTrendLineSlope = 0;
    let dataTrendLineIntercept = 0;
    let dataTrendLine = [[0,0],[1,1]];

    let selectedVariableTitle = "";
    let selectedVariableSource= "";
    let selectedVariableGroup= "";

    const regionColours = $regions;

    function getCityColour(city) {
        const cityRegion = cities.find(item => item.city === city);
        return cityRegion.region;
    }


    async function loadDataRecovery() {
        try {
            const response = await fetch('../transit-and-downtown-recovery.csv');
            const csvData = await response.text();
            recoveryData = csvParse(csvData);
            console.log(recoveryData);
        } catch (error) {
            console.error('Error loading CSV data:', error);
        }
    }

    onMount(() => {
        loadDataRecovery();
    });

    $: chartData = recoveryData
        .filter(item => item.mode === transitVariable)
        .sort((a, b) => b.downtown_recovery - a.downtown_recovery);


    // // chart parameters

    let chartWidth;
    let chartHeight = 420;
    $: chartHeight = chartWidth * 1 + 20;


    // y-axis

    let maxRecoveryValue = 1.4; // for y-axis scale

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

    $: yAxisIntervalSpacing = (chartHeight - 60) / (yAxisIntervals.length - 1);

    $: yAxisRange = [Math.min(...yAxisIntervals), Math.max(...yAxisIntervals)];

    function yScale(axisRange, axisHeight, yValue) {
        return axisHeight - axisHeight * yValue / (axisRange[1] - axisRange[0])
    }


    // x axis

    let xVariable = "transit_recovery";

    let xAxisWidth = 100;
    $: xAxisWidth = chartWidth - 45 - 10;

    let maxXaxis = 140;

    let xIntervalChart = 0.1;
    $: xIntervalChart = xAxisWidth / 7;

    let xIntervalUnits = 1;
    $: xIntervalUnits = maxXaxis / 7;

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
            filteredChartData.map(obj => parseFloat(obj.downtown_recovery))
        ) : 0;

    $: dataLinearRegression =
    filteredChartData.length > 0 ? 
        linearRegression(
            filteredChartData.map(obj => [parseFloat(obj[xVariable]), parseFloat(obj.downtown_recovery)])
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

    <div class="text">

   
        <div id="chart-wrapper" bind:offsetWidth={chartWidth}>

            <h3>{modeName} Ridership & Downtown Recovery</h3>

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

                {#each [0,1,2,3,4,5,6,7] as i}

                    <line class="grid"
                        x1 = {45 + i * xIntervalChart}
                        y1 = 22
                        x2 = {45 + i * xIntervalChart}
                        y2 = {chartHeight - 20}
                    ></line>

                    <text class="axis-label"
                        x = {47 + i * xIntervalChart}
                        y = {chartHeight - 10}
                        text-anchor="end"
                    >{(i * xIntervalUnits).toLocaleString()}%</text>

                    <line class="grid-white"
                        x1 = {45 + i * xIntervalChart}
                        y1 = {chartHeight - 25}
                        x2 = {45 + i * xIntervalChart}
                        y2 = {chartHeight - 30}
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
                                parseFloat(d[xVariable])
                            )}
                            cy={30 + yScale(
                                yAxisRange,
                                chartHeight - 60,
                                d.downtown_recovery
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
                                parseFloat(d[xVariable])
                            )}
                            cy={30 + yScale(
                                yAxisRange,
                                chartHeight - 60,
                                d.downtown_recovery
                            )}
                            r="6" 
                            fill={modeColour}
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
                    x={(parseFloat(selected_datapoint[xVariable]) < maxXaxis / 2 ? 0 : -175) + 55 + xScale(
                        [0, maxXaxis],
                        xAxisWidth,
                        parseFloat(selected_datapoint[xVariable])
                    )} 
                    y={22 + yScale(
                        yAxisRange,
                        chartHeight - 60,
                        selected_datapoint.downtown_recovery
                    )} 
                    width="155" 
                    height="50">
                    <div id="tooltip" 
                    style="background-color: black"
                    >
                        <p id="tooltip-p">
                            <u>{selected_datapoint.city}</u>
                            <br> 
                            Downtown Recovery: {Math.round(100 *selected_datapoint.downtown_recovery)}%
                            <br>
                            Transit Recovery: {Math.round((selected_datapoint.transit_recovery).toString())}%
                        </p>
                    </div>
                </foreignObject>

                {/if}

                <text class="axis-label"
                        x = {chartWidth / 2 + 14}
                        y = {chartHeight - 40}
                        text-anchor="middle"
                    >{modeName} Ridership Recovery</text>

                <text class="axis-label"
                    x = 300
                    y = {375}
                    text-anchor="middle"
                    transform="rotate(-90, 60, 375)"
                >Downtown Recovery</text>
                
            </svg>

        </div>
    </div>





<style>

    .text {
        border: 0px;
    }


    #chart-wrapper {
        margin: 0 auto;
        max-width: 500px;
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

    h3 {
       
        margin-bottom: -30px;
        font-family: TradeGothicBold;
        font-size: 22px;
        color: var(--brandWhite);
        text-decoration: none;
        background-color: var(--brandDarkBlue);
        padding-left: 8px;
        padding-right: 8px;
        padding-top: 0px;
        padding-bottom: 0px;
    }


</style>
