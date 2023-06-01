<script>

    import Header from "../../../lib/header.svelte";
    import "../../../assets/global.css";

    const regions = ["Southeast", "Southwest", "Pacific", "Northeast", "Midwest", "Canada", "Europe"]

    const seasons = [
        {
            "name": "Spring: Mar 2020 - May 2020",
            "number": 1
        },
        {
            "name": "Summer: June 2020 - Aug 2020",
            "number": 2
        },
        {
            "name": "Fall: Sept 2020 - Nov 2020",
            "number": 3
        },
        {
            "name": "Winter: Dec 2020 - Feb 2021",
            "number": 4
        },
        {
            "name": "Spring: Mar 2021 - May 2021",
            "number": 5
        },
        {
            "name": "Summer: June 2021 - Aug 2021",
            "number": 6
        },
        {
            "name": "Fall: Sept 2021 - Nov 2021",
            "number": 7
        },
        {
            "name": "Winter: Dec 2021 - Feb 2022",
            "number": 8
        },
        {
            "name": "Spring: Mar 2022 - May 2022",
            "number": 9
        },
        {
            "name": "Summer: June 2022 - Aug 2022",
            "number": 10
        },
        {
            "name": "Fall: Sept 2022 - Nov 2022",
            "number": 11
        },
        {
            "name": "Winter: Dec 2022 - Feb 2023",
            "number": 12
        }
    ]

    let selectedRegions = ["Southeast", "Southwest", "Pacific", "Northeast", "Midwest", "Canada"]

    let selectedSeason = 12

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
            - select metric (city vs downtown) - maybe add later?
        </p>

    </div>

    <div id="ranking-chart">

        meow

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
        max-width: 666px;
        color: white;
    }

    #ranking-chart {
        max-width: 1920px;
    }

</style>