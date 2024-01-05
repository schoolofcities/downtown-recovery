<script>

	import { scaleLinear } from "d3";

	let categories = ["Recovery Rate", "Useable Space", "Class A", "Class B", "Class C", "Office", "Retail", "Office & Retail"]

	let data = [
		{
			"cluster": 1,
			"colour": "#8DBF2E",
			"name": "High Recovery, Class B & C",
			"Useable Space": 0.3100813120417891,
			"Office & Retail": 0.09090909090909091,
			"Office": 0.6818181818181818,
			"Retail": 0.22727272727272727,
			"Class A": 0,
			"Class B": 0.7272727272727273,
			"Class C": 0.2727272727272727,
			"Recovery Rate": 0.7261625560245528,
			"n": 22
		},
		{
			"cluster": 2,
			"colour": "#007FA3",
			"name": "Moderate Recovery, Office & Mixed-Use",
			"Useable Space": 0.6051907914021837,
			"Office & Retail": 0.3333333333333333,
			"Office": 0.6666666666666666,
			"Retail": 0,
			"Class A": 0.23333333333333334,
			"Class B": 0.7666666666666667,
			"Class C": 0,
			"Recovery Rate": 0.5793544678022642,
			"n": 30
		},
		{
			"cluster": 3,
			"colour": "#6D247A",
			"name": "Low Recovery, Class A & Retail Mix",
			"Useable Space": 0.7604600977897897,
			"Office & Retail": 0.71875,
			"Office": 0.21875,
			"Retail": 0.0625,
			"Class A": 0.9375,
			"Class B": 0.0625,
			"Class C": 0,
			"Recovery Rate": 0.4851078200226867,
			"n": 32
		},
		{
			"cluster": 4,
			"colour": "#AB1368",
			"name": "Very Low Recovery, Class B",
			"Useable Space": 0.45203298849205176,
			"Office & Retail": 0.2,
			"Office": 0.55,
			"Retail": 0.25,
			"Class A": 0,
			"Class B": 0.95,
			"Class C": 0.05,
			"Recovery Rate": 0.34098280832331385,
			"n": 20
		}
	]

	let width = 400;
	let height = 210;

	let xScale = scaleLinear()
		.domain([0, 1])
		.range([100, 385]);

</script>



<div class="chartWrapper">

	{#each data as cluster, index}

		<div class="chart">

			<svg width="{width}" height="{height}">

				<rect 
					x="10"
					y="10"
					width="30" 
					height="15" 
					fill="{cluster.colour}"
					stroke-width="1"
					stroke="white"
				/>

				<line 
					x1="{10}" 
					y1="35" 
					x2="{390}" 
					y2="35" 
					stroke="#1E3765" 
					stroke-width="1"
				/>

				<text
					x="45" 
					y="23" 
					fill="white"
					font-size="15"
					text-anchor="start"
					font-family="Roboto"
					>
					{cluster.name}			
				</text>

				<text
					x="390" 
					y="23" 
					fill="white"
					font-size="12"
					text-anchor="end"
					font-family="Roboto"
					>
					n = {cluster.n}			
				</text>
				
				{#each categories as category, index}

					<text
						x="85" 
						y="{58 + index * 20}" 
						fill="white"
						font-size="12"
						text-anchor="end"
						font-family="Roboto"
						>
						{category}			
					</text>

					<line
						x1="{100}" 
						y1="{55 + index * 20}" 
						x2="{xScale(1) + 0}" 
						y2="{55 + index * 20}" 
						stroke="#1E3765" 
						stroke-width="8"
						stroke-linecap="round"
					/>

					<line
						x1="{100}" 
						y1="{55 + index * 20}" 
						x2="{xScale(cluster[category]) + 0}" 
						y2="{55 + index * 20}" 
						stroke="white" 
						stroke-width="8"
						stroke-linecap="round"
					/>

				{/each}
			
			</svg>

		</div>
	
	{/each}

</div>



<style>

	.chartWrapper {
		max-width: 825px;
		margin: 0 auto;
		display: grid;
		grid-template-columns: repeat(2, 1fr); 
		gap: 25px;
	}

	.chart {
		background-color: #161616;
		margin: 0 auto;
	  	height: 210px;
		width: 400px;
	  	text-align: center;
		border: solid 1px #2a2a2a
	}

	@media screen and (max-width: 800px) {
		.chartWrapper {
			grid-template-columns: 1fr; 
		}
	}

</style>