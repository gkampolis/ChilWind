# ##############################################################################
# Author: Georgios Kampolis
#
# Description: Creates wind roses plots from the initial data set,
# before hourly conversion.
#
# ##############################################################################

library(openair)

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

windInitial %<>% filter(dateTime < ymd_hms("2018-01-15 00:00:00"))

rm(dateTime)

windInitial %<>% rename(date = dateTime)

windRoseTotal <- windRose(windInitial, ws = "windSpeed", wd = "windDirection",
                          key.position = "right",
                          key.header = "Wind speed (m / s)",
                          annotate = "")

windRoseSeason <- windRose(windInitial, ws = "windSpeed", wd = "windDirection",
                          key.position = "right",
                          key.header = "Wind speed (m / s)",
                          annotate = "",
                          type = "season")


# PDF export
pdf(file = "./plots/windRoseTotal.pdf",
    width = 8.3, # 21cm in inches
    height = 5.8 # 14.8 cm in inches
    )

print(windRoseTotal)

dev.off()

pdf(file = "./plots/windRoseSeason.pdf",
    width = 8.3, # 21cm in inches
    height = 5.8 # 14.8 cm in inches
)

print(windRoseTotal)

dev.off()

# PNG export
# png(file = "./plots/windRoseTotal.png",
#     units = "cm",
#     res = 300,
#     width = 21,
#     height = 14.8)
#
# print(windRoseTotal)
#
# dev.off()
#
# png(file = "./plots/windRoseSeason.png",
#     units = "cm",
#     res = 300,
#     width = 21,
#     height = 14.8)
#
# print(windRoseSeason)
#
# dev.off()

## clean up ##
rm(windRoseSeason, windRoseTotal, windInitial)

detach(package:openair, unload = TRUE)

## Notify that script's end has been reached ##
if (require(beepr)) {beepr::beep(1)}
