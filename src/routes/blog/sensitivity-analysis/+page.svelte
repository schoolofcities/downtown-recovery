<script>

    import Header from "../../../lib/Header.svelte";
    import "../../../assets/global.css";
    import MapPlot from "./lib/MapPlot.svelte";

</script>



<Header/>

<main>

    <div class="text">

        <h3>
            How Does The Definition of Downtown Affect Its Recovery Rate?
        </h3>

        <p>
            By <a href='https://www.urbandisplacement.org/team/julia-greenberg/' target='_blank'>Julia Greenberg</a>, <a href='https://schoolofcities.utoronto.ca/people/byeonghwa-jeong/' target='_blank'>Byeonghwa Jeong</a>, <a href='https://schoolofcities.utoronto.ca/people/jeff-allen/' target='_blank'>Jeff Allen</a>, <a href='https://www.geography.utoronto.ca/people/directories/all-faculty/karen-chapple' target='_blank'>Karen Chapple</a>, and Sarah Smith | [DATE]
        </p>

    </div>

    <div class="text">

        <p>
            Since there is no standard spatial definition of "downtown," researchers have relied on a variety of methods to create geographic boundaries for this area. Downtowns, which typically include the oldest, most established parts of a city, can be as small as a few city blocks or as large as several square miles.<a href="#footnote-1">[1]</a>
        </p>
        <p>
            Since the US Census Bureau stopped collecting data for “central business districts” – another term for downtowns – in 1984, these boundaries have often been constructed using existing spatial units like census tracts.<a href="#footnote-2">[2]</a> For example, researchers at the Brookings Institution defined the central business district in US cities as the census block with the highest job density and number of jobs in the region, and then identified the "commercial core" as the neighboring block groups with high density development and high ratios of jobs to residents.<a href="#footnote-3">[3]</a>
        </p>
        <p>
            Other methods for defining downtown include using a specific distance threshold from the "100 percent corner" (the urban intersection with the highest land value), examining historic maps and street grids, and asking city officials and leaders for their local expertise.<a href="#footnote-1">[1,</a><a href="#footnote-2">2]</a>
        </p>
        <p>
            All of these methodologies have their shortcomings; for example, they generally do not account for the fact that some cities are polycentric and have multiple downtown areas.<a href="#footnote-4">[4]</a> Given the heterogeneity of urban regions – with tremendous variety in their economic context, built environment, and geographic scale – there also may not be a standard definition of downtown that works well for multiple cities.
        </p>
        <p>
            Because it is so challenging to come up with a single definition of downtown, we created multiple downtown polygons for each city. Use the drop-down menu below to select a city and compare the “recovery rates” of the different downtown boundaries (see our <a href='https://downtownrecovery.com/methodology' target='_blank'>methodology page</a> to learn more about how these rates were calculated).
        </p>
    
    </div>

    <div class="text">

        <MapPlot/>

    </div>

</main>



<style>

    h3 {
        font-size: 25px;
    }

</style>
