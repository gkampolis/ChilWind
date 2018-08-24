################################################################################
# Author: George Kampolis
#
# A function to save ggplots at A5 size with dpi=300 in the "plots" directory
# By default a .pdf is produced.
# Based on ggsave by either ggplot2 (original).
#
################################################################################

require(ggplot2)

saveA5 <- function(plotObject, plotName, orientation = "H", fileType = ".pdf") {
  if (orientation == "H" || orientation == "h") {  # horizontal orientation
    ggplot2::ggsave(paste0(plotName, fileType),
           plot = plotObject,
           units = "cm",
           width = 21,
           height = 14.8,
           dpi = 300,
           path = "plots/"
    )
  } else if (orientation == "V" || orientation == "v") { # vertical orientation
    ggplot2::ggsave(paste0(plotName, fileType),
           plot = plotObject,
           units = "cm",
           width = 14.8,
           height = 21,
           dpi = 300,
           path = "plots/"
    )
  }


}
