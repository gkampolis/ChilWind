# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Loads the data set, and creates hourly values by aggregating
# means (by utilizing na.rm=TRUE option of the mean() function). Resulting data
# set still has NAs, for the cases where the vector passed to mean() is
# comprised entirely by NAs.
#
# Initial set has values recorded every 10 seconds.
#
# ##############################################################################

# Read from zip and load directly to memory, without unzipping first to disk:
df <- read_csv(unz("data/windDataChilBolton.zip",
               utils::unzip("data/windDataChilBolton.zip",
                            list = TRUE)[1,1])
              )
df %<>% dplyr::select(windSpeed)

# Load variation of mean() function, which automatically has na.rm=TRUE
source("scripts/fun/meanNA.R")

## Create *hourly* data set, by computing the mean ##
n <- 6 * 60 # measurements every 10 secs, 6 values comprise a minute.
df <- aggregate(df,list(rep(1:(nrow(df)%/%n+1),each=n,len=nrow(df))),meanNA)[-1];

dateTime <- seq(ymd_hm("2016-01-01 00:00"),
                ymd_hm("2018-01-31 23:00"),
                by = "1 hour"
                )

windHourly <- bind_cols(as.data.frame(dateTime, col.names = "dateTime"),df)

write_delim(windHourly,
            path = "./data/windHourlyChilbolton.csv",
            delim = ",")

rm(n, df, dateTime, windHourly, meanNA)
