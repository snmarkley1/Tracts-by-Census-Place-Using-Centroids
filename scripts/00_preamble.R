
#########################################################################
#########################################################################
###                                                                   ###
###                             PREAMBLE                              ###
###                                                                   ###
#########################################################################
#########################################################################

## PREPARE WORKSPACE
rm(list = ls())  # clear environment
options(scipen = 999) 
options(digits = 6)


## Load or install packages
packages <- function(x) {
  x <- deparse(substitute(x))
  installed_packages <- as.character(installed.packages()[, 1])
  
  if (length(intersect(x, installed_packages)) == 0) {
    install.packages(pkgs = x, dependencies = TRUE, repos = "http://cran.r-project.org")
  }
  
  library(x, character.only = TRUE)
  rm(installed_packages) # Remove From Workspace
}

packages(tidyverse)
packages(tidycensus)
packages(tigris)
packages(sf)
packages(mapview)
packages(openxlsx)
#packages(httr)  # for rest API
