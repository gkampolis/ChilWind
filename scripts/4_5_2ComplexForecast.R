# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Forecast with the classical models. Note that the model-building
# itself takes place at a different script (see Main.R at the root of the
# project) to avoid excessively long and complicated scripts and help ease code
# maintenance.
#
# ##############################################################################
#
# Naming scheme: Variables to hold the models themeselves are fitName
# (as in "fitted against the data"). Variables for the predictions are forName,
# for "forecasts".
#
# ######################## TBATS model #########################################

# Load the R object containing the model

fitTBATS <- readRDS(file = "models/fitTBATS.RDS")

# Forecast
forecastsTBATS <- forecast(fitTBATS, h = horizon)

# Collect results
forTBATS <- windTest
forTBATS$TBATS <- forecastsTBATS$mean

accuracyTBATS <- as.data.frame(accuracy(forecastsTBATS, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

rm(forecastsTBATS, fitTBATS)

write_delim(forTBATS,
            path = "./results/forecastsTBATS.csv",
            delim = ",")

write_delim(accuracyTBATS,
            path = "./results/accuracyTBATS.csv",
            delim = ",")

rm(accuracyTBATS)

# Plot

plotTBATS <- melt(forTBATS, id.vars = "dateTime") %>%
  ggplot(aes(x = dateTime, y = value, colour = variable)) +
  geom_line() + scale_color_nejm() +
  labs(subtitle = "Complex models: TBATS",
       y = "Wind Speed (m/s)",
       x = "Time"
  ) +
  scale_x_datetime(date_labels = "%d/%m %H:%M") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_blank()
  )

saveA5(plotTBATS, "forTBATS", "H")

rm(forTBATS, plotTBATS)

# ######################## ANN model #########################################

# Load the R objects containing the models

fitANN <- readRDS(file = "models/fitANN.RDS")
fitANNunscaled <- readRDS(file = "models/fitANNunscaled.RDS")

# Forecast
forecastsANN <- forecast(fitANN, h = horizon)
forecastsANNunscaled <- forecast(fitANNunscaled, h = horizon)

# Collect results
forANN <- windTest
forANN$NNAR <- forecastsANN$mean
forANN$NNAR_Unscaled <- forecastsANNunscaled$mean

accuracyANN <- as.data.frame(accuracy(forecastsANN, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

accuracyANNunscaled <- as.data.frame(accuracy(forecastsANNunscaled, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)


rm(forecastsANN, fitANN,
   forecastsANNunscaled, fitANNunscaled)

write_delim(forANN,
            path = "./results/forecastsANN.csv",
            delim = ",")

write_delim(accuracyANN,
            path = "./results/accuracyANN.csv",
            delim = ",")

write_delim(accuracyANNunscaled,
            path = "./results/accuracyANNunscaled.csv",
            delim = ",")

rm(accuracyANN, accuracyANNunscaled)

# Plot

plotANN <- melt(forANN, id.vars = "dateTime") %>%
  ggplot(aes(x = dateTime, y = value, colour = variable)) +
  geom_line() + scale_color_nejm() +
  labs(subtitle = "Complex models: ANN",
       y = "Wind Speed (m/s)",
       x = "Time"
  ) +
  scale_x_datetime(date_labels = "%d/%m %H:%M") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_blank()
  )

saveA5(plotANN, "forANN", "H")

rm(plotANN, forANN)
