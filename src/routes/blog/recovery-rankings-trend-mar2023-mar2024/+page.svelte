<script>
    import Header from "../../../lib/Header.svelte";
    import SelectRegions from "../../../lib/SelectRegions.svelte";
    import { onMount } from 'svelte';
    import { csvParse } from 'd3-dsv';
    import { scaleTime, scaleLinear, timeParse, line } from "d3";
    import { regressionLoess } from "d3-regression";

    import { regions, cities } from '../../../lib/stores.js';

    let data = [];
    let thecities = [];

    async function loadData() {
        try {
            const response = await fetch('../stopuplevelled_mar2023_mar2024_US_only.csv');
            const csvData = await response.text();
            data = csvParse(csvData);
            // data = csvParse(csvData, {
            //     header: true,
            //     transform: (value, header) => {
            //         if (header === "normalized_distinct_clean") {
            //             return parseFloat(value);
            //         }
            //         return value;
            //     }
            // });
            thecities = [...new Set(data.map(item => item.city))]; // Get unique city names
        } catch (error) {
            console.error('Error loading CSV data:', error);
        }
    }

    onMount(() => {
        loadData();
    });
    $: console.log(data)

    let chartWidth = 250;
    const chartHeight = 50;

    const marginTop = 20;
    const marginRight = 5;
    const marginBottom = 20;
    const marginLeft = 25;

    const parseDate = timeParse("%Y-%m-%d");

    let charts = []; // to hold chart data for each city
    

    function createCharts(data) {
        charts = thecities.map(city => {
            // figure out city's min and max 
            let min = Math.min(parseFloat(data.filter(item => item.city === city).normalized_distinct_clean));
            let max = Math.max(parseFloat(data.filter(item => item.city === city).normalized_distinct_clean));
            
            // // Filter data for March 2023
            // const march2023Data = data.filter(item => {
            //     const date = new Date(item.date);
            //     return date.getFullYear() === 2023 && date.getMonth() === 2; // for march
            // });

            // // Calculate sum for March 2023
            // let march2023 = 0;
            // march2023Data.forEach(item => {
            //     march2023 += parseFloat(item.normalized_distinct_clean);
            // });

            // console.log("Sum of normalized_distinct_clean column for March 2023:", march2023);


            const uniqueCities = [...new Set(data.map(item => item.city))]; // Get unique city names

            uniqueCities.forEach(city => {
                // Filter data for March 2023 for the current city
                const march2023City = data.filter(item => {
                    const date = new Date(item.date);
                    return date.getFullYear() === 2023 && date.getMonth() === 2 && item.city === city;
                });

                // Calculate sum for March 2023 for the current city
                let march2023 = 0;
                march2023City.forEach(item => {
                    march2023 += parseFloat(item.normalized_distinct_clean);
                });

                console.log(`Sum of normalized_distinct_clean column for March 2023 in ${city}:`, march2023);
                
                // Filter data for Feb 2024 for the current city
                const feb2024City = data.filter(item => {
                    const date = new Date(item.date);
                    return date.getFullYear() === 2024 && date.getMonth() === 1 && item.city === city;
                });
                // Calculate sum for Feb 2024 for the current city
                let feb2024 = 0;
                feb2024City.forEach(item => {
                    feb2024 += parseFloat(item.normalized_distinct_clean);
                });

                console.log(`Sum of normalized_distinct_clean column for March 2024 in ${city}:`, feb2024);
            });

            // let march2023 = parseFloat(data.find(item => item.date === "2023-03-01")?.normalized_distinct_clean);
            // let march2024 = parseFloat(data.find(item => item.date === "2024-03-01")?.normalized_distinct_clean);
            const cityData = data.filter(item => item.city === city);
            console.log(min)
            if (cityData.length > 0) {
                const xScale = scaleTime()
                    .domain([new Date("2023-03-01"), new Date("2024-03-01")])
                    .range([marginLeft, chartWidth - marginRight]);

                const yScale = scaleLinear()
                    .domain([0, 0.008])
                    // .domain([min, max])
                    .range([chartHeight - marginBottom, marginTop]);

                const regressionGenerator = regressionLoess()
                    .x((d) => parseDate(d.date))
                    .y((d) => parseFloat(d.normalized_distinct_clean))
                    .bandwidth(0.2);

                const lineGenerator = line()
                    .x(d => xScale(d[0]))
                    .y(d => yScale(d[1]));

                const regressionLine = lineGenerator(regressionGenerator(cityData));

                // const percentageChange = (((feb2024-march2023)/march2023)*100);
                // const perChangeDisplay = percentageChange + "%";

                // const circles = cityData.map(item => ({
                //     cx: xScale(parseDate(item.date)),
                //     cy: yScale(parseFloat(item.normalized_distinct_clean)),
                //     r: 2,
                //     fill: "#914137"
                // }));

                // Start circle
                const startPoint = cityData.find(item => item.date === "2023-03-01")?.normalized_distinct_clean || 0;
                const startCircle = {
                    cx: 29 + ((chartWidth - 50) * startPoint),
                    cy: 52,
                    radius: 6,
                    fill: "black",
                    stroke: "#6aa687",
                    "stroke-width": 2
                };

                // End circle
                const endPoint = cityData.find(item => item.date === "2024-03-01")?.normalized_distinct_clean || 0;
                const endCircle = {
                    cx: 29 + ((chartWidth - 50) * endPoint),
                    cy: 52,
                    radius: 6,
                    fill: "black",
                    stroke: "#6aa687",
                    "stroke-width": 2
                };

                return {
                    city: city,
                    regressionLine: regressionLine,
                    // circles: circles,
                    startCircle: startCircle,
                    endCircle: endCircle,
                    // perChangeDisplay: perChangeDisplay
                };
            }
        });
    }

    $: {
        createCharts(data);
    }
</script>

<Header />
<main>
    {#each charts as { city, regressionLine, circles, startCircle, endCircle } }
        <div class="chart-wrapper">
            <h3>{city}</h3>
            <svg height={chartHeight} width={chartWidth} class="chart">

                <path d={regressionLine} stroke="#ffffff" stroke-width="2" fill="none" />
                <!-- {#each circles as circle }
                    <circle {...circle} />
                {/each} -->
                <circle {...startCircle} class="start-circle" />
                <circle {...endCircle} class="end-circle" />
            </svg>
        </div>
    {/each}
</main>

<style>
    .chart-wrapper {
        margin-bottom: 5px;
        background-color: black;
    }
    .chart {
        background-color: black;
    }
    h3{
        font-size: 18px;
    }
</style>
