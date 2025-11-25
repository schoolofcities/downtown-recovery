<script>

    import Header from "../../../lib/Header.svelte";
    import "../../../assets/global.css";

    import RecoveryMaps from "./lib/RecoveryMaps.svelte";

    import mapToronto from "./data/Q_tor.png";
    import mapVancouver from "./data/Q_van.png";
    import mapNewYorkSouth from "./data/Q_nyc_south.png";
    import mapNewYorkNorth from "./data/Q_nyc_north.png";
    import mapSanFrancisco from "./data/Q_sf.png";

    import doomLoopGraphic from "./data/doom-loop-schematic.png";

</script>


<Header/>

<main>

    <div class="text">

        <h3>Doom Loop</h3>

        <p>By Author Name, Author Name, etc. | November, 2025</p> 

        <!-- <a href="https://schoolofcities.utoronto.ca/people/byeonghwa-jeong/">Byeonghwa Jeong</a>, <a href="https://schoolofcities.utoronto.ca/people/karen-chapple/">Karen Chapple</a> -->

        <p>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        </p>

        <div style="max-width:600px; width:100%; margin:0 auto;">
            <img
                src="{doomLoopGraphic}"
                alt="Descriptive alt text"
                loading="lazy"
                style="
                display:block;         
                width:100%;          
                max-width:100%;    
                object-fit:contain; 
                image-rendering: -webkit-optimize-contrast; 
                "
            />
        </div>

        <p>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        </p>

        <RecoveryMaps
            title="Downtown San Francisco"
            mapImage={mapSanFrancisco}
        />

        <p>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        </p>

        <RecoveryMaps
            title="New York Midtown"
            mapImage={mapNewYorkNorth}
        />

        <p>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        </p>

        <RecoveryMaps
            title="New York Financial District"
            mapImage={mapNewYorkSouth}
        />

        <p>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        </p>

        <RecoveryMaps
            title="Downtown Toronto"
            mapImage={mapToronto}
        />

        <p>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        </p>
        
        <RecoveryMaps
            title="Downtown Vancouver"
            mapImage={mapVancouver}
        />

        <p>
            Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        </p>
        
    </div>


</main>


<style>

    .mapImg {
        max-width: 600px;
        margin: 0 auto; /* Center the container */
    }
    img {
		border: solid 1px var(--brandDarkBlue);
		min-width: 350px;
		max-width: 100%; /* Set maximum width to 100% of the container */
		height: auto; /* Maintain aspect ratio */
		display: block; /* Remove default image spacing */
		margin: 0 auto; /* Center the image within the container */
	}

    .text {
        border: 0px;
    }


    h4 {
        text-decoration: underline;
    }

    p {
        line-height: 25px;
    }

</style>
