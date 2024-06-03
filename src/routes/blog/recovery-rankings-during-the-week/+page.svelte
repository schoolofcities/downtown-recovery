<script>

	import Header from "../../../lib/Header.svelte";
	import "../../../assets/global.css";

	import SelectRegions from "../../../lib/SelectRegions.svelte";

	import { onMount } from 'svelte';
	import { csvParse } from 'd3-dsv';

	import { selectedRegions, regions } from '../../../lib/stores.js';


	// colour vars

	let weekdayColour = "#999999";
	let weekendColour = "#191919";
	let overallColour = "#ffffff";
	let circleRadius = 6;

	// initial loading data and dynamic filtering
	
	let data = [];
	let filteredData = [];

	const regionColours = $regions;

	async function loadData() {
		try {
			// const response = await fetch('../recovery_rankings.csv');
			const response = await fetch('/time_of_week_rankings.csv');
			const csvData = await response.text();
			data = csvParse(csvData);
		} catch (error) {
			console.error('Error loading CSV data:', error);
		}
	}

	onMount(() => {
		loadData();
		console.log(data);
	});

	$: filteredData = data
		.filter(item => $selectedRegions.includes(item.region))
		.sort((a, b) => b.Recovery_rate_total - a.Recovery_rate_total);


	// chart parameters

	let chartWidth;
	let chartHeight = 100;
	$: chartHeight = 24 * filteredData.length + 50;

	let maxValue = 1.5; // for x-axis scale
	// $: maxValue = filteredData.length !== 0 ? filteredData[0].Recovery_Rate_weekends : 1;
	// $: maxValue = maxValue < 1 ? 1 : maxValue;

	function generateXaxisIntervals(maxValue, interval) {
		let values = [];

		for (let i = 0; i <= Math.ceil(maxValue / interval); i++) {
			values.push(i * interval);
		}
		return values;
	} 

	let xAxisIntervals = [];
	$: if (maxValue < 2) {
		xAxisIntervals = generateXaxisIntervals(maxValue, 0.2)
	}
	else 
		{xAxisIntervals = generateXaxisIntervals(maxValue, 0.5)
	} ;

	$: xAxisIntervalSpacing = (chartWidth - 50) / (xAxisIntervals.length - 1);


</script>


<Header/>

<main>

	<div class="text">

		<h3>
			Attracting activity to North American downtowns: Understanding downtown recovery across the course of a week
		</h3>
		<p>
			<a href="https://www.linkedin.com/in/amir-forouhar">Amir Forouhar</a>, <a href="https://schoolofcities.utoronto.ca/people/karen-chapple/">Karen Chapple</a>, & <a href="http://jamaps.github.io/">Jeff Allen</a> | March, 2024
		</p>
		<p>
			As downtowns adjust to a new normal of hybrid and remote work, many seek to recover by attracting different types of activity. When downtowns serve as hubs for entertainment, food, retail, and tourism, they can attract visitors and shoppers around the clock. In this analysis, we show how cities recover during working hours (8 AM to 6 PM, Monday to Friday) compared to after-work hours (weeknights 6 PM to 8 AM and the entire weekend), as well as weekdays versus weekends. This provides invaluable insights into how cities can best bring back their downtowns.
		</p>
		<p>
			During working hours, downtown areas typically function as commercial and financial hubs. Our findings shared below reveal that all North American downtowns have exhibited a greater decrease in activity levels during working hours, reflecting a trend towards remote work and flexible schedules. 
		</p>

	</div>

	<div id="chart-wrapper" bind:offsetWidth={chartWidth}>
		
		<div id="options">
			<h2>Downtown Recovery: Working Hours vs. After-Work Hours</h2>

			<p>
				<svg height=16 width=16>
					<circle
						cx=9
						cy=9
						r={circleRadius}
						style="
							fill: {overallColour};
							stroke: #4d4d4d;
							stroke-width: 2
						"
					></circle>
				</svg>
				Overall downtown recovery rate
				<br>
				<svg height=16 width=16>
					<rect 
						x="4" 
						y="5" 
						width="10" 
						height="10" 
						fill="{weekdayColour}" 
						stroke="#edf0f5" 
						stroke-width="2"
					/>
				</svg>
				Recovery rate during typical working hours (8am-6pm, Monday to Friday)
				<br>
				<svg height=16 width=16>
					<polygon 
						points="9,3 15,9 9,15 3,9" 
						fill="{weekendColour}" 
						stroke="white" 
						stroke-width="2" 
					/>
				</svg>
				Recovery rate outside of working hours
			</p>

			<p>Select Regions:</p>
			<div id="options-region">
				<SelectRegions europe={"no"} canada={"yes"}/>
			</div>
		</div>

		<svg height={chartHeight} width={chartWidth} id="chart">

			<polygon id="diamond" points="0,-6 6,0 0,6 -6,0" fill="black" stroke="white" stroke-width="2" />

			<polygon points="0,-6 6,0 0,6 -6,0" fill="{weekendColour}" stroke="#191919" stroke-width="4" />

			<!-- x axis grid and labels -->

			{#each xAxisIntervals as xInterval, i}

                <line class="grid"
                    x1 = {29 + i * xAxisIntervalSpacing}
                    y1 = 34
                    x2 = {29 + i * xAxisIntervalSpacing}
                    y2 = {chartHeight}
                ></line>

                <line class="grid-white"
                    x1 = {29 + i * xAxisIntervalSpacing}
                    y1 = 34
                    x2 = {29 + i * xAxisIntervalSpacing}
                    y2 = 38
                ></line>

                <text class="axis-label"
                    x = {35 + i * xAxisIntervalSpacing}
                    y = 30
                    text-anchor="end"
                >{(100 * xInterval).toFixed(0)}%</text>

            {/each}
		
			{#each xAxisIntervals as xInterval, i}

				<line class="grid"
					x1 = {29 + i * xAxisIntervalSpacing}
					y1 = 34
					x2 = {29 + i * xAxisIntervalSpacing}
					y2 = {chartHeight}
					stroke-opacity="0.91"
				></line>

				{#if xInterval === 1}

					<line class="grid-white"
						x1 = {29 + i * xAxisIntervalSpacing}
						y1 = 34
						x2 = {29 + i * xAxisIntervalSpacing}
						y2 = {chartHeight}
						stroke-opacity=0.75
						stroke-dasharray="2 2"
					></line>

				{/if}

				{#if xInterval === 0}

					<line class="grid-white"
						x1 = {29 + i * xAxisIntervalSpacing}
						y1 = 34
						x2 = {29 + i * xAxisIntervalSpacing}
						y2 = {chartHeight}
						stroke-opacity=0.5
					></line>

				{/if}

			{/each}


			<!-- data points labels and dumbbells -->

			{#each filteredData as d, i}
		
				<line class="bar"
					x1={30}
					y1={52 + i * 24}
					x2={29 + ((chartWidth - 50) * d.Recovery_Rate_after_working_hours_weekdaynights_wholeweekends / Math.max(...xAxisIntervals)) - 1}
					y2={52 + i * 24}
					style="
						stroke: white;
						stroke-width: 16;
						stroke-opacity: 0.08
					"
				></line>

				<line class="bar"
					x1={0}
					y1={52 + i * 24}
					x2={4}
					y2={52 + i * 24}
					style="
						stroke: {regionColours.find(region => region.name === d.region).colour};
						stroke-width: 16;
						stroke-opacity: 1
					"
				></line>

				<text class="axis-label"
                    x = 8
                    y = {57 + i * 24}
                    text-anchor="start"
                >{i + 1}</text>

				<line class="connecting-line"
					x1={29 + ((chartWidth - 50) * d.Recovery_Rate_Working_Hours / Math.max(...xAxisIntervals))}
					y1={52 + i * 24}
					x2={29 + ((chartWidth - 50) * d.Recovery_Rate_after_working_hours_weekdaynights_wholeweekends / Math.max(...xAxisIntervals)) - 1}
					y2={52 + i * 24}
					style="
						stroke: #edf0f5;
						stroke-width: 2
					"
				></line>


				<rect 
					x="{-5 + 29 + ((chartWidth - 50) * d.Recovery_Rate_Working_Hours / Math.max(...xAxisIntervals))}" 
					y="{-5 + 52 + i * 24}" 
					width="10" 
					height="10" 
					fill="{weekdayColour}" 
					stroke="#edf0f5" 
					stroke-width="2"
				/>

				<use 
					href="#diamond" 
					x="{29 + ((chartWidth - 50) * d.Recovery_Rate_after_working_hours_weekdaynights_wholeweekends / Math.max(...xAxisIntervals))}" 
					y="{52 + i * 24}" 
				/>
		
				<circle class="circle-mid"
					cx={29 + ((chartWidth - 50) * d.Recovery_rate_total / Math.max(...xAxisIntervals))}
					cy={52 + i * 24}
					r={circleRadius}
					style="
						fill: {overallColour};
						stroke: #4d4d4d;
						stroke-width: 2
					"
				></circle>


				<text class="bar-label"
					x={34}
					y={56 + i * 24}
					style="
						fill: white;
					"
				>{d.display_title}</text>

			{/each}
			
		</svg>
	
	</div>

	<div class="text">

		<p>
			Our <a href="../charts/correlations">previous research</a> has found that the downtowns that house sectors like education, health care, entertainment, accommodations, and manufacturing, where workers are on-site every day, tend to recover fastest, while those with longer commute times and higher densities fare the worst. Not surprisingly, then, looking just at working hours, Las Vegas (specializing in entertainment) and Bakersfield (health care and administrative support) top the list of downtowns (at 97% and 90%, respectively), while Minneapolis and Seattle, with long commutes and a disproportionate share of jobs in tech and management, are at the bottom (44% and 47%, respectively).
		</p>
		<p>
			But after work-hour activity is surging in many downtowns. Almost a third of downtowns have more activity on weeknights and weekends than they did before the Covid-19 pandemic. Almost all of these downtowns are in the warmer regions of the U.S. (the Southwest, Pacific, or Southeast), suggesting that pleasant weather helps attract visitors and shoppers downtown. 
		</p><p>
			Notably, many large downtowns struggling to bring back activity during the workweek are booming after hours. San Francisco, Chicago, Detroit, Minneapolis, Houston, and Dallas all experience after-hour activity at least 35% higher than during the workweek. 
		</p><p>
			Interestingly, a few cities, including Las Vegas, Raleigh, New Orleans, and Wichita, see little difference between workweek and after-hour activity. This may be because they consistently attract one type of activity throughout the week (e.g., gambling in Las Vegas), or because their economy is balanced between workers and visitors.
		</p>
		<p style="text-align: center;">
			- - -
		</p>
		<p>
			The question remains whether downtowns are attracting new visitors and shoppers, or simply benefitting from the workers who stay downtown after hours, or even just downtown residents. To examine this, we also analyzed weekend activity. Weekends may be a particular draw because they offer special festivals, events, recreation, brunch and dining, and cultural attractions.
		</p>

	</div>

	<div id="chart-wrapper" bind:offsetWidth={chartWidth}>
		
		<div id="options">
			<h2>Weekends versus weekdays</h2>

			<p>
				<svg height=16 width=16>
					<circle
						cx=9
						cy=9
						r={circleRadius}
						style="
							fill: {overallColour};
							stroke: #4d4d4d;
							stroke-width: 2
						"
					></circle>
				</svg>
				Overall downtown recovery rate
				<br>
				<svg height=16 width=16>
					<rect 
						x="4" 
						y="5" 
						width="10" 
						height="10" 
						fill="{weekdayColour}" 
						stroke="#edf0f5" 
						stroke-width="2"
					/>
				</svg>
				Recovery rate on weekdays
				<br>
				<svg height=16 width=16>
					<polygon 
						points="9,3 15,9 9,15 3,9" 
						fill="black" 
						stroke="white" 
						stroke-width="2" 
					/>
				</svg>
				Recovery rate on weekends
			</p>

			<p>Select Regions:</p>
			<div id="options-region">
				<SelectRegions europe={"no"}/>
			</div>
		</div>

		<svg height={chartHeight} width={chartWidth} id="chart">

			<!-- x axis grid and labels -->

			{#each xAxisIntervals as xInterval, i}

                <line class="grid"
                    x1 = {29 + i * xAxisIntervalSpacing}
                    y1 = 34
                    x2 = {29 + i * xAxisIntervalSpacing}
                    y2 = {chartHeight}
                ></line>

                <line class="grid-white"
                    x1 = {29 + i * xAxisIntervalSpacing}
                    y1 = 34
                    x2 = {29 + i * xAxisIntervalSpacing}
                    y2 = 38
                ></line>

                <text class="axis-label"
                    x = {35 + i * xAxisIntervalSpacing}
                    y = 30
                    text-anchor="end"
                >{(100 * xInterval).toFixed(0)}%</text>

            {/each}
		
			{#each xAxisIntervals as xInterval, i}

				<line class="grid"
					x1 = {29 + i * xAxisIntervalSpacing}
					y1 = 34
					x2 = {29 + i * xAxisIntervalSpacing}
					y2 = {chartHeight}
					stroke-opacity="0.91"
				></line>

				{#if xInterval === 1}

					<line class="grid-white"
						x1 = {29 + i * xAxisIntervalSpacing}
						y1 = 34
						x2 = {29 + i * xAxisIntervalSpacing}
						y2 = {chartHeight}
						stroke-opacity=0.75
						stroke-dasharray="2 2"
					></line>

				{/if}

				{#if xInterval === 0}

					<line class="grid-white"
						x1 = {29 + i * xAxisIntervalSpacing}
						y1 = 34
						x2 = {29 + i * xAxisIntervalSpacing}
						y2 = {chartHeight}
						stroke-opacity=0.5
					></line>

				{/if}

			{/each}


			<!-- data points labels and dumbbells -->

			{#each filteredData as d, i}
		
				<line class="bar"
					x1={30}
					y1={52 + i * 24}
					x2={29 + ((chartWidth - 50) * d.Recovery_Rate_weekends / Math.max(...xAxisIntervals)) - 1}
					y2={52 + i * 24}
					style="
						stroke: white;
						stroke-width: 16;
						stroke-opacity: 0.08
					"
				></line>

				<line class="bar"
					x1={0}
					y1={52 + i * 24}
					x2={4}
					y2={52 + i * 24}
					style="
						stroke: {regionColours.find(region => region.name === d.region).colour};
						stroke-width: 16;
						stroke-opacity: 1
					"
				></line>

				<text class="axis-label"
                    x = 8
                    y = {57 + i * 24}
                    text-anchor="start"
                >{i + 1}</text>

				<line class="connecting-line"
					x1={29 + ((chartWidth - 50) * d.Recovery_Rate_weekdays / Math.max(...xAxisIntervals))}
					y1={52 + i * 24}
					x2={29 + ((chartWidth - 50) * d.Recovery_Rate_weekends / Math.max(...xAxisIntervals)) - 1}
					y2={52 + i * 24}
					style="
						stroke: #edf0f5;
						stroke-width: 2
					"
				></line>


				<rect 
					x="{-5 + 29 + ((chartWidth - 50) * d.Recovery_Rate_weekdays / Math.max(...xAxisIntervals))}" 
					y="{-5 + 52 + i * 24}" 
					width="10" 
					height="10" 
					fill="{weekdayColour}" 
					stroke="#edf0f5" 
					stroke-width="2"
				/>

				<use 
					href="#diamond" 
					x="{29 + ((chartWidth - 50) * d.Recovery_Rate_weekends / Math.max(...xAxisIntervals))}" 
					y="{52 + i * 24}" 
				/>
		
				<circle class="circle-mid"
					cx={29 + ((chartWidth - 50) * d.Recovery_rate_total / Math.max(...xAxisIntervals))}
					cy={52 + i * 24}
					r={circleRadius}
					style="
						fill: {overallColour};
						stroke: #4d4d4d;
						stroke-width: 2
					"
				></circle>

				

				<text class="bar-label"
					x={34}
					y={56 + i * 24}
					style="
						fill: white;
					"
				>{d.display_title}</text>

			{/each}
			
		</svg>
	
	</div>

	<div class="text">

		<p>
			The downtowns with high levels of activity on weekends are generally similar to those that flourish after work hours. But a couple exceptions stand out. Jacksonville, Tulsa, and Las Vegas all experience activity levels 13% higher on weekends than after hours generally, suggesting that they may have special weekend events that bring visitors from out of town. On the other end of the spectrum, San Jose and Phoenix see higher activity throughout the after-hour period than on weekends in particular.
		</p>
		<h2>Attracting Activity to Downtowns</h2>
		<p>
			These patterns suggest a clear path forward for North America’s downtowns. Of course, not all downtowns can benefit from balmy weather as Tucson and Charlotte have. But we can learn from the experience of the big cities experiencing lively weekends and weeknights despite low recovery during the workweek. Even if remote and hybrid work in high-skill economic sectors is keeping half of their workforce at home during the week, the downtowns in San Francisco, Chicago, and Minneapolis benefit from their mixture of uses (particularly restaurants, bars, and entertainment venues), transit accessibility, and ongoing event programming. Cities like Louisville and St. Louis that are struggling to attract visitors and shoppers, in addition to workers, will most likely experience a longer road to recovery.
			<br>
			<br>
			<br>
		</p>
		<h2>Data & Methods</h2>
		<p>
			Check out our <a href="../methodology">methodology</a> page for a descritpion on how we measure downtown recovery. For the data on this page, we followed the same process, but filtered the data just for the time periods noted in the charts. You can download the data displayed on these chartes <a href="../time_of_week_rankings.csv">here</a>.
			<br>
			<br>
			<br>
		</p>
	</div>

</main>


<style>
	.text {
		border: 0px;
		min-width: 375px;
	}

	p {
		line-height: 25px;
	}

	#chart-wrapper {
		margin: 0 auto;
		max-width: 1080px;
		min-width: 375px;
		border-top: solid 1px var(--brandDarkBlue);
		/* border-bottom: solid 1px var(--brandDarkBlue); */
		padding-bottom: 10px;
		margin-bottom: 10px;
		padding-left: 10px;
	}

	#options {
		margin: 0 auto;
		max-width: 760px;
	}

	#options-season {
		float: left;
		padding-right: 15px;
	}
	#options-region {
		overflow: hidden;
	}

	#chart {
		margin-top: 10px;
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

	.bar-label {
		/* fill: var(--brandWhite); */
		font-size: 13px;
	}

	.circle-label{
		font-size: 11px;
	}

</style>