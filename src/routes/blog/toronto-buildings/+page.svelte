<script>

    import Header from "../../../lib/Header.svelte";
    import "../../../assets/global.css";

    import MapTorontoRecovery from "./lib/MapTorontoRecovery.svelte";
    import DotDistribution from "./lib/DotDistribution.svelte";
    import ClusterResult from "./lib/ClusterResult.svelte";

    import mapRecovery from "./data/map-cluster.png";

</script>


<Header/>

<main>

    <div class="text">

        <h3>Understanding post-pandemic recovery for individual buildings </h3>

        <p>By <a href="https://schoolofcities.utoronto.ca/people/byeonghwa-jeong/">Byeonghwa Jeong</a>, <a href="https://schoolofcities.utoronto.ca/people/karen-chapple/">Karen Chapple</a> & <a href="http://jamaps.github.io/">Jeff Allen</a> | December 15, 2023</p> 

        <p>
            On this website, we've tracked post-pandemic recovery patterns in the downtowns of many North American cities, based on location-based mobility data from cell phones supplied by Spectus. While we've <a href="/charts/rankings">compared recovery across different cities</a>, as well as created a tool to <a href="/blog/downtown-definitions">explore how results vary for different definitions of downtown</a>, policymakers often need more fine-grained data to determine how recovery is progressing at the city block or individual building level.
        </p>
        <p>
            On this page, we examine recovery rates (comparing activity in Spring 2023 to Spring 2019) for 119 buildings located in the Toronto Financial District Business Improvement Area (BIA). Most buildngs in this BIA are either office (45%), mixed-use office plus retail (33%), or retail only (11%) buildings. The map below reveals substantial variation in recovery across the area. The darker the red, the lower activity in 2023 compared to 2019, and the darker the blue, the higher the rate of recovery.
        </p>
        

        <MapTorontoRecovery/>

        <p>
            Specifically, to estimate the recovery rate of each building, we counted the total unique daily visitors from March to May 2023, dividing it by the total unique daily visitors in corresponding months in 2019. Before dividing, both totals were normalized by the total number of unique devices in the City of Toronto, to account for changing sampling rates over time. For more details on how we are measuring recovery from Spectus data, view our  <a href="/methodology">methodology</a> page.
        </p>

        <p>  
            The building that recorded the highest rate of change was CIBC Square Phase I with 3026% followed by Wildeboer Dellelce Place and the building at 9 Temperance St (369% and 344% respectively). In the case of CIBC Square, it was under construction in 2019 and opened in 2021. It also has a regional bus terminal on its ground floor. The building that recorded the lowest recovery rate was the HSBC Building at 70 York St (7%) and the Lumsden Building at 6 Adelaide St E (7%). These buildings likely had tenants that moved out during the pandemic and have not had their spaces refilled by Spring 2023.
        </p>

        <h2>Recovery Rates By Building Type</h2>

        <p>
            Below we create dot distribution charts of building recovery rates by the four most prominent building types. Each dot represents a single building, placed on the X-axis pertaining to its recovery rate. The data on building type was provided by the Financial District BIA.
        </p>
        <p>
            The vast majority of office and retail buildings have not recovered to their pre-pandemic level of activity, likely due to hybrid work arrangements. While there are only 8 hospitality buildings in the district, 6 of them have a recovery rate of more than 100%, indicating a strong return and increase in activity in hotels and related establishments.
        </p>

        
    </div>

    <DotDistribution/>

    <div class="text">

        <h2>Cluster Analysis</h2>

        <p>
            Based on the recovery rate results, we conducted a clustering analysis to identify building typologies related to their recovery rates and other attributes such as building type (e.g. retail, office, etc.), building class (A, B, or C, which is a ranking of building quality, often reflective in rental rates) and usable space of the building (i.e. the total floor area to account for different building sizes). Specifically, we ran a cluster analysis that's a <a href="http://cran.fhcrc.org/web/packages/kmed/vignettes/kmedoid.html#gower">combination of Gower's distance and k-medoids method</a> on all office, retail, and mixed use office/retail buildings in the district. The categorical variables were converted to dummy variables (0 or 1) and the numeric variables on usable space and recovery rate were log scaled and normalized to a range from 0 to 1 prior to clustering. The number of clusters was based on analyzing the within-cluster sum of squares.
        </p>
        <p>
            Based on our analysis, we find that there are 4 clusters (i.e. types) of buildings. Generally, Class A buildings and large-size office and retail mix-used buildings tend to have lower recovery rates, whereas smaller-sized Class B and C office and retail buildings show higher recovery rates.
        </p>

    </div>

    <ClusterResult/>

    <div class="text">

        <p>Below is a map of the cluster results. A large number of buildings were identified in the third cluster, predominantly Class A mixed-use buildings with lower recovery rates, which we see are located in the centre of the BIA. These buildings make up most of the tall skyscrapers in the district. Buildings in the other clusters are scattered more around the periphery of the BIA.</p>

        <p>It is our hope that based on this typology, policy-makers and related stakeholders can see how different types of buildings are recovering more than others, and can design effective recovery strategies based on building-level attributes.</p>

        <div class="mapImg">

            <img src={mapRecovery} alt="Map ...">
        
        </div>

        <p>
            While our analysis was focused on Toronto's downtown, the same type of analysis could be applied to other areas as well that have building level data or other sub-geographies (e.g. sets of city blocks, BIAs, neighbourhoods) with distinct characteristics. If you're interested in seeing something similar for your city or neighbourhood, please reach out to us!
        </p>

        <br><br><br>

        <!-- <h2>Data & Methods</h2>

        <p>
            For details on the downtown recovery metrics, check out our <a href="../methodology">methodology</a>. The charts on this page were made by <a href="https://jamaps.github.io">Jeff Allen</a> using D3 and Svelte.
        </p> -->

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

    h3 {
        font-size: 25px;
    }

    h4 {
        text-decoration: underline;
    }

    p {
        line-height: 25px;
    }

</style>
