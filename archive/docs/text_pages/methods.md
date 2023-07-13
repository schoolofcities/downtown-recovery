# Methodology

#### POI

Point of Interest. From Safegraph: 

> A point of interest is a specific physical location which someone may find interesting. Restaurants, retail stores, and grocery stores are all examples of points of interest.

### Observation

In the United States, the smallest unit of observation in this study is the ZCTA. For Canada, it is a census dissemination area.

### Downtown

The set of observations in a city with the greatest employment density.

### Recovery

Measures the number of raw POI visits (scaled by state sampling rate) in post-COVID period vs pre-COVID period per geography.

### RQ

Recovery Quotient:

$$ RQ_{2021} = \frac{\text{Downtown POI visits in 2021}}{\text{Downtown POI visits in 2019}} $$

### Polycentricity

Measures the proportion of POI visits in downtown vs. the rest of the city in post-COVID period vs. pre-COVID period.

### LQ

Location Quotient:

$$ LQ_{2021} = \frac{\frac{\text{Downtown POI visits in 2021}}{\text{Entire City POI visits in 2021}}}{\frac{\text{Downtown POI visits in 2019}}{\text{Entire City POI visits in 2019}}} $$


#### What is an observation?

In the United States, the smallest unit of observation in this study is the ZCTA. For Canada, it is a census dissemination area.

#### Definition of downtown

Observations with the greatest employment density. 

#### Time periods

##### Period 1:

March 2020 - August 2020

##### Period 2:

September 2020 - February 2021

##### Period 3: 

March 2021 - August 2021

##### Period 4:

September 2021 - February 2022

#### Compound Metrics:

##### Rate of Recovery:

$$ \frac{RQ_{\text{period 4}}}{RQ_{\text{period 1}}} $$

##### Omicron Resilience:

$$ \frac{RQ_{\text{Jan-Feb 2022}}}{RQ_{\text{Sep - Dec 2021}}}$$

#### Comparative Map
Displays 2D maps of all metrics and all periods for all cities at the national level. Only the average weekly metric over Period 4 is available at the city level. A value greater than 1 indicates an increase in activity from the comparison period. A value less than 1 indicates the opposite. A value equal to 1 means the activity level has not changed between the two periods.
#### All cities map
This map has 12 viewable layers. 

The purpose of this map is to provide an overview of all metrics over all periods for all cities in the study. 

#### Select Metric
Recovery Quotient (RQ) Downtown: divides the sum of downtown area's device counts of the week by the corresponding week in 2019

Recovery Quotient (RQ) City: divides the sum of the entire city's device counts of the week by the corresponding week in 2019.

Location Quotient (LQ): A ratio of the previous two metrics; this measures by how much more or less the device counts in a downtown area changed relative to how much it changed in the entire city.

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

#### Explanatory Variables

Plots the relationship of a selected *downtown* socioeconomic factor and selected recovery metric. This plot takes *all* cities into consideration, but a select few can be highlight for comparison's sake. You can click on any point in the plot to see the exact value of the selected independent and dependent variables, rounded to two decimal points. The points are colored according to region.

#### Select Metric

Recovery Quotient (RQ) Downtown: Compares the activity in downtowns between post-COVID period and pre-COVID period.

Recovery Quotient (RQ) City: Compares the activity in the entire city between post-COVID period and pre-COVID period.

Location Quotient (LQ): Measures the proportion of activity in downtown areas vs. the rest of the city between post-COVID period and pre-COVID period.

#### Select independent variable

These represent socioeconomic factors in the *downtown* areas of each city. 

#### Select dependent variable
The dependent variable is the period, rate of recovery, and omicron resilience. It is renamed to 'dependent variable' in this plot to signify that the change in this value is what we want to learn more about using the independent variables.

Each numbered period averages the chosen metric over the specified window of time. 

Rate of recovery is the ratio of the metric in Period 4 divided by Period 1

Omicron resilience is the ratio of the average weekly metric between January 2022 - February 2022 divided by September 2021 - December 2021

#### City

Highlights cities on the plot. Changing this does not change the trendline or coefficients as the line is fitted to all observations no matter what. This option is solely to make it easier to identify cities of interest. Cities are colored according to their region.

#### Plot

The horizontal axis will be in units of the independent variable; the vertical axis will be in units of the dependent variable. 

#### Line by line explanation of the printout:

The default values will be used here as an example, but changes to metric, independent variable, and dependent variable will result in different numbers, although the interpretation of the output remains the same.

```
Call:
lm(formula = "y~x", data = plot_df)
```

This means that a linear model is being fit to the selected independent and dependent variables for a given metric. 

```
Residuals:
     Min       1Q   Median       3Q      Max 
-0.22071 -0.12082 -0.00304  0.08707  0.45152 
```

The *residuals* of a linear regression measures how far off each prediction is from the true value. Each residual is calculated by subtracting the the predicted value of the dependent variable from the actual value of the dependent variable for each observation. 

```
Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.614312   0.030569  20.096  < 2e-16 ***
x           -0.019193   0.006254  -3.069  0.00322 ** 
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

The coefficients represent the value you would have to multiply the independent variable by in order to have the prediction come as close to possible to the true dependent variable, for *all* observations. 

The estimate for the intercept is the predicted value of the dependent variable when only taking into consideration the average of the independent variables for all observations. 

The estimate for x describes the relationship between the change in independent variable and the effect it has on the predicted value of the dependent variable. In this case, the coefficient indicates that for each one unit increase in the independent variable corresponds to a decrease of .019193 in the independent variable. In the specific case of the default example, for each 1% increase in the percent of jobs in information in a city's downtown, the recovery quotient in period 4 decreases by .019193. 

The standard error is a measure of the average amount that the coefficient estimates vary from the actual average of the dependent variable. In the event the model was run over and over, the estimate would vary by the standard error.

The t value is the value of the t-statistic to be used when testing whether the coefficient estimate is different from zero. The assumption of regression is that the coefficient estimates will all be zero  and any relationship between independent variables and dependent variable is strictly due to random chance. A zero coefficient would allow for anything to be the input, because zero multiplied by the input data would always result in zero. 

The p-value is to be used to perform the hypothesis test for which the observed t value will be tested against the null hypothesis- that the true coefficient estimate is zero and any relationship that exists is strictly due to random chance. A very low p-value suggests that it would be rare to see the result of the hypothesis test if the null hypothesis were true. A low p-value does not conclusively determine anything, but it does indicate that whatever is being observed is unlikely under the assumption that no linear relationship exists.

```
Residual standard error: 0.1436 on 60 degrees of freedom
Multiple R-squared:  0.1357,	Adjusted R-squared:  0.1213 
F-statistic: 9.417 on 1 and 60 DF,  p-value: 0.003225
```

These summary statistics describe the model as a whole rather than by each individual coefficient. 

Residual standard error describes the standard error of all residuals. It is the average amount that the true dependent variable deviates from the regression line. In this case, it means that the true downtown RQ4 deviates by .1436 from the regression line. Given that the mean RQ4 for all observations is 0.614312 (the Intercept coefficient), the percentage that any prediction would be off by *at minimum* is 23.38%. The degrees of freedom refers to the number of data points that go into estimating the coefficients, which is the total number of observations subtracted by the number of coefficients to estimate.

The multiple $R^2$ and adjusted $R^2$ are measures of how well the model fits the actual data. It describes the amount of variance in the data that the model can explain. It is a proportion, so the maximum is 1. Closer to 1 means that more variance is explained and a lower number means less of it is explained. The multiple $R^2$ will always increase as more variables are added, so the adjusted $R^2$ is more reliable in getting an accurate picture of how well the model fits the data. 

The F-statistic indicates whether there is a relationship between the independent and dependent variables. The null hypothesis assumes that there is no relationship and the F-statistic is equal to 1. Since the value necessary to reject the null hypothesis depends on the number of data points and number of predictors, the p-value that accompanies the F-statistic can be used in the hypothesis test. The p-value is the probability of the observed F-statistic existing under the null hypothesis-- the lower the p-value is, the more unlikely it is that no relationship exists between the variables. 

#### Limitations:

As with any form of modeling, this does not and will never exactly predict a downtown's activity recovery or conclusively prove any independent variable is the cause for a downtown's activity recovery. The Census response rate is never 100%. The plot and model printout can only be used to state whether or not it is more likely than not that a linear relationship exists between two variables. The p-values, no matter how low, can never truly rule out the null hypothesis in favor of the alternative. 
#### Relevant libraries
dplyr, tidyverse, ggplot2, ggrepel

[Back to top](#)

# Sources
#### Geographic data:

##### United States:
[2018 ZCTA cartographic boundary shapefile, US Census Bureau](https://www2.census.gov/geo/tiger/GENZ2018/shp/cb_2018_us_zcta510_500k.zip)

##### Canada:
[2016 Census dissemination area shapefile, Statcan](https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-eng.cfm)

#### Demographic and socioeconomic data:

##### United States
[American Community Survey 5-Year estimates 2015 - 2019, US Census Bureau](https://www.census.gov/data/developers/data-sets/acs-5year.2019.html)

[ZIP Code Business Patterns, US Census Bureau](https://www.census.gov/data/developers/data-sets/cbp-nonemp-zbp/cbp-api.2019.html)

[LEHD Origin-Destination Employment Statistics, US Census Bureau](https://lehd.ces.census.gov/data/lodes/)

##### Canada
[2016 Census of Population, Statcan](https://www12.statcan.gc.ca/census-recensement/2016/dp-pd/dt-td/index-eng.cfm)


#### Mobile device count:
>[SafeGraph](https://www.safegraph.com/), a data company that aggregates anonymized location data from numerous applications in order to provide insights about physical places, via the SafeGraph Community. To enhance privacy, SafeGraph excludes census block group information if fewer than five devices visited an establishment in a month from a given census block group.

Datasets used:

[Places](https://docs.safegraph.com/docs/core-places)

[Patterns](https://docs.safegraph.com/docs/monthly-patterns)

### Note: the following datasets are to be used in the future, but are not included in the current version of the app
### Unemployment rate
#### US cities: 
| Measure Data Type | Area Type |	Seasonality | Survey Name |
|:-----------------:|:---------:|:-----------:|:-----------:|
|unemployment rate |Cities and towns above 25,000 population|Not Seasonally Adjusted|Local Area Unemployment Statistics|
https://beta.bls.gov/dataViewer/view/7902ccef8ffe48ac998b21a4d222c377 <br>

#### Canadian CMAs: 
Statistics Canada. Table 14-10-0380-01  Labour force characteristics, three-month moving average, seasonally adjusted <br>
https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1410038001 <br>
Canadian data is seasonally unadjusted and is available by month, as 3 month moving averages. <br>


### Covid timeline
#### Canada:
https://www.cihi.ca/en/covid-19-intervention-timeline-in-canada
#### US:
https://www.cdc.gov/museum/timeline/covid19.html
#### Global:
https://covid19.trackvaccines.org/agency/who/

### Covid case count
Note: The geographic region for Covid case count data does not exactly match the geographic region used to join Safegraph data to census data, due to unavailability at the zip code level and dissemination area level for all cities. Public health agencies are included if a study city is included in the agency's publicly available data.

#### Canada
##### Vancouver (British Columbia): 
http://www.bccdc.ca/Health-Info-Site/Documents/BC_COVID-19_Disclaimer_Data_Notes.pdf <br>

##### Calgary & Edmonton (Alberta): 
https://data.edmonton.ca/Community-Services/COVID-19-in-Alberta-Cases-by-Zone/jmcu-tz8y <br>

##### London, Mississauga, Ottawa (Ontario), Toronto: 
https://www.publichealthontario.ca/en/data-and-analysis/infectious-disease/covid-19-data-surveillance/covid-19-data-tool?tab=trends <br>
Note: Mississauga is grouped with Brampton and Caledon; the data is managed by Peel Public Health Unit. <br>

#####  Montréal, Québec, Ottawa (Québec):
https://www.donneesquebec.ca/recherche/dataset/covid-19-portrait-quotidien-des-cas-confirmes <br>
Note: Québec COVID-19 case data is only available at province level. <br>

#### United States
##### San Francisco: 
###### cases 
https://data.sfgov.org/COVID-19/COVID-19-Cases-Over-Time/gyr2-k29z  <br>
###### vaccines: 
https://data.sfgov.org/COVID-19/COVID-Vaccinations-Given-to-SF-Residents-Over-Time/bqge-2y7k <br>

##### New York: 
###### cases 
https://github.com/nychealth/coronavirus-data/blob/master/trends/data-by-day.csv <br>
###### vaccines
https://raw.githubusercontent.com/nychealth/covid-vaccine-data/main/doses/doses-by-day.csv <br>

##### Dallas: 
###### cases 
https://covid-analytics-pccinnovation.hub.arcgis.com/ <br>
###### vaccines 
https://covid-analytics-pccinnovation.hub.arcgis.com/ <br>
Note: Dallas has county dashboards only, county data is available for download at CDC's website. <br>

##### Seattle: 
###### cases 
https://kingcounty.gov/depts/health/covid-19/data/summary-dashboard.aspx <br>
###### vaccines 
https://kingcounty.gov/depts/health/covid-19/data/vaccination.aspx <br>

##### Chicago:
###### cases 
https://www.chicago.gov/city/en/sites/covid-19/home/covid-dashboard.html <br>
###### vaccines 
https://www.chicago.gov/city/en/sites/covid-19/home/covid-dashboard.html <br>
Note: Chicago has covid data dashboards, but no option to download the data. <br>

##### Washington DC:
###### cases 
https://coronavirus.dc.gov/data <br>
###### vaccines
https://coronavirus.dc.gov/data <br>

##### Detroit:
###### cases 
https://codtableau.detroitmi.gov/t/DHD/views/CityofDetroit-PublicCOVIDDashboard/TimelineCasesDashboard?%3AisGuestRedirectFromVizportal=y&%3Aembed=y <br>
###### vaccines 
https://codtableau.detroitmi.gov/t/DoIT-Data-Public/views/VaccinePublicDashboard/VaccineDashboard?:origin=card_share_link&:embed=y&:isGuestRedirectFromVizportal=y <br>
Note: Detroit's tableau dashboards are visible, but data is unavailable for download. <br>

##### Los Angeles:
###### cases 
http://dashboard.publichealth.lacounty.gov/covid19_surveillance_dashboard/ <br>
###### vaccines 
http://publichealth.lacounty.gov/media/Coronavirus/vaccine/vaccine-dashboard.htm <br>
Note: Los Angeles has a warning about its data: "Please note that select data for ages 12-17 by city/community had errors prior to 7/28/2021.  The issue has been resolved but please discard any files with age 12-17 data downloaded prior to 7/28/2021.  All other age group and city/community data were not impacted by these issues."
