<script>
	import { onMount } from 'svelte';
	import maplibregl from 'maplibre-gl';
	import hdbscan_downtowns from '../../../../assets/HDBSCAN_downtowns_with_province.geo.json';
	import old_downtowns from '../../../../assets/old_study_areas.geo.json';
	import { cityCoordinates } from './city_coords2.js';
	import { scaleLinear, scaleBand, select, axisBottom, axisLeft, format } from 'd3';
  
	let pageHeight;
	let pageWidth;
  
	/**
	 * @type {import("maplibre-gl").Map}
	 */
	let map;
  
	let mapHeight = 600;
	$: if (pageHeight < 800) {
	  mapHeight = pageHeight - 200;
	} else {
	  mapHeight = 600;
	}
  
	let selectedCity = 'Albuquerque NM'; // Default city
  
	let showHDBSCANDowntowns = true; // Initial visibility
	let showOldDowntowns = true; // Initial visibility
  
	let chartData = [];
  
	function updateChartData() {
	  const selectedData = cityCoordinates[selectedCity];
	  chartData = [
		{ label: 'rq_comm', value: selectedData.rq_comm },
		{ label: 'rq_zip', value: selectedData.rq_zip },
		{ label: 'rq_hdbscan', value: selectedData.rq_hdbscan },
	  ];
	}
  
	function renderChart() {
	  updateChartData();
	  const margin = { top: 20, right: 20, bottom: 30, left: 40 };
	  const width = 400;
	  const height = 200;
  
	  const x = scaleLinear()
		.domain([0, Math.max(...chartData.map((d) => d.value))])
		.nice()
		.range([margin.left, width - margin.right]);
	  const y = scaleBand()
		.domain(chartData.map((d) => d.label))
		.range([height - margin.bottom, margin.top]);
  
	  const svg = select('.chart-container > svg');
	  svg.selectAll('*').remove();

	  // Use D3's format function to format the ticks as percentages
	  const xAxis = axisBottom(x)
	  .tickFormat(format('.0%'));	  
  
	  svg
		.selectAll('rect')
		.data(chartData)
		.enter()
		.append('rect')
		.attr('x', margin.left)
		.attr('y', (d) => y(d.label))
		.attr('width', (d) => x(d.value))
		.attr('height', y.bandwidth())
		.attr('fill', 'steelblue');
  
	  svg
		.append('g')
		.attr('transform', `translate(0,${height - margin.bottom})`)
		.call(xAxis);
  
	  svg
		.append('g')
		.attr('transform', `translate(${margin.left},0)`)
		.call(axisLeft(y));
	}
  
    onMount(() => {
	  // Initialize the map
	  map = new maplibregl.Map({
		container: 'map',
		center: [cityCoordinates[selectedCity].long, cityCoordinates[selectedCity].lat],
		zoom: 12,
		minZoom: 9,
		maxZoom: 16,
		bearing: 0,
		projection: 'globe',
		scrollZoom: true,
		attributionControl: false,
	  });
  
	  map.dragRotate.disable();
	  map.touchZoomRotate.disableRotation();
  
	  // Add sources and layers
	  map.addSource('hdbscan_downtowns', {
		type: 'geojson',
		data: hdbscan_downtowns,
	  });
  
	  map.addLayer({
		id: 'hdbscan_downtowns',
		type: 'fill',
		source: 'hdbscan_downtowns',
		paint: {
		  'fill-color': 'red',
		  'fill-opacity': showHDBSCANDowntowns ? 0.6 : 0,
		},
	  });
  
	  map.addSource('old_downtowns', {
		type: 'geojson',
		data: old_downtowns,
	  });
  
	  map.addLayer({
		id: 'old_downtowns',
		type: 'fill',
		source: 'old_downtowns',
		paint: {
		  'fill-color': 'blue',
		  'fill-opacity': showOldDowntowns ? 0.6 : 0,
		},
	  });
  
	  map.addSource('osm-raster-tiles', {
		type: 'raster',
		tiles: ['https://tile.openstreetmap.org/{z}/{x}/{y}.png'],
		tileSize: 256,
	  });
  
	  map.addLayer({
		id: 'osm-raster-tiles',
		type: 'raster',
		source: 'osm-raster-tiles',
		paint: {
		  'raster-saturation': -1,
		  'raster-opacity': 0.42,
		},
	  });
  
	  // Call renderChart when the map is initialized
	  renderChart();
    });
  
	// Function to update the map and chart when the city changes
	function updateMapAndChart() {
	//   const { lat, long } = cityCoordinates[selectedCity];

	  const lat = cityCoordinates[selectedCity].lat;
	  const long = cityCoordinates[selectedCity].long;	  

	  map.flyTo({ center: [long, lat], zoom: 12, duration: 50 });
	  renderChart();
	}

	  // Watch for changes in layer visibility
	  $: {
		if (map) {
		  map.setPaintProperty('hdbscan_downtowns', 'fill-opacity', showHDBSCANDowntowns ? 0.4 : 0);
		  map.setPaintProperty('old_downtowns', 'fill-opacity', showOldDowntowns ? 0.4 : 0);
		}
	  }	
  </script>
  
  <svelte:window bind:innerHeight={pageHeight} bind:innerWidth={pageWidth} />
  
  <div class="container">
  
	<div class="chart-container">
	  <svg width="200" height="200"></svg>
	</div>

	<div id="map" class="map" style="height: {mapHeight}px"></div>	
  
	<div>
	  <div>
		<label for="cityDropdown">Select a city:</label>
		<select bind:value={selectedCity} on:change={updateMapAndChart}>
		  {#each Object.keys(cityCoordinates) as city}
			<option value={city}>{city}</option>
		  {/each}
		</select>
	  </div>

	  <br>

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
			Zip code
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
	  flex-direction: row;
	  justify-content: space-between;
	  align-items: flex-start;
	  max-width: 1200px;
	  margin: 0 auto;
	}
  
	.chart-container {
	  width: 40%;
	  height: 100%;
	  margin: 0 auto;
	  max-width: 900px;
	}
  
	.map {
	  width: 40%;
	  height: 100%;
	  margin: 20px;
	  max-width: 900px;
	  background-color: white;
	}
  
	#sidebar {
	  width: 30%;
	}
  </style>
  