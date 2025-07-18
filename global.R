# global.r file for acid-base titration app

# packages to load
library(shiny) # functions for creating app
library(shinythemes) # functions for styling shiny app
library(titrationCurves) # functions to calculate titration curves
library(shape) # functions for drawing arrows

# set color scheme
palette("Okabe-Ito")

# vector that stores the choices of indicators
indicator.name = c("bromophenol blue (3.0-4.6)",
                   "bromocresol green (3.8-5.4)", 
                   "methyl red (4.2-6.3)",
                   "bromocresol purple (5.2-6.8)", 
                   "bromothymol blue (6.0-7.6)", 
                   "phenol red (6.8-8.4)", 
                   "cresol red (7.2-8.8)", 
                   "p-naphtholbenzein (9.0-11.0)", 
                   "alizarin yellow R (10.1-12.0)")

# vectors that store the colors and pH limits for the indicators
acid.color = c(5,5,8,5,5,5,5,5,5) # color of indicator's acid form
acid.limit = c(3.0,3.8,4.2,5.2,6.0,6.8,7.2,9.0,10.1) # acid pH limit
base.color = c(3,3,5,8,3,3,8,3,8) # color of indicator's base form
base.limit = c(4.6,5.4,6.3,6.8,7.6,8.4,8.8,11.0,12.0) # base pH limit

