## Loads the libraries needed, sets default ggplot2 theme and ##
## explicitly states that dplyr::select() takes precedence. ##
library(dplyr)
library(magrittr)
library(ggplot2)
library(ggExtra)
library(ggsci)
library(ggpubr)
library(lubridate)
library(forecast)
library(tseries)
library(readr)
library(cowplot)
library(gridExtra)
library(reshape2)
# loaded as needed by individual scripts, kept here for reference:
# library(openair)
# library(fitdistrplus)
# library(ncdf4)
# library(naniar)
# library(visdat)

theme_set(theme_bw())

select <- dplyr::select #fitdistrplus loads MASS which masks select from dplyr...

if (require(beepr)) {beepr::beep(1)}
