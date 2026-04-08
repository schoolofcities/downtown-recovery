<Password/>

<script>
	import Header from "../../../lib/Header.svelte";
	import SelectRegions from "../../../lib/SelectRegions.svelte";
	import { onMount } from 'svelte';
	import { csvParse } from 'd3-dsv';
	import { scaleLinear, scaleSqrt, line } from "d3";
	import { regressionLoess } from "d3-regression";
	import { mean, sum, max as d3Max } from 'd3-array';
	import maplibregl from 'maplibre-gl';
	import 'maplibre-gl/dist/maplibre-gl.css';
	import Password from '$lib/Password.svelte';

	// Import regions and selectedRegions for color coding
	import { regions, selectedRegions } from '../../../lib/stores.js';

	// Get region color
	function getRegionColor(regionName) {
		const region = $regions.find(r => r.name === regionName);
		return region ? region.colour : '#999';
	}

	import upArrow from '../../../assets/green-arrow.svg';
	import downArrow from '../../../assets/red-arrow.svg';

	import "../../../assets/global.css";

	// Configuration
	let selection = {
		year1: 2024,
		year2: 2025,
		year3: 2026,
		period1Start: "2024-04-01",
		period1End: "2025-03-31",
		period2Start: "2025-04-01",
		period2End: "2026-03-31",
		update_date: "2026-04-08"
	}

	// Canadian province codes to filter out
	const canadianProvinces = ['BC', 'AB', 'SK', 'MB', 'ON', 'QC', 'NB', 'NS', 'PE', 'NL', 'YT', 'NT', 'NU'];

	// US Metro coordinates lookup (major metros - will be populated from data)
	const usMetroCoords = {
		"New York-Newark-Jersey City, NY-NJ-PA": [-74.006, 40.7128],
		"Los Angeles-Long Beach-Anaheim, CA": [-118.2437, 34.0522],
		"Chicago-Naperville-Elgin, IL-IN-WI": [-87.6298, 41.8781],
		"Dallas-Fort Worth-Arlington, TX": [-96.797, 32.7767],
		"Houston-The Woodlands-Sugar Land, TX": [-95.3698, 29.7604],
		"Washington-Arlington-Alexandria, DC-VA-MD-WV": [-77.0369, 38.9072],
		"Miami-Fort Lauderdale-Pompano Beach, FL": [-80.1918, 25.7617],
		"Philadelphia-Camden-Wilmington, PA-NJ-DE-MD": [-75.1652, 39.9526],
		"Atlanta-Sandy Springs-Alpharetta, GA": [-84.388, 33.749],
		"Boston-Cambridge-Newton, MA-NH": [-71.0589, 42.3601],
		"Phoenix-Mesa-Chandler, AZ": [-112.074, 33.4484],
		"San Francisco-Oakland-Berkeley, CA": [-122.4194, 37.7749],
		"Riverside-San Bernardino-Ontario, CA": [-117.3961, 33.9533],
		"Detroit-Warren-Dearborn, MI": [-83.0458, 42.3314],
		"Seattle-Tacoma-Bellevue, WA": [-122.3321, 47.6062],
		"Minneapolis-St. Paul-Bloomington, MN-WI": [-93.265, 44.9778],
		"San Diego-Chula Vista-Carlsbad, CA": [-117.1611, 32.7157],
		"Tampa-St. Petersburg-Clearwater, FL": [-82.4572, 27.9506],
		"Denver-Aurora-Lakewood, CO": [-104.9903, 39.7392],
		"St. Louis, MO-IL": [-90.1994, 38.627],
		"Baltimore-Columbia-Towson, MD": [-76.6122, 39.2904],
		"Orlando-Kissimmee-Sanford, FL": [-81.3792, 28.5383],
		"Charlotte-Concord-Gastonia, NC-SC": [-80.8431, 35.2271],
		"San Antonio-New Braunfels, TX": [-98.4936, 29.4241],
		"Portland-Vancouver-Hillsboro, OR-WA": [-122.6765, 45.5152],
		"Sacramento-Roseville-Folsom, CA": [-121.4944, 38.5816],
		"Pittsburgh, PA": [-79.9959, 40.4406],
		"Las Vegas-Henderson-Paradise, NV": [-115.1398, 36.1699],
		"Austin-Round Rock-Georgetown, TX": [-97.7431, 30.2672],
		"Cincinnati, OH-KY-IN": [-84.512, 39.1031],
		"Kansas City, MO-KS": [-94.5786, 39.0997],
		"Columbus, OH": [-82.9988, 39.9612],
		"Cleveland-Elyria, OH": [-81.6944, 41.4993],
		"Indianapolis-Carmel-Anderson, IN": [-86.1581, 39.7684],
		"San Jose-Sunnyvale-Santa Clara, CA": [-121.8863, 37.3382],
		"Nashville-Davidson--Murfreesboro--Franklin, TN": [-86.7816, 36.1627],
		"Virginia Beach-Norfolk-Newport News, VA-NC": [-76.2859, 36.8529],
		"Providence-Warwick, RI-MA": [-71.4128, 41.824],
		"Milwaukee-Waukesha, WI": [-87.9065, 43.0389],
		"Jacksonville, FL": [-81.6557, 30.3322],
		"Oklahoma City, OK": [-97.5164, 35.4676],
		"Raleigh-Cary, NC": [-78.6382, 35.7796],
		"Memphis, TN-MS-AR": [-90.049, 35.1495],
		"Richmond, VA": [-77.436, 37.5407],
		"New Orleans-Metairie, LA": [-90.0715, 29.9511],
		"Louisville/Jefferson County, KY-IN": [-85.7585, 38.2527],
		"Salt Lake City, UT": [-111.891, 40.7608],
		"Hartford-East Hartford-Middletown, CT": [-72.6851, 41.7658],
		"Buffalo-Cheektowaga, NY": [-78.8784, 42.8864],
		"Birmingham-Hoover, AL": [-86.8025, 33.5207],
		"Rochester, NY": [-77.6109, 43.1566],
		"Grand Rapids-Kentwood, MI": [-85.6681, 42.9634],
		"Tucson, AZ": [-110.9747, 32.2226],
		"Honolulu, HI": [-157.8583, 21.3069],
		"Tulsa, OK": [-95.9928, 36.154],
		"Fresno, CA": [-119.7871, 36.7378],
		"Bridgeport-Stamford-Norwalk, CT": [-73.2052, 41.1792],
		"El Paso, TX": [-106.485, 31.7619],
		"Albany-Schenectady-Troy, NY": [-73.7562, 42.6526],
		"Albuquerque, NM": [-106.6504, 35.0844],
		"Omaha-Council Bluffs, NE-IA": [-95.9345, 41.2565],
		"New Haven-Milford, CT": [-72.9279, 41.3083],
		"Bakersfield, CA": [-119.0187, 35.3733],
		"Knoxville, TN": [-83.9207, 35.9606],
		"Greenville-Anderson, SC": [-82.3940, 34.8526],
		"Dayton-Kettering, OH": [-84.1916, 39.7589],
		"Baton Rouge, LA": [-91.1403, 30.4515],
		"Sarasota-Bradenton-Venice, FL": [-82.5308, 27.3364],
		"Little Rock-North Little Rock-Conway, AR": [-92.2896, 34.7465],
		"Charleston-North Charleston, SC": [-79.9311, 32.7765],
		"Colorado Springs, CO": [-104.8214, 38.8339],
		"Boise City, ID": [-116.2023, 43.615],
		"Syracuse, NY": [-76.1474, 43.0481],
		"Spokane-Spokane Valley, WA": [-117.4260, 47.6588],
		"Provo-Orem, UT": [-111.6585, 40.2338],
		"Durham-Chapel Hill, NC": [-78.8986, 35.994],
		"Akron, OH": [-81.5190, 41.0814],
		"Anchorage, AK": [-149.9003, 61.2181],
		"Stockton, CA": [-121.2908, 37.9577],
		"Greensboro-High Point, NC": [-79.7920, 36.0726],
		"Toledo, OH": [-83.5379, 41.6528],
		"Wichita, KS": [-97.3301, 37.6872],
		"Cape Coral-Fort Myers, FL": [-81.9495, 26.6406],
		"Des Moines-West Des Moines, IA": [-93.6091, 41.6005],
		"Madison, WI": [-89.4012, 43.0731],
		"Springfield, MA": [-72.5898, 42.1015],
		"Winston-Salem, NC": [-80.2442, 36.0999],
		"Columbia, SC": [-81.0348, 34.0007],
		"Lakeland-Winter Haven, FL": [-81.9498, 28.0395],
		"Fayetteville-Springdale-Rogers, AR": [-94.1574, 36.0626],
		"Chattanooga, TN-GA": [-85.3097, 35.0456],
		"Scranton--Wilkes-Barre, PA": [-75.8813, 41.4090],
		"Modesto, CA": [-120.9969, 37.6391],
		"Lancaster, PA": [-76.3055, 40.0379],
		"Youngstown-Warren-Boardman, OH-PA": [-80.6495, 41.0998],
		"Deltona-Daytona Beach-Ormond Beach, FL": [-81.0228, 29.2108],
		"Palm Bay-Melbourne-Titusville, FL": [-80.6081, 28.0836],
		"North Port-Sarasota-Bradenton, FL": [-82.2381, 27.0440],
		"Portland-South Portland, ME": [-70.2553, 43.6591],
		"Lansing-East Lansing, MI": [-84.5555, 42.7325],
		"Pensacola-Ferry Pass-Brent, FL": [-87.2169, 30.4213],
		"Augusta-Richmond County, GA-SC": [-81.9746, 33.4735],
		"Harrisburg-Carlisle, PA": [-76.8867, 40.2732],
		"Fort Wayne, IN": [-85.1394, 41.0793],
		"Santa Rosa-Petaluma, CA": [-122.7141, 38.4404],
		"Lexington-Fayette, KY": [-84.5037, 38.0406],
		"Oxnard-Thousand Oaks-Ventura, CA": [-119.1792, 34.1975],
		"Corpus Christi, TX": [-97.3964, 27.8006],
		"Fayetteville, NC": [-78.8784, 35.0527],
		"Flint, MI": [-83.6875, 43.0125],
		"Savannah, GA": [-81.0998, 32.0809],
		"Killeen-Temple, TX": [-97.7278, 31.1171],
		"Beaumont-Port Arthur, TX": [-94.1266, 29.9507],
		"Brownsville-Harlingen, TX": [-97.4973, 25.9017],
		"Mobile, AL": [-88.0399, 30.6954],
		"Springfield, MO": [-93.2923, 37.2090],
		"Reading, PA": [-75.9268, 40.3356],
		"Shreveport-Bossier City, LA": [-93.7502, 32.5252],
		"Visalia, CA": [-119.2921, 36.3302],
		"Salem, OR": [-123.0351, 44.9429],
		"Tallahassee, FL": [-84.2807, 30.4383],
		"McAllen-Edinburg-Mission, TX": [-98.2300, 26.2034],
		"Canton-Massillon, OH": [-81.3784, 40.7989],
		"Trenton-Princeton, NJ": [-74.7429, 40.2206],
		"Worcester, MA-CT": [-71.8023, 42.2626],
		"Rockford, IL": [-89.0940, 42.2711],
		"Asheville, NC": [-82.5515, 35.5951],
		"Huntsville, AL": [-86.5861, 34.7304],
		"Ann Arbor, MI": [-83.7430, 42.2808],
		"Lincoln, NE": [-96.6852, 40.8258],
		"Vallejo, CA": [-122.2566, 38.1041],
		"Eugene-Springfield, OR": [-123.0868, 44.0521],
		"Lubbock, TX": [-101.8552, 33.5779],
		"Reno, NV": [-119.8138, 39.5296],
		"Peoria, IL": [-89.5890, 40.6936],
		"Atlantic City-Hammonton, NJ": [-74.4229, 39.3643],
		"Lafayette, LA": [-92.0198, 30.2241],
		"Myrtle Beach-Conway-North Myrtle Beach, SC-NC": [-78.8867, 33.6891],
		"Fort Collins, CO": [-105.0844, 40.5853],
		"Gainesville, FL": [-82.3248, 29.6516],
		"South Bend-Mishawaka, IN-MI": [-86.2520, 41.6764],
		"Boulder, CO": [-105.2705, 40.015],
		"Ogden-Clearfield, UT": [-111.9738, 41.223],
		"Evansville, IN-KY": [-87.5711, 37.9716],
		"Spartanburg, SC": [-81.9320, 34.9496],
		"Greenville, NC": [-77.3664, 35.6127],
		"Duluth, MN-WI": [-92.1005, 46.7867],
		"Green Bay, WI": [-88.0199, 44.5133],
		"Appleton, WI": [-88.4154, 44.2619],
		"Davenport-Moline-Rock Island, IA-IL": [-90.5776, 41.5236],
		"Sioux Falls, SD": [-96.7311, 43.5460],
		"Kingsport-Bristol, TN-VA": [-82.5618, 36.5484],
		"Huntington-Ashland, WV-KY-OH": [-82.4452, 38.4192],
		"Utica-Rome, NY": [-75.2327, 43.1009],
		"Kennewick-Richland, WA": [-119.2752, 46.2856],
		"Salinas, CA": [-121.6555, 36.6777],
		"Amarillo, TX": [-101.8313, 35.2220],
		"Olympia-Lacey-Tumwater, WA": [-122.9007, 47.0379],
		"College Station-Bryan, TX": [-96.3344, 30.6280],
		"Bremerton-Silverdale-Port Orchard, WA": [-122.6329, 47.5673],
		"Santa Maria-Santa Barbara, CA": [-119.6982, 34.4208],
		"Hilton Head Island-Bluffton, SC": [-80.7526, 32.2163],
		"Clarksville, TN-KY": [-87.3595, 36.5298],
		"Johnson City, TN": [-82.3535, 36.3134],
		"Crestview-Fort Walton Beach-Destin, FL": [-86.5986, 30.4213],
		"Wilmington, NC": [-77.9447, 34.2257],
		"Yakima, WA": [-120.5059, 46.6021],
		"Bellingham, WA": [-122.4788, 48.7519],
		"Medford, OR": [-122.8756, 42.3265],
		"Ocala, FL": [-82.1401, 29.1872],
		"Waco, TX": [-97.1467, 31.5493],
		"Springfield, IL": [-89.6501, 39.7817],
		"Santa Cruz-Watsonville, CA": [-122.0308, 36.9741],
		"Roanoke, VA": [-79.9414, 37.2710],
		"Topeka, KS": [-95.6890, 39.0473],
		"Merced, CA": [-120.4830, 37.3022],
		"Tyler, TX": [-95.3010, 32.3513],
		"Charlottesville, VA": [-78.4767, 38.0293],
		"Longview, TX": [-94.7405, 32.5007],
		"Macon-Bibb County, GA": [-83.6324, 32.8407],
		"Laredo, TX": [-99.5075, 27.5306],
		"Terre Haute, IN": [-87.4139, 39.4667],
		"Binghamton, NY": [-75.9180, 42.0987],
		"Lake Charles, LA": [-93.2174, 30.2266],
		"Hickory-Lenoir-Morganton, NC": [-81.3412, 35.7345],
		"Jackson, MS": [-90.1848, 32.2988],
		"Saginaw, MI": [-83.9508, 43.4195],
		"Erie, PA": [-80.0852, 42.1292],
		"Tuscaloosa, AL": [-87.5692, 33.2098],
		"Champaign-Urbana, IL": [-88.2434, 40.1164],
		"Burlington-South Burlington, VT": [-73.2121, 44.4759],
		"Bloomington, IN": [-86.5264, 39.1653],
		"Lynchburg, VA": [-79.1422, 37.4138],
		"Redding, CA": [-122.3917, 40.5865],
		"Chico, CA": [-121.8375, 39.7285],
		"State College, PA": [-77.8600, 40.7934],
		"Abilene, TX": [-99.7331, 32.4487],
		"Yuma, AZ": [-114.6277, 32.6927],
		"Hilo, HI Micro Area": [-155.0900, 19.7074],
		"Kahului-Wailuku-Lahaina, HI": [-156.4729, 20.8893],
		"Idaho Falls, ID": [-112.0340, 43.4917],
		"Monroe, LA": [-92.1193, 32.5093],
		"St. George, UT": [-113.5841, 37.0965],
		"Joplin, MO": [-94.5133, 37.0842],
		"Prescott Valley-Prescott, AZ": [-112.4685, 34.6101],
		"Eau Claire, WI": [-91.4985, 44.8113],
		"Blacksburg-Christiansburg, VA": [-80.4139, 37.2296],
		"Hagerstown-Martinsburg, MD-WV": [-77.7200, 39.6418],
		"East Stroudsburg, PA": [-75.1810, 41.0023],
		"El Centro, CA": [-115.5631, 32.7920],
		"Pueblo, CO": [-104.6091, 38.2544],
		"Bowling Green, KY": [-86.4436, 36.9685],
		"Warner Robins, GA": [-83.6243, 32.6130],
		"Dover, DE": [-75.5277, 39.1582],
		"Kingston, NY": [-74.0104, 41.9270],
		"Lebanon, NH-VT Micro Area": [-72.2517, 43.6423],
		"Jackson, TN": [-88.8139, 35.6145],
		"Columbus, GA-AL": [-84.9877, 32.4610],
		"Fort Smith, AR-OK": [-94.3985, 35.3859],
		"Janesville-Beloit, WI": [-89.0187, 42.6828],
		"Florence, SC": [-79.7625, 34.1954],
		"Gulfport-Biloxi, MS": [-88.8853, 30.3960],
		"Salisbury, MD-DE": [-75.5994, 38.3607],
		"San Luis Obispo-Paso Robles, CA": [-120.6596, 35.2828],
		"Punta Gorda, FL": [-82.0456, 26.9298],
		"Auburn-Opelika, AL": [-85.4808, 32.6099],
		"Norwich-New London, CT": [-72.0995, 41.3557],
		"Sebastian-Vero Beach, FL": [-80.3806, 27.5946],
		"Barnstable Town, MA": [-70.3000, 41.7003],
		"Iowa City, IA": [-91.5302, 41.6611],
		"Athens-Clarke County, GA": [-83.3776, 33.9519],
		"Port St. Lucie, FL": [-80.3582, 27.2939],
		"Oshkosh-Neenah, WI": [-88.5569, 44.0247],
		"Charleston, WV": [-81.6326, 38.3498],
		"Burlington, NC": [-79.4378, 36.0957],
		"Midland, TX": [-102.0779, 31.9973],
		"Odessa, TX": [-102.3676, 31.8457],
		"Racine, WI": [-87.7829, 42.7261],
		"Yuba City, CA": [-121.6169, 39.1404],
		"Tupelo, MS Micro Area": [-88.7034, 34.2576],
		"Daphne-Fairhope-Foley, AL": [-87.9036, 30.4985],
		"Greeley, CO": [-104.7091, 40.4233]
	};

	// State variables
	let processedData = [];
	let metros = [];
	let isLoading = true;
	let searchQuery = "";
	
	// View toggle: "map", "rankings" or "trends"
	let viewMode = "map";
	
	// Map variables
	let map;
	let mapContainer;
	let mapLoaded = false;
	let mapClickBound = false;
	let currentPopup = null;

	// Comparison mode for rankings
	let compareMode = "2026vs2025"; // "2026vs2025" or "2025vs2024"

	// Metro to region mapping (US states to regions)
	const stateToRegion = {
		// Midwest
		'IL': 'Midwest', 'IN': 'Midwest', 'MI': 'Midwest', 'OH': 'Midwest', 'WI': 'Midwest',
		'IA': 'Midwest', 'KS': 'Midwest', 'MN': 'Midwest', 'MO': 'Midwest', 'NE': 'Midwest',
		'ND': 'Midwest', 'SD': 'Midwest',
		// Northeast
		'CT': 'Northeast', 'ME': 'Northeast', 'MA': 'Northeast', 'NH': 'Northeast', 'RI': 'Northeast',
		'VT': 'Northeast', 'NJ': 'Northeast', 'NY': 'Northeast', 'PA': 'Northeast',
		'DE': 'Northeast', 'MD': 'Northeast',
		// Southwest
		'AZ': 'Southwest', 'NM': 'Southwest', 'OK': 'Southwest', 'TX': 'Southwest',
		'CO': 'Southwest', 'NV': 'Southwest', 'UT': 'Southwest',
		// Southeast
		'AL': 'Southeast', 'AR': 'Southeast', 'FL': 'Southeast', 'GA': 'Southeast', 'KY': 'Southeast',
		'LA': 'Southeast', 'MS': 'Southeast', 'NC': 'Southeast', 'SC': 'Southeast', 'TN': 'Southeast',
		'VA': 'Southeast', 'WV': 'Southeast',
		// Pacific
		'AK': 'Pacific', 'CA': 'Pacific', 'HI': 'Pacific', 'OR': 'Pacific', 'WA': 'Pacific', 'ID': 'Pacific'
	};

	function getMetroRegion(metroName) {
		// Extract state codes from metro name (e.g., "New York, NY" or "Dallas-Fort Worth, TX")
		const stateMatch = metroName.match(/,\s*([A-Z]{2})/);
		if (stateMatch) {
			const state = stateMatch[1];
			return stateToRegion[state] || null;
		}
		// Check for multi-state metros (e.g., "Washington, DC-VA-MD-WV")
		const multiStateMatch = metroName.match(/,\s*([A-Z]{2}(?:-[A-Z]{2})+)/);
		if (multiStateMatch) {
			const firstState = multiStateMatch[1].split('-')[0];
			return stateToRegion[firstState] || null;
		}
		return null;
	}

	// Parse date from YYYYMMDD format
	function parseDate(dateValue) {
		const dateStr = String(dateValue).trim();
		const year = parseInt(dateStr.substring(0, 4), 10);
		const month = parseInt(dateStr.substring(4, 6), 10) - 1;
		const day = parseInt(dateStr.substring(6, 8), 10);
		return new Date(year, month, day);
	}

	// Format date to YYYY-MM-DD
	function formatDate(date) {
		return date.toISOString().split('T')[0];
	}

	async function loadData() {
		isLoading = true;
		try {
			// Load normalized data directly
			const response = await fetch('/us_normalized_trips.csv');
			const csv = await response.text();
			const normalizedDataRaw = csvParse(csv);

			// Process the data
			processData(normalizedDataRaw);
		} catch (error) {
			console.error('Error loading CSV data:', error);
		}
		isLoading = false;
	}

	function processData(normalizedDataRaw) {
		const normalizedData = [];
		normalizedDataRaw.forEach(row => {
			const metro = row.METRO || row.metro;
			const dateValue = row.DATE || row.date || row.dateNum;
			const normalizedValue = row.normalized ?? row.NORMALIZED;
			if (!metro || !dateValue) return;

			const date = parseDate(dateValue);
			if (Number.isNaN(date.getTime())) return;

			normalizedData.push({
				metro,
				date,
				dateStr: formatDate(date),
				dateNum: dateValue,
				normalized: parseFloat(normalizedValue)
			});
		});

		// Filter to our date range (April 1, 2024 to March 31, 2026)
		const startDate = new Date("2024-04-01");
		const endDate = new Date("2026-03-31");
		
		processedData = normalizedData.filter(d => d.date >= startDate && d.date <= endDate);
		
		// Get unique metros
		metros = [...new Set(processedData.map(d => d.metro))].sort();
	}

	onMount(() => {
		loadData();
	});

	// Destroy map when leaving map view
	$: if (map && viewMode !== "map") {
		map.remove();
		map = null;
		mapLoaded = false;
		mapClickBound = false;
		currentPopup = null;
	}

	// Initialize map when switching to map view
	$: if (mapContainer && viewMode === "map" && !map) {
		initMap();
	}

	function initMap() {
		if (!mapContainer || map) return;
		
		map = new maplibregl.Map({
			container: mapContainer,
			style: {
				version: 8,
				sources: {
					'carto-dark': {
						type: 'raster',
						tiles: ['https://basemaps.cartocdn.com/rastertiles/dark_all/{z}/{x}/{y}{r}.png'],
						tileSize: 256,
						attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="https://carto.com/attributions">CARTO</a>'
					}
				},
				layers: [{
					id: 'carto-dark-layer',
					type: 'raster',
					source: 'carto-dark',
					minzoom: 0,
					maxzoom: 19
				}]
			},
			center: [-98, 39], // Center of US
			zoom: 3.5,
			minZoom: 2,
			maxZoom: 10
		});

		map.dragRotate.disable();
		map.touchZoomRotate.disableRotation();

		map.on('load', () => {
			mapLoaded = true;
			updateMapData();
		});
	}

	function updateMapData() {
		if (!map || !mapLoaded) return;

		// Remove existing layers/sources if they exist
		if (map.getLayer('metro-circles')) map.removeLayer('metro-circles');
		if (map.getSource('metros')) map.removeSource('metros');

		if (filteredMetroMetrics.length === 0) return;

		// Calculate max normalized value for sizing
		const maxNormalized = d3Max(filteredMetroMetrics, m => m.avg2) || 0.001;

		// Create GeoJSON from metro metrics
		const geojson = {
			type: 'FeatureCollection',
			features: filteredMetroMetrics
				.filter(m => {
					// Try to find coordinates for this metro
					const coords = findMetroCoords(m.metro);
					return coords !== null;
				})
				.map(m => {
					const coords = findMetroCoords(m.metro);
					return {
						type: 'Feature',
						geometry: {
							type: 'Point',
							coordinates: coords
						},
						properties: {
							metro: m.metro,
							avg1: m.avg1,
							avg2: m.avg2,
							percentChange: m.percentChange,
							total1: m.total1,
							total2: m.total2
						}
					};
				})
		};

		map.addSource('metros', {
			type: 'geojson',
			data: geojson
		});

		map.addLayer({
			id: 'metro-circles',
			type: 'circle',
			source: 'metros',
			paint: {
				'circle-radius': [
					'interpolate', ['linear'],
					['get', 'avg2'],
					0, 7,  
					maxNormalized * 0.25, 15, 
					maxNormalized * 0.5, 25,  
					maxNormalized * 0.75, 37,  
					maxNormalized, 55  
				],
				'circle-color': [
					'interpolate', ['linear'],
					['get', 'percentChange'],
					-70, '#7D0011',  // Dark red
					-35, '#b2182b',  // red
					-10, '#E57D40',  // Very light red
					0, '#f1c500',    // Yellow (neutral)
					10, '#90CC7E',   // Very light green
					35, '#3E9126',   // green
					70, '#166101'    // Dark green
				],
				'circle-opacity': 0.75,
				'circle-stroke-width': 0
			}
		});

		// Add popup on click, but only bind once
		if (!mapClickBound) {
			map.on('click', 'metro-circles', (e) => {
				// Close existing popup if any
				if (currentPopup) {
					currentPopup.remove();
				}

				const props = e.features[0].properties;
				const change = parseFloat(props.percentChange).toFixed(2);
				const changeColor = change >= 0 ? '#1b7837' : '#b2182b';
				
				currentPopup = new maplibregl.Popup()
					.setLngLat(e.lngLat)
					.setHTML(`
						<div style="color: #333; font-family: Roboto, sans-serif;">
							<strong>${props.metro}</strong><br>
							<span style="color: ${changeColor}; font-weight: bold;">${change >= 0 ? '+' : ''}${change}%</span> YoY change
						</div>
					`)
					.addTo(map);

				// Clear reference when popup is closed
				currentPopup.on('close', () => {
					currentPopup = null;
				});
			});

			map.on('mouseenter', 'metro-circles', () => {
				map.getCanvas().style.cursor = 'pointer';
			});
			map.on('mouseleave', 'metro-circles', () => {
				map.getCanvas().style.cursor = '';
			});
			mapClickBound = true;
		}
	}

	function findMetroCoords(metroName) {
		// Direct lookup
		if (usMetroCoords[metroName]) {
			return usMetroCoords[metroName];
		}
		
		// Try partial match (first part before comma)
		const shortName = metroName.split(',')[0].trim();
		for (const [key, coords] of Object.entries(usMetroCoords)) {
			if (key.startsWith(shortName + ',') || key.startsWith(shortName + '-')) {
				return coords;
			}
		}
		
		// Try finding by city name
		for (const [key, coords] of Object.entries(usMetroCoords)) {
			const keyCity = key.split(',')[0].split('-')[0].trim();
			if (keyCity === shortName) {
				return coords;
			}
		}
		
		return null;
	}

	// Update map when metrics change
	$: if (mapLoaded && filteredMetroMetrics) {
		updateMapData();
	}

	// Chart dimensions
	let chartWidth = 520;
	const chartHeight = 50;

	// Compute metrics for each metro
	$: metroMetrics = (() => {
		if (processedData.length === 0) return [];

		const period1Start = new Date(selection.period1Start);
		const period1End = new Date(selection.period1End);
		const period2Start = new Date(selection.period2Start);
		const period2End = new Date(selection.period2End);

		return metros.map(metro => {
			const metroData = processedData.filter(d => d.metro === metro);
			
			// Period 1: April 1, 2024 - March 31, 2025
			const period1Data = metroData.filter(d => d.date >= period1Start && d.date <= period1End);
			// Period 2: April 1, 2025 - March 31, 2026
			const period2Data = metroData.filter(d => d.date >= period2Start && d.date <= period2End);
			
			if (period1Data.length < 10 || period2Data.length < 10) return null;

			const avg1 = mean(period1Data, d => d.normalized);
			const avg2 = mean(period2Data, d => d.normalized);
			const total1 = sum(period1Data, d => d.normalized);
			const total2 = sum(period2Data, d => d.normalized);

			const percentChange = avg1 > 0 ? ((avg2 - avg1) / avg1) * 100 : 0;

			// For LOESS trend
			const sortedData = [...metroData].sort((a, b) => a.date - b.date);
			
			let regressionLine = null;
			let startCircle = null;
			let endCircle = null;
			let meanLine = null;

			if (sortedData.length >= 30) {
				try {
					const regressionGenerator = regressionLoess()
						.x(d => d.date.getTime())
						.y(d => d.normalized)
						.bandwidth(0.05);
					
					const regressionData = regressionGenerator(sortedData);
					
					if (regressionData.length > 0) {
						const allValues = regressionData.map(d => d[1]);
						const minVal = Math.min(...allValues);
						const maxVal = Math.max(...allValues);
						
						const minDateStr = period1Start.getTime();
						const maxDateStr = period2End.getTime();
						
						const xPadding = 5;
						const xScale = scaleLinear()
							.domain([minDateStr, maxDateStr])
							.range([xPadding, chartWidth - xPadding]);
						
						const yScale = scaleLinear()
							.domain([minVal, maxVal])
							.range([chartHeight - 5, 5]);

						const lineGenerator = line()
							.x(d => xScale(d[0]))
							.y(d => yScale(d[1]));

						regressionLine = lineGenerator(regressionData);
						
						startCircle = {
							cx: xScale(regressionData[0][0]),
							cy: yScale(regressionData[0][1])
						};
						endCircle = {
							cx: xScale(regressionData[regressionData.length - 1][0]),
							cy: yScale(regressionData[regressionData.length - 1][1])
						};
						meanLine = yScale(avg1);
					}
				} catch (e) {
					// Skip LOESS for this metro
				}
			}

			return {
				metro,
				region: getMetroRegion(metro),
				avg1,
				avg2,
				total1,
				total2,
				percentChange,
				period1Count: period1Data.length,
				period2Count: period2Data.length,
				regressionLine,
				startCircle,
				endCircle,
				meanLine,
				percentChangeDisplay: percentChange.toFixed(2) + "%"
			};
		}).filter(m => m !== null);
	})();

	// Filter by selected regions and search query
	$: filteredMetroMetrics = metroMetrics.filter(m => {
		if ($selectedRegions.length === 0) return false;
		
		const matchesRegion = m.region && $selectedRegions.includes(m.region);
		const matchesSearch = !searchQuery || m.metro.toLowerCase().includes(searchQuery.toLowerCase());
		
		return matchesRegion && matchesSearch;
	});

	// Sort for rankings view (worst to best)
	$: sortedByRankings = [...filteredMetroMetrics].sort((a, b) => a.percentChange - b.percentChange);

	// Sort for trends view (worst negatives first, then positives)
	$: sortedByTrends = [...filteredMetroMetrics].sort((a, b) => a.percentChange - b.percentChange);

	// The filters are already applied to filteredMetroMetrics
	$: filteredRankings = sortedByRankings;
	$: filteredTrends = sortedByTrends;

	// Statistics
	$: totalMetros = filteredMetroMetrics.length;
	$: metrosRising = filteredMetroMetrics.filter(m => m.percentChange > 0).length;
	$: metrosFalling = filteredMetroMetrics.filter(m => m.percentChange < 0).length;
	$: meanChange = filteredMetroMetrics.length > 0 ? mean(filteredMetroMetrics, m => m.percentChange) : 0;

	function getBarColor(percentChange, region) {
		// Use region colors instead of red/green
		return getRegionColor(region);
	}
</script>

<Header />

<main>
	<div class="text">
		<h1>Trips from Canada to the U.S.</h1>
		<p>
			By <a href="https://schoolofcities.utoronto.ca/people/karen-chapple/" target="_blank">Karen Chapple</a>,
			<a href="https://www.linkedin.com/in/yihoi-jung-0b95351b5/" target="_blank">Yihoi Jung</a>,
			<a href="https://schoolofcities.utoronto.ca/people/jeff-allen/" target="_blank">Jeff Allen</a>
		</p>
		<p><i>Updated {selection.update_date}</i></p>
		
		<p>
			With an increasing Canadian choice sentiment, the Canada Border Services Agency has been seeing a fall in Canada to U.S. visits.
            To investigate this phenomenon, cell phone activity (footfall) data across Canada and the U.S. provides more granular observations on these visits.
		</p>

        <p>
			This page analyzes Canadian travel to U.S. metro areas using geolocation data from March 2024 to March 2026. 
			The data shows normalized trips (ratio of trips to total Canadian devices) to understand year-over-year trends in border travel.
		</p>

		{#if !isLoading && metroMetrics.length > 0}
		<h5>Key findings:</h5>
		<p>
			‣ Out of <span class="bold">{totalMetros}</span> U.S. metro areas in the selected region(s), 
			<span class="bold">{metrosRising}</span> saw increased Canadian visits and 
			<span class="bold">{metrosFalling}</span> saw declines comparing Year 2 (03/2025-03/2026) to Year 1 (03/2024-03/2025).
			<br />
			‣ The mean change in normalized trips across all metros was 
			<span class="bold">{meanChange?.toFixed(1) ?? "..."}%</span>.
		</p>
		{/if}
	</div>

	{#if isLoading}
		<div class="loading-container">
			<div class="loading-spinner"></div>
			<p class="loading-text">Loading data...</p>
		</div>
	{:else}

	<div class="text" style="margin-bottom: 0px;">
		<!-- Region Selector (always visible) -->
		<div class="region-selector">
			<h5>Select Regions:</h5>
			<div class="region-controls">
				<button class="region-control-btn" on:click={() => $selectedRegions = ['Midwest', 'Northeast', 'Southwest', 'Southeast', 'Pacific']}>
					Select All
				</button>
				<button class="region-control-btn" on:click={() => $selectedRegions = []}>
					Clear All
				</button>
			</div>
			<SelectRegions europe="no" canada="no" />
		</div>

		<!-- View Toggle -->
		<div class="view-toggle">
			<div class="toggle-group">
				<span class="toggle-label">View:</span>
				<button
					class="toggle-btn"
					class:active={viewMode === "map"}
					on:click={() => (viewMode = "map")}
				>
					Map
				</button>
				<button
					class="toggle-btn"
					class:active={viewMode === "rankings"}
					on:click={() => (viewMode = "rankings")}
				>
					Rankings
				</button>
				<button
					class="toggle-btn"
					class:active={viewMode === "trends"}
					on:click={() => (viewMode = "trends")}
				>
					Trend Lines
				</button>
			</div>
		</div>
	</div>

	<!-- Search Box -->
	<div class="search-wrapper">
		<div class="search-container">
			<input
				type="text"
				class="search-input"
				placeholder="Search for a metro area..."
				bind:value={searchQuery}
			/>
			{#if searchQuery}
				<button class="clear-search" on:click={() => searchQuery = ""}>×</button>
			{/if}
		</div>
	</div>

	<!-- Map View -->
	{#if viewMode === "map"}
	<div class="map-section">
		<div class="text">
			<h4>Canada to U.S. Trip Map</h4>
			
			<!-- Color Legend -->
			 
			<div class="color-legend">
			<span>Year-over-Year Change</span>
				<div class="legend-bar">
					<div class="legend-gradient"></div>
				</div>
				<div class="legend-labels">
					<span>-70% (Large Decline)</span>
					<span>0% (Neutral)</span>
					<span>+70% (Large Increase)</span>
				</div>
			</div>
			
			<p class="map-legend-text">
				Circle size represents normalized trip volume. Click on a circle for details.
			</p>
		</div>
		<div class="map-container" bind:this={mapContainer}></div>
	</div>
	{/if}

	<!-- Rankings and Trends Views -->
	{#if viewMode !== "map"}
	<div class="text">
		<h4>
			{viewMode === "rankings" 
				? `Year-over-Year Change`
				: `Trips to the U.S.`}
		</h4>
	</div>
    
	<!-- Rankings View -->
	{#if viewMode === "rankings"}
		<div class="charts-scroll-container" on:wheel={(e) => e.stopPropagation()}>
			<div class="charts-inner">
				<!-- Header row -->
				<div class="chart-wrapper header-row">
					<div class="left">
						<span class="header-text">Metro Area</span>
					</div>
					<div class="arrow"></div>
					<div class="number">
						<span class="header-text">% Change</span>
					</div>
					<div class="bar-container">
						<div class="chart-header">
							<span class="header-text">04/2024-03/2025 vs 04/2025-03/2026</span>
						</div>
					</div>
				</div>

				{#each filteredRankings as metro, i}
					<div class="chart-wrapper">
						<div class="left">
							<svg width="250" height="{chartHeight}" class="region-bar">
								<line x1="5" y1="15" x2="5" y2="{chartHeight - 15}" stroke="#fff" stroke-width="5"/>
								<text x="12" y="31" class="textCity">{i + 1}. {metro.metro.split(',')[0]}</text>
							</svg>
						</div>

						<div class="arrow">
							{#if metro.percentChange >= 0}
								<img src={upArrow} alt="Up arrow" class="arrow-icon"/>
							{:else}
								<img src={downArrow} alt="Down arrow" class="arrow-icon"/>
							{/if}
						</div>

						<div class="number">
							<span class="percent-main" style="color: var(--brandWhite)">
								{metro.percentChangeDisplay}
							</span>
						</div>

						<div class="bar-container">
							<svg height={chartHeight} width="520" class="bar-chart">
								<!-- Center line at 0 -->
								<!-- Scale: -70% to +30%, total 100%, so 0% is at 70/100 * 520 = 364px -->
								<line x1="364" y1="10" x2="364" y2="40" stroke="#666" stroke-width="1"/>
								
								<!-- Bar -->
								{#if metro.percentChange >= 0}
									<rect 
										x="364" 
										y="15" 
										width={Math.min(metro.percentChange / 30 * 156, 156)}
										height="20" 
										fill={getBarColor(metro.percentChange, metro.region)}
										opacity="0.8"
									/>
								{:else}
									<rect 
										x={Math.max(364 - (Math.abs(metro.percentChange) / 70 * 364), 0)} 
										y="15" 
										width={Math.min(Math.abs(metro.percentChange) / 70 * 364, 364)}
										height="20" 
										fill={getBarColor(metro.percentChange, metro.region)}
										opacity="0.8"
									/>
								{/if}
							</svg>
						</div>
					</div>
				{/each}
			</div>
		</div>

	<!-- Trends View -->
	{:else}
		<div class="charts-scroll-container">
			<div class="charts-inner">
				<!-- Header row -->
				<div class="chart-wrapper header-row">
					<div class="left">
						<span class="header-text">Metro Area</span>
					</div>
					<div class="arrow"></div>
					<div class="number">
						<span class="header-text">% Change</span>
					</div>
					<div class="bar-container">
						<svg height="45" width={chartWidth} class="chart">
							<text x={chartWidth / 4} y="15" class="textYear">2024 / 2025</text>
							<text x={chartWidth * 3/4} y="15" class="textYear">2025 / 2026</text>
							
							<line x1={chartWidth / 2} y1="0" x2={chartWidth / 2} y2="45" stroke="#555555" stroke-width="2"/>
							
							{#each [0, 1] as yearIndex}
								{#each [4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3] as month, i}
									<text 
										x={yearIndex * (chartWidth / 2) + i * (chartWidth / 24) + (chartWidth / 48)} 
										y="35" 
										class="textLabelSmall" 
										style="text-anchor: middle;"
									>{month}</text>
									
									{#if !(yearIndex === 0 && i === 0)}
										<line 
											x1={yearIndex * (chartWidth / 2) + i * (chartWidth / 24)} 
											y1="40" 
											x2={yearIndex * (chartWidth / 2) + i * (chartWidth / 24)} 
											y2="45" 
											stroke="#555555" 
											stroke-width="1"
										/>
									{/if}
								{/each}
							{/each}
							
							<line x1="0" y1="45" x2={chartWidth} y2="45" stroke="#555555" stroke-width="1"/>
						</svg>
					</div>
				</div>

				{#each filteredTrends as metro, i}
					<div class="chart-wrapper" style="height: 53px;">
						<div class="left">
							<svg width="250" height="{chartHeight}" class="region-bar">
								<line x1="5" y1="15" x2="5" y2="{chartHeight - 15}" stroke="#fff" stroke-width="5"/>
								<text x="12" y="31" class="textCity">{i + 1}. {metro.metro.split(',')[0]}</text>
							</svg>
						</div>

						<div class="arrow">
							{#if metro.percentChange >= 0}
								<img src={upArrow} alt="Up arrow" class="arrow-icon"/>
							{:else}
								<img src={downArrow} alt="Down arrow" class="arrow-icon"/>
							{/if}
						</div>

						<div class="number">
							<span class="percent-main">
								{metro.percentChangeDisplay}
							</span>
						</div>

						<div class="bar-container">
							<svg height={chartHeight} width={chartWidth} class="chart">
								<!-- Grid lines -->
								{#each [0, 1] as yearIndex}
									{#each [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11] as tick}
										<line
											x1={yearIndex * (chartWidth / 2) + (tick * chartWidth / 2 / 12)}
											y1={5}
											x2={yearIndex * (chartWidth / 2) + (tick * chartWidth / 2 / 12)}
											y2={45}
											stroke="#333333"
											stroke-width="1"
										/>
									{/each}
									{#if yearIndex < 1}
										<line
											x1={(yearIndex + 1) * (chartWidth / 2)}
											y1={5}
											x2={(yearIndex + 1) * (chartWidth / 2)}
											y2={45}
											stroke="#555555"
											stroke-width="2"
										/>
									{/if}
								{/each}

								<!-- Baseline (Year 1 average) -->
								{#if metro.meanLine !== null}
									<line x1="0" y1={metro.meanLine} x2={chartWidth} y2={metro.meanLine} stroke="#D0D1C9" stroke-width="1" stroke-dasharray="4"/>
								{/if}

								<!-- LOESS regression line -->
								{#if metro.regressionLine}
									<path d={metro.regressionLine} stroke="white" stroke-width="2" fill="none"/>
									{#if metro.startCircle}
										<circle cx={metro.startCircle.cx} cy={metro.startCircle.cy} r="2" fill="white"/>
									{/if}
									{#if metro.endCircle}
										<circle cx={metro.endCircle.cx} cy={metro.endCircle.cy} r="2" fill="white"/>
									{/if}
								{/if}
							</svg>
						</div>
					</div>
				{/each}
			</div>
		</div>
	{/if}
	{/if}

	<div class="text">
		<br>
		<h4>More Information</h4>
		<p>
			The data comes from geolocation-based trip analysis tracking Canadian devices traveling to U.S. metro areas. 
			Values are normalized by the total number of unique Canadian devices each day to account for variations in data collection.
			The trend lines are fit via a <a href="https://en.wikipedia.org/wiki/Local_regression">LOESS</a> curve.
		</p>
		<p>
			You can download the normalized trip data <a href="/us_can_normalized_trips.csv">from this link</a>.
		</p>
		<br>
	</div>

	{/if}
</main>

<style>
	main {
		margin: 0 auto;
		margin-left: 15px;
		margin-right: 15px;
		width: calc(100% - 30px);
		min-width: 320px;
		max-width: 1920px;
		position: relative;
	}

	/* Map styles */
	.map-section {
		max-width: 900px;
		margin: 0 auto 30px auto;
	}

	.map-container {
		width: 100%;
		height: 500px;
		border: 1px solid var(--brandDarkBlue);
		border-radius: 4px;
	}

	.map-legend-text {
		font-size: 13px;
		color: var(--brandWhite);
		margin-bottom: 10px;
	}

	:global(.maplibregl-popup-content) {
		background: rgba(255,255,255,0.95);
		padding: 10px 15px;
		border-radius: 4px;
	}

	:global(.maplibregl-popup-close-button) {
		font-size: 16px;
		color: #333;
		padding: 4px 8px;
		right: 0;
		top: 0;
		position: absolute;
		cursor: pointer;
		background: transparent;
		border: 0;
	}

	:global(.maplibregl-popup-close-button:hover) {
		background-color: rgba(0, 0, 0, 0.05);
	}

	/* Region selector styles */
	.region-selector {
		margin: 20px 0;
		max-width: 900px;
	}

	.region-selector h5 {
		margin-bottom: 10px;
		color: var(--brandWhite);
	}

	.region-controls {
		display: flex;
		gap: 10px;
		margin-bottom: 10px;
	}

	.region-control-btn {
		padding: 6px 12px;
		background-color: var(--brandDarkBlue);
		color: var(--brandWhite);
		border: 1px solid var(--brandLightBlue);
		border-radius: 4px;
		cursor: pointer;
		font-family: Roboto, sans-serif;
		font-size: 13px;
		transition: background-color 0.2s;
	}

	.region-control-btn:hover {
		background-color: var(--brandLightBlue);
	}

	/* Color legend styles */
	.color-legend {
		margin: 15px auto;
		max-width: 900px;
	}

	.legend-bar {
		width: 100%;
		height: 20px;
		border: 1px solid var(--brandDarkBlue);
		border-radius: 3px;
		overflow: hidden;
        justify-content: center;
	}

	.legend-gradient {
		width: 100%;
		height: 100%;
		background: linear-gradient(
			to right,
			#9C2F2F 0%,
			#CC3A35 16.6%,
			#F08B5F 33.3%,
			#FFE066 50%,
			#A5D88C 66.6%,
			#5FBB58 83.3%,
			#2F8F3A 100%
		);
	}

	.legend-labels {
		display: flex;
		justify-content: space-between;
		margin-top: 5px;
		font-size: 12px;
		color: var(--brandWhite);
	}

	.charts-scroll-container {
		overflow-x: hidden;
		overflow-y: scroll;
		margin: 0 auto;
		max-width: 900px;
		max-height: 70vh;
		overscroll-behavior: contain;
		width: 100%;
	}

	.charts-inner {
		min-width: 880px;
	}

	.chart-wrapper {
		display: flex;
		margin: 0 auto;
		padding-left: 5px;
		padding-right: 5px;
		margin-bottom: 0px;
		max-width: 900px;
		height: 53px;
		background-color: var(--brandGray90);
		border-bottom: solid 1px var(--brandDarkBlue);
	}

	.chart-wrapper.header-row {
		position: sticky;
		top: 0;
		z-index: 10;
		background-color: var(--brandGray90);
		border-bottom: solid 2px var(--brandDarkBlue);
		height: auto;
		min-height: 53px;
	}

	.header-text {
		font-family: Roboto;
		font-size: 13px;
		font-weight: bold;
		color: var(--brandWhite);
	}

	.left {
		width: 250px;
		min-width: 250px;
		display: flex;
		align-items: center;
	}

	.textCity {
		font-family: Roboto;
		font-size: 13px;
		text-anchor: start;
		fill: var(--brandWhite);
	}

	.textLabel {
		font-family: Roboto;
		font-size: 15px;
		text-anchor: end;
		fill: var(--brandWhite);
	}

	.textLabelSmall {
		font-family: Roboto;
		font-size: 13px;
		text-anchor: end;
		fill: var(--brandWhite);
	}

	.textYear {
		font-family: Roboto;
		font-size: 14px;
		font-weight: bold;
		text-anchor: middle;
		fill: var(--brandWhite);
	}

	.arrow {
		margin: auto 0;
		width: 40px;
		height: 40px;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.arrow-icon {
		width: 30px;
		height: 30px;
	}

	.number {
		width: 70px;
		display: flex;
		align-items: center;
		justify-content: flex-end;
		padding-right: 10px;
	}

	.percent-main {
		font-family: Roboto;
		font-size: 14px;
		color: var(--brandWhite);
	}

	.bar-container {
		flex: 1;
		display: flex;
		align-items: center;
	}

	.bar-chart {
		margin-left: 10px;
	}

	.chart-container {
		width: 400px; /* Overridden by inline style anyway */
	}

	.chart {
		margin-left: 10px;
	}

	.chart-header {
		width: 520px;
		margin-left: 10px;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	/* Search styles */
	.search-wrapper {
		max-width: 900px;
		margin: 0 auto;
		padding-left: 10px;
		padding-right: 10px;
		box-sizing: border-box;
		width: 100%;
	}

	.search-container {
		position: relative;
		max-width: 400px;
		margin: 25px 0 5px 0;
	}

	.search-input {
		width: 100%;
		padding: 10px 35px 10px 15px;
		font-size: 14px;
		border: 1px solid var(--brandDarkBlue);
		border-radius: 4px;
		background: var(--brandGray90);
		color: var(--brandWhite);
	}

	.search-input::placeholder {
		color: #888;
	}

	.clear-search {
		position: absolute;
		right: 10px;
		top: 50%;
		transform: translateY(-50%);
		background: none;
		border: none;
		color: var(--brandWhite);
		font-size: 20px;
		cursor: pointer;
		padding: 0 5px;
	}

	/* Toggle styles */
	.view-toggle {
		display: flex;
		flex-wrap: wrap;
		gap: 20px;
		padding: 15px 0;
	}

	.toggle-group {
		display: flex;
		align-items: center;
		gap: 8px;
	}

	.toggle-label {
		font-family: Roboto;
		font-size: 14px;
		color: var(--brandWhite);
	}

	.toggle-btn {
		font-family: Roboto;
		font-size: 13px;
		padding: 6px 12px;
		border: 1px solid var(--brandWhite);
		background: transparent;
		color: var(--brandWhite);
		cursor: pointer;
		border-radius: 4px;
		transition: all 0.2s ease;
	}

	.toggle-btn:hover {
		background: rgba(255, 255, 255, 0.1);
	}

	.toggle-btn.active {
		background: var(--brandWhite);
		color: var(--brandDarkBlue);
	}

	/* Loading spinner */
	.loading-container {
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		padding: 60px 20px;
		min-height: 200px;
	}

	.loading-spinner {
		width: 50px;
		height: 50px;
		border: 4px solid var(--brandGray90);
		border-top: 4px solid var(--brandLightBlue);
		border-radius: 50%;
		animation: spin 1s linear infinite;
	}

	@keyframes spin {
		0% { transform: rotate(0deg); }
		100% { transform: rotate(360deg); }
	}

	.loading-text {
		margin-top: 15px;
		font-family: Roboto;
		font-size: 14px;
		color: var(--brandWhite);
	}

	h5 {
		font-size: 16px;
		font-family: Roboto;
		color: var(--brandWhite);
		margin-bottom: 5px;
	}

	.bold {
		font-weight: bold;
	}

	.text {
		max-width: 900px;
		margin: 0 auto;
	}
</style>