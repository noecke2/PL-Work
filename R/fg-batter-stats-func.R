# PURPOSE: Function to scrape desired FG batter statistics

fg_batter_stats <- function(startdate = "2022-01-01", enddate = "2022-12-31", qual = "y"){
  
  startdate <- as.Date(startdate)
  enddate <- as.Date(enddate)
  
  # Grab fg URL
  url <- paste0("https://www.fangraphs.com/leaders.aspx?pos=all&stats=bat&lg=all&qual=",
                qual,
                "&type=c,6,34,35,36,308,311,-1,23,37,38,39,-1,40,60,41,-1,201,205,200,-1,52,51,50,61,-1,12,7,14,11,13,21&season=2022&month=1000&season1=2022&ind=0&team=0&rost=0&age=0&filter=&players=0&startdate=",
                startdate, 
                "&enddate=",
                enddate,
                "&sort=7,d&page=1_100000")
  
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
    mutate_at(vars(-Name, -Team),
              list(as.character)) %>%
    mutate_at(vars(-Name, -Team),
              list(parse_number)) %>%
    mutate(start_date = as.Date(startdate),
           end_date = as.Date(enddate))
  
  
  return(fg_data)
}