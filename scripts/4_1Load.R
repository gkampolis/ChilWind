# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Loads the hourly wind speed train & test sets for model building
# and validation. Returns teh forecast horizon (length of the test set) and both
# data frames and msts objects.
#
# ##############################################################################

windTrain <- read_csv("data/windTrainSet.csv")

windTest <- read_csv("data/windTestSet.csv")

# Create time series

freq <- c(24, 24*365.25) # Diurnal & Annual seasonality

windTrainTS <- msts(windTrain$windSpeed, freq, ts.frequency = freq[1])

windTestTS <- msts(windTest$windSpeed, freq, ts.frequency = freq[1])

# Shift the Test data in time to accomodate plotting. Start & End points
# are the same as the forecast objects. This does not truncate the series.
windTestTS <- ts(data = as.vector(windTestTS),
                frequency = 24,
                start = c(746, 1),
                end = c(762, 24)
)

# Set forecast horizon h
horizon <- length(windTestTS)

## Notify that script's end has been reached ##
if (require(beepr)) {beepr::beep(1)}
