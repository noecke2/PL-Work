
# Create Termi Roster -----------------------------------------------------

### Google Sheet 
ss <- "1nTbaBZ6tply7bBv7GRo4sLkLathcZIX_ByUnk7cnkXw"

# googlesheets4::gs4_auth(email = "alnoecker4@gmail.com", token=ss)

# Data is public so don't need to authenticate
gs4_deauth()

# Read in missing FG keys
pl_rosters <- googlesheets4::range_read(ss = ss,
                                        sheet = "Rosters",
                                        range = "M1:W50")

termi_full <- player_lu %>%
  filter(!is.na(key_fangraphs),
         key_fangraphs %in% pl_rosters$Terminoeckers)

termi_full_keys <- termi_full %>% pull(key_fangraphs)
termi_starters <- pl_rosters$Terminoeckers[1:28] # first 28 players in the column are the starters, everyone else is bench


# fg_batter_leaders(startseason = 2024, endseason = 2024, startdate = "2024-03-20", enddate = "2024-03-28") %>% filter(playerid ==29490)



