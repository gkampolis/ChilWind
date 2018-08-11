# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Decomposition by seasonality plots.
#
# ##############################################################################

STLdecomp <- autoplot(mstl(windTS)) +
  labs(subtitle = "Original data decomposition by STL",
       x = "Time (days)")

saveA5(STLdecomp, "STL", "H")

rm(STLdecomp)

STLdecompBoxCox <- autoplot(mstl(BoxCox(windTS + 1, lambda = 0))) +
  labs(subtitle = "Transformed data decomposition by STL",
       x = "Time (days)")

saveA5(STLdecompBoxCox, "STL_BoxCox", "H")

rm(STLdecompBoxCox)

fitTBATS <- tbats(windTS, use.box.cox = FALSE, use.arma.errors = TRUE)

png(file = "./plots/TBATS.png",
    units = "cm",
    res = 300,
    width = 21,
    height = 14.8)

print(
      plot(fitTBATS, main = "Data decomposition by TBATS", xlab = "Time (Days)")
     )

dev.off()

rm(fitTBATS)

fitTBATSBoxAuto <- tbats(windTS,
                  use.box.cox = TRUE,
                  use.arma.errors = TRUE,
                  biasadj = TRUE)

png(file = "./plots/TBATS_BoxCox_Auto.png",
    units = "cm",
    res = 300,
    width = 21,
    height = 14.8)

print(
  plot(fitTBATSBoxAuto, main = "Data decomposition by TBATS", xlab = "Time (Days)")
)

dev.off()

rm(fitTBATSBoxAuto)

fitTBATSBox <- tbats(BoxCox(windTS + 1, lambda = 0), use.box.cox = FALSE)
png(file = "./plots/TBATS_BoxCox.png",
    units = "cm",
    res = 300,
    width = 21,
    height = 14.8)

print(
  plot(fitTBATSBox, main = "Transformed data decomposition by TBATS",
       xlab = "Time (Days)")
  )

dev.off()

rm(fitTBATSBox)

## Notify that script's end has been reached ##
if (require(beepr)) {beepr::beep(1)}


