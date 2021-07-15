source('FTSE100.R')
source("key-stats-valuation.R")
DOWNLOADS <- DIR_FTSE100
CACHE <- 'FTSE100_CACHE'

# 1 Download info for the list of companies in the FTSE100
FTSE100_INFO <- GetFTSE100Stocks()
FTSE100 <- BatchGetSymbols(tickers = '^FTSE',
                         first.date = first.date,
                         last.date = last.date,
                         cache.folder = file.path(WORK_DIR,CACHE))
# Build a dataframe
FTSE100_DF <- as.data.frame(FTSE100["df.tickers"])
colnames(FTSE100_DF) <- c("open", "high","low","close","volume","price_adjusted","date","ticker","return_adjusted_prices","return_closing_prices")
FTSE100_DF <- FTSE100_DF[, c(7,1,2,3,4,5,6,8,9,10)]
FTSE100$ticker <- NULL

# Write to excel/csv
tickerFile <- "FTSE100.xlsx"
tickerFilePath <- paste(DOWNLOADS, tickerFile, sep="/")
# write.csv(FTSE100, file = tickerFilePath)
export(SP500_DF, tickerFilePath , append=FALSE)

# 2 Download prices in batch for all companies in the FTSE100 and store prices in cache folder
TICKERS <- FTSE100_INFO$ticker

TICKERS_DOWNLOAD_ERROR <- c()
TICKERS_DOWNLOAD_WARNING <- c()

# 3 Download prices and key stats to xls
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
    tickerFile <- trimws(ticker)
    tickerFilePath <- paste(DOWNLOADS, tickerFile, sep="/")
    fileName <- paste(tickerFilePath,".xlsx",sep = "")
    export(TICKER_DF, fileName , which = "Price", append=TRUE)
    # write.csv(TICKER_DF, file = fileName, row.names = FALSE)

    # Get Key stats for that ticker from Marketwatch
    TICKER_STATS <- KeyStatsDataframe(ticker)
    colnames(TICKER_STATS) <- c("Metric","Value")
    export(TICKER_STATS, fileName, which = "Key_Stats", append=TRUE)

    },
    warning = function(w) {
      c(TICKERS_DOWNLOAD_WARNING, ticker)},
    error = function(e) {
      c(TICKERS_DOWNLOAD_ERROR, ticker)},
    finally = {
      TICKER_RAW <- NULL;TICKER_DF <- NULL
      tickerFile <- NULL;tickerFilePath <- NULL
    }
  )
}

