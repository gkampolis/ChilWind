# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Loads the hourly wind speed data set for EDA.
# Returns both data frame and msts objects.
#
# ##############################################################################

wind <- read_csv("data/windTrainSet.csv")

# Create time series

freq <- c(24, 24*365.25) # Diurnal & Annual seasonality

windTS <- msts(wind$windSpeed, freq, ts.frequency = freq[1])
