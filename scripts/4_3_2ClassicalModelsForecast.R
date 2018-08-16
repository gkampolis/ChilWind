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
