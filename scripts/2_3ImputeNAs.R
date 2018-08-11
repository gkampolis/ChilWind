# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Loads the hourly data set and imputes NAs by linear interpolation
# and taking into account seasonality by robust STL decomposition.
#
# ##############################################################################

wind <- read_csv("data/windHourlyChilBolton.csv")
windInitial <- read_csv(unz("data/windDataChilBolton.zip",
                            utils::unzip("data/windDataChilBolton.zip",
                                         list = TRUE)[1,1])
)

dateTime <- seq(ymd_hms("2016-01-01 00:00:00"),
                       ymd_hms("2018-01-31 23:59:50"),
                       by = "10 secs"
                       )

windInitial <- bind_cols(as.data.frame(dateTime),
                         windInitial
                        )
rm(dateTime) # not needed anymore.
windInitial %<>% select(dateTime, windSpeed) # drop direction data

windTestSet <- wind %>% filter(dateTime>=ymd_hms("2018-01-15 00:00:00"))
wind %<>% filter(dateTime < ymd_hms("2018-01-15 00:00:00")) # training set

windInitial %<>% filter(dateTime < ymd_hms("2018-01-15 00:00:00"))

## NA values in the test set? ##
message(paste0("NAs in the Test Set: ", sum(is.na(windTestSet$windSpeed))))
message("Writing out Test Set as 'windTest.csv'.")
write_delim(windTestSet,
            path = "./data/windTestSet.csv",
            delim = ",")
rm(windTestSet)

## Visualize missing values ##
# library(visdat)
# miss_var_summary(windInitial) # 4879 missing values, 0.741%
# miss_var_summary(wind) # 10 missing values, 0.0547%
windInitialSummary <- summary(windInitial$windSpeed)
windSummary <- summary(wind$windSpeed)

histWindInitial <- ggplot(windInitial, aes(x = windSpeed)) +
  geom_histogram(aes(y = ..density..),
                 binwidth = 0.5,
                 colour = "black",
                 fill = "white") +
  geom_rug(sides = "b") +
  geom_density(colour = "gray", fill = "gray", alpha = 1/2) +
  theme(axis.title.x=element_blank()) +
  xlim(0,30) +
  labs(y = "Density",
       title = "Histogram & density plot before hourly conversion.",
       subtitle = paste0(
         "Min: ", round(windInitialSummary[1], digits = 2),
         " m/s | 1st Qu.: ", round(windInitialSummary[2], digits = 2),
         " m/s | Median: ", round(windInitialSummary[3], digits = 2),
         " m/s | Mean: ", round(windInitialSummary[4], digits = 2),
         " m/s | 3st Qu.: ", round(windInitialSummary[5], digits = 2),
         " m/s | Max: ", round(windInitialSummary[6], digits = 2),
         " m/s | NAs: ", windInitialSummary[7]
         )
  )

histWind <- ggplot(wind, aes(x = windSpeed)) +
  geom_histogram(aes(y = ..density..),
                 binwidth = 0.5,
                 colour = "black",
                 fill = "white") +
  geom_rug(sides = "b") +
  xlim(0,30) +
  geom_density(colour = "gray", fill = "gray", alpha = 1/2) +
  theme(axis.title.x=element_blank()) +
  labs(y = "Density",
       title = "Histogram & density plot after hourly conversion.",
       subtitle = paste0(
         "Min: ", round(windSummary[1], digits = 2),
         " m/s | 1st Qu.: ", round(windSummary[2], digits = 2),
         " m/s | Median: ", round(windSummary[3], digits = 2),
         " m/s | Mean: ", round(windSummary[4], digits = 2),
         " m/s | 3st Qu.: ", round(windSummary[5], digits = 2),
         " m/s | Max: ", round(windSummary[6], digits = 2),
         " m/s | NAs: ", windSummary[7]
       )
  )


## Set up frequencies ##
# for elaboration on calculation of yearly frequency, see here:
# https://robjhyndman.com/hyndsight/seasonal-periods/
freqDay <- 24
freqYear <- freqDay * 365.25
freq <- c(freqDay, freqYear)

## Create multiple seasonality time series (msts) objects ##
windSpeedTS <- msts(as.vector(wind$windSpeed), freq,
                    ts.frequency = freqDay
                    )

whichNA <- which(is.na(windSpeedTS))


## Linearly interpolate missing values (NAs), taking into account seasonality ##
windSpeedTS <- na.interp(windSpeedTS)

## Create new data frame and apply imputed values ##

library(naniar)

plotNAs <- wind %>% ggplot(aes(x = dateTime, y = windSpeed)) +
  geom_miss_point(alpha = 1/5) +
  geom_path() +
  theme(legend.position = "bottom") +
  scale_colour_nejm() +
  labs(y = "Wind speed (m/s)",
       x = "Time",
       colour = "")

plotNAsFocused <- wind[(min(whichNA)-48):(max(whichNA)+48),] %>%
  ggplot(aes(dateTime, windSpeed)) +
  geom_miss_point() +
  geom_path() +
  ylim(0,7) +
  scale_colour_nejm() +
  theme(legend.position="none") +
  labs(title = "Before imputation",
       x = "Time",
       y = "Wind Speed (m/s)",
       colour = ""
       )

## Assign interpolated values to original data frame ##
wind$windSpeed <- windSpeedTS

plotNAsImputed <- wind[(min(whichNA)-48):(max(whichNA)+48),] %>%
  ggplot(aes(dateTime, windSpeed)) +
  geom_point(colour = pal_nejm()(2)[2]) +
  geom_path() +
  theme(legend.position = "none",
        axis.title.y = element_blank()) +
  ylim(0,7) +
  labs(title = "After imputation",
       x = "Time",
       colour = ""
  )

windSummary <- summary(wind$windSpeed)

histWindImputed <- ggplot(wind, aes(x = windSpeed)) +
  geom_histogram(aes(y = ..density..),
                 binwidth = 0.5,
                 colour = "black",
                 fill = "white") +
  geom_rug(sides = "b") +
  xlim(0,30) +
  geom_density(colour = "gray", fill = "gray", alpha = 1/2) +
  labs(y = "Density",
       x = "Wind Speed (m/s)",
       title = "Histogram & density plot after NA imputation.",
       subtitle = paste0(
         "Min: ", round(windSummary[1], digits = 2),
         " m/s | 1st Qu.: ", round(windSummary[2], digits = 2),
         " m/s | Median: ", round(windSummary[3], digits = 2),
         " m/s | Mean: ", round(windSummary[4], digits = 2),
         " m/s | 3st Qu.: ", round(windSummary[5], digits = 2),
         " m/s | Max: ", round(windSummary[6], digits = 2),
         " m/s | NAs: ", if(is.na(windSummary[7])) "0" else windSummary[7]
       )
  )

histHourlyCompare <- plot_grid(histWindInitial, histWind, histWindImputed,
                               ncol = 1, align = "hv", axis = "tblr")

saveA5(histHourlyCompare, "Hourly_Conversion_Imputation", "H")

rm(histWindInitial, histWind, histWindImputed, histHourlyCompare,
   windInitial, windInitialSummary, windSummary
)
bottomRow <- plot_grid(plotNAsFocused, plotNAsImputed,
                       nrow = 1, align = "hv", axis = "lrtb"
                       )
NAsImputePlot <- plot_grid(plotNAs, bottomRow,
                           ncol = 1, align = "v", axis = "lrtb"
                           )

saveA5(NAsImputePlot, "HourlyImputation", "H")

message("Writing out Training Set as 'windTrainSet.csv'.")
write_delim(wind,
            path = "./data/windTrainSet.csv",
            delim = ",")

rm(bottomRow, NAsImputePlot,plotNAsImputed,
   plotNAsFocused, plotNAs, freq, freqDay, freqYear,
   wind, whichNA, windSpeedTS)

## Notify that script's end has been reached ##
if (require(beepr)) {beepr::beep(1)}
