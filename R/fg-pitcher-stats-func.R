# PURPOSE: function to pull pitcher stats over a certain time frame

fg_pitcher_stats <- function(startdate = "2022-01-01", enddate = "2022-12-31", qual = "y"){
  
  # Grab fg URL
  url <- paste0("https://www.fangraphs.com/leaders.aspx?pos=all&stats=pit&lg=all&qual=",
                qual,
                "&type=c,13,4,24,11,6,42,-1,120,121,217,-1,14,322,323,325,328,-1,122,330,331,-1,41,43,44,-1,117,118,119,-1,45,124,-1,62,36,37,38,40&season=2022&month=1000&season1=2022&ind=0&team=0&rost=0&age=0&filter=&players=0&startdate=",
                startdate, 
                "&enddate=",
                enddate,
                "&sort=11,d&page=1_100000")
  
  wp <- read_html(url)
  
  # Grab data from webpage, convert to table
  fg_data <- 
    (wp %>%
       html_nodes(xpath = '//*[@id="LeaderBoard1_dg1_ctl00"]/tbody') %>%
       html_table())[[1]]
  
  # Grab and assign appropriate column names
  fg_colnames <-
    ((wp %>%
        html_nodes(xpath = '//*[@id="LeaderBoard1_dg1_ctl00"]/thead') %>%
        html_table())[[1]] %>%
       slice(2))[1,]
  
  colnames(fg_data) <- str_trim(fg_colnames)
  
  # Parse numbers as appropriate
  fg_data <- fg_data %>%
    mutate(across(-c("Name", "Team"), as.character)) %>%
    mutate(across(-c("Name", "Team"), parse_number)) %>% 
    mutate(start_date = as.Date(startdate),
           end_date = as.Date(enddate))
  
  return(fg_data)
}