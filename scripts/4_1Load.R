# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Loads the hourly wind speed train & test sets for model building
# and validation. Returns both data frames and msts objects.
#
# ##############################################################################

windTrain <- read_csv("data/windTrainSet.csv")

windTest <- read_csv("data/windTestSet.csv")

# Create time series

freq <- c(24, 24*365.25) # Diurnal & Annual seasonality

windTrainTS <- msts(windTrain$windSpeed, freq, ts.frequency = freq[1])

windTestTS <- msts(windTest$windSpeed, freq, ts.frequency = freq[1])

## Notify that script's end has been reached ##
if (require(beepr)) {beepr::beep(1)}
