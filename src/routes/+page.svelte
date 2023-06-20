<script>

    import Header from "../lib/Header.svelte";
    import "../assets/global.css";

    import cardImgRankings from "../assets/card-img/card-img-rankings.png";
    import cardImgPatterns from "../assets/card-img/card-img-patterns.png";

</script>


<Header/>

<main>

    <div class="text">

        <h1>
            Death of Downtown?
        </h1>
        <p>
            <span class="bold">Exploring Pandemic Recovery Trajectories Across 63 North American Cities</span>
        </p>
        <p>
            Updated on April 25, 2023
        </p>

    </div>

    <div id="cards-wrapper">

        <div class="card">

            <div class="card-img"> 
                <img src={cardImgRankings}>
            </div>

            <h2>Recovery Rankings</h2>

            <p>Comparison of overall recovery in activity levels across different cities and time periods.</p>

        </div>

        <div class="card">

            <div class="card-img"> 
                <img src={cardImgPatterns}>
            </div>

            <h2>Recovery Patterns</h2>

            <p>Explore weekly activity levels during different phases of the pandemic for different cities.</p>

        </div>

        <div class="card">

            <div class="card-img"></div>

            <h2>Policy Brief</h2>

            <p>Our report (updated January 2023) on recovery patterns and their explanatory factors.</p>

        </div>

        <div class="card">

            <div class="card-img"></div>

            <h2>Explainer Video</h2>

            <p>Our short video on downtown recovery and how to prevent the death of downtown.</p>

        </div>

        <div class="card">

            <div class="card-img"></div>

            <h2>Methodology</h2>

            <p>Details on how we measured downtown activity and recovery using mobile phone data.</p>

        </div>

    </div>

</main>




<style>
    
    #cards-wrapper {
        max-width: 1200px;
        display: grid;
        margin: 0 auto;
        align-items: center;
        justify-content: center;
    }

    .card {
        margin: 10px;
        padding: 10px;
        width: 350px;
        max-width: 350px;
    }

    .card:hover {
        cursor: pointer;
    }

    .card-img {
        background-color: white;
        width: 350px;
        height: 150px;
        border: 1px solid var(--brandDarkBlue);
    }

    @media (min-width: 800px) {
        #cards-wrapper { 
            grid-template-columns: repeat(2, 1fr); 
            max-width: 800px;
        }
        
    }

    @media (min-width: 1200px) {
        #cards-wrapper { grid-template-columns: repeat(3, 1fr); }
    }

</style>
