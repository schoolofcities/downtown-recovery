<script>
    import { regions, selectedRegions } from './stores.js';
    import '../assets/global.css';

    import { onMount } from 'svelte';

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


<div id="buttons">
    {#each $regions as region}
        <div
        class="button"
        on:click={() => handleClick(region.name)}
        style="color: white; "
        >
            <div class="box" style="background-color: {region.colour}"></div>
            <div class="name">
                {region.name}
            </div>
        </div>
    {/each}
</div>



<style>
    .button {
        width: 500px;
        float: left;
    }
    .box {
        height: 15px;
        width: 15px;
        border: solid 1px white;
        float:left;
    }
    .name {
        overflow: hidden;
        padding-left: 5px;
    }
</style>
