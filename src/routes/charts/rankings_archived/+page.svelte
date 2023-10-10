<script>

    import Header from "../../../lib/Header.svelte";
    import SelectSeason from "../../../lib/SelectSeason.svelte";
    import SelectRegions from "../../../lib/SelectRegions.svelte";

    import { onMount } from 'svelte';
    import { csvParse } from 'd3-dsv';

    import { season, selectedRegions, regions } from '../../../lib/stores.js';

    import "../../../assets/global.css";


    // initial loading data and dynamic filtering

    let data = [];
    let filteredData = [];

    const regionColours = $regions;

    async function loadData() {
        try {
            const response = await fetch('../ranking_data.csv');
            const csvData = await response.text();
            data = csvParse(csvData);
        } catch (error) {
            console.error('Error loading CSV data:', error);
        }
    }

    onMount(() => {
        loadData();
    });

    $: filteredData = data
        .filter(item => item.metric === 'downtown')
        .filter(item => item.Season === `Season_${$season}`)
        .filter(item => $selectedRegions.includes(item.region))
        .sort((a, b) => b.seasonal_average - a.seasonal_average);


    // chart parameters

    let chartWidth;
    let chartHeight = 100;
    $: chartHeight = 24 * filteredData.length + 50;

    let maxValue = 1; // for x-axis scale
    $: maxValue = filteredData.length !== 0 ? filteredData[0].seasonal_average : 1;
    $: maxValue = maxValue < 1 ? 1 : maxValue;

    function generateXaxisIntervals(maxValue, interval) {
        let values = [];

        for (let i = 0; i <= Math.ceil(maxValue / interval); i++) {
            values.push(i * interval);
        }
        return values;
    } 

    let xAxisIntervals = [];
    $: if (maxValue < 2) {
        xAxisIntervals = generateXaxisIntervals(maxValue, 0.2)
    }
    else 
        {xAxisIntervals = generateXaxisIntervals(maxValue, 0.5)
    } ;

    $: xAxisIntervalSpacing = (chartWidth - 50) / (xAxisIntervals.length - 1);


</script>




<Header/>

<main>

    <div class="text">

        <h1>
            Downtown Recovery Rankings
        </h1>
        <p>
            The recovery metrics on these charts are based on a sample of mobile phone data. 
        </p>
        <p>    
            They are computed by counting the number of unique mobile phones in a city's downtown area in the specified time period, and then dividing it by the number of unique visitors during the equivalent time period in 2019. For example, the March 2023 - May 2023 time period is compared to the March 2019 - May 2019 time period. 
        </p>
        <p>
            A recovery metric greater than 100% means that for the selected inputs, the mobile device activity increased relative to the comparison period. A value less than 100% means the opposite, that the city's downtown has not recovered to pre-COVID activity levels.
        </p>
        <p>
            For more information, read our <a href="/methodology">Methodology</a> page. Or click <a href="/ranking_data.csv">here</a> to download the data shown on this chart.
        </p>

    </div>

    <div id="chart-wrapper" bind:offsetWidth={chartWidth}>
        
        <div id="options">
            <div id="options-season">
                <SelectSeason/>
            </div>
            <div id="options-region">
                <SelectRegions europe={"yes"}/>
            </div>
            <p id="note">*Data for Europe is only available from 12/2021 to 02/2023</p>
        </div>

        <svg height={chartHeight} width={chartWidth} id="chart">

            {#each xAxisIntervals as xInterval, i}

                <line class="grid"
                    x1 = {29 + i * xAxisIntervalSpacing}
                    y1 = 34
                    x2 = {29 + i * xAxisIntervalSpacing}
                    y2 = {chartHeight}
                ></line>

                <line class="grid-white"
                    x1 = {29 + i * xAxisIntervalSpacing}
                    y1 = 34
                    x2 = {29 + i * xAxisIntervalSpacing}
                    y2 = 38
                ></line>

                <text class="axis-label"
                    x = {35 + i * xAxisIntervalSpacing}
                    y = 30
                    text-anchor="end"
                >{(100 * xInterval).toFixed(0)}%</text>

            {/each}

            {#each filteredData as d, i}

                {#if regionColours.find(region => region.name === d.region).text === "#000"}
                    <text class="bar-label"
                    x = 32
                    y = {56 + i * 24}
                    style = "
                        fill: #000;
                        fill-opacity: 0;
                        stroke: white;
                        stroke-width: 3px;
                        stroke-opacity: 0.62;
                    "
                    >{d.display_title} - {Math.round(100 * d.seasonal_average)}%</text>
                {/if}

                <line class="bar"
                    x1 = {29}
                    y1 = {52 + i * 24}
                    x2 = {29 + ((chartWidth - 50) * d.seasonal_average / Math.max(... xAxisIntervals))}
                    y2 = {52 + i * 24}
                    style = "
                        stroke: white;
                        stroke-width: 20
                    "
                ></line>

                <line class="bar"
                    x1 = {30}
                    y1 = {52 + i * 24}
                    x2 = {29 + ((chartWidth - 50) * d.seasonal_average / Math.max(... xAxisIntervals)) - 1}
                    y2 = {52 + i * 24}
                    style = "
                        stroke: {regionColours.find(region => region.name === d.region).colour};
                        stroke-width: 18
                    "
                ></line>

                <text class="axis-label"
                    x = 25
                    y = {57 + i * 24}
                    text-anchor="end"
                >{i + 1}</text>

                
                
                <text class="bar-label"
                    x = 32
                    y = {56 + i * 24}
                    style = "
                        fill: {regionColours.find(region => region.name === d.region).text};
                    "
                >{d.display_title} - {Math.round(100 * d.seasonal_average)}%</text>

            {/each}

            {#each xAxisIntervals as xInterval, i}

                <line class="grid"
                    x1 = {29 + i * xAxisIntervalSpacing}
                    y1 = 34
                    x2 = {29 + i * xAxisIntervalSpacing}
                    y2 = {chartHeight}
                    stroke-opacity="0.21"
                ></line>

                {#if xInterval === 1}

                    <line class="grid-white"
                        x1 = {29 + i * xAxisIntervalSpacing}
                        y1 = 34
                        x2 = {29 + i * xAxisIntervalSpacing}
                        y2 = {chartHeight}
                        stroke-opacity=0.75
                        stroke-dasharray="2 2"
                    ></line>

                {/if}

            {/each}

        </svg>

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
        max-width: 1080px;
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
        font-size: 15px;
        text-align: right;
    }

    #chart {
        margin-top: 10px;
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

</style>
