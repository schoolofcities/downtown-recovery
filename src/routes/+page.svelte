<script>

    import Header from "../lib/Header.svelte";
    import "../assets/global.css";

    import cardImgRankings from "../assets/card-img/card-img-rankings.png";
    import cardImgPatterns from "../assets/card-img/card-img-patterns.png";
    import cardImgCorrelations from "../assets/card-img/card-img-correlations.png";
    import cardImgReport from "../assets/card-img/card-img-report.png";
    import cardImgVideo from "../assets/card-img/card-img-video.png";

    const baseUrl = '/downtown-recovery';

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
            Updated on July 7, 2023
        </p>

    </div>

    <div id="cards-wrapper">

        <a href="/charts/rankings">
            <div class="card">

                <div class="card-img"> 
                    <img src={cardImgRankings}>
                </div>

                <h2>Recovery Rankings</h2>

                <p>Comparison of overall recovery in activity levels across different cities and time periods.</p>

            </div>
        </a>

        <a href="/charts/patterns">
            <div class="card">

                <div class="card-img"> 
                    <img src={cardImgPatterns}>
                </div>

                <h2>Recovery Patterns</h2>

                <p>Explore weekly activity levels during different phases of the pandemic for different cities.</p>

            </div>
        </a>

        <a href="/charts/correlations">
            <div class="card">

                <div class="card-img"> 
                    <img src={cardImgCorrelations}>
                </div>

                <h2>Correlations</h2>

                <p>Visualize how downtown recovery is (or is not) related to a range of other urban data</p>

            </div>
        </a>

        <a href="/death_of_downtown_policy_brief.pdf">
            <div class="card">

                <div class="card-img"> 
                    <img src={cardImgReport}>
                </div>

                <h2>Policy Brief</h2>

                <p>Our report (updated January 2023) on recovery patterns and their explanatory factors.</p>

            </div>
        </a>
        
        <a href="https://www.youtube.com/watch?v=K2E1uvWqSH8&feature=youtu.be" target="_blank">
            <div class="card">

                <div class="card-img"> 
                    <img src={cardImgVideo}>
                </div>

                <h2>Explainer Video</h2>

                <p>Our short video on downtown recovery and how to prevent the death of downtown.</p>

            </div>
        </a>

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

    .card:hover h2,
    .card:hover p {
        color: var(--brandLightBlue);
    }    

    .card-img {
        background-color: white;
        width: 350px;
        height: 150px;
        border: 1px solid var(--brandDarkBlue);
    }

    a {
        text-decoration: none;
    }

    @media (min-width: 800px) {
        #cards-wrapper { 
            grid-template-columns: repeat(2, 1fr); 
            max-width: 800px;
        }
        
    }

    @media (min-width: 1200px) {
        #cards-wrapper { grid-template-columns: repeat(2, 1fr); }
    }

</style>
