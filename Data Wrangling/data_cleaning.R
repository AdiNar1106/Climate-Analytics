library(tidyverse)
library(lubridate)

cd.data <- read.csv("../data/GlobalTemperatures.csv")

agg.by.year <- function(data) {
  data %>% 
    mutate(Year = year(dt)) %>% 
      select(Year,everything()) %>% 
        subset(Year >= 1850)
}

annual_land_temp <- function(data) {
  data %>% 
    group_by(Year) %>% 
      summarize(LandAvgTemp = mean(LandAverageTemperature,na.rm = TRUE),
                LandAvgTempUncertainty = mean(LandAverageTemperatureUncertainty,na.rm= TRUE)
              )
}

annual_land_ocean_temp <- function(data) {
  data %>% 
    group_by(Year) %>% 
    summarize(LandOceanAvgTemp = mean(as.numeric(LandAndOceanAverageTemperature),na.rm = TRUE),
                  LandOceanAvgTempUncertainty = mean(as.numeric(LandAndOceanAverageTemperatureUncertainty),na.rm= TRUE)
            )
}

tmp.data <- agg.by.year(data = cd.data)
land.temp <- annual_land_temp(tmp.data)
land.ocean.temp <- annual_land_ocean_temp(tmp.data)

write.csv(land.temp, '../Datasets/land_temperature.csv')
write.csv(land.ocean.temp, '../Datasets/land_ocean_temperature.csv')
