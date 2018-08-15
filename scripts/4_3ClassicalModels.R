# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Create the models for forecasting
#
# ##############################################################################

# Variables to hold the models themeselves are fitName
# (as in "fitted against the data").

# Variables for the predictions are forName, for "forecasts".

# ######################## ETS models ##########################################

fitETS <- ets(windTrainTS, lambda = NULL)

forETS <- forecast(fitETS, h = horizon, lambda = NULL)

fitETSBoxCoxAuto <- ets(windTrainTS, lambda = "auto")

forETSBoxCoxAuto <- forecast(fitETSBoxCoxAuto, h = horizon, biasadj = TRUE)

fitETSBoxCox <- ets(windTrainTS + 1, lambda = 0, biasadj = TRUE)

forETSBoxCox <- forecast(fitETSBoxCox, h = horizon, biasadj = TRUE)

# Back-adjust the addition of unity to box-cox
forETSBoxCox$mean <- forETSBoxCox$mean - 1
forETSBoxCox$upper <- forETSBoxCox$upper - 1
forETSBoxCox$lower <- forETSBoxCox$lower - 1

# ######################## ARIMA models ########################################

## Notify that script's end has been reached ##
if (require(beepr)) {beepr::beep(1)}
