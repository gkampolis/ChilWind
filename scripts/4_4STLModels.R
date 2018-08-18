# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Forecasting by STL decomposition and simple models
#
# ##############################################################################

# Variables to hold the models themeselves are fitName
# (as in "fitted against the data").

# Variables for the predictions are forName, for "forecasts".


# ######################## STL-Naive forecasts #################################

forSTLN <- stlf(windTrainTS, h = horizon, method = "naive")
forSTLNBoxCoxAuto <- stlf(windTrainTS, h = horizon,
                          method = "naive", lambda = "auto")
forSTLNBoxCox <- stlf(windTrainTS + 1, h = horizon, method = "naive", lambda = 0)
forSTLNBoxCox$mean <- forSTLNBoxCox$mean - 1

# Accuracy

accuracySTLN <- as.data.frame(accuracy(forSTLN, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracySTLN,
            path = "./results/accuracySTLN.csv",
            delim = ",")

rm(accuracySTLN)

accuracySTLN_BC_Auto <- as.data.frame(accuracy(forSTLNBoxCoxAuto, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracySTLN_BC_Auto,
            path = "./results/accuracySTLN_BC_Auto.csv",
            delim = ",")

rm(accuracySTLN_BC_Auto)

accuracySTLN_BC <- as.data.frame(accuracy(forSTLNBoxCox, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracySTLN_BC,
            path = "./results/accuracySTLN_BC.csv",
            delim = ",")

rm(accuracySTLN_BC)

# ######################## STL-ETS forecasts ###################################

# ETS(A,N,N)
forSTLETS <- stlf(windTrainTS, h = horizon, method = "ets")

# ETS(A,N,N)
forSTLETSBoxCoxAuto <- stlf(windTrainTS, h = horizon,
                          method = "ets", lambda = "auto")

# ETS(A,N,N)
forSTLETSBoxCox <- stlf(windTrainTS + 1, h = horizon, method = "ets", lambda = 0)
forSTLETSBoxCox$mean <- forSTLETSBoxCox$mean - 1

# Accuracy

accuracySTLETS <- as.data.frame(accuracy(forSTLETS, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracySTLETS,
            path = "./results/accuracySTLETS.csv",
            delim = ",")

rm(accuracySTLETS)

accuracySTLETS_BC_Auto <- as.data.frame(accuracy(forSTLETSBoxCoxAuto, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracySTLETS_BC_Auto,
            path = "./results/accuracySTLETS_BC_Auto.csv",
            delim = ",")

rm(accuracySTLETS_BC_Auto)

accuracySTLETS_BC <- as.data.frame(accuracy(forSTLETSBoxCox, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracySTLETS_BC,
            path = "./results/accuracySTLETS_BC.csv",
            delim = ",")

rm(accuracySTLETS_BC)

# ######################## STL-ARIMA forecasts #################################

# ARIMA(0,1,3)
forSTLARIMA <- stlf(windTrainTS, h = horizon, method = "arima")

# ARIMA(3,1,0)
forSTLARIMABoxCoxAuto <- stlf(windTrainTS, h = horizon,
                            method = "arima", lambda = "auto")

# ARIMA(1,1,2)
forSTLARIMABoxCox <- stlf(windTrainTS + 1, h = horizon, method = "arima", lambda = 0)
forSTLARIMABoxCox$mean <- forSTLARIMABoxCox$mean - 1

# Accuracy

accuracySTLARIMA <- as.data.frame(accuracy(forSTLARIMA, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracySTLARIMA,
            path = "./results/accuracySTLARIMA.csv",
            delim = ",")

rm(accuracySTLARIMA)

accuracySTLARIMA_BC_Auto <- as.data.frame(accuracy(forSTLARIMABoxCoxAuto, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracySTLARIMA_BC_Auto,
            path = "./results/accuracySTLARIMA_BC_Auto.csv",
            delim = ",")

rm(accuracySTLARIMA_BC_Auto)

accuracySTLARIMA_BC <- as.data.frame(accuracy(forSTLARIMABoxCox, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracySTLARIMA_BC,
            path = "./results/accuracySTLARIMA_BC.csv",
            delim = ",")

rm(accuracySTLARIMA_BC)


# ######################## Collect results #####################################

# STL + Naive

forSTLnaive <- windTest
forSTLnaive$STLN <- forSTLN$mean
forSTLnaive$STLN_BC_Auto <- forSTLNBoxCoxAuto$mean
forSTLnaive$STLN_BC <- forSTLNBoxCox$mean

# STL + ETS

forSTLets <- windTest
forSTLets$STLETS <- forSTLETS$mean
forSTLets$STLETS_BC_Auto <- forSTLETSBoxCoxAuto$mean
forSTLets$STLETS_BC <- forSTLETSBoxCox$mean

# STL + ARIMA

forSTLarima <- windTest
forSTLarima$STLARIMA <- forSTLARIMA$mean
forSTLarima$STLARIMA_BC_Auto <- forSTLARIMABoxCoxAuto$mean
forSTLarima$STLARIMA_BC <- forSTLARIMABoxCox$mean

write_delim(forSTLnaive,
            path = "./results/forecastsSTLnaive.csv",
            delim = ",")

write_delim(forSTLets,
            path = "./results/forecastsSTLets.csv",
            delim = ",")

write_delim(forSTLarima,
            path = "./results/forecastsSTLarima.csv",
            delim = ",")

rm(forSTLN, forSTLNBoxCoxAuto, forSTLNBoxCox,
   forSTLETS, forSTLETSBoxCoxAuto, forSTLETSBoxCox,
   forSTLARIMA, forSTLARIMABoxCoxAuto, forSTLARIMABoxCox
)

# Plots
plotSTLnaive <- melt(forSTLnaive, id.vars = "dateTime") %>%
  ggplot(aes(x = dateTime, y = value, colour = variable)) +
  geom_line() + scale_color_nejm() +
  labs(subtitle = "STL decomposition models: Naive",
       y = "Wind Speed (m/s)",
       x = "Time"
  ) +
  scale_x_datetime(date_labels = "%d/%m %H:%M") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_blank()
  )

plotSTLets <- melt(forSTLets, id.vars = "dateTime") %>%
  ggplot(aes(x = dateTime, y = value, colour = variable)) +
  geom_line() + scale_color_nejm() +
  labs(subtitle = "STL decomposition models: ETS",
       y = "Wind Speed (m/s)",
       x = "Time"
  ) +
  scale_x_datetime(date_labels = "%d/%m %H:%M") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_blank()
  )

plotSTLarima <- melt(forSTLarima, id.vars = "dateTime") %>%
  ggplot(aes(x = dateTime, y = value, colour = variable)) +
  geom_line() + scale_color_nejm() +
  labs(subtitle = "STL decomposition models: ARIMA",
       y = "Wind Speed (m/s)",
       x = "Time"
  ) +
  scale_x_datetime(date_labels = "%d/%m %H:%M") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_blank()
  ) +
  guides(colour = guide_legend(nrow = 2))

saveA5(plotSTLnaive, "forSTLnaive", "H")
saveA5(plotSTLets, "forSTLets", "H")
saveA5(plotSTLarima, "forSTLarima", "H")

rm(plotSTLnaive, plotSTLets, plotSTLarima,
   forSTLnaive, forSTLets, forSTLarima)
