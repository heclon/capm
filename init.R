# Shiny app deps
install.packages("devtools")
library(devtools)
install_github("arbuzovv/rusquant")
install.packages("shiny")
install.packages("DT")
install.packages("PerformanceAnalytics")
install.packages("curl")
install.packages("plotly")
install.packages("ggplot2")

# Datafeeds deps
install.packages("BatchGetSymbols")
install.packages("rio")
devtools::install_github('Rapporter/pander')
install.packages("RJSONIO", repos = "http://www.omegahat.org/R", type = "source")
install.packages("qmao", repos="http://R-Forge.R-project.org")
install.packages("reticulate")


# Load libraries
library(shiny)
library(DT)
library(PerformanceAnalytics)
library(ggplot2)
library(plotly)
library(rusquant)
library(curl)

library(BatchGetSymbols)
library(rio)
library(qmao)
library(reticulate)
RSWorldTrader984521.