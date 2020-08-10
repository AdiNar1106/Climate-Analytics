library(httr)
library(jsonlite)
library(tidyverse)

get.data <- function(url) {
  
  resp <- GET(url)
  resp_text <- content(resp, "text", encoding = "UTF-8")
  data_json <- fromJSON(resp_text, flatten = TRUE)
  data.df <- as.data.frame(data_json)
  
  ####################################################################
  return(data.df)
}
# Acquiring data from the world bank web api. We will use historic change in temperature data to predict change in temperatures for future data. 

climate.df <- get.data("ENTER URL HERE")
sapply(climate.df, class)
#climate.df$monthVals <- unlist(climate.df$monthVals)
#sapply(climate.df, class)
write.csv(climate.df, '../Datasets/FILE_NAME.csv', row.names = TRUE)
