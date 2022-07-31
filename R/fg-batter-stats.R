# PURPOSE: Scrape Fangraphs Hitter Data in certain time frame


# Load in data/library ----------------------------------------------------

library(rvest)
library(lubridate)
library(tidyverse)



https://www.fangraphs.com/leaders.aspx?pos=all&stats=pit&lg=all&qual=y&type=1&season=2022&month=0&season1=2022&ind=0&team=0&rost=0&age=0&filter=&players=0&startdate=2022-01-01&enddate=2022-12-31


https://www.fangraphs.com/leaders.aspx?pos=all&stats=pit&lg=all&qual=y&type=1&season=2022&month=1000&season1=2022&ind=0&team=0&rost=0&age=0&filter=&players=0&startdate=2022-06-01&enddate=2022-07-10

qual <- 30
startdate <- "2022-06-06"
enddate <- "2022-06-25"

fg_batter_stats <- function(startdate = "2022-01-01", enddate = "2022-12-31", qual = "y"){
  
  startdate <- as.Date(startdate)
  enddate <- as.Date(enddate)
  
  # Grab fg URL
  url <- paste0("https://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=",
                qual,
                "&type=c,6,34,35,36,308,311,-1,23,37,38,39,-1,40,60,41,-1,201,205,200,-1,52,51,50,61,-1,12,7,14,11,13,21&season=2022&month=1000&season1=2022&ind=0&team=0&rost=0&age=0&filter=&players=0&startdate=",
                startdate, 
                "&enddate=",
                enddate,
                "&page=1_100000")
  
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
    mutate_at(vars(-Name, -Team),
              list(as.character)) %>%
    mutate_at(vars(-Name, -Team),
              list(parse_number)) %>%
    mutate(start_date = as.Date(startdate),
           end_date = as.Date(enddate))
  
    
  return(fg_data)
}

p4 <- fg_batter_stats("2022-06-06", "2022-06-25", qual = 10)
p5 <- fg_batter_stats("2022-06-26", "2022-07-15", qual = 10)


# Function to subtract the 2 date ranges
minus <- function(x) sum(x[1],na.rm=T) - sum(x[2],na.rm=T)

# Combining the 2 chunks, calculating differences (second chunk - first_chunk)
period4_5_diff <- bind_rows(p5, p4) %>% 
  select(-`#`) %>%
  group_by(Name, Team) %>% 
  summarize_at(vars(-group_cols(), -start_date, -end_date), minus) %>%
  ungroup()

# Get rid of players who didn't qualify for both periods
qual_players <- bind_rows(p5, p4) %>% 
  select(-`#`) %>%
  group_by(Name, Team) %>% 
  summarize(n = n())

period4_5_diff <- period4_5_diff %>% 
  mutate(qual_periods = qual_players$n) %>%
  filter(qual_periods == 2)


# Order by descending barrel rate
period4_5_diff <- period4_5_diff %>%
  arrange(-`Barrel%`)

players <- c("Ty France", "Luke Voit", "Nico Hoerner", "Josh Donaldson", "Wilmer Flores", "Joey Votto", "Christian Yelich")

# WRITE CSV
write_csv(period4_5_diff, "data/p4-5-diff.csv")


