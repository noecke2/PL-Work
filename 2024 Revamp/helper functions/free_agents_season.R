get_top_free_agents <- function(n = 30){
  
  free_agent_leaders <- fg_batter_leaders(startseason = 2024, endseason = 2024) %>%
    filter(!playerid %in% long_pl_rosters$playerid,
           !is.na(maxEV),
           PA > (G*2),
           G >= 5) %>%
    select(playerid,
           PlayerName,
           # is_starter,
           team_name,
           G,
           AB,
           R,
           H,
           RBI,
           BB,
           HR,
           SB,
           SO,
           K_pct,
           BB_pct,
           wOBA,
           xwOBA,
           wRC_plus,
           BABIP,
           # Events,
           maxEV,
           EV,
           LA,
           # Barrels,
           Barrel_pct,
           maxEV,
           # HardHit,
           HardHit_pct) %>%
    arrange(-xwOBA)
  
  
  final_fa_tbl <- free_agent_leaders %>%
    mutate(maxEV = round(maxEV,1),
           EV = round(EV, 1),
           LA = round(LA,1),
           BABIP = round(BABIP, 3),
           wOBA = round(wOBA, 3),
           wRC_plus = round(wRC_plus, 0)) %>%
    # mutate(across(ends_with("_pct"), ~ sprintf("%.0f%%", . * 100))) %>%
    rename(Team = team_name,
           `wRC+` = wRC_plus) %>%
    rename_with(~gsub("_pct", "%", .x), ends_with("_pct")) %>%
    select(-playerid) %>%
    slice_head(n = 40)
  
  
  final_gt_table <- final_fa_tbl %>%
    gt() %>%
    fmt_percent(
      columns = ends_with("%"),
      decimals = 0) %>%
    tab_header(
      title = "Free Agent Leaders",
      subtitle = "Min 5 games & 2 PA / G. Data for full season through yesterday"
    ) %>%
    data_color(
      columns = xwOBA,
      method = "numeric",
      palette = c("lightgreen", "darkgreen")
    ) %>%
    data_color(
      columns=  `Barrel%`,
      method = "auto",
      palette = c("lightgreen", "darkgreen")
    ) %>%
    tab_style(
      style = cell_text(weight = "bold"),
      locations = cells_column_labels()
    ) %>%
    tab_style(
      style = cell_text(align = "center"),  # Center-align cell text
      locations = cells_body()  # Apply to body cells
    ) %>%
    tab_options(
      table.width = "100%",  # Set table width to 100%
      table.border.top.width = px(1),  # Set top border width
      table.border.bottom.width = px(1)  # Set bottom border width
    ) %>%
    tab_style(
      style = cell_text(weight = "bold"),
      locations = cells_body(columns = "PlayerName")  # Bold PlayerName column
    )
  
  
  return(final_gt_table %>% as_raw_html())
  
}


# fg_pitcher_leaders(startseason = 2024, endseason = 2024) %>%
#   filter(!playerid %in% long_pl_rosters$playerid) %>% 
#   colnames()




