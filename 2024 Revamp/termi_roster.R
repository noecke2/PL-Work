
# Create Termi Roster -----------------------------------------------------


termi_batters <- player_lu %>%
  filter((name_first == "Maikel" & name_last == "García") |
           (name_first == "Bo" & name_last == "Naylor") |
           (name_first == "Freddie" & name_last == "Freeman") |
           (name_first == "Gleyber" & name_last == "Torres") |
           (name_first == "Max" & name_last == "Muncy" & key_person == "65e6cf19") |
           (name_first == "Willy" & name_last == "Adames") |
           (name_first == "Vladimir" & name_last == "Guerrero") |
           (name_first == "Zack" & name_last == "Gelof") |
           (name_first == "Kyle" & name_last == "Tucker") |
           (name_first == "Michael" & name_last == "Harris") |
           (name_first == "Seiya" & name_last == "Suzuki") |
           (name_first == "Cody" & name_last == "Bellinger") |
           (name_first == "James" & name_last == "Outman") |
           (name_first == "Brandon" & name_last == "Lowe") |
           (name_first == "José" & name_last == "Siri") |
           (name_first == "Ian" & name_last == "Happ") |
           (name_first == "Parker" & name_last == "Meadows") |
           (name_first == "Michael" & name_last == "Busch") 
         )
termi_batter_keys <- termi_batters %>% pull(key_fangraphs)

# fg_batter_leaders(startseason = 2024, endseason = 2024, startdate = "2024-03-20", enddate = "2024-03-28") %>% filter(playerid ==29490)



termi_pitchers <- player_lu %>%
  filter((name_first == "Framber" & name_last == "Valdez") |
           (name_first == "Bobby" & name_last == "Miller") |
           (name_first == "Joe" & name_last == "Musgrove") |
           (name_first == "Mike" & name_last == "King") |
           (name_first == "Nathan" & name_last == "Eovaldi") |
           (name_first == "Charlie" & name_last == "Morton") |
           (name_first == "Edwin" & name_last == "Díaz" & key_fangraphs == 14710) |
           (name_first == "Adbert" & name_last == "Alzolay") |
           (name_first == "Michael" & name_last == "Soroka") |
           (name_first == "A. J." & name_last == "Puk") |
           (name_first == "Seth" & name_last == "Lugo") |
           (name_first == "Luis" & name_last == "Gil") |
           (name_first == "Jack" & name_last == "Flaherty") |
           (name_first == "Kyle" & name_last == "Harrison") |
            (name_first == "Abner" & name_last == "Uribe") |
            (name_first == "Clarke" & name_last == "Schmidt") |
            (name_first == "James" & name_last == "McArthur") |
           (name_first == "Jason" & name_last == "Foley")
           )

termi_pitcher_keys <- termi_pitchers %>% pull(key_fangraphs)