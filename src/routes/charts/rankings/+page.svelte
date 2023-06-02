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

    $: console.log(filteredData);


    // chart parameters

    let chartWidth;
    let chartHeight = 100;
    $: chartHeight = 20 * filteredData.length + 50;

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
    $: xAxisIntervals = generateXaxisIntervals(maxValue, 0.2);

    $: xAxisIntervalSpacing = (chartWidth - 40) / (xAxisIntervals.length - 1);


</script>




<Header/>

<main>

    <div id="title">

        <h1>
            Downtown Recovery Rankings
        </h1>
        <p>
            Some very simple intro to the data/charts
        </p>
        <p>
            A recovery value greater than 100% means that for the selected inputs, the mobile device activity improved from the comparison period. A value less than 100% means the opposite, and a value equal to 100% means the activity did not change.
        </p>

    </div>

    <div id="chart-wrapper" bind:offsetWidth={chartWidth}>
        
        <div id="options">
            <div id="options-season">
                <SelectSeason/>
            </div>
            <div id="options-region">
                <SelectRegions/>
            </div>
        </div>

        <svg height={chartHeight} width={chartWidth} id="chart">
            
            <!-- <line class="grid"
                x1 = 29
                y1 = 40
                x2 = {chartWidth}
                y2 = 40
            ></line> -->

            {#each xAxisIntervals as xInterval, i}

                <line class="grid"
                    x1 = {29 + i * xAxisIntervalSpacing}
                    y1 = 34
                    x2 = {29 + i * xAxisIntervalSpacing}
                    y2 = {chartHeight}
                ></line>

                <text class="axis-label"
                    x = {25 + i * xAxisIntervalSpacing}
                    y = 30
                >{(100 * xInterval).toFixed(0)}%</text>

            {/each}

            {#each filteredData as d, i}

                <line class="bar"
                    x1 = {29}
                    y1 = {52 + i * 20}
                    x2 = {d.seasonal_average * (chartWidth - 29) / Math.max(... xAxisIntervals)}
                    y2 = {52 + i * 20}
                    style = "
                        stroke: white;
                        stroke-width: 17
                    "
                ></line>

                <line class="bar"
                    x1 = {30}
                    y1 = {52 + i * 20}
                    x2 = {d.seasonal_average * (chartWidth - 29) / Math.max(... xAxisIntervals) - 1}
                    y2 = {52 + i * 20}
                    style = "
                        stroke: {regionColours.find(region => region.name === d.region).colour};
                        stroke-width: 15
                    "
                ></line>

                <text class="axis-label"
                    x = 25
                    y = {57 + i * 20}
                    text-anchor="end"
                >{i + 1}</text>

                <text class="bar-label"
                    x = 32
                    y = {56 + i * 20}
                    style = "
                        fill: {regionColours.find(region => region.name === d.region).text};
                    "
                >{d.display_title}</text>

            {/each}

            {#each xAxisIntervals as xInterval, i}

                <line class="grid"
                    x1 = {29 + i * xAxisIntervalSpacing}
                    y1 = 34
                    x2 = {29 + i * xAxisIntervalSpacing}
                    y2 = {chartHeight}
                    stroke="#fff"
                    stroke-opacity="0.42"
                ></line>

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

    #title {
        margin: 0 auto;
        max-width: 650px;
        color: white;
        border-bottom: solid 1px var(--brandDarkBlue);
    }

    h1 {
        font-family: TradeGothicBold;
		font-size: 30px;
        color: var(--brandWhite);
        text-decoration: underline;
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

    #chart {
        margin-top: 10px;
        margin-bottom: 10px;
        background-color: var(--brandGray90);
    }

    .grid {
        stroke: var(--brandGray70);
        stroke-width: 1px;
    }

    .axis-label {
        fill: var(--brandGray);
        font-size: 14px;
    }

    .bar-label {
        /* fill: var(--brandWhite); */
        font-size: 11px;
    }

</style>
