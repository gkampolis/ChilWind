# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Create the classical models for forecasting. Note that the
# forecasting itself takes place at a different script (see Main.R at the root
# of the project) to avoid excessively long and complicated scripts and help
# ease code maintenance.
#
# ##############################################################################
#
# Naming scheme: Variables to hold the models themeselves are fitName
# (as in "fitted against the data"). Variables for the predictions are forName,
# for "forecasts".
#
# ######################## ETS models ##########################################

fitETS <- ets(ts(as.vector(windTrainTS),frequency = 24),
              lambda = NULL)

saveRDS(fitETS, file = "models/fitETS.RDS")
rm(fitETS)

fitETSBoxCoxAuto <- ets(ts(as.vector(windTrainTS),frequency = 24),
                        lambda = "auto")

saveRDS(fitETSBoxCoxAuto, file = "models/fitETSBoxCoxAuto.RDS")
rm(fitETSBoxCoxAuto)

fitETSBoxCox <- ets(ts(as.vector(windTrainTS + 1),frequency = 24),
                    lambda = 0, biasadj = TRUE)

saveRDS(fitETSBoxCox, file = "models/fitETSBoxCox.RDS")
rm(fitETSBoxCox)

# ######################## sARIMA models #######################################

fitSARIMA <- auto.arima(ts(as.vector(windTrainTS),frequency = 24),
                        stepwise = TRUE)

saveRDS(fitSARIMA, file = "models/fitSARIMA.RDS")

rm(fitSARIMA)


fitSARIMABoxCoxAuto <- auto.arima(ts(as.vector(windTrainTS),frequency = 24),
                        stepwise = TRUE, lambda = "auto", biasadj = TRUE)

saveRDS(fitSARIMABoxCoxAuto, file = "models/fitSARIMABoxCoxAuto.RDS")

rm(fitSARIMABoxCoxAuto)


fitSARIMABoxCox <- auto.arima(ts(as.vector(windTrainTS + 1),frequency = 24),
                                  stepwise = TRUE, lambda = 0, biasadj = TRUE)

saveRDS(fitSARIMABoxCox, file = "models/fitSARIMABoxCox.RDS")

rm(fitSARIMABoxCox)

# ######################## ARIMA models ########################################

fitARIMA <- auto.arima(ts(as.vector(windTrainTS),frequency = 24),
                       seasonal = FALSE, stepwise = FALSE,
                       parallel = TRUE, num.cores = 4)

saveRDS(fitARIMA, file = "models/fitARIMA.RDS")
rm(fitARIMA)

fitARIMABoxCoxAuto <- auto.arima(ts(as.vector(windTrainTS),frequency = 24),
                       seasonal = FALSE, stepwise = FALSE, lambda = "auto",
                       biasadj = TRUE, parallel = TRUE, num.cores = 4)

saveRDS(fitARIMABoxCoxAuto, file = "models/fitARIMABoxCoxAuto.RDS")
rm(fitARIMABoxCoxAuto)

fitARIMABoxCox <- auto.arima(ts(as.vector(windTrainTS + 1),frequency = 24),
                                 seasonal = FALSE, stepwise = FALSE, lambda = 0,
                                 biasadj = TRUE, parallel = TRUE, num.cores = 4)

saveRDS(fitARIMABoxCox, file = "models/fitARIMABoxCox.RDS")
rm(fitARIMABoxCox)

## Notify that script's end has been reached ##
if (require(beepr)) {beepr::beep(1)}
