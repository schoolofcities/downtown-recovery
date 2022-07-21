#### Recovery Patterns

This chart displays a rolling weekly average of the selected metric. The mobile device count for a given week during the pandemic is divided by the mobile device count for the corresponding week pre-pandemic. Safegraph reports weekly data every Monday. Each reporting date is converted to the [ISO week number](https://en.wikipedia.org/wiki/ISO_week_date) that it belongs to. Weeks are considered to correspond with one another if their ISO week number matches.

#### Select cities 
Select which cities to include in the plot. They are sorted by total population and a random selection of the top 20 largest cities are chosen by default.

#### Select Metric
Recovery Quotient (RQ) Downtown: divides the sum of downtown area's device counts of the week by the corresponding week in 2019

Recovery Quotient (RQ) City: divides the sum of the entire city's device counts of the week by the corresponding week in 2019.

Location Quotient (LQ): A ratio of the previous two metrics; this is a measures by how much more or less the device counts in a downtown area changed relative to how much it changed in the entire city.

#### Weekly rolling average window

A window to average the weekly observations. The short term fluctuations between weeks can obscure long term trends. 

#### Limitations

The option to select all cities does exist, but should be used with caution as the resulting plot will very likely be incomprehensible. The plot was generated using the ggrepel library, which attempts to 'smartly' repel text on a plot from other text to make for better readability. In some cases, this can cause the final labels on the plots to end up far from where the actual line on the plot ends, particularly when too many cities end with the same weekly metric.

For the sake of color coherence, 7 cities is a good upper limit. 

#### Relevant libraries

dplyr, tidyverse, ggplot, ggrepel
[Back to top](#)
