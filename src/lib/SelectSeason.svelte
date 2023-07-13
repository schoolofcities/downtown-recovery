<script>
    import { season } from './stores.js';
    import '../assets/global.css';

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
        },
        {
            "name": "Spring: Mar 2023 - May 2023",
            "number": 13
        }
    ]

    let initialSeason = $season;
    
    function handleChange(event) {
        const selectedValue = event.target.value;
        season.set(selectedValue);
    }

</script>

<p>Select Season:</p>
<select value={initialSeason} on:change={handleChange}>
    {#each seasons as season}
        <option value={season.number}>{season.name}</option>
    {/each}
</select>


<style>
    
    select {
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