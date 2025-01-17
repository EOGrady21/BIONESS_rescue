# gather loaded BIONESS data and check mission and station count


library(tidyverse)
library(readxl)

data <- read_csv("BIONESS_loaded.csv")

# GATHER UNIQUE NAME AND COLLECTOR STATIO NAME COMBINATIONS AND COUNT ROWS
SUMMDAT <- data %>%
  group_by(NAME, COLLECTOR_STATION_NAME, INSTITUTE) %>%
  summarise(n = n()) %>%
  select(NAME, COLLECTOR_STATION_NAME, INSTITUTE, n) %>%
  rename(N_data_rows = n)

num_mission <- length(unique(SUMMDAT$NAME))
num_mission_bio <- length(unique(SUMMDAT$NAME[SUMMDAT$INSTITUTE == "BIO"]))  

write.csv(SUMMDAT, 'BIONESS_BIOCHEM_summary.csv')
