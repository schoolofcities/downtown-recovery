<script>
	import { onMount } from 'svelte';
	import maplibregl from 'maplibre-gl';
	import hdbscan_downtowns from '../../../../assets/HDBSCAN_downtowns_with_province.geo.json';
	import old_downtowns from '../../../../assets/old_study_areas.geo.json';
	import comm_downtowns from '../../../../assets/all_commercial.geo.json';
	import citydefined_downtowns from '../../../../assets/city_defined_sarah.geo.json';
	import { cityCoordinates } from './city_coords.js';
	import { csvParse } from "d3-dsv";
	import { scaleLinear, scaleBand, select, axisBottom, axisLeft, format } from 'd3';
  
	let pageHeight;
	let pageWidth;
  
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

	function renderChart() {
		updateChartData();
		const margin = { top: 3, right: 0, bottom: 0, left: 3 };
		const width = 200;
		const height = 350;

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
				} else if (d.label === 'Office/retail') {
					return '#AB1368'; // Add 'red' color for the 'Office/retail' label
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
				} else if (d.label === 'Office/retail') {
					return '#AB1368'; // Add 'red' color for the 'Office/retail' label
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
  
	  // Call renderChart when the map is initialized
	  renderChart();
    });
  
	// Function to update the map and chart when the city changes
	async function updateMapAndChart() {

	  await loadURL(selectedCity);

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

	  

	let svgWidth;
	$: console.log(selectedCity);

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
			City-defined
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
					width={svgWidth * 0.8 / 1.3}
					height="20px" 
					stroke="#00A189" 
					stroke-width="2" 
					fill="#00A189" 
					fill-opacity=0.2 
				/>
				<text
					x={8 + svgWidth * 0.8 / 1.3}
					y="91"
					class="svg-data-label">
					{Math.round(100 * 0.8)}%
				</text>
			{/if}
		</svg>
	</div>
	<!-- <div class="chart-container" style="max-width: 250px">
		<p class="rec_label">Recovery rate:</p>
		<svg width="300" height="400"></svg>
	  </div> -->
  </div>

  <div class="container">
	<div id="map" class="map" style="height: {mapHeight}px"></div>	
  </div>

  <br>
  <h2>How are downtowns usually defined?</h2>
  <p>Since there is no standard spatial definition of "downtown," researchers have relied on a variety of methods to create geographic boundaries for this area. Downtowns, which typically include the oldest, most established parts of a city, can be as small as a few city blocks or as large as several square miles.<a href="#footnote-1">[1]</a></p>
  <p>Since the US Census Bureau stopped collecting data for “central business districts” – another term for downtowns – in 1984, these boundaries have often been constructed using existing spatial units like census tracts.<a href="#footnote-2">[2]</a> For example, researchers at the Brookings Institution defined the central business district in US cities as the census block with the highest job density and number of jobs in the region, and then identified the "commercial core" as the neighboring block groups with high density development and high ratios of jobs to residents.<a href="#footnote-3">[3]</a></p>
  <p>Other methods for defining downtown include using a specific distance threshold from the "100 percent corner" (the urban intersection with the highest land value), examining historic maps and street grids, and asking city officials and leaders for their local expertise.<a href="#footnote-1">[1,</a><a href="#footnote-2">2]</a></p>
  <p>All of these methodologies have their shortcomings; for example, they generally do not account for the fact that some cities are polycentric and have multiple downtown areas.<a href="#footnote-4">[4]</a> Given the heterogeneity of urban regions – with tremendous variety in their economic context, built environment, and geographic scale – there also may not be a standard definition of downtown that works well for multiple cities.</p>
  <p>Because it is so challenging to come up with a single definition of downtown, we created multiple downtown polygons for each city. Use the drop-down menu above to select a city and compare the “recovery rates” of the different downtown boundaries (see our <a href='https://downtownrecovery.com/methodology' target='_blank'>methodology page</a> to learn more about how these rates were calculated).</p>
  <br>
  <h2>How did we define downtown?</h2>
  <h4>HDBSCAN</h4>   
  <p class="indented-paragraph">
    The <i>HDBSCAN</i> polygons are used to determine our current <a href='https://downtownrecovery.com/charts/rankings' target='_blank'>recovery rankings</a>. Read the <i>Downtown Geography Selection</i> section of our <a href='https://downtownrecovery.com/methodology' target='_blank'>Methodology page</a> to learn about how the 'HDBSCAN' polygons were created.
  </p>   
  <h4>Zip code</h4> 
  <p class="indented-paragraph">
    The <i>Zip code</i> polygons, which were used to determine our previous <a href='https://downtownrecovery.com/charts/rankings_archived' target='_blank'>recovery rankings</a>, were created by selecting the zip code (in the US) or group of dissemination areas (in Canada) in each city with the highest job density. Read the <i>SafeGraph and Spectus Data and Downtown Definitions</i> section of our <a href='https://downtownrecovery.com/death_of_downtown_policy_brief.pdf' target='_blank'>policy brief</a> to learn more.
  </p> 
  <h4>Office/retail</h4> 
  <p class="indented-paragraph">
    The <i>Office/retail</i> polygons represent areas of high commercial and economic activity in the urban core. These boundaries were created using an unsupervised image segmentation model that combines office and retail data from OpenStreetMap with jobs data from 2019 (<a href='https://lehd.ces.census.gov/data/'>in the U.S.</a>) and 2016 (<a href='http://odesi2.scholarsportal.info/documentation/CENSUS/2016/cen16labour.html'>in Canada</a>). The model results in multiple spatial clusters in each city, which were assigned scores based on their size as well as their level of retail, job and office density. The cluster with the highest score that also overlapped with the original zip code-level downtown boundary was selected as the final polygon.
  </p> 
  <h4>City-defined</h4> 
  <p class="indented-paragraph">
	The <i>City-defined</i> polygons represent cities' own definitions of their downtown boundaries. The shapefiles were either downloaded directly from public websites, like open data portals, or created manually in GIS based on static maps.
  </p>  
  <p class="indented-paragraph">
	<i>Click <a href={cityURL} target='_blank'>here</a> for the source of {selectedCity.replace(/\s\w{2}$/, '')}'s downtown boundary.</i>   
  <p class="indented-paragraph">
	<i>Click <a href="../citydefined_list.csv">here</a> to download a list of sources for all city-defined downtown polygons.</i>
  </p>

  <br><br>
  <p id="footnote-1" class="footnotes">[1] <a href='https://books.google.com/books?hl=en&lr=&id=817RDAAAQBAJ&oi=fnd&pg=PA63&dq=downtown+definition&ots=UFs6KoHQF_&sig=IZmIngj2QEsdRx9lGR_RFIdQ_CI#v=onepage&q=downtown%20definition&f=false'>Sohmer, Rebecca R, and Robert E Lang. "Downtown Rebound." Redefining Urban and Suburban America: Evidence from Census 2000, Brookings Institution Press, Washington, D.C., 2006.</a></p>
  <p id="footnote-2" class="footnotes">[2] <a href='https://static1.squarespace.com/static/5bc02d0d7a1fbd0d56ea7ec7/t/5bc8ebdfb208fc74126a6b82/1539894240627/Birch_2005_Who_Lives_Downtown.pdf'>Birch, Eugenie L. 2005, Who Lives Downtown.</a></p>
  <p id="footnote-3" class="footnotes">[3] <a href='https://www.brookings.edu/articles/breaking-the-urban-doom-loop-the-future-of-downtowns-is-shared-prosperity/'>Hadden Loh, Tracy, and Hanna Love. Breaking the 'Urban Doom Loop': The Future of Downtowns Is Shared Prosperity.</a></p>
  <p id="footnote-4" class="footnotes">[4] <a href='https://journals.sagepub.com/doi/epdf/10.1177/0002716209344169'>Birch, Eugenie L. "Downtown in the new American city." The annals of the American academy of political and social science 626.1 (2009): 134-153.</a></p>	  

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

	.container {
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
  
	.chart-container {
	  width: 60%;
	  height: 100%;
	  margin: 0 auto;
	  max-width: 900px;
	}
  
	.map {
	  width: 100%;
	  height: 100%;
	  /* margin: 20px; */
	  max-width: 900px;
	  border: solid 1px var(--brandDarkBlue);
	  /* background-color: black; */
	}
  
	.sidebar {
	  width: 60%;
	  margin: 15px;
	  /* display: flex;
	  flex-direction: row;
	  justify-content: space-between;
	  align-items: flex-end; */
	  margin-top: 30px;
	}

    .indented-paragraph {
	  margin-left: .6em;
    }	

    .authors {
	  font-size: 12px;
    }		

	.rec_label {
		margin-bottom: 20px;
		margin-top: 0px;
	}

	.footnotes {
		font-size: 11px;
	}
  </style>