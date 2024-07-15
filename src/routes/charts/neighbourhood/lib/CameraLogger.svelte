<script>
    import { onMount } from "svelte";
    import { writable } from "svelte/store";
    import * as maplibregl from "maplibre-gl";
  
    export let map;
  
    const center = writable(null);
    const zoom = writable(null);
    const bearing = writable(null);
    const pitch = writable(null);
  
    // Log current camera parameters
    function logCurrentCameraParameters() {
      center.set(map.getCenter());
      zoom.set(map.getZoom());
      bearing.set(map.getBearing());
      pitch.set(map.getPitch());
  
      console.log('Current Camera Parameters:');
      console.log('Center:', $center);
      console.log('Zoom:', $zoom);
      console.log('Bearing:', $bearing);
      console.log('Pitch:', $pitch);
    }
  
    onMount(async() => {
      if (map) {
        logCurrentCameraParameters();
        map.on('moveend', logCurrentCameraParameters);
      }
    });
  </script>