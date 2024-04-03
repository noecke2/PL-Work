# PL-Work

Repository to house various fantasy baseball projects, primarily a [custom report](https://noecke2.github.io/PL-Work/R/Period-Reports/report1.html) developed for the Terminoeckers, a fantasy baseball team I co-manage with my dad.

### `R`
The functions used in the report are in this folder, along with the `Period-Reports` folder. The R scripts essentially re-work baseballr functions to pull statistics from fangraphs, but only over a certain date range (the baseballr functions could only pull statistics for the whole season). 

##### `Period-Reports`

The main file of interest in this folder is the `report1.Rmd`, which is the main report that is knitted and shared between my dad and I. It allows us to look at advanced statistics for our players, all MLB players, and free agents available in our league (done by scraping each fantasy team's rosters using the googlesheets4 package). 

### `2024 Revamp`

New code for 2024 season - adding a daily email that deploys at 5:30am. Includes previous day's statistics for our players and the next days probable pitchers. More features to be added in the future.