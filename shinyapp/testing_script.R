library(ggplot2)
library(readxl)
library(ggpmisc)
library(dplyr)
library(stringr)
library(scales)
library(ggrepel)
library(ggpubr)
library(hrbrthemes)
library(gifski)
library(tidyverse)
library(gganimate)
library(zoo)
library(sf)
library(sp)
library(geojsonio)
library(httr)


path <- "~/git/mc-covid19-dtra/shinyapp/"
weekly_concurrent_vars <-
  read.csv(paste0(path, "input_data/weekly_concurrent_vars.csv"))
monthly_concurrent_vars <-
  read.csv(paste0(path, "input_data/monthly_concurrent_vars.csv"))
city_attributes <-
  read.csv(paste0(path, "input_data/master_factors_display.csv"))
study_das <-
  read.csv(paste0(path, "input_data/study_area_canada.csv"))
study_postal_codes <-
  read.csv(paste0(path, "input_data/study_area_us.csv"))
all_shapefile <-  st_read(paste0(path, "shp/study_area_all.shp"))
all_shapefile <-
  st_transform(all_shapefile, st_crs("+proj=longlat +datum=WGS84"))

### 2022.04.07 updated metrics appened together and pivoted to longform for time series plotting  ###
all_weekly_lqs <-
  read.csv(paste0(path, "input_data/all_weekly_lqs.csv"))
all_city_coords_lqs <-
  read.csv(paste0(path, "input_data/all_city_coords_lqs.csv"))
metrics_df <- read.csv(paste0(path, "input_data/metrics_df.csv"))
city_population <- read.csv(paste0(path, "input_data/total_population_city.csv"))

all_dc <-
  read.csv(paste0(path, "aggregates/rq4_by_postal_code.csv"))

## concurrent variables - tbd how to incorporate these bc the geographies do not match study geographies 100%
covid_cases_all <-
  read.csv(paste0(path, "input_data/covid_cases_all.csv"))
unemployment_rates_all <-
  read.csv(paste0(path, "input_data/unemployment_rates_all.csv"))

outlier_cities <-
  c("Dallas", "Mississauga", "Orlando", "Oklahoma City")
city_attributes <- city_attributes %>%
  dplyr::filter(!(city %in% outlier_cities))

model_df <- inner_join(city_attributes, metrics_df, by = c("country", "display_title", "state", "city"))
#can_shapefile <- st_read(paste(path, "shp/study_area_canada.shp", sep = ""))
#us_shapefile <- st_read(paste(path, "shp/study_area_us.shp", sep = ""))

### updated metrics - 2022.04.07 ###
#downtown_rec <- read.csv(paste(path, "input_data/downtown_rec_df_0407.csv", sep = ""))
#metro_rec <- read.csv(paste(path, "input_data/metro_rec_df_0407.csv", sep = ""))
#relative_rec <- read.csv(paste(path, "input_data/relative_rec_df_0407.csv", sep = ""))
#all_city_coords <- geojson_read(paste(path, "input_data/can_us_cities.geojson", sep = ""), what = "sp")
#all_city_coords_lqs <- read.csv(paste(path, "input_data/all_city_coords_lqs.csv", sep = ""))
all_weekly_lqs <- read.csv(paste(path, "input_data/all_weekly_lqs.csv", sep = ""))
#downtown_rec$metric <- "downtown"
#metro_rec$metric <- "metro"
#relative_rec$metric <- "relative"

# all_weekly_lqs <- rbind(downtown_rec, metro_rec, relative_rec)
# all_weekly_lqs_longer <- all_weekly_lqs %>%
#   dplyr::select(-rec_2020.53) %>%
#   dplyr::select(city, metric, starts_with("rec")) %>%
#   pivot_longer(cols = starts_with("rec"), names_to = "week", values_to = "weekly_lq")
# 
# all_weekly_lqs_longer$week <- str_pad(string = all_weekly_lqs_longer$week, width = 11, side = "right", pad = "0")
# all_weekly_lqs_longer$week <- substr(all_weekly_lqs_longer$week, 5, 11)
# all_weekly_lqs_longer$week <- as.Date(paste(all_weekly_lqs_longer$week, "1", sep = "."), "%Y.%U.%u")
# all_weekly_lqs_longer$start_label <- all_weekly_lqs_longer$week
# all_weekly_lqs_longer$end_label <- all_weekly_lqs_longer$week
# all_weekly_lqs_longer$start_label[all_weekly_lqs_longer$week != min(all_weekly_lqs_longer$week)] <- NA
# all_weekly_lqs_longer$end_label[all_weekly_lqs_longer$week != max(all_weekly_lqs_longer$week)] <- NA
#write.csv(all_weekly_lqs_longer, paste(path, "input_data/all_weekly_lqs.csv", sep = ""))

# necessary to get around the ESRI column name length limit
colnames(all_shapefile) <- c("postal_code", "geometry")
# all_weekly_lqs_longer %>%
#   group_by(city, metric) %>%
#   mutate(rolling_avg = rollmean(weekly_lq, rolling, na.pad = TRUE, align = "center")) %>%
#   ungroup()
all_weekly_lqs$week <- as.Date(all_weekly_lqs$week, format = "%m/%d/%Y")
study_weeks <- unique(all_weekly_lqs %>% dplyr::arrange(week) %>% dplyr::select(week))

all_weekly_lqs <- all_weekly_lqs %>%
  dplyr::filter(!(city %in% outlier_cities))

# top 10 can/us cities & industry
top_5_us_jobs <- model_df %>%
  dplyr::filter((country == 1) & 
                  (metric == "downtown")) %>%
  dplyr::arrange(-total_pop) %>%
  dplyr::slice_head(n = 5) %>%
  dplyr::select(starts_with("pct_job"), "city", "total_pop")

top_5_can_jobs <- model_df %>%
  dplyr::filter((country == 0) & 
                  (metric == "downtown")) %>%
  dplyr::arrange(-total_pop) %>%
  dplyr::slice_head(n = 5) %>%
  dplyr::select(starts_with("pct_job"), "city", "total_pop")

top_10_all_jobs <- rbind(top_5_can_jobs, top_5_us_jobs)


job_cols <- colnames(top_10_all_jobs %>% 
                       dplyr::select(starts_with("pct_job")))


top_jobs <- job_cols[order(apply(top_10_all_jobs %>% 
                                             dplyr::select(starts_with("pct_job")), 2, median) >= 5, decreasing = TRUE)]

job_percent_chart <- function(n_jobs = 7) {
  # default is top 7 job sectors among all downtowns
  # job sectors are sorted by whether or not the median of the industry is greater than 5 for all cities
  # this is meant to exclude the extreme outliers/industries that are only prominent in a handful of cities
  # for the sake of making the stacked bar charts easier to parse for all cities
  # the top 7 of these industries is the default because that's an easy number of colors to start with, but this can be 
  # expanded to include up to all 20 sectors, provided that you don't mind the complicated color scheme
  df <- top_10_all_jobs %>%
    dplyr::select(city, total_pop, all_of(top_jobs[1:n_jobs])) %>%
    dplyr::arrange(-total_pop) %>%
    pivot_longer(cols = starts_with("pct_job"),
                 names_to = "Category",
                 names_prefix = "pct_",
                 values_to = "percent")
  
  ggplot(df, aes(fill = Category, y = percent, x = city)) + 
    geom_bar(position = "fill", stat = "identity") + 
    coord_flip() +
    theme_modern_rc() +
    theme(axis.title.x = element_text(hjust = .5)) +
    theme(axis.title.y = element_text(vjust = .5, hjust = .5)) +
    theme(axis.text.y = element_text(hjust = .5)) +
    theme(plot.title = element_text(hjust = .5)) + 
    guides(fill = guide_legend(reverse = TRUE)) +
    ggtitle("Proportion of employment in top 10 US/Canadian downtowns")
  
}

job_percent_chart()

# reshape df to longform: city date_col recovery_val, each row is a week

recovery_df_transformer <- function(recovery_metric = "downtown", rolling_window = 25, large_city_cutoff = 26) {
  
  # df <- df %>%
  #   dplyr::select(-rec_2020.53) %>%
  #   dplyr::select(city,  starts_with("rec")) %>%
  #   pivot_longer(!city, names_to = "week", values_to = "weekly_lq") %>%
  #   dplyr::filter(city %in% cities)
  # 
  # df$week <- str_pad(string = df$week, width = 11, side = "right", pad = "0")
  # df$week <- substr(df$week, 5, 11)
  # df$week <- as.Date(paste(df$week, "1", sep = "."), "%Y.%U.%u")
  # df$start_label <- df$week
  # df$end_label <- df$week
  # df$start_label[df$week != min(df$week)] <- NA
  # df$end_label[df$week != max(df$week)] <- NA
  # df %>%
  #   group_by(city) %>%
  #   mutate(rolling_avg = rollmean(weekly_lq, rolling, na.pad = TRUE, align = "center")) %>%
  #   ungroup()
  largest_n_cities <- city_population %>%
    dplyr::arrange(-population) %>%
    mutate(pop_rank = rank(-population)) %>%
    dplyr::filter(pop_rank <= large_city_cutoff) %>%
    dplyr::select(city)
  
  city_attributes_metro_size <- city_attributes %>%
    mutate(metro_size = case_when(
      city %in% largest_n_cities$city ~ "large",
      !(city %in% largest_n_cities$city) ~ "medium")
    ) %>% 
    dplyr::select(city, display_title, region, metro_size)
  
  
  
  smoothed_weekly_lqs <- all_weekly_lqs %>%
    dplyr::filter((metric == recovery_metric)) %>%
    group_by(city) %>%
    mutate(rolling_avg = rollmean(weekly_lq, as.numeric(rolling_window), na.pad = TRUE, align = "center")) %>%
    ungroup()
  
  smoothed_weekly_lqs <- inner_join(smoothed_weekly_lqs, city_attributes_metro_size,
                                    by = "city")
  smoothed_weekly_lqs
}

ranking_df_transformer <- function(recov_metric = "downtown", period = "period_4", large_city_cutoff = 26) {
  
  largest_n_cities <- city_population %>%
    dplyr::arrange(-population) %>%
    mutate(pop_rank = rank(-population)) %>%
    dplyr::filter(pop_rank <= large_city_cutoff) %>%
    dplyr::select(city)
  
  model_df %>%
    mutate(metro_size = case_when(
      city %in% largest_n_cities$city ~ "large",
      !(city %in% largest_n_cities$city) ~ "medium")
      ) %>% 
    dplyr::filter(metric == recov_metric) %>%
    dplyr::select(display_title, region, metro_size, all_of(period), metric)
}

starting_lq_ranks <- function(df) {
  # returns the cities ranked by their lqs on the min date of the plot
  lq_ranks <- na.omit(df) %>%
    dplyr::filter(week == min(week)) %>%
    dplyr::select(city, week, rolling_avg) %>%
    dplyr::arrange(rolling_avg) %>%
    mutate(lq_rank = rank(rolling_avg, ties.method = "first"))
  
  lq_ranks <- inner_join(lq_ranks, df %>%
                           dplyr::select(city, region), by = "city")
  lq_ranks
  
}

ending_lq_ranks <- function(df) {
  # returns the cities ranked by their lqs on the max date of the plot
  lq_ranks <- na.omit(df) %>%
    dplyr::filter(week == max(week)) %>%
    dplyr::select(city, week, rolling_avg) %>%
    dplyr::arrange(rolling_avg) %>%
    mutate(lq_rank = rank(rolling_avg, ties.method = "first"))
  
  lq_ranks <- inner_join(lq_ranks, df %>%
                           dplyr::select(city, region), by = "city")
  lq_ranks
}

# function to plot recovery metric
recovery_plot <- function(df, metric, rolling_window) {
  
  starting_lqs <- starting_lq_ranks(df)
  ending_lqs <- ending_lq_ranks(df)
  total_cities <- length(unique(df$city))
  g1 <- ggplot(df) + aes(x = week, y = rolling_avg, colour = city, label = city) + geom_line(size = 1) +
    geom_text_repel(data = starting_lqs, size = 4, segment.square = TRUE, segment.inflect = TRUE, direction = "y", hjust = "right",
                    force = 500, na.rm  = TRUE,  min.segment.length = 0, segment.curvature = .1, segment.ncp = 3, segment.angle = 30, 
                    nudge_x = seq(from = -60*24*7*4*3, to = 0, length.out = total_cities),
                    #nudge_y = seq(from = max(weekly_lq), to = min(weekly_lq), length.out = total_cities)
                    ) +
    geom_text_repel(data = ending_lqs, size = 4, segment.square = TRUE, segment.inflect = TRUE, direction = "y", hjust = "left",
                    force = 500, na.rm = TRUE, min.segment.length = 0, segment.curvature = -.1, segment.ncp = 3, segment.angle = 30,
                    nudge_x = seq(from = 60*24*7*4*4, to = 0, length.out = total_cities),
                    #nudge_y = seq(from = max(weekly_lq), to = min(weekly_lq), length.out = total_cities)
                    ) +
    ylab(metric) + xlab("Week") + theme(legend.position = "none", axis.text = element_text(size = 10, angle = 45, colour = "black", vjust = 1, hjust = 1)) + 
    ggtitle(paste(metric, rolling_window, "week rolling average for selected cities")) + scale_x_date(breaks = "4 weeks", date_labels = "%Y.%m", expand = expansion(mult = .15))
  g1
}

recov_metric <- "downtown"
rolling_val <- 25
recovery_df <- recovery_df_transformer(sample(unique(all_weekly_lqs$city), 5), recov_metric, rolling_val)

starting_lqs <- starting_lq_ranks(recovery_df)
starting_lqs
ending_lqs <- ending_lq_ranks(recovery_df)
ending_lqs

# test function
recovery_plot(recovery_df, recov_metric, rolling_val)

lq_ranking <- function(df) {
  # assumes df is pre-filtered. 'top n ranking' has no meaning for weekly ranks
  df %>%
    dplyr::filter(!is.na(rolling_avg)) %>%
    dplyr::group_by(week) %>%
    dplyr::arrange(-rolling_avg) %>%
    mutate(lq_rank = rank(-rolling_avg, ties.method = "first"),
           lq_rank_rel = rolling_avg / rolling_avg[lq_rank == 1],
           lq_rank_label = paste0(" ", round(100 * rolling_avg, 2), "%")) %>%
    dplyr::group_by(city) %>%
    ungroup()
}

recov_ranking <- function(df, top_n, ranking_period) {
  df %>%
    dplyr::filter(!is.na(ranking_period)) %>%
    dplyr::group_by(metro_size) %>%
    dplyr::arrange(ranking_period) %>%
    mutate(lq_rank = rank(ranking_period, ties.method = "first")) %>%
    dplyr::filter(lq_rank <= top_n) %>%
    ungroup()
}

ranking_plot <- function(top_n_df, metric, top_n = 20) {
  largest_n_cities <- city_population %>%
    dplyr::arrange(-population) %>%
    mutate(pop_rank = rank(-population)) %>%
    dplyr::filter(pop_rank <= top_n) %>%
    dplyr::select(city)
  
  df <- lq_ranking(top_n_df %>% 
                     dplyr::filter(city %in% largest_n_cities$city))
  df$week <- as.Date(df$week, "%Y-%M-%d")
  starting_lqs <- starting_lq_ranks(df)
  ending_lqs <- ending_lq_ranks(df)
  g1 <- ggplot(df) +
    aes(x = week, y = lq_rank, group = city, color = region, label = city) +
    geom_line(size = 1) +
    geom_label_repel(
      data = starting_lqs,
      size = 5,
      direction = "y",
      hjust = "right",
      force = 1,
      na.rm  = TRUE,
      min.segment.length = 0,
      segment.curvature = 1e-20,
      segment.angle = 20,
      #nudge_x = rep(-5, times = top_n),
      show.legend = FALSE
    ) +
    geom_label_repel(
      data = ending_lqs,
      size = 5,
      direction = "y",
      hjust = "left",
      force = 1,
      na.rm = TRUE,
      min.segment.length = 0,
      segment.curvature =  1e-20,
      segment.angle = 20,
      #nudge_x = rep(5, times = top_n),
      show.legend = FALSE
    ) +
    labs(title = paste("Weekly", str_to_title(metric), "recovery rank of top", top_n, "cities" ),
         y = "Rank",
         x = "Week")+
    theme(
      #legend.position = "none",
      axis.text.x = element_text(size = 10, angle = 45, vjust = 1, hjust = 1),
      plot.title = element_text(size = 16, hjust = .5),
      plot.subtitle = element_text(size = 12, hjust = .5)
    ) +
    scale_x_date(
      breaks = "4 weeks",
      date_labels = "%Y.%m",
      expand = expansion(mult = .15)
    ) +
    scale_y_continuous(breaks = unique(df$lq_rank)) +
    scale_color_manual(values = c("Canada" = "#e41a1c",
                                  "Midwest" = "#377eb8",
                                  "Northeast" = "#4daf4a",
                                  "Pacific" = "#984ea3",
                                  "Southeast" = "#ff7f00",
                                  "Southwest" = "#e6ab02"))
  g1

    
}
ranking_df <- recovery_df_transformer(recovery_metric = recov_metric)
ranking_plot_gg <- ranking_plot(top_n_df = ranking_df, metric = recov_metric, top_n = 20)
print(ranking_plot_gg)
test_df <- recov_ranking(ranking_df, 20)

largest_n_cities <- city_population %>%
  dplyr::arrange(-population) %>%
  mutate(pop_rank = rank(-population)) %>%
  dplyr::filter(pop_rank <= top_n) %>%
  dplyr::select(city)

bar_chart_race <- function(smoothed_df, metric, rolling_window, top_n = 25) {
  
  largest_n_cities <- city_population %>%
    dplyr::arrange(-population) %>%
    mutate(pop_rank = rank(-population)) %>%
    dplyr::filter(pop_rank <= top_n) %>%
    dplyr::select(city)
  
  ranked_lqs <- lq_ranking(smoothed_df %>% 
                     dplyr::filter(city %in% largest_n_cities$city))
  ranked_lqs$week <- as.Date(ranked_lqs$week, "%Y-%M-%d")
  static_plot <- ggplot(ranked_lqs) + 
    aes(lq_rank, group = display_title, fill = region, color = region) +
    geom_tile(aes(y = rolling_avg / 2, height = rolling_avg, width = 0.75), alpha = 0.8) +
    geom_text(aes(y = 0, label = paste("", lq_rank, ":", display_title, "")), vjust = 0.2, hjust = "inward", color = "white") +
    geom_text(aes(y = rolling_avg, label = lq_rank_label, hjust=0, size = 4, fontface = "bold"), show.legend = FALSE) +
    coord_flip(clip = "off", expand = FALSE) +
    scale_y_continuous("", labels = scales::comma) +
    scale_x_reverse("") +
    #guides(color = FALSE, fill = FALSE, scale = "none") +
    theme_modern_rc() + 
    theme(panel.grid = element_blank(),
          axis.text.y = element_blank(),
          axis.text.x = element_blank(),
          axis.title = element_blank(),
          axis.title.y = element_blank(),
          axis.title.x = element_blank(),
          plot.title = element_text(size = 23),
          plot.caption = element_text(color = "white", size = 14),
          plot.subtitle = element_text(color = "white", size = 16)
          #plot.margin = unit(c(1, 1, 1, 3.5), "cm")
          ) + 
   # theme(legend.position = "none") + 

    scale_fill_manual(values = c("Canada" = "#e41a1c",
                                 "Midwest" = "#377eb8",
                                 "Northeast" = "#4daf4a",
                                 "Pacific" = "#984ea3",
                                 "Southeast" = "#ff7f00",
                                 "Southwest" = "#e6ab02")) +
    scale_color_manual(values = c("Canada" = "#e41a1c",
                                 "Midwest" = "#377eb8",
                                 "Northeast" = "#4daf4a",
                                 "Pacific" = "#984ea3",
                                 "Southeast" = "#ff7f00",
                                 "Southwest" = "#e6ab02"))
    #scale_colour_manual(values = c("large" = "#000000", 
    #                               "medium" = "#ffffff"))
  
  anim <- static_plot + transition_states(week, transition_length = 10, state_length = 1) +
    #view_follow(fixed_x = TRUE) +
    labs(title = 'Recovery metric per week : {closest_state}',
         subtitle = paste("Large cities:", metric, "recovery"))
  anim
}

top_n = 26

# test function

ranking_metric = "metro"

ranking_df <- recovery_df_transformer(recovery_metric = ranking_metric)
n_weeks <- length(unique(na.omit(ranking_df)$week))

animated_plot <- bar_chart_race(ranking_df, "city", rolling_val, top_n)
animate(animated_plot, n_weeks * 10, fps = 30, width = 720, height = 1280, renderer = gifski_renderer(paste(path, ranking_metric, ".gif", sep = "")))

