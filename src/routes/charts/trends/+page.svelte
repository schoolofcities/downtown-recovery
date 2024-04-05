<script>
	import Header from "../../../lib/Header.svelte";
	import SelectRegions from "../../../lib/SelectRegions.svelte";
	import { onMount } from 'svelte';
	import { csvParse } from 'd3-dsv';
	import { scaleTime, scaleLinear, timeParse, line} from "d3";
	import { regressionLoess } from "d3-regression";
	import { min, max, mean} from 'd3-array';

	import { regions, selectedRegions, cities } from '../../../lib/stores.js';
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
		filteredCities = cities
			.filter(item => $selectedRegions.includes(item.region))
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
	let charts = []; // to hold chart data for each city
	let sortedCharts = []; // to hold the sorted charts


	$: filteredCities = cities
		.filter(item => $selectedRegions.includes(item.region))
		.map(item => item.city);

	// function createCharts(data) {

	$: charts = thecities.map(city => {
			if (filteredCities.includes(city)) {
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
			
			}
		// });

		
	}).filter(value => value !== undefined);

	// Sort charts based on percentageChange descending order
	$: sortedCharts = charts.slice().sort((a,b) => b.percentageChange - a.percentageChange);

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

	// $: {
	// 	createCharts(data);
	// }
	
</script>





<Header />

<main>
	<div class="text">

		<h1>
			Recovery Trends
		</h1>
		<p>
			By <a href="https://">Karen Chapple</a>, <a href="https://">Julia Greenberg</a>, <a href="https://">Jeff Allen</a>, <a href="https://">Irene Chang</a> 
		</p>
		<p>
			<i>Updated April 2024</i>
		</p>
		<p>
			Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
		</p>
		<p>
			Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
		</p>

		<p>
			Select Regions:
		</p>

		<SelectRegions europe={"no"} canada={"yes"}/>

		<br>
		<br>

	</div>

		{#each sortedCharts as { city, regressionLine, startCircle, endCircle, meanLine, perChangeDisplay, percentageChange}, i}
			<div class="chart-wrapper" bind:clientWidth={width}>
				<div class="left">
					<svg width="150" height="{chartHeight}" class="region-bar">
						
						<line x1="5" y1="15" x2="5" y2="{chartHeight - 15}" stroke={getRegionColor(city)} stroke-width= "5"/>
						
						<text
							x="12"
							y="31"
							class="textCity"
						>{i + 1}. {city}</text>

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
					{#if percentageChange > 0}
						<img src={upArrow} alt="Up arrow" class="arrow-icon"/>
					{:else if percentageChange < 0}
						<img src={downArrow} alt="Down arrow" class="arrow-icon"/>
					{/if}
				</div>
				
				<div class="number">
					<svg width="50" height="{chartHeight}" class="region-bar">
						<text
							x="46"
							y="45"
							class="textPercent"
						>{perChangeDisplay}</text>
					
					</svg>
					<!-- <h5>{perChangeDisplay}</h5> -->
				</div>
				
				<div class="chart-container" style="width: {chartWidth};">
					<svg height={chartHeight} width={chartWidth} class="chart">
						<!-- Top line -->
						<!-- <line x1="0" y1="0" x2={chartWidth} y2="0" stroke="gray" stroke-width="1"/>  -->
						<!-- Middle line -->
						<line x1="0" y1={meanLine} x2={chartWidth} y2={meanLine} stroke="gray" stroke-width="1" stroke-dasharray="4"/>
						<!-- Bottom line -->
						<!-- <line x1="0" y1={chartHeight} x2={chartWidth} y2={chartHeight} stroke="gray" stroke-width="1"/> -->
						<!-- <path d={regressionLine} stroke={getRegionColor(city)} stroke-width="2" fill="none"/> -->
						<path d={regressionLine} stroke="white" stroke-width="2" fill="none"/>
						<!-- First point -->
						<circle cx={startCircle.cx} cy={startCircle.cy} r="2" fill="white"/>
						<!-- Last point -->
						<circle cx={endCircle.cx} cy={endCircle.cy} r="2" fill="white" stroke="white" />
					</svg>
				</div>

				
				
			</div>
		{/each}

	<div class="text">

		<br>

		<br>

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
		border-bottom: solid 1px var(--brandGray80);
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
		margin-left:20px;
	}

	.number {
		width: 50px;
		margin-top: -12px;
		/* background-color: var(--brandDarkBlue); */
	}
	.textPercent {
		font-family: Roboto;
		font-size: 16px;
		text-anchor: end;
		fill: var(--brandWhite);
	}

	.arrow {
		margin: auto 0;
		width: 40px;
		height: 40px;
		align-items: center;
		/* background-color: var(--brandDarkGreen); */
	}
	.arrow-icon{
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