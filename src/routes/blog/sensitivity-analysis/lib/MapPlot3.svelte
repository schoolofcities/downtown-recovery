<script>
    import { onMount} from 'svelte';
    import { cityCoordinates } from './city_coords2.js';
    import { scaleLinear, scaleBand, select, axisBottom, axisLeft } from 'd3';
  
    let pageHeight;
    let pageWidth;
    let selectedCity = 'Albuquerque NM'; // Default city
    let chartData = [];
  
    function updateChartData() {
      const selectedData = cityCoordinates[selectedCity];
      chartData = [
        { label: 'rq_comm', value: selectedData.rq_comm },
        { label: 'rq_zip', value: selectedData.rq_zip },
        { label: 'rq_hdbscan', value: selectedData.rq_hdbscan }
      ];
    }
  
    function renderChart() {

      updateChartData();
        
      const margin = { top: 20, right: 20, bottom: 30, left: 40 };
      const width = 400;
      const height = 200;
  
      const x = scaleLinear().domain([0, Math.max(...chartData.map(d => d.value))]).nice().range([margin.left, width - margin.right]);
      const y = scaleBand().domain(chartData.map(d => d.label)).range([height - margin.bottom, margin.top]);
  
      const svg = select('.chart-container > svg');
      svg.selectAll('*').remove();
  
      svg
        .selectAll('rect')
        .data(chartData)
        .enter()
        .append('rect')
        .attr('x', margin.left)
        .attr('y', d => y(d.label))
        .attr('width', d => x(d.value))
        .attr('height', y.bandwidth())
        .attr('fill', 'steelblue');
  
      svg
        .append('g')
        .attr('transform', `translate(0,${height - margin.bottom})`)
        .call(axisBottom(x));
  
      svg
        .append('g')
        .attr('transform', `translate(${margin.left},0)`)
        .call(axisLeft(y));
    }

    onMount(() => {
      renderChart();
    });

  </script>
  
  <svelte:window bind:innerHeight={pageHeight} bind:innerWidth={pageWidth}/>
  
  <div class="container">
    <div class="chart-container">
      <svg width="400" height="200"></svg>
    </div>
    <div>
      <div>
        <label for="cityDropdown">Select a city:</label>
        <select bind:value={selectedCity} on:change={renderChart}>
          {#each Object.keys(cityCoordinates) as city}
            <option value={city}>{city}</option>
          {/each}
        </select>
      </div>
    </div>
  </div>
  
  <style>
    .container {
      display: flex;
      flex-direction: row;
      justify-content: space-between;
      align-items: flex-start;
      max-width: 1200px;
      margin: 0 auto;
    }
  
    .chart-container {
      width: 80%;
      height: 100%;
      margin: 0 auto;
      max-width: 900px;
    }
  
    #sidebar {
      width: 30%;
      margin-left: 20px;
    }
  </style>
  