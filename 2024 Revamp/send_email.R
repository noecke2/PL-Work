
# require(blastula)
# require(glue)
# require(gt)
# require(keyring)
# require(tidyverse)

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

# batter_tbl_html <- 
#   batter_output %>%
#   select(-playerid, -Date) %>%
#   gt() %>%
#   as_raw_html()
# 
# pitcher_tbl_html <- 
#   pitcher_output %>%
#   select(-playerid, -Date) %>%
#   gt() %>%
#   as_raw_html()
# 
# sending_date <- format(as.Date(batter_output %>% distinct(Date) %>% pull(Date)),'%B %d, %Y')
# 
# email <-
#   compose_email(
#     body = 
#       blocks(
#         block_title(md("This is a **PL Testing** Email")),
#         block_text(md(glue(
#           
#           "
#   ## Hello!
#   
#   This is a testing email featuring hitters data from {sending_date} (date is dynamically inserted). We can also test using **bold** formatting.
#   
#   Thanks, Andrew
#   
#   "
#         ))),
#         batter_tbl_html,
#         block_text(md(glue(
#           
#           "
#           This is some more text followed by the pitcher table:
#           
#           Testing testing"))),
#         pitcher_tbl_html
#         )
#   )
# 
#  if (interactive()) email
# 
# 
# email %>%
#   smtp_send(
#     to = c('alnoecker4@gmail.com'),
#     from = 'alnoecker4@gmail.com',
#     subject = "Test email with pitcher data",
#     credentials = creds_key(id = "gmail_creds2")#creds_file(file = "gmail_creds")
#   )
# #To set the credentials the first time use (in this case using a gmail address):
# # create_smtp_creds_file(
# #   file = "gmail_creds",
# #   user = "alnoecker@gmail.com",
# #   provider = "gmail"
# # )
# 




# gmailr testing ----------------------------------------------------------

library(gmailr)
gm_auth_configure(path = "2024 Revamp/gmail_credentials.json")


mail <- gm_mime() %>%
  gm_to("alnoecker4@gmail.com") %>%
  gm_from("alnoecker4@gmail.com") %>%
  gm_subject("Test email subject") %>%
  gm_text_body("Test email body")


gm_send_message(mail)
