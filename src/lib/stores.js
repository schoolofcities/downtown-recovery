import { writable, readable } from 'svelte/store';

export const season = writable(12);

export const selectedRegions = writable(["Southeast", "Southwest", "Pacific", "Northeast", "Midwest", "Canada"]);

export const regions = readable(
    [ 
        {
            "name": "Midwest",
            "colour": "#6FC7EA",
            "text": "#000"
        },
        {
            "name": "Northeast",
            "colour": "#8DBF2E",
            "text": "#000"
        },
        {
            "name": "Pacific",
            "colour": "#00A189",
            "text": "#000"
        },
        {
            "name": "Southwest",
            "colour": "#F1C500",
            "text": "#000"
        },
        {
            "name": "Southeast",
            "colour": "#AB1368",
            "text": "#fff"
        },
        {
            "name": "Canada",
            "colour": "#DC4633",
            "text": "#fff"
        },
        {
            "name": "Europe",
            "colour": "#ffffff",
            "text": "#000"
        }
    ]
)
