<script>
	import { onMount } from "svelte";
    import * as maplibregl from "maplibre-gl";
	import * as pmtiles from "pmtiles";
	import GeoJSON from "../../../assets/high-point-geohashes-grid.geo.json";
	import "maplibre-gl/dist/maplibre-gl.css";

	let map;

	let scale = new maplibregl.ScaleControl({
        maxWidth: 100,
        unit: "metric",
    });

	// const maxBounds = [
	// 	[-80.1, 35.9], // SW coords
	// 	[-79.9, 36.1] // NE coords
	// ];

	onMount(async() => {

		let protocol = new pmtiles.Protocol();
        maplibregl.addProtocol("pmtiles", protocol.tile);

		map = new maplibregl.Map({
			container: "map",
			style: 'https://basemaps.cartocdn.com/gl/dark-matter-gl-style/style.json', // Carto dark style URL
            center: [-79.997, 35.9615],
            zoom: 8.5,
            pitch: 60,
            // maxPitch: 85,
            // maxZoom: 30,
            // minZoom: 10,
            bearing: 25,
            projection: "globe",
            scrollZoom: true,
            // maxBounds: maxBounds,
            attributionControl: true,
            antialias: true,
		});

		map.addControl(scale, "bottom-left");
		map.addControl(new maplibregl.NavigationControl(), 'top-left');

		map.on("load", () => {

			map.addSource("GeoJSON-Grid", {
			type: "geojson",
			data: GeoJSON,
			});

			map.addLayer({
			id: "base-layer",
			type: "fill-extrusion",
			source: "GeoJSON-Grid",
			paint: {
          		"fill-extrusion-color": "rgba(211, 169, 40, 1)",
          		"fill-extrusion-height": ["*", ["get", "stops"], 0.1],
				"fill-extrusion-base": 0,
			},
		});
		
	
	});

});

</script>

<div id="map"/>

<style>
    #map {
        position: fixed;
        width: 100%;
        height: 100%;
    }
  </style>