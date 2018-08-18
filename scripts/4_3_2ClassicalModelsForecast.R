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
# ######################## ETS models ##########################################

# load the R objects containing the models

# ETS(A,A,A)
fitETS <- readRDS(file = "models/fitETS.RDS")

# ETS(A,N,A)
fitETSBoxCoxAuto <- readRDS(file = "models/fitETSBoxCoxAuto.RDS")

# ETS(A,Ad,A)
fitETSBoxCox <- readRDS(file = "models/fitETSBoxCox.RDS")

# forecast with each model

forETS <- fitETS %>% forecast(h = horizon)
forETSBoxCoxAuto <- fitETSBoxCoxAuto %>% forecast(h = horizon)
forETSBoxCox <- fitETSBoxCox %>% forecast(h = horizon)
forETSBoxCox$mean <- forETSBoxCox$mean - 1

# Accuracy

accuracyETS <- as.data.frame(accuracy(forETS, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracyETS,
            path = "./results/accuracyETS.csv",
            delim = ",")

rm(accuracyETS)

accuracyETS_BC_Auto <- as.data.frame(accuracy(forETSBoxCoxAuto, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracyETS_BC_Auto,
            path = "./results/accuracyETS_BC_Auto.csv",
            delim = ",")

rm(accuracyETS_BC_Auto)

accuracyETS_BC <- as.data.frame(accuracy(forETSBoxCox, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracyETS_BC,
            path = "./results/accuracyETS_BC.csv",
            delim = ",")

rm(accuracyETS_BC)

rm(fitETS, fitETSBoxCoxAuto, fitETSBoxCox)

# ######################## sARIMA models #######################################

# load the R objects containing the models

# ARIMA(2,1,0)(2,0,0)[24]
fitSARIMA <- readRDS(file = "models/fitSARIMA.RDS")

# ARIMA(2,1,0)(2,0,0)[24]
fitSARIMABoxCoxAuto <- readRDS(file = "models/fitSARIMABoxCoxAuto.RDS")

# ARIMA(0,1,2)(2,0,0)[24]
fitSARIMABoxCox <- readRDS(file = "models/fitSARIMABoxCox.RDS")

# forecast with each model

forSARIMA <- fitSARIMA %>% forecast(h = horizon)
forSARIMABoxCoxAuto <- fitSARIMABoxCoxAuto %>% forecast(h = horizon)
forSARIMABoxCox <- fitSARIMABoxCox %>% forecast(h = horizon)
forSARIMABoxCox$mean <- forSARIMABoxCox$mean - 1

# Accuracy

accuracySARIMA <- as.data.frame(accuracy(forSARIMA, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracySARIMA,
            path = "./results/accuracySARIMA.csv",
            delim = ",")

rm(accuracySARIMA)

accuracySARIMA_BC_Auto <- as.data.frame(accuracy(forSARIMABoxCoxAuto, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracySARIMA_BC_Auto,
            path = "./results/accuracySARIMA_BC_Auto.csv",
            delim = ",")

rm(accuracySARIMA_BC_Auto)

accuracySARIMA_BC <- as.data.frame(accuracy(forSARIMABoxCox, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracySARIMA_BC,
            path = "./results/accuracySARIMA_BC.csv",
            delim = ",")

rm(accuracySARIMA_BC)

rm(fitSARIMA, fitSARIMABoxCoxAuto, fitSARIMABoxCox)

# ######################## ARIMA models ########################################

# load the R objects containing the models

# ARIMA(0,1,5)
fitARIMA <- readRDS(file = "models/fitARIMA.RDS")

# ARIMA(0,1,5)
fitARIMABoxCoxAuto <- readRDS(file = "models/fitARIMABoxCoxAuto.RDS")

# ARIMA(0,1,5)
fitARIMABoxCox <- readRDS(file = "models/fitARIMABoxCox.RDS")

# forecast with each model

forARIMA <- fitARIMA %>% forecast(h = horizon)
forARIMABoxCoxAuto <- fitARIMABoxCoxAuto %>% forecast(h = horizon)
forARIMABoxCox <- fitARIMABoxCox %>% forecast(h = horizon)
forARIMABoxCox$mean <- forARIMABoxCox$mean - 1

# Accuracy

accuracyARIMA <- as.data.frame(accuracy(forARIMA, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracyARIMA,
            path = "./results/accuracyARIMA.csv",
            delim = ",")

rm(accuracyARIMA)

accuracyARIMA_BC_Auto <- as.data.frame(accuracy(forARIMABoxCoxAuto, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracyARIMA_BC_Auto,
            path = "./results/accuracyARIMA_BC_Auto.csv",
            delim = ",")

rm(accuracyARIMA_BC_Auto)

accuracyARIMA_BC <- as.data.frame(accuracy(forARIMABoxCox, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracyARIMA_BC,
            path = "./results/accuracyARIMA_BC.csv",
            delim = ",")

rm(accuracyARIMA_BC)

rm(fitARIMA, fitARIMABoxCoxAuto, fitARIMABoxCox)

# ######################## Collect results #####################################

# ETS

forClassicETS <- windTest
forClassicETS$ETS <- forETS$mean
forClassicETS$ETS_BC_Auto <- forETSBoxCoxAuto$mean
forClassicETS$ETS_BC <- forETSBoxCox$mean

rm(forETS, forETSBoxCoxAuto, forETSBoxCox)

# sARIMA
forClassicSARIMA <- windTest
forClassicSARIMA$SARIMA <- forSARIMA$mean
forClassicSARIMA$SARIMA_BC_Auto <- forSARIMABoxCoxAuto$mean
forClassicSARIMA$SARIMA_BC <- forSARIMABoxCox$mean

rm(forSARIMA, forSARIMABoxCoxAuto, forSARIMABoxCox)

# ARIMA
forClassicARIMA <- windTest
forClassicARIMA$ARIMA <- forARIMA$mean
forClassicARIMA$ARIMA_BC_Auto <- forARIMABoxCoxAuto$mean
forClassicARIMA$ARIMA_BC <- forARIMABoxCox$mean

rm(forARIMA, forARIMABoxCoxAuto, forARIMABoxCox)

write_delim(forClassicETS,
            path = "./results/forecastsClassicETS.csv",
            delim = ",")

write_delim(forClassicSARIMA,
            path = "./results/forecastsClassicSARIMA.csv",
            delim = ",")

write_delim(forClassicARIMA,
            path = "./results/forecastsClassicARIMA.csv",
            delim = ",")


# Plots
plotClassicETS <- melt(forClassicETS, id.vars = "dateTime") %>%
  ggplot(aes(x = dateTime, y = value, colour = variable)) +
  geom_line() + scale_color_nejm() +
  labs(subtitle = "Classical models: ETS",
       y = "Wind Speed (m/s)",
       x = "Time"
  ) +
  scale_x_datetime(date_labels = "%d/%m %H:%M") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_blank()
  )

plotClassicSARIMA <- melt(forClassicSARIMA, id.vars = "dateTime") %>%
  ggplot(aes(x = dateTime, y = value, colour = variable)) +
  geom_line() + scale_color_nejm() +
  labs(subtitle = "Classical models: sARIMA",
       y = "Wind Speed (m/s)",
       x = "Time"
  ) +
  scale_x_datetime(date_labels = "%d/%m %H:%M") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_blank()
  )

plotClassicARIMA <- melt(forClassicARIMA, id.vars = "dateTime") %>%
  ggplot(aes(x = dateTime, y = value, colour = variable)) +
  geom_line() + scale_color_nejm() +
  labs(subtitle = "Classical models: ARIMA",
       y = "Wind Speed (m/s)",
       x = "Time"
  ) +
  scale_x_datetime(date_labels = "%d/%m %H:%M") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_blank()
  )

saveA5(plotClassicETS, "forClassicETS", "H")
saveA5(plotClassicSARIMA, "forClassicSARIMA", "H")
saveA5(plotClassicARIMA, "forClassicARIMA", "H")

# Clean Up
rm(plotClassicETS, plotClassicARIMA, plotClassicSARIMA,
   forClassicETS, forClassicARIMA, forClassicSARIMA)
