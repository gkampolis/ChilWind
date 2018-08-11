# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Create ACF and partial-ACF plots.
#
# ##############################################################################

plotACF <- windTS %>%
  ggAcf(lag = freq[1]*7) +
  theme(plot.title = element_blank()) +
  xlab("Lag (hours)")


plotACFzoom <- windTS %>%
  ggAcf(lag = freq[1]*7) +
  theme(plot.title = element_blank()) +
  xlab("Lag (hours)") +
  xlim(120,144) +
  ylim(-0.05,0.2)


plotACFcombo <- ggdraw() +
  draw_plot(plotACF,
            0, 0, 1, 1
            ) +
  draw_plot(plotACFzoom,
            0.47, 0.47, 0.5, 0.5
            )

saveA5(plotACFcombo, "ACF", "H")

plotPACF <- windTS %>%
  ggPacf(lag = freq[1]*2) +
  theme(plot.title = element_blank()) +
  xlab("Lag (hours)")

saveA5(plotPACF, "PACF", "H")

rm(plotACF, plotACFzoom, plotACFcombo,plotPACF)

## Notify that script's end has been reached ##
if (require(beepr)) {beepr::beep(1)}
