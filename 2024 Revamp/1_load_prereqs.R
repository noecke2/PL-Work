
# Script to pull player lookup table and filter to this year --------------

require(baseballr)
require(blastula)
require(glue)
require(gt)
require(googlesheets4)
#require(keyring)
require(tidyverse)

player_lu <- read_rds("2024 Revamp/player_lookup.rds")
last_update_date  <- player_lu %>% distinct(last_update_date) %>% pull(last_update_date)

# If player lookup table hasn't been updated in 7 days, load new one
# Otherwise, just use the one from the last 7 days
if (last_update_date <= Sys.Date() - 7) {
  player_lu_raw <- baseballr::chadwick_player_lu() %>% 
    filter(pro_played_last %in% c(2022, 2023, 2024))
  
  player_lu <- fix_missing_ids(player_lu_raw) %>%
    mutate(last_update_date = Sys.Date())
  
  write_rds(player_lu, "2024 Revamp/player_lookup.rds")
  # write_players_to_gs()
}


# player_lu %>% filter(mlb_played_last == 2024, is.na(key_fangraphs)) %>% select(name_last, name_first)

fg_keys <- player_lu %>%
  filter(!is.na(key_fangraphs),
         mlb_played_last %in% c(2024)) %>%
  pull(key_fangraphs)

# playerid_lookup(last_name = "Ryan", first_name = "River")

# player_lu %>% filter(name_first == "River", name_last == "Ryan") %>% view()


# freeman