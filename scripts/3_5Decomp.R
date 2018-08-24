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

STLdecompBoxCox <- autoplot(mstl(
  msts(BoxCox(windTS, lambda = "auto"),freq, ts.frequency = freq[1])
  )) +
  labs(subtitle = "Data decomposition by STL & Box-Cox",
       x = "Time (days)")

saveA5(STLdecompBoxCox, "STL_BoxCox_Auto", "H")

rm(STLdecompBoxCox)

fitTBATS <- tbats(windTS, use.box.cox = FALSE, use.arma.errors = TRUE)

pdf(file = "./plots/TBATS.pdf",
    width = 8.3, # 21cm in inches
    height = 5.8 # 14.8 cm in inches
)

print(
      plot(fitTBATS, main = "Data decomposition by TBATS", xlab = "Time (Days)")
     )

dev.off()

rm(fitTBATS)

fitTBATSBoxAuto <- tbats(windTS,
                  use.box.cox = TRUE,
                  use.arma.errors = TRUE,
                  biasadj = TRUE)

pdf(file = "./plots/TBATS_BoxCox_Auto.pdf",
    width = 8.3, # 21cm in inches
    height = 5.8 # 14.8 cm in inches
)

print(
  plot(fitTBATSBoxAuto,
       main = "Data decomposition by TBATS & Box-Cox",
       xlab = "Time (Days)")
)

dev.off()

rm(fitTBATSBoxAuto)

## Notify that script's end has been reached ##
if (require(beepr)) {beepr::beep(1)}


