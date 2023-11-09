<script>

    import Header from "../../../lib/Header.svelte";
    import "../../../assets/global.css";
    // import ScatterPlot from "./lib/ScatterPlot.svelte";
    // import SelectRegions from "../../../lib/SelectRegions.svelte";
    import MapPlot from "./lib/MapPlot2.svelte";
    // import Map from "./lib/Map.svelte";

</script>


<Header/>

<main>

    <div class="text">

        <h3>Comparison of recovery rate for different definitions of "downtown"</h3>

        <p>
            [explanation here] 
        </p>

        <MapPlot/>

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
