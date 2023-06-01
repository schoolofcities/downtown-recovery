import { writable, readable } from 'svelte/store';

export const season = writable(12);

export const selectedRegions = writable(["Southeast", "Southwest", "Pacific", "Northeast", "Midwest", "Canada"]);

export const regions = readable(
    [
        {
            "name": "Southeast",
            "colour": "#F1C500"
        },
        {
            "name": "Southwest",
            "colour": "#AB1368  "
        },
        {
            "name": "Pacific",
            "colour": "#00A189"
        },
        {
            "name": "Northeast",
            "colour": "#8DBF2E"
        },
        {
            "name": "Midwest",
            "colour": "#6FC7EA"
        },
        {
            "name": "Canada",
            "colour": "#DC4633"
        },
        {
            "name": "Europe",
            "colour": "#ffffff"
        }
    ]
);
