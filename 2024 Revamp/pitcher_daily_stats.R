
# Script to pull pitcher daily stats --------------------------------------

# https://stackoverflow.com/questions/77664560/scrape-data-from-site-using-variables-and-functions-and-bind-tables-to-one-dataf
require(baseballr)
require(tidyverse)


#### These are the 2 functions that seem most useful

# Helper function to pull player game logs
pitcher_daily_game_logs <- function(x, year = 2024, date1, date2) {
  t1 <- suppressMessages(baseballr::fg_pitcher_game_logs(x, year))
  if(nrow(t1)>0){
    t2 <- t1 %>% 
      dplyr::filter(`Date` >= date1, `Date` <= date2)
    return(t2)
  }
}

22210 


# target_date <- as.Date("2024-03-20")
# batter_game_logs_date(19755, date1 = target_date, date2 = target_date)

# Function to combine all player stats into one tibble and select relevant columns
pitcher_stats_prep <- function(playerids, date1, date2){
  
  ret_tbl<- playerids %>% 
    map_dfr(\(playerids) pitcher_daily_game_logs(playerids, year = 2024, date1, date2)) %>%
    select(playerid,
           PlayerName,
           Team,
           Date,
           IP,
           H,
           R,
           ER,
           BB,
           SO,
           HR,
           ERA,
           WHIP,
           `K-BB%`,
           `SwStr%`,
           EV,
           `Barrel%`,
           `HardHit%`,
           ) %>%
    mutate(EV = round(EV, 1),
           ERA = round(ERA,2),
           WHIP = round(WHIP,2),
           `K-BB%` = round(`K-BB%`*100,1),
           `SwStr%` = round(`SwStr%`*100,1),
           `Barrel%`= round(`Barrel%`*100,1),
           `HardHit%` = round(`HardHit%`*100,1)) %>%
    arrange(Team, -IP)
  return(ret_tbl)
}

target_date <- as.Date("2024-03-20")
pitcher_output <- pitcher_stats_prep(fg_keys, target_date, target_date)


# x <- fg_keys[1:3]
# x %>% map_dfr(\(x) pitcher_daily_game_logs(x, year = 2024, target_date))  %>% colnames()
# 
# colnames(test_list[[2]])[!(colnames(test_list[[2]])) %in% colnames(test_list[[1]])]







