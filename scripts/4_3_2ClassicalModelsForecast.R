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

# ######################## Collect results #####################################

# ETS

forClassicETS <- windTest
forClassicETS$ETS <- forETS$mean
forClassicETS$ETS_BC_Auto <- forETSBoxCoxAuto$mean
forClassicETS$ETS_BC <- forETSBoxCox$mean - 1

# sARIMA
forClassicSARIMA <- windTest
forClassicSARIMA$SARIMA <- forSARIMA$mean
forClassicSARIMA$SARIMA_BC_Auto <- forSARIMABoxCoxAuto$mean
forClassicSARIMA$SARIMA_BC <- forSARIMABoxCox$mean - 1

# ARIMA
forClassicARIMA <- windTest
forClassicARIMA$ARIMA <- forARIMA$mean
forClassicARIMA$ARIMA_BC_Auto <- forARIMABoxCoxAuto$mean
forClassicARIMA$ARIMA_BC <- forARIMABoxCox$mean - 1

write_delim(forClassicETS,
            path = "./results/forecastsClassicETS.csv",
            delim = ",")

write_delim(forClassicSARIMA,
            path = "./results/forecastsClassicSARIMA.csv",
            delim = ",")

write_delim(forClassicARIMA,
            path = "./results/forecastsClassicARIMA.csv",
            delim = ",")

# Accuracy ETS

accuracyClassicETS <- as.data.frame(names(forClassicETS)[3:5])
names(accuracyClassicETS) <- "Model"
temp <- data.frame()
temp <- as.data.frame(accuracy(forClassicETS$ETS, forClassicETS$windSpeed))
temp <- rbind(temp, as.data.frame(accuracy(forClassicETS$ETS_BC_Auto, forClassicETS$windSpeed)))
temp <- rbind(temp, as.data.frame(accuracy(forClassicETS$ETS_BC, forClassicETS$windSpeed)))

accuracyClassicETS <- cbind(accuracyClassicETS, temp)
rownames(accuracyClassicETS) <- NULL
rm(temp)

# Accuracy sARIMA

accuracyClassicSARIMA <- as.data.frame(names(forClassicSARIMA)[3:5])
names(accuracyClassicSARIMA) <- "Model"
temp <- data.frame()
temp <- as.data.frame(accuracy(forClassicSARIMA$SARIMA, forClassicSARIMA$windSpeed))
temp <- rbind(temp, as.data.frame(accuracy(forClassicSARIMA$SARIMA_BC_Auto, forClassicSARIMA$windSpeed)))
temp <- rbind(temp, as.data.frame(accuracy(forClassicSARIMA$SARIMA_BC, forClassicSARIMA$windSpeed)))

accuracyClassicSARIMA <- cbind(accuracyClassicSARIMA, temp)
rownames(accuracyClassicSARIMA) <- NULL
rm(temp)

# Accuracy ARIMA

accuracyClassicARIMA <- as.data.frame(names(forClassicARIMA)[3:5])
names(accuracyClassicARIMA) <- "Model"
temp <- data.frame()
temp <- as.data.frame(accuracy(forClassicARIMA$ARIMA, forClassicARIMA$windSpeed))
temp <- rbind(temp, as.data.frame(accuracy(forClassicARIMA$ARIMA_BC_Auto, forClassicARIMA$windSpeed)))
temp <- rbind(temp, as.data.frame(accuracy(forClassicARIMA$ARIMA_BC, forClassicARIMA$windSpeed)))

accuracyClassicARIMA <- cbind(accuracyClassicARIMA, temp)
rownames(accuracyClassicARIMA) <- NULL
rm(temp)

write_delim(accuracyClassicETS,
            path = "./results/accuracyClassicETS.csv",
            delim = ",")

write_delim(accuracyClassicSARIMA,
            path = "./results/accuracyClassicSARIMA.csv",
            delim = ",")

write_delim(accuracyClassicARIMA,
            path = "./results/accuracyClassicARIMA.csv",
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
rm(plotClassicETS, plotClassicARIMA, plotClassicSARIMA, fitARIMA,
   fitARIMABoxCoxAuto, fitARIMABoxCox, fitETS, fitETSBoxCoxAuto,
   fitETSBoxCox, fitSARIMA, fitSARIMABoxCoxAuto, fitSARIMABoxCox,
   forARIMA, forARIMABoxCoxAuto, forARIMABoxCox, forETS,
   forETSBoxCoxAuto, forETSBoxCox, forSARIMA, forSARIMABoxCoxAuto,
   forSARIMABoxCox, forClassicARIMA, forClassicETS, forClassicSARIMA,
   accuracyClassicARIMA, accuracyClassicETS, accuracyClassicSARIMA)
