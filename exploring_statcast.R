
# Purpose: Explore getting statcast data from baseballr package -----------



# Load in Data / Packages ------------------------------------------------------------

library(baseballr)
library(tidyverse)


statcast_14day <- scrape_statcast_savant_batter_all(start_date = Sys.Date() - 14, end_date = Sys.Date())

code_barrel(statcast_14day) %>%
  filter(type == "X") %>%
  filter(player_name %in% c("Donaldson, Josh", "Rojas, Josh", "Flores, Wilmer")) %>%
  group_by(player_name) %>%
  summarize(mean_velo = mean(release_speed, na.rm = TRUE),
            bb_num = n(),
            barrel_rate = mean(barrel, na.rm = TRUE)
            ) %>%
  arrange(-mean_velo) %>%
  filter(bb_num > 10) 

statcast_leaderboards(leaderboard = "pitch_arsenal", 
                      year = 2022, 
                      abs = 50,
                      arsenal_type = "avg_spin") %>% view()

code_barrel(statcast_14day) %>% view()

# 

all_pitchers_season <- mlb_stats(stat_type = 'season', stat_group = "pitching", season = 2022, player_pool = "All", position = "P") %>% 
  mutate(innings_pitched = parse_number(innings_pitched)) %>%
  filter(innings_pitched > 20) %>%
  select(69:72, 1:68, 73:87) %>%
  mutate(k_rate = strike_outs / batters_faced, 
         bb_rate = base_on_balls / batters_faced,
         k_bb_rate = k_rate - bb_rate) %>% 
  select(88:90, 1:87)


mlb_stats(stat_type = 'season', 
          stat_group = "pitching", 
          season = 2022, 
          player_pool = "Qualified", 
          position = "RP") %>% view()
  mutate(innings_pitched = parse_number(innings_pitched)) %>%
  filter(innings_pitched > 20) 

