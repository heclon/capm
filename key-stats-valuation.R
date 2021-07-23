# Read Key Stats Information from Marketwatch
KeyStatsDataframe <- function(ticker){
  
  url_stats <- paste0("https://www.marketwatch.com/investing/stock/", ticker)
  
  key_stats_elements <- url_stats %>%
    read_html() %>%
    html_nodes(xpath='//ul[@class="list list--kv list--col50"]')
  # key_stats_elements
  
  # Fix and prepare text to extract key stats
  key_stats_text <- html_text(key_stats_elements)
  key_stats_text <- strsplit(key_stats_text,split =
                               "\n                    \n                \n                \n                    ") [[1]]
  # key_stats_text
  key_stats_text <- gsub(pattern = "\n                    \n                \n        ", replacement = "",key_stats_text)
  # key_stats_text
  key_stats_text <- gsub(pattern = "\n                \n                \n", replacement = "",key_stats_text)
  # key_stats_text
  
  # Extract stats
  # Extract open
  new_line_spaces = "\n                    "
  open_line <- gsub(pattern = new_line_spaces , replacement = "",key_stats_text)[[1]]
  open_line <- strsplit(open_line,split = "\\$")
  open_line <-  data.frame(open_line)
  
  # Extract Day range
  day_range_line <-  strsplit(key_stats_text,split = new_line_spaces,key_stats_text)[[2]]
  day_range_line <-  data.frame(day_range_line)
  
  # Extract 52 Week Range
  yearly_range_line <-strsplit(key_stats_text,split = new_line_spaces,key_stats_text)[[3]]
  yearly_range_line <-data.frame(yearly_range_line)
  
  # Market Cap
  market_cap <- strsplit(key_stats_text,split = new_line_spaces,key_stats_text)[[4]]
  market_cap <-  data.frame(market_cap)
  
  # Shares Outstanding
  shares_outstanding <- strsplit(key_stats_text,split = new_line_spaces,key_stats_text)[[5]]
  shares_outstanding <- data.frame(shares_outstanding)
  
  # Public Float
  public_float <- strsplit(key_stats_text,split = new_line_spaces,key_stats_text)[[6]]
  public_float <- data.frame(public_float)
  
  # Beta
  beta <- strsplit(key_stats_text,split = new_line_spaces,key_stats_text)[[7]]
  beta <-  data.frame(beta)
  
  # Revenue per employee
  revenue_per_employee <- strsplit(key_stats_text,split = new_line_spaces,key_stats_text)[[8]]
  revenue_per_employee <- data.frame(revenue_per_employee)
  
  # P/E ratio
  pe_ratio <- strsplit(key_stats_text,split = new_line_spaces,key_stats_text)[[9]]
  pe_ratio <- data.frame(pe_ratio)
  
  # EPS
  eps <- strsplit(key_stats_text,split = new_line_spaces,key_stats_text)[[10]]
  eps <- data.frame(eps)
  
  # Yield
  yield <- strsplit(key_stats_text,split = new_line_spaces,key_stats_text)[[11]]
  yield <- data.frame(yield)
  
  # Dividend
  dividend <- strsplit(key_stats_text,split = new_line_spaces,key_stats_text)[[12]]
  dividend <- data.frame(dividend)
  
  # Ex-dividend date
  exdividend_date <- strsplit(key_stats_text,split = new_line_spaces,key_stats_text)[[13]]
  exdividend_date <-  data.frame(exdividend_date)
  
  # # Short Interest
  # short_interest <- strsplit(key_stats_text,split = new_line_spaces,key_stats_text)[[14]]
  # short_interest_df <- as.data.frame(short_interest)
  # short_interest_df
  
  # Average Volume
  average_volume <- strsplit(key_stats_text,split = new_line_spaces,key_stats_text)[[15]]
  average_volume <- data.frame(average_volume)
  
  KEY_STATS_DF <- data.frame(open_line,day_range_line,yearly_range_line,market_cap,
                             pe_ratio,eps,beta,shares_outstanding,yield,dividend,
                             public_float,exdividend_date,average_volume)
  # KEY_STATS_DF
  KEY_STATS_DF <- t(KEY_STATS_DF)
  rownames(KEY_STATS_DF) <- 1:nrow(KEY_STATS_DF)
  return(KEY_STATS_DF)
}

RL_DF <- KeyStatsDataframe("rl")
colnames(RL_DF) <- c("Metric","Value")

# TODO: valuation
# url_valuation <- paste("https://www.marketwatch.com/investing/stock/",ticker,"/profile")
# Example URL https://www.marketwatch.com/investing/stock/rl/profile
# valuation_col <- url_valuation %>%
#   read_html() %>%
#   html_nodes(xpath='//*[@class="block threewide addgutter"]')
#
# valuation_data <- url_valuation %>%
#   read_html() %>%
#   html_nodes(xpath='//*[@class="data lastcolumn"]')