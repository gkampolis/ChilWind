# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Loads the hourly wind speed train & test sets for model building
# and validation. Returns teh forecast horizon (length of the test set) and both
# data frames and msts objects.
#
# ##############################################################################

# Set forecast horizon h, in hours.
horizon <- 48

# Load data

windTrain <- read_csv("data/windTrainSet.csv")

windTest <- read_csv("data/windTestSet.csv") %>% head(horizon)

# Create time series

freq <- c(24, 24*365.25) # Diurnal & Annual seasonality

windTrainTS <- msts(windTrain$windSpeed, freq, ts.frequency = freq[1])

# Shift the Test data in time to accomodate plotting. Start point is the
# same as the forecast objects. This does not truncate the series.
windTestTS <- ts(data = as.vector(head(windTest$windSpeed, horizon)),
                frequency = 24,
                start = c(746, 1)
)


## Notify that script's end has been reached ##
if (require(beepr)) {beepr::beep(1)}
