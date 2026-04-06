<script>
	import Header from "../../../lib/Header.svelte";
	import { onMount } from 'svelte';
	import { csvParse } from 'd3-dsv';
	import { scaleTime, scaleLinear, timeParse, line} from "d3";
	import { regressionLoess } from "d3-regression";
	import { min, max, mean} from 'd3-array';
	import { cities } from '../../../lib/stores.js';

	import upArrow from '../../../assets/green-arrow.svg';
	import downArrow from '../../../assets/red-arrow.svg';

	import "../../../assets/global.css";

	let selection = {
		year1: 2023,
		year2: 2024,
		year3: 2025,
		update_date: "2025-03-25" // change this to whenever website is updated
	}

	// Comparison mode toggle
	let compareMode = "2025vs2023"; // "2025vs2023" or "2025vs2024"

	let isLoadingOverall = true;
	let overallChartsCache = null;

	async function loadData() {
		isLoadingOverall = true;
		try {
			const response = await fetch('/can_msa_normed_data_SIERRA_20230101_20251231.csv');
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
		filteredCities = cities
			.filter(item => item.region==='Canada')
			.map(item => item.city);
	});

	let width;

	let chartWidth = 500;
	const chartHeight = 50;

	const marginTop = 0;
	const marginRight = 5;
	const marginBottom = 0;
	const marginLeft = 5;

	const parseDate = timeParse("%Y-%m-%d");

	let thecities = [];
	let charts = [];
	let sortedCharts = [];

	$: filteredCities = cities
			.filter(item => item.region==='Canada')
			.map(item => item.city);

	// Get normalized value from data
	function getValue(item) {
		return parseFloat(item.normalized_distinct || 0);
	}

	$: charts = (() => {
		// Return cached charts if available
		if (overallChartsCache !== null) {
			return overallChartsCache;
		}

		if (thecities.length === 0 || data.length === 0) {
			return [];
		}

		const generatedCharts = thecities.map(city => {
			if (filteredCities.includes(city)) {

				// Filter data for each year (full year Jan 1 - Dec 31)
				const cityData2023 = data.filter(item => {
					const date = new Date(item.date);
					return item.city === city &&
						date >= new Date("2023-01-01") &&
						date <= new Date("2023-12-31");
				});

				const cityData2024 = data.filter(item => {
					const date = new Date(item.date);
					return item.city === city &&
						date >= new Date("2024-01-01") &&
						date <= new Date("2024-12-31");
				});

				const cityData2025 = data.filter(item => {
					const date = new Date(item.date);
					return item.city === city &&
						date >= new Date("2025-01-01") &&
						date <= new Date("2025-12-31");
				});

				if (cityData2023.length > 0 && cityData2024.length > 0 && cityData2025.length > 0) {

					// Calculate averages for each year
					const avg2023 = mean(cityData2023, d => getValue(d));
					const avg2024 = mean(cityData2024, d => getValue(d));
					const avg2025 = mean(cityData2025, d => getValue(d));

					// Calculate percentage changes
					const percentageChange2025vs2024 = ((avg2025 - avg2024) / avg2024) * 100;
					const percentageChange2025vs2023 = ((avg2025 - avg2023) / avg2023) * 100;

					// Combine all city data for ONE continuous LOESS regression
					const allCityData = [...cityData2023, ...cityData2024, ...cityData2025];

					// ONE LOESS regression across all 3 years
					const regressionGenerator = regressionLoess()
						.x((d) => parseDate(d.date))
						.y((d) => getValue(d))
						.bandwidth(0.033);
					const regressionData = regressionGenerator(allCityData);

					// Calculate scales
					const allRegressionValues = regressionData.map(d => d[1]);
					const cityMin = Math.min(...allRegressionValues);
					const cityMax = Math.max(...allRegressionValues);

					// X scale - 3 columns for 3 years
					const xPadding = 5;
					const columnWidth = (chartWidth - 2 * xPadding) / 3;

					// Custom position function for 3 separate columns (12 months each)
					const getXPosition = (date) => {
						const d = new Date(date);
						const year = d.getFullYear();
						const month = d.getMonth(); // 0-11
						const day = d.getDate();
						const daysInMonth = new Date(d.getFullYear(), month + 1, 0).getDate();
						const dayFraction = day / daysInMonth;
						const positionInColumn = (month + dayFraction) / 12; // 0-1 within 12 months

						// Determine which column (0=2023, 1=2024, 2=2025)
						const columnIndex = year - 2023;

						return xPadding + columnIndex * columnWidth + positionInColumn * columnWidth;
					};

					// Add vertical padding to make trends easier to read and avoid clipping at top/bottom
					const yPadding = (cityMax - cityMin) * 0.1; // 10% padding
					const yScale = scaleLinear()
						.domain([cityMin - yPadding, cityMax + yPadding])
						.range([chartHeight - marginBottom, marginTop]);

					// Create one continuous line path
					const lineGenerator = line()
						.x(d => getXPosition(d[0]))
						.y(d => yScale(d[1]));

					const regressionLine = lineGenerator(regressionData);

					// Circles for start and end points
					const startCircle = {
						cx: getXPosition(regressionData[0][0]),
						cy: yScale(regressionData[0][1])
					};
					const endCircle = {
						cx: getXPosition(regressionData[regressionData.length - 1][0]),
						cy: yScale(regressionData[regressionData.length - 1][1])
					};

					// Baseline (2023 average)
					const meanLine = yScale(avg2023);

					return {
						city: city,
						regressionLine: regressionLine,
						startCircle: startCircle,
						endCircle: endCircle,
						meanLine: meanLine,
						percentageChange2025vs2024: percentageChange2025vs2024,
						percentageChange2025vs2023: percentageChange2025vs2023,
						perChange2025Display: percentageChange2025vs2023.toFixed(2) + "%",
						perChange2024Display: percentageChange2025vs2024.toFixed(2) + "%",
					};
				}

			}
		}).filter(value => value !== undefined);

		// Cache the generated charts and update loading state
		if (generatedCharts.length > 0) {
			overallChartsCache = generatedCharts;
			setTimeout(() => { isLoadingOverall = false; }, 0);
		}

		return generatedCharts;
	})();

	// Get effective change based on compare mode
	function getEffectiveChange(chartData) {
		return compareMode === "2025vs2023"
			? chartData.percentageChange2025vs2023
			: chartData.percentageChange2025vs2024;
	}

	// Sort charts based on selected comparison mode
	// Explicitly depend on compareMode to trigger re-sort
	$: sortedCharts = (compareMode, charts.slice().sort((a, b) => {
		const aChange = compareMode === "2025vs2023"
			? a.percentageChange2025vs2023
			: a.percentageChange2025vs2024;
		const bChange = compareMode === "2025vs2023"
			? b.percentageChange2025vs2023
			: b.percentageChange2025vs2024;
		return bChange - aChange;
	}));

	// Key findings statistics
	$: totalCities = charts.length;
	$: citiesRising2023 = charts.filter(c => c.percentageChange2025vs2023 > 0).length;
	$: citiesRising2024 = charts.filter(c => c.percentageChange2025vs2024 > 0).length;
	$: mean2023Change = charts.length > 0 ? mean(charts, c => c.percentageChange2025vs2023) : null;
	$: mean2024Change = charts.length > 0 ? mean(charts, c => c.percentageChange2025vs2024) : null;

</script>


<Header />

<main>
	<div class="text">

		<h1>
			Canada Recovery Trends
		</h1>
		    <p>
				By <a href="https://schoolofcities.utoronto.ca/people/karen-chapple/" target="_blank"
					>Karen Chapple</a
				>,
				<a href="https://www.linkedin.com/in/yihoi-jung-0b95351b5/" target="_blank">Yihoi Jung</a>,
				<a href="https://schoolofcities.utoronto.ca/people/jeff-allen/" target="_blank"
					>Jeff Allen</a
				>
			</p>
		<p>
			<i>Updated {selection.update_date}</i>
		</p>
		<p>
			Data on cell phone activity (a.k.a. footfall) trends for the last three years provide a picture of how Canadian downtowns are faring. We look here at year-over-year trends comparing {selection.year3} to {selection.year2} and {selection.year1}.
		</p>
		<p>
			The solid lines on the charts below represent the number of daily unique devices in the downtown area, split by the three years for comparison. The dotted lines provide a baseline of the average level of activity in {selection.year1}, allowing for comparison to the following years. When the solid lines extend above the dotted baseline, downtown activity is greater compared to {selection.year1}. When they dip below the dotted line, activity is on a downswing.
		</p>
		<h5>Key findings:</h5>
		<p>
			‣ <span class="bold">{citiesRising2024}</span> out of
			<span class="bold">{totalCities}</span>
			Canadian cities rose in activity in {selection.year3} compared to {selection.year2}, with a mean change of
			<span class="bold">{mean2024Change?.toFixed(1) ?? "..."}%</span>.
			<br />
			‣ Compared to {selection.year1}, <span class="bold">{citiesRising2023}</span> out of
			<span class="bold">{totalCities}</span>
			cities saw increases, with a mean change of
			<span class="bold">{mean2023Change?.toFixed(1) ?? "..."}%</span>.
		</p>
		<p>
			Note: Trends are based on data from Spectus, but use different cell phone data providers from our rankings analysis. The trendlines measure the average level of activity over the course of the year, while the ranking metric shows the percent difference in the average number of unique devices in {selection.year3} versus the same period in {selection.year2} or {selection.year1}.
		</p>

	</div>

	<div class="text">
		<h4>Unique Devices Downtown ({selection.year1} to {selection.year3})</h4>

		<!-- Comparison Toggle -->
		<div class="view-toggle">
			<div class="toggle-group">
				<span class="toggle-label">Compare:</span>
				<button
					class="toggle-btn"
					class:active={compareMode === "2025vs2023"}
					on:click={() => (compareMode = "2025vs2023")}
				>
					{selection.year3} vs {selection.year1}
				</button>
				<button
					class="toggle-btn"
					class:active={compareMode === "2025vs2024"}
					on:click={() => (compareMode = "2025vs2024")}
				>
					{selection.year3} vs {selection.year2}
				</button>
			</div>
		</div>

		<!-- Legend -->
		<div style="display: flex; align-items: center; gap: 20px; padding: 10px 0; flex-wrap: wrap;">
			<div style="display: flex; align-items: center; gap: 8px;">
				<svg height="10" width="50">
					<line x1="0" y1="5" x2="50" y2="5" stroke="white" stroke-width="1" stroke-dasharray="4"/>
				</svg>
				{selection.year1} average
			</div>
		</div>
	</div>

	<!-- Loading spinner -->
	{#if isLoadingOverall}
		<div class="loading-container">
			<div class="loading-spinner"></div>
			<p class="loading-text">Loading data...</p>
		</div>
	{:else}
		<div class="charts-scroll-container">
			<div class="charts-inner">
				<div class="chart-wrapper">

					<div class="left">

						<svg width="760" height="{chartHeight}" class="region-bar">

					<text
						x="12"
						y="35"
						class="textCity"
					>City</text>

					<text
						x="235"
						y="15"
						class="textLabelSmall"
					>% Change in Unique Devices</text>

					<text
						x="235"
						y="38"
						class="textLabel"
					>{compareMode === "2025vs2023"
						? `${selection.year3} vs. ${selection.year1}`
						: `${selection.year3} vs. ${selection.year2}`}</text>

					<line x1="260" y1={45} x2={260 + chartWidth} y2={45} stroke="white" stroke-width="1" />

					<!-- Draw 3 columns for 3 years -->
					{#each [0, 1, 2] as yearIndex}
						{#each [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] as month, i}
							{#if i % 3 === 0}
								<line
									x1={260 + yearIndex * (chartWidth / 3) + (i * chartWidth / 3 / 12)}
									y1={45}
									x2={260 + yearIndex * (chartWidth / 3) + (i * chartWidth / 3 / 12)}
									y2={40}
									stroke="white"
									stroke-width="1"
								/>
								<text
									x={260 + yearIndex * (chartWidth / 3) + ((i + 1.5) * chartWidth / 3 / 12)}
									y="40"
									class="textMonth"
								>{month}</text>
							{/if}
						{/each}

						<!-- Year labels -->
						<text
							x={260 + yearIndex * (chartWidth / 3) + chartWidth / 6}
							y="20"
							class="textYear"
						>{2023 + yearIndex}</text>

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
					<svg width="150" height="{chartHeight}" class="region-bar">

						<line x1="5" y1="15" x2="5" y2="{chartHeight - 15}" stroke="#fff" stroke-width= "5"/>

						<text
							x="12"
							y="31"
							class="textCity"
						>{i + 1}. {chartData.city}</text>

					</svg>
				</div>

				<div class="arrow">
					{#if getEffectiveChange(chartData) >= 0}
						<img src={upArrow} alt="Up arrow" class="arrow-icon"/>
					{:else}
						<img src={downArrow} alt="Down arrow" class="arrow-icon"/>
					{/if}
				</div>

				<div class="number">
					<span class="percent-main">
						{compareMode === "2025vs2023"
							? chartData.perChange2025Display
							: chartData.perChange2024Display}
					</span>
				</div>

				<div class="chart-container" style="width: {chartWidth};">
					<svg height={chartHeight} width={chartWidth} class="chart">

						<!-- Grid lines for 3 columns -->
						{#each [0, 1, 2] as yearIndex}
							{#each [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11] as tick}
								<line
									x1={yearIndex * (chartWidth / 3) + (tick * chartWidth / 3 / 12)}
									y1={5}
									x2={yearIndex * (chartWidth / 3) + (tick * chartWidth / 3 / 12)}
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

						<!-- Baseline (2023 average) -->
						<line x1="0" y1={chartData.meanLine} x2={chartWidth} y2={chartData.meanLine} stroke="#D0D1C9" stroke-width="1" stroke-dasharray="4"/>

						<!-- One continuous line -->
						<path d={chartData.regressionLine} stroke="white" stroke-width="2" fill="none"/>
						<circle cx={chartData.startCircle.cx} cy={chartData.startCircle.cy} r="2" fill="white"/>
						<circle cx={chartData.endCircle.cx} cy={chartData.endCircle.cy} r="2" fill="white"/>

					</svg>
				</div>


			</div>
		{/each}
		</div>
	</div>
	{/if}

	<div class="text">

		<br>
		<br>


		<h4>
			More Information
		</h4>

		<p>
			The trend lines are fit from daily data via a <a href="https://en.wikipedia.org/wiki/Local_regression">LOESS</a> curve. You can download the raw daily data shown to fit these curves <a href="/can_msa_normed_data_SIERRA_20230101_20251231.csv">from this link</a>. The data on the charts are based on the `normalized_distinct` column, which pertains to the number of unique daily devices normalized by the total number in the metro area. The trend-line and summary statistics shown are calculated in JavaScript (code is on <a href="https://github.com/schoolofcities/downtown-recovery/blob/main/src/routes/charts/canada_trends_update/%2Bpage.svelte" target="_blank">GitHub</a>)
			</p>

		<br>

		<br>

	</div>
</main>

<style>
	.charts-scroll-container {
		overflow-x: auto;
		margin: 0 auto;
		max-width: 100%;
	}

	.charts-inner {
		min-width: 760px;
	}

	.chart-wrapper {
		display: flex;
		margin: 0 auto;
		padding-left: 5px;
		padding-right: 5px;
		margin-bottom: 0px;
		max-width: 760px;
		height: 53px;
		background-color: var(--brandGray90);
		border-bottom: solid 1px var(--brandDarkBlue);
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

	.textYear {
		font-family: Roboto;
		font-size: 14px;
		font-weight: bold;
		text-anchor: middle;
		fill: var(--brandWhite);
	}

	.left {
		width: 150px;
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
		margin-left:20px;
	}

	.number {
		width: 50px;
		display: flex;
		align-items: center;
		justify-content: flex-end;
	}

	.percent-main {
		font-family: Roboto;
		font-size: 16px;
		color: var(--brandWhite);
	}

	.arrow {
		margin: auto 0;
		width: 40px;
		height: 40px;
		align-items: center;
	}
	.arrow-icon{
		margin: auto 0;
		width: 40px;
		height: 40px;
		align-items: center;
	}

	.text {
		border-bottom: none;
	}

	/* Toggle styles */
	.view-toggle {
		display: flex;
		flex-wrap: wrap;
		gap: 20px;
		padding: 15px 0;
	}

	.toggle-group {
		display: flex;
		align-items: center;
		gap: 8px;
	}

	.toggle-label {
		font-family: Roboto;
		font-size: 14px;
		color: var(--brandWhite);
	}

	.toggle-btn {
		font-family: Roboto;
		font-size: 13px;
		padding: 6px 12px;
		border: 1px solid var(--brandWhite);
		background: transparent;
		color: var(--brandWhite);
		cursor: pointer;
		border-radius: 4px;
		transition: all 0.2s ease;
	}

	.toggle-btn:hover {
		background: rgba(255, 255, 255, 0.1);
	}

	.toggle-btn.active {
		background: var(--brandWhite);
		color: var(--brandDarkBlue);
	}

	/* Loading spinner styles */
	.loading-container {
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		padding: 60px 20px;
		min-height: 200px;
	}

	.loading-spinner {
		width: 50px;
		height: 50px;
		border: 4px solid var(--brandGray90);
		border-top: 4px solid var(--brandLightBlue);
		border-radius: 50%;
		animation: spin 1s linear infinite;
	}

	@keyframes spin {
		0% { transform: rotate(0deg); }
		100% { transform: rotate(360deg); }
	}

	.loading-text {
		margin-top: 15px;
		font-family: Roboto;
		font-size: 14px;
		color: var(--brandWhite);
	}

	h5 {
		font-size: 16px;
		font-family: Roboto;
		color: var(--brandWhite);
		margin-bottom: 5px;
	}

	.bold {
		font-weight: bold;
	}
</style>
