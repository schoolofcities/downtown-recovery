<script>
	import buildingData from "../data/building-recovery.geo.json";
	import { bin, scaleLinear } from "d3";

	let	marginLeft = 20;
	let marginRight = 20;
	let width = 400;
	let height = 150;

	let typeNames = ["Office", "Retail", "Mixed Office & Retail", "Hospitality"]
	let typeRecovery = ["56%", "34%", "59%", "110%"]

	let data = [
		buildingData.features.filter(d => d.properties.Type === "('Office',)"),
		buildingData.features.filter(d => d.properties.Type === "('Retail',)"),
		buildingData.features.filter(d => d.properties.Type === "('Office', 'Retail')"),
		buildingData.features.filter(d => d.properties.Type === "('Hospitality',)" || d.properties.Type === "('Hospitality', 'Retail')")
	]

	let binArray = Array.from({ length: 41 }, (_, index) => index * 10);

	let bins = bin().value((d) => d.properties.recovery_rates).thresholds(binArray)

	let xScale = scaleLinear()
		.domain([0, 400])
		.range([marginLeft, width - marginRight]);

	function colours(value) {
		if (value < 50) {
			return "#dc4633"
		} else if (value < 70) {
			return "#e27e71"
		} else if (value < 90) {
			return "#e9c1bb"
		} else if (value < 110) {
			return "#eeeeee"
		} else if (value < 130) {
			return "#c2e1ec"
		} else if (value < 150) {
			return "#9bd5eb"
		} else {
			return "#6fc7ea"
		}
	}


</script>



<div class="chartWrapper">

	{#each data as type, index}

		<div class="chart">

			<svg width="{width}" height="{height}">

				<text
						x="{marginLeft}" 
						y="20" 
						fill="white"
						font-size="13"
						text-anchor="start"
						font-family="Roboto"
					>
					{typeNames[index]} Buildings			
				</text>

				<text
						x="{width - marginRight}" 
						y="20" 
						fill="white"
						font-size="13"
						text-anchor="end"
						font-family="Roboto"
					>
					Average Recovery Rate = {typeRecovery[index]}			
				</text>

				<line 
					x1="{marginLeft}" 
					y1="100" 
					x2="{width - marginRight}" 
					y2="100" 
					stroke="white" 
					stroke-width="1"
				/>

				<text
						x="{width / 2}" 
						y="135" 
						fill="white"
						font-size="12"
						text-anchor="middle"
						font-family="Roboto"
					>
					Recovery Rate					
				</text>
				
				{#each [0, 100, 200, 300, 400] as t}

					<line 
						x1="{xScale(t)}" 
						y1="102" 
						x2="{xScale(t)}" 
						y2="106" 
						stroke="white" 
						stroke-width="1"
					/>

					<line 
						x1="{xScale(t)}" 
						y1="35" 
						x2="{xScale(t)}" 
						y2="99" 
						stroke="#1E3765" 
						stroke-width="1"
					/>

					<text
						x="{xScale(t)}" 
						y="120" 
						fill="white"
						font-size="12"
						text-anchor="middle"
						font-family="Roboto"
					>
					{t}%						
					</text>

				{/each}

				{#each bins(type) as t}

					{#if t.length > 0}

						{#each Array.from({ length: t.length }, (_, index) => index) as c}

							<circle cx="{xScale(t.x0 + 5)}" cy="{94 - c * 9}" r="4" fill={colours(t.x0 + 0.01)}/>

						{/each}

					{/if}

				{/each}

			
			</svg>
			
		</div>

	{/each}


</div>


<style>

	/* Container div for the grid */
	.chartWrapper {
		margin: 0 auto;
		display: grid;
		grid-template-columns: repeat(2, 1fr); /* Default 2x2 grid */
		gap: 15px; /* Adjust the gap as needed */
	}

	/* Individual divs inside the grid */
	.chart {
		background-color: #161616;
		margin: 0 auto;
	  	height: 150px;
		width: 400px;
	  	text-align: center;
		border: solid 1px #2a2a2a
	}

	/* Media query for screens less than 800px wide */
	@media screen and (max-width: 800px) {
		.chartWrapper {
			grid-template-columns: 1fr; /* Switch to a single column */
		}
	}

</style>
