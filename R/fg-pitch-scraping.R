#PURPOSE: Calculate / create K%-BB% table for Termi use



# Load in data/library ----------------------------------------------------

library(baseballr)
library(rvest)
library(lubridate)
library(tidyverse)


# Using baseballr

# Doesn't work for date range

mlb_stats(stat_type = 'season', stat_group = "pitching", season = 2022, player_pool = "All", position = "P") %>% 
  mutate(innings_pitched = parse_number(innings_pitched)) %>%
  filter(innings_pitched > 20) %>%
  select(69:72, 1:68, 73:87) %>%
  mutate(k_rate = strike_outs / batters_faced, 
         bb_rate = base_on_balls / batters_faced,
         k_bb_rate = k_rate - bb_rate) %>% 
  select(88:90, 1:87) %>%
  arrange(-k_bb_rate)



# USing rvest and html web scraping

https://www.fangraphs.com/leaders.aspx?pos=all&stats=pit&lg=all&qual=y&type=1&season=2022&month=0&season1=2022&ind=0&team=0&rost=0&age=0&filter=&players=0&startdate=2022-01-01&enddate=2022-12-31


https://www.fangraphs.com/leaders.aspx?pos=all&stats=pit&lg=all&qual=y&type=1&season=2022&month=1000&season1=2022&ind=0&team=0&rost=0&age=0&filter=&players=0&startdate=2022-06-01&enddate=2022-07-10



url <- read_html("https://www.fangraphs.com/leaders.aspx?pos=all&stats=pit&lg=all&qual=y&type=1&season=2022&month=1000&season1=2022&ind=0&team=0&rost=0&age=0&filter=&players=0&startdate=2022-05-04&enddate=2022-07-20&sort=9,d&page=1_10000")

url %>%
  # html() %>%
  html_nodes(xpath = '//*[@id="LeaderBoard1_dg1_ctl00"]') %>%
  html_table()

//*[@id="LeaderBoard1_dg1_ctl00"]


# Scraping fangraphs table body

fg_data <- (url %>%
              html_nodes(xpath = '//*[@id="LeaderBoard1_dg1_ctl00"]/tbody') %>%
              html_table())[[1]]


# Trying to scrape column names

fg_colnames <-
  ((url %>%
      html_nodes(xpath = '//*[@id="LeaderBoard1_dg1_ctl00"]/thead') %>%
      html_table())[[1]] %>%
     slice(2))[1,]

# Trying to combine
colnames(fg_data) <- str_trim(fg_colnames)

fg_data %>% view()

colnames(fg_data)

startdate <- "2022-06-26"
enddate <- Sys.Date() - 1
qual = 5



fg_pitcher_stats <- function(startdate = "2022-01-01", enddate = "2022-12-31", qual = "y"){
  
  # Grab fg URL
  url <- paste0("https://www.fangraphs.com/leaders.aspx?pos=all&stats=pit&lg=all&qual=",
                qual,
                "&type=c,13,4,24,11,6,42,-1,120,121,217,-1,36,37,38,40,-1,41,43,44,-1,14,322,323,325,328,-1,117,118,119,-1,45,124,-1,62,122&season=2022&month=1000&season1=2022&ind=0&team=0&rost=0&age=0&filter=&players=0&startdate=",
                start_date, 
                "&enddate=",
                end_date,
                "&sort=11,d&page=1_100000")
  
  wp <- read_html(url)
  
  # Grab data from webpage, convert to table
  fg_data <- 
    (wp %>%
       html_nodes(xpath = '//*[@id="LeaderBoard1_dg1_ctl00"]/tbody') %>%
       html_table())[[1]]
  
  # Grab and assign appropriate column names
  fg_colnames <-
    ((wp %>%
        html_nodes(xpath = '//*[@id="LeaderBoard1_dg1_ctl00"]/thead') %>%
        html_table())[[1]] %>%
       slice(2))[1,]
  
  colnames(fg_data) <- str_trim(fg_colnames)
  
  # Parse numbers as appropriate
  fg_data <- fg_data %>%
    mutate(across(-c("Name", "Team"), as.character)) %>%
    mutate(across(-c("Name", "Team"), parse_number)) %>% 
    mutate(start_date = as.Date(startdate),
           end_date = as.Date(enddate))
  
  return(fg_data)
}

# Function to subtract the 2 date ranges
minus <- function(x) sum(x[1],na.rm=T) - sum(x[2],na.rm=T)

# Two chunks of the season
first_chunk <- test_func("2022-06-05", "2022-06-25", qual = 5)
second_chunk <- test_func("2022-06-26", Sys.Date(), qual = 5)

# Combining the 2 chunks, calculating differences (second chunk - first_chunk)
season_diff <- bind_rows(second_chunk, first_chunk) %>% 
  select(-`#`) %>%
  group_by(Name, Team) %>% 
  summarize_at(vars(-group_cols(), -start_date, -end_date), minus) %>%
  ungroup()

player_quals <- bind_rows(second_chunk, first_chunk) %>%
  count(Name, Team)

season_diff <- season_diff %>%
  mutate(qual_periods = player_quals$n) %>%
  filter(qual_periods == 2)

players <- c("Tanner Scott", "Brett Martin", "Reid Detmers", "Nick Lodolo", "Patrick Sandoval")

write_csv(season_diff, "data/p4-5-pitcher-diff.csv")


