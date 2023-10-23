<script>

    import Header from "../../lib/Header.svelte";
    import "../../assets/global.css";

</script>


<Header/>

<main>

    <div class="text">

        <h1>Methodology</h1>

        <p>
            The recovery metrics on this website are based on a sample of location-based mobility data derived from cell phones.
        </p>
        <p>
            The recovery metrics on the charts and maps are computed by counting the number of unique visitors in a city's downtown area in the specified time period (standardized by region – see ‘Standardization’ section below), and then dividing it by the standardized number of unique visitors during the equivalent time period in 2019.
        </p>
        <p>
            A recovery metric greater than 100% means that for the selected inputs, the mobile device activity increased relative to the comparison period. A value less than 100% means the opposite, that the city's downtown has not recovered to pre-COVID activity levels.
        </p>

        <h2>Downtown Geography Selection</h2>

        <p>
            When we launched this project, the geography of what counts as "downtown" involved selecting zip codes (in the US) and Dissemination Areas (in Canada) with the highest job density. 
        </p>
        <p>
            In our October 2023 update, we've improved these definitions to not rely as heavily on administrative or census boundaries, which often do not reflect the actual geographies of cities’ downtowns. To create these new definitions, we used jobs data to identify concentrations of jobs in individual city blocks and then drew a polygon around these clusters to represent downtown. (For more details, see below).
        </p>
        <p>
            Specifically, to create new geographic definitions of “downtown”, we used jobs data from 2019 (<a href="https://lehd.ces.census.gov/data/">in the U.S.</a>) and 2016 (<a href="http://odesi2.scholarsportal.info/documentation/CENSUS/2016/cen16labour.html">in Canada</a>). We generated 1 randomly scattered point for every 100 jobs in each block (in the U.S.) or Dissemination Area (in Canada). We then applied the <a href="https://scikit-learn.org/stable/modules/generated/sklearn.cluster.HDBSCAN.html">HDBSCAN</a> algorithm to each city individually to create clusters of points within the city, discarding the points designated as “noise” and tuning the parameters to select a cluster representing each city’s downtown. For this step, we validated these geographies using Google Maps, cities’ own definitions of their downtowns, our personal knowledge of certain cities, and Brookings’ 2023 <a href="https://www.brookings.edu/articles/breaking-the-urban-doom-loop-the-future-of-downtowns-is-shared-prosperity/">definitions of downtowns</a> across the U.S. Next, we created a buffer around each point in the cluster and created a polygon from the spatial union of these buffers. Lastly, we formed a <a href="https://shapely.readthedocs.io/en/stable/reference/shapely.concave_hull.html#shapely.concave_hull">concave hull</a> around this polygon to create the final downtown area.
        </p>
        <p>
            Click <a href="/downtowns-hbscan.geojson">here</a> to download a geojson file of the new downtown boundaries. Click <a href="/downtowns-original.geojson">here</a> to download a geojson file of our original zip-code defined downtowns.
        </p>

        <h2>Standardization</h2>

        <p>
            Because fluctuations in unique device counts over time may reflect changes in sample sizes from data providers rather than actual changes in activity, we standardized the downtown counts using larger geographies. In our previous method, this was the state (in the U.S.) or province (in Canada). Our updated method instead standardizes the data using core based statistical areas (in the U.S.) and census metropolitan areas (in Canada). Standardization using these smaller areas results in more accurate recovery rates, since a city’s downtown is not affected by the activity patterns of other cities in the same state.
        </p>

        <h2>Data Providers & Imputation</h2>

        <p>
            Our mobile device data comes from <a href="https://spectus.ai/">Spectus</a>. They source data from multiple providers. One of these providers includes data for the entire study period; however, its sample size declines significantly during this period. A second provider has a significantly larger sample size, but does not include Canadian data before May 2021. We decided to use data from this second provider and impute pre-May 2021 data for Canada, relying on the assumption that differences between the two providers are similar in the US and in Canada. 
        </p>

        <p>
            The imputation model we employed is called Self-Attention-based Imputation for Time Series (SAITS). The <a href="https://doi.org/10.1016/j.eswa.2023.119619">SAITS model</a>, which employs self-attention techniques, identifies relationships within time series data and imputes missing information based on observed trends. The model converts randomly selected observed values into missing values, predicts the missing values, and compares the predicted and original values to evaluate the accuracy of the model.
        </p>

        <h2>
            Measuring recovery rates
        </h2>

        <p>
            Because of the data imputation process, we calculated recovery rates slightly differently for the U.S. and Canada.
        </p>

        <p>
            In the US, we measured recovery rates for each city by:
        </p>

        <p>1) Calculating the sum of daily unique devices both downtown and in the core based statistical area for all of the days in the study period (March through mid-June) in 2019 as well as 2023.</p>

        <p>2) Standardizing the counts for each year by dividing the summed device count in the downtown area by the summed device count in the core based statistical area.</p>

        <p>3) Dividing the standardized count in the 2023 study period by the total count in the 2019 study period for each city.</p>

        <p>
            In Canada, we measured recovery rates for each city by:
        </p>
        
        <p>1) Calculating the weekly sum of daily unique devices both downtown and in the census metropolitan area. </p>

        <p>2) Standardizing the weekly counts by dividing the weekly summed device count in the downtown area by the weekly summed device count in the census metropolitan area.</p>

        <p>3) Imputing pre-5/17/21 data using these standardized weekly counts (see Data Providers & Imputation section).</p>

        <p>4) Determining weekly recovery rates by dividing the standardized weekly counts in 2023 by the (imputed) standardized weekly counts in the same week in 2019.</p>

        <p>5) Calculating the average weekly recovery rate by city.</p>



        <h2>Website:</h2>

        <p>
            This website was built using Svelte with a bit of D3 for the charts. Code is on <a href="https://github.com/schoolofcities/downtown-recovery">GitHub</a>
        </p>

    </div>

    <div class="text"></div>

    <div class="text"></div>


</main>
