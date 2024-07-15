<script>
	import Header from '../../../lib/Header.svelte';
	import '../../../assets/global.css';
	import { onMount } from 'svelte';
    import * as maplibregl from 'maplibre-gl';
	import * as pmtiles from 'pmtiles';
	import GeoJSON from '../../../assets/high-point-geohashes-grid.geo.json';
	import 'maplibre-gl/dist/maplibre-gl.css';
	import { tweened } from 'svelte/motion';
	import { cubicOut } from 'svelte/easing';
	import { writable } from 'svelte/store';
	import CameraLogger from './lib/CameraLogger.svelte';

	let map;
	let scale = new maplibregl.ScaleControl({
        maxWidth: 100,
        unit: 'metric',
    });

	const tweenedValue = tweened(0, {
      duration: 300,
      easing: cubicOut,
    });

	const tweenStore = writable(0);
	tweenedValue.subscribe(value => tweenStore.set(value));

	let isOn;
  
    function toggle() {
      isOn = !isOn;
      tweenedValue.set(isOn ? 1 : 0);
    }

	// Normalized stops values
	GeoJSON.features.forEach(feature => {
		const stops = feature.properties.stops;
		const dailyStops = (20 * stops) / 365 ;
		feature.properties.dailyStops = dailyStops;
	});

	// const maxBounds = [
	// 	[-80.1, 35.9], // SW coords
	// 	[-79.9, 36.1] // NE coords
	// ];

	onMount(async() => {

		let protocol = new pmtiles.Protocol();
        maplibregl.addProtocol('pmtiles', protocol.tile);

		map = new maplibregl.Map({
			container: 'map',
			style: 'https://basemaps.cartocdn.com/gl/dark-matter-gl-style/style.json', // Carto dark style URL
            center: [-79.81007479731534, 36.03345131099759],
            zoom: 9.15,
            pitch: 0,
            // maxPitch: 85,
            // maxZoom: 30,
            // minZoom: 10,
            bearing: 0,
            projection: 'globe',
            scrollZoom: true,
            // maxBounds: maxBounds,
            attributionControl: true,
            antialias: true,
		});

		// Add controls
		map.addControl(scale, 'bottom-left');
		map.addControl(new maplibregl.NavigationControl(), 'top-left');

		map.on('load', () => {

			map.addSource('GeoJSON-Grid', {
			type: 'geojson',
			data: GeoJSON,
			});

			// Data
			map.addLayer({
			id: 'data-layer',
			type: 'fill-extrusion',
			source: 'GeoJSON-Grid',
			paint: {
          		'fill-extrusion-color': [
					'step',
					['get', 'dailyStops'],
						'#FFCB30',
						500,
						'#FFA930',
						2500,
						'#FF8730',
						5000,
						'#FF6430',
				],
				'fill-extrusion-opacity': 0.85,
          		'fill-extrusion-height': ['*', ['get', 'dailyStops'], $tweenStore],
				'fill-extrusion-base': 0,
			},
			filter: ['>', ['get', 'dailyStops'], -1] // Threshold filter

		});
	});

});

  $: if (map) {
        const layer = map.getLayer('data-layer');
        if (layer) {
            map.setPaintProperty('data-layer', 'fill-extrusion-height', ['*', ['get', 'dailyStops'], $tweenStore]);
        }
    }

</script>

<Header/>


<main>
	<div class='text'>
		<h1>
			Lorem Ipsum
		</h1>
		<p>
			<i>Updated </i>
		</p>
		<p>
			By <a href=''>Author 1</a>, <a href=''>Author 2</a>, <a href=''>Author 3</a>
		</p>
		<p>
			Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ullamcorper lectus vitae ex posuere vestibulum. Curabitur dapibus est eget sagittis faucibus. Praesent id urna velit. Sed ullamcorper urna libero, interdum congue lorem venenatis a. Aenean auctor nunc hendrerit nunc pellentesque, nec congue mauris vehicula. Proin sit amet pellentesque leo, vitae scelerisque velit. Nunc congue pulvinar felis id mollis. Praesent mattis libero ex, in venenatis orci pharetra et. Praesent ultrices gravida rhoncus.
		</p>
		<p>
			Praesent varius rhoncus libero eu gravida. Suspendisse vestibulum tellus a pharetra lobortis. Phasellus pulvinar nunc et ligula blandit, a suscipit tortor blandit. Ut eget molestie mi. Morbi non dictum erat. Mauris vehicula tempor nulla, porta dignissim libero ullamcorper a. Aenean vestibulum congue turpis, non consequat tellus egestas ut. Fusce fermentum vulputate dui, lacinia blandit ipsum semper et. Nunc et sollicitudin erat, sit amet egestas lectus. Fusce vulputate ex convallis sollicitudin faucibus.
		</p>
	<h5>High Point Visits Per Day</h5>

	<div id='map'/>

	<button on:click={toggle}>
		{isOn ? '3D' : '2D'}
	</button>

	<CameraLogger { map }/>

	<div id='legend'>
		<svg width='300' height='40' xmlns='http://www.w3.org/2000/svg'>
			<rect x='0' y='0' width='75' height='15' fill='#D3A928'/>
			<rect x='75' y='0' width='75' height='15' fill='#D38D28'/>
			<rect x='150' y='0' width='75' height='15' fill='#D37028'/>
			<rect x='225' y='0' width='75' height='15' fill='#D35428'/>
			<text class='legend-label' x='75' y='32' text-anchor='middle' >500</text>
			<text class='legend-label' x='150' y='32' text-anchor='middle'>2,500</text>
			<text class='legend-label' x='225' y='32' text-anchor='middle'>5,000</text>
		</svg>
	</div>
	<div>
		<h5>Lorem Ipsum</h5>	
		<p>
			Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ullamcorper lectus vitae ex posuere vestibulum. Curabitur dapibus est eget sagittis faucibus. Praesent id urna velit. Sed ullamcorper urna libero, interdum congue lorem venenatis a. Aenean auctor nunc hendrerit nunc pellentesque, nec congue mauris vehicula. Proin sit amet pellentesque leo, vitae scelerisque velit. Nunc congue pulvinar felis id mollis. Praesent mattis libero ex, in venenatis orci pharetra et. Praesent ultrices gravida rhoncus.
		</p>
	</div>
</main>

<style>
    #map {
		padding-left: 10px;
		padding-right: 10px;
		margin: 0 auto;
        max-width: 760px;
        height: 500px;
    }

	#legend {
		margin: 20px auto;
		width: 300px;
	}

	.legend-label {
		fill: white;
	}
  </style>