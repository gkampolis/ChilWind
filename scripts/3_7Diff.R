# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Create plots to explore the effects of differencing.
#
# ##############################################################################

plotSeries <- autoplot(windTS) +
  labs(x = "Time (Days)",
       y = "Wind Speed (m/s)"
       )

plotDiffSeries <- autoplot(diff(windTS)) +
  labs(x = "Time (Days)",
       y = "Wind Speed Differences (m/s)"
       )

plotHist <- ggplot(windTS, aes(x = windTS)) +
  geom_histogram(aes(y = ..density..),
                 binwidth = 0.5,
                 colour = "black",
                 fill = "white") +
  geom_rug(sides = "b") +
  geom_density(colour = "gray", fill = "gray", alpha = 1/2) +
  labs(y = "Density",
       x = "Wind Speed (m/s)"
       )

plotDiffHist <- ggplot(diff(windTS), aes(x = diff(windTS))) +
  geom_histogram(aes(y = ..density..),
                 colour = "black",
                 fill = "white") +
  geom_rug(sides = "b") +
  geom_density(colour = "gray", fill = "gray", alpha = 1/2) +
  labs(y = "Density",
       x = "Wind Speed Differences (m/s)"
  )

plotACF <- windTS %>%
  ggAcf(lag = freq[1]*7) +
  theme(plot.title = element_blank()) +
  xlab("Lag (hours)")

plotDiffACF <- diff(windTS) %>%
  ggAcf(lag = freq[1]*7) +
  theme(plot.title = element_blank()) +
  xlab("Lag (hours)")

diffPlot <- gridExtra::grid.arrange(plotSeries, plotHist, plotACF,
                        plotDiffSeries, plotDiffHist, plotDiffACF,
                        ncol = 3)

saveA5(diffPlot, "DifferencedSeries", "H")

## Clean up ##
rm(diffPlot, plotSeries, plotHist, plotACF,
   plotDiffSeries, plotDiffHist, plotDiffACF)

## Notify that script's end has been reached ##
if (require(beepr)) {beepr::beep(1)}
