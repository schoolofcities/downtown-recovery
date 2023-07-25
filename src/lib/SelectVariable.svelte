<script>
    import { selectedVariable } from './stores.js';
    import '../assets/global.css';
    import { onMount } from 'svelte';
    import { csvParse } from 'd3-dsv';

    let initialVariable;

    let dataDictionary = [];
    
    let dataDictionaryCommuting = [];
    let dataDictionaryCovid = [];
    let dataDictionaryDemographics = [];
    let dataDictionaryEmployment = [];
    let dataDictionaryHousing = [];
    let dataDictionaryIncome = [];
    let dataDictionaryPolitics = [];
    let dataDictionaryWeather = [];

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

    onMount(() => {
        loadDataDictionary();
        initialVariable = $selectedVariable;
    });

    $: dataDictionaryCommuting = dataDictionary.filter(obj => obj.group === "Commuting");
    $: dataDictionaryCovid = dataDictionary.filter(obj => obj.group === "COVID-19 Closures");
    $: dataDictionaryDemographics = dataDictionary.filter(obj => obj.group === "Demographics");
    $: dataDictionaryEmployment = dataDictionary.filter(obj => obj.group === "Employment")
    $: dataDictionaryHousing = dataDictionary.filter(obj => obj.group === "Housing")
    $: dataDictionaryIncome = dataDictionary.filter(obj => obj.group === "Income")
    $: dataDictionaryPolitics = dataDictionary.filter(obj => obj.group === "Political Leaning")
    $: dataDictionaryWeather = dataDictionary.filter(obj => obj.group === "Weather")
    
    function handleChange(event) {
        const selectedValue = event.target.value;
        selectedVariable.set(selectedValue);
    }

</script>

<p>Select Variable:</p>
<select value={initialVariable} on:change={handleChange}>
    <optgroup label="Demographics">
        {#each dataDictionaryDemographics as v}
            <option value={v.value}>{v.text}</option>
        {/each}
    </optgroup>
    <optgroup label="Employment">
        {#each dataDictionaryEmployment as v}
            <option value={v.value}>{v.text}</option>
        {/each}
    </optgroup>
    <optgroup label="Income">
        {#each dataDictionaryIncome as v}
            <option value={v.value}>{v.text}</option>
        {/each}
    </optgroup>
    <optgroup label="Housing">
        {#each dataDictionaryHousing as v}
            <option value={v.value}>{v.text}</option>
        {/each}
    </optgroup>
    <optgroup label="Commuting">
        {#each dataDictionaryCommuting as v}
            <option value={v.value}>{v.text}</option>
        {/each}
    </optgroup>
    <optgroup label="Weather">
        {#each dataDictionaryWeather as v}
            <option value={v.value}>{v.text}</option>
        {/each}
    </optgroup>
    <optgroup label="COVID-19 Closures">
        {#each dataDictionaryCovid as v}
            <option value={v.value}>{v.text}</option>
        {/each}
    </optgroup>
    <optgroup label="Political Leaning">
        {#each dataDictionaryPolitics as v}
            <option value={v.value}>{v.text}</option>
        {/each}
    </optgroup>
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