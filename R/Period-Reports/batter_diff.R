# PURPOSE: Function to compile batter time period difference report 

source("R/fg-batter-stats-func.R")

batter_diff <- function(startdate1 = "2021-01-01", enddate1 = "2021-12-31", startdate2 = "2022-01-01", enddate2 = "2022-12-31", qual1 = "y", qual2 = "y"){
  
  # Function to subtract the 2 date ranges
  minus <- function(x) sum(x[1],na.rm=T) - sum(x[2],na.rm=T)
  
  first_chunk <- fg_batter_stats(startdate1, enddate1, qual = qual1)
  second_chunk <- fg_batter_stats(startdate2, enddate2, qual = qual2)
  
  # Combining the 2 chunks, calculating differences (second chunk - first_chunk)
  all_qual <- bind_rows(second_chunk, first_chunk) 

  
  season_diff <- all_qual %>%
    select(-`#`) %>%
    group_by(Name, Team) %>% 
    summarize_at(vars(-group_cols(), -start_date, -end_date), minus) %>%
    ungroup()
  
  # Adding PA numbers for both time periods for easier comparison
  season_diff <- season_diff %>%
    left_join(select(first_chunk, Name, Team, PA), 
              by = c("Name", "Team")) %>%
    left_join(select(second_chunk, Name, Team, PA),
              by = c("Name", "Team")) %>%
    rename(PA_Diff = "PA.x",
           PA1 = "PA.y",
           PA2 = "PA") %>%
    select(1:3, 29:30, 4:28)
  
  # Getting rid of players who didn't show up in both
  player_quals <- all_qual %>%
    count(Name, Team)
  
  season_diff <- season_diff %>%
    mutate(qual_periods = player_quals$n) %>%
    filter(qual_periods == 2) %>% 
    select(-qual_periods)
  
  return(season_diff)
  
}


