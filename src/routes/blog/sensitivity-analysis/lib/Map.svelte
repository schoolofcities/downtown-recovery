<script>

	import { onMount } from 'svelte';
	import maplibregl from 'maplibre-gl';
	import hdbscan_downtowns from '../../../../assets/HDBSCAN_downtowns_with_province.geo.json';
	import old_downtowns from '../../../../assets/old_study_areas.geo.json';

	let pageHeight;
	let pageWidth;
	/**
     * @type {import("maplibre-gl").Map}
     */
	let map;

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
			center: [-79.386, 43.653], 
			zoom: 12,
			minZoom: 9,
			maxZoom: 13,
			bearing: 0,
			projection: 'globe',
			scrollZoom: true,
			attributionControl: false
		});

		map.dragRotate.disable();
		map.touchZoomRotate.disableRotation();
		// map.scrollZoom.disable();

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
                   'fill-color': 'orange',
                   'fill-opacity': showOldDowntowns ? 0.4 : 0,
               }
        });	

		map.addSource('osm-raster-tiles', {
			'type': 'raster',
			'tiles': ['https://tile.openstreetmap.org/{z}/{x}/{y}.png'],
			'tileSize': 256,
			'minzoom': 0,
			'maxzoom': 19
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

</script>

<svelte:window bind:innerHeight={pageHeight} bind:innerWidth={pageWidth}/>

<div id="map" style="height: {mapHeight}px"></div>

<div id="bottombar">
	<div>
		<label>
		<input type="checkbox" bind:checked={showHDBSCANDowntowns} />
		HDBSCAN
		</label>
	</div>
	<div>
		<label>
		<input type="checkbox" bind:checked={showOldDowntowns} />
		Zip code (former definition)
		</label>
	</div>
	<p id='data_sources'>Data Sources: OpenStreetMap</p>
</div>

<!-- <p>Data Sources: OpenStreetMap</p> -->

<style>
	#map {
		width: 100%;
		margin: 0 auto;
		max-width: 1200px;
		/* border-top: 1px solid var(--brandBlack);
		border-bottom: 1px solid var(--brandBlack); */
		background-color: white;
	}

	#bottombar {
		margin-left: 20px;
		margin-right: 10px;
	}

	#data_sources {
		margin: 0 auto;
		text-align: right;
		font-size: 12px;
		max-width: 1200px;
		color: white;		
	}
	
</style>