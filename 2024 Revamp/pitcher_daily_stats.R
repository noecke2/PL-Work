
# Script to pull pitcher daily stats --------------------------------------

# https://stackoverflow.com/questions/77664560/scrape-data-from-site-using-variables-and-functions-and-bind-tables-to-one-dataf
# require(baseballr)
# require(tidyverse)


#### These are the 2 functions that seem most useful

# Helper function to pull player game logs
# pitcher_daily_game_logs <- function(x, year = 2024, date1, date2) {
#   t1 <- suppressMessages(baseballr::fg_pitcher_game_logs(x, year))
#   if(nrow(t1)>0){
#     t2 <- t1 %>% 
#       dplyr::filter(`Date` >= date1, `Date` <= date2)
#     return(t2)
#   }
# }


# target_date <- as.Date("2024-03-20")
# batter_game_logs_date(19755, date1 = target_date, date2 = target_date)

# Function to combine all player stats into one tibble and select relevant columns
# pitcher_stats_prep <- function(playerids, date1, date2){
  
#   ret_tbl<- playerids %>% 
#     map_dfr(\(playerids) pitcher_daily_game_logs(playerids, year = 2024, date1, date2))
#   return(ret_tbl)
# }
# 
# target_date <- Sys.Date() - 1
# pitcher_output <- pitcher_stats_prep(termi_pitcher_keys, target_date, target_date)


# x <- fg_keys[1:3]
# x %>% map_dfr(\(x) pitcher_daily_game_logs(x, year = 2024, target_date))  %>% colnames()
# 
# colnames(test_list[[2]])[!(colnames(test_list[[2]])) %in% colnames(test_list[[1]])]

season_pitcher_logs <- lapply(termi_pitcher_keys, function(player_id) {
  # Retrieve pitcher game logs for the current player ID and season
  player_logs <- fg_pitcher_game_logs(player_id, year = 2024)  # Adjust season as needed
  
  # Check if game logs were retrieved successfully
  if (!is.null(player_logs)) {
    return(player_logs)  # Return the game logs
  } else {
    # Handle case where game logs are not available
    warning(paste("No game logs available for player ID", player_id))
    return(NULL)  # Return NULL to indicate no game logs
  }
})

# Combine game logs into a single data frame
# all_logs_pitchers <- do.call(rbind, c(season_pitcher_logs, fill = TRUE))
all_logs_pitchers <- bind_rows(season_pitcher_logs)


# Filter for yesterday's date
yesterday_date <- Sys.Date() - 1
pitcher_output <- all_logs_pitchers %>%
  as_tibble() %>%
  filter(Date == yesterday_date) %>%
  select(playerid,
         PlayerName,
         Team,
         Date,
         W,
         SV,
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
  arrange(desc(as.numeric(`K-BB%`)), -IP)

# mutate(EV = round(EV, 1),
#        ERA =sprintf("%.2f",ERA),
#        WHIP = sprintf("%.2f", WHIP),
#        `K-BB%` = sprintf("%.1f%%", `K-BB%` * 100),
#        `SwStr%` = round(`SwStr%`*100,1),
#        `Barrel%` = sprintf("%.0f%%", `Barrel%` * 100),
#        `HardHit%` = sprintf("%.0f%%", `HardHit%` * 100)) %>%


pitcher_tbl_html <-
  pitcher_output %>%
  select(-playerid, -Date) %>%
  mutate(EV = round(EV, 1),
         ERA =sprintf("%.2f",ERA),
         WHIP = sprintf("%.2f", WHIP),
         `K-BB%` = sprintf("%.0f%%", `K-BB%` * 100),
         `SwStr%` = sprintf("%.0f%%", `SwStr%` * 100),
         `Barrel%` = sprintf("%.0f%%", `Barrel%` * 100),
         `HardHit%` = sprintf("%.0f%%", `HardHit%` * 100)) %>%
  gt() %>%
  grand_summary_rows(
    columns = c(W, SV, IP, H, R, ER, BB, SO, HR),
    fns = list(label = "TOTALS", id = "TOTALS", fn = ~sum(.)),
    fmt = ~ fmt_integer(.),
    side = "top"
  ) %>%
  grand_summary_rows(
    columns = c(WHIP),
    fns = list(label = "TOTALS", id = "TOTALS", fn = ~sum((H+BB)) / sum(IP)),
    fmt = ~ fmt_number(., decimals = 2),
    side = "top"
  )%>%
  grand_summary_rows(
    columns = c(ERA),
    fns = list(label = "TOTALS", id = "TOTALS", fn = ~(9 * (sum(ER) / sum(IP)))),
    fmt = ~ fmt_number(., decimals = 2),
    side = "top"
  ) %>%
  tab_style(
    locations = cells_grand_summary(),
    style = cell_fill(color = "lightblue" %>% adjust_luminance(steps = +1))
  ) %>%
  as_raw_html()


