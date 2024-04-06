


# map_dfr()
# x <- c(18882, 19470) 
# test_list <- x %>% map(\(x) baseballr::fg_batter_game_logs(x,year = 2023))
# require(baseballr)
# require(tidyverse)
#
# x <- fg_keys[1:25]
# x %>% map_dfr(\(x) batter_game_logs_date(x, year = 2023, "2023-04-10", "2023-04-10"))  %>% colnames()
#
# colnames(test_list[[2]])[!(colnames(test_list[[2]])) %in% colnames(test_list[[1]])]



season_batter_logs <- lapply(termi_full$key_fangraphs, function(player_id) {
  fg_batter_game_logs(player_id, year = 2024)  # Adjust season as needed
})

# Combine game logs into a single data frame
all_logs_batters <- do.call(rbind, c(season_batter_logs, fill = TRUE))

# Filter for yesterday's date
yesterday_date <- Sys.Date() - 1

batter_output <- all_logs_batters %>%
  as_tibble() %>%
  filter(Date == yesterday_date,
         Pos != "P") %>%
  mutate(is_starter = ifelse(playerid %in% termi_starters, 1, 0)) %>%
  select(playerid,
         PlayerName,
         is_starter,
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
  arrange(-is_starter,-HR, -RBI, -R, -H, -BB, -SB)


if(nrow(batter_output) > 0){
  
  batter_tbl_html <-  batter_output %>%
    select(-playerid, -Date) %>%
    # filter(is_starter == 1) %>%
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
      columns = c(AB, R, H, RBI, BB, HR, SB, SO),
      fns = list(TOTAL = ~sum(., na.rm = TRUE)),
      fmt = ~ fmt_integer(.),
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
  batter_tbl_html <- html("We either had no pitchers yesterday or data is not accessible yet")
}





