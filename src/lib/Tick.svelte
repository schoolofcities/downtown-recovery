<script>
    export let x;
    export let y;
    export let value;
    export let direction;
    export let format = true;
    export let formatFunction;
    const xTranslation = direction === "horizontal" ? x - 10 : x;

    function nFormatter(num, digits) {

      console.log(num);
      console.log(digits);
      const lookup = [
        { value: 1, symbol: "" },
        { value: 1e3, symbol: "k" },
        { value: 1e6, symbol: "M" },
        { value: 1e9, symbol: "G" },
        { value: 1e12, symbol: "T" },
        { value: 1e15, symbol: "P" },
        { value: 1e18, symbol: "E" },
      ];  const rx = /\.0+$|(\.[0-9]*[1-9])0+$/;
      
      var item = lookup
          .slice()
          .reverse()
          .find(function (item) {
            return num >= item.value;
          });
      
      return item
        ? (num / item.value)
           .toFixed(digits).replace(rx, "$1") + item.symbol
        : "0";
    }
    
    const valueLabel = formatFunction !== undefined 
        ? formatFunction(value)
        : format
          ? nFormatter(value, 1)
          : value;
      </script>
      <g transform={"translate(" + xTranslation + ", " + y + ")"}>
      <text
        y={direction === "horizontal" ? 0 : 20}
        font-size="13px"
        text-anchor={direction === "horizontal" ? "end" : "middle"}
        alignment-baseline="middle">
         {valueLabel}
      </text>
      {#if direction === "horizontal"}
        <line 
          x1={2} 
          x2={8} 
          y1={0} 
          y2={0} 
          stroke="white" 
          stroke-width="1" />
      {:else}
        <line 
          x1={0} 
          x2={0} 
          y1={2} 
          y2={8} 
          stroke="white" 
          stroke-width="1" />
      {/if}
    </g>