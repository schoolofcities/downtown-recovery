<script>

    import Header from "../../../lib/Header.svelte";
    import SelectSeason from "../../../lib/SelectSeason.svelte";
    import SelectRegions from "../../../lib/SelectRegions.svelte";

    import { season, regions, selectedRegions } from '../../../lib/stores.js';

    import "../../../assets/global.css";

</script>




<Header/>

<main>

    <div id="title">

        <h1>
            Downtown Recovery Rankings
        </h1>
        <p>
            Some very simple intro to the data/charts
        </p>
        <p>
            A recovery value greater than 100% means that for the selected inputs, the mobile device activity improved from the comparison period. A value less than 100% means the opposite, and a value equal to 100% means the activity did not change.
        </p>

        <p>
            Options
            - select Season
            - select Region (by colour - Europe as white)
        </p>

    </div>

    <div id="ranking-chart">
        
        <div id="options">
            <div id="options-season">
                <SelectSeason/>
            </div>
            <div id="options-region">
                <SelectRegions/>
            </div>
        </div>



    </div>

</main>





<style>

    main {
        margin: 0 auto;
        width: 100%;
        min-width: 320px;
        max-width: 1920px;
        position: relative;
    }

    #title {
        margin: 0 auto;
        max-width: 650px;
        color: white;
        border-bottom: solid 1px var(--brandDarkBlue);
    }

    #ranking-chart {
        margin: 0 auto;
        max-width: 1920px;
    }

    #options {
        margin: 0 auto;
        max-width: 650px;
    }

    #options-season {
        float: left;
        padding-right: 15px;
    }
    #options-region {
        overflow: hidden;
    }

</style>
