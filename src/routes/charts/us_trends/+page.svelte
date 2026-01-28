<script>
  import Header from "../../../lib/Header.svelte";
  import { onMount } from "svelte";
  import { csvParse } from "d3-dsv";
  import {
    scaleTime,
    scaleLinear,
    timeParse,
    line,
    scaleSequential,
    interpolateRdYlGn,
  } from "d3";
  import { regressionLoess } from "d3-regression";
  import { min, max, mean } from "d3-array";
  import { cities } from "../../../lib/stores.js";
  import maplibregl from "maplibre-gl";

  import upArrow from "../../../assets/green-arrow.svg";
  import downArrow from "../../../assets/red-arrow.svg";

  import "../../../assets/global.css";
  import "maplibre-gl/dist/maplibre-gl.css";
  import { xlink_attr } from "svelte/internal";

  let selection = {
    monthNames: "September to December",
    monthNumbers: [9, 10, 11, 12],
    year1: 2023,
    year2: 2024,
    year3: 2025,
    update_date: "2026-01-06", // change this to whenever website is updated
  };

  // Toggle between Overall and Breakdown view
  let viewMode = "overall"; // "overall" or "breakdown"
  const activityTypes = ["WORK", "HOME", "NEITHER"];
  const activityColors = {
    WORK: "#FF6B6B", // red
    HOME: "#4ECDC4", // teal
    NEITHER: "#FFE66D", // yellow
  };

  let data = []; // aggregated data for overall view
  let activityData = []; // activity-level data for breakdown view
  let cityCoords = []; // city coordinates for map
  let mapContainer; // map container element
  let map; // maplibre map instance

  async function loadCityCoords() {
    try {
      const response = await fetch("/all_city_coords.csv");
      const csvData = await response.text();
      cityCoords = csvParse(csvData);
    } catch (error) {
      console.error("Error loading city coordinates:", error);
    }
  }
  async function loadData() {
    try {
      // Load aggregated data (one row per city/date with agg_norm_distinct)
      const response = await fetch("/trend_sep_to_dec_agg_only.csv");
      const csvData = await response.text();
      data = csvParse(csvData);
      thecities = [...new Set(data.map((item) => item.city))];
    } catch (error) {
      console.error("Error loading aggregated CSV data:", error);
    }
  }

  async function loadActivityData() {
    try {
      // Load activity-level data for breakdown view (kept for later)
      const response = await fetch(
        "/trend_sep_to_dec_23_24_25_activity_deduped.csv",
      );
      const csvData = await response.text();
      activityData = csvParse(csvData);
    } catch (error) {
      console.error("Error loading activity CSV data:", error);
    }
  }

  onMount(async () => {
    await loadData();
    await loadCityCoords();
    loadActivityData();
    filteredCities = cities
      .filter((item) => item.region !== "Canada")
      .map((item) => item.city);
  });

  // Initialize map when sortedCharts is ready
  $: if (
    sortedCharts.length > 0 &&
    cityCoords.length > 0 &&
    mapContainer &&
    !map
  ) {
    initMap();
  }

  function initMap() {
    map = new maplibregl.Map({
      container: mapContainer,
      style: {
        version: 8,
        sources: {
          "carto-dark": {
            type: "raster",
            tiles: [
              "https://a.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}@2x.png",
              "https://b.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}@2x.png",
              "https://c.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}@2x.png",
            ],
            tileSize: 256,
            attribution:
              '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>',
          },
        },
        layers: [
          {
            id: "carto-dark-layer",
            type: "raster",
            source: "carto-dark",
            minzoom: 0,
            maxzoom: 19,
          },
        ],
      },
      center: [-98, 39], // Center of US
      zoom: 3.5,
    });

    map.on("load", () => {
      addCityMarkers();
    });
  }

  function addCityMarkers() {
    // Find min/max percent change for color scale
    const changes = sortedCharts.map((c) => c.percentageChange2025vs2023);
    const minChange = Math.min(...changes);
    const maxChange = Math.max(...changes);

    // Create symmetric scale around 0
    const maxAbs = Math.max(Math.abs(minChange), Math.abs(maxChange));
    const colorScale = scaleSequential(interpolateRdYlGn).domain([
      -maxAbs,
      maxAbs,
    ]);

    sortedCharts.forEach((chart) => {
      // Find coordinates for this city
      const coords = cityCoords.find((c) => c.city === chart.city);
      if (!coords) return;

      const lng = parseFloat(coords.long);
      const lat = parseFloat(coords.lat);
      const change = chart.percentageChange2025vs2023;
      const color = colorScale(change);

      // Create marker element
      const el = document.createElement("div");
      el.className = "city-marker";
      el.style.backgroundColor = color;
      el.style.width = "24px";
      el.style.height = "24px";
      el.style.borderRadius = "50%";
      el.style.border = "2px solid white";
      el.style.cursor = "pointer";
      el.style.display = "flex";
      el.style.alignItems = "center";
      el.style.justifyContent = "center";
      el.style.fontSize = "10px";
      el.style.fontWeight = "bold";
      el.style.color = change > 30 ? "#000" : "#fff";

      // Create popup
      const popup = new maplibregl.Popup({ offset: 25 }).setHTML(
        `<div style="color: #333; font-family: Roboto;">
          <strong>${chart.city}</strong><br/>
          2025 vs 2023: <span style="color: ${change >= 0 ? "green" : "red"}; font-weight: bold;">${change >= 0 ? "+" : ""}${change.toFixed(1)}%</span>
        </div>`,
      );

      new maplibregl.Marker({ element: el })
        .setLngLat([lng, lat])
        .setPopup(popup)
        .addTo(map);
    });
  }

  let chartWidth = 500;
  const chartHeight = 80;

  const marginTop = 0;
  const marginRight = 5;
  const marginBottom = 0;
  const marginLeft = 5;

  const parseDate = timeParse("%m/%d/%Y");

  let charts = []; // to hold chart data for each city
  let sortedCharts = []; // to hold the sorted charts
  let thecities = []; // to hold unique city names from data
  let width; // for binding chart wrapper width

  // Filter out Canadian cities
  $: filteredCities = cities
    .filter((item) => item.region !== "Canada")
    .map((item) => item.city);

  // Get the value column based on view mode
  function getValue(item) {
    // agg_norm_distinct is from the R-computed aggregated file
    return parseFloat(item.agg_norm_distinct || 0);
  }

  // Get normalized_distinct_clean for activity breakdown
  function getActivityValue(item) {
    return parseFloat(item.normalized_distinct_clean || 0);
  }

  // ===== OVERALL VIEW CHARTS =====
  $: overallCharts = thecities
    .map((city) => {
      if (filteredCities.includes(city)) {
        // ===== FILTER DATA BY CITY AND DATE RANGE =====
        // For overall view, we need unique dates (aggregated values are duplicated per activity)
        const filterAndDedupe = (startDate, endDate) => {
          const filtered = data.filter((item) => {
            const date = new Date(item.date);
            return item.city === city && date >= startDate && date <= endDate;
          });

          if (viewMode === "overall") {
            // Deduplicate by date for overall view (since agg values are same for all activities)
            const seen = new Set();
            return filtered.filter((item) => {
              if (seen.has(item.date)) return false;
              seen.add(item.date);
              return true;
            });
          }
          return filtered;
        };

        const cityData2023 = filterAndDedupe(
          new Date("2023-09-01"),
          new Date("2023-12-31"),
        );
        const cityData2024 = filterAndDedupe(
          new Date("2024-09-01"),
          new Date("2024-12-31"),
        );
        const cityData2025 = filterAndDedupe(
          new Date("2025-09-01"),
          new Date("2025-12-31"),
        );

        if (
          cityData2023.length > 0 &&
          cityData2024.length > 0 &&
          cityData2025.length > 0
        ) {
          // ===== CALCULATE AVERAGES =====
          const avg2023 = mean(cityData2023, (d) => getValue(d));
          const avg2024 = mean(cityData2024, (d) => getValue(d));
          const avg2025 = mean(cityData2025, (d) => getValue(d));

          // ===== CALCULATE PERCENTAGE CHANGES =====

          // 2025 vs 2024
          const percentageChange2025vs2024 =
            ((avg2025 - avg2024) / avg2024) * 100;

          // 2025 vs 2023
          const percentageChange2025vs2023 =
            ((avg2025 - avg2023) / avg2023) * 100;

          // ===== REGRESSION FOR 2023 LINE =====
          const regressionGenerator2023 = regressionLoess()
            .x((d) => parseDate(d.date))
            .y((d) => getValue(d))
            .bandwidth(0.2);

          const regressionData2023 = regressionGenerator2023(cityData2023);

          // ===== REGRESSION FOR 2024 LINE =====
          const regressionGenerator2024 = regressionLoess()
            .x((d) => parseDate(d.date))
            .y((d) => getValue(d))
            .bandwidth(0.2);

          const regressionData2024 = regressionGenerator2024(cityData2024);

          // ===== REGRESSION FOR 2025 LINE =====
          const regressionGenerator2025 = regressionLoess()
            .x((d) => parseDate(d.date))
            .y((d) => getValue(d))
            .bandwidth(0.2);

          const regressionData2025 = regressionGenerator2025(cityData2025);

          // ===== SCALES (4-month Sept-Dec range) =====
          const allRegressionValues2023 = regressionData2023.map((d) => d[1]);
          const allRegressionValues2024 = regressionData2024.map((d) => d[1]);
          const allRegressionValues2025 = regressionData2025.map((d) => d[1]);

          const allRegressionValues = [
            ...allRegressionValues2023,
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

          // X scale spans 12 months (3 periods of 4 months each)
          const xPadding = 5;
          const columnWidth = (chartWidth - 2 * xPadding) / 3;

          // Custom position function for 3 separate columns
          const getXPosition = (date, year) => {
            const d = new Date(date);
            const month = d.getMonth(); // 0-11
            const day = d.getDate();

            // Calculate position within Sept-Dec (month 8-11)
            const monthOffset = month - 8; // 0-3 for Sept-Dec
            const daysInMonth = new Date(
              d.getFullYear(),
              month + 1,
              0,
            ).getDate();
            const dayFraction = day / daysInMonth;
            const positionInColumn = (monthOffset + dayFraction) / 4; // 0-1 within 4 months

            // Determine which column (0=2023, 1=2024, 2=2025)
            const columnIndex = year - 2023;

            return (
              xPadding +
              columnIndex * columnWidth +
              positionInColumn * columnWidth
            );
          };

          const yScale = scaleLinear()
            .domain([paddedMin, paddedMax])
            .range([chartHeight - marginBottom, marginTop]);

          // ===== CREATE LINE PATHS =====
          const lineGenerator2023 = line()
            .x((d) => getXPosition(d[0], 2023))
            .y((d) => yScale(d[1]));
          const lineGenerator2024 = line()
            .x((d) => getXPosition(d[0], 2024))
            .y((d) => yScale(d[1]));
          const lineGenerator2025 = line()
            .x((d) => getXPosition(d[0], 2025))
            .y((d) => yScale(d[1]));

          const regressionLine2023 = lineGenerator2023(regressionData2023);
          const regressionLine2024 = lineGenerator2024(regressionData2024);
          const regressionLine2025 = lineGenerator2025(regressionData2025);

          // ===== CIRCLES FOR START AND END POINTS =====
          // 2023 line circles (blue)
          const startCircle2023 = {
            cx: getXPosition(regressionData2023[0][0], 2023),
            cy: yScale(regressionData2023[0][1]),
          };
          const endCircle2023 = {
            cx: getXPosition(
              regressionData2023[regressionData2023.length - 1][0],
              2023,
            ),
            cy: yScale(regressionData2023[regressionData2023.length - 1][1]),
          };

          // 2024 line circles (red)
          const startCircle2024 = {
            cx: getXPosition(regressionData2024[0][0], 2024),
            cy: yScale(regressionData2024[0][1]),
          };
          const endCircle2024 = {
            cx: getXPosition(
              regressionData2024[regressionData2024.length - 1][0],
              2024,
            ),
            cy: yScale(regressionData2024[regressionData2024.length - 1][1]),
          };

          // 2025 line circles (orange)
          const startCircle2025 = {
            cx: getXPosition(regressionData2025[0][0], 2025),
            cy: yScale(regressionData2025[0][1]),
          };
          const endCircle2025 = {
            cx: getXPosition(
              regressionData2025[regressionData2025.length - 1][0],
              2025,
            ),
            cy: yScale(regressionData2025[regressionData2025.length - 1][1]),
          };

          // ===== BASELINE (Sept 2023 average) =====
          const meanLine = yScale(avg2023);

          return {
            city: city,
            regressionLine2023: regressionLine2023,
            regressionLine2024: regressionLine2024,
            regressionLine2025: regressionLine2025,
            startCircle2023: startCircle2023,
            endCircle2023: endCircle2023,
            startCircle2024: startCircle2024,
            endCircle2024: endCircle2024,
            startCircle2025: startCircle2025,
            endCircle2025: endCircle2025,
            meanLine: meanLine,
            percentageChange2025vs2024: percentageChange2025vs2024,
            percentageChange2025vs2023: percentageChange2025vs2023,
            perChange2025Display: percentageChange2025vs2023.toFixed(2) + "%",
            perChange2024Display: percentageChange2025vs2024.toFixed(2) + "%",
          };
        }
      }
    })
    .filter((value) => value !== undefined);

  // ===== ACTIVITY BREAKDOWN CHARTS =====
  $: activityCharts = thecities
    .map((city) => {
      if (filteredCities.includes(city) && activityData.length > 0) {
        const filterByActivityAndDate = (activity, startDate, endDate) => {
          return activityData.filter((item) => {
            const date = new Date(item.date);
            return (
              item.city === city &&
              item.ACTIVITY === activity &&
              date >= startDate &&
              date <= endDate
            );
          });
        };

        // Get data for each activity and year
        const activityResults = {};
        let allRegressionValues = [];

        for (const activity of activityTypes) {
          const data2023 = filterByActivityAndDate(
            activity,
            new Date("2023-09-01"),
            new Date("2023-12-31"),
          );
          const data2024 = filterByActivityAndDate(
            activity,
            new Date("2024-09-01"),
            new Date("2024-12-31"),
          );
          const data2025 = filterByActivityAndDate(
            activity,
            new Date("2025-09-01"),
            new Date("2025-12-31"),
          );

          if (
            data2023.length > 0 &&
            data2024.length > 0 &&
            data2025.length > 0
          ) {
            const avg2023 = mean(data2023, (d) => getActivityValue(d));
            const avg2024 = mean(data2024, (d) => getActivityValue(d));
            const avg2025 = mean(data2025, (d) => getActivityValue(d));

            const percentChange2025vs2023 =
              ((avg2025 - avg2023) / avg2023) * 100;
            const percentChange2025vs2024 =
              ((avg2025 - avg2024) / avg2024) * 100;

            // Generate regression for each year
            const regressionGenerator = regressionLoess()
              .x((d) => parseDate(d.date))
              .y((d) => getActivityValue(d))
              .bandwidth(0.2);

            const regression2023 = regressionGenerator(data2023);
            const regression2024 = regressionGenerator(data2024);
            const regression2025 = regressionGenerator(data2025);

            allRegressionValues = [
              ...allRegressionValues,
              ...regression2023.map((d) => d[1]),
              ...regression2024.map((d) => d[1]),
              ...regression2025.map((d) => d[1]),
            ];

            activityResults[activity] = {
              avg2023,
              avg2024,
              avg2025,
              percentChange2025vs2023,
              percentChange2025vs2024,
              regression2023,
              regression2024,
              regression2025,
            };
          }
        }

        if (Object.keys(activityResults).length === 3) {
          const cityMin = Math.min(...allRegressionValues);
          const cityMax = Math.max(...allRegressionValues);
          const yRange = cityMax - cityMin;
          const yPadding = yRange * 0.5;
          const paddedMin = cityMin - yPadding;
          const paddedMax = cityMax + yPadding;

          const xPadding = 5;
          const columnWidth = (chartWidth - 2 * xPadding) / 3;

          const getXPosition = (date, year) => {
            const d = new Date(date);
            const month = d.getMonth();
            const day = d.getDate();
            const monthOffset = month - 8;
            const daysInMonth = new Date(
              d.getFullYear(),
              month + 1,
              0,
            ).getDate();
            const dayFraction = day / daysInMonth;
            const positionInColumn = (monthOffset + dayFraction) / 4;
            const columnIndex = year - 2023;
            return (
              xPadding +
              columnIndex * columnWidth +
              positionInColumn * columnWidth
            );
          };

          const yScale = scaleLinear()
            .domain([paddedMin, paddedMax])
            .range([chartHeight - marginBottom, marginTop]);

          // Generate line paths for each activity
          const activityLines = {};
          for (const activity of activityTypes) {
            const res = activityResults[activity];

            const lineGen2023 = line()
              .x((d) => getXPosition(d[0], 2023))
              .y((d) => yScale(d[1]));
            const lineGen2024 = line()
              .x((d) => getXPosition(d[0], 2024))
              .y((d) => yScale(d[1]));
            const lineGen2025 = line()
              .x((d) => getXPosition(d[0], 2025))
              .y((d) => yScale(d[1]));

            activityLines[activity] = {
              line2023: lineGen2023(res.regression2023),
              line2024: lineGen2024(res.regression2024),
              line2025: lineGen2025(res.regression2025),
              percentChange2025vs2023: res.percentChange2025vs2023,
              percentChange2025vs2024: res.percentChange2025vs2024,
            };
          }

          // Calculate overall percent change (average of activities weighted equally)
          const avgPercentChange2025vs2023 = mean(
            activityTypes,
            (a) => activityResults[a].percentChange2025vs2023,
          );

          return {
            city,
            activityLines,
            percentageChange2025vs2023: avgPercentChange2025vs2023,
          };
        }
      }
    })
    .filter((value) => value !== undefined);

  // Choose which charts to display based on viewMode
  $: charts = viewMode === "overall" ? overallCharts : activityCharts;

  // Sort by 2025 vs 2023 change (greatest positive change first)
  $: sortedCharts = charts
    .slice()
    .sort(
      (a, b) => b.percentageChange2025vs2023 - a.percentageChange2025vs2023,
    );
</script>

<Header />

<main>
  <div class="text">
    <h1>Canada Recovery Trends</h1>
    <p>
      By <a href="https://schoolofcities.utoronto.ca/people/karen-chapple/"
        >Karen Chapple</a
      >,
      <a href="https://www.urbandisplacement.org/team/julia-greenberg/"
        >Julia Greenberg</a
      >,
      <a href="https://schoolofcities.utoronto.ca/people/jeff-allen/"
        >Jeff Allen</a
      >,
      <a href="https://www.linkedin.com/in/irene-kcc/">Irene Chang</a>
    </p>
    <p>
      <i>Updated {selection.update_date}</i>
    </p>
    <p>
      Data on cell phone activity (a.k.a. footfall) trends for the last two
      years provide a picture of how Canadian downtowns are faring. We look here
      at year-over-year trends comparing September {selection.year3} vs. {selection.year2}
      vs. {selection.year1}.
    </p>
    <p>
      The solid lines represent the number of daily unique visitors in the
      downtown area, both displayed on the same September-to-September timeline
      for direct comparison. The red line shows the Sept
      {selection.year1} to Sept {selection.year2} period and the orange line shows
      the Sept
      {selection.year2} to Sept {selection.year3} period, with the {selection.year3}.
      The dotted line provides a baseline of the average level of activity in
      September {selection.year1}, allowing for comparison to the following
      years. When the solid lines extend above the dotted baseline, downtown
      activity is greater compared to September {selection.year1}. When they dip
      below the dotted line, activity is on a downswing.
    </p>
    <!-- <h5>
			Key Findings:
		</h5> -->
    <!-- <p>
			Comparing {selection.monthName} {selection.year1} to {selection.monthName} {selection.year2}:
			<br>
	
			‣ <span class="bold">All 10</span> downtowns are in an upward trajectory.  -->
    <!-- , while <span class="bold">???</span> are trending downwards.  -->
    <!-- <br>
			‣ The median rate of change is <span class="bold">???%</span>.
		</p> -->
    <p>
      Note: Trends are based on data from Spectus, but use different cell phone
      data providers from our rankings analysis. The trendlines measure the
      average level of activity over the course of the year, while the ranking
      metric shows the percent difference in the average number of unique
      visitors in {selection.year3} versus the same month in {selection.year2}.
    </p>

    <h4>Map: 2025 vs 2023 Percent Change by City</h4>
    <p>
      Click on a city marker to see details. Green indicates positive change,
      red indicates negative change.
    </p>
  </div>

  <!-- Map container -->
  <div class="map-wrapper">
    <div bind:this={mapContainer} class="map-container"></div>
    <div class="map-legend">
      <div class="legend-title">% Change (2025 vs 2023)</div>
      <div class="legend-gradient"></div>
      <div class="legend-labels">
        <span>−15%</span>
        <span>0%</span>
        <span>+50%</span>
      </div>
    </div>
  </div>

  <div class="text">
    <h4>
      Visits to Downtown (September to December from {selection.year1} to {selection.year3})
    </h4>

    <!-- View Mode Toggle -->
    <div class="view-toggle">
      <span class="toggle-label">View Mode:</span>
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

    <!-- Legend for Overall mode -->
    {#if viewMode === "overall"}
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
          {selection.year1} average
        </div>

        <div style="display: flex; align-items: center; gap: 8px;">
          <svg height="10" width="50">
            <line x1="0" y1="5" x2="50" y2="5" stroke="blue" stroke-width="2" />
          </svg>
          {selection.year1}
        </div>

        <div style="display: flex; align-items: center; gap: 8px;">
          <svg height="10" width="50">
            <line x1="0" y1="5" x2="50" y2="5" stroke="red" stroke-width="2" />
          </svg>
          {selection.year2}
        </div>

        <div style="display: flex; align-items: center; gap: 8px;">
          <svg height="10" width="50">
            <line
              x1="0"
              y1="5"
              x2="50"
              y2="5"
              stroke="orange"
              stroke-width="2"
            />
          </svg>
          {selection.year3}
        </div>
      </div>
    {:else}
      <!-- Legend for Activity breakdown mode -->
      <div
        style="display: flex; align-items: center; gap: 20px; padding: 10px 0; flex-wrap: wrap;"
      >
        <div style="display: flex; align-items: center; gap: 8px;">
          <svg height="10" width="50">
            <line
              x1="0"
              y1="5"
              x2="50"
              y2="5"
              stroke={activityColors.WORK}
              stroke-width="2"
            />
          </svg>
          Work
        </div>

        <div style="display: flex; align-items: center; gap: 8px;">
          <svg height="10" width="50">
            <line
              x1="0"
              y1="5"
              x2="50"
              y2="5"
              stroke={activityColors.HOME}
              stroke-width="2"
            />
          </svg>
          Home
        </div>

        <div style="display: flex; align-items: center; gap: 8px;">
          <svg height="10" width="50">
            <line
              x1="0"
              y1="5"
              x2="50"
              y2="5"
              stroke={activityColors.NEITHER}
              stroke-width="2"
            />
          </svg>
          Visitor
        </div>
      </div>
    {/if}
  </div>

  <div class="chart-wrapper">
    <div class="left">
      <svg width="760" height={chartHeight} class="region-bar">
        <text x="12" y="35" class="textCity">City</text>

        {#if viewMode === "overall"}
          <text x="235" y="15" class="textLabel">Percent Change in Visits</text>
          <text x="235" y="35" class="textLabel"
            >{selection.year3} vs. {selection.year1}</text
          >
          <text x="235" y="50" class="textLabelSmall"
            >{selection.year3} vs. {selection.year2}
          </text>
        {:else}
          <text x="235" y="20" class="textLabel">% Change by Activity</text>
          <text x="235" y="38" class="textLabelSmall"
            >{selection.year3} vs. {selection.year1}</text
          >
          <text
            x="175"
            y="52"
            class="textActivityLabel"
            fill={activityColors.WORK}>Work</text
          >
          <text
            x="205"
            y="52"
            class="textActivityLabel"
            fill={activityColors.HOME}>Home</text
          >
          <text
            x="235"
            y="52"
            class="textActivityLabel"
            fill={activityColors.NEITHER}>Visitor</text
          >
        {/if}

        <line
          x1="260"
          y1={45}
          x2={260 + chartWidth}
          y2={45}
          stroke="white"
          stroke-width="1"
        />

        <!-- Draw 3 columns for 3 years -->
        {#each [0, 1, 2] as yearIndex}
          {#each [9, 10, 11, 12] as month, i}
            <line
              x1={260 + yearIndex * (chartWidth / 3) + (i * chartWidth) / 3 / 4}
              y1={45}
              x2={260 + yearIndex * (chartWidth / 3) + (i * chartWidth) / 3 / 4}
              y2={40}
              stroke="white"
              stroke-width="1"
            />

            <text
              x={260 +
                yearIndex * (chartWidth / 3) +
                (i * chartWidth) / 3 / 4 +
                chartWidth / 3 / 8}
              y="40"
              class="textMonth">{month}</text
            >
          {/each}

          <!-- Year labels -->
          <text
            x={260 + yearIndex * (chartWidth / 3) + chartWidth / 6}
            y="20"
            class="textYear">{2023 + yearIndex}</text
          >

          <!-- Vertical separator lines between years -->
          {#if yearIndex < 2}
            <line
              x1={260 + (yearIndex + 1) * (chartWidth / 3)}
              y1={5}
              x2={260 + (yearIndex + 1) * (chartWidth / 3)}
              y2={45}
              stroke="white"
              stroke-width="2"
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
            stroke="#fff"
            stroke-width="5"
          />

          <text x="12" y="31" class="textCity">{i + 1}. {chartData.city}</text>
        </svg>
      </div>

      <div class="arrow">
        {#if chartData.percentageChange2025vs2023 > 0}
          <img src={upArrow} alt="Up arrow" class="arrow-icon" />
        {:else if chartData.percentageChange2025vs2023 < 0}
          <img src={downArrow} alt="Down arrow" class="arrow-icon" />
        {/if}
      </div>

      <div class="number">
        {#if viewMode === "overall"}
          <span class="percent-main">{chartData.perChange2025Display},</span>
          <span class="percent-secondary">{chartData.perChange2024Display}</span
          >
        {:else}
          <!-- Activity breakdown percentages -->
          <div class="activity-percents">
            {#each activityTypes as activity}
              <span
                class="activity-percent"
                style="color: {activityColors[activity]}"
              >
                {chartData.activityLines[
                  activity
                ].percentChange2025vs2023.toFixed(1)}%
              </span>
            {/each}
          </div>
        {/if}
      </div>

      <div class="chart-container" style="width: {chartWidth};">
        <svg height={chartHeight} width={chartWidth} class="chart">
          <!-- Grid lines for 3 columns -->
          {#each [0, 1, 2] as yearIndex}
            {#each [1, 2, 3] as tick}
              <line
                x1={yearIndex * (chartWidth / 3) + (tick * chartWidth) / 3 / 4}
                y1={5}
                x2={yearIndex * (chartWidth / 3) + (tick * chartWidth) / 3 / 4}
                y2={45}
                stroke="#333333"
                stroke-width="1"
              />
            {/each}
            <!-- Vertical separator between years -->
            {#if yearIndex < 2}
              <line
                x1={(yearIndex + 1) * (chartWidth / 3)}
                y1={5}
                x2={(yearIndex + 1) * (chartWidth / 3)}
                y2={45}
                stroke="#555555"
                stroke-width="2"
              />
            {/if}
          {/each}

          {#if viewMode === "overall"}
            <!-- OVERALL VIEW: Year-based lines -->
            <!-- Baseline -->
            <line
              x1="0"
              y1={chartData.meanLine}
              x2={chartWidth}
              y2={chartData.meanLine}
              stroke="#D0D1C9"
              stroke-width="1"
              stroke-dasharray="4"
            />

            <!-- 2023 regression line (blue) -->
            <path
              d={chartData.regressionLine2023}
              stroke="blue"
              stroke-width="2"
              fill="none"
            />

            <!-- 2024 regression line (red) -->
            <path
              d={chartData.regressionLine2024}
              stroke="red"
              stroke-width="2"
              fill="none"
            />

            <!-- 2025 regression line (orange) -->
            <path
              d={chartData.regressionLine2025}
              stroke="orange"
              stroke-width="2"
              fill="none"
            />

            <!-- Start and end circles for 2023 line -->
            <circle
              cx={chartData.startCircle2023.cx}
              cy={chartData.startCircle2023.cy}
              r="1"
              fill="blue"
              stroke="blue"
              stroke-width="2"
            />
            <circle
              cx={chartData.endCircle2023.cx}
              cy={chartData.endCircle2023.cy}
              r="1"
              fill="blue"
              stroke="blue"
              stroke-width="2"
            />

            <!-- Start and end circles for 2024 line -->
            <circle
              cx={chartData.startCircle2024.cx}
              cy={chartData.startCircle2024.cy}
              r="1"
              fill="red"
              stroke="red"
              stroke-width="2"
            />
            <circle
              cx={chartData.endCircle2024.cx}
              cy={chartData.endCircle2024.cy}
              r="1"
              fill="red"
              stroke="red"
              stroke-width="2"
            />

            <!-- Start and end circles for 2025 line -->
            <circle
              cx={chartData.startCircle2025.cx}
              cy={chartData.startCircle2025.cy}
              r="1"
              fill="orange"
              stroke="orange"
              stroke-width="2"
            />
            <circle
              cx={chartData.endCircle2025.cx}
              cy={chartData.endCircle2025.cy}
              r="1"
              fill="orange"
              stroke="orange"
              stroke-width="2"
            />
          {:else}
            <!-- ACTIVITY BREAKDOWN VIEW: Activity-based lines -->
            {#each activityTypes as activity}
              <!-- 2023 line for this activity -->
              <path
                d={chartData.activityLines[activity].line2023}
                stroke={activityColors[activity]}
                stroke-width="2"
                fill="none"
                opacity="0.5"
              />
              <!-- 2024 line for this activity -->
              <path
                d={chartData.activityLines[activity].line2024}
                stroke={activityColors[activity]}
                stroke-width="2"
                fill="none"
                opacity="0.7"
              />
              <!-- 2025 line for this activity -->
              <path
                d={chartData.activityLines[activity].line2025}
                stroke={activityColors[activity]}
                stroke-width="2"
                fill="none"
              />
            {/each}
          {/if}
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
      <a href="/trend_canada_sep1_2023_to_sep30_2025.csv">from this link</a>.
      The data on the charts are based on the `normalized_distinct_clean`
      column, which pertains to the number of unique daily visitors normalized
      by the total number in the metro area. The trend-line and summary
      statistics shown are calculated in JavaScript (code is on
      <a
        href="https://github.com/schoolofcities/downtown-recovery/blob/main/src/routes/charts/canada_trends/%2Bpage.svelte"
        target="_blank">GitHub</a
      >). Note: Quebec & Montreal data is limited to September 26, 2025.
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

  .textActivityLabel {
    font-family: Roboto;
    font-size: 11px;
    font-weight: bold;
    text-anchor: end;
  }

  .textMonth {
    font-family: Roboto;
    font-size: 14px;
    text-anchor: middle;
    fill: var(--brandWhite);
  }

  .textYear {
    font-family: Roboto;
    font-size: 13px;
    font-weight: bold;
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
  }
  .chart {
    margin-left: 10px;
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

  /* Toggle button styles */
  .view-toggle {
    display: flex;
    align-items: center;
    gap: 10px;
    margin: 15px 0;
  }

  .toggle-label {
    font-family: Roboto;
    font-size: 14px;
    color: var(--brandWhite);
  }

  .toggle-btn {
    font-family: Roboto;
    font-size: 14px;
    padding: 8px 16px;
    border: 1px solid #555;
    background-color: #333;
    color: #ccc;
    cursor: pointer;
    border-radius: 4px;
    transition: all 0.2s ease;
  }

  .toggle-btn:hover {
    background-color: #444;
  }

  .toggle-btn.active {
    background-color: var(--brandLightBlue, #4a90d9);
    color: white;
    border-color: var(--brandLightBlue, #4a90d9);
  }

  /* Activity percentage styles */
  .activity-percents {
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    gap: 0;
    margin-right: 10px;
    padding-top: 5px;
  }

  .activity-percent {
    font-family: Roboto;
    font-size: 11px;
    font-weight: bold;
    line-height: 1.3;
  }

  .arrow {
    margin: auto 4px auto -13px;
    width: 32px;
    height: 40px;
    display: flex;
    justify-content: center;
    align-items: center;
    transform: translateX(-8px);
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

  /* Map styles */
  .map-wrapper {
    max-width: 900px;
    margin: 20px auto;
    padding: 0 20px;
    position: relative;
  }

  .map-container {
    width: 100%;
    height: 500px;
    border-radius: 8px;
    border: 1px solid #333;
  }

  .map-legend {
    position: absolute;
    bottom: 30px;
    right: 40px;
    background: rgba(30, 30, 30, 0.9);
    padding: 10px 15px;
    border-radius: 6px;
    border: 1px solid #444;
  }

  .legend-title {
    font-family: Roboto;
    font-size: 12px;
    color: #fff;
    margin-bottom: 8px;
    text-align: center;
  }

  .legend-gradient {
    width: 150px;
    height: 12px;
    background: linear-gradient(to right, #6c0601, #db4126, #1a9850);
    border-radius: 2px;
  }

  .legend-labels {
    display: flex;
    justify-content: space-between;
    font-family: Roboto;
    font-size: 10px;
    color: #ccc;
    margin-top: 4px;
  }

  :global(.maplibregl-popup-content) {
    background: #fff;
    padding: 10px 15px;
    border-radius: 6px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
  }

  :global(.maplibregl-popup-close-button) {
    font-size: 18px;
    padding: 5px 10px;
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
