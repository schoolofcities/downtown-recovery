#### Recovery Rankings
Displays a ranked bar chart wth city names and metrics superimposed on the bars. The bars are filled according to which region they belong to (Canada, US Midwest, US Northeast, US Pacific, US Southeast, US Southwest) and the text is colored according to city size. The text on the bars is as follows: 

City ranking : City name : Value

A value greater than 1.0 means that for the selected inputs, the mobile device activity improved from the comparison period. A value less than 1.0 means the opposite, and a value equal to 1.0 means the activity did not change. 
#### City size
Since all cities in the study were included because they were the largest cities in Canada and the United States, 'large' in this case refers to the largest 20 cities in the study. All other cities are considered 'medium'. 

#### Select Metric
Recovery Quotient (RQ) Downtown: divides the sum of downtown area's device counts of the week by the corresponding week in 2019

Recovery Quotient (RQ) City: divides the sum of the entire city's device counts of the week by the corresponding week in 2019.

Location Quotient (LQ): A ratio of the previous two metrics; this is a measures by how much more or less the device counts in a downtown area changed relative to how much it changed in the entire city.

#### Select Period

Each numbered period averages the chosen metric over the specified window of time. 

Rate of recovery is the ratio of the metric in Period 4 divided by Period 1

Omicron resilience is the ratio of the average weekly metric between January 2022 - February 2022 divided by September 2021 - December 2021
#### Weekly Ranking Animation
The only option that can be changed for these animations is metric. They display the top 20 cities according to their weekly ranking for the selected metric, smoothed to a 25-week window to reduce the amount of rapid weekly ranking swaps. 
#### Limitations
Take caution when ranking more than 25 cities at a time. The bars have been filled and accented with readability in mind and the text will resize as more cities are added, but after a certain point it will be difficult to read. 
#### Relevant libraries
ggplot2, dplyr, tidyverse

[Back to top](#)
