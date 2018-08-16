# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Create the models for forecasting
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

# Naive w/ Drift (random walk)
forDrift <- rwf(windTrainTS, h = horizon, drift = TRUE)

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
           frequency = 24
           )

# Use lower and upper bounds from the mean forecasts, as an indication
forNewRef <- list(dataFrame = forNewRef, mean = mean,
                  lower = forMean$lower, upper = forMean$upper)

rm(mean)


# ######################## Collect results #####################################

forNaive <- windTest
forNaive$mean <- forMean$mean
forNaive$drift <- forDrift$mean
forNaive$persist <- forPersist$mean
forNaive$newRef <- forNewRef$mean

rm(forNewRef,forDrift, forMean, forPersist)

accuracyNaive <- as.data.frame(names(forNaive)[3:6])
names(accuracyNaive) <- "Method"
temp <- data.frame()
temp <- as.data.frame(accuracy(forNaive$mean, forNaive$windSpeed))
temp <- rbind(temp, as.data.frame(accuracy(forNaive$drift, forNaive$windSpeed)))
temp <- rbind(temp, as.data.frame(accuracy(forNaive$persist, forNaive$windSpeed)))
temp <- rbind(temp, as.data.frame(accuracy(forNaive$newRef, forNaive$windSpeed)))

accuracyNaive <- cbind(accuracyNaive, temp)
rownames(accuracyNaive) <- NULL
rm(temp)

write_delim(forNaive,
            path = "./results/forecastsNaive.csv",
            delim = ",")

write_delim(accuracyNaive,
            path = "./results/accuracyNaive.csv",
            delim = ",")

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
rm(plotNaive, forNaive, accuracyNaive)
