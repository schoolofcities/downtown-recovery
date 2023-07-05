<script>

    import Header from "../../../lib/Header.svelte";
    import SelectSeason from "../../../lib/SelectSeason.svelte";
    import SelectRegions from "../../../lib/SelectRegions.svelte";
    import SelectVariable from "../../../lib/SelectVariable.svelte";

    import { onMount } from 'svelte';
    import { csvParse } from 'd3-dsv';

    import { season, selectedRegions, regions, selectedVariable } from '../../../lib/stores.js';

    import "../../../assets/global.css";

    const baseUrl = import.meta.env.BASE_URL;


    // initial loading data and dynamic filtering

    let recoveryData = [];
    let variablesData = [];
    let filteredData = [];
    let chartData = [];

    const regionColours = $regions;

    async function loadDataRecovery() {
        try {
            const response = await fetch('../ranking_data.csv');
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

    onMount(() => {
        loadDataRecovery();
        loadDataVariables();
    });

    $: filteredData = recoveryData
        .filter(item => item.metric === 'downtown')
        .filter(item => item.region !== 'Europe')
        .filter(item => item.Season === `Season_${$season}`)
        .filter(item => $selectedRegions.includes(item.region))
        .sort((a, b) => b.seasonal_average - a.seasonal_average);

    // joining in the variables data
    $: chartData = filteredData.map(function(obj1) {
        var matchedObj = variablesData.find(function(obj2) {
            return obj2.city === obj1.city;
        });
        return Object.assign({}, obj1, matchedObj);
    });

    // $: console.log(filteredData);
    // $: console.log(chartData);



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




</script>




<Header/>

<main>

    <div class="text">

        <h1>
            Downtown Recovery Correlations
        </h1>
        <p>
            The recovery metrics on these charts are computed by counting the number unique visitors in a city's downtown area in the specified time period, and then dividing it by the number of unique visitors during the equivalent time period in 2019. Visits are based on a sample of mobile phone data.
        </p>
        <p>
            A recovery metric greater than 100% means that for the selected inputs, the mobile device activity increased from the comparison period. A value less than 100% means the opposite, that the city's downtown has not recovered to pre-COVID activity levels.
        </p>
        <p>
            For more information, read our <a href="{baseUrl}/methodology">Methodology</a> page. 
        </p>

    </div>

    <div id="chart-wrapper" bind:offsetWidth={chartWidth}>
        
        <div id="options">
            <div id="options-season">
                <SelectSeason/>
            </div>
            <div id="options-region">
                <SelectRegions europe={"no"}/>
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

            {#each chartData as d, i}

                {#if d[$selectedVariable] >= 0}

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

                {#if d[$selectedVariable] >= 0}

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
                        X-Value: {selected_datapoint[$selectedVariable].toLocaleString()}
                    </p>
                </div>
            </foreignObject>

            {/if}
            
        </svg>

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
        max-width: 650px;
    }

    #options-season {
        float: left;
        padding-right: 15px;
    }
    #options-region {
        overflow: hidden;
    }

    #note {
        color: var(--brandGray);
        font-size: 13px;
        text-align: right;
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

    .bar-label {
        /* fill: var(--brandWhite); */
        font-size: 13px;
    }

    .point-white {
        opacity: 0.9
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
