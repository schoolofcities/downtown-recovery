<script>

	import { regions, selectedRegions } from './stores.js';
	import '../assets/global.css';

	export let europe;
	export let canada;
	// export let midwest;
	// export let northeast;
	// export let southwest;
	// export let southeast;
	// export let pacific;

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

<div id="buttons">

	{#each $regions as region}
		
		{#if region.name === "Europe"}

			{#if europe === "yes"}

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

		{:else if region.name === "Canada"}

			{#if canada === "yes"}

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

		<!-- {:else if region.name === "Pacific"}

			{#if pacific === "yes"}

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
			
		{:else if region.name === "Southeast"}

			{#if southeast === "yes"}

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
			
		{:else if region.name === "Southwest"}

			{#if southwest === "yes"}

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
			
		{:else if region.name === "Northeast"}

			{#if northeast === "yes"}

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
			
		{:else if region.name === "Midwest"}

			{#if midwest === "yes"}

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

			{/if}				 -->

		{:else}

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
