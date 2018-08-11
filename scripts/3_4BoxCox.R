# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Sets up Box-Cox transformations and plots their effects.
#
# ##############################################################################

# Determine best lamda via Guerrero method.
lambdaProposed <- BoxCox.lambda(windTS, method = "guerrero") # approx. 0.32533

plotMeasured <- windTS %>%
  autoplot() +
  labs(x = "Time (Days)",
      y = "Wind Speed (m/s)",
      subtitle = bquote("Measurements - untransformed series."*" | " *
                        "Variance: "*.(round(var(windTS),2))
                        )
      )

plotProposed <- BoxCox(windTS, lambda = lambdaProposed) %>%
  autoplot() +
  labs(x = "Time (Days)",
       y = "Transformed Speed",
       subtitle = bquote("Box-Cox transformed. " *
                              lambda*": " *
                              .(round(lambdaProposed, digits = 3))*" | " *
                  "Variance: "*.(round(var(BoxCox(windTS, lambda = lambdaProposed)),2))
                  )
  )

plotLogTrans <- BoxCox(windTS, lambda = 0) %>%
  autoplot() +
  labs(x = "Time (Days)",
       y = "Transformed Speed",
       subtitle = bquote("Box-Cox (log) transformed. "*lambda*": 0" *
                         " | "*"Variance: "*.(round(var(BoxCox(windTS, lambda = 0)),2))
                        )
  )

plotLogTransDual <- BoxCox(windTS + 1, lambda = 0) %>%
  autoplot() +
  labs(x = "Time (Days)",
       y = "Transformed Speed",
       subtitle = bquote("Dual parameter Box-Cox (log) transformed. " *
                           lambda[1]*": 0 "*lambda[2]*": 1"*" | " *
                           "Variance: "*.(round(var(BoxCox(windTS + 1, lambda = 0)),2))
                         )
      )


plot <- cowplot::plot_grid(plotMeasured + theme(axis.title.x = element_blank()),
                           plotProposed + theme(axis.title.x = element_blank()),
                           plotLogTrans + theme(axis.title.x = element_blank()),
                           plotLogTransDual,
                           ncol = 1,
                           align = "v", axis = "tblr"
                           )

saveA5(plot, "BoxCoxExplore", "V")

rm(plot, plotMeasured, plotProposed, plotLogTrans, plotLogTransDual)

## Histograms & Density plots ##

windSummary <- summary(windTS)

histWind <- ggplot(windTS, aes(x = windTS)) +
  geom_histogram(aes(y = ..density..),
                 binwidth = 0.5,
                 colour = "black",
                 fill = "white") +
  geom_rug(sides = "b") +
  geom_density(colour = "gray", fill = "gray", alpha = 1/2) +
  theme(axis.title.x = element_blank()) +
  labs(y = "Density",
       title = "Measurements - untransformed series.",
       subtitle = paste0(
         "Min: ", round(windSummary[1], digits = 2),
         " m/s | Median: ", round(windSummary[3], digits = 2),
         " m/s | Mean: ", round(windSummary[4], digits = 2),
         " m/s | Max: ", round(windSummary[6], digits = 2)
       )
  )

windSummary <- summary(BoxCox(windTS, lambda = lambdaProposed))

histWindProposed <- ggplot(windTS, aes(x = BoxCox(windTS, lambda = lambdaProposed))) +
  geom_histogram(aes(y = ..density..),
                 colour = "black",
                 fill = "white") +
  geom_rug(sides = "b") +
  geom_density(colour = "gray", fill = "gray", alpha = 1/2) +
  theme(axis.title.x = element_blank()) +
  labs(y = "Density",
       title = bquote("Box-Cox transformed. "*lambda*": " *
                        .(round(lambdaProposed, digits = 3))
                      ),
       subtitle = paste0(
         "Min: ", round(windSummary[1], digits = 2),
         " | Median: ", round(windSummary[3], digits = 2),
         " | Mean: ", round(windSummary[4], digits = 2),
         " | Max: ", round(windSummary[6], digits = 2)
       )
  )


windSummary <- summary(BoxCox(windTS, lambda = 0))

histWindLogTrans <- ggplot(windTS, aes(x = BoxCox(windTS, lambda = 0))) +
  geom_histogram(aes(y = ..density..),
                 colour = "black",
                 fill = "white") +
  geom_rug(sides = "b") +
  geom_density(colour = "gray", fill = "gray", alpha = 1/2) +
  theme(axis.title.x = element_blank()) +
  labs(y = "Density",
       title = bquote("Box-Cox (log) transformed. "*lambda*": 0"),
       subtitle = paste0(
         "Min: ", round(windSummary[1], digits = 2),
         " | Median: ", round(windSummary[3], digits = 2),
         " | Mean: ", round(windSummary[4], digits = 2),
         " | Max: ", round(windSummary[6], digits = 2)
       )
  )


windSummary <- summary(BoxCox(windTS + 1, lambda = 0))

histWindLogTransDual <- ggplot(windTS, aes(x = BoxCox(windTS + 1, lambda = 0))) +
  geom_histogram(aes(y = ..density..),
                 colour = "black",
                 fill = "white") +
  geom_rug(sides = "b") +
  geom_density(colour = "gray", fill = "gray", alpha = 1/2) +
  theme(axis.title.x = element_blank()) +
  labs(y = "Density",
       title = bquote("Dual parameter Box-Cox (log) transformed. " *
                        lambda[1]*": 0 "*lambda[2]*": 1"
                      ),
       subtitle = paste0(
         "Min: ", round(windSummary[1], digits = 2),
         "  | Median: ", round(windSummary[3], digits = 2),
         "  | Mean: ", round(windSummary[4], digits = 2),
         "  | Max: ", round(windSummary[6], digits = 2)
       )
  )



histPlot <- plot_grid(
  histWind + theme(axis.title.x = element_blank()),
  histWindProposed + theme(axis.title.x = element_blank()),
  histWindLogTrans + theme(axis.title.x = element_blank()),
  histWindLogTransDual + theme(axis.title.x = element_blank()),
  ncol = 1,
  align = "v", axis = "tblr"
)

saveA5(histPlot, "BoxCoxExploreHistogram", "V")

rm(lambdaProposed, windSummary, histWind, histWindProposed,
   histWindLogTrans, histWindLogTransDual, histPlot)

## Notify that script's end has been reached ##
if (require(beepr)) {beepr::beep(1)}
