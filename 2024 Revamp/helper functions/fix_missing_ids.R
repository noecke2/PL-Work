
# 27 players who don't have a fangraphs key who have played this year
# player_lu %>%
#   filter(mlb_played_last %in% c(2023,2024), is.na(key_fangraphs)) %>%
#   select(key_person, name_first, name_last) %>%
#   arrange(name_first)
#   view()

fix_missing_ids <- function(player_lu_raw) {
  
  ### Google Sheet with amended FG IDs
  ss <- "1nTbaBZ6tply7bBv7GRo4sLkLathcZIX_ByUnk7cnkXw"
  
  # googlesheets4::gs4_auth(email = "alnoecker4@gmail.com", token=ss)
  
  # Data is public so don't need to authenticate
  gs4_deauth()
  
  # Read in missing FG keys
  missing_fg_ids <- googlesheets4::range_read(ss = ss,
                                              sheet = "Player Lookup Fixes",
                                              range = "A1:D100") %>%
    filter(!is.na(key_fangraphs)) %>%
    mutate(key_person = as.character(key_person))

  # UPDATE player_lu with fixed Fg keys
  player_lu_updated <- player_lu_raw %>%
    left_join(missing_fg_ids, by = "key_person", suffix = c("", ".y")) %>% 
    mutate(key_fangraphs = ifelse(!is.na(key_fangraphs.y), key_fangraphs.y, key_fangraphs)) %>%
    # filter(key_fangraphs %in% missing_fg_ids$key_fangraphs) %>%
    select(!ends_with(".y"))
  
  return(player_lu_updated)
  
}



  




