create_batter_html_tbl <- function(x) {
  
  num_starters <- nrow(x %>% filter(is_starter == 1))
  num_bench <- nrow(x %>% filter(is_starter == 0))
  
  if(num_starters > 0 && num_bench > 0){
    batter_tbl <-  
      batter_output %>%
      select(-playerid, -Date) %>%
      # filter(is_starter == 1) %>%
      gt() %>%
      tab_row_group(
        label =  "Starters",
        rows = is_starter == 1
      ) %>%
      tab_row_group(
        label = "Bench",
        rows = is_starter == 0
      ) %>%
      summary_rows(
        groups = everything(),
        columns = c(AB, R, H, RBI, BB, HR, SB, SO),
        fns = list(TOTAL = ~sum(., na.rm = TRUE)),
        fmt = ~ fmt_integer(.),
        side = c("top")
      ) %>%
      tab_style(
        locations = cells_summary(groups = "Starters"),
        style = cell_fill(color = "lightblue" %>% adjust_luminance(steps = +1))
      ) %>%
      tab_style(
        locations = cells_summary(groups = "Bench"),
        style = cell_fill(color = "grey" %>% adjust_luminance(steps = +1))
      ) %>%
      row_group_order(groups = c("Starters", "Bench"))
    
    
  } else if (num_starters >0 && num_bench == 0){
      
    batter_tbl <-  
      x %>%
      select(-playerid, -Date) %>%
      # filter(is_starter == 1) %>%
      gt() %>%
      tab_row_group(
        label =  "Starters",
        rows = is_starter == 1
      ) %>%
      summary_rows(
        groups = everything(),
        columns = c(AB, R, H, RBI, BB, HR, SB, SO),
        fns = list(TOTAL = ~sum(., na.rm = TRUE)),
        fmt = ~ fmt_integer(.),
        side = c("top")
      ) %>%
      tab_style(
        locations = cells_summary(groups = "Starters"),
        style = cell_fill(color = "lightblue" %>% adjust_luminance(steps = +1))
      ) %>%
      row_group_order(groups = c("Starters"))
    
    
  } else if (num_starters == 0 && num_bench > 0){
    
    batter_tbl <-  
      x %>%
      select(-playerid, -Date) %>%
      # filter(is_starter == 1) %>%
      gt() %>%
      tab_row_group(
        label =  "Bench",
        rows = is_starter == 0
      ) %>%
      summary_rows(
        groups = everything(),
        columns = c(AB, R, H, RBI, BB, HR, SB, SO),
        fns = list(TOTAL = ~sum(., na.rm = TRUE)),
        fmt = ~ fmt_integer(.),
        side = c("top")
      ) %>%
      tab_style(
        locations = cells_summary(groups = "Bench"),
        style = cell_fill(color = "grey" %>% adjust_luminance(steps = +1))
      ) %>%
      row_group_order(groups = c("Bench"))
    
    
  } else{
    
    batter_tbl <- html("We either had no hitters yesterday or data is not accessible yet")
    
  }
  
  if (typeof(batter_tbl) == "list"){
    batter_tbl_html <- batter_tbl %>%
      tab_header(
        title = md("**Terminoecker Hitters**"),
        subtitle = paste0(md("Date: "), yesterday_date)
      ) %>%
      cols_hide(columns = c(is_starter)) %>%
      as_raw_html()
    
  } else {batter_tbl_html <- batter_tbl}
  
  return(batter_tbl_html)
  
}
