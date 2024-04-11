create_pitcher_html_tbl <- function(x) {
  
  num_starters <- nrow(x %>% filter(is_starter == 1))
  num_bench <- nrow(x %>% filter(is_starter == 0))
  
  
  if (num_starters > 0 && num_bench > 0){
    pitcher_tbl <-
      x %>%
      select(-playerid, -Date) %>%
      mutate(EV = round(EV, 1),
             ERA =sprintf("%.2f",ERA),
             WHIP = sprintf("%.2f", WHIP),
             `K-BB%` = sprintf("%.0f%%", `K-BB%` * 100),
             `SwStr%` = sprintf("%.0f%%", `SwStr%` * 100),
             `Barrel%` = sprintf("%.0f%%", `Barrel%` * 100),
             `HardHit%` = sprintf("%.0f%%", `HardHit%` * 100)) %>%
      gt() %>%
      tab_row_group(
        label =  "Starters",
        rows = is_starter == 1
      ) %>%
      tab_options(
        row_group.default_label = "Bench"
      ) %>%
    tab_row_group(
      label = "Bench",
      rows = is_starter == 0
    ) %>%
      summary_rows(
        groups = everything(),
        columns = c(W, SV, H, R, ER, BB, SO, HR),
        fns = list(TOTALS = ~sum(., na.rm = TRUE)),
        fmt = ~ fmt_integer(.),
        side = c("top")
      ) %>%
      summary_rows(
        groups = everything(),
        columns = c(IP),
        fns = list(TOTALS = ~round(sum(convert_ip(.)),2)),
        fmt = ~ fmt_number(., decimals = 2),
        side = c("top")
      ) %>%
      summary_rows(
        groups = everything(),
        columns = c(WHIP),
        fns = list(TOTALS = ~sum((H+BB)) / sum(convert_ip(IP))),
        fmt = ~ fmt_number(., decimals = 2),
        side = c("top")
      ) %>%
      summary_rows(
        groups = everything(),
        columns = c(ERA),
        fns = list(TOTALS = ~(9 * (sum(ER) / sum(convert_ip(IP))))),
        fmt = ~ fmt_number(., decimals = 2),
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
    
    pitcher_tbl <-
      x %>%
      select(-playerid, -Date) %>%
      mutate(EV = round(EV, 1),
             ERA =sprintf("%.2f",ERA),
             WHIP = sprintf("%.2f", WHIP),
             `K-BB%` = sprintf("%.0f%%", `K-BB%` * 100),
             `SwStr%` = sprintf("%.0f%%", `SwStr%` * 100),
             `Barrel%` = sprintf("%.0f%%", `Barrel%` * 100),
             `HardHit%` = sprintf("%.0f%%", `HardHit%` * 100)) %>%
      gt() %>%
      tab_row_group(
        label =  "Starters",
        rows = is_starter == 1
      ) %>%
      summary_rows(
        groups = everything(),
        columns = c(W, SV, H, R, ER, BB, SO, HR),
        fns = list(TOTALS = ~sum(., na.rm = TRUE)),
        fmt = ~ fmt_integer(.),
        side = c("top")
      ) %>%
      summary_rows(
        groups = everything(),
        columns = c(IP),
        fns = list(TOTALS = ~round(sum(convert_ip(.)),2)),
        fmt = ~ fmt_number(., decimals = 2),
        side = c("top")
      ) %>%
      summary_rows(
        groups = everything(),
        columns = c(WHIP),
        fns = list(TOTALS = ~sum((H+BB)) / sum(convert_ip(IP))),
        fmt = ~ fmt_number(., decimals = 2),
        side = c("top")
      ) %>%
      summary_rows(
        groups = everything(),
        columns = c(ERA),
        fns = list(TOTALS = ~(9 * (sum(ER) / sum(convert_ip(IP))))),
        fmt = ~ fmt_number(., decimals = 2),
        side = c("top")
      ) %>%
      tab_style(
        locations = cells_summary(groups = "Starters"),
        style = cell_fill(color = "lightblue" %>% adjust_luminance(steps = +1))
      ) %>%
      row_group_order(groups = c("Starters"))
    
  } else if (num_starters == 0 && num_bench > 0){
    
    pitcher_tbl <-
      x %>%
      select(-playerid, -Date) %>%
      mutate(EV = round(EV, 1),
             ERA =sprintf("%.2f",ERA),
             WHIP = sprintf("%.2f", WHIP),
             `K-BB%` = sprintf("%.0f%%", `K-BB%` * 100),
             `SwStr%` = sprintf("%.0f%%", `SwStr%` * 100),
             `Barrel%` = sprintf("%.0f%%", `Barrel%` * 100),
             `HardHit%` = sprintf("%.0f%%", `HardHit%` * 100)) %>%
      gt() %>%
    tab_row_group(
      label = "Bench",
      rows = is_starter == 0
    ) %>%
      summary_rows(
        groups = everything(),
        columns = c(W, SV, H, R, ER, BB, SO, HR),
        fns = list(TOTALS = ~sum(., na.rm = TRUE)),
        fmt = ~ fmt_integer(.),
        side = c("top")
      ) %>%
      summary_rows(
        groups = everything(),
        columns = c(IP),
        fns = list(TOTALS = ~round(sum(convert_ip(.)),2)),
        fmt = ~ fmt_number(., decimals = 2),
        side = c("top")
      ) %>%
      summary_rows(
        groups = everything(),
        columns = c(WHIP),
        fns = list(TOTALS = ~sum((H+BB)) / sum(convert_ip(IP))),
        fmt = ~ fmt_number(., decimals = 2),
        side = c("top")
      ) %>%
      summary_rows(
        groups = everything(),
        columns = c(ERA),
        fns = list(TOTALS = ~(9 * (sum(ER) / sum(convert_ip(IP))))),
        fmt = ~ fmt_number(., decimals = 2),
        side = c("top")
      ) %>%
      tab_style(
        locations = cells_summary(groups = "Bench"),
        style = cell_fill(color = "grey" %>% adjust_luminance(steps = +1))
      ) %>%
      row_group_order(groups = c("Bench")) 
    
    
  } else{
    
    pitcher_tbl <- html("We either had no pitchers yesterday or data is not accessible yet")
    
  }
  
  if (typeof(pitcher_tbl) == "list"){
    pitcher_tbl_html <- pitcher_tbl %>%
      tab_header(
        title = md("**Terminoecker Pitchers**"),
        subtitle = paste0(md("Date: "), yesterday_date)
      ) %>%
      cols_hide(columns = c(is_starter)) %>%
      as_raw_html()
    
  } else {pitcher_tbl_html <- pitcher_tbl}
  
  return(pitcher_tbl_html)
  
}
