# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Create the models for forecasting
#
# ##############################################################################

# Set forecast horizon h
horizon <- length(windTestTS)

# Variables to hold the models themeselves are fitName
# (as in "fitted against the data").

# Variables for the predictions are forName, for "forecasts".


# ######################## Naive models ########################################

# Persistence
forPersist <- naive(windTrainTS, h = horizon)

# Mean (climatological)
forMean <- meanf(windTrainTS, h = horizon)

# Naive w/ Drift (random walk)
forDrift <- rwf(windTrainTS, h = horizon, drift = TRUE)

# Seasonal Naive, diurnal only
forSNaive <- snaive(windTrainTS, h = horizon)

# ######################## New Reference #######################################
calcACF <- acf(windTrainTS, lag.max = horizon, plot = FALSE)$acf

# The above includes unity at last value, for forecasting we need the rest.
# Also, ACF can take negative values, values less tahn zero are replaced with
# zero.
calcACF <- calcACF[2:length(calcACF)] # drop first value

forNewRef <- as.data.frame(calcACF)
rm(calcACF)

# replace negatives with 0
forNewRef %<>%
  mutate(ACF = ifelse(calcACF < 0, 0, calcACF),
                      meanTrain = mean(windTrainTS),
                      lastValueTrain = windTestTS[[length(windTestTS)]],
                      mean = ACF * lastValueTrain + (1 - ACF) * meanTrain) %>%
  select(mean)
# forecasts are stored in forNewRed$mean, the choice of "mean" is for
# compatibility with the other methods in the "forecast" package.

# Create TS object from data frame (as the forecast package) and clean up
mean <- ts(data = as.vector(forNewRef$mean),
           frequency = 24
           )

forNewRef <- list(dataFrame = forNewRef, mean = mean)

rm(mean)
