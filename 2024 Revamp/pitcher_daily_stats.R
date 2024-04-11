
# Script to pull pitcher daily stats --------------------------------------

# Helper function to convert 1.2 IP to 1.67 for calculation purposes
convert_ip <- function(x) {
  return(((10*x) - (7 * as.integer(x))) / 3)
} 


season_pitcher_logs <- lapply(termi_full$key_fangraphs, function(player_id) {
  # Retrieve pitcher game logs for the current player ID and season
  player_logs <- suppressMessages(fg_pitcher_game_logs(player_id, year = 2024))  # Adjust season as needed
  
  # Check if game logs were retrieved successfully
  if (nrow(player_logs) > 0) {
    return(player_logs)  # Return the game logs
  } else {
    # Handle case where game logs are not available
    warning(paste("No game logs available for player ID", player_id))
    #return(NULL)  # Return NULL to indicate no game logs
  }
})

# Combine game logs into a single data frame
all_logs_pitchers <- do.call(rbind, c(season_pitcher_logs, fill = TRUE))
# all_logs_pitchers <- bind_rows(season_pitcher_logs) %>% as_tibble()


# Filter for yesterday's date, select relevant columns
yesterday_date <- Sys.Date() - 1
pitcher_output <- all_logs_pitchers %>%
  as_tibble() %>%
  mutate(is_starter = ifelse(playerid %in% termi_starters, 1, 0)) %>%
  filter(Date == yesterday_date) %>%
  select(playerid,
         PlayerName,
         is_starter,
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
  arrange(-is_starter, desc(as.numeric(`K-BB%`)), -IP)

pitcher_tbl_html <- create_pitcher_html_tbl(pitcher_output)

