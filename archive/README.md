# Status
* 2023/01/03: Mirroring to School of Cities GitHub page
* 2022/08/04: Everything has been rewritten in HTML and Javascript. Aside from any absolutely essential changes, the website is more or less complete. Any further developments would be the content of a text container, a minor change in functionality, or new tab altogether. The existing tabs are pretty much in their final form.
* 2022/07/21: 'version 1' is beginning. All data preprocessing has been moved to databricks. The goal is to pare down [the website](https://www.downtownrecovery.com) to something that does not depend so much on Shiny's servers to function. The website will likely be some middle ground between the original 'only widgets, pure HTML' setup and 'all Shiny' from version 0. 
* 2022/06/13: 'version 0' is done. Now moving on to version 1: will have the single city dashboard tab and update temporal filters to be by month / 3 month window instead of the 6 month window. The concept of Period 1/2/3/4 is now irrelevant.
* 2022/05/06: Each tab in the navbar now has an additional 'about' tab as well as brief explanations above each input. The contents of each about tab is an overview of what this is supposed to convey, then detailed explanations of each input button in the order that they appear, a section on limitations, and finally which R libraries are prominently used. 
* 2022/05/04: The entire layout of the page is entirely shiny, index.html exists for github pages to be able to display the app. the sluggishness has been fixed, now the action buttons and tabs allow navigation at the same speed. the methods and sources tabs have been filled in, references to featured cities have been removed now that all information is readily available. i might break up the methods tab to about/how to use this page subtabs within each page in the navbar, because the brief description in the cards can give the user an idea of what's to come, but navigating the page and knowing what this means or what can be understood or compared from the plots is not abundantly clear. 
* 2022/05/03: The HTML from previous version has been fully incorporated into a home tab in the shinyapp. The page is essentially an index.html embedding the entire shinyapp in one very large iframe nestled in a shell of the former homepage. The action buttons on the cards link to the separate tabs, although personally I find navigation to be a bit snappier just using the navbar. I will look into whether it's possible to have the action buttons in the cards have the same behavior. Everything is more or less fully functional, data is up to date, but cosmetic/design choices and performance re: card to navbar have some room for improvement. The TODO will be updated in detail by order of what's most important with what's left. 
* 2022/05/01: Widgets fit, single city maps corrected to be rate of recovery for each individual zip code/DA, some scripts updated, links to methods and sources updated to actually be html rather than raw markdown
* 2022/04/28: Simplified cards homepage, added method and sources as markdowns (which need to be fixed lol), updated links to subdomains, widget containers went from overly huge to extremely tiny.
* 2022/04/27: A github pages has been deployed. All panels aside from the policy brief link to some kind of content. the vast majority of the text is placeholder.
* 2022/04/26: Extremely under construction. Very little, if any of the scripts are ready to be sourced as they are. They will require major edits to path names, careful running line by line, and other obnoxious/tedious/tiptoeing around a minefield of error messages to get any use out of them. 
![its a mess](delete_when_ready.png)

# TODO
* ~~Update this entire page to reflect final, simplified version of website that accompanies the policy brief and mentions future plans, and nothing more, nothing less.~~
* ~~Change text in pop-up boxes of national comparative map to a time series? If not, some change here might be warranted to better convey a city's change over time rather than increasing lines of text~~
* ~~Implement automation in pulling data from safegraph/databricks/wherever the new mobility data ends up going.~~
* ~~Update 'Raw device counts' tab to have a slideshow of Kepler images for the cities in which they are available~~
* ~~Select which explanatory variables / city-specific data is suitable for the single city dashboard page. It might make most sense to use the explanatory variables from the multinomial logistic model / time series regression / etc to start with, then add one or two others that might be interesting but ultimately not significant enough to use in the model?~~ 
* ~~Select the method to best display the data: tables? charts? map? text? popup?~~
* ~~Clean up *entire pipeline* to be useable for someone other than myself~~
* ~~Clean up R scripts to be useable for someone other than myself (they can run on a separate machine by only pulling whats in the repo, but the caveat is it was my laptop)~~
* ~~Add single city dashboard tab~~
* ~~Rework site to display information by month rather than by period 1/2/3/4~~
* ~~Any further cosmetic changes or additions as requested. The inner workings/functionality of the page are essentially complete as of 2022/05/04~~
* ~~Complete Methods/Sources tabs; fill in with info from policy brief and slides. The idea of the cards is to get someone without any context of what this is to be able to interact with the default values in the shiny tabs.~~
* ~~Embed working examples of widgets in website~~
* ~~Format website to be suitable for human eyes~~

# File structure and organization
* docs: The idea is to have everything unrelated to the Shiny app in here and be strictly anything front end-- the index.html file, Javascript files, dashboards in HTML, maintenance.html, and image folder are in here. Most of the other folders are essentially relics from when this was an effort to piece together disparate html widget outputs from R into one site.
* shinyapp: the folder where everything the Shiny app needs to run lives in. The idea is for you to be able to clone this repo, run app.R in RStudio, and so long as you have the necessary libraries installed, you should be able to see the Shiny app locally.

# Table schema
* all_city_index.csv: table consisting of `postal_code`, `city`, `is_downtown` (a true/false flag), and `country`. 
contactenated togther into one master table of purely dependent variables for each season, for each type of recovery.
* all_weekly_metrics.csv: a table consisting of `city`, `metric`, `date_range_start`, `region`, and `normalized_visits_by_total_visits`. This is a longform version of the 3 tables `downtown_rec_df_0407`, `metro_rec_df_0407`, and `relative_rec_df_0407`, from databricks pivoted and concatenated together. The convention of Year.week_num column names in databricks has been changed to a parse-able Date format in R to allow for plotting a time series of the weekly recovery patterns for each city. This table is used in the 'Recovery Patterns' tab. 
* all_seasonal_metrics.csv: a table consisting of `city`, `metric`, `date_range_start`, `region`, `period`, and `season_X`. This is a longform version of the 3 tables `downtown_rec_df_0407`, `metro_rec_df_0407`, and `relative_rec_df_0407`, from databricks averaged by season to calculate the recovery metric for each different type. In other words, it is all_weekly_metrics.csv pivoted by `city`, `metric`, then assigned a `season` based on the window in which `date_range_start` falls, then averaged by `season`. This table is used in the 'Recovery Rankings', 'Explanatory Variables', and 'Comparative Map' tabs.
* explanatory_vars.csv: a table consisting of `city`, `region`, `display_title`, and all explanatory variables from the ACS (downtown AND city specific), LEHD (only downtown), and Oxford government response datasets.
* all_city_coords.csv: a table consisting of lat/lon coordinates for all cities in the study for the sake of plotting them on the national map. 

# Debugging Shiny apps:

From the docs themselves: 
> Debugging Shiny applications can be challenging. Because Shiny is reactive, code execution isn’t as linear as you might be used to, and your application code runs behind a web server and the Shiny framework itself, which can make it harder to access.

## Workflow for adding new features

Generally, I have found it easier to write functions that anticipate whatever UI input elements you would like to allow and test it in a separate script to get it working before trying it in a Shiny session, simply because it *is* such a pain to debug. It was easier (for me) to be able to separate debugging issues, especially when error messages can be very vague. Before the function even exists in Shiny, I want to know how it's working, that I'm getting the expected output, and what its problems may be by being able to freely step through it in another script and fix any R syntax/library issues/general presentation problems in a quick, simple, isolated function. When that is working well, then it is added to the Shiny app as a reactive function to first filter the data by the user input, then feed that into whatever output$function_name you're working on. The final cosmetic/useability/etc are debugged in the Shiny app, because generally the labels/titles/popups/hovers/etc that will be printed must be able to change with user input. 

Breakpoints usually work if you place them inside of an output$function_name or if they're in a reactive function. 

Some generally useful articles are: 

![Shiny app development walkthrough](https://shiny.rstudio.com/articles/)

![leaflet - Shiny interaction](http://rstudio.github.io/leaflet/shiny.html#inputsevents)

![ggplot - Shiny interaction](https://mastering-shiny.org/action-graphics.html)

![github of the original reference app](https://github.com/eparker12/nCoV_tracker)


