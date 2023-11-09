<script>

	import { onMount } from 'svelte';
	import maplibregl from 'maplibre-gl';
	import hdbscan_downtowns from '../../../../assets/HDBSCAN_downtowns_with_province.geo.json';
	import old_downtowns from '../../../../assets/old_study_areas.geo.json';
	import { cityCoordinates } from './city_coords2.js';
	import { scaleLinear, scaleBand, select, axisBottom, axisLeft } from 'd3';

	let pageHeight;
	let pageWidth;
	/**
     * @type {import("maplibre-gl").Map}
     */
	// let map;
	let selectedCity = 'Albuquerque NM'; // Default city

	let showHDBSCANDowntowns = true; // Initial visibility
	let showOldDowntowns = true; // Initial visibility

	// let mapHeight = 600;
	// $: if (pageHeight < 800) {
	// 	mapHeight = pageHeight - 200;
	// } else {
	// 	mapHeight = 600
	// }

	let chartHeight = 600;
	$: if (pageHeight < 800) {
		chartHeight = pageHeight - 200;
	} else {
		chartHeight = 600
	}	

	/**
    * @type {Iterable<any> | import("d3-selection").ValueFn<SVGSVGElement, any, any[] | Iterable<any>>}
    */
	let chartData = []; // Initialize chart data	

	onMount(() => {

		// console.log(chartData)

		updateChartData(); // Initialize the chart data based on the selected city

		const margin = { top: 20, right: 20, bottom: 30, left: 40 };
		const width = 400;
		const height = 200;

		const x = scaleLinear().domain([0, Math.max(...chartData.map(d => d.value))]).nice().range([margin.left, width - margin.right]);
		const y = scaleBand().domain(chartData.map(d => d.label)).range([height - margin.bottom, margin.top]);

		const svg = select('.chart-container')
			.append('svg')
			.attr('width', width)
			.attr('height', height);

		svg
			.selectAll('rect')
			.data(chartData)
			.enter()
			.append('rect')
			.attr('x', margin.left) // Fixed x position for horizontal bars
			.attr('y', d => y(d.label)) // Use y to position horizontally
			.attr('width', d => x(d.value)) // Use x for the bar width
			.attr('height', y.bandwidth()) // Use y for the bar height
			.attr('fill', 'steelblue');

		svg
			.append('g')
			.attr('transform', `translate(0,${height - margin.bottom})`)
			.call(axisBottom(x));

		svg
			.append('g')
			.attr('transform', `translate(${margin.left},0)`)
			.call(axisLeft(y));		

	// 	map = new maplibregl.Map({
	// 		container: 'map',
	// 		center: [cityCoordinates[selectedCity].long, cityCoordinates[selectedCity].lat],
	// 		zoom: 12,
	// 		minZoom: 9,
	// 		maxZoom: 16,
	// 		bearing: 0,
	// 		projection: 'globe',
	// 		scrollZoom: true,
	// 		attributionControl: false
	// 	});

	// 	map.dragRotate.disable();
	// 	map.touchZoomRotate.disableRotation();

	// 	map.addSource('hdbscan_downtowns', {
	// 		'type': 'geojson',
	// 		'data': hdbscan_downtowns
	// 	});

	// 	map.addLayer({
    //            'id': 'hdbscan_downtowns',
    //            'type': 'fill',
    //            'source': 'hdbscan_downtowns',
    //            'paint': {
    //                'fill-color': 'red',
    //                'fill-opacity': showHDBSCANDowntowns ? 0.4 : 0,
    //            }
    //     });		

	// 	map.addSource('old_downtowns', {
	// 		'type': 'geojson',
	// 		'data': old_downtowns
	// 	});

	// 	map.addLayer({
    //            'id': 'old_downtowns',
    //            'type': 'fill',
    //            'source': 'old_downtowns',
    //            'paint': {
    //                'fill-color': 'blue',
    //                'fill-opacity': showOldDowntowns ? 0.4 : 0,
    //            }
    //     });	

	// 	map.addSource('osm-raster-tiles', {
	// 		'type': 'raster',
	// 		'tiles': ['https://tile.openstreetmap.org/{z}/{x}/{y}.png'],
	// 		'tileSize': 256,
	// 		// 'minzoom': 0,
	// 		// 'maxzoom': 19
	// 	});
	// 	map.addLayer({
	// 		'id': 'osm-raster-tiles',
	// 		'type': 'raster',
	// 		'source': 'osm-raster-tiles',
	// 		'paint': {
	// 			'raster-saturation': -1,
	// 			'raster-opacity': 0.42
	// 		}
	// 	});			
		
	});

	// Function to update the chart data based on the selected city
	function updateChartData() {
		const selectedData = cityCoordinates[selectedCity];
		chartData = [
			{ label: 'rq_comm', value: selectedData.rq_comm },
			{ label: 'rq_zip', value: selectedData.rq_zip },
			{ label: 'rq_hdbscan', value: selectedData.rq_hdbscan }
		];
	}	

	// // Watch for changes in layer visibility
	// $: {
	// 	if (map) {
    //   		map.setPaintProperty('hdbscan_downtowns', 'fill-opacity', showHDBSCANDowntowns ? 0.4 : 0);
    //   		map.setPaintProperty('old_downtowns', 'fill-opacity', showOldDowntowns ? 0.4 : 0);
    // 	}
	// }	

	// function updateMap() {
	// 	// Update the map's center and zoom based on the selected city
	// 	const { lat, long } = cityCoordinates[selectedCity];
	// 	map.flyTo({ center: [long, lat], zoom: 12, duration: 50 }); // Adjust the zoom level as needed
  	// }	

</script>

<svelte:window bind:innerHeight={pageHeight} bind:innerWidth={pageWidth}/>

<div class="container">

  <!-- <div class="map" style="height: {mapHeight}px"></div> -->

  <div class="chart-container">
	<svg width="400" height="200"></svg>
  </div>

  <div>
	<div>
		<label for="cityDropdown">Select a city:</label>
		<!-- <select id="cityDropdown" bind:value={selectedCity} on:change={updateMap}> -->
		<select bind:value={selectedCity} on:change={updateChartData}>
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

  .chart-container {
	width: 80%;
	height: 100%;
	margin: 0 auto;
	max-width: 900px;
  }  

  /* .map {
	width: 80%;
	height: 100%;
	margin: 0 auto;
	max-width: 900px;
	background-color: white;	
  } */

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