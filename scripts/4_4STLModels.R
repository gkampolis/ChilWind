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


# ######################## STL-ETS forecasts ###################################

# ETS(A,N,N)
forSTLETS <- stlf(windTrainTS, h = horizon, method = "ets")

# ETS(A,N,N)
forSTLETSBoxCoxAuto <- stlf(windTrainTS, h = horizon,
                          method = "ets", lambda = "auto")

# ETS(A,N,N)
forSTLETSBoxCox <- stlf(windTrainTS + 1, h = horizon, method = "ets", lambda = 0)
forSTLETSBoxCox$mean <- forSTLETSBoxCox$mean - 1

# ######################## STL-ARIMA forecasts #################################

# ARIMA(0,1,3)
forSTLARIMA <- stlf(windTrainTS, h = horizon, method = "arima")

# ARIMA(3,1,0)
forSTLARIMABoxCoxAuto <- stlf(windTrainTS, h = horizon,
                            method = "arima", lambda = "auto")

# ARIMA(1,1,2)
forSTLARIMABoxCox <- stlf(windTrainTS + 1, h = horizon, method = "arima", lambda = 0)
forSTLARIMABoxCox$mean <- forSTLARIMABoxCox$mean - 1

# ######################## Collect results #####################################

# STL + Naive

forSTLnaive <- windTest
forSTLnaive$STLN <- forSTLN$mean
forSTLnaive$STLN_BC_Auto <- forSTLNBoxCoxAuto$mean
forSTLnaive$STLN_BC <- forSTLNBoxCox$mean

rm(forSTLN, forSTLNBoxCoxAuto, forSTLNBoxCox)

# STL + ETS

forSTLets <- windTest
forSTLets$STLETS <- forSTLETS$mean
forSTLets$STLETS_BC_Auto <- forSTLETSBoxCoxAuto$mean
forSTLets$STLETS_BC <- forSTLETSBoxCox$mean

rm(forSTLETS, forSTLETSBoxCoxAuto, forSTLETSBoxCox)

# STL + ARIMA

forSTLarima <- windTest
forSTLarima$STLARIMA <- forSTLARIMA$mean
forSTLarima$STLARIMA_BC_Auto <- forSTLARIMABoxCoxAuto$mean
forSTLarima$STLARIMA_BC <- forSTLARIMABoxCox$mean

rm(forSTLARIMA, forSTLARIMABoxCoxAuto, forSTLARIMABoxCox)

write_delim(forSTLnaive,
            path = "./results/forecastsSTLnaive.csv",
            delim = ",")

write_delim(forSTLets,
            path = "./results/forecastsSTLets.csv",
            delim = ",")

write_delim(forSTLarima,
            path = "./results/forecastsSTLarima.csv",
            delim = ",")


# Accuracy STL + Naive

accuracySTLnaive <- as.data.frame(names(forSTLnaive)[3:5])
names(accuracySTLnaive) <- "Model"
temp <- data.frame()
temp <- as.data.frame(accuracy(forSTLnaive$STLN, forSTLnaive$windSpeed))
temp <- rbind(temp,
              as.data.frame(
                accuracy(forSTLnaive$STLN_BC_Auto, forSTLnaive$windSpeed
                         )
                )
              )
temp <- rbind(temp,
              as.data.frame(
                accuracy(forSTLnaive$STLN_BC, forSTLnaive$windSpeed
                         )
                )
              )

accuracySTLnaive <- cbind(accuracySTLnaive, temp)
rownames(accuracySTLnaive) <- NULL
rm(temp)

# Accuracy STL + ETS

accuracySTLets <- as.data.frame(names(forSTLets)[3:5])
names(accuracySTLets) <- "Model"
temp <- data.frame()
temp <- as.data.frame(accuracy(forSTLets$STLETS, forSTLets$windSpeed))
temp <- rbind(temp,
              as.data.frame(
                accuracy(forSTLets$STLETS_BC_Auto, forSTLets$windSpeed
                         )
                )
              )
temp <- rbind(temp,
              as.data.frame(
                accuracy(forSTLets$STLETS_BC, forSTLets$windSpeed
                         )
                )
              )

accuracySTLets <- cbind(accuracySTLets, temp)
rownames(accuracySTLets) <- NULL
rm(temp)


# Accuracy STL + ARIMA

accuracySTLarima <- as.data.frame(names(forSTLarima)[3:5])
names(accuracySTLarima) <- "Model"
temp <- data.frame()
temp <- as.data.frame(accuracy(forSTLarima$STLARIMA, forSTLarima$windSpeed))
temp <- rbind(temp,
              as.data.frame(
                accuracy(forSTLarima$STLARIMA_BC_Auto, forSTLarima$windSpeed
                )
              )
)
temp <- rbind(temp,
              as.data.frame(
                accuracy(forSTLarima$STLARIMA_BC, forSTLarima$windSpeed
                )
              )
)

accuracySTLarima <- cbind(accuracySTLarima, temp)
rownames(accuracySTLarima) <- NULL
rm(temp)

write_delim(accuracySTLnaive,
            path = "./results/accuracySTLnaive.csv",
            delim = ",")

write_delim(accuracySTLets,
            path = "./results/accuracySTLets.csv",
            delim = ",")

write_delim(accuracySTLarima,
            path = "./results/accuracySTLarima.csv",
            delim = ",")

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
   accuracySTLnaive, accuracySTLets, accuracySTLarima,
   forSTLnaive, forSTLets, forSTLarima)
