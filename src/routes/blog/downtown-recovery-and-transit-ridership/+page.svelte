<script>

    import Header from "../../../lib/Header.svelte";
    import "../../../assets/global.css";
    import ScatterPlot from "./lib/ScatterPlot.svelte";
    import SelectRegions from "../../../lib/SelectRegions.svelte";

</script>


<Header/>

<main>

    <div class="text">

        <h3>Downtown Recovery ~ Transit Ridership Recovery</h3>

        <p>
            In the aftermath of the COVID-19 pandemic, the revival of downtown areas and public transit systems has been a hot topic. As cities all over North America faced pandemic challenges, we decided to explore the connection between downtown recovery and public transit resurgence. Our journey took us across different types of public transport, including Commuter Rail, Heavy Rail, Light Rail, and Buses in cities across North America. 
        </p>

        <ScatterPlot transitVariable = "Total"/>

        <div id="options">
            <!-- <div id="options-season">
                <SelectSeason/>
            </div> -->
            <div id="options-region">
                <SelectRegions europe={"no"}/>
            </div>
            
        </div>

        <div class="text"></div>

    </div>

    <div class="text">

        <p>
            In the aftermath of the COVID-19 pandemic, the revival of downtown areas and public transit systems has been a hot topic. As cities all over North America faced pandemic challenges, we decided to explore the connection between downtown recovery and public transit resurgence. Our journey took us across different types of public transport, including Commuter Rail, Heavy Rail, Light Rail, and Buses in cities across North America. 
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
            In the aftermath of the COVID-19 pandemic, the revival of downtown areas and public transit systems has been a hot topic. As cities all over North America faced pandemic challenges, we decided to explore the connection between downtown recovery and public transit resurgence. Our journey took us across different types of public transport, including Commuter Rail, Heavy Rail, Light Rail, and Buses in cities across North America. 
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
