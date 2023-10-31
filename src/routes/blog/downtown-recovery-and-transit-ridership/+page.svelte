<script>

    import Header from "../../../lib/Header.svelte";
    import "../../../assets/global.css";
    import ScatterPlot from "./lib/ScatterPlot.svelte";
    import SelectRegions from "../../../lib/SelectRegions.svelte";

</script>


<Header/>

<main>

    <div class="text">

        <h3>Downtown Recovery & Transit Ridership Recovery</h3>

        <p>By <a href="www.linkedin.com/in/amir-forouhar">Amir Forouhar</a> | October 31, 2023</p> 

        <p>
            The Covid-19 pandemic significantly impacted our vibrant city life and downtown areas. As cities aim to recover, the role of public transit in this process has garnered our attention. So, we decided to explore the interplay between recovery of downtown areas and rebound of transit ridership- an exploration that includes commuter rail, heavy rail, light rail, and buses in cities across North America.  
        </p>

        <ScatterPlot transitVariable = "Total"/>

        <p>
            What we uncovered was a connection between downtown recovery and the resurgence of public transit ridership, including commuter rail, heavy rail, and bus services. It's like a mutual reawakening - as our downtown areas gradually came back to life, people also returned to public transportation as a preferred means of commuting.
        </p>
        <p>
            While it is not a strict cause-and-effect relationship, our data suggests that public transit is an ingredient in the recipe for downtown recovery – that the return to pre-pandemic levels of urban vibrancy is intertwined with a resurgence in public transportation use.
        </p>

        <p>
            The colours of the dots on the chart indicate the geographic region of each city. Click below to toggle on/off different regions and the chart will update based on your selection.
        </p>

        <div id="options">
            <div id="options-region">
                <SelectRegions europe={"no"}/>
            </div>
        </div>

        <p>
            We've also created charts for different modes of transit; busses, light rail, heavy rail (i.e. metro and subway), and commuter rail. Check them out below
        </p>

    </div>

    <div class="text">

        <h4>Commuter Rail:</h4>

        <p>
            For cities with commuter rail systems, we observed a noteworthy connection between downtown recovery and the return of commuters to the rail lines. This suggests that as businesses and offices reopen, commuters are once again using this mode of transit to access downtown job centres.
        </p>

        <h4>Heavy rail (subway/metro):</h4>

        <p>
            The use of heavy rail systems, such as subways or metros, also indicates a correlation with the resurgence of downtown areas. These systems often offer the most straightforward transit access to urban centres, and it's clear that they contribute much to city life.
        </p>

        <h4>Light Rail:</h4>

        <p>
            Light rail, while a crucial part of public transportation, complicates the story, as we found a less significant relationship between its use and downtown recovery. This may be due to issues of accessibility/coverage or commuter preferences – it is something that we will continue to monitor and think through. 
        </p>

        <h4>Bus services:</h4>

        <p>
            Buses, often considered the backbone of urban transit systems, showed a clear connection with downtown recovery. As people return to shops, restaurants, and cultural attractions, buses offer accessible and adaptable options for reaching downtowns. 
        </p>

    </div>

    <div class="grid">

        <div class="grid-cell">
            <ScatterPlot transitVariable = "MB"/>
        </div>
        <div class="grid-cell">
            <ScatterPlot transitVariable = "LR"/>
        </div>
        <div class="grid-cell">
            <ScatterPlot transitVariable = "HR"/>
        </div>
        <div class="grid-cell">
            <ScatterPlot transitVariable = "CR"/>
        </div>

    </div>

    

    <div class="text">

        <h4>Conclusion</h4>

        <p>
            Our data analysis makes it clear that a return to the liveliness of pre-pandemic downtowns is linked to a resurgence in public transit use. As downtowns across North America bounce back slowly, public transit serves as a cohesive, sustainable, and efficient element. 
        </p>

        <p>
            The discernible relationship between downtown recovery and transit ridership recovery presents cities with a potential path to post-pandemic success. This relationship supports arguments for further investment in public transportation systems, demonstrating that thriving downtowns and robust transit networks are closely intertwined.
        </p>

        <p>
            However, it is important to acknowledge that the role of light rail in this dynamic is less clear and may require extra tailored strategies and enhancements to fully unlock its potential.
        </p>

        <p>
            The road ahead for downtowns contains ongoing challenges, but the connection between recovery and ridership provides a clear example of a way forward. 
        </p>

    </div>

    <div class="text">

        <h4>Data Sources</h4>

        <p>
            We obtained our transit ridership data from the <a href="https://www.apta.com/research-technical-resources/transit-statistics/ridership-report/">American Public Transportation Association (APTA) Ridership Report</a>. APTA’s Quarterly Ridership Report contains information on the number of unlinked passenger trips taken on public transportation, broken down by agency and mode. Our analysis specifically concentrated on the period from January to June 2023, comparing it to the reference period in 2019. For details on the downtown recovery metrics, check out our <a href="../methodology">methodology</a>. The charts on this page were made by <a href="https://jamaps.github.io">Jeff Allen</a> using D3 and Svelte.
        </p>

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

    h4 {
        text-decoration: underline;
    }

    p {
        line-height: 25px;
    }

</style>
