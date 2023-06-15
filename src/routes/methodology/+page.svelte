<script>

    import Header from "../../lib/Header.svelte";

</script>


<Header/>

<main>

    <div id="text">

        <h1>Methodology</h1>

        <h2>January 2023 update:</h2>

        <p>

            Beginning with the week of June 13th, 2022, the source of mobile device data changed from Safegraph to Spectus.

        </p>

        <p>

            To protect user privacy, Spectus does not report information on 'sensitive' points of interest- a subset of which are present in Safegraph data. Furthermore, there is no way of reconciling whether the two sources use the same panel dataset. The delivery method of Spectus device information necessitated the use of polygons to make spatial queries over the study period. Rather than collect information on each city's full boundary, only downtown areas were queried during the initial phase of this transition to account for the size and computational complexity constraints of repeating this operation for 66 cities over 1434 days.

        </p>

        <p>

            Reconciling the reported device counts from the two sources was performed like so:

        </p>

        <p>

            Spectus data was first subset on the records that were most likely to have been collected in a manner similar to Safegraph. This was done using a t-test for each week for all cities that compared the distribution of device counts between the two sources. There was insufficient evidence to reject the null hypothesis that the paired samples came from the same distribution over the entire study period for all but 3 cities: Albuquerque, Quebec, and Honolulu. Halifax was excluded from this test due to there being no recorded devices collected according to the method closest to Safegraph's prior to May 2021.

        </p>

        <p>

            The Spectus values were scaled by the average of the observed Safegraph values over the most recent 3-month interval then appended to the existing time series. The weekly downtown RQs from June 2022 through November 2022 and seasonal averages were then computed according to the methodology used previously.

        </p>

        <p>

            As the team continues this work with Spectus, we aim to incorporate city recovery quotients and relative location quotients with the updated data. 

        </p>

    </div>

</main>
