import { writable, readable } from 'svelte/store';

export const season = writable(13);

export const selectedVariable = writable("total_pop_city")

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
    
  },
  {
    city: "Edmonton",
    display_title: "Edmonton, AB",
    region: "Canada",
    
  },
  {
    city: "Halifax",
    display_title: "Halifax, NS",
    region: "Canada",
    
  },
  {
    city: "London",
    display_title: "London, ON",
    region: "Canada",
    
  },
  {
    city: "Mississauga",
    display_title: "Mississauga, ON",
    region: "Canada",
    
  },
  {
    city: "Montreal",
    display_title: "Montréal, QC",
    region: "Canada",
    
  },
  {
    city: "Ottawa",
    display_title: "Ottawa, ON",
    region: "Canada",
    
  },
  {
    city: "Quebec",
    display_title: "Québec, QC",
    region: "Canada",
    
  },
  {
    city: "Toronto",
    display_title: "Toronto, ON",
    region: "Canada",
    
  },
  {
    city: "Vancouver",
    display_title: "Vancouver, BC",
    region: "Canada",
    
  },
  {
    city: "Winnipeg",
    display_title: "Winnipeg, MB",
    region: "Canada",
    
  },
  {
    city: "Chicago",
    display_title: "Chicago, IL",
    region: "Midwest",
    
  },
  {
    city: "Cincinnati",
    display_title: "Cincinnati, OH",
    region: "Midwest",
    
  },
  {
    city: "Columbus",
    display_title: "Columbus, OH",
    region: "Midwest",
    
  },
  {
    city: "Detroit",
    display_title: "Detroit, MI",
    region: "Midwest",
    
  },
  {
    city: "Indianapolis",
    display_title: "Indianapolis, IN",
    region: "Midwest",
    
  },
  {
    city: "Kansas City",
    display_title: "Kansas City, MO",
    region: "Midwest",
    
  },
  {
    city: "Louisville",
    display_title: "Louisville, KY",
    region: "Midwest",
    
  },
  {
    city: "Milwaukee",
    display_title: "Milwaukee, WI",
    region: "Midwest",
    
  },
  {
    city: "Minneapolis",
    display_title: "Minneapolis, MN",
    region: "Midwest",
    
  },
  {
    city: "Omaha",
    display_title: "Omaha, NE",
    region: "Midwest",
    
  },
  {
    city: "St Louis",
    display_title: "St. Louis, MO",
    region: "Midwest",
    
  },
  {
    city: "Wichita",
    display_title: "Wichita, KS",
    region: "Midwest",
    
  },
  {
    city: "Baltimore",
    display_title: "Baltimore, MD",
    region: "Northeast",
    
  },
  {
    city: "Boston",
    display_title: "Boston, MA",
    region: "Northeast",
    
  },
  {
    city: "New York",
    display_title: "New York, NY",
    region: "Northeast",
    
  },
  {
    city: "Philadelphia",
    display_title: "Philadelphia, PA",
    region: "Northeast",
    
  },
  {
    city: "Pittsburgh",
    display_title: "Pittsburgh, PA",
    region: "Northeast",
    
  },
  {
    city: "Washington DC",
    display_title: "Washington DC",
    region: "Northeast",
    
  },
  {
    city: "Bakersfield",
    display_title: "Bakersfield, CA",
    region: "Pacific",
    
  },
  {
    city: "Fresno",
    display_title: "Fresno, CA",
    region: "Pacific",
    
  },
  {
    city: "Honolulu",
    display_title: "Honolulu, HI",
    region: "Pacific",
    
  },
  {
    city: "Los Angeles",
    display_title: "Los Angeles, CA",
    region: "Pacific",
    
  },
  {
    city: "Oakland",
    display_title: "Oakland, CA",
    region: "Pacific",
    
  },
  {
    city: "Portland",
    display_title: "Portland, OR",
    region: "Pacific",
    
  },
  {
    city: "Sacramento",
    display_title: "Sacramento, CA",
    region: "Pacific",
    
  },
  {
    city: "San Diego",
    display_title: "San Diego, CA",
    region: "Pacific",
    
  },
  {
    city: "San Francisco",
    display_title: "San Francisco, CA",
    region: "Pacific",
    
  },
  {
    city: "San Jose",
    display_title: "San Jose, CA",
    region: "Pacific",
    
  },
  {
    city: "Seattle",
    display_title: "Seattle, WA",
    region: "Pacific",
    
  },
  {
    city: "Atlanta",
    display_title: "Atlanta, GA",
    region: "Southeast",
    
  },
  {
    city: "Charlotte",
    display_title: "Charlotte, NC",
    region: "Southeast",
    
  },
  {
    city: "Jacksonville",
    display_title: "Jacksonville, FL",
    region: "Southeast",
    
  },
  {
    city: "Memphis",
    display_title: "Memphis, TN",
    region: "Southeast",
    
  },
  {
    city: "Miami",
    display_title: "Miami, FL",
    region: "Southeast",
    
  },
  {
    city: "Nashville",
    display_title: "Nashville, TN",
    region: "Southeast",
    
  },
  {
    city: "New Orleans",
    display_title: "New Orleans, LA",
    region: "Southeast",
    
  },
  {
    city: "Raleigh",
    display_title: "Raleigh, NC",
    region: "Southeast",
    
  },
  {
    city: "Tampa",
    display_title: "Tampa, FL",
    region: "Southeast",
    
  },
  {
    city: "Albuquerque",
    display_title: "Albuquerque, NM",
    region: "Southwest",
    
  },
  {
    city: "Austin",
    display_title: "Austin, TX",
    region: "Southwest",
    
  },
  {
    city: "Colorado Springs",
    display_title: "Colorado Springs, CO",
    region: "Southwest",
    
  },
  {
    city: "Denver",
    display_title: "Denver, CO",
    region: "Southwest",
    
  },
  {
    city: "El Paso",
    display_title: "El Paso, TX",
    region: "Southwest",
    
  },
  {
    city: "Fort Worth",
    display_title: "Fort Worth, TX",
    region: "Southwest",
    
  },
  {
    city: "Houston",
    display_title: "Houston, TX",
    region: "Southwest",
    
  },
  {
    city: "Las Vegas",
    display_title: "Las Vegas, NV",
    region: "Southwest",
    
  },
  {
    city: "Phoenix",
    display_title: "Phoenix, AZ",
    region: "Southwest",
    
  },
  {
    city: "Salt Lake City",
    display_title: "Salt Lake City, UT",
    region: "Southwest",
    
  },
  {
    city: "San Antonio",
    display_title: "San Antonio, TX",
    region: "Southwest",
    
  },
  {
    city: "Tucson",
    display_title: "Tucson, AZ",
    region: "Southwest",
    
  },
  {
    city: "Tulsa",
    display_title: "Tulsa, OK",
    region: "Southwest",
    
  }
];

export const selectedCities = writable([
  "Montréal, QC", "Toronto, ON", "Chicago, IL",
  "Detroit, MI", "Baltimore, MD", "New York, NY",
  "Los Angeles, CA", "San Francisco, CA", "Atlanta, GA",
  "Miami, FL", "Austin, TX", "Las Vegas, NV"]);




