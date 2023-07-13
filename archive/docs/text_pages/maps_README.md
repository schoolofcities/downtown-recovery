#### Comparative Map
Displays 2D maps of all metrics and all periods for all cities at the national level. Only the average weekly metric over Period 4 is available at the city level. A value greater than 1 indicates an increase in activity from the comparison period. A value less than 1 indicates the opposite. A value equal to 1 means the activity level has not changed between the two periods.
#### All cities map
This map has 12 viewable layers. 

The purpose of this map is to provide an overview of all metrics over all periods for all cities in the study. 

#### Select Metric
Recovery Quotient (RQ) Downtown: divides the sum of downtown area's device counts of the week by the corresponding week in 2019

Recovery Quotient (RQ) City: divides the sum of the entire city's device counts of the week by the corresponding week in 2019.

Location Quotient (LQ): A ratio of the previous two metrics; this is a measures by how much more or less the device counts in a downtown area changed relative to how much it changed in the entire city.

#### Select Period

Each numbered period averages the chosen metric over the specified window of time. 

Rate of recovery is the ratio of the metric in Period 4 divided by Period 1

Omicron resilience is the ratio of the average weekly metric between January 2022 - February 2022 divided by September 2021 - December 2021

#### Single city map

This map has only one layer to view.

The purpose of this map is to display information about how mobile device count activity changed from pre-pandemic levels in each ZIP code or dissemination area for Period 4.
#### Limitations
Because of the small size of census dissemination areas, the Canadian cities can take more time to load than the US cities. Most of the time this is a non-issue, although larger cities like Toronto and Montreal do have a few seconds of delay before loading in. The fill color of Canadian cities is better observed while zoomed in, since the thickness of the highlighter line can obscure some of the tinier dissemination areas.
#### Relevant libraries
dplyr, geojsonio, leaflet, sf, sp, tidyverse
[Back to top](#)
