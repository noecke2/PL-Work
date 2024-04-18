
# Function to get Termi probable starters for the next day ------------------------


# Step 1: Pull game packs for the next day --------------------------------

get_probables <- function(team = "Terminoeckers") {
  next_day_pks <- mlb_game_pks(Sys.Date()) %>% pull(game_pk)
  next_day_probables <- bind_rows(lapply(next_day_pks, mlb_probables))
  
  team_mlb_ids <- long_pl_rosters %>%
    filter(Team_Name == team) %>%
    pull(key_mlbam)
  
  probables <- next_day_probables %>% 
    filter(id %in% team_mlb_ids) %>%
    left_join(next_day_probables, by = c("game_pk"), suffix = c("", "_opp")) %>%
    filter(id != id_opp | is.na(id_opp)) %>%
    mutate(fullName_opp = ifelse(is.na(fullName_opp), "TBD", fullName_opp)) %>%
    select(fullName, team, fullName_opp, team_opp)
  

  if(nrow(probables) > 0){
    table_gt <- probables %>%
      gt() %>%
      tab_header(
        title =  
        paste0(
          "Probable Pitchers for ",team, ": ", 
          format(Sys.Date(), "%B %d, %Y")
          )
      ) %>%
      cols_label(
        fullName = paste0(team," Pitcher"),
        team = "Team",
        fullName_opp = "Opposing Pitcher",
        team_opp = "Opposing Team"
      ) %>%
      tab_style(style = list(
                          cell_text(weight = "bold"),
                          cell_fill(color = "#C9E9C3")),
                locations = cells_body(
                  columns = fullName
                )) %>%
      tab_style(style = list(
                          cell_fill(color = "#F9E3D6"),
                          cell_text(weight = "bold")),
                locations = cells_body(columns = fullName_opp))
    return(as_raw_html(table_gt))
    
  } else {
    return(html(paste0("There are no probable pitchers today for ", team)))
  }
}
