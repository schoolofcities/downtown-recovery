<script>

    import Header from "../../../lib/Header.svelte";
    import "../../../assets/global.css";
    import MapPlot from "./lib/MapPlot.svelte";

</script>


<Header/>

<main>
    <div class="text">
        <h3>Comparison of recovery rate for different definitions of "downtown"</h3>
        <p>
            Downtowns' recovery rates look different depending on how the "downtown" is defined. 
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
