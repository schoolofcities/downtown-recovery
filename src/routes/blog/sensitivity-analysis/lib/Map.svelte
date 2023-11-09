<script>

	import { onMount } from 'svelte';
	import maplibregl from 'maplibre-gl';
	import hdbscan_downtowns from '../../../../assets/HDBSCAN_downtowns_with_province.geo.json';
	import old_downtowns from '../../../../assets/old_study_areas.geo.json';
	import { cityCoordinates } from './city_coords.js';

	let pageHeight;
	let pageWidth;
	/**
     * @type {import("maplibre-gl").Map}
     */
	let map;
	let selectedCity = 'Albuquerque NM'; // Default city

	let showHDBSCANDowntowns = true; // Initial visibility
	let showOldDowntowns = true; // Initial visibility

	let mapHeight = 600;
	$: if (pageHeight < 800) {
		mapHeight = pageHeight - 200;
	} else {
		mapHeight = 600
	}

	onMount(() => {

		map = new maplibregl.Map({
			container: 'map',
			center: [cityCoordinates[selectedCity].long, cityCoordinates[selectedCity].lat],
			zoom: 12,
			minZoom: 9,
			maxZoom: 16,
			bearing: 0,
			projection: 'globe',
			scrollZoom: true,
			attributionControl: false
		});

		map.dragRotate.disable();
		map.touchZoomRotate.disableRotation();

		map.addSource('hdbscan_downtowns', {
			'type': 'geojson',
			'data': hdbscan_downtowns
		});

		map.addLayer({
               'id': 'hdbscan_downtowns',
               'type': 'fill',
               'source': 'hdbscan_downtowns',
               'paint': {
                   'fill-color': 'red',
                   'fill-opacity': showHDBSCANDowntowns ? 0.4 : 0,
               }
        });		

		map.addSource('old_downtowns', {
			'type': 'geojson',
			'data': old_downtowns
		});

		map.addLayer({
               'id': 'old_downtowns',
               'type': 'fill',
               'source': 'old_downtowns',
               'paint': {
                   'fill-color': 'blue',
                   'fill-opacity': showOldDowntowns ? 0.4 : 0,
               }
        });	

		map.addSource('osm-raster-tiles', {
			'type': 'raster',
			'tiles': ['https://tile.openstreetmap.org/{z}/{x}/{y}.png'],
			'tileSize': 256,
			// 'minzoom': 0,
			// 'maxzoom': 19
		});
		map.addLayer({
			'id': 'osm-raster-tiles',
			'type': 'raster',
			'source': 'osm-raster-tiles',
			'paint': {
				'raster-saturation': -1,
				'raster-opacity': 0.42
			}
		});			
		
	});

	// Watch for changes in layer visibility
	$: {
		if (map) {
      		map.setPaintProperty('hdbscan_downtowns', 'fill-opacity', showHDBSCANDowntowns ? 0.4 : 0);
      		map.setPaintProperty('old_downtowns', 'fill-opacity', showOldDowntowns ? 0.4 : 0);
    	}
	}	

	function updateMap() {
		// Update the map's center and zoom based on the selected city
		const { lat, long } = cityCoordinates[selectedCity];
		map.flyTo({ center: [long, lat], zoom: 12, duration: 50 }); // Adjust the zoom level as needed
  	}	

</script>

<svelte:window bind:innerHeight={pageHeight} bind:innerWidth={pageWidth}/>

<div class="container">
  <div id="map" style="height: {mapHeight}px"></div>

  <div>
	<div>
		<label for="cityDropdown">Select a city:</label>
		<select id="cityDropdown" bind:value={selectedCity} on:change={updateMap}>
		  {#each Object.keys(cityCoordinates) as city}
			<option value={city}>{city}</option>
		  {/each}
		</select>
	  </div>
	
	  <div id="sidebar">
		<div>
			<label>
			<input type="checkbox" bind:checked={showHDBSCANDowntowns} />
			HDBSCAN
			</label>
		</div>
		<br>
		<div>
			<label>
			<input type="checkbox" bind:checked={showOldDowntowns} />
			Zip code (former definition)
			</label>
		</div>
		<div>
			<br><br>
			<p id='data_sources'>Data Sources:<br>- OpenStreetMap<br>- LEHD</p>
		</div>
	  </div>
  </div>

</div>

<style>
  .container {
    display: flex;
    flex-direction: row; /* Horizontal layout */
    justify-content: space-between; /* Align items to the start and end of the container */
    align-items: flex-start; /* Align items to the top of the container */
    max-width: 1200px;
    margin: 0 auto;
  }

  #map {
	width: 80%;
	height: 100%;
	margin: 0 auto;
	max-width: 900px;
	background-color: white;	
  }

  #sidebar {
    width: 30%;
	margin-left: 20px;
  }

  #data_sources {
	margin: 0 auto;
	text-align: left;
	font-size: 12px;
	max-width: 1200px;
	color: white;		
  }
</style>