<script>
    import { selectedVariable } from './stores.js';
    import '../assets/global.css';
    import { onMount } from 'svelte';
    import { csvParse } from 'd3-dsv';

    let dataDictionary = [];

    async function loadDataDictionary() {
        try {
            const response = await fetch('../variables_data_dictionary.csv');
            const csvData = await response.text();
            dataDictionary = csvParse(csvData);
            console.log(dataDictionary);
        } catch (error) {
            console.error('Error loading CSV data:', error);
        }
    }

    let initialVariable;

    onMount(() => {
        loadDataDictionary();
        initialVariable = $selectedVariable;
    });
    
    function handleChange(event) {
        const selectedValue = event.target.value;
        selectedVariable.set(selectedValue);
    }

</script>

<p>Select Variable:</p>
<select value={initialVariable} on:change={handleChange}>
    {#each dataDictionary as v}
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