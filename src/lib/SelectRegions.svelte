<script>
    import { regions, selectedRegions } from './stores.js';
    import '../assets/global.css';

    let selectedButtons = $selectedRegions;

    function handleClick(name) {
        if (selectedButtons.includes(name)) {
            selectedButtons = selectedButtons.filter(region => region !== name);
        } else {
            selectedButtons = [...selectedButtons, name];
        }
    }

    $: selectedRegions.set(selectedButtons)
    
</script>


<p>Select Regions:</p>
<div id="buttons">
    {#each $regions as region}
        <div
        class="button"
        on:click={() => handleClick(region.name)}
        style="color: white; opacity: {selectedButtons.includes(region.name) ? 1 : 0.333}"
        >
            <div class="box" style="background-color: {region.colour}"></div>
            <div class="name" >
                {region.name}
            </div>
        </div>
    {/each}
</div>



<style>

    p {
        color: white;
    }

    #buttons {
        display: flex;
        flex-wrap: wrap;
        max-width: 600px;
    }

    .button {
        width: 102px;
        float: left;
    }

    .button:hover {
        cursor: pointer;
    }

    .box {
        height: 15px;
        width: 15px;
        border: solid 1px var(--brandDarkBlue);
        float:left;
    }

    .name {
        overflow: hidden;
        padding-left: 5px;
    }

    .name:hover {
        opacity: 0.7;
    }

</style>
