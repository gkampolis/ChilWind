# ChilWind: Forecasting wind speeds at Chilbolton, UK.
A repository to host the data analysis required for my MSc project for Renewable Energy and Environmental Modelling at the University of Dundee. Released under the [MIT License](https://github.com/gkampolis/Chilbolton/blob/master/LICENSE.md). A full write-up is coming soon. Easiest way to replicate the analysis is to open Rstudio by double-clicking the `ChilWind.Rproj` and then go through the `Main.R` script. Small tweaks are still needed here and there, but this is close to final.

## Data Provenance

Data was collected by the Chilbolton Facility for Atmospheric and Radio Research (CFARR), located at Hampshire, UK. The data set is available (and continuously updated) online at the CEDA Archive [here](http://catalogue.ceda.ac.uk/uuid/bf49f0ad8afe1eff425346777c590146) and released under the Open Government Licence for public sector information, a copy of which can be found [here](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/) and is also included in `.pdf` form in the data folder of this repository.

## Overview
Please note that a write up more suited to this repository as a stand-alone project will be posted soon. For the moment, the following information should give enough context and serve as an overview.

### Introduction

Several applications exist for wind forecasting including load balancing operations, scheduling optimization for conventional power plants, reserves allocation, maintenance scheduling and value optimization of the produced electricity (economic dispatch, participation in the electricity market etc.) End-users include Transmission System Operators, Distribution System Operators, Energy Storage Providers, Independent Power Producers and market operators.

### Wind power generation review
The operating principle of wind energy turbines is capturing kinetic energy from the oncoming wind and converting that first to rotational kinetic energy via the turbine's blades and then to electric energy via the generator. It can easily be shown that the power available in the wind is ![Power in the Wind](https://latex.codecogs.com/gif.latex?P%3D%5Cfrac%7B1%7D%7B2%7D%5Crho%20Av%5E3) where v the wind speed, ρ the air density and A the swept area by the turbine. The energy conversion efficiency at the blade can be expressed with the dimensionless power coefficient Cp. Betz’s limit specifies the maximum efficiency attainable, i.e. ![Betz's limit](https://latex.codecogs.com/gif.latex?C_P%5E%7Bmax%7D%3DC_P%5E%7BBetz%7D%3D59.25%5C%25) . Thus, the converted power is given by the following: ![Power to the blade](https://latex.codecogs.com/gif.latex?P%3D%5Cfrac%7B1%7D%7B2%7D%5Crho%20Av%5E3C_P). Clearly, as the wind speed is the only cubed parameter, it plays a major role and small deviations in its value have significant repercussions. Once a wind speed value has been obtained, it is straightforward to convert to power via a power curve (a power vs. wind speed plot), taking into account the characteristics of the wind turbine/farm (incl. wake effects) and losses due to gearboxes & generators.

### Atmospheric flow generation and considerations

Wind energy is derived by the movement of air masses, in turn the result of solar energy, as the main mechanism of generation is the flow due to temperature differences and the resulting pressure gradients.

Meteorologists describe the north-to-south (and vice-versa) air flows in a hemisphere by the Tropical (Hadley), Temperate (Ferrell) and Polar “cells”. Of interest here is that the  direction of wind is further impacted by the Coriolis force (most prominent at higher altitudes), friction with the ground and any obstacles (at lower altitudes), pressure differentials due to orography (lower pressure downwind of the mountains) and localized temperature differentials due to the varying heating rates between land masses and water bodies (the sea breeze being a typical example).

Of particular interest for forecasting are the relevant periods (or “seasonalities” in statistics) that occur naturally: annual and diurnal. The tilt of the Earth’s rotational axis (23.5 degrees) is responsible for the annual seasonality (i.e. the seasons). The much more prominent diurnal seasonality is a result of the day-night cycle and the associated temperature differences. It encompasses a wide range of resulting effects, such as the varying thickness of the atmospheric boundary layer, the atmospheric flows near coastlines and varying density of air due to the rise of water vapor. 

### Forecasting and Numerical Weather Predictions (NWP)

There are two main approaches to forecasting wind speed: the deterministic process of Numerical Weather Prediction models (NWP) and the stochastic options which are aimed at time series analysis and prediction (either univariate or multivariate), encompassing a range of options for specific models (incl. Machine Learning approaches). The ML options are commonly used for combining the two, treating the NWP results as another input variable.

NWP are based on numerically approximating a solution to the partial differential equations of conservation of mass, momentum, and energy that describe the atmospheric flow, by discretization on a temporal and spatial grid (via truncated Taylor series). The error for NWP approaches is temporally and spatially distributed, i.e. the error for a region is smaller than the error for a wind farm, as not all wind farms in a region see the same wind speeds simultaneously. NWP disadvantages include  heavy reliance on initial parameters to describe the system, parameterization/approximation schemes (look-up tables etc.) for effects that require significant calculations to be analytically expressed (introducing significant errors in the process), the potential for numerical instability due the necessary downscaling/upscaling processes, and the significant computation cost/time. They outperform time-series approaches for longer forecasting horizons and frequently utilize some form of statistical error correction.

### Forecasting and Time Series 

The statistical methodologies for wind speed forecasting centres around the concept of time series, a sequence of recorded values (observations) indexed in time order. The premise for the univariate (and most common) approach is that there is a function ![f](https://latex.codecogs.com/gif.latex?f) connecting a vector ![X](https://latex.codecogs.com/gif.latex?X) to a response variable ![y_hat](https://latex.codecogs.com/gif.latex?%5Chat%7By%7D) with a random error term ![epsilon](https://latex.codecogs.com/gif.latex?%5Cepsilon), i.e.: ![stat_equation](https://latex.codecogs.com/gif.latex?%5Chat%7By%7D%3Df%28X%29+%5Cepsilon). For wind speed forecasting this means using past values of wind speed (comprising ![X](https://latex.codecogs.com/gif.latex?X)) to predict
future ones (![y_hat](https://latex.codecogs.com/gif.latex?%5Chat%7By%7D)). 

A number of methods were tested: 

- exponential smoothening (ETS)
-  uto-regressive integrated moving averages with and without seasonal component (sARIMA, ARIMA)
- combinations of ETS and ARIMA with “Seasonal and Trend decomposition with Loess” (STL) to include  annual and diurnal seasonality
- the TBATS method
- and  a Neural Network to fit an auto-regressive model (NNAR) without the stationarity constraints of (s)ARIMA.

Model selection was done by minimization of the corrected Akaike’s Information Criterion, penalizing overly complex models for goodness-of-fit. For pre-processing, the 1- and 2- parameter Box-Cox transformations were tested, as
well scaling and centring in the case of the neural network. These are benchmarked against persistence (last recorded value “forwarded” in time – the most common approach), climatological approach (the mean of all values), the
Drift model (equivalent to drawing a line between first and last observations and extrapolating) and the “New Reference Model” by  Nielsen et al. (a weighted combination of persistence and climatology).

### Data Exploration

The wind speed data used in this project has been collected at a height of 10m at Chilbolton, from Jan 1st 2016 to Jan 17th 2018 (inclusive) and was converted to an hourly data set. The last 48 hours constitute the test set. The box plots below highlight the annual and diurnal seasonalities present in the data (as expected) while the histogram & density plot illustrate the skewed distribution of wind speeds (a typical feature of most regions’ wind regimes). The AutoCorellation Function plot confirms the existence of both trend and seasonality in the data, but the trend is of marginal impact, as identified by STL decomposition.

![Density Plot](https://5etpra.db.files.1drv.com/y4msNWQNA_dkh0S0yx6blyGlWIG1Y0ImTX9pQ2qskut4qEIsOHp62izmLxHhvIrECBcb9dmVmWewqAHdM8Gi-2BWkkvVRskD2TDSYJLQwgNVmE1I3yxc1b0lpOxnpiNXRNS5pj083s4iYStCODOaAQp4aIoAApf6bMPxcn62pgL4ywLrD16hE97k4pjlQwW5ntBDnRm5S55Vf9v416h8QZ2GQ?width=660&height=161&cropmode=none)

![Box plot per hour](https://fuerxa.db.files.1drv.com/y4mmn5hW3N1lfVUluLDSA7bQDuiORucLqK3FJzP6wDnkyQSi4du6POw0GLtpew32v942vGwBdS8zxa74-tX9qQ-ckA8Y-XS2AvjOJSfxONcizjIHePOPKn64RrPxIttmz5yPXRCen7PPrHc8rq4O-OLbWiEdoGwXF53FsueZMiGR3fiTXE79ugtpVENYh5d5oGqZv7N4ffCG59yxtT2IUGGyg?width=660&height=465&cropmode=none)

![Box plot per month](https://fuemxa.db.files.1drv.com/y4mx4ocgifXQB5mrotNiEA7MofAT3t9yYuPvGBe_eG2dtkUFlWsn3Pkkaia8LjLkI8f7MlTELfAvAfzqCO5FpcbEKpm8AYIhe4MHxo3qKZwyQ0W0qxUXAIE26Lono6Ev6BCa2YR1z-OMzCdynMi6ks2VrAo4iheHvOm59MHFuC_M0YJwMYuPGKAwK-5qIc29SVHrDHlnJrS5mYYRYRXJXCiZQ?width=660&height=465&cropmode=none)

![ACF plot](https://feeoxa.db.files.1drv.com/y4mbedmdl5ClDcizm-qEd0nbWTIScMXH1cESNQ9D5YLpGNu2iSVsup3_HLoZNUyQs1oOEDRlcIYra8mZNnk_RqNd9BZGfnKnAYX_x-McEpZriVInHeJkdTncn_lZJcJOlIcYN4mOQnpDtATMXucRFRQhl3IqDiTb4-3WPjMeSPjfIIPXHDHJ-9oF6Sv8EhBEcMaFnnDm2jZZFYpbAzoHZr3sA?width=660&height=465&cropmode=none)

![STL decomposition](https://goeqxa.db.files.1drv.com/y4m0nU-baMeAuYMj9bXjgdJo-O92kL2ALG2Q08mEIAOQcSkGfTlcl6wZDa6l7o0hVLDCYU2ha5Koyb3_bD4aknwm16kk1fr_4PCgc4rQYfK29lbNXt2QNNgqw3SFhwrt-wyJLs8_jF02AfRKlBcjh6BPd38k2Ts7C8jRaaYHTVJY2VxPO7MLfQAaLqRt3rsKiwWuRswIR-Fs-_sPeUDRCqqGA?width=660&height=465&cropmode=none)

### Statistical Forecasting Results

Four methods outperformed the benchmark of Persistence and only ETS significantly so. These methods are shown to the right. The table lists Mean Error (ME), Root Mean Squared Error (RMSE), Mean Absolute Error (MAE), Mean Absolute Percentage Error (MAPE) and relative improvement over persistence. The methods are sorted by MAE, which shows on average the deviation from actual values, while RMSE penalizes significant deviations. ME shows bias (errors potentially cancel each other) and MAPE quantifies error as “capacity” – however it is the least robust for this application due the reliance of division by potentially near-zero numbers.  Note that "BC" refers to the use of pre-processing by one-parameter formulation of Box-Cox transformation.

| Model       | ME   | RMSE | MAE  | MAPE  | rel. MAE | rel. RMSE |
| ----------- | ---- | ---- | ---- | ----- | -------- | --------- |
| ETS         | 0.38 | 1.29 | 1.01 | 14.34 | 20.47%   | 18.42%    |
| sARIMA      | 0.89 | 1.52 | 1.20 | 15.95 | 5.77%    | 3.74%     |
| ETS w/ BC   | 0.83 | 1.66 | 1.25 | 17.18 | 1.88%    | -5.27%    |
| Drift       | 1.02 | 1.58 | 1.27 | 16.80 | 0.27%    | 0.19%     |
| Persistence | 1.02 | 1.58 | 1.27 | 16.84 | 0.00%    | 0.00%     |

![5 Best Methods](https://5etsra.db.files.1drv.com/y4m8xsFKHYFJ5u0o8BuVcannVy8ff2D-XONASdaa7xcHGsozVEYcS8ozb3fjhSpV3NmaMuwpl7z6hvGM2S3gy_haRVoHSN1whYWEHzbhnf_nEFY3VDFAAUvG7HjODyVHwy7w1X0SYf8-cHrSH_i9P05auanRU_HzsptUD15xyqKsQ5Dz4_kgWXhcA5mqflKqpiGc-CxRcU6EXq2jD1lxjZ7cg?width=660&height=648&cropmode=none)

None of the methods managed to capture the “ramp” event at the start of the forecasting period, suggesting that a sub-hourly approach may be needed. Furthermore, the Drift method performed marginally better than Persistence. The lowest MAE in the training set was achieved by STL approaches which include Annual and Diurnal seasonality. They subsequently performed very poorly for forecasting, suggesting that good fit in the training set is not indication of performance and that including annual seasonality may lead to overfitting. Data pre-processing/transformations hindered the forecasting ability of the models universally. 

Most of the literature focuses on ARIMA methods, but the ETS performed significantly better and is characterized by a very low computation cost, making it a good recommendation to try it out by other forecasters in future work. 

