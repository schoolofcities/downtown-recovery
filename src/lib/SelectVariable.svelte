<script>
    import { selectedVariable } from './stores.js';
    import '../assets/global.css';

    const variables = [
        {
            "value": "total_pop_city",
            "text": "Metro population"
        },
        {
            "value": "population_density_city",
            "text": "City-wide Population Density"
        },
        {
            "value": "housing_units_city",
            "text": "City-wide Total Housing Stock"
        },
        {
            "value": "housing_density_city",
            "text": "City-wide Housing Density"
        },
        {
            "value": "pct_renter_city",
            "text": "City-wide Percentage of Rented-Occupied Units"
        },
        {
            "value": "pct_singlefam_city",
            "text": "City-wide Percentage of Single-Family Homes"
        },
        {
            "value": "pct_multifam_city",
            "text": "City-wide Percentage of Multi-Family Homes"
        },
        {
            "value": "median_age_city",
            "text": "City-wide Median Age of Residents"
        },
        {
            "value": "bachelor_plus_city",
            "text": "City-wide Percentage of Residents with a Bachelor's Degree or Higher"
        },
        {
            "value": "pct_vacant_city",
            "text": "City-wide Percentage of Vacant Housing Units"
        },
        {
            "value": "median_rent_city",
            "text": "City-wide Median Rent of Housing Units"
        },
        {
            "value": "median_hhinc_city",
            "text": "City-wide Median Household Income of Residents"
        },
        {
            "value": "pct_nhwhite_city",
            "text": "City-wide Percentage of White Residents"
        },
        {
            "value": "pct_nhblack_city",
            "text": "City-wide Percentage of Black Residents"
        },
        {
            "value": "pct_hisp_city",
            "text": "City-wide Percentage of Hispanic Residents"
        },
        {
            "value": "pct_nhasian_city",
            "text": "City-wide Percentage of Asian Residents"
        },
        {
            "value": "pct_commute_auto_city",
            "text": "City-wide Percentage of Residents who Commute to Work by Car"
        },
        {
            "value": "pct_commute_public_transit_city",
            "text": "City-wide Percentage of Residents who Commute to Work by Public Transit"
        },
        {
            "value": "pct_commute_bicycle_city",
            "text": "City-wide Percentage of Residents who Commute to Work by Bicycle"
        },
        {
            "value": "pct_commute_walk_city",
            "text": "City-wide Percentage of Residents who Commute to Work by Walking"
        },
        {
            "value": "pct_commute_others_city",
            "text": "City-wide Percentage of Residents who Commute to Work by Other Modes"
        },
        {
            "value": "average_commute_time_city",
            "text": "City-wide Average Commute Time"
        }
    ]


    let initialVariable = $selectedVariable;

    
    
    function handleChange(event) {
        const selectedValue = event.target.value;
        selectedVariable.set(selectedValue);
    }

</script>

<p>Select Variable:</p>
<select value={initialVariable} on:change={handleChange}>
    {#each variables as v}
        <option value={v.value}>{v.text}</option>
    {/each}
</select>


<style>
    
    select {
        max-width: 600px;
        max-width: calc(100vw - 30px);
        padding: 5px;
        background-color: var(--brandGray90);
        border: 1px solid var(--brandDarkBlue);
        color: white; 
    }
  
    select option {
        background-color: var(--brandGray90);
        color: white;
    }

    select:hover {
        cursor: pointer;
        background-color: black;
    }

</style>