<script>
	import buildingData from "../data/building-recovery.geo.json";
	import { bin, scaleLinear } from "d3";

	let	marginLeft = 10;
	let marginRight = 20;
	let width = 400;
	let height = 150;

	let types = ["Office", "Retail", "Office / Retail", "Hospitality"]
		
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

	console.log(bins(data[1]))

	const x = 10; // replace 10 with your desired value
	const resultArray = Array.from({ length: x }, (_, index) => index);
	console.log(resultArray);

</script>



<div class="chartWrapper">

	{#each data as type, index}

		<div class="chart">

			<svg width="{width}" height="{height}">

				<text
						x="10" 
						y="30" 
						fill="white"
						font-size="12"
						text-anchor="start"
					>
					{types[index]}				
				</text>

				<line 
					x1="{marginLeft}" 
					y1="100" 
					x2="{width - marginRight}" 
					y2="100" 
					stroke="#1E3765" 
					stroke-width="1"
				/>

				<line 
					x1="{xScale(100)}" 
					y1="20" 
					x2="{xScale(100)}" 
					y2="100" 
					stroke="#1E3765" 
					stroke-width="1"
				/>

				<text
						x="{width / 2}" 
						y="135" 
						fill="white"
						font-size="12"
						text-anchor="middle"
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

					<text
						x="{xScale(t)}" 
						y="120" 
						fill="white"
						font-size="12"
						text-anchor="middle"
					>
					{t}%						
					</text>

				{/each}

				{#each bins(type) as t}

					{#if t.length > 0}

						{#each Array.from({ length: t.length }, (_, index) => index) as c}

							<circle cx="{xScale(t.x0 + 5)}" cy="{94 - c * 9}" r="4" fill="white"/>

						{/each}

					{/if}

				{/each}

			
			</svg>
			
		</div>

	{/each}


</div>


<style>

	.chart {
		/* background-color: black; */
		/* border-top: solid 1px grey; */
		height: 150px;
		width: 350px;
	}

</style>
