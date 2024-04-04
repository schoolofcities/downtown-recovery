<script>
    import Header from "../../../lib/Header.svelte";
    import SelectRegions from "../../../lib/SelectRegions.svelte";
    import { onMount } from 'svelte';
    import { csvParse } from 'd3-dsv';
    import { scaleTime, scaleLinear, timeParse, line} from "d3";
    import { regressionLoess } from "d3-regression";
    import { min, max, mean} from 'd3-array';

    import { regions, cities } from '../../../lib/stores.js';
    const regionColours = $regions;

    import upArrow from '/src/assets/green-arrow.svg';
    import downArrow from '/src/assets/red-arrow.svg';
    // import upArrow from '/src/assets/green-arrow-circle.svg';
    // import downArrow from '/src/assets/red-arrow-circle.svg';

    async function loadData() {
        try {
            const response = await fetch('../stopuplevelled_mar2023_mar2024.csv');
            const csvData = await response.text();
            data = csvParse(csvData);
            thecities = [...new Set(data.map(item => item.city))];
        } catch (error) {
            console.error('Error loading CSV data:', error);
        }
    }

    let data = [];

    onMount(() => {
        loadData();
    });
    $: console.log(data)

    let chartWidth = 250;
    const chartHeight = 60;

    const marginTop = 0;
    const marginRight = 5;
    const marginBottom = 0;
    const marginLeft = 5;

    const parseDate = timeParse("%Y-%m-%d");

    let thecities = [];
    let charts = []; // to hold chart data for each city
    let sortedCharts = []; // to hold the sorted charts

    function createCharts(data) {
        charts = thecities.map(city => {
            const cityData = data.filter(item => item.city === city);
            if (cityData.length > 0) {
                const normalizedDistinctCleanValues = cityData.map(item => parseFloat(item.normalized_distinct_clean));

                // Calculate min and max for the current city
                const cityMin = min(normalizedDistinctCleanValues);
                const cityMax = max(normalizedDistinctCleanValues);

                // Filter data for March 2023 for the current city
                const march2023City = data.filter(item => {
                    const date = new Date(item.date);
                    return date.getFullYear() === 2023 && date.getMonth() === 2 && item.city === city;
                });

                // Calculate mean for March 2023 for the current city
                const march2023 = mean(march2023City, d => parseFloat(d.normalized_distinct_clean));
                
                // Filter data for Feb 2024 for the current city
                const feb2024City = data.filter(item => {
                    const date = new Date(item.date);
                    return date.getFullYear() === 2024 && date.getMonth() === 1 && item.city === city;
                });

                // Calculate mean for Feb 2024 for the current city
                const feb2024 = mean(feb2024City, d => parseFloat(d.normalized_distinct_clean));
    
                const xScale = scaleTime()
                    .domain([new Date("2023-03-01"), new Date("2024-03-01")])
                    .range([marginLeft, chartWidth - marginRight]);

                const yScale = scaleLinear()
                    .domain([cityMin, cityMax])
                    .range([chartHeight - marginBottom, marginTop]);

                const regressionGenerator = regressionLoess()
                    .x((d) => parseDate(d.date))
                    .y((d) => parseFloat(d.normalized_distinct_clean))
                    .bandwidth(0.05);

                const lineGenerator = line()
                    .x(d => xScale(d[0]))
                    .y(d => yScale(d[1]));

                const regressionLine = lineGenerator(regressionGenerator(cityData));

                const percentageChange = (((feb2024-march2023)/march2023)*100);
                const perChangeDisplay = percentageChange.toFixed(1) + "%";

                // Start circle
                const startPoint = regressionGenerator(cityData)[0];
                const startCircle = {
                    cx: xScale(startPoint[0]),
                    cy: yScale(startPoint[1]), 
                    radius: 6,
                    fill: "red",
                    stroke: "red",
                    "stroke-width": 2
                };

                // End circle
                const endPoint = regressionGenerator(cityData)[366]; // total length = 367
                const endCircle = {
                    cx: xScale(endPoint[0]), 
                    cy: yScale(endPoint[1]),
                    radius: 6,
                    fill: "red",
                    stroke: "#6aa687",
                    "stroke-width": 2
                };

                const meanLine = yScale(march2023);

                return {
                    city: city,
                    regressionLine: regressionLine,
                    meanLine: meanLine,
                    startCircle: startCircle,
                    endCircle: endCircle,
                    perChangeDisplay: perChangeDisplay,
                    percentageChange: percentageChange,
                };
            }
        });

        // Sort charts based on percentageChange descending order
        sortedCharts = charts.slice().sort((a,b) => b.percentageChange - a.percentageChange);
    }

    // Get the region colour for each city
    function getRegionColor(city) {
        const cityData = cities.filter(item => item.city === city);
        if (cityData) {
            const regionName = cityData[0].region;
            const regionData = regionColours.find(region => region.name === regionName);
            if (regionData) {
                return regionData.colour;
            }
        }       
        else {
            return 'white'
        };
    }

    $: {
        createCharts(data);
    }
</script>

<Header />

<main>
    <div class="text">

		<h3>
			Blog Title
		</h3>
		<p>
			<a href="https://">Author</a>, <a href="https://">Author</a>, & <a href="https://">Author</a>,| April, 2024
		</p>
		<p>
            Some texts
		</p>
		<p>
            more texts.
		</p>

	</div>

    {#each sortedCharts as { city, regressionLine, startCircle, endCircle, meanLine, perChangeDisplay, percentageChange}}
        <div class="chart-wrapper">
                <svg width="10" height="20" class="region-bar">
                    <line x1="1" y1="0" x2="1" y2="18" stroke={getRegionColor(city)} stroke-width= "10"/>
                </svg>
                <h4>{city}</h4>
                <h5>{perChangeDisplay}</h5>
                <div class="arrow-indicator">
                    {#if percentageChange > 0}
                        <img src={upArrow} alt="Up arrow" class="arrow-icon"/>
                    {:else if percentageChange < 0}
                        <img src={downArrow} alt="Down arrow" class="arrow-icon"/>
                    {/if}
                </div>
                <div class="chart-container">
                    <svg height={chartHeight} width={chartWidth} class="chart">

                    <!-- Top line -->
                    <line x1="0" y1="0" x2={chartWidth} y2="0" stroke="gray" stroke-width="1"/> 
                    <!-- Middle line -->
                    <line x1="0" y1={meanLine} x2={chartWidth} y2={meanLine} stroke="gray" stroke-width="1" stroke-dasharray="4"/>
                    <!-- Bottom line -->
                    <line x1="0" y1={chartHeight} x2={chartWidth} y2={chartHeight} stroke="gray" stroke-width="1"/>
                    <!-- <path d={regressionLine} stroke={getRegionColor(city)} stroke-width="2" fill="none"/> -->
                    <path d={regressionLine} stroke="white" stroke-width="2" fill="none"/>
                    <!-- First point -->
                    <circle cx={startCircle.cx} cy={startCircle.cy} r="4.5" fill="#F1C500"/>
                    <!-- Last point -->
                    <circle cx={endCircle.cx} cy={endCircle.cy} r="4.5" fill="#AB1368" stroke="white" stroke-width="1.5"/>
                    
                    </svg>
            </div>
        </div>
    {/each}

    <div class="text">

		<p>
            paragraph...
        </p>
		<p>
            paragraph...		
        </p>
		<p style="text-align: center;">
			- - -
		</p>
		<p>
            concluding...
        </p>

	</div>
</main>

<style>
    .chart-wrapper {
        display: flex;
        justify-content: center;
        align-items: center;
        margin: 0 auto;
        padding-left: 10px;
        padding-right: 10px;
        margin-bottom: 10px;
        max-width: 760px;
        background-color: var(--brandGray90);
    }

    .chart-wrapper h4 {
        margin-right: 10px;
    }

    .chart-container {
    flex-grow: 1;
    }

    .region-bar{
        padding-left: 5px;
    }

    .chart {
        background-color: var(--brandGray90);
        margin-left: 10px;
    }
    @media (max-width: 490px) {
        .chart-wrapper {
            flex-direction: column; 
            align-items: center;
        }
        .chart-container {
            margin-top: 0;
        }
    }
    .arrow-icon{
		margin: auto 0;
		max-width: 40px;
		height: 40px;
		flex-grow: 1;
        align-items: center;
	}
    h4{
        font-family: TradeGothicBold;
        font-size: 16px;
        color: var(--brandWhite);
        padding-bottom: 5px;
        min-width: 103px;
        margin-left: 2px;
        margin-right: 2px;
        /* border-bottom: solid 2px var(--brandYellow); */
        /* text-decoration-line: underline;
        text-decoration-color: var(--brandDarkBlue);
        text-decoration-thickness: 5px;
        text-underline-offset: 5px; */
    }

    h5{
        font-size: 14px;
        min-width: 45px;
        margin-right: 5px;
        font-family: TradeGothicBold;
        color: var(--brandWhite);
        text-decoration: none;
        padding-bottom: 5px;
    }
</style>