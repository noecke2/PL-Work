
# Script to pull player lookup table and filter to this year --------------

require(baseballr)
require(blastula)
require(glue)
require(gt)
require(keyring)
require(tidyverse)

# https://stackoverflow.com/questions/77664560/scrape-data-from-site-using-variables-and-functions-and-bind-tables-to-one-dataf


player_lu <- baseballr::chadwick_player_lu()

fg_keys <- player_lu %>%
  filter(!is.na(key_fangraphs),
         mlb_played_last %in% c(2024)) %>%
  pull(key_fangraphs)

#player_lu %>% filter(name_first == "Jackson", name_last == "Merrill") %>% view()
