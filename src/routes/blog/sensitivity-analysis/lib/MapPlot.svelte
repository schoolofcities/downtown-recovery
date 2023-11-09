<script>
	import { onMount } from 'svelte';
	import maplibregl from 'maplibre-gl';
	import hdbscan_downtowns from '../../../../assets/HDBSCAN_downtowns_with_province.geo.json';
	import old_downtowns from '../../../../assets/old_study_areas.geo.json';
	import { cityCoordinates } from './city_coords.js';
	import { scaleLinear, scaleBand, select, axisBottom, axisLeft, format } from 'd3';
  
	let pageHeight;
	let pageWidth;
  
	/**
	 * @type {import("maplibre-gl").Map}
	 */
	let map;
  
	let mapHeight = 400;
	$: if (pageHeight < 600) {
	  mapHeight = pageHeight - 200;
	} else {
	  mapHeight = 400;
	}
  
	let selectedCity = 'Albuquerque NM'; // Default city
  
	let showHDBSCANDowntowns = true; // Initial visibility
	let showOldDowntowns = false; // Initial visibility
  
	let chartData = [];
  
	function updateChartData() {
	  const selectedData = cityCoordinates[selectedCity];
	  chartData = [
		{ label: 'Commercial', value: selectedData.rq_comm },
		{ label: 'Zip code', value: selectedData.rq_zip },
		{ label: 'HDBSCAN', value: selectedData.rq_hdbscan },
	  ];
	}

	function renderChart() {
		updateChartData();
		const margin = { top: 0, right: 20, bottom: 200, left: 0 };
		const width = 200;
		const height = 400;

		const x = scaleLinear()
			.domain([0, Math.max(...chartData.map((d) => d.value))])
			.nice()
			.range([margin.left, width - margin.right]);

		const y = scaleBand()
			.domain(chartData.map((d) => d.label))
			.range([height - margin.bottom, margin.top]);

		const svg = select('.chart-container > svg');
		svg.selectAll('*').remove();

		svg
			.selectAll('rect')
			.data(chartData)
			.enter()
			.append('rect')
			.attr('x', margin.left)
			.attr('y', (d) => y(d.label))
			.attr('width', (d) => x(d.value))
			.attr('height', y.bandwidth() * 0.7)
			.attr('fill', (d) => {
				// Assign colors based on the label
				if (d.label === 'HDBSCAN') {
					return '#DC4633';
				} else if (d.label === 'Zip code') {
					return '#007FA3';
				} else if (d.label === 'Commercial') {
					return '#8DBF2E'; // Add 'red' color for the 'Commercial' label
				} else {
					return 'white';
				}
			})
			.attr('fill-opacity', .5) // Set fill opacity
			.attr('stroke', (d) => {
				// Assign colors based on the label
				if (d.label === 'HDBSCAN') {
					return '#DC4633';
				} else if (d.label === 'Zip code') {
					return '#007FA3';
				} else if (d.label === 'Commercial') {
					return '#8DBF2E'; // Add 'red' color for the 'Commercial' label
				} else {
					return 'white';
				}
			})
			.attr('stroke-opacity', 1) // Set border opacity	
			.attr('stroke-width', 3);		

		// Add labels on top of the bars
		svg
			.selectAll('text')
			.data(chartData)
			.enter()
			.append('text')
			.text((d) => `${d.label}: ${format('.0%')(d.value)}`)
			.attr('x', margin.left + 6)
			.attr('y', (d) => y(d.label) + y.bandwidth()/3)
			.attr('dy', '0.35em')
			.attr('font-size', '12px')
			.attr('fill', 'white');

		svg
			.append('g')
			.attr('transform', `translate(0,${height - margin.bottom})`)
			// .call(xAxis);

		svg
			.append('g')
			.attr('transform', `translate(${margin.left},0)`)
			// .call(axisLeft(y));
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
				'raster-brightness-min': 0.25,
				'raster-brightness-max': 0.95,
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
		  'fill-color': '#DC4633',
		  'fill-opacity': showHDBSCANDowntowns ? 0.5 : 0,
		},
	  });

	  map.addLayer({
		id: 'hdbscan_downtowns_stroke',
		type: 'line', // Use 'line' type for the border/stroke
		source: 'hdbscan_downtowns',
		paint: {
			'line-color': '#DC4633', // Set the border color
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
		  'fill-color': '#007FA3',
		  'fill-opacity': showOldDowntowns ? 0.5 : 0,
		},
	  });

	  map.addLayer({
		id: 'old_downtowns_stroke',
		type: 'line', // Use 'line' type for the border/stroke
		source: 'old_downtowns',
		paint: {
			'line-color': '#007FA3', // Set the border color
			'line-opacity': 1, // Set the border opacity to 1
			'line-width': 3, // Adjust the border width as needed
		},
	  });		
  
	  // Call renderChart when the map is initialized
	  renderChart();
    });
  
	// Function to update the map and chart when the city changes
	function updateMapAndChart() {

	  const lat = cityCoordinates[selectedCity].lat;
	  const long = cityCoordinates[selectedCity].long;	  

	  map.flyTo({ center: [long, lat], zoom: 12, duration: 50 });
	  renderChart();
	}

	  // Watch for changes in layer visibility
	  $: {
		if (map) {
		  map.setPaintProperty('hdbscan_downtowns_fill', 'fill-opacity', showHDBSCANDowntowns ? 0.4 : 0);
		  map.setLayoutProperty('hdbscan_downtowns_stroke', 'visibility', showHDBSCANDowntowns ? 'visible' : 'none'); 
		  map.setPaintProperty('old_downtowns_fill', 'fill-opacity', showOldDowntowns ? 0.4 : 0);
		  map.setLayoutProperty('old_downtowns_stroke', 'visibility', showOldDowntowns ? 'visible' : 'none'); 
		}
	  }	
  </script>
  
  <svelte:window bind:innerHeight={pageHeight} bind:innerWidth={pageWidth} />
  
  <div class="dropdown">
	<label for="cityDropdown">Select a city:</label>
	<select bind:value={selectedCity} on:change={updateMapAndChart}>
	  {#each Object.keys(cityCoordinates) as city}
		<option value={city}>{city}</option>
	  {/each}
	</select>
  </div>

  <div class="container">
  
	<div class="chart-container" style="max-width: 250px">
	  <svg width="300" height="400"></svg>
	</div>

	<div id="map" class="map" style="height: {mapHeight}px"></div>	

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
	</div>	
  </div>
  
  <style>

	.dropdown {
		margin-top: 30px; 
		margin-bottom: 30px; 
	}

	.container {
	  display: flex;
	  flex-direction: row;
	  justify-content: space-between;
	  align-items: flex-start;
	  max-width: 1200px;
	  margin: 0 auto;
	}
  
	.chart-container {
	  width: 60%;
	  height: 100%;
	  margin: 0 auto;
	  max-width: 900px;
	}
  
	.map {
	  width: 70%;
	  height: 100%;
	  /* margin: 20px; */
	  max-width: 900px;
	  /* background-color: black; */
	}
  
	#sidebar {
	  width: 30%;
	  margin-left: 15px;
	}
  </style>
  