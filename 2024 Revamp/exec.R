
# Exec Script -------------------------------------------------------------

##### Run all relevant scripts

# Load packages + player lookup table
source("2024 Revamp/1_load_prereqs.R")

# Load batter daily statistics from previous day
source("2024 Revamp/batters_daily_stats.R")

# Load pitcher daily statistics from previous dat
source("2024 Revamp/pitcher_daily_stats.R")

# Format table + send email
source("2024 Revamp/send_email.R")

