


# map_dfr()
# x <- c(18882, 19470) 
# test_list <- x %>% map(\(x) baseballr::fg_batter_game_logs(x,year = 2023))
# require(baseballr)
# require(tidyverse)


#### These are the 2 functions that seem most useful

# Helper function to pull player game logs
# batter_daily_game_logs <- function(x, year = 2024, date1, date2) {
#   t1 <- suppressMessages(baseballr::fg_batter_game_logs(x, year))
#   if(nrow(t1)>0){
#     t2 <- t1 %>%
#       dplyr::filter(`Date` >= date1, `Date` <= date2)
#     return(t2)
#   }
# }
#baseballr::fg_batter_game_logs(29490, 2024)

# target_date <- as.Date("2024-03-20")
# batter_game_logs_date(19755, date1 = target_date, date2 = target_date)

# Function to combine all player stats into one tibble and select relevant columns
# batter_stats_prep <- function(playerids, date1, date2){

#   ret_tbl<- playerids %>%
#     map_dfr(\(playerids) batter_daily_game_logs(playerids, year = 2024, date1, date2)) %>%
#     select(playerid,
#            PlayerName,
#            Team,
#            Date,
#            BatOrder,
#            Pos,
#            AB,
#            R,
#            H,
#            RBI,
#            BB,
#            HR,
#            SB,
#            SO,
#            Events,
#            maxEV,
#            EV,
#            LA,
#            Barrels,
#            `Barrel%`,
#            maxEV,
#            HardHit) %>%
#     mutate(maxEV = round(maxEV,1),
#            EV = round(EV, 1),
#            LA = round(LA,1)) %>%
#     arrange(Team,BatOrder)
#   return(ret_tbl)
# }

# target_date <- Sys.Date() - 1
# batter_output <- batter_stats_prep(termi_hitter_keys, target_date, target_date)

#
# x <- fg_keys[1:25]
# x %>% map_dfr(\(x) batter_game_logs_date(x, year = 2023, "2023-04-10", "2023-04-10"))  %>% colnames()
#
# colnames(test_list[[2]])[!(colnames(test_list[[2]])) %in% colnames(test_list[[1]])]



season_batter_logs <- lapply(termi_batter_keys, function(player_id) {
  fg_batter_game_logs(player_id, year = 2024)  # Adjust season as needed
})

# Combine game logs into a single data frame
all_logs_batters <- do.call(rbind, c(season_batter_logs, fill = TRUE))

# Filter for yesterday's date
yesterday_date <- Sys.Date() - 1

batter_output <- all_logs_batters %>%
  as_tibble() %>%
  filter(Date == yesterday_date) %>%
  select(playerid,
         PlayerName,
         Team,
         Date,
         BatOrder,
         Pos,
         AB,
         R,
         H,
         RBI,
         BB,
         HR,
         SB,
         SO,
         Events,
         maxEV,
         EV,
         LA,
         Barrels,
         `Barrel%`,
         maxEV,
         HardHit,
         `HardHit%`) %>%
  mutate(maxEV = round(maxEV,1),
         EV = round(EV, 1),
         LA = round(LA,1),
         `Barrel%` = sprintf("%.0f%%", `Barrel%` * 100),
         `HardHit%` = sprintf("%.0f%%", `HardHit%` * 100)) %>%
  arrange(Team,BatOrder)


