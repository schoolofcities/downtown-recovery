<script>

    import Header from "../../lib/Header.svelte";
    import "../../assets/global.css";

</script>


<Header/>

<main>

    <div class="text">

        <h1>Methodology</h1>

        <p>
            The recovery metrics on these charts are based on a sample of mobile phone data. 
        </p>
        <p>
            The recovery metrics on the charts and maps are computed by counting the number of unique visitors in a city's downtown area in the specified time period (standardized by region – see ‘Standardization’ section below), and then dividing it by the standardized number of unique visitors during the equivalent time period in 2019.
        </p>
        <p>
            A recovery metric greater than 100% means that the mobile device activity increased from the comparison period. A value less than 100% means the opposite, that the city's downtown has not recovered to pre-COVID activity levels.
        </p>

        <h2>Downtown Geography Selection</h2>

        <p>
            Our previous method for creating downtown polygons involved selecting zip codes with the highest job density. Our updated polygon definitions are more precise and do not rely as heavily on administrative or census boundaries, which often do not reflect the actual geographies of cities’ downtowns. To create these new definitions, we used jobs data to identify concentrations of jobs on individual blocks and then drew a polygon around these clusters to represent downtown. (For more details, see an appendix below).
        </p>

        <h2>Standardization</h2>

        <p>
            Because fluctuations in unique device counts over time may reflect changes in sample sizes from data providers rather than actual changes in activity, we standardized the downtown counts using larger geographies. In our previous method, this was the state (in the U.S.) or province (in Canada). Our updated method instead standardizes the data using core based statistical areas (in the U.S.) and census metropolitan areas (in Canada). Standardization using these smaller areas results in more accurate recovery rates, since a city’s downtown is not affected by the activity patterns of other cities in the same state.
        </p>

        <h2>Data Providers & Imputation</h2>

        <p>
            Our mobile device data provider, Spectus, sources information from multiple providers. The most reliable source lacks data before May 2021, so we imputed this information using data from other providers (for more details, see appendix below).
        </p>



        <h2>Website:</h2>

        <p>
            This website was built using Svelte with a bit of D3 for the charts. Code is on <a href="https://github.com/schoolofcities/downtown-recovery">GitHub</a>
        </p>

    </div>

    <div class="text"></div>

    <div class="text">

        <h1>Detailed Methodology</h1>

        <h2>Downtown Geography Selection</h2>

        <p>
            Our previous method for creating downtown polygons involved selecting zip codes with the highest job density. Our updated polygon definitions are more precise and do not rely as heavily on administrative or census boundaries, which often do not reflect the actual geographies of cities’ downtowns. 
        </p>
        <p>
            To create these new definitions, we used jobs data from 2019 (<a href="https://lehd.ces.census.gov/data/">in the U.S.</a>) and 2016 (<a href="http://odesi2.scholarsportal.info/documentation/CENSUS/2016/cen16labour.html">in Canada</a>). We generated 1 randomly scattered point for every 100 jobs in each block (in the U.S.) or dissemination area (in Canada). We then applied the <a href="https://scikit-learn.org/stable/modules/generated/sklearn.cluster.HDBSCAN.html">HDBSCAN</a> algorithm to each city individually to create clusters of points within the city, discarding the points designated as “noise” and tuning the parameters to select a cluster representing each city’s downtown. For this step, we validated these geographies using Google Maps, cities’ own definitions of their downtowns, our personal knowledge of certain cities, and Brookings’ 2023 <a href="https://www.brookings.edu/articles/breaking-the-urban-doom-loop-the-future-of-downtowns-is-shared-prosperity/">definitions of downtowns</a> across the U.S. Next, we created a buffer around each point in the cluster and created a polygon from the spatial union of these buffers. Lastly, we formed a <a href="https://shapely.readthedocs.io/en/stable/reference/shapely.concave_hull.html#shapely.concave_hull">concave hull</a> around this polygon to create the final downtown area.
        </p>

        <h2>Standardization</h2>

        <p>
            Because fluctuations in unique device counts over time may reflect changes in sample sizes from data providers rather than actual changes in activity, we standardized the downtown counts using larger geographies. In other words, instead of tracking the raw numbers of unique devices in a downtown area over time, we tracked unique device counts in the downtown divided by unique device counts in a larger area. 
        </p>
        <p>
            In our previous method, this “larger area” was the state (in the U.S.) or province (in Canada). Our updated method instead standardizes the data using core based statistical areas (in the U.S.) and census metropolitan areas (in Canada). Standardization using these smaller areas results in more accurate recovery rates, since a city’s downtown is not affected by the activity patterns of other cities in the same state.
        </p>

        <h2>
            Data Providers & Imputation
        </h2>
        
        <p>
            Spectus, a data provider, sources information from two different providers. Although one provider supplies the counts of mobile phone data between 2019 and 2023 in the US and Canada, the sample size of the data has been significantly declined, which is likely to hinder the accuracy of estimated recovery rates. On the other hand, another provider offers more comprehensive data covering the US and Canada, but this provider does not include Canadian data before May 2021. To address this gap, we employed the Self-Attention-based Imputation for Time Series (SAITS) model developed by <a href="https://doi.org/10.1016/j.eswa.2023.119619">Wenjie, David, & Yan in 2023</a>. Before initiating the imputation process, our underlying hypothesis for imputation was that if we had Canadian data before May 2021, it might show trends similar to those in the US and Canadian cities for two providers.
        </p>
        <p>
            The SAITS model, which employs self-attention techniques, is well-known for capturing dependencies in sequential data, similar to its use in language translation. The approach helps identify relationships within time series data and impute missing information based on observed trends. The overall process of SAITS is that it first converts randomly selected observed values into missing values. Through a series of operations, the model results in the predicted missing values. Finally, the model compares the predicted and original values of artificially created missing values, which allows us to estimate the accuracy of the imputation. In this process, the model is trained for imputation, and the successfully trained model can impute the missing data.
        </p>
        <p>
            We applied the SAITS model to fill in missing data in Canadian cities from Jan 2019 to May 2021, with a focus on normalizing user ratios. To achieve this goal, the weekly normalizing user ratios data of cities in the US and Canada by two providers was built. Observed data was filled with actual values, whereas the missing data was filled with no value. This resulted in a matrix in which the rows and columns showed the week and value of two providers of all study areas, respectively. After preparing the data, we flipped it chronologically and split it into training and test sets. The training set included 70% of the data, and the remaining part served as the test data. Hyperparameters were tuned through grid search, considering the number of iterations, learning rates, and dropout rates. The model's performance was evaluated using Root Mean Squared Error (RMSE). We found that 130 iterations, 0.001 learning rates, and 0.2 dropout rates were the best combination. Based on the trained model using this hyperparameter combination, the missing data was imputed.
        </p>

    </div>

    <div class="text"></div>


</main>
