<script>

    import Header from "../../../lib/Header.svelte";
    import "../../../assets/global.css";
    import ScatterPlot from "./lib/ScatterPlot.svelte";
    import SelectRegions from "../../../lib/SelectRegions.svelte";

</script>


<Header/>

<main>

    <div class="text">

        <h3>Downtown Recovery & Transit Ridership Recovery</h3>

        <p>
            In the aftermath of the COVID-19 pandemic, the revival of downtown areas and public transit systems has been a hot topic. As cities all over North America faced pandemic challenges, we decided to explore the connection between downtown recovery and public transit resurgence. Our journey took us across different types of public transport, including Commuter Rail, Heavy Rail, Light Rail, and Buses in cities across North America. 
        </p>

        <ScatterPlot transitVariable = "Total"/>

        <p>
            The colours of the dots pertain to the region of the city. Feel free to toggle each region on or off by clicking on each below. You can also hover over each point to view the name of the city and its statistics.
        </p>

        <div id="options">
            <div id="options-region">
                <SelectRegions europe={"no"}/>
            </div>
        </div>

        <p>
            We've also created charts for different modes of transit; busses, light rail, heavy rail (i.e. metro and subway), and commuter rail. Check them out below
        </p>

    </div>

    <div class="grid">

        <div class="grid-cell">
            <ScatterPlot transitVariable = "MB"/>
        </div>
        <div class="grid-cell">
            <ScatterPlot transitVariable = "LR"/>
        </div>
        <div class="grid-cell">
            <ScatterPlot transitVariable = "HR"/>
        </div>
        <div class="grid-cell">
            <ScatterPlot transitVariable = "CR"/>
        </div>

    </div>

    <div class="text">

        <p>
            Note that the data on these charts for downtown recovery are slightly different than elsewhere on this site. This is because they were calculated for Jan 2023 to June 2023 to align with the ridership data that we had access to. 
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

    p {
        line-height: 25px;
    }

</style>
