
# Purpose: Write Player Lookup Table to Google Sheet for easier roster updating --------

write_players_to_gs <- function() {
  
  ### Google Sheet with amended FG IDs
  ss <- "1nTbaBZ6tply7bBv7GRo4sLkLathcZIX_ByUnk7cnkXw"
  
  # googlesheets4::gs4_auth(email = "alnoecker4@gmail.com", token=ss)
  gs4_auth(email = "alnoecker4@gmail.com")
  
  # Data is public so don't need to authenticate
  gs4_deauth()
  
  clean_player_lu <- player_lu %>%
    filter(!is.na(key_fangraphs)) %>%
    mutate(name_first = iconv(name_first, to = "ASCII//TRANSLIT"),
           name_last = iconv(name_last, to = "ASCII//TRANSLIT"),
           name_full = paste(name_first, name_last)) %>%
    select(name_full, 
           key_person,
           key_bbref,
           key_fangraphs,
           name_last, 
           name_first,
           pro_played_first,
           pro_played_last,
           mlb_played_first,
           mlb_played_last,
           last_update_date)
  
  
  # Read in missing FG keys
  googlesheets4::sheet_write(clean_player_lu,
                             ss = ss,
                             sheet = "All Players")
  
}


# sheet_properties(ss)
