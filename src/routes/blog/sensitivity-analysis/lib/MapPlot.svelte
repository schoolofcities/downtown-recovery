<script>
	import { onMount } from 'svelte';
	import maplibregl from 'maplibre-gl';
	import hdbscan_downtowns from '../../../../assets/HDBSCAN_downtowns_with_province.geo.json';
	import old_downtowns from '../../../../assets/old_study_areas.geo.json';
	import comm_downtowns from '../../../../assets/all_commercial.geo.json';
	import citydefined_downtowns from '../../../../assets/city_defined_sarah.geo.json';
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
	let showOldDowntowns = false;
	let showCommDowntowns = false;	
	let showCityDowntowns = false;
  
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
		const margin = { top: 3, right: 0, bottom: 0, left: 3 };
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
					return '#F1C500';
				} else if (d.label === 'Zip code') {
					return '#6FC7EA';
				} else if (d.label === 'Commercial') {
					return '#AB1368'; // Add 'red' color for the 'Commercial' label
				} else {
					return 'white';
				}
			})
			.attr('fill-opacity', .2) // Set fill opacity
			.attr('stroke', (d) => {
				// Assign colors based on the label
				if (d.label === 'HDBSCAN') {
					return '#F1C500';
				} else if (d.label === 'Zip code') {
					return '#6FC7EA';
				} else if (d.label === 'Commercial') {
					return '#AB1368'; // Add 'red' color for the 'Commercial' label
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
			.attr('font-size', '14px')
			.attr('font-family', 'Roboto')
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
  </script>
  
  <svelte:window bind:innerHeight={pageHeight} bind:innerWidth={pageWidth} />
  
  <div class="top-container">
	<div class="dropdown">
		<label for="cityDropdown">Select a city:</label>
		<select bind:value={selectedCity} on:change={updateMapAndChart}>
		  {#each Object.keys(cityCoordinates) as city}
			<option value={city}>{city}</option>
		  {/each}
		</select>
	</div>

	<div class="sidebar">
		<div class='hdbscan-check'>
			<label>
			<input type="checkbox" bind:checked={showHDBSCANDowntowns} />
			HDBSCAN
			</label>
		</div>
		<div class='old-check'>
			<label>
			<input type="checkbox" bind:checked={showOldDowntowns} />
			Zip code
			</label>
		</div>
		<div class='comm-check'>
			<label>
			<input type="checkbox" bind:checked={showCommDowntowns} />
			Commercial
			</label>
		</div>	
		<div class='city-check'>
			<label>
			<input type="checkbox" bind:checked={showCityDowntowns} />
			City-defined
			</label>
		</div>				
	</div>	
  </div>

  <div class="container">
  
	<div class="chart-container" style="max-width: 250px">
	  <svg width="300" height="400"></svg>
	</div>

	<div id="map" class="map" style="height: {mapHeight}px"></div>	
  </div>
  
  <style>

	.dropdown {
		margin-top: 30px; 
		margin-bottom: 30px; 
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
	
	.top-container {
	  display: flex;
	  flex-direction: row;
	  justify-content: space-between;
	  align-items: flex-start;
	  max-width: 1200px;
	  margin: 0 auto;
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
  
	.sidebar {
	  width: 65%;
	  margin: 15px;
	  display: flex;
	  flex-direction: row;
	  justify-content: space-between;
	  align-items: flex-end;
	  margin-top: 30px;
	}
  </style>