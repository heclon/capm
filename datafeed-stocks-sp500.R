
# path_to_python <- "/usr/bin/python"
# use_python(path_to_python)
# reticulate::py_available()
# reticulate::import("yfinance")
# reticulate::import("lxml")
# reticulate::import("os")

source("key-stats-valuation.R")
# Create directories
WORK_DIR <- "."
setwd(WORK_DIR)
DIR_SP500 <- file.path(WORK_DIR, "SP500")
DOWNLOADS <- DIR_SP500
CACHE <- 'SP500_CACHE'

if (!dir.exists(DIR_SP500)){
  dir.create(DIR_SP500)
} else {
  print("Dir DIR_SP500 already exists!")
}

# Download info for the list of companies in the SP500 and prices of the SP500 index
SP500_INFO <- GetSP500Stocks()
SP500 <- BatchGetSymbols(tickers = '^GSPC',
                         first.date = first.date,
                         last.date = last.date,
                         cache.folder = file.path(WORK_DIR,CACHE))
# Build a dataframe
SP500_DF <- as.data.frame(SP500["df.tickers"])
colnames(SP500_DF) <- c("open", "high","low","close","volume","price_adjusted","date","ticker","return_adjusted_prices","return_closing_prices")
SP500_DF <- SP500_DF[, c(7,1,2,3,4,5,6,8,9,10)]
SP500_DF$ticker <- NULL

# Write to excel/csv
tickerFile <- "SP500.csv"
tickerFilePath <- paste(DOWNLOADS, tickerFile, sep="/")
write.csv(SP500_DF, file = tickerFilePath)
# export(SP500_DF, tickerFilePath , append=FALSE)

# Sanitise with "-" these companies that have tickers with "."
SP500_INFO["Tickers"][SP500_INFO["Tickers"] == "BRK.B"] <- "BRK-B"
SP500_INFO["Tickers"][SP500_INFO["Tickers"] == "BF.B"] <- "BF-B"

# Download prices in batch for all companies in the SP500 and store prices in cache folder
TICKERS <- SP500_INFO$Tickers

TICKERS_DOWNLOAD_ERROR <- c()
TICKERS_DOWNLOAD_WARNING <- c()

# Download prices and key stats to xls
for(ticker in TICKERS){
  ticker <- trimws(ticker)
  TICKER_RAW  <- BatchGetSymbols(tickers = ticker,
                                 first.date = first.date,
                                 last.date = last.date,
                                 cache.folder = file.path(WORK_DIR,CACHE))
  result = tryCatch({
    TICKER_DF <- as.data.frame(TICKER_RAW ["df.tickers"])
    names(TICKER_DF) <- c("open", "high","low","close","volume","price_adjusted","date","ticker","return_adjusted_prices","return_closing_prices")
    TICKER_DF <- TICKER_DF[, c(7,1,2,3,4,5,6,8,9,10)]
    TICKER_DF$ticker <- NULL
    ticker <- trimws(ticker)
    tickerFilePath <- paste(DOWNLOADS, ticker, sep="/")
    fileName <- paste(tickerFilePath,".csv",sep = "")
    # export(TICKER_DF, fileName , append=FALSE)
    write.csv(TICKER_DF, file = fileName, row.names = FALSE)
    
    # Get Key stats for that ticker from Yahoo Finance with python script ratios-yfinance.py
    fileNameStats <- paste(tickerFilePath,"_stats.csv",sep = "")
    TICKER_STATS <- KeyStatsDataframe(ticker)
    colnames(TICKER_STATS) <- c("Metric","Value")
    # export(TICKER_STATS, fileNameStats, which = "Key_Stats", append=TRUE)
    write.csv(TICKER_STATS, file = fileNameStats, row.names = FALSE)
    
  },
  warning = function(w) {
    c(TICKERS_DOWNLOAD_WARNING, ticker)},
  error = function(e) {
    c(TICKERS_DOWNLOAD_ERROR, ticker)},
  finally = {
    TICKER_RAW <- NULL; TICKER_DF <- NULL;
    tickerFile <- NULL; tickerFilePath <- NULL;
  }
  )
}
