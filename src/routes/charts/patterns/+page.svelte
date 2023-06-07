<script>

    import Header from "../../../lib/Header.svelte";
    import SelectCities from "../../../lib/SelectCities.svelte";



    import { onMount } from 'svelte';
    import { csvParse } from 'd3-dsv';

    import {selectedCities, cities } from '../../../lib/stores.js';

    import "../../../assets/global.css";


    // initial loading data and dynamic filtering

    let data = [];
    let filteredData = [];



    async function loadData() {
        try {
            const response = await fetch('../pattern_data.csv');
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
        .filter(item => selectedCities.includes(item.display_title))
        .sort((a, b) => b.rolling_avg - a.rolling_avg);

    $: console.log(filteredData);

    // chart parameters

    let chartWidth;
    let chartHeight = 100;
    $: chartHeight = 20 * filteredData.length + 50;

    let maxValue = 1; // for x-axis scale
    $: maxValue = filteredData.length !== 0 ? filteredData[0].rolling_avg : 1;
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

    $: xAxisIntervalSpacing = (chartWidth - 40) / (xAxisIntervals.length - 1);


</script>




<Header/>

<main>

    <div id="title">

        <h1>
            Downtown Recovery Patterns
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
                <p>Select City:</p>
                <SelectCities id='options-cities' value={selectedCities}>
                    {#each cities as city}
                    <option value={city.display_title}>{city.display_title}</option>
                    {/each}
                </SelectCities>
          
          
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

                <line class="bar"
                    x1 = {29}
                    y1 = {52 + i * 24}
                    x2 = {d.seasonal_average * (chartWidth - 29) / Math.max(... xAxisIntervals)}
                    y2 = {52 + i * 24}
                    style = "
                        stroke: white;
                        stroke-width: 20
                    "
                ></line>

          

                <text class="axis-label"
                    x = 25
                    y = {57 + i * 24}
                    text-anchor="end"
                >{i + 1}</text>

                

             

            {/each}

            {#each xAxisIntervals as xInterval, i}

                <line class="grid"
                    x1 = {29 + i * xAxisIntervalSpacing}
                    y1 = 34
                    x2 = {29 + i * xAxisIntervalSpacing}
                    y2 = {chartHeight}
                    stroke-opacity="0.32"
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

 

    #chart {
        margin-top: 10px;
        margin-bottom: 10px;
        background-color: var(--brandGray90);
    }




</style>
