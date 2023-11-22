<script>

    import Header from "../../../lib/Header.svelte";
    import "../../../assets/global.css";
    import MapPlot from "./lib/MapPlot.svelte";

</script>

<Header/>

<main>
    <div class="text">
        <h3>How does the definition of downtown affect its recovery rate?</h3>
        <p>
            By <a href='https://www.urbandisplacement.org/team/julia-greenberg/' target='_blank'>Julia Greenberg</a>, <a href='https://schoolofcities.utoronto.ca/people/byeonghwa-jeong/' target='_blank'>Byeonghwa Jeong</a>, <a href='https://schoolofcities.utoronto.ca/people/jeff-allen/' target='_blank'>Jeff Allen</a>, <a href='https://www.geography.utoronto.ca/people/directories/all-faculty/karen-chapple' target='_blank'>Karen Chapple</a>, and Sarah Smith | [DATE]
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
