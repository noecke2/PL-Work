
# Test all in one file-----------------------------------------------------



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





# map_dfr()
# x <- c(18882, 19470) 
# test_list <- x %>% map(\(x) baseballr::fg_batter_game_logs(x,year = 2023))

#### These are the 2 functions that seem most useful

# Helper function to pull player game logs
batter_daily_game_logs <- function(x, year = 2024, date1, date2) {
  t1 <- baseballr::fg_batter_game_logs(x, year)
  t2 <- t1 %>% 
    dplyr::filter(`Date` >= date1, `Date` <= date2,Pos != "P")
  
  return(as_tibble(t2))
}


# target_date <- as.Date("2024-03-20")
# batter_game_logs_date(19755, date1 = target_date, date2 = target_date)

# Function to combine all player stats into one tibble and select relevant columns
batter_stats_prep <- function(playerids, date1, date2){
  
  ret_tbl<- playerids %>% 
    map_dfr(\(playerids) batter_daily_game_logs(playerids, year = 2024, date1, date2)) %>%
    select(playerid,
           PlayerName,
           Team,
           Date,
           BatOrder,
           Pos,
           AB,
           R,
           H,
           RBI,
           BB,
           HR,
           SB,
           SO,
           Events,
           maxEV,
           EV,
           LA,
           Barrels,
           `Barrel%`,
           maxEV,
           HardHit) %>%
    mutate(maxEV = round(maxEV,1),
           EV = round(EV, 1),
           LA = round(LA,1)) %>%
    arrange(Team,BatOrder)
  return(ret_tbl)
}

target_date <- as.Date("2024-03-20")
batter_output <- batter_stats_prep(fg_keys, target_date, target_date)

# 
# x <- fg_keys[1:25]
# x %>% map_dfr(\(x) batter_game_logs_date(x, year = 2023, "2023-04-10", "2023-04-10"))  %>% colnames()
# 
# colnames(test_list[[2]])[!(colnames(test_list[[2]])) %in% colnames(test_list[[1]])]



# Script to pull pitcher daily stats --------------------------------------

# https://stackoverflow.com/questions/77664560/scrape-data-from-site-using-variables-and-functions-and-bind-tables-to-one-dataf

#### These are the 2 functions that seem most useful

# Helper function to pull player game logs
pitcher_daily_game_logs <- function(x, year = 2024, date1, date2) {
  t1 <- suppressMessages(baseballr::fg_pitcher_game_logs(x, year))
  if(nrow(t1)>0){
    t2 <- t1 %>% 
      dplyr::filter(`Date` >= date1, `Date` <= date2)
    return(t2)
  }
}

22210 


# target_date <- as.Date("2024-03-20")
# batter_game_logs_date(19755, date1 = target_date, date2 = target_date)

# Function to combine all player stats into one tibble and select relevant columns
pitcher_stats_prep <- function(playerids, date1, date2){
  
  ret_tbl<- playerids %>% 
    map_dfr(\(playerids) pitcher_daily_game_logs(playerids, year = 2024, date1, date2)) %>%
    select(playerid,
           PlayerName,
           Team,
           Date,
           IP,
           H,
           R,
           ER,
           BB,
           SO,
           HR,
           ERA,
           WHIP,
           `K-BB%`,
           `SwStr%`,
           EV,
           `Barrel%`,
           `HardHit%`,
    ) %>%
    mutate(EV = round(EV, 1),
           ERA = round(ERA,2),
           WHIP = round(WHIP,2),
           `K-BB%` = round(`K-BB%`*100,1),
           `SwStr%` = round(`SwStr%`*100,1),
           `Barrel%`= round(`Barrel%`*100,1),
           `HardHit%` = round(`HardHit%`*100,1)) %>%
    arrange(Team, -IP)
  return(ret_tbl)
}

target_date <- as.Date("2024-03-20")
pitcher_output <- pitcher_stats_prep(fg_keys, target_date, target_date)


# x <- fg_keys[1:3]
# x %>% map_dfr(\(x) pitcher_daily_game_logs(x, year = 2024, target_date))  %>% colnames()
# 
# colnames(test_list[[2]])[!(colnames(test_list[[2]])) %in% colnames(test_list[[1]])]



# Store SMTP credentials in the
# system's key-value store with
# `provider = "gmail"`
# create_smtp_creds_key(
#   id = "gmail_creds2",
#   user = "alnoecker4@gmail.com",
#   provider = "gmail"
# )
#phxf zpwu dwpv yfqb

#load("2024 Revamp/email_testing_240323.RData")

batter_tbl_html <- 
  batter_output %>%
  select(-playerid. -Date) %>%
  gt() %>%
  as_raw_html()

pitcher_tbl_html <- 
  pitcher_output %>%
  select(-playerid, -Date) %>%
  gt() %>%
  as_raw_html()

sending_date <- format(as.Date(batter_output %>% distinct(Date) %>% pull(Date)),'%B %d, %Y')

email <-
  compose_email(
    body = 
      blocks(
        block_title(md("This is a **PL Testing** Email")),
        block_text(md(glue(
          
          "
  ## Hello!
  
  This is a testing email featuring hitters data from {sending_date} (date is dynamically inserted). We can also test using **bold** formatting.
  
  Thanks, Andrew
  
  "
        ))),
  batter_tbl_html,
  block_text(md(glue(
    
    "
          This is some more text followed by the pitcher table:
          
          Testing testing"))),
  pitcher_tbl_html
      )
  )

if (interactive()) email


email %>%
  smtp_send(
    to = c('alnoecker4@gmail.com'),
    from = 'alnoecker4@gmail.com',
    subject = "Test email with pitcher data",
    credentials = creds_key(id = "gmail_creds2")#creds_file(file = "gmail_creds")
  )
#To set the credentials the first time use (in this case using a gmail address):
# create_smtp_creds_file(
#   file = "gmail_creds",
#   user = "alnoecker@gmail.com",
#   provider = "gmail"
# )





# gmailr testing ----------------------------------------------------------

# library(gmailr)
# gm_auth_configure(path = "gmail_credentials.json")
# 
# 
# mail <- gm_mime() %>%
#   gm_to("alnoecker4@gmail.com") %>%
#   gm_from("alnoecker4@gmail.com") %>%
#   gm_subject("Test email subject") %>%
#   gm_text_body("Test email body")
# 
# 
# gm_send_message(mail)





