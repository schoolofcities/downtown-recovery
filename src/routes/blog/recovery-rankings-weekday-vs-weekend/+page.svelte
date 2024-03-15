<script>

	import Header from "../../../lib/Header.svelte";
	import "../../../assets/global.css";

	import SelectRegions from "../../../lib/SelectRegions.svelte";

	import { onMount } from 'svelte';
	import { csvParse } from 'd3-dsv';

	import { selectedRegions, regions } from '../../../lib/stores.js';


	// initial loading data and dynamic filtering
	
	let data = [];
	let filteredData = [];

	const regionColours = $regions;

	async function loadData() {
		try {
			// const response = await fetch('../recovery_rankings.csv');
			const response = await fetch('/src/routes/blog/recovery-rankings-weekday-vs-weekend/data/working_hours_NEW.csv');
			const csvData = await response.text();
			data = csvParse(csvData);
		} catch (error) {
			console.error('Error loading CSV data:', error);
		}
	}

	onMount(() => {
		loadData();
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

		<h3>Exploring the pulse of American downtowns: understanding downtown
			recovery across different time frames</h3>

		<p>By author names here | March, 2024</p> 

		<p>
			In the vibrant core of American cities, a quiet story is being told by the rhythm of
			cellphone mobility data. As the downtown areas come to life, buzz with activity,
			every city reveals its unique narrative of rebounding and resilience. This exploration
			aims to decode the secrets behind the urban dynamics following the COVID-19
			pandemic, investigating how cities recover during various timeframes: weekends
			(Saturday and Sunday), weekdays (Monday to Friday), working hours (9 am to 6 pm,
			Monday to Friday), and post-work hours (6 pm to 9 am, Saturday to Friday).
		</p>
		<p>
			This journey into understanding the rates of urban recovery transcends mere
			number crunching; it’s about peeling back the layers to reveal the soul of city living.
			From economic vitality to social vibrancy, these metrics offer a glimpse into the
			pulse of a community. As the world grapples with urbanization, pandemics, and
			technological shifts, deciphering these patterns becomes crucial for planners,
			policymakers, and citizens alike
		</p>

	</div>

	<div id="chart-wrapper" bind:offsetWidth={chartWidth}>

		<p>Weekend vs. Weekday</p>
		
		<div id="options">
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

				<circle class="circle-left"
					cx={29 + ((chartWidth - 50) * d.Recovery_Rate_weekdays / Math.max(...xAxisIntervals))}
					cy={52 + i * 24}
					r={5}
					style="
						fill: #DC4633;
						stroke: #edf0f5;
						stroke-width: 2
					"
				></circle>

				<circle class="circle-right"
					cx={29 + ((chartWidth - 50) * d.Recovery_Rate_weekends / Math.max(...xAxisIntervals))}
					cy={52 + i * 24}
					r={5}
					style="
						fill: #007FA3;
						stroke: #edf0f5;
						stroke-width: 2
					"
				></circle>
		
				<circle class="circle-mid"
					cx={29 + ((chartWidth - 50) * d.Recovery_rate_total / Math.max(...xAxisIntervals))}
					cy={52 + i * 24}
					r={5}
					style="
						fill: #1E3765;
						stroke: #edf0f5;
						stroke-width: 2
					"
				></circle>

				<!-- <text class="circle-label"
					x={17 + ((chartWidth - 50) * d.Recovery_Rate_after_working_hours / Math.max(...xAxisIntervals))}
					y={56 + i * 24}
					style="
						fill: {regionColours.find(region => region.name === d.region).text};
					"
				>{Math.round(100 * d.Recovery_Rate_after_working_hours)}%</text>
		 -->

		 <!-- {regionColours.find(region => region.name === d.region).colour} -->

				
		
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

</main>


<style>
	.text {
		border: 0px;
	}

	h3 {
		font-size: 25px;
	}

	p {
		line-height: 25px;
	}

	#chart-wrapper {
		margin: 0 auto;
		max-width: 1080px;
		border-top: solid 1px var(--brandGray70);
	}

	#options {
		margin: 0 auto;
		max-width: 650px;
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