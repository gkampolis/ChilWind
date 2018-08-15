################################################################################
# Author: George Kampolis
#
# A simple variation of the base::mean() function to always incorporate the
# na.rm = TRUE option (the default is na.rm = FALSE).
#
################################################################################

meanNA <- function(x) {
  meanValue <- mean(x, na.rm = TRUE)
  return(meanValue)
}
