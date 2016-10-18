#load libs 
library (RPostgreSQL)
library(ggplot2)
library(plyr)
library(dplyr)
library(reshape2)
library(tidyr)
library(tibble)

#connect to db 
driver <- dbDriver("PostgreSQL")
conn <- dbConnect(driver, host="superevilmegacorp.redshift.amplitude.com",
                  port="5439",
                  dbname="superevilmegacorp",
                  user="superevilmegacorp",
                  password="GQdPSadICW2lL5qCkS20U9Jk")

update_time <- strptime(Sys.time(), "%Y-%m-%d %T")

##============================================
## Daily Essence Card Events (g_card_essence_events & g_daily_card_essence_events)
##============================================

sql_daily_card_essence_events <-
  "Select
date(event_time) as event_date
,e_essence as essence_type
,count(*) event_count
From economy_convert_cardtoessence
Where date(event_time) >= '2016-09-15'
And e_essence IN ( --these appear to be the corrct e_essence values
1,
6,
10,
12,
30,
120
)
Group By 1,2"


daily_card_essence_events <- dbGetQuery(conn, paste("SET search_path = app139203;",
                                                    sql_daily_card_essence_events,
                                                    sep = ""))