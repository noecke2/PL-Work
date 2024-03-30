
# require(blastula)
# require(glue)
# require(gt)
# require(keyring)
# require(tidyverse)

batter_tbl_html <-
  batter_output %>%
  select(-playerid, -Date) %>%
  gt() %>%
  as_raw_html()

pitcher_tbl_html <-
  pitcher_output %>%
  select(-playerid, -Date) %>%
  mutate(EV = round(EV, 1),
         ERA =sprintf("%.2f",ERA),
         WHIP = sprintf("%.2f", WHIP),
         `K-BB%` = sprintf("%.0f%%", `K-BB%` * 100),
         `SwStr%` = sprintf("%.0f%%", `SwStr%` * 100),
         `Barrel%` = sprintf("%.0f%%", `Barrel%` * 100),
         `HardHit%` = sprintf("%.0f%%", `HardHit%` * 100)) %>%
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

  This is the first day testing this on a schedule. Ideally, it will run around 6am. 
  
  This data is from {sending_date} (date is dynamically inserted). We can also test using **bold** formatting.

  Thanks, Andrew

  "
        ))),
        batter_tbl_html,
        block_text(md(glue(

          "
          This is some more text followed by the pitcher table:\n"))),
        pitcher_tbl_html
        )
  )
# if (interactive()) email

smtp_server <- Sys.getenv("SMTP_SERVER")
smtp_username <- Sys.getenv("SMTP_USERNAME")
smtp_password <- Sys.getenv("SMTP_PASSWORD")

creds <- creds_envvar(
  user = smtp_username,
  pass_envvar = "SMTP_PASSWORD",
  provider = "gmail"
    #host = smtp_server
)

email %>%
  smtp_send(
    to = c('alnoecker4@gmail.com', 'duane.noecker@gmail.com'),
    from = 'alnoecker4@gmail.com',
    subject = paste0("Termi Daily Report: ", sending_date),
    credentials = creds
      #creds_key(id = "gmail_creds2")#creds_file(file = "gmail_creds")
  )
#To set the credentials the first time use (in this case using a gmail address):
# create_smtp_creds_file(
#   file = "gmail_creds",
#   user = "alnoecker@gmail.com",
#   provider = "gmail"
# )





# gmailr testing ----------------------------------------------------------

# library(gmailr)
# #gm_auth_configure(path = "2024 Revamp/gmail_credentials.json")
# 
# options(gargle_verbosity = "debug")
# 
# gm_auth_configure(path = "2024 Revamp/gmail_credentials.json")
# gm_auth(email = "alnoecker4@gmail.com")
# 
# mail <- gm_mime() %>%
#   gm_to("alnoecker4@gmail.com") %>%
#   gm_from("alnoecker4@gmail.com") %>%
#   gm_subject("Test email subject") %>%
#   gm_text_body("Test email body")
# 
# 
# gm_send_message(mail)
