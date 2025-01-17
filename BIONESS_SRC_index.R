library(fs)
library(tidyverse)

directory <- "R:/Science/BIODataSvc/SRC/2010s"
search_string <- "BIONESS"
date_threshold <- as.POSIXct("2011-01-01") 

filtered_files <- dir_ls(
  path = directory,
  recurse = TRUE,
  type = "file",
  regexp = search_string,
  fail = FALSE
) %>%
  keep(~ file_info(.x)$birth_time > date_threshold)

