<script>

    import Header from "../../../lib/Header.svelte";
    import SelectSeason from "../../../lib/SelectSeason.svelte";
    import SelectRegions from "../../../lib/SelectRegions.svelte";

    import { onMount } from 'svelte';
    import { csvParse } from 'd3-dsv';

    import { season, selectedRegions, regions } from '../../../lib/stores.js';

    import "../../../assets/global.css";

    const baseUrl = import.meta.env.BASE_URL;


    // initial loading data and dynamic filtering

    // let data = [];
    // let filteredData = [];

    // const regionColours = $regions;

    // async function loadData() {
    //     try {
    //         const response = await fetch('../ranking_data.csv');
    //         const csvData = await response.text();
    //         data = csvParse(csvData);
    //     } catch (error) {
    //         console.error('Error loading CSV data:', error);
    //     }
    // }

    // onMount(() => {
    //     loadData();
    // });

    // $: filteredData = data
    //     .filter(item => item.metric === 'downtown')
    //     .filter(item => item.Season === `Season_${$season}`)
    //     .filter(item => $selectedRegions.includes(item.region))
    //     .sort((a, b) => b.seasonal_average - a.seasonal_average);

    // $: console.log($selectedRegions);


    // // chart parameters

    let chartWidth;
    // let chartHeight = 100;
    // $: chartHeight = 24 * filteredData.length + 50;

    // let maxValue = 1; // for x-axis scale
    // $: maxValue = filteredData.length !== 0 ? filteredData[0].seasonal_average : 1;
    // $: maxValue = maxValue < 1 ? 1 : maxValue;

    // function generateXaxisIntervals(maxValue, interval) {
    //     let values = [];

    //     for (let i = 0; i <= Math.ceil(maxValue / interval); i++) {
    //         values.push(i * interval);
    //     }
    //     return values;
    // } 

    // let xAxisIntervals = [];
    // $: if (maxValue < 2) {
    //     xAxisIntervals = generateXaxisIntervals(maxValue, 0.2)
    // }
    // else 
    //     {xAxisIntervals = generateXaxisIntervals(maxValue, 0.5)
    // } ;

    // $: xAxisIntervalSpacing = (chartWidth - 40) / (xAxisIntervals.length - 1);


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
                <SelectRegions/>
            </div>
            <p id="note">*We have not yet collected explanatory variables for Europe yet</p>
        </div>

        <!-- <svg height={chartHeight} width={chartWidth} id="chart">

        </svg> -->

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
        font-size: 13px;
        text-align: right;
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
