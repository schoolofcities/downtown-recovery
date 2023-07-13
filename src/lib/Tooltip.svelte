<script>
import { onMount } from "svelte";
export let x;
export let y;
export let labels;
export let values;
export let width = 150;
export let backgroundColor = "white";
export let textColor = "black";
export let opacity = 0.89;
export let title;
export let adaptTexts = true;
const step = 18;
const paddingLeft = 5;
const paddingRight = 5;
const lineLength = 10;
const spaceBetweenLineText = 3;
const idContainer = "svg-legend";
const maxTextLength = width - paddingLeft - lineLength -   spaceBetweenLineText - paddingRight;
let computedWidth = width;

onMount(async () => {
  const texts = document
                .getElementById(idContainer)
                .getElementsByClassName("legend-labels");

  const textWidths = [...Array(texts.length).keys()].map((d) => ({id: d, 
  width: texts[d].getBoundingClientRect().width,}));
  const longTexts = textWidths.filter((d) => d.width > maxTextLength);  
  if (longTexts.length === 0) return;
  if (adaptTexts) {
    longTexts.map((d) => {
      const textContent = texts[d.id].textContent;
      const numCharsAvailable =
        Math.floor((maxTextLength * textContent.length)/d.width)-3;
      texts[d.id].textContent = 
        textContent.slice(0, numCharsAvailable).trim() + "...";
  });
  } else {
    const maxLength = Math.max(...longTexts.map((d) => d.width));
    computedWidth =
      paddingLeft +
      lineLength +
      spaceBetweenLineText +
      maxLength +
      paddingRight;
  }
});

</script>

<svg x={x} {y} width={computedWidth + 2} height="25" id={idContainer}>
  <rect
    x="1"
    y="1"
    width={computedWidth}
    height={(labels.length + 1 + (title !== undefined ? 1 : 0)) * step}
    
    fill={backgroundColor}
    opacity={opacity}
  />
  {#if title !== undefined}
    <text
      x={paddingLeft + 3}
      y={step}
      alignment-baseline="middle"
      font-size="14"
      fill={textColor}>{title}</text>
  {/if}
 
  <g>
    <line
      x1={paddingLeft}
      x2={paddingLeft + lineLength}
      y1={(1 + (title !== undefined ? 1 : 0)) * step - 1}
      y2={(1 + (title !== undefined ? 1 : 0)) * step - 1}/>
    <text
      x={paddingLeft + lineLength + spaceBetweenLineText}
      y={( 1 + (title !== undefined ? 1 : 0)) * step}
      alignment-baseline="middle"
      font-size="14"
      fill={textColor}
      class="legend-labels">{labels}{values !== undefined
          ? ": " + values.toLocaleString(): ""}</text>
   </g>
</svg>