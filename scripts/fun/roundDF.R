################################################################################
# Author: George Kampolis
#
# A function to round only the numeric variables of a data frame.
#
################################################################################

roundDF <- function(x, digits) {
  numeric_columns <- sapply(x, class) == 'numeric'
  x[numeric_columns] <-  round(x[numeric_columns], digits)
  x
}
