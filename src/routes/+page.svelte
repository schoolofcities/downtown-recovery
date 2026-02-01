<script>
    import Header from "../lib/Header.svelte";
    import "../assets/global.css";

    import cardDoomLoop from "../assets/card-img/card-img-doom-loop.png";
    import cardFlightToQuality from "../assets/card-img/card-flight-to-quality.png";
    import cardTransitResilience from "../assets/card-img/card-img-transit-resilience.png";
    import cardImgTrends from "../assets/card-img/card-img-trends.png";
    import cardImgUSTrends from "../assets/card-img/card-img-us-trends.png";
    import cardImgCanadaTrends from "../assets/card-img/card-img-canada-trends.png";
    import cardImgRankings from "../assets/card-img/card-img-rankings.png";
    import cardImgPatterns from "../assets/card-img/card-img-patterns.png";
    import cardImgCorrelations from "../assets/card-img/card-img-correlations.png";
    import cardImgWeekly from "../assets/card-img/card-img-weekly.png";
    import cardImgTorontoBuildings from "../assets/card-img/card-img-toronto-buildings.png";
    import cardImgTransitRidership from "../assets/card-img/card-img-transit-ridership.png";
    import cardImgDowntownDefinition from "../assets/card-img/card-img-downtown-definition.png";
    import cardImgReport from "../assets/card-img/card-img-report.png";
    import cardImgVideo from "../assets/card-img/card-img-video.png";

    const baseUrl = "/downtown-recovery";
</script>

<Header />

<main>
    <div class="text">
        <h1>Death of Downtown?</h1>
        <h2>
            <span class="bold"
                >Exploring Pandemic Recovery Across North American Downtowns</span
            >
        </h2>
    </div>

    <div id="cards-wrapper">
        <a href="/blog/doom-loop">
            <div class="card">
                <div class="card-img">
                    <img src={cardDoomLoop} />
                </div>

                <h2>Want to Prevent a Doom Loop?</h2>

                <p>
                    Maps and comparative local economic analysis of U.S. and
                    Canadian cities.
                </p>
            </div>
        </a>

        <a href="/blog/flight-to-quality">
            <div class="card">
                <div class="card-img">
                    <img src={cardFlightToQuality} />
                </div>

                <h2>Flight to Quality?</h2>

                <p>
                    Did activity in high-end office and commercial buildings
                    withstand the pandemic?
                </p>
            </div>
        </a>

        <a href="/blog/transit-resilience">
            <div class="card">
                <div class="card-img">
                    <img src={cardTransitResilience} />
                </div>

                <h2>Transit Resilience</h2>

                <p>
                    Transit-oriented communities and post-pandemic urban
                    resilience in Toronto
                </p>
            </div>
        </a>

        <a href="/charts/us_trends">
            <div class="card">
                <div class="card-img">
                    <img src={cardImgUSTrends} />
                </div>

                <h2>U.S. Recovery Trends</h2>

                <p>
                    Charting downtown recovery across the U.S. from September to
                    December 2023 to 2025.
                </p>
            </div>
        </a>

        <a href="/charts/canada_trends">
            <div class="card">
                <div class="card-img">
                    <img src={cardImgCanadaTrends} />
                </div>

                <h2>Canada Recovery Trends</h2>

                <p>
                    Charting downtown recovery across Canada from February, 2024
                    through February, 2025
                </p>
            </div>
        </a>

        <a href="/charts/trends">
            <div class="card">
                <div class="card-img">
                    <img src={cardImgTrends} />
                </div>

                <h2>Recovery Trends</h2>

                <p>
                    Charting downtown recovery across North America from May,
                    2023 through May, 2024
                </p>
            </div>
        </a>

        <a href="/charts/rankings">
            <div class="card">
                <div class="card-img">
                    <img src={cardImgRankings} />
                </div>

                <h2>Recovery Rankings</h2>

                <p>
                    Comparison of overall recovery in activity levels across
                    several cities. Comparing 2019 to 2023.
                </p>
            </div>
        </a>

        <a href="/charts/patterns">
            <div class="card">
                <div class="card-img">
                    <img src={cardImgPatterns} />
                </div>

                <h2>Recovery Patterns</h2>

                <p>
                    Explore weekly activity levels during different phases of
                    the pandemic for different cities.
                </p>
            </div>
        </a>

        <a href="/charts/correlations">
            <div class="card">
                <div class="card-img">
                    <img src={cardImgCorrelations} />
                </div>

                <h2>Correlations</h2>

                <p>
                    Visualize how downtown recovery is (or is not) related to a
                    range of other urban data.
                </p>
            </div>
        </a>

        <a href="/blog/recovery-rankings-during-the-week">
            <div class="card">
                <div class="card-img">
                    <img src={cardImgWeekly} />
                </div>

                <h2>Recovery After Hours</h2>

                <p>
                    How does downtown recovery vary for working and non-working
                    hours?
                </p>
            </div>
        </a>

        <a href="/blog/toronto-buildings">
            <div class="card">
                <div class="card-img">
                    <img src={cardImgTorontoBuildings} />
                </div>

                <h2>Building-By-Building Recovery</h2>

                <p>
                    Understanding post-pandemic recovery for individual
                    buildings. A Toronto case-study.
                </p>
            </div>
        </a>

        <a href="/blog/downtown-definitions">
            <div class="card">
                <div class="card-img">
                    <img src={cardImgDowntownDefinition} />
                </div>

                <h2>Downtown Definition</h2>

                <p>
                    Interactive map and blog post on how recovery varies for
                    different definitions of downtowns.
                </p>
            </div>
        </a>

        <a href="/blog/downtown-recovery-and-transit-ridership">
            <div class="card">
                <div class="card-img">
                    <img src={cardImgTransitRidership} />
                </div>

                <h2>Downtown Recovery & Transit</h2>

                <p>
                    Blog post on how downtown recovery is related to recovery in
                    transit ridership.
                </p>
            </div>
        </a>

        <a href="/death_of_downtown_policy_brief.pdf">
            <div class="card">
                <div class="card-img">
                    <img src={cardImgReport} />
                </div>

                <h2>Policy Brief</h2>

                <p>
                    Our report (updated January 2023) on recovery patterns and
                    their explanatory factors.
                </p>
            </div>
        </a>

        <a
            href="https://www.youtube.com/watch?v=K2E1uvWqSH8&feature=youtu.be"
            target="_blank"
        >
            <div class="card">
                <div class="card-img">
                    <img src={cardImgVideo} />
                </div>

                <h2>Explainer Video</h2>

                <p>
                    Our short video on downtown recovery and how to prevent the
                    death of downtown.
                </p>
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
        #cards-wrapper {
            grid-template-columns: repeat(2, 1fr);
        }
    }

    .card-img img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
</style>
