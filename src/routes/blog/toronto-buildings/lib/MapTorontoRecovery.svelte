<script>

	import mapRecovery from "../data/map-recovery.png";

	let legendColours = ['#dc4633', '#e27e71', '#e9c1bb', '#eeeeee', '#c2e1ec', '#9bd5eb', '#6fc7ea'];
	let legendText = ["50%","70%","90%", "110%", "130%", "150%"]

</script>



<div class="legendContainer">
	<h2>Toronto Financial District BIA</h2>
	<p>Recovery Rate % (2019 to 2023)</p>
	<svg class="legend" width="350" height="35" xmlns="http://www.w3.org/2000/svg">
		{#each legendColours as colour, index}
			<rect
				x={index * 50}
				y="0"
				width="50"
				height="15"
				fill={colour}
				stroke="#191919"
				stroke-width="1"
			/>
		{/each}
		{#each legendText as text, index}
			<text
				x={50 + index * 50} 
				y="30"
				fill="#ffffff"
				font-size="14"
				text-anchor="middle"
				font-family="Roboto"
				opacity="0.7"
				>
				{text}
			</text>
		{/each}
	</svg>
</div>

<div class="mapImg">

	<img src={mapRecovery} alt="Map visualizing buildings based on their footfall activity in 2023 relative to 2019 (pre-covid). Buildings shaded blue indicate recovery of greater than 100%, buildings shaded red are below 100%.">

</div>



  

<style>

	.mapImg {
		max-width: 740px;
		margin: 0 auto; /* Center the container */
	}

	img {
		border: solid 1px var(--brandDarkBlue);
		min-width: 350px;
		max-width: 100%; /* Set maximum width to 100% of the container */
		height: auto; /* Maintain aspect ratio */
		display: block; /* Remove default image spacing */
		margin: 0 auto; /* Center the image within the container */
	}

	.legendContainer {
		padding-top: 10px;
		/* background-color: red; */
		border-top: solid 1px var(--brandDarkBlue);
		max-width: 740px;
		margin: 0 auto;
		padding-bottom: 10px;
	}

	.legend {
		margin: 0 auto;
	}

</style>