# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Forecasting by naive models
#
# ##############################################################################

# Variables to hold the models themeselves are fitName
# (as in "fitted against the data").

# Variables for the predictions are forName, for "forecasts".


# ######################## Naive models ########################################

# Persistence
forPersist <- naive(windTrainTS, h = horizon)

# Mean (climatological)
forMean <- meanf(windTrainTS, h = horizon)

# Drift (random walk)
forDrift <- rwf(windTrainTS, h = horizon, drift = TRUE)

# Accuracy
accuracyPersist <- as.data.frame(accuracy(forPersist, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracyPersist,
            path = "./results/accuracyPersist.csv",
            delim = ",")

rm(accuracyPersist)

accuracyMean <- as.data.frame(accuracy(forMean, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracyMean,
            path = "./results/accuracyMean.csv",
            delim = ",")

rm(accuracyMean)

accuracyDrift <- as.data.frame(accuracy(forDrift, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracyDrift,
            path = "./results/accuracyDrift.csv",
            delim = ",")

rm(accuracyDrift)


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
                      lastValueTrain = windTrainTS[[length(windTrainTS)]],
                      mean = ACF * lastValueTrain + (1 - ACF) * meanTrain) %>%
  select(mean)
# forecasts are stored in forNewRed$mean, the choice of "mean" is for
# compatibility with the other methods in the "forecast" package.

# Create TS object from data frame (as the forecast package) and clean up
mean <- ts(data = as.vector(forNewRef$mean),
           frequency = 24,
           start = c(746,1)
           )

# Use lower and upper bounds from the mean forecasts, as an indication
forNewRef <- list(dataFrame = forNewRef, mean = mean,
                  lower = forMean$lower, upper = forMean$upper)

rm(mean)

# Accuracy
accuracyNewRef <- as.data.frame(accuracy(forNewRef$mean, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracyNewRef,
            path = "./results/accuracyNewRef.csv",
            delim = ",")

rm(accuracyNewRef)

# ######################## Collect results #####################################

forNaive <- windTest
forNaive$mean <- forMean$mean
forNaive$drift <- forDrift$mean
forNaive$persist <- forPersist$mean
forNaive$newRef <- forNewRef$mean

rm(forNewRef,forDrift, forMean, forPersist)

write_delim(forNaive,
            path = "./results/forecastsNaive.csv",
            delim = ",")

# Plot

plotNaive <- melt(forNaive, id.vars = "dateTime") %>%
  ggplot(aes(x = dateTime, y = value, colour = variable)) +
  geom_line() + scale_color_nejm() +
  labs(subtitle = "Naive models",
       y = "Wind Speed (m/s)",
       x = "Time"
       ) +
  scale_x_datetime(date_labels = "%d/%m %H:%M") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_blank()
        )

saveA5(plotNaive, "forNaive", "H")

rm(plotNaive, forNaive)
