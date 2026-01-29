<script>
  import Header from "../../../lib/Header.svelte";
  import SelectRegions from "../../../lib/SelectRegions.svelte";
  import { onMount } from "svelte";
  import { csvParse } from "d3-dsv";
  import { scaleTime, scaleLinear, timeParse, line } from "d3";
  import { regressionLoess } from "d3-regression";
  import { min, max, mean } from "d3-array";

  import { regions, selectedRegions, cities } from "../../../lib/stores.js";
  const regionColours = $regions;

  import upArrow from "../../../assets/green-arrow.svg";
  import downArrow from "../../../assets/red-arrow.svg";

  import "../../../assets/global.css";
  import { xlink_attr } from "svelte/internal";

  let selection = {
    monthName: "September",
    monthNumber: 9,
    year1: 2023,
    year2: 2024,
    year3: 2025,
    day1: "2023-09-01",
    day2: "2025-09-30",
    update_date: "2025-12-29", // change this to whenever website is updated
  };

  // Toggle between Overall and Breakdown view
  let viewMode = "overall"; // "overall" or "breakdown"
  const activityTypes = ["WORK", "HOME", "NEITHER"];
  const activityColors = {
    WORK: "#FF6B6B", // red
    HOME: "#4ECDC4", // teal
    NEITHER: "#FFE66D", // yellow
  };

  async function loadData() {
    try {
      const response = await fetch("/SONmonths.csv");
      const csvData = await response.text();
      data = csvParse(csvData);
      thecities = [...new Set(data.map((item) => item.city))];
    } catch (error) {
      console.error("Error loading CSV data:", error);
    }
  }

  let data = [];

  onMount(() => {
    loadData();
    filteredCities = cities
      .filter((item) => $selectedRegions.includes(item.region))
      .map((item) => item.city);
  });

  let width;

  let chartWidth = 500;
  const chartHeight = 80;

  const marginTop = 0;
  const marginRight = 5;
  const marginBottom = 0;
  const marginLeft = 5;

  const parseDate = timeParse("%m/%d/%Y");

  let thecities = [];
  let charts = []; // to hold chart data for each city
  let sortedCharts = []; // to hold the sorted charts

  $: filteredCities = cities
    .filter((item) => $selectedRegions.includes(item.region))
    .map((item) => item.city);

  // function createCharts(data) {

  // Helper function to generate chart data for a specific activity filter
  function generateChartForCity(city, activityFilter = null) {
    // ===== FILTER DATA BY YEAR (and optionally by activity) =====
    const filterByYearAndActivity = (item, year) => {
      const date = parseDate(item.date);
      const yearMatch =
        date && date.getFullYear() === year && item.city === city;
      if (activityFilter) {
        return yearMatch && item.ACTIVITY === activityFilter;
      }
      return yearMatch;
    };

    const cityData2023 = data.filter((item) =>
      filterByYearAndActivity(item, 2023),
    );
    const cityData2024 = data.filter((item) =>
      filterByYearAndActivity(item, 2024),
    );
    const cityData2025 = data.filter((item) =>
      filterByYearAndActivity(item, 2025),
    );

    if (
      cityData2023.length < 3 ||
      cityData2024.length < 3 ||
      cityData2025.length < 3
    ) {
      return undefined;
    }

    // ===== CALCULATE SEPTEMBER AVERAGES FOR 3 YEARS =====
    const sept2023avg = mean(cityData2023, (d) =>
      parseFloat(d.normalized_distinct_clean),
    );
    const sept2024avg = mean(cityData2024, (d) =>
      parseFloat(d.normalized_distinct_clean),
    );
    const sept2025avg = mean(cityData2025, (d) =>
      parseFloat(d.normalized_distinct_clean),
    );

    // ===== CALCULATE PERCENTAGE CHANGES =====
    const percentageChange2025vs2023 = sept2023avg
      ? ((sept2025avg - sept2023avg) / sept2023avg) * 100
      : 0;
    const percentageChange2025vs2024 = sept2024avg
      ? ((sept2025avg - sept2024avg) / sept2024avg) * 100
      : 0;

    // ===== REGRESSION FOR EACH YEAR =====
    const regressionGenerator = regressionLoess()
      .x((d) => parseDate(d.date).getDate())
      .y((d) => parseFloat(d.normalized_distinct_clean))
      .bandwidth(0.3);

    const regression2023 = regressionGenerator(cityData2023);
    const regression2024 = regressionGenerator(cityData2024);
    const regression2025 = regressionGenerator(cityData2025);

    if (
      !regression2023?.length ||
      !regression2024?.length ||
      !regression2025?.length
    ) {
      return undefined;
    }

    // ===== SCALES =====
    const allValues = [
      ...regression2023.map((d) => d[1]),
      ...regression2024.map((d) => d[1]),
      ...regression2025.map((d) => d[1]),
    ];

    const cityMin = Math.min(...allValues);
    const cityMax = Math.max(...allValues);
    const yRange = cityMax - cityMin;
    const yPadding = yRange * 0.5;

    const yScale = scaleLinear()
      .domain([cityMin - yPadding, cityMax + yPadding])
      .range([chartHeight - marginBottom, marginTop]);

    const yearWidth = chartWidth / 3;
    const dayScale = scaleLinear()
      .domain([1, 30])
      .range([0, yearWidth - 10]);

    // ===== CREATE LINE PATHS FOR EACH YEAR =====
    const lineGen2023 = line()
      .x((d) => 5 + dayScale(d[0]))
      .y((d) => yScale(d[1]));
    const lineGen2024 = line()
      .x((d) => yearWidth + 5 + dayScale(d[0]))
      .y((d) => yScale(d[1]));
    const lineGen2025 = line()
      .x((d) => 2 * yearWidth + 5 + dayScale(d[0]))
      .y((d) => yScale(d[1]));

    const regressionLine2023 = lineGen2023(regression2023);
    const regressionLine2024 = lineGen2024(regression2024);
    const regressionLine2025 = lineGen2025(regression2025);

    // ===== CIRCLES FOR START AND END POINTS =====
    const startCircle2023 = {
      cx: 5 + dayScale(regression2023[0][0]),
      cy: yScale(regression2023[0][1]),
    };
    const endCircle2023 = {
      cx: 5 + dayScale(regression2023[regression2023.length - 1][0]),
      cy: yScale(regression2023[regression2023.length - 1][1]),
    };
    const startCircle2024 = {
      cx: yearWidth + 5 + dayScale(regression2024[0][0]),
      cy: yScale(regression2024[0][1]),
    };
    const endCircle2024 = {
      cx:
        yearWidth + 5 + dayScale(regression2024[regression2024.length - 1][0]),
      cy: yScale(regression2024[regression2024.length - 1][1]),
    };
    const startCircle2025 = {
      cx: 2 * yearWidth + 5 + dayScale(regression2025[0][0]),
      cy: yScale(regression2025[0][1]),
    };
    const endCircle2025 = {
      cx:
        2 * yearWidth +
        5 +
        dayScale(regression2025[regression2025.length - 1][0]),
      cy: yScale(regression2025[regression2025.length - 1][1]),
    };

    const yearBreak2024 = yearWidth;
    const yearBreak2025 = 2 * yearWidth;
    const meanLine = sept2023avg ? yScale(sept2023avg) : chartHeight / 2;

    return {
      city,
      activity: activityFilter,
      isBreakdown: false,
      regressionLine2023,
      regressionLine2024,
      regressionLine2025,
      startCircle2023,
      endCircle2023,
      startCircle2024,
      endCircle2024,
      startCircle2025,
      endCircle2025,
      yearBreak2024,
      yearBreak2025,
      meanLine,
      percentageChange2025vs2023,
      percentageChange2025vs2024,
      perChange2025Display: percentageChange2025vs2023.toFixed(2) + "%",
      perChange2024Display: percentageChange2025vs2024.toFixed(2) + "%",
    };
  }

  $: charts = thecities
    .map((city) => {
      if (filteredCities.includes(city)) {
        if (viewMode === "overall") {
          const chart = generateChartForCity(city, null);
          return chart;
        } else {
          // Breakdown mode - generate chart for each activity type
          const activityCharts = activityTypes
            .map((activity) => generateChartForCity(city, activity))
            .filter((c) => c !== undefined);

          if (activityCharts.length === 0) return undefined;

          // Get overall percentage change for consistent sorting with overall view
          const overallChart = generateChartForCity(city, null);

          // Return a combined object with all activity data
          return {
            city,
            isBreakdown: true,
            activities: activityCharts,
            // Use overall data for sorting (same as overall view)
            percentageChange2025vs2024:
              overallChart?.percentageChange2025vs2024 || 0,
          };
        }
      }
    })
    .filter((value) => value !== undefined);

  // Sort by 2025 vs 2024 change (greatest positive change first)
  $: sortedCharts = charts
    .slice()
    .sort(
      (a, b) => b.percentageChange2025vs2024 - a.percentageChange2025vs2024,
    );

  // Get the region colour for each city
  function getRegionColor(city) {
    const cityData = cities.filter((item) => item.city === city);
    if (cityData) {
      const regionName = cityData[0].region;
      const regionData = regionColours.find(
        (region) => region.name === regionName,
      );
      if (regionData) {
        return regionData.colour;
      }
    } else {
      return "white";
    }
  }

  // $: {
  // 	createCharts(data);
  // }
</script>

<Header />

<main>
  <div class="text">
    <h1>Recovery Trends</h1>
    <p>
      By <a href="https://schoolofcities.utoronto.ca/people/karen-chapple/"
        >Karen Chapple</a
      >,
      <a href="https://www.urbandisplacement.org/team/julia-greenberg/"
        >Julia Greenberg</a
      >,
      <a href="https://schoolofcities.utoronto.ca/people/jeff-allen/"
        >Jeff Allen</a
      >, <a href="https://www.linkedin.com/in/irene-kcc/">Irene Chang</a>
    </p>
    <p>
      <i>Updated {selection.update_date}</i>
    </p>
    <p>
      Data on cell phone activity (a.k.a. footfall) trends provide a picture of
      how downtowns are faring. We look here at year-over-year trends comparing {selection.monthName}
      {selection.year3} vs. {selection.year2}
      and {selection.monthName}
      {selection.year3} vs. {selection.year1}.
    </p>
    <p>
      The solid line represents the number of daily unique visitors in the
      downtown area from September to November across 2023, 2024, and 2025. The
      dotted line provides a baseline of the average level of activity in {selection.monthName}
      2023, allowing for comparison to subsequent periods. When the solid line extends
      above the dotted baseline, downtown activity is greater compared to {selection.monthName}
      2023. When it dips below the dotted line, activity is on a downswing.
    </p>
    <h5>Key Findings:</h5>
    <p>
      Comparing {selection.monthName} 2024 to {selection.monthName} 2025:
      <br />

      ‣ <span class="bold">32</span> downtowns are in an upward trajectory,
      while <span class="bold">31</span> are trending downwards.
      <br />
      ‣ The median rate of change is <span class="bold">-0.63%</span>, the mean
      is <span class="bold">-2.23%</span>.
    </p>
    <p>
      In general, the downtowns that are seeing the highest rates of activity
      increase are the downtowns where recovery was lagging in our <a
        href="/charts/rankings">2023 rankings</a
      >.
    </p>
    <p>
      Note: Trends are based on data from Spectus, but use different cell phone
      data providers from our rankings analysis. The trendlines measure the
      average level of activity over the course of the year, while the ranking
      metric shows the percent difference in the average number of unique
      visitors in {selection.year3} versus the same month in {selection.year1}
      & {selection.year3} versus {selection.year1}.
    </p>

    <h4>
      Visits to Downtown ({selection.monthName}
      {selection.year1}, {selection.year2}, {selection.year3})
    </h4>

    <p>View Mode:</p>
    <div class="toggle-container">
      <button
        class="toggle-btn"
        class:active={viewMode === "overall"}
        on:click={() => (viewMode = "overall")}
      >
        Overall
      </button>
      <button
        class="toggle-btn"
        class:active={viewMode === "breakdown"}
        on:click={() => (viewMode = "breakdown")}
      >
        By Activity
      </button>
    </div>

    <p>Select Regions:</p>

    <SelectRegions europe={"no"} canada={"yes"} />

    <div
      style="display: flex; align-items: center; gap: 20px; padding: 10px 0;"
    >
      {#if viewMode === "breakdown"}
        <!-- Activity legend for breakdown view -->
        <div style="display: flex; align-items: center; gap: 5px;">
          <span
            style="width: 12px; height: 12px; background: {activityColors.WORK}; border-radius: 2px;"
          ></span>
          <span style="font-size: 14px; color: white;">Work</span>
        </div>
        <div style="display: flex; align-items: center; gap: 5px;">
          <span
            style="width: 12px; height: 12px; background: {activityColors.HOME}; border-radius: 2px;"
          ></span>
          <span style="font-size: 14px; color: white;">Home</span>
        </div>
        <div style="display: flex; align-items: center; gap: 5px;">
          <span
            style="width: 12px; height: 12px; background: {activityColors.NEITHER}; border-radius: 2px;"
          ></span>
          <span style="font-size: 14px; color: white;">Neither</span>
        </div>
      {:else}
        <!-- Overall view legend -->
        <div style="display: flex; align-items: center; gap: 8px;">
          <svg height="10" width="50">
            <line
              x1="0"
              y1="5"
              x2="50"
              y2="5"
              stroke="white"
              stroke-width="1"
              stroke-dasharray="3"
            />
          </svg>
          {selection.monthName}
          {selection.year1} average
        </div>

        <div style="display: flex; align-items: center; gap: 8px;">
          <svg height="10" width="50">
            <line
              x1="0"
              y1="5"
              x2="50"
              y2="5"
              stroke="#4ECDC4"
              stroke-width="2"
            />
          </svg>
          {selection.monthName} trend
        </div>
      {/if}

      <div style="display: flex; align-items: center; gap: 8px;">
        <svg height="10" width="30">
          <line x1="0" y1="5" x2="30" y2="5" stroke="#666" stroke-width="1" />
        </svg>
        Year break
      </div>
    </div>
  </div>

  <div class="chart-wrapper">
    <div class="left">
      <svg width="760" height={chartHeight} class="region-bar">
        <text x="12" y="35" class="textCity">City</text>

        <text x="235" y="15" class="textLabel">Percent Change in Visits</text>

        <text x="235" y="35" class="textLabel"
          >{selection.monthNumber}/{selection.year3} vs. {selection.monthNumber}/{selection.year2},
        </text>

        <text x="235" y="55" class="textLabelSmall"
          >{selection.monthNumber}/{selection.year3} vs. {selection.monthNumber}/{selection.year1}</text
        >

        <line
          x1="260"
          y1={45}
          x2={260 + chartWidth}
          y2={45}
          stroke="white"
          stroke-width="1"
        />

        <!-- Year labels for 2023, 2024, 2025 -->
        {#each [2023, 2024, 2025] as year, i}
          <!-- Year section background label -->
          <text
            x={260 + (i * chartWidth) / 3 + chartWidth / 6}
            y="40"
            class="textMonth">{year}</text
          >

          <!-- Year break lines (between years) -->
          {#if i > 0}
            <line
              x1={260 + (i * chartWidth) / 3}
              y1={5}
              x2={260 + (i * chartWidth) / 3}
              y2={50}
              stroke="white"
              stroke-width="1"
            />
          {/if}
        {/each}
      </svg>
    </div>
  </div>

  {#each sortedCharts as chartData, i}
    <div class="chart-wrapper" bind:clientWidth={width}>
      <div class="left">
        <svg width="150" height={chartHeight} class="region-bar">
          <line
            x1="5"
            y1="15"
            x2="5"
            y2={chartHeight - 45}
            stroke={getRegionColor(chartData.city)}
            stroke-width="5"
          />

          <text x="12" y="31" class="textCity">{i + 1}. {chartData.city}</text>
        </svg>
      </div>

      {#if !chartData.isBreakdown}
        <!-- OVERALL VIEW -->
        <div class="arrow">
          {#if chartData.percentageChange2025vs2024 > 0}
            <img src={upArrow} alt="Up arrow" class="arrow-icon" />
          {:else if chartData.percentageChange2025vs2024 < 0}
            <img src={downArrow} alt="Down arrow" class="arrow-icon" />
          {/if}
        </div>

        <div class="number">
          <span class="percent-main">{chartData.perChange2024Display},</span>
          <span class="percent-secondary">{chartData.perChange2025Display}</span
          >
        </div>

        <div class="chart-container" style="width: {chartWidth};">
          <svg height={chartHeight} width={chartWidth} class="chart">
            <!-- Year break lines -->
            <line
              x1={chartData.yearBreak2024}
              y1={5}
              x2={chartData.yearBreak2024}
              y2={50}
              stroke="#666666"
              stroke-width="1"
            />
            <line
              x1={chartData.yearBreak2025}
              y1={5}
              x2={chartData.yearBreak2025}
              y2={50}
              stroke="#666666"
              stroke-width="1"
            />

            <!-- Baseline (Sept 2023 average) -->
            <line
              x1="0"
              y1={chartData.meanLine}
              x2={chartWidth}
              y2={chartData.meanLine}
              stroke="#D0D1C9"
              stroke-width="1"
              stroke-dasharray="4"
            />

            <!-- Regression lines -->
            <path
              d={chartData.regressionLine2023}
              stroke="#4ECDC4"
              stroke-width="2"
              fill="none"
            />
            <path
              d={chartData.regressionLine2024}
              stroke="#4ECDC4"
              stroke-width="2"
              fill="none"
            />
            <path
              d={chartData.regressionLine2025}
              stroke="#4ECDC4"
              stroke-width="2"
              fill="none"
            />

            <!-- Start and end circles -->
            <circle
              cx={chartData.startCircle2023.cx}
              cy={chartData.startCircle2023.cy}
              r="2"
              fill="#4ECDC4"
            />
            <circle
              cx={chartData.endCircle2023.cx}
              cy={chartData.endCircle2023.cy}
              r="2"
              fill="#4ECDC4"
            />
            <circle
              cx={chartData.startCircle2024.cx}
              cy={chartData.startCircle2024.cy}
              r="2"
              fill="#4ECDC4"
            />
            <circle
              cx={chartData.endCircle2024.cx}
              cy={chartData.endCircle2024.cy}
              r="2"
              fill="#4ECDC4"
            />
            <circle
              cx={chartData.startCircle2025.cx}
              cy={chartData.startCircle2025.cy}
              r="2"
              fill="#4ECDC4"
            />
            <circle
              cx={chartData.endCircle2025.cx}
              cy={chartData.endCircle2025.cy}
              r="2"
              fill="#4ECDC4"
            />
          </svg>
        </div>
      {:else}
        <!-- BREAKDOWN VIEW -->
        <div class="arrow">
          <!-- No arrow in breakdown view -->
        </div>

        <div class="number breakdown-number">
          {#each chartData.activities as act}
            <span
              class="percent-activity"
              style="color: {activityColors[act.activity]};"
            >
              {act.activity}: {act.perChange2025Display}
            </span>
          {/each}
        </div>

        <div class="chart-container" style="width: {chartWidth};">
          <svg height={chartHeight} width={chartWidth} class="chart">
            <!-- Year break lines -->
            <line
              x1={chartData.activities[0].yearBreak2024}
              y1={5}
              x2={chartData.activities[0].yearBreak2024}
              y2={50}
              stroke="#666666"
              stroke-width="1"
            />
            <line
              x1={chartData.activities[0].yearBreak2025}
              y1={5}
              x2={chartData.activities[0].yearBreak2025}
              y2={50}
              stroke="#666666"
              stroke-width="1"
            />

            <!-- Regression lines for each activity -->
            {#each chartData.activities as act}
              <path
                d={act.regressionLine2023}
                stroke={activityColors[act.activity]}
                stroke-width="2"
                fill="none"
              />
              <path
                d={act.regressionLine2024}
                stroke={activityColors[act.activity]}
                stroke-width="2"
                fill="none"
              />
              <path
                d={act.regressionLine2025}
                stroke={activityColors[act.activity]}
                stroke-width="2"
                fill="none"
              />
            {/each}
          </svg>
        </div>
      {/if}
    </div>
  {/each}

  <div class="text">
    <br />
    <br />

    <h4>More Information</h4>

    <p>
      The trend lines are fit from daily data via a <a
        href="https://en.wikipedia.org/wiki/Local_regression">LOESS</a
      >
      curve. You can download the raw daily data shown to fit these curves
      <a href="/SONmonths.csv">from this link</a>. The data on the charts are
      based on the `normalized_distinct_clean` column, which pertains to the
      number of unique daily visitors normalized by the total number in the
      metro area. The trend-line and summary statistics shown are calculated in
      JavaScript (code is on
      <a
        href="https://github.com/schoolofcities/downtown-recovery/blob/main/src/routes/charts/trends/%2Bpage.svelte"
        target="_blank">GitHub</a
      >)
    </p>

    <br />

    <br />
  </div>
</main>

<style>
  .chart-wrapper {
    display: flex;
    /* vertical-align: top; */
    margin: 0 auto;
    padding-left: 5px;
    padding-right: 5px;
    margin-bottom: 0px;
    max-width: 760px;
    height: 53px;
    background-color: var(--brandGray90);
    border-bottom: solid 1px var(--brandDarkBlue);
    padding-bottom: 6px;
  }

  .textLabel {
    font-family: Roboto;
    font-size: 15px;
    text-anchor: end;
    fill: var(--brandWhite);
  }

  .textLabelSmall {
    font-family: Roboto;
    font-size: 13px;
    text-anchor: end;
    fill: var(--brandWhite);
  }

  .textMonth {
    font-family: Roboto;
    font-size: 14px;
    text-anchor: middle;
    fill: var(--brandWhite);
  }

  .left {
    width: 150px;
    /* background-color: var(--brandPurple); */
  }
  .textCity {
    font-family: Roboto;
    font-size: 15px;
    text-anchor: start;
    fill: var(--brandWhite);
  }

  .chart-container {
    width: 400px;
    /* background-color: var(--brandMedBlue); */
  }
  .chart {
    margin-left: 10px; /* tighter to match header composite offset */
  }

  .number {
    width: 65px;
    margin-top: -12px;
    margin-right: 0px;
    margin-left: 12px;
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    justify-content: center;
    gap: 2px;
  }
  .percent-main {
    font-family: Roboto;
    font-size: 16px;
    color: var(--brandWhite);
    line-height: 1.2;
    margin-right: 15px;
    padding-top: 15px;
  }
  .percent-secondary {
    font-family: Roboto;
    font-size: 13px;
    color: var(--brandWhite);
    line-height: 1.2;
    margin-right: 15px;
  }

  .arrow {
    margin: auto 4px auto -13px;
    width: 32px;
    height: 40px;
    display: flex;
    justify-content: center;
    align-items: center;
    transform: translateX(7px);
    flex-shrink: 0;
  }
  .arrow-icon {
    margin: auto 0;
    width: 40px;
    height: 40px;
    align-items: center;
  }
  /* @media (max-width: 490px) {
		.chart-wrapper {
			flex-direction: column; 
			align-items: center;
		}
		.chart-container {
			margin-top: 0;
		}
	} */

  .text {
    border-bottom: none;
  }

  /* Toggle button styles */
  .toggle-container {
    display: flex;
    gap: 0;
    margin-bottom: 15px;
  }
  .toggle-btn {
    padding: 8px 20px;
    font-family: Roboto;
    font-size: 14px;
    border: 1px solid var(--brandWhite);
    background: transparent;
    color: var(--brandWhite);
    cursor: pointer;
    transition: all 0.2s ease;
  }
  .toggle-btn:first-child {
    border-radius: 4px 0 0 4px;
  }
  .toggle-btn:last-child {
    border-radius: 0 4px 4px 0;
    border-left: none;
  }
  .toggle-btn.active {
    background: var(--brandWhite);
    color: var(--brandDarkBlue);
  }
  .toggle-btn:hover:not(.active) {
    background: rgba(255, 255, 255, 0.1);
  }

  /* Breakdown view number styles */
  .breakdown-number {
    width: 90px;
    gap: 1px;
    padding-top: 5px;
  }
  .percent-activity {
    font-family: Roboto;
    font-size: 11px;
    line-height: 1.1;
    margin-right: 10px;
  }

  /* h5 {
		font-size: 18px;
		text-align: right;
		font-family: Roboto;
		color: var(--brandGray);
		padding-left: 0px;
		padding-bottom: 40px;;
		text-decoration: none;
	} */
</style>
