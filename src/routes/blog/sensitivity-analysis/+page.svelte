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
        <p>I think we need a couple high-level sentences here that describe the purpose of this page</p>
        <MapPlot/>
    </div>
</main>

<style>

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
