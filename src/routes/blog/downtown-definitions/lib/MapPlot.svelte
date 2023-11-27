<script>
	import { onMount } from 'svelte';
	import maplibregl from 'maplibre-gl';
	import hdbscan_downtowns from '../../../../assets/HDBSCAN.geo.json';
	import old_downtowns from '../../../../assets/zip_code.geo.json';
	import comm_downtowns from '../../../../assets/office_retail.geo.json';
	import citydefined_downtowns from '../../../../assets/city_defined.geo.json';
	import { cityCoordinates } from './city_coords.js';
	import { csvParse } from "d3-dsv";
    import { pointer } from 'd3';
  
	let pageHeight;
	let pageWidth;
	let svgWidth;
  
	let map;
  
	let mapHeight = 400;
	$: if (pageHeight < 600) {
	  	mapHeight = pageHeight - 200;
	} else {
	  	mapHeight = 400;
	}
  
	let selectedCity = 'Albuquerque NM'; // Default city
  
	let showHDBSCANDowntowns = true; // Initial visibility
	let showOldDowntowns = false;
	let showCommDowntowns = false;	
	let showCityDowntowns = false;
  
	let chartData = [];

    let data = [];
    let cityURL = '';
  
	function updateChartData() {
		const selectedData = cityCoordinates[selectedCity];
		chartData = [
			{ label: 'Office/retail', value: selectedData.rq_comm },
			{ label: 'Zip code', value: selectedData.rq_zip },
			{ label: 'HDBSCAN', value: selectedData.rq_hdbscan },
		];
	}

    async function loadURL(selectedCity) {
        try {
            const response = await fetch('../citydefined_list.csv');
            const csvData = await response.text();
            data = csvParse(csvData);
			console.log('Successfully loaded CSV data: ', data)
        } catch (error) {
            console.error('Error loading CSV data:', error);
        }

		// Filter to selectedCity
		const filteredData = data.filter(row => row.City === selectedCity);
		
		// Check if there is a matching row
		if (filteredData.length > 0) {
			// Assign the value in the 'Link' column to cityURL
			cityURL = filteredData[0].Link;
			console.log('URL: ', cityURL)
		} else {
			console.error('No data found for that city.');
		}		
    }
  
    onMount(() => {

		loadURL(selectedCity);

		// Initialize the map
		map = new maplibregl.Map({
			container: 'map',
			center: [cityCoordinates[selectedCity].long, cityCoordinates[selectedCity].lat],
			zoom: 12,
			minZoom: 9,
			maxZoom: 16,
			bearing: 0,
			scrollZoom: true,
			attributionControl: false,
		});

		map.dragRotate.disable();
		map.touchZoomRotate.disableRotation();  

		map.addSource('black-and-white-basemap', {
			type: 'raster',
			tiles: ['https://basemaps.cartocdn.com/rastertiles/dark_all/{z}/{x}/{y}{r}.png'],
			tileSize: 256,
			attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>',
		});

		map.addLayer({
			id: 'black-and-white-basemap',
			type: 'raster',
			source: 'black-and-white-basemap',
			paint: {
					'raster-brightness-min': 0.2,
					'raster-brightness-max': 0.9,
					'raster-saturation': 0.5,
					'raster-contrast': 0.25,
					'raster-opacity': 1
				}
		});

		// Add sources and layers
		map.addSource('hdbscan_downtowns', {
			type: 'geojson',
			data: hdbscan_downtowns,
		});

		map.addLayer({
			id: 'hdbscan_downtowns_fill',
			type: 'fill',
			source: 'hdbscan_downtowns',
			paint: {
				'fill-color': '#F1C500',
				'fill-opacity': showHDBSCANDowntowns ? 0.2 : 0,
			},
		});

		map.addLayer({
			id: 'hdbscan_downtowns_stroke',
			type: 'line', // Use 'line' type for the border/stroke
			source: 'hdbscan_downtowns',
			paint: {
				'line-color': '#F1C500', // Set the border color
				'line-opacity': 1, // Set the border opacity to 1
				'line-width': 3, // Adjust the border width as needed
			},
		});		  

		map.addSource('old_downtowns', {
			type: 'geojson',
			data: old_downtowns,
		});

		map.addLayer({
			id: 'old_downtowns_fill',
			type: 'fill',
			source: 'old_downtowns',
			paint: {
				'fill-color': '#6FC7EA',
				'fill-opacity': showOldDowntowns ? 0.2 : 0,
			},
		});

		map.addLayer({
			id: 'old_downtowns_stroke',
			type: 'line', // Use 'line' type for the border/stroke
			source: 'old_downtowns',
			paint: {
				'line-color': '#6FC7EA', // Set the border color
				'line-opacity': 1, // Set the border opacity to 1
				'line-width': 3, // Adjust the border width as needed
			},
		});
		
		map.addSource('comm_downtowns', {
			type: 'geojson',
			data: comm_downtowns,
		});

		map.addLayer({
			id: 'comm_downtowns_fill',
			type: 'fill',
			source: 'comm_downtowns',
			paint: {
				'fill-color': '#AB1368',
				'fill-opacity': showCommDowntowns ? 0.2 : 0,
			},
		});

		map.addLayer({
			id: 'comm_downtowns_stroke',
			type: 'line', // Use 'line' type for the border/stroke
			source: 'comm_downtowns',
			paint: {
				'line-color': '#AB1368', // Set the border color
				'line-opacity': 1, // Set the border opacity to 1
				'line-width': 3, // Adjust the border width as needed
			},
		});	
		
		map.addSource('citydefined_downtowns', {
			type: 'geojson',
			data: citydefined_downtowns,
		});

		map.addLayer({
			id: 'citydefined_downtowns_fill',
			type: 'fill',
			source: 'citydefined_downtowns',
			paint: {
				'fill-color': '#00A189',
				'fill-opacity': showCommDowntowns ? 0.2 : 0,
			},
		});

		map.addLayer({
			id: 'citydefined_downtowns_stroke',
			type: 'line', // Use 'line' type for the border/stroke
			source: 'citydefined_downtowns',
			paint: {
				'line-color': '#00A189', // Set the border color
				'line-opacity': 1, // Set the border opacity to 1
				'line-width': 3, // Adjust the border width as needed
			},
		});		  
    });
  
	// Function to update the map and chart when the city changes
	async function updateMapAndChart() {

		await loadURL(selectedCity);

		const lat = cityCoordinates[selectedCity].lat;
		const long = cityCoordinates[selectedCity].long;	  

		map.flyTo({ center: [long, lat], zoom: 12, duration: 50 });

	}

	// Watch for changes in layer visibility
	$: {
		if (map) {
			map.setPaintProperty('hdbscan_downtowns_fill', 'fill-opacity', showHDBSCANDowntowns ? 0.2 : 0);
			map.setLayoutProperty('hdbscan_downtowns_stroke', 'visibility', showHDBSCANDowntowns ? 'visible' : 'none'); 
			map.setPaintProperty('old_downtowns_fill', 'fill-opacity', showOldDowntowns ? 0.2 : 0);
			map.setLayoutProperty('old_downtowns_stroke', 'visibility', showOldDowntowns ? 'visible' : 'none'); 
			map.setPaintProperty('comm_downtowns_fill', 'fill-opacity', showCommDowntowns ? 0.2 : 0);
			map.setLayoutProperty('comm_downtowns_stroke', 'visibility', showCommDowntowns ? 'visible' : 'none'); 
			map.setPaintProperty('citydefined_downtowns_fill', 'fill-opacity', showCityDowntowns ? 0.2 : 0);
			map.setLayoutProperty('citydefined_downtowns_stroke', 'visibility', showCityDowntowns ? 'visible' : 'none'); 		  
		}
	}

	function zoomIn() {
		map.zoomIn();
	}
	function zoomOut() {
		map.zoomOut();
	}

</script>
  


<svelte:window bind:innerHeight={pageHeight} bind:innerWidth={pageWidth} />
    
<div class="top-container">
	<div class="dropdown">
		<p>Select a city:</p>
		<select bind:value={selectedCity} on:change={updateMapAndChart}>
			{#each Object.keys(cityCoordinates) as city}
				<option value={city}>{city}</option>
			{/each}
		</select>

		<p>Select boundary:</p>

		<div class='check'>
			<label>
			<input type="checkbox" bind:checked={showHDBSCANDowntowns} style="{showHDBSCANDowntowns ? 'background-color: #F1C500;' : ''}"/>
			HDBSCAN
			</label>
		</div>
		<div class='check'>
			<label>
			<input type="checkbox" bind:checked={showOldDowntowns} style="{showOldDowntowns ? 'background-color: #6FC7EA;' : ''}"/>
			Zip Code
			</label>
		</div>
		<div class='check'>
			<label>
			<input type="checkbox" bind:checked={showCommDowntowns} style="{showCommDowntowns ? 'background-color: #AB1368;' : ''}"/>
			Office/Retail
			</label>
		</div>	
		<div class='check'>
			<label>
			<input type="checkbox" bind:checked={showCityDowntowns} style="{showCityDowntowns ? 'background-color: #00A189;' : ''}"/>
			City-Defined
			</label>
		</div>				
	</div>

	<div class="svg-chart-container" bind:clientWidth={svgWidth}>
		<p>Recovery Rate:</p>
		<svg height="100" width="100%" >
			{#if showHDBSCANDowntowns}
				<rect 
					x="1" 
					y="1" 
					width={svgWidth * cityCoordinates[selectedCity].rq_hdbscan / 1.3}
					height="20px" 
					stroke="#F1C500" 
					stroke-width="2" 
					fill="#F1C500" 
					fill-opacity=0.2 
				/>
				<text
					x={8 + svgWidth * cityCoordinates[selectedCity].rq_hdbscan / 1.3}
					y="16"
					class="svg-data-label">
					{Math.round(100 * cityCoordinates[selectedCity].rq_hdbscan)}%
				</text>
			{/if}
			{#if showOldDowntowns}
				<rect 
					x="1" 
					y="26" 
					width={svgWidth * cityCoordinates[selectedCity].rq_zip / 1.3}
					height="20px" 
					stroke="#6FC7EA" 
					stroke-width="2" 
					fill="#6FC7EA" 
					fill-opacity=0.2 
				/>
				<text
					x={8 + svgWidth * cityCoordinates[selectedCity].rq_zip / 1.3}
					y="41"
					class="svg-data-label">
					{Math.round(100 * cityCoordinates[selectedCity].rq_zip)}%
				</text>
			{/if}
			{#if showCommDowntowns}
				<rect 
					x="1" 
					y="51"
					width={svgWidth * cityCoordinates[selectedCity].rq_comm / 1.3}
					height="20px" 
					stroke="#AB1368" 
					stroke-width="2" 
					fill="#AB1368" 
					fill-opacity=0.2 
				/>
				<text
					x={8 + svgWidth * cityCoordinates[selectedCity].rq_comm / 1.3}
					y="66"
					class="svg-data-label">
					{Math.round(100 * cityCoordinates[selectedCity].rq_comm)}%
				</text>
			{/if}
			{#if showCityDowntowns}
				<rect 
					x="1"
					y="76" 
					width={svgWidth * cityCoordinates[selectedCity].rq_city / 1.3}
					height="20px" 
					stroke="#00A189" 
					stroke-width="2" 
					fill="#00A189" 
					fill-opacity=0.2 
				/>
				<text
					x={8 + svgWidth * cityCoordinates[selectedCity].rq_city / 1.3}
					y="91"
					class="svg-data-label">
					{Math.round(100 * cityCoordinates[selectedCity].rq_city)}%
				</text>
			{/if}
		</svg>
	</div>

</div>

<div class="container">
	
	<div id="map" class="map" style="height: {mapHeight}px">
		<div class="map-zoom-wrapper">
			<span on:click={zoomOut} class="map-zoom">–</span>
			<span on:click={zoomIn} class="map-zoom">+</span>
		</div>
	</div>	

	<p>Base Map Data Sources: CARTO, OpenStreetMap</p>
</div>

<br>
<p>
	<i>Click <a href='../all_shapefiles_download.zip'>here</a> to download the polygons (in geojson format) for all four types of boundaries.</i>
</p>


<br>
<br>

<h4 style="border-bottom: solid 2px #F1C500;">HDBSCAN</h4>   
<p class="indented-paragraph">
The <i>HDBSCAN</i> polygons are used to determine our current <a href='https://downtownrecovery.com/charts/rankings' target='_blank'>recovery rankings</a>. To create these polygons, we used jobs data to identify concentrations of jobs in individual city blocks (or dissemination areas, in Canada) and then drew a polygon around these clusters to represent downtown. For more details, read the <i>Downtown Geography Selection</i> section of our <a href='https://downtownrecovery.com/methodology' target='_blank'>Methodology page</a>.
</p>

<h4 style="border-bottom: solid 2px #6FC7EA;">Zip Code</h4> 
<p class="indented-paragraph">
The <i>Zip code</i> polygons, which were used to determine our previous <a href='https://downtownrecovery.com/charts/rankings_archived' target='_blank'>recovery rankings</a>, were created by selecting the zip code (in the US) or group of dissemination areas (in Canada) in each city with the highest job density. Read the <i>SafeGraph and Spectus Data and Downtown Definitions</i> section of our <a href='https://downtownrecovery.com/death_of_downtown_policy_brief.pdf' target='_blank'>policy brief</a> to learn more.
</p> 

<h4 style="border-bottom: solid 2px #AB1368;">Office/Retail</h4> 
<p class="indented-paragraph">
The <i>Office/retail</i> polygons represent areas of high commercial and economic activity in the urban core. These boundaries were created using an unsupervised image segmentation model that combines office and retail data from OpenStreetMap with jobs data from 2019 (<a href='https://lehd.ces.census.gov/data/' target='_blank'>in the U.S.</a>) and 2016 (<a href='http://odesi2.scholarsportal.info/documentation/CENSUS/2016/cen16labour.html' target='_blank'>in Canada</a>). The model results in multiple spatial clusters in each city, which were assigned scores based on their size as well as their level of retail, job and office density. The cluster with the highest score that also overlapped with the original zip code-level downtown boundary was selected as the final polygon.
</p> 

<h4 style="border-bottom: solid 2px #00A189;">City-Defined</h4> 
<p class="indented-paragraph">
The <i>City-defined</i> polygons represent cities' own definitions of their downtown boundaries. The shapefiles were either downloaded directly from public websites, like open data portals, or created manually in GIS based on static maps.
</p>  
<p class="indented-paragraph">
<i>Click <a href={cityURL} target='_blank'>here</a> for the source of {selectedCity.replace(/\s\w{2}$/, '')}'s downtown boundary.</i>   
<p class="indented-paragraph">
<i>Click <a href="../citydefined_list.csv">here</a> to download a list of sources for all city-defined downtown polygons.</i>
</p>

<style>

	.dropdown {
		width: 160px;
		height: 260px;
	}

    select {
        padding: 5px;
        background-color: var(--brandGray90);
        border: 1px solid var(--brandDarkBlue);
        color: white; 
		font-family: 'Roboto';
    }
  
    select option {
        background-color: var(--brandGray90);
        color: white;
    }

	input[type="checkbox"] {
      appearance: none;
      -webkit-appearance: none;
      -moz-appearance: none;
      width: 16px;
      height: 16px;
      border: 1px solid var(--brandDarkBlue);
      background-color: var(--brandBlack);
      outline: none;
	  margin: 0px;
	  margin-right: 2px;
    }

    input[type="checkbox"]:checked {
      border: 1px solid var(--brandDarkBlue);
      background-color: var(--brandWhite);
    }

	input[type="checkbox"]:hover {
		cursor: pointer;
	}

	.top-container {
		display: flex;
	  max-width: 1200px;
	  margin: 0 auto;
	}	

	

	.check {
		margin-bottom: 5px;
	}

	.svg-chart-container {
		flex: 1;
		height: calc(240px - 85px);
		/* background-color: black; */
		padding-top: 85px;
	}
	.svg-data-label {
		fill: white;
		font-family: Roboto;
		font-size: 15px;
	}

	.container {
		position: relative;
		max-width: 1200px;
		margin: 0 auto;
	}
	.container p {
		font-size: 12px;
		margin-top: 0px;
		color: gray;
		position: absolute;
		right: 0px;

	}

	.map {
		position: relative; 
		width: 100%;
		height: 100%;
		max-width: 900px;
		border: solid 1px var(--brandDarkBlue);
	}
	.map-zoom-wrapper {
		margin-top: 5px;
		margin-left: 5px;
		right: 5px;
		position: absolute;
	}
	.map-zoom {
		display: inline-block;
		font-size: 25px;
		max-width: 25px;
		min-width: 25px;
		background-color: var(--brandDarkBlue);
		color: white;
		border: solid 1px var(--brandGray90);
		text-align: center;
		margin: 0 auto;
	}
	.map-zoom:hover {
		cursor: pointer;
		background-color: var(--brandGray90);
	}

    .indented-paragraph {
	  	margin-left: 25px;
    }	

	.footnotes {
		font-size: 11px;
	}

</style>