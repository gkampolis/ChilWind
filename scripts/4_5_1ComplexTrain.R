# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Forecasting by TBATS
#
# ##############################################################################
#
# Variables to hold the models themeselves are fitName
# (as in "fitted against the data").
#
# Variables for the predictions are forName, for "forecasts".
#
# ##############################################################################

# Train
fitTBATS <- tbats(windTrainTS, num.cores = 4, biasadj = TRUE)
saveRDS(fitTBATS, file = "models/fitTBATS.RDS")
rm(fitTBATS)

# TBATS(0.671, {1,1}, -, {<24,3>, <8766,1>})
# 0.671 the Lambda of the Box-Cox transformation
# {1,1} the ARMA process for the errors, ARMA(1,1)
#  - no damping parameter was used
# {<24,3>, <8766,1>} 3 Fourier terms to describe seasonality of 24 (diurnal)
# and 1 Fourier term to describe seasonality of 8766 (annual)

fitANN <- nnetar(windTrainTS)
saveRDS(fitANN, file = "models/fitANN.RDS")

# NNAR(27,1,14)[24]
# Average of 20 networks, each of which
# is a network with 27 lagged inputs and
# 1 hidden layer with 14 neurons.

fitANNunscaled <- nnetar(windTrainTS, scale.inputs = FALSE)
saveRDS(fitANNunscaled, file = "models/fitANNunscaled.RDS")

# NNAR(41,1,21)[24]
# Average of 20 networks, each of which
# is a network with 41 lagged inputs and
# 1 hidden layer with 21 neurons.


## Notify that script's end has been reached ##
if (require(beepr)) {beepr::beep(1)}
