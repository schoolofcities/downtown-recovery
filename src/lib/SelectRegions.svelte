<script>

    import { regions, selectedRegions } from './stores.js';
    import '../assets/global.css';

    export let europe;

    let selectedButtons = $selectedRegions;

    function handleClick(name) {
        if ($selectedRegions.includes(name)) {
            $selectedRegions = $selectedRegions.filter(region => region !== name);
        } else {
            $selectedRegions = [...$selectedRegions, name];
        }
    }

    $: selectedRegions.set(selectedButtons)
    
</script>


<!-- <p>Select Regions:</p> -->

<div id="buttons">
    {#if europe === "yes"}
        {#each $regions as region}
            <div
            class="button"
            on:click={() => handleClick(region.name)}
            style="color: white; opacity: {$selectedRegions.includes(region.name) ? 1 : 0.333}"
            >
                <div class="box" style="background-color: {region.colour}"></div>
                <div class="name" >
                    {region.name}
                </div>
            </div>
        {/each}
    {/if}

    {#if europe === "no"}
        {#each $regions as region}
            {#if region.name !== "Europe"}
                <div
                class="button"
                on:click={() => handleClick(region.name)}
                style="color: white; opacity: {$selectedRegions.includes(region.name) ? 1 : 0.333}"
                >
                    <div class="box" style="background-color: {region.colour}"></div>
                    <div class="name" >
                        {region.name}
                    </div>
                </div>
            {/if}
        {/each}
    {/if}
</div>



<style>

    #buttons {
        display: flex;
        flex-wrap: wrap;
        max-width: 750px;
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
        color: var(--brandWhite);
        font-size: 15px;
    }

    .name:hover {
        opacity: 0.7;
    }

</style>
