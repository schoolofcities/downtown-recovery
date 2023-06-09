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


export const cities = [

  {
    city: "Calgary",
    display_title: "Calgary, AB",
    region: "Canada",
    colour: "#ab1368",
  },
  {
    city: "Edmonton",
    display_title: "Edmonton, AB",
    region: "Canada",
    colour: "#ab1368",
  },
  {
    city: "Halifax",
    display_title: "Halifax, NS",
    region: "Canada",
    colour: "#ab1368",
  },
  {
    city: "London",
    display_title: "London, ON",
    region: "Canada",
    colour: "#ab1368",
  },
  {
    city: "Mississauga",
    display_title: "Mississauga, ON",
    region: "Canada",
    colour: "#ab1368",
  },
  {
    city: "Montreal",
    display_title: "Montréal, QC",
    region: "Canada",
    colour: "#ab1368",
  },
  {
    city: "Ottawa",
    display_title: "Ottawa, ON",
    region: "Canada",
    colour: "#ab1368",
  },
  {
    city: "Quebec",
    display_title: "Québec, QC",
    region: "Canada",
    colour: "#ab1368",
  },
  {
    city: "Toronto",
    display_title: "Toronto, ON",
    region: "Canada",
    colour: "#ab1368",
  },
  {
    city: "Vancouver",
    display_title: "Vancouver, BC",
    region: "Canada",
    colour: "#ab1368",
  },
  {
    city: "Winnipeg",
    display_title: "Winnipeg, MB",
    region: "Canada",
    colour: "#ab1368",
  },
  {
    city: "Chicago",
    display_title: "Chicago, IL",
    region: "Midwest",
    colour: "#007fa3",
  },
  {
    city: "Cincinnati",
    display_title: "Cincinnati, OH",
    region: "Midwest",
    colour: "#007fa3",
  },
  {
    city: "Cleveland",
    display_title: "Cleveland, OH",
    region: "Midwest",
    colour: "#007fa3",
  },
  {
    city: "Columbus",
    display_title: "Columbus, OH",
    region: "Midwest",
    colour: "#007fa3",
  },
  {
    city: "Detroit",
    display_title: "Detroit, MI",
    region: "Midwest",
    colour: "#007fa3",
  },
  {
    city: "Indianapolis",
    display_title: "Indianapolis, IN",
    region: "Midwest",
    colour: "#007fa3",
  },
  {
    city: "Kansas City",
    display_title: "Kansas City, MO",
    region: "Midwest",
    colour: "#007fa3",
  },
  {
    city: "Louisville",
    display_title: "Louisville, KY",
    region: "Midwest",
    colour: "#007fa3",
  },
  {
    city: "Milwaukee",
    display_title: "Milwaukee, WI",
    region: "Midwest",
    colour: "#007fa3",
  },
  {
    city: "Minneapolis",
    display_title: "Minneapolis, MN",
    region: "Midwest",
    colour: "#007fa3",
  },
  {
    city: "Omaha",
    display_title: "Omaha, NE",
    region: "Midwest",
    colour: "#007fa3",
  },
  {
    city: "St Louis",
    display_title: "St. Louis, MO",
    region: "Midwest",
    colour: "#007fa3",
  },
  {
    city: "Wichita",
    display_title: "Wichita, KS",
    region: "Midwest",
    colour: "#007fa3",
  },
  {
    city: "Baltimore",
    display_title: "Baltimore, MD",
    region: "Northeast",
    colour: "#8dbf2e",
  },
  {
    city: "Boston",
    display_title: "Boston, MA",
    region: "Northeast",
    colour: "#8dbf2e",
  },
  {
    city: "New York",
    display_title: "New York, NY",
    region: "Northeast",
    colour: "#8dbf2e",
  },
  {
    city: "Philadelphia",
    display_title: "Philadelphia, PA",
    region: "Northeast",
    colour: "#8dbf2e",
  },
  {
    city: "Pittsburgh",
    display_title: "Pittsburgh, PA",
    region: "Northeast",
    colour: "#8dbf2e",
  },
  {
    city: "Washington DC",
    display_title: "Washington DC",
    region: "Northeast",
    colour: "#8dbf2e",
  },
  {
    city: "Bakersfield",
    display_title: "Bakersfield, CA",
    region: "Pacific",
    colour: "#6d247a",
  },
  {
    city: "Fresno",
    display_title: "Fresno, CA",
    region: "Pacific",
    colour: "#6d247a",
  },
  {
    city: "Honolulu",
    display_title: "Honolulu, HI",
    region: "Pacific",
    colour: "#6d247a",
  },
  {
    city: "Los Angeles",
    display_title: "Los Angeles, CA",
    region: "Pacific",
    colour: "#6d247a",
  },
  {
    city: "Oakland",
    display_title: "Oakland, CA",
    region: "Pacific",
    colour: "#6d247a",
  },
  {
    city: "Portland",
    display_title: "Portland, OR",
    region: "Pacific",
    colour: "#6d247a",
  },
  {
    city: "Sacramento",
    display_title: "Sacramento, CA",
    region: "Pacific",
    colour: "#6d247a",
  },
  {
    city: "San Diego",
    display_title: "San Diego, CA",
    region: "Pacific",
    colour: "#6d247a",
  },
  {
    city: "San Francisco",
    display_title: "San Francisco, CA",
    region: "Pacific",
    colour: "#6d247a",
  },
  {
    city: "San Jose",
    display_title: "San Jose, CA",
    region: "Pacific",
    colour: "#6d247a",
  },
  {
    city: "Seattle",
    display_title: "Seattle, WA",
    region: "Pacific",
    colour: "#6d247a",
  },
  {
    city: "Atlanta",
    display_title: "Atlanta, GA",
    region: "Southeast",
    colour: "#dc4633",
  },
  {
    city: "Charlotte",
    display_title: "Charlotte, NC",
    region: "Southeast",
    colour: "#dc4633",
  },
  {
    city: "Jacksonville",
    display_title: "Jacksonville, FL",
    region: "Southeast",
    colour: "#dc4633",
  },
  {
    city: "Memphis",
    display_title: "Memphis, TN",
    region: "Southeast",
    colour: "#dc4633",
  },
  {
    city: "Miami",
    display_title: "Miami, FL",
    region: "Southeast",
    colour: "#dc4633",
  },
  {
    city: "Nashville",
    display_title: "Nashville, TN",
    region: "Southeast",
    colour: "#dc4633",
  },
  {
    city: "New Orleans",
    display_title: "New Orleans, LA",
    region: "Southeast",
    colour: "#dc4633",
  },
  {
    city: "Raleigh",
    display_title: "Raleigh, NC",
    region: "Southeast",
    colour: "#dc4633",
  },
  {
    city: "Tampa",
    display_title: "Tampa, FL",
    region: "Southeast",
    colour: "#dc4633",
  },
  {
    city: "Albuquerque",
    display_title: "Albuquerque, NM",
    region: "Southwest",
    colour: "#e6ab02",
  },
  {
    city: "Austin",
    display_title: "Austin, TX",
    region: "Southwest",
    colour: "#e6ab02",
  },
  {
    city: "Colorado Springs",
    display_title: "Colorado Springs, CO",
    region: "Southwest",
    colour: "#e6ab02",
  },
  {
    city: "Denver",
    display_title: "Denver, CO",
    region: "Southwest",
    colour: "#e6ab02",
  },
  {
    city: "El Paso",
    display_title: "El Paso, TX",
    region: "Southwest",
    colour: "#e6ab02",
  },
  {
    city: "Fort Worth",
    display_title: "Fort Worth, TX",
    region: "Southwest",
    colour: "#e6ab02",
  },
  {
    city: "Houston",
    display_title: "Houston, TX",
    region: "Southwest",
    colour: "#e6ab02",
  },
  {
    city: "Las Vegas",
    display_title: "Las Vegas, NV",
    region: "Southwest",
    colour: "#e6ab02",
  },
  {
    city: "Phoenix",
    display_title: "Phoenix, AZ",
    region: "Southwest",
    colour: "#e6ab02",
  },
  {
    city: "Salt Lake City",
    display_title: "Salt Lake City, UT",
    region: "Southwest",
    colour: "#e6ab02",
  },
  {
    city: "San Antonio",
    display_title: "San Antonio, TX",
    region: "Southwest",
    colour: "#e6ab02",
  },
  {
    city: "Tucson",
    display_title: "Tucson, AZ",
    region: "Southwest",
    colour: "#e6ab02",
  },
  {
    city: "Tulsa",
    display_title: "Tulsa, OK",
    region: "Southwest",
    colour: "#e6ab02",
  }
];

export const selectedCities = [
  "Montréal, QC", "Toronto, ON", "Chicago, IL",
  "Detroit, MI", "Baltimore, MD", "New York, NY",
  "Los Angeles, CA", "San Francisco, CA", "Atlanta, GA",
  "Miami, FL", "Austin, TX", "Las Vegas, NV"];
