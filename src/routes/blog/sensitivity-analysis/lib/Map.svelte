<script>

	import { onMount } from 'svelte';
	import maplibregl from 'maplibre-gl';
	// import downtownsHdbscan from './HDBSCAN_downtowns_with_province.geojson';

	let pageHeight;
	let pageWidth;
	let map;

	let mapHeight = 600;
	$: if (pageHeight < 800) {
		mapHeight = pageHeight - 200;
	} else {
		mapHeight = 600
	}

	onMount(() => {

		map = new maplibregl.Map({
			container: 'map',
			center: [-79.36, 43.715], 
			zoom: 10.5,
			minZoom: 9,
			maxZoom: 13,
			bearing: 0,
			// maxBounds: [ 
			// 	[-80.28, 43.21], 
			// 	[-77.88, 44.91] 
			// ],
			projection: 'globe',
			scrollZoom: true,
			attributionControl: false
		});

		map.dragRotate.disable();
		map.touchZoomRotate.disableRotation();
		// map.scrollZoom.disable();

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
		
		map.addSource('hdbscan-data', {
			'type': 'geojson',
			'data': downtownsHdbscan
			// 'data': 'C:/Users/jpg23/git/website_downtownrecovery/downtown-recovery/src/routes/blog/sensitivity-analysis/lib/HDBSCAN_downtowns_with_province.geo.json'
			// 'data': 'HDBSCAN_downtowns_with_province.geo.json'
		});
		map.addLayer({
                'id': 'hdbscan-data',
                'type': 'fill',
                'source': 'hdbscan-data',
                'paint': {
                    'fill-color': '#888888',
                    'fill-outline-color': 'red',
                    'fill-opacity': 0.4
                }
            });		
		
	});

</script>




<svelte:window bind:innerHeight={pageHeight} bind:innerWidth={pageWidth}/>

<div id="map" style="height: {mapHeight}px"></div>

<p>Data Sources: OpenStreetMap</p>




<style>
	#map {
		width: 100%;
		margin: 0 auto;
		max-width: 1200px;
		/* border-top: 1px solid var(--brandBlack);
		border-bottom: 1px solid var(--brandBlack); */
		background-color: white;
	}
	p {
		margin: 0 auto;
		text-align: right;
		font-size: 10px;
		max-width: 1200px;
		color: var(--brandBlack);
	}
</style>