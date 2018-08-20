# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Create a combination model based on the best performing previous
# model (ETS) and with the only model to have a negative Mean Error, the ETS
# with the 2-parameter Box-Cox transformation.
#
# ##############################################################################
#
# Naming scheme: Variables to hold the models themeselves are fitName
# (as in "fitted against the data"). Variables for the predictions are forName,
# for "forecasts".
#
# ##############################################################################

# Load models
fitETS <- readRDS(file = "models/fitETS.RDS")
fitETS2BC <- readRDS(file = "models/fitETSBoxCox.RDS")

# Forecast
forETS <- fitETS %>% forecast(h = horizon)
forETS2BC <- fitETS2BC %>% forecast(h = horizon)
forETS2BC$mean <- forETS2BC$mean - 1

rm(fitETS, fitETS2BC)

# Ensemble
forCombo <- (0.75 * forETS$mean + 0.25 * forETS2BC$mean)

# Accuracy
accuracyCombo <- as.data.frame(accuracy(forCombo, windTestTS)) %>%
  select(ME, RMSE, MAE, MPE, MAPE)

write_delim(accuracyCombo,
            path = "./results/accuracyCombo.csv",
            delim = ",")

rm(accuracyCombo)

# Collect results

resultsCombo <- windTest
resultsCombo$ETS <- forETS$mean
resultsCombo$ETS_BC <- forETS2BC$mean
resultsCombo$Combination <- forCombo

rm(forETS, forETS2BC, forCombo)

write_delim(resultsCombo,
            path = "./results/forecastsCombination.csv",
            delim = ",")

# Plot

plotCombo <- melt(resultsCombo, id.vars = "dateTime") %>%
  ggplot(aes(x = dateTime, y = value, colour = variable)) +
  geom_line() + scale_color_nejm() +
  labs(subtitle = "ETS and combination",
       y = "Wind Speed (m/s)",
       x = "Time"
  ) +
  scale_x_datetime(date_labels = "%d/%m %H:%M") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position = "bottom",
        legend.title = element_blank(),
        axis.title.x = element_blank()
  )

saveA5(plotCombo, "forCombination", "H")

# Clean up
rm(plotCombo, resultsCombo)
