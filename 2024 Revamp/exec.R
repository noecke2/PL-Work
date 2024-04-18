
# Exec Script -------------------------------------------------------------

##### Run all relevant scripts

# Load helper functions
source("2024 Revamp/helper functions/get_probables.R")
source("2024 Revamp/helper functions/fix_missing_ids.R")
source("2024 Revamp/helper functions/create_pitcher_html_tbl.R")
source("2024 Revamp/helper functions/create_batter_html_tbl.R")
source("2024 Revamp/helper functions/free_agents_season.R")

# source("2024 Revamp/helper functions/write_players_to_gs.R")

# Load packages + player lookup table
source("2024 Revamp/1_load_prereqs.R")

# Load Termi Rosters
source("2024 Revamp/termi_roster.R")

# Load batter daily statistics from previous day
source("2024 Revamp/batters_daily_stats.R")

# Load pitcher daily statistics from previous day
source("2024 Revamp/pitcher_daily_stats.R")

# Load function to get probable pitchers

# Format table + send email
source("2024 Revamp/send_email.R")

# batter_output %>%
#   write_rds("batter_output.rds")
# 
# pitcher_output %>%
#   write_rds("pitcher_output.rds")

