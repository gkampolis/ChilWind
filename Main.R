# ##############################################################################
# Author: Georgios Kampolis
#
# Description: This is the main master script for Kampolis' MSc Project, partial
# requirement for the degree of MSc in Renewable Energy and Environmental
# Modelling at the University of Dundee.
#
# Running this script will enable the reproduction all of the results obtained
# and presented in the written project report.
#
# ##############################################################################

################################ Initialisation ################################

here::here() # Sets working directory at the level of the .Rproj file.

# Sets a seed for reproducibility reasons re: methods incorporating randomness
set.seed(42)

# Loads packages, global ggplot2 theme and ensures explicitly
# select() corresponds to dplyr's implementation.
source("scripts/1Init.R")

# Load custom function to quickly save in A5 size.
source("scripts/fun/saveA5.R")

################################ Pre-Processing ################################

# If you want to recreate the initial csv file from the original .nc files,
# uncomment line no. 31. Do note that the package ncdf4 is required and that
# for most moemory efficient usage, the R session should be closed after
# creating the csv but before proceeding, due to ncdf4 not clossing the
# connection to the .nc files properly (they're still loaded and used by the R
# process).
# source("scripts/2_1LoadNC.R)


# Loads the data set, and creates hourly values by aggregating means (by
# utilizing na.rm=TRUE option of the mean() function).
# Resulting data set still has NAs, for the cases where the vector passed
# to mean() is comprised entirely by NAs.
# source("scripts/2_2CreateHourlyDF.R)

# Loads the hourly data set, splits into training and test sets and
# imputes NAs in the training set by linear interpolationand taking
# into account seasonality by robust STL decomposition.
# Also creates relevant plots by loading the original set and showing both the
# effects of hourly conversion and of the imputation.
# source("scripts/2_3Impute_NAs.R")

########################## Exploratory Data Analysis ###########################

# Create wind roses plot
# source("scripts/3_1WindRoses.R")

# Load the data set to be used throughout EDA, in data frame and msts objects.
# source("scripts/3_2EDAload.R")

# Create initial box plots, to explore seasonality
# source("scripts/3_3EDABoxPlot.R")

# Compare Box-Cox transformation options
# source("scripts/3_4BoxCox.R")

# Explore decomposition methods options
# source("scripts/3_5Decomp.R")

# ACF and PACF plots
# source("scripts/3_6ACF.R")

# Explore the effects of differencing.
# source("scripts/3_7Diff.R")

# Unload data set to make section autonomous
# rm(wind, freq, windTS)

######################## Model Building and Forecasting ########################

# Load test and train sets and set the forecast horizon
source("scripts/4_1Load.R")

# The "naive" category: Persistence, Mean clima, New Reference, and variations
source("scripts/4_2NaiveModels.R")

# The "classical" category: ETS and ARIMA with variations
source("scripts/4_3_1ClassicalModelsTrain.R")
source("scripts/4_3_2ClassicalModelsForecast.R")

# The STL category: STL-naive, STL-ETS, STL-ARIMA
source("scripts/4_4STLModels.R")

# The complex category: Artificial Neural Network and TBATS
source("scripts/4_5_1ComplexTrain.R")
source("scripts/4_5_2ComplexForecast.R")

# Ensemble models
source("scripts/4_6Ensemble.R")

# Clean up objects from 4_1Load.R
rm(windTest, windTrain,
   windTestTS, windTrainTS,
   freq, horizon)

######################## Clean up custom functions #############################
rm(saveA5, select)
