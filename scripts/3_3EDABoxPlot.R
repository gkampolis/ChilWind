# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Creates boxplots to explore seasonality of the data set.
#
# ##############################################################################

wind %<>% mutate(year = as.factor(year(dateTime)),
                 month = as.factor(month(dateTime)),
                 hour = as.factor(hour(dateTime))
)

boxPlotMonthOverall <- wind %>%
  ggplot(aes(month, windSpeed)) + geom_boxplot() +
  theme(axis.title.x = element_blank()) +
  labs(y = "Wind speed (m/s)")

boxPlotMonth <- wind %>% filter(year(dateTime) < 2018) %>%
  ggplot(aes(month, windSpeed)) +
  geom_boxplot() + facet_wrap(~ year) +
  labs(x = "Months",
       y = "Wind speed (m/s)")

boxPlotMonthTotal <- gridExtra::grid.arrange(boxPlotMonthOverall, boxPlotMonth)

saveA5(boxPlotMonthTotal, "BoxPlotMonth", "H")

rm(boxPlotMonth, boxPlotMonthOverall, boxPlotMonthTotal)

boxPlotHourOverall <- wind %>%
  ggplot(aes(hour, windSpeed)) +
  geom_boxplot() +
  labs(y = "Wind speed (m/s)",
       x = "Hours")

saveA5(boxPlotHourOverall, "BoxPlotHour", "H")

boxPlotHourByMonth <- wind %>%
  ggplot(aes(hour, windSpeed)) +
  geom_boxplot() +
  facet_wrap(~ month, ncol = 3) +
  labs(y = "Wind speed (m/s)",
       x = "Hours")

ggsave("BoxPlotHourByMonth.png", plot = boxPlotHourByMonth, path = "plots/",
       units = "cm",
       width = 29.7,
       height = 21,
       dpi = 300)

rm(boxPlotHourOverall, boxPlotHourByMonth)

# return the data set in its initial state
wind %<>% select(dateTime, windSpeed)

## Notify that script's end has been reached ##
if (require(beepr)) {beepr::beep(1)}
