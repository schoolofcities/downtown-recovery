<script>
    import Header from "../../../lib/Header.svelte";
    import SelectCities from "../../../lib/SelectCities.svelte";
    import Tick from "../../../lib/Tick.svelte";
    import { onMount } from "svelte";
    import { csvParse } from "d3-dsv";
    import {
        line,
        curveNatural,
        scaleLinear,
        timeParse,
        extent,
        scaleTime,
        group,
        rollup,
    } from "d3";

    import { selectedCities, cities, regions } from "../../../lib/stores.js";

    import "../../../assets/global.css";

    // initial loading data and dynamic filtering

    let data = [];
    let filteredData = [];

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
            data = csvParse(csvData);
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
                .filter((item) => item.metric === "downtown")
                .filter((item) => $selectedCities.includes(item.display_title))
                .sort((a, b) => a.week - b.week),
            (d) => d.display_title
        )
    ).map((g) => g[1]);

    // chart parameters

    let chartWidth;
    let chartHeight = 460;
    const paddings = {
        top: 10,
        left: 10,
        right: 10,
        bottom: 10,
    };
    let margin = { top: 10, bottom: 10, left: 10, right: 10 };
    let xScale;
    let xGrid;
    let yScale;
    let yGrid;

    function getXExtent(dat) {
        return extent(dat.map((d) => d.week));
    }

    function getYExtent(dat) {
        return extent(dat, (d) => d.rolling_avg);
    }

    function getXTicks(dat) {
        let uniqueWeeks = [];
        dat.forEach((d) => {
            if (!uniqueWeeks.includes(d.week)) {
                uniqueWeeks.push(d.week);
            }
        });

        let xTicks = [];
        uniqueWeeks.forEach((d) => {
            if (d.getMonth() % 5 == 0) {
                xTicks.push(d);
            }
        });

        return xTicks;
    }

    // tooltip debugging
    $: console.log();
    // scales
    $: xScale = scaleTime()
        .domain(getXExtent(filteredData.flat()))
        .range([margin.left, chartWidth - margin.right]);
    $: yScale = scaleLinear()
        .domain(getYExtent(filteredData.flat()))
        .range([chartHeight - margin.bottom, margin.top])
        .nice(5);

    let xTickNumber;
    // ticks for X axis- every six months (?)
    $: xTickNumber = chartWidth > 480 ? 12 : 5;
    $: xGrid = xScale.ticks(xTickNumber);
    // y gets evenly spaced ticks of some fixed constant number
    $: yGrid = yScale.ticks(5);

    // x axis labels string formatting
    function getXLabel(x) {
        let xLabel =
            monthNames[x.getMonth()] +
            " 20" +
            x.getYear().toString().substring(x.getYear(), 1);
        return xLabel;
    }

    // y ticks count to label by 'nice' increments
    let yTicks = [];
    for (let i = 0; i < 1.5; i = i + 0.25) {
        yTicks.push(Math.floor(i / 0.25) * 0.25);
    }
    // d's for axis paths
    let xPath = `M${margin.left + 0.5},6V0H${chartWidth - margin.right + 1}V6`;
    let yPath = `M-6,${chartHeight + 0.5}H0.5V0.5H-6`;

 

  let mousePosition = { x: null, y: null }
  function followMouse(event) {
    const svg = document.getElementById('chart')
    if (svg === null) return
    const dim = svg.getBoundingClientRect()
    const positionInSVG = { x: event.clientX - dim.left, y: event.clientY - dim.top }
    mousePosition = positionInSVG.x > paddings.left &&
    positionInSVG.x < chartWidth - paddings.right &&
    positionInSVG.y > paddings.top &&
    positionInSVG.y < chartHeight - paddings.bottom
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
    <div id="title">
        <h1>Downtown Recovery Patterns</h1>
        <p>Some very simple intro to the data/charts</p>
        <p>
            A recovery value greater than 100% means that for the selected
            inputs, the mobile device activity improved from the comparison
            period. A value less than 100% means the opposite, and a value equal
            to 100% means the activity did not change.
        </p>
    </div>

    <div id="chart-wrapper" bind:clientWidth={chartWidth}>
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
            height={chartHeight}
            width={chartWidth}
            id="chart"
            transform="translate({margin.left}, {margin.top})"
            on:mousemove={followMouse}
            on:mouseleave={removePointer}
        >
            <!-- create axes -->

            <g>
                <line
                    x1={margin.left}
                    x2={chartWidth - margin.right}
                    y1={chartHeight - margin.bottom}
                    y2={chartHeight - margin.bottom}
                    stroke="white"
                    stroke-width="1"
                />
            </g>
            <g>
                <line
                    x1={margin.left}
                    x2={margin.left}
                    y1={margin.top}
                    y2={chartHeight - margin.bottom}
                    stroke="white"
                    stroke-width="1"
                />
            </g>

            <!-- axis ticks -->
            <g>
                {#each yGrid.slice(1) as gridLine}
                    <Tick
                        x={paddings.left}
                        y={yScale(gridLine)}
                        value={gridLine}
                        direction={"horizontal"}
                    />
                {/each}
            </g>
            <g>
                {#each xGrid as gridLine}
                    <Tick
                        x={xScale(gridLine)}
                        y={chartHeight - paddings.bottom}
                        value={gridLine}
                        direction={"vertical"}
                        format={false}
                    />
                {/each}
            </g>

            {#each filteredData as d, i}
                <g>
                    <!-- draw line 
                    xScale will respond to changes in chart width
                -->

                    {#if cityColours}
                        <path
                            d={line()
                                .x((d1) => xScale(d1.week))
                                .y((d1) => yScale(d1.rolling_avg))
                                .curve(curveNatural)(d.flat())}
                            stroke-width="2"
                            stroke={cityColours.find(
                                (region) =>
                                    region.name ===
                                    cities.filter(
                                        (item) =>
                                            item.display_title ===
                                            d[0].display_title
                                    )[0].region
                            ).colour}
                            fill="transparent"
                            on:click={() => {
                                console.log(
                                    cities.filter(
                                        (item) =>
                                            item.display_title ===
                                            d[0].display_title
                                    )[0].display_title
                                );
                            }}
                        />
                    {/if}

                    {#if mousePosition.x !== null}
<g
  transform=
    "translate({xScale(computeSelectedXValue(d, mousePosition.x))} 0)"
>
  <line
    x1="0"
    x2="0"
    y1={margin.top}
    y2={chartHeight - margin.bottom - 2}
    stroke="black"
    stroke-width="1"
  />
 
    <circle
      cx={0}
      cy={yScale(
         d.find(
           (d1) => d1.week === computeSelectedXValue(d, mousePosition.x)
           ).rolling_avg
         )}
      r="3"
      fill={cityColours.find(
        (region) =>
            region.name ===
            cities.filter(
                (item) =>
                    item.display_title ===
                    d[0].display_title
            )[0].region
    ).colour}
    />
</g>
{/if}
                </g>
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

    #options-cities {
        overflow: auto;
        z-index: 1000;
    }

    #chart {
        margin-top: 10px;
        margin-bottom: 10px;
        background-color: var(--brandGray90);
    }
</style>
