
# require(blastula)
# require(glue)
# require(gt)
# require(keyring)
# require(tidyverse)



sending_date <- format(as.Date(batter_output %>% distinct(Date) %>% pull(Date)),'%B %d, %Y')

email_body <- glue::glue(
  "
  ## Hello!
  
  **New feature today:** Cleaned up table titles and implemented better error handling for hitter + pitcher tables. Hoping to add 7 day weekly updates soon (in the next couple of days). 
  
  Thanks,  
  Andrew
  "
)

# Compose the email
email <- compose_email(
  body = blocks(
    block_title(md(paste0("PL Daily Report: ", sending_date))),
    block_text(md(email_body)),
    get_termi_probables(),
    batter_tbl_html,
    block_text("\n"),  # Additional spacing
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
