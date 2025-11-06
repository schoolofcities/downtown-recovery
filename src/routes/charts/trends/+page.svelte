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
    day2: "2024-09-01",
    day3: "2025-09-30",
    day1_num: 1,
    day2_num: 30,
    update_date: "2025-11-06", // change this to whenever website is updated
  };

  async function loadData() {
    try {
      const response = await fetch(
        "/trend_canada_us_sep1_2023_to_sep30_2025.csv",
      );
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

  const parseDate = timeParse("%Y-%m-%d");

  let thecities = [];
  let charts = []; // to hold chart data for each city
  let sortedCharts = []; // to hold the sorted charts

  $: filteredCities = cities
    .filter((item) => $selectedRegions.includes(item.region))
    .map((item) => item.city);

  // function createCharts(data) {

  $: charts = thecities
    .map((city) => {
      if (filteredCities.includes(city)) {
        // ===== 2024 DATA (Sept 2023 to Sept 2024) =====
        const cityData2024 = data.filter((item) => {
          const date = new Date(item.date);
          const start2023 = new Date(selection.day1);
          const end2024 = new Date("2024-09-30");
          return item.city === city && date >= start2023 && date <= end2024;
        });

        // ===== 2025 DATA (Sept 2024 to Sept 2025) =====
        const cityData2025 = data.filter((item) => {
          const date = new Date(item.date);
          const start2024 = new Date(selection.day2);
          const end2025 = new Date(selection.day3);
          return item.city === city && date >= start2024 && date <= end2025;
        });

        if (cityData2024.length > 0 && cityData2025.length > 0) {
          // ===== CALCULATE MONTHLY AVERAGES FOR 3 SEPTEMBERS =====

          // September 2023 average
          const sept2023data = data.filter((item) => {
            const date = new Date(item.date + "T00:00:00Z");
            return (
              date.getUTCFullYear() === selection.year1 &&
              date.getUTCMonth() === selection.monthNumber - 1 &&
              item.city === city
            );
          });
          const sept2023avg = mean(sept2023data, (d) =>
            parseFloat(d.normalized_distinct_clean),
          );

          // September 2024 average
          const sept2024data = data.filter((item) => {
            const date = new Date(item.date + "T00:00:00Z");
            return (
              date.getUTCFullYear() === selection.year2 &&
              date.getUTCMonth() === selection.monthNumber - 1 &&
              item.city === city
            );
          });
          const sept2024avg = mean(sept2024data, (d) =>
            parseFloat(d.normalized_distinct_clean),
          );

          // September 2025 average
          const sept2025data = data.filter((item) => {
            const date = new Date(item.date + "T00:00:00Z");
            return (
              date.getUTCFullYear() === selection.year3 &&
              date.getUTCMonth() === selection.monthNumber - 1 &&
              item.city === city
            );
          });
          const sept2025avg = mean(sept2025data, (d) =>
            parseFloat(d.normalized_distinct_clean),
          );

          // ===== CALCULATE PERCENTAGE CHANGES =====

          // 9/2025 vs 9/2023
          const percentageChange2025vs2023 =
            ((sept2025avg - sept2023avg) / sept2023avg) * 100;

          // 9/2025 vs 9/2024
          const percentageChange2025vs2024 =
            ((sept2025avg - sept2024avg) / sept2024avg) * 100;

          // ===== REGRESSION FOR 2024 LINE =====
          const regressionGenerator2024 = regressionLoess()
            .x((d) => parseDate(d.date))
            .y((d) => parseFloat(d.normalized_distinct_clean))
            .bandwidth(0.031);

          const regressionData2024 = regressionGenerator2024(cityData2024);

          // ===== REGRESSION FOR 2025 LINE =====
          const regressionGenerator2025 = regressionLoess()
            .x((d) => parseDate(d.date))
            .y((d) => parseFloat(d.normalized_distinct_clean))
            .bandwidth(0.031);

          const regressionData2025 = regressionGenerator2025(cityData2025);

          // ===== NORMALIZE 2025 DATES TO OVERLAP WITH 2024 =====
          // Shift 2025 dates back by one year so they align September-to-September
          const regressionData2025Normalized = regressionData2025.map((d) => {
            const originalDate = new Date(d[0]);
            const normalizedDate = new Date(originalDate);
            normalizedDate.setFullYear(originalDate.getFullYear() - 1);
            return [normalizedDate, d[1]];
          });

          // ===== SCALES (12-month Sept-Sept range) =====
          const allRegressionValues2024 = regressionData2024.map((d) => d[1]);
          const allRegressionValues2025 = regressionData2025.map((d) => d[1]);

          const allRegressionValues = [
            ...allRegressionValues2024,
            ...allRegressionValues2025,
          ];

          const cityMin = Math.min(...allRegressionValues);
          const cityMax = Math.max(...allRegressionValues);

          // Add padding to prevent lines from going out of bounds (10% padding)
          const yRange = cityMax - cityMin;
          const yPadding = yRange * 0.7;
          const paddedMin = cityMin - yPadding;
          const paddedMax = cityMax + yPadding;

          // X scale spans Sept 2023 to Sept 2024 (12 months + September 2024)
          // Add padding to prevent dots from being cut off at edges
          const xPadding = 5; // removed padding to align with header ticks
          const xScale = scaleTime()
            .domain([new Date(selection.day1), new Date("2024-09-30")])
            .range([xPadding, chartWidth - xPadding]); // horizontal padding

          const yScale = scaleLinear()
            .domain([paddedMin, paddedMax])
            .range([chartHeight - marginBottom, marginTop]);

          const lineGenerator = line()
            .x((d) => xScale(d[0]))
            .y((d) => yScale(d[1]));

          // ===== CREATE LINE PATHS =====
          const regressionLine2024 = lineGenerator(regressionData2024);
          const regressionLine2025 = lineGenerator(
            regressionData2025Normalized,
          );

          // ===== CIRCLES FOR START AND END POINTS =====
          // 2024 line circles (red)
          const startCircle2024 = {
            cx: xScale(regressionData2024[0][0]),
            cy: yScale(regressionData2024[0][1]),
          };
          const endCircle2024 = {
            cx: xScale(regressionData2024[regressionData2024.length - 1][0]),
            cy: yScale(regressionData2024[regressionData2024.length - 1][1]),
          };

          // 2025 line circles (orange) - using normalized dates
          const startCircle2025 = {
            cx: xScale(regressionData2025Normalized[0][0]),
            cy: yScale(regressionData2025Normalized[0][1]),
          };
          const endCircle2025 = {
            cx: xScale(
              regressionData2025Normalized[
                regressionData2025Normalized.length - 1
              ][0],
            ),
            cy: yScale(
              regressionData2025Normalized[
                regressionData2025Normalized.length - 1
              ][1],
            ),
          };

          // ===== BASELINE (Sept 2023 average) =====
          const meanLine = yScale(sept2023avg);

          return {
            city: city,
            regressionLine2024: regressionLine2024,
            regressionLine2025: regressionLine2025,
            startCircle2024: startCircle2024,
            endCircle2024: endCircle2024,
            startCircle2025: startCircle2025,
            endCircle2025: endCircle2025,
            meanLine: meanLine,
            percentageChange2025vs2023: percentageChange2025vs2023,
            percentageChange2025vs2024: percentageChange2025vs2024,
            perChange2025Display: percentageChange2025vs2023.toFixed(2) + "%",
            perChange2024Display: percentageChange2025vs2024.toFixed(2) + "%",
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
      Data on cell phone activity (a.k.a. footfall) trends for the last two
      years provide a picture of how downtowns are faring. We look here at
      year-over-year trends comparing September {selection.year3} vs. {selection.year2}
      and September {selection.year3} vs. {selection.year1}.
    </p>
    <p>
      The solid line represents the number of daily unique visitors in the
      downtown area. The dotted line provides a baseline of the average level of
      activity in {selection.monthName} 2023, allowing for comparison to subsequent
      months. When the solid line extends above the dotted baseline, downtown activity
      is greater compared to in {selection.monthName} 2023. When it dips below the
      dotted line, activity is on a downswing. For most cities, there is an increase
      in month 6 or 7; this is expected since these are the summer months of June
      and July. The fall months see decreasing activity on average, with almost all
      downtowns losing activity by November. However, some cities stay above the
      {selection.monthName} baseline, suggesting gradual recovery, while others dip
      well below it, i.e., stagnating recovery.
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
      Visits to Downtown (September {selection.year1} to September {selection.year3})
    </h4>

    <p>Select Regions:</p>

    <SelectRegions europe={"no"} canada={"yes"} />

    <div
      style="display: flex; align-items: center; gap: 20px; padding: 10px 0;"
    >
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
          <line x1="0" y1="5" x2="50" y2="5" stroke="red" stroke-width="2" />
        </svg>
        {selection.year1} to {selection.year2}
      </div>

      <div style="display: flex; align-items: center; gap: 8px;">
        <svg height="10" width="50">
          <line x1="0" y1="5" x2="50" y2="5" stroke="orange" stroke-width="2" />
        </svg>
        {selection.year2} to {selection.year3}
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

        {#each [9, 10, 11, 12, 1, 2, 3, 4, 5, 6, 7, 8, 9] as l, i}
          <line
            x1={260 + (i * chartWidth) / 13}
            y1={45}
            x2={260 + (i * chartWidth) / 13}
            y2={40}
            stroke="white"
            stroke-width="1"
          />

          {#if i === 4}
            <line
              x1={260 + (i * chartWidth) / 13}
              y1={5}
              x2={260 + (i * chartWidth) / 13}
              y2={40}
              stroke="white"
              stroke-width="1"
            />
          {/if}

          <text
            x={260 + (i * chartWidth) / 13 + (0.5 * chartWidth) / 13}
            y="40"
            class="textMonth">{l}</text
          >
        {/each}
      </svg>
    </div>
  </div>

  {#each sortedCharts as { city, regressionLine2024, regressionLine2025, startCircle2024, endCircle2024, startCircle2025, endCircle2025, meanLine, perChange2024Display, perChange2025Display, percentageChange2025vs2024 }, i}
    <div class="chart-wrapper" bind:clientWidth={width}>
      <div class="left">
        <svg width="150" height={chartHeight} class="region-bar">
          <line
            x1="5"
            y1="15"
            x2="5"
            y2={chartHeight - 45}
            stroke={getRegionColor(city)}
            stroke-width="5"
          />

          <text x="12" y="31" class="textCity">{i + 1}. {city}</text>
        </svg>

        <!-- <div class="arrow-indicator">
						{#if percentageChange > 0}
							<img src={upArrow} alt="Up arrow" class="arrow-icon"/>
						{:else if percentageChange < 0}
							<img src={downArrow} alt="Down arrow" class="arrow-icon"/>
						{/if}
					</div>
					<h5>{perChangeDisplay}</h5> -->
      </div>

      <div class="arrow">
        {#if percentageChange2025vs2024 > 0}
          <img src={upArrow} alt="Up arrow" class="arrow-icon" />
        {:else if percentageChange2025vs2024 < 0}
          <img src={downArrow} alt="Down arrow" class="arrow-icon" />
        {/if}
      </div>

      <div class="number">
        <span class="percent-main">{perChange2024Display},</span>
        <span class="percent-secondary">{perChange2025Display}</span>
      </div>

      <div class="chart-container" style="width: {chartWidth};">
        <svg height={chartHeight} width={chartWidth} class="chart">
          {#each [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] as l, i}
            <line
              x1={(l * chartWidth) / 13}
              y1={5}
              x2={(l * chartWidth) / 13}
              y2={45}
              stroke="#333333"
              stroke-width="1"
            />
          {/each}

          <!-- Top line -->
          <!-- <line x1="0" y1="0" x2={chartWidth} y2="0" stroke="gray" stroke-width="1"/>  -->
          <!-- Middle line -->
          <line
            x1="0"
            y1={meanLine}
            x2={chartWidth}
            y2={meanLine}
            stroke="#D0D1C9"
            stroke-width="1"
            stroke-dasharray="4"
          />

          <!-- 2024 regression line (red) -->
          <path
            d={regressionLine2024}
            stroke="red"
            stroke-width="2"
            fill="none"
          />

          <!-- 2025 regression line (orange) -->
          <path
            d={regressionLine2025}
            stroke="orange"
            stroke-width="2"
            fill="none"
          />

          <!-- Start and end circles for 2024 line -->
          <circle
            cx={startCircle2024.cx}
            cy={startCircle2024.cy}
            r="1"
            fill="red"
            stroke="red"
            stroke-width="2"
          />
          <circle
            cx={endCircle2024.cx}
            cy={endCircle2024.cy}
            r="1"
            fill="red"
            stroke="red"
            stroke-width="2"
          />

          <!-- Start and end circles for 2025 line -->
          <circle
            cx={startCircle2025.cx}
            cy={startCircle2025.cy}
            r="1"
            fill="orange"
            stroke="orange"
            stroke-width="2"
          />
          <circle
            cx={endCircle2025.cx}
            cy={endCircle2025.cy}
            r="1"
            fill="orange"
            stroke="orange"
            stroke-width="2"
          />
        </svg>
      </div>
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
      <a href="/trend_canada_us_sep1_2023_to_sep30_2025.csv">from this link</a>.
      The data on the charts are based on the `normalized_distinct_clean`
      column, which pertains to the number of unique daily visitors normalized
      by the total number in the metro area. The trend-line and summary
      statistics shown are calculated in JavaScript (code is on
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
