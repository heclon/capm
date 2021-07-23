source("env.R")
YEARS_HISTORIC_DATA <- 1
first.date <- Sys.Date()-(365*YEARS_HISTORIC_DATA)
last.date <- Sys.Date()
freq.data <- 'daily'

source("datafeed-stocks-sp500.R")
