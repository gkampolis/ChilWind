# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Loads the individual .nc files and creates .csv file with all
# wind speed and direction measurements.
#
# ##############################################################################


library(ncdf4)

## Initialize ##
windSpeed <- NULL
windDirection <- NULL
ncFiles <- list.files(path = "./data/Chilbolton/data",
                      full.names = TRUE,
                      pattern = "*.nc"
                      )

## Read wind speed and direction for all files ##
for (i in seq_along(ncFiles)) {

    ncObject <- nc_open(ncFiles[i])
    windSpeedNC <- ncvar_get(ncObject, varid = "wind_speed")
    windDirectionNC <- ncvar_get(ncObject, varid = "wind_direction")

    # Apend new data #
    windSpeed <- combine(windSpeed, windSpeedNC)
    windDirection <- combine(windDirection, windDirectionNC)

    # Close connection to ncObject #
    nc_close(ncObject)
}
rm(windSpeedNC, windDirectionNC, ncObject, i, ncFiles)

## Create Data Frame ##
windData <- bind_cols(as.data.frame(windSpeed, col.names = "windSpeed"),
                     as.data.frame(windDirection, col.names = "WindDirection")
                     )

## Write .csv ##
write_delim(windData,
            path = "./data/windDataChilbolton.csv",
            delim = ",")

## Create .zip to avoid Git LFS ##
utils::zip("./data/windDataChilbolton.zip","./data/windDataChilbolton.csv")

## Remove intermediary .csv file ##
file.remove("./data/windDataChilbolton.csv")

## Notify that script's end has been reached ##
if (require(beepr)) {beepr::beep(1)}
