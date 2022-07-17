# PURPOSE: Function to compile pitcher time period difference report



source("R/fg-pitcher-stats-func.R")

pitcher_diff <- function(startdate1 = "2021-01-01", enddate1 = "2021-12-31", startdate2 = "2022-01-01", enddate2 = "2022-12-31", qual1 = "y", qual2 = "y"){
  
  # Function to subtract the 2 date ranges
  minus <- function(x) sum(x[1],na.rm=T) - sum(x[2],na.rm=T)
  
  # Two chunks of the season
  first_chunk <- fg_pitcher_stats(startdate1, enddate1, qual = qual1)
  second_chunk <- fg_pitcher_stats(startdate2, enddate2, qual = qual2)
  
  # Combining 2 time periods
  all_qual <- bind_rows(second_chunk, first_chunk)
  
  # Grouping by player, calculating differnce
  season_diff <- all_qual %>%
    select(-`#`) %>%
    group_by(Name, Team) %>% 
    summarize_at(vars(-group_cols(), -start_date, -end_date), minus) %>%
    ungroup()
  
  
  # Getting rid of players who didn't show up in both
  player_quals <- all_qual %>%
    count(Name, Team)
  
  season_diff <- season_diff %>%
    mutate(qual_periods = player_quals$n) %>%
    filter(qual_periods == 2) %>% 
    select(-qual_periods)
  
  return(season_diff)
}
