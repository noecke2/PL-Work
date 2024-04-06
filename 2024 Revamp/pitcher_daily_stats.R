
# Script to pull pitcher daily stats --------------------------------------

# Helper function to convert 1.2 IP to 1.67 for calculation purposes
convert_ip <- function(x) {
  return(((10*x) - (7 * as.integer(x))) / 3)
} 


season_pitcher_logs <- lapply(termi_full$key_fangraphs, function(player_id) {
  # Retrieve pitcher game logs for the current player ID and season
  player_logs <- fg_pitcher_game_logs(player_id, year = 2024)  # Adjust season as needed
  
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


if (nrow(pitcher_output) > 0){
  
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
    tab_row_group(
      label =  "Starters",
      rows = is_starter == 1
    ) %>%
    tab_row_group(
      label = "Bench",
      rows = is_starter == 0
    ) %>%
    summary_rows(
      groups = everything(),
      columns = c(W, SV, H, R, ER, BB, SO, HR),
      fns = list(TOTALS = ~sum(., na.rm = TRUE)),
      fmt = ~ fmt_integer(.),
      side = c("top")
    ) %>%
    summary_rows(
      groups = everything(),
      columns = c(IP),
      fns = list(TOTALS = ~round(sum(convert_ip(.)),2)),
      fmt = ~ fmt_number(., decimals = 2),
      side = c("top")
    ) %>%
    summary_rows(
      groups = everything(),
      columns = c(WHIP),
      fns = list(TOTALS = ~sum((H+BB)) / sum(convert_ip(IP))),
      fmt = ~ fmt_number(., decimals = 2),
      side = c("top")
    ) %>%
    summary_rows(
      groups = everything(),
      columns = c(ERA),
      fns = list(TOTALS = ~(9 * (sum(ER) / sum(convert_ip(IP))))),
      fmt = ~ fmt_number(., decimals = 2),
      side = c("top")
    ) %>%
    tab_style(
      locations = cells_summary(groups = "Starters"),
      style = cell_fill(color = "lightblue" %>% adjust_luminance(steps = +1))
    ) %>%
    tab_style(
      locations = cells_summary(groups = "Bench"),
      style = cell_fill(color = "grey" %>% adjust_luminance(steps = +1))
    ) %>%
    row_group_order(groups = c("Starters", "Bench")) %>%
    cols_hide(columns = c(is_starter)) %>%
    as_raw_html()
  
  
} else {
  pitcher_tbl_html <- html("We either had no pitchers yesterday or data is not accessible yet")
}
