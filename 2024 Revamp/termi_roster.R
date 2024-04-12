
# Create Termi Roster -----------------------------------------------------

### Google Sheet 
ss <- "1nTbaBZ6tply7bBv7GRo4sLkLathcZIX_ByUnk7cnkXw"

# googlesheets4::gs4_auth(email = "alnoecker4@gmail.com", token=ss)

# Data is public so don't need to authenticate
gs4_deauth()

# Read in FG keys
pl_rosters <- googlesheets4::range_read(ss = ss,
                                        sheet = "Rosters",
                                        range = "M1:W50") %>%
  filter(!is.na(Terminoeckers))

termi_full <- player_lu %>%
  filter(!is.na(key_fangraphs),
         key_fangraphs %in% pl_rosters$Terminoeckers)

termi_full_keys <- termi_full %>% pull(key_fangraphs)
termi_starters <- pl_rosters$Terminoeckers[1:28] # first 28 players in the column are the starters, everyone else is bench


# fg_batter_leaders(startseason = 2024, endseason = 2024, startdate = Sys.Date() - 15, enddate = Sys.Date() - 1) %>% filter(playerid %in% termi_full_keys) %>% view()

