<script>

    import Header from "../../../lib/Header.svelte";
    import "../../../assets/global.css";
    import ScatterPlot from "./lib/ScatterPlot.svelte";

</script>


<Header/>

<main>

    <div class="text">

        <h1><span class="bold">Downtown Recovery & Transit Ridership Recovery</span></h1>

        <p>
            In the aftermath of the COVID-19 pandemic, the revival of downtown areas and public transit systems has been a hot topic. As cities all over North America faced pandemic challenges, we decided to explore the connection between downtown recovery and public transit resurgence. Our journey took us across different types of public transport, including Commuter Rail, Heavy Rail, Light Rail, and Buses in cities across North America. 
        </p>

        <ScatterPlot transitVariable = "LR"/>

    </div>

    

    <div class="text"></div>

    <div class="text"></div>


</main>
