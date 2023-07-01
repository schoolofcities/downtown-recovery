<script>
    import Header from "../../../lib/Header.svelte";
    import SelectCities from "../../../lib/SelectCities.svelte";
    import Tick from "../../../lib/Tick.svelte";
    import Tooltip from "../../../lib/Tooltip.svelte"
    import { onMount } from "svelte";
    import { csvParse } from "d3-dsv";
    import {
        line,
        curveNatural,
        scaleLinear,
        scaleOrdinal,
        timeParse,
        extent,
        scaleTime,
        group
    } from "d3";

    import { selectedCities, cities, regions } from "../../../lib/stores.js";

    import "../../../assets/global.css";

    // initial loading data and dynamic filtering

    let data = [];
    let filteredData = [];
    let dateOptions = { year: 'numeric', month: 'long', day: 'numeric' };
    let colourScale = [];
    let weeklyRank = [];

cities.forEach((j1) => {
  $regions.forEach((j2) => {
    if (j1.region === j2.name) {
        colourScale[j1.display_title] = {'colour' : j2.colour, 'text' : j2.text};
    }
  });
});


    const cityColours = $regions;
    const monthNames = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
    ];

    async function loadData() {
        try {
            const response = await fetch("../pattern_data.csv");
            const csvData = await response.text();
            data = csvParse(csvData)
                    .filter((item) => !['Dallas, TX', 'Orlando, FL', 'Oklahoma City, OK'].includes(item.display_title));
            data.forEach((d) => {
                d.week = timeParse("%Y-%m-%d")(d.week);
                d.week = new Date(d.week);
            });
        } catch (error) {
            console.error("Error loading CSV data:", error);
        }
    }

    onMount(() => {
        loadData();
    });

    $: filteredData = Array.from(
        group(
            data
                .filter((item) => 
                item.metric === "downtown" &&
                $selectedCities.includes(item.display_title))
                .sort((a, b) => a.week - b.week),
            (d) => d.display_title
        )
    ).map((g) => g[1]);

    // chart parameters
    let margin = { top: 10, bottom: 40, left: 10, right: 30 };
    let chartWidth;
    let chartHeight = 640;
    $: chartHeight = chartWidth * 0.666;
    

      // y-axis

    let maxRecoveryValue = 1; // for y-axis scale
    $: maxRecoveryValue = filteredData.length !== 0 ? filteredData.flat().sort((a,b) => b.rolling_avg - a.rolling_avg)[0].rolling_avg : 1;
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

    $: yAxisIntervalSpacing = (chartHeight - margin.bottom) / (yAxisIntervals.length - 1);

    $: yAxisRange = [Math.min(...yAxisIntervals), Math.max(...yAxisIntervals)];

    $: console.log(yAxisRange);
    let xScale;
    let xGrid;

    function getXExtent(dat) {
        return extent(dat.map((d) => d.week));
    }

    // scales
    $: xScale = scaleTime()
        .domain(getXExtent(filteredData.flat()))
        .range([margin.left + 40, chartWidth - margin.right]);

    function yScale(axisRange, axisHeight, yValue) {
        return axisHeight - axisHeight * yValue / (axisRange[1] - axisRange[0])
    }

    let xTickNumber;
    // ticks for X axis- every six months (?)
    $: xTickNumber = chartWidth > 480 ? 12 : 5;
    $: xGrid = xScale.ticks(xTickNumber);


    // x axis labels string formatting

    function getXLabel(x) {
       
        let xLabel =
            monthNames[x.getMonth()] + '\n' +
            '20' +
            x.getYear().toString().substring(x.getYear(), 1);
    
        return xLabel;
    }



  let mousePosition = { x: null, y: null }

  function followMouse(event) {
    const svg = document.getElementById('chart')
    if (svg === null) return
    const dim = svg.getBoundingClientRect()
    const positionInSVG = { x: event.clientX - dim.left, y: event.clientY - dim.top }
    mousePosition = positionInSVG.x > margin.left &&
    positionInSVG.x < chartWidth - margin.right &&
    positionInSVG.y > margin.top &&
    positionInSVG.y < chartHeight - margin.bottom
      ? { x: positionInSVG.x, y: positionInSVG.y }
      : { x: null, y: null }
}

function removePointer() {
  mousePosition = { x: null, y: null }
}

function computeSelectedXValue(dat, value) {
  return dat.filter((d) => xScale(d.week) >= value)[0].week
}

</script>


<Header />

<main>
    <div class="text">
        <h1>Downtown Recovery Patterns</h1>
        <p>Some very simple intro to the data/charts</p>
        <p>
            A recovery value greater than 100% means that for the selected
            inputs, the mobile device activity improved from the comparison
            period. A value less than 100% means the opposite, and a value equal
            to 100% means the activity did not change.
        </p>
    </div>

    <div id="chart-wrapper" bind:offsetWidth={chartWidth}>
        <div id="options">
            <div id="options-cities">
                <p>Select City:</p>
                <SelectCities
                    id="options-cities"
                    value={[
                        "Montréal, QC",
                        "Toronto, ON",
                        "Chicago, IL",
                        "Detroit, MI",
                        "Baltimore, MD",
                        "New York, NY",
                        "Los Angeles, CA",
                        "San Francisco, CA",
                        "Atlanta, GA",
                        "Miami, FL",
                        "Austin, TX",
                        "Las Vegas, NV",
                    ]}
                >
                    {#each cities as city_obj}
                        <option value={city_obj.display_title}
                            >{city_obj.display_title}</option
                        >
                    {/each}
                </SelectCities>
            </div>
        </div>

        <svg
            height={chartHeight + 40}
            width={chartWidth}
            id="chart"
            transform="translate({margin.left}, {margin.top})"
            on:mousemove={followMouse}
            on:mouseleave={removePointer}
        >
            <!-- create axes -->
                    <!-- y-axis ticks -->
        {#each yAxisIntervals.reverse() as yInterval, i}

                   <line class="grid"
                        x1 = {40}
                        y1 = {margin.bottom + i * yAxisIntervalSpacing}
                        x2 = {chartWidth - margin.right}
                        y2 = {margin.bottom + i * yAxisIntervalSpacing}
                    ></line>
        
                    <text class="axis-label"
                        x = {margin.left + 25}
                        y = {margin.bottom + i * yAxisIntervalSpacing}
                        text-anchor="end"
                    >{(100 * yInterval).toFixed(0)}%</text>
        
                    <line class="grid-white"
                        x1 = 37
                        y1 = {margin.bottom + i * yAxisIntervalSpacing}
                        x2 = 45
                        y2 = {margin.bottom + i * yAxisIntervalSpacing}
                    ></line>
        
                {/each}

            
                <line
                    x1={margin.left + 40}
                    x2={chartWidth - margin.right}
                    y1={chartHeight}
                    y2={chartHeight}
                    stroke="white"
                    stroke-width="1"
                />
                <line
                    x1={margin.left + 40}
                    x2={margin.left + 40}
                    y1={margin.top}
                    y2={chartHeight}
                    stroke="white"
                    stroke-width="1"
                />
            

            <!-- x axis ticks -->
         
            
                {#each xGrid as gridLine}
                    <Tick
                        x={xScale(gridLine)}
                        y={chartHeight}
                        value={gridLine}
                        direction={"vertical"}
                        format={false}
                        formatFunction={getXLabel}
                    />
                {/each}
            
            {#each filteredData as d, i}
                
                    <!-- draw line 
                    xScale will respond to changes in chart width
                -->

                    {#if cityColours}
                        <path
                            d={line()
                                .x((d1) => xScale(d1.week))
                                .y((d1) => yScale(
                        yAxisRange,
                        chartHeight,
                        d1.rolling_avg
                    ) + margin.bottom)
                                .curve(curveNatural)(d.flat())}
                            stroke-width="2"
                            stroke={colourScale[d[0].display_title].colour}
                            fill="transparent"
                        />
                    {/if}
                  

                    {#if mousePosition.x !== null}
<g
  transform=
    "translate({xScale(computeSelectedXValue(d, mousePosition.x))} 0)"
>
  <!--<line
    x1="0"
    x2="0"
    y1={margin.top}
    y2={chartHeight - margin.bottom - 2}
    stroke="black"
    stroke-width="1"
  />-->
 
    <circle
      cx={0}
      cy={yScale(
        yAxisRange,
        chartHeight,
         d.find(
           (d1) => d1.week === computeSelectedXValue(d, mousePosition.x)
           ).rolling_avg
         ) + margin.bottom}
      r="3"
      fill={colourScale[d[0].display_title].colour}
    />
</g>


<Tooltip
      labels={d[0].display_title}
      values={Math.floor(d.find(
        (d1) => d1.week === computeSelectedXValue(d, mousePosition.x)
        ).rolling_avg * 100)}%
      
      x={mousePosition.x + 180 > chartWidth
        ? mousePosition.x - 195
        : mousePosition.x + 15}
      y={yScale(
        yAxisRange,
        chartHeight,
        d.find(
        (d1) => d1.week === computeSelectedXValue(d, mousePosition.x)
        ).rolling_avg) + margin.bottom
        }
      backgroundColor={colourScale[d[0].display_title].colour}
      opacity="0.5"
      textColor={colourScale[d[0].display_title].text}
      title={undefined}
      width="180"
      adaptTexts={false}
    />

    <Tooltip
      labels="Week of"
      values={computeSelectedXValue(data, mousePosition.x).toLocaleString(undefined, dateOptions)
        }
      title={undefined}
      x={mousePosition.x + 180 > chartWidth
        ? mousePosition.x - 195
        : mousePosition.x + 15}
      y={chartHeight - 30}
      backgroundColor="white"
      opacity="0.5"
      textColor="black"
     
      width="200"
      adaptTexts={false}
    />

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
        max-width: 840px;
    }

    #options {
        margin: 0 auto;
        max-width: 650px;
    }

    
    #options-cities {
        overflow: auto;
        
    }
    
    #note {
        color: var(--brandGray);
        font-size: 13px;
        text-align: right;
    }

    #title {
        margin: 0 auto;
        max-width: 650px;
        color: white;
        border-bottom: solid 1px var(--brandDarkBlue);
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

    h1 {
        font-family: TradeGothicBold;
        font-size: 30px;
        color: var(--brandWhite);
        text-decoration: underline;
    }

 

  



 
</style>
