<script>

    import Header from "../../../lib/Header.svelte";
    import "../../../assets/global.css";

    import MapTorontoRecovery from "./lib/MapTorontoRecovery.svelte";

    import DotDistribution from "./lib/DotDistribution.svelte";

</script>


<Header/>

<main>

    <div class="text">

        <h3>Understanding post-pandemic recovery for individual buildings </h3>

        <p>By <a href="">B</a>,  <a href="">Jeff Allen</a>, & <a href="">Karen Chapple</a> | December 15, 2023</p> 


        <p>
            On this site, we've tracked recovery patterns in the downtowns of many North American cities, based on location-based mobility data from cell phones supplied by Spectus. Though the website allows users to explore different definitions of downtown, policymakers need more fine-grained data to determine how recovery is progressing at the block or even building level.
        </p>
        <p>
            Here we examine recovery rates (comparing activity in spring 2023 to spring 2019) for 119 buildings located in the Toronto Financial District Business Improvement Area; most are either office (45%), office plus retail (33%), and retail (11%) buildings. The map below reveals substantial variation in recovery across the area: the darker the red, the lower activity in 2023 compared to 2019, and the darker the blue, the higher the rate of recovery.
        </p>
        

        <MapTorontoRecovery/>

        <p>
            Specifically, to estimate the recovery rate of each building, we used the footfall volume data from March to May 2023, the corresponding months in 2019. A recovery rate lower than 100% indicates that the number of visitors from March to May 2023 had not yet recovered to the same month's visitor count in 2019. 
        </p>

        <p>  
            The building that recorded the highest rate of change was CIBC Square (Phase I with 3026%) followed by Wildeboer Dellelce Place and the building at 9 Temperance St (369% and 344% respectively). In the case of CIBC Square, it was under construction during the before-pandemic period and opened in 2021, which led to a unique increase in recovery rates. It also has a regional bus terminal on it's ground floor. The building that recorded the lowest recovery rate was the HSBC Building at 70 York St (7%) followed by the Lumsden Building at 6 Adelaide St E (7%). These buildings (WHAT CAN WE SAY ABOUT THEM?)
        </p>

        <h2>Recovery Rates By Building Type</h2>

        <p>
            Below we create dot distribution charts of building recovery rates by the four most prominent building types. Each dot represents a single building, place on the X-axis pertaining to it's recovery rate.
        </p>
        <p>
            The vast majority of office and retail buildings have not recovered to their pre-pandemic level of activity, likely due to hybrid work arrangements. While there are only 8 hospitality buildings in the district, 6 of them have a recovery rate of more than 100%, indicating a strong return and increase in activity in hotels and related establishments.
        </p>

        <DotDistribution/>

        <h2>Cluster Analysis</h2>

        <p>
            Based on the recovery rate results, we conducted a clustering analysis to identify building typologies related to their recovery rates and other attributes such as building type (e.g. retail, office, etc.), class (A, B, or C, which is a qualitative ranking of building quality) and usable space of the building (i.e. the total floor area to account for different building sizes). Specifically, we ran a <a href="https://en.wikipedia.org/wiki/K-means_clustering">k-means cluster analysis</a> on all office, retail, and mixed use office/retail buildings in the district.
        </p>
        <p>
            It is our hope that based on this typology, policy-makers and related stakeholders can visualize how different types of buildings are recovering more than others, and can design effective recovery strategies for downtown’s diverse sub-areas. 
        </p>
        <p>
             
        </p>

        

    </div>

       

    <div class="text">

        <h2>Data & Methods</h2>

        <p>
            For details on the downtown recovery metrics, check out our <a href="../methodology">methodology</a>. The charts on this page were made by <a href="https://jamaps.github.io">Jeff Allen</a> using D3 and Svelte.
        </p>

    </div>


</main>


<style>

    .grid {
        margin: 0 auto;
        display: flex;
        flex-wrap: wrap;
        justify-content: center; /* Center the cells horizontally */
        max-width: 1100px;
    }

    .grid-cell {
        width: 50%;
        box-sizing: border-box;
    }

    @media (max-width: 1000px) {
        .grid-cell {
            width: 100%;
        }
    }

    #options {
        margin: 0 auto;
        padding-top: 8px;
        padding-bottom: 8px;
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
