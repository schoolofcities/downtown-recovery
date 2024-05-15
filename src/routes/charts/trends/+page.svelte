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

	import upArrow from '../../../assets/green-arrow.svg';
	import downArrow from '../../../assets/red-arrow.svg';
	// import upArrow from '/src/assets/green-arrow-circle.svg';
	// import downArrow from '/src/assets/red-arrow-circle.svg';

	let selection = {
		"monthName": "April",
		"monthNumber": 4,
		"year1": 2023,
		"year2": 2024,
		"day1": "2023-04-01",
		"day2": "2024-04-30"
	}

	async function loadData() {
		try {
			const response = await fetch('/trends.csv');
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

				const cityData = data.filter(
					item => {
						const date = new Date(item.date);
						const day1 = new Date(selection.day1);
						const day2 = new Date(selection.day2);
						return item.city === city && date >= day1 && date <= day2
					}
				);

				if (cityData.length > 0) {

					console.log("cityData");

					const normalizedDistinctCleanValues = cityData.map(item => parseFloat(item.normalized_distinct_clean));

					

					// Filter data for March 2023 for the current city
					const month1data = data.filter(item => {
						const date = new Date(item.date);
						return date.getFullYear() === selection.year1 && date.getMonth() === (selection.monthNumber - 1) && item.city === city;
					});

					// Calculate mean for March 2023 for the current city
					const month1 = mean(month1data, d => parseFloat(d.normalized_distinct_clean));
					
					// Filter data for Feb 2024 for the current city
					const month2data = data.filter(item => {
						const date = new Date(item.date);
						return date.getFullYear() === selection.year2 && date.getMonth() === (selection.monthNumber - 1) && item.city === city;
					});

					// Calculate mean for Feb 2024 for the current city
					const month2 = mean(month2data, d => parseFloat(d.normalized_distinct_clean));

					const regressionGenerator = regressionLoess()
						.x((d) => parseDate(d.date))
						.y((d) => parseFloat(d.normalized_distinct_clean))
						.bandwidth(0.03);

					// Calculate min and max for the current city
					const cityMin = Math.min(...regressionGenerator(cityData).map(subarray => subarray[1]), min(normalizedDistinctCleanValues));
					const cityMax = Math.max(...regressionGenerator(cityData).map(subarray => subarray[1]), max(normalizedDistinctCleanValues));
		
					const xScale = scaleTime()
						.domain([new Date(selection.day1), new Date(selection.day2)])
						.range([marginLeft, chartWidth - marginRight]);

					const yScale = scaleLinear()
						.domain([cityMin, cityMax])
						.range([chartHeight - marginBottom, marginTop]);

					
					const lineGenerator = line()
						.x(d => xScale(d[0]))
						.y(d => yScale(d[1]));

					const regressionLine = lineGenerator(regressionGenerator(cityData));

					if (city === "Quebec") {
						console.log(cityData);
						console.log(regressionGenerator(cityData));
						console.log(cityMax);
					}

					const percentageChange = (((month2 - month1) / month1)*100);
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
					const endPoint = regressionGenerator(cityData)[395]; // total length = 367
					const endCircle = {
						cx: xScale(endPoint[0]), 
						cy: yScale(endPoint[1]),
						radius: 6,
						fill: "red",
						stroke: "#6aa687",
						"stroke-width": 2
					};

					const meanLine = yScale(month1);

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
			<i>Updated May 2024</i>
		</p>
		<p>
			Data on cell phone activity (a.k.a. footfall) trends for the last year provide a picture of how downtowns are faring since our last rankings update in the summer of 2023. We look here at trends from {selection.monthName}, 2023 through {selection.monthName}, 2024. Trends are based on data from Spectus, but use different cell phone data providers from our rankings analysis. The trendlines measure the average level of activity over the course of the year, while the ranking metric shows the percent difference in the average number of stops in {selection.monthName} 2024 relative to {selection.monthName} 2023. 
		</p>
		<p>
			The dotted line provides a baseline of the average level of activity in {selection.monthName} 2023, allowing for comparison to subsequent months. The solid line represents the average level of activity by week. When the solid line extends above the dotted baseline, downtown activity is greater compared to in {selection.monthName} 2023. When it dips below the dotted line, activity is on a downswing. For most cities, there is an increase in month 6 or 7; this is expected since these are the summer months of June and July. The fall months see decreasing activity on average, with almost all downtowns losing activity by November. However, some cities stay above the {selection.monthName} baseline, suggesting gradual recovery, while others dip well below it, i.e., stagnating recovery.
		</p>
		<h5>
			Key Findings
		</h5>
		<p>
			Overall, the median rate of change is 9.3% over the year, meaning that the median downtown in the U.S. and Canada’s largest metropolitan areas are gradually seeing more activity. Fifty downtowns are in an upward trajectory, while just 14 are trending downwards.
		</p>
		<p>
			With a couple exceptions, the downtowns that are seeing the highest rates of activity increase, consistently higher relative to 2023, are the ones that were below 80% in our <a href="/charts/rankings">2023 rankings</a>.  These cities seem to be trending towards recovery: Minneapolis, Montreal, Ottawa, Chicago, Louisville, Pittsburgh, Cincinnati, Boston, Washington DC, and Toronto. In other words, their recovery may now be converging with the downtowns that largely recovered in 2023.
		</p>
		<p>
			On the other hand, for the 14 cities where recovery is faltering, we see three types of patterns. For a handful of cities that previously topped our rankings, such as Las Vegas, Colorado Springs, San Antonio, Fort Worth, Tampa, Wichita, Oklahoma City, activity rates are slowing (albeit slightly for most) and changing very little since March 2023. On the other hand, Dallas and San Francisco are both quite volatile, with significant new activity in summer 2023 decreasing below the baseline by fall and winter. A few downtowns, including Houston, Memphis, and Nashville, have basically stalled at the March 2023 activity rate.
		</p>
		<p>
			To the extent possible, we will update this data on a monthly basis through 2024.
		</p>

		<h4>Visits to Downtown ({selection.monthName} 1, 2023 to {selection.monthName} 30, 2024)</h4>

		<p>
			Select Regions:
		</p>

		<SelectRegions europe={"no"} canada={"yes"}/>

		<p style="padding-top: 10px; padding-bottom: 10px;">
			<svg height="10" width="50">
				<line x1="0" y1="5" x2="50" y2="5" stroke="white" stroke-width="1" stroke-dasharray="4"/>
			</svg>
			{selection.monthName} {selection.year1} average
		</p>


	</div>

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
						class="textLabel"
					>Percent Change in Visits</text>
					<text
						x="235"
						y="35"
						class="textLabel"
					>{selection.monthNumber}/{selection.year2} vs. {selection.monthNumber}/{selection.year1}</text>

					<text
						x="{469}"
						y="15"
						class="textMonth"
					>2023</text>

					<text
						x="{719}"
						y="15"
						class="textMonth"
					>2024</text>

					<line x1="260" y1={45} x2={260 + chartWidth} y2={45} stroke="white" stroke-width="1" />

					{#each [4,5,6,7,8,9,10,11,12,1,2,3,4] as l, i}
						<line x1={260 + i * chartWidth / 13} y1={45} x2={260 + i * chartWidth / 13} y2={40} stroke="white" stroke-width="1" />

						{#if l === 1}

							<line x1={260 + i * chartWidth / 13} y1={5} x2={260 + i * chartWidth / 13} y2={40} stroke="white" stroke-width="1" />

						{/if}

						<text
							x="{260 + i * chartWidth / 13 + 0.5 * chartWidth / 13}"
							y="40"
							class="textMonth"
						>{l}</text>
					{/each}

					<line x1={259 + chartWidth} y1={45} x2={259 + chartWidth} y2={40} stroke="white" stroke-width="1" />

					

				</svg>
				
				
			</div>

		</div>

		{#each sortedCharts as { city, regressionLine, startCircle, endCircle, meanLine, perChangeDisplay, percentageChange }, i}
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

						{#each [1,2,3,4,5,6,7,8,9,10,11] as l, i}
						
						<line x1={l * chartWidth / 12} y1={5} x2={l * chartWidth / 12} y2={45} stroke="#333333" stroke-width="1" />

						{/each}
						
						<!-- Top line -->
						<!-- <line x1="0" y1="0" x2={chartWidth} y2="0" stroke="gray" stroke-width="1"/>  -->
						<!-- Middle line -->
						<line x1="0" y1={meanLine} x2={chartWidth} y2={meanLine} stroke="#D0D1C9" stroke-width="1" stroke-dasharray="4"/>
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
		

		<h4>
			More Information
		</h4>

		<p>
			You can download the data shown on the chart <a href="/stopuplevelled_mar2023_mar2024.csv">here</a>. The data on the charts are based on the `normalized_distinct_clean` column, which pertains to the number of unique daily visitors normalized by the total number in the metro area. The trend-line and summary statistics shown are calculated in JavaScript (code is <a href="https://github.com/schoolofcities/downtown-recovery/blob/main/src/routes/charts/trends/%2Bpage.svelte" target="_blank">here</a>)
			</p>

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
		border-bottom: solid 1px var(--brandDarkBlue);
	}

	.textLabel {
		font-family: Roboto;
		font-size: 15px;
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