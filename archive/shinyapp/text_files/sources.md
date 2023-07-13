### Geographic data:

#### United States:
[2018 ZCTA cartographic boundary shapefile, US Census Bureau](https://www2.census.gov/geo/tiger/GENZ2018/shp/cb_2018_us_zcta510_500k.zip)

#### Canada:
[2016 Census dissemination area shapefile, Statcan](https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-eng.cfm)

### Demographic and socioeconomic data:

#### United States
[American Community Survey 5-Year estimates 2015 - 2019, US Census Bureau](https://www.census.gov/data/developers/data-sets/acs-5year.2019.html)

[ZIP Code Business Patterns, US Census Bureau](https://www.census.gov/data/developers/data-sets/cbp-nonemp-zbp/cbp-api.2019.html)

[LEHD Origin-Destination Employment Statistics, US Census Bureau](https://lehd.ces.census.gov/data/lodes/)

#### Canada
[2016 Census of Population, Statcan](https://www12.statcan.gc.ca/census-recensement/2016/dp-pd/dt-td/index-eng.cfm)


### Mobile device count:
>[SafeGraph](https://www.safegraph.com/), a data company that aggregates anonymized location data from numerous applications in order to provide insights about physical places, via the SafeGraph Community. To enhance privacy, SafeGraph excludes census block group information if fewer than five devices visited an establishment in a month from a given census block group.

Datasets used:

[Places](https://docs.safegraph.com/docs/core-places)

[Patterns](https://docs.safegraph.com/docs/monthly-patterns)

## Note: the following datasets are to be used in the future, but are not included in the current version of the app
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
