# Volume data extraction

# The electronic file log was generated manually with information from the 
# logsheets, electronic files and taxonomic data. It includes columns
# - mission
# - tow
# - event
# - electronic_file_name
# - sample_id
# - net_number
# - volume

library(tidyverse)
library(BIONESSQC)
datapath <- 'R:/Science/BIODataSvc/SRC/ZPlankton_DataRescue/OGrady_2024/raw_data'
# Gather all files for HUD2014030 (test mission to be loaded first)
efiles_log <- list.files(datapath, pattern = 'electronic_file_log.xlsx',
                         recursive = TRUE,
                         full.names = TRUE)
efiles_log <- efiles_log[12:14]
# efiles <- readxl::read_xlsx(file.path(datapath, 'HUD2014030/HUD2014030_electronic_file_log.xlsx'))

for (log in efiles_log) {
  efiles <- readxl::read_xlsx(log)
  cat('.')

efile_paths <- list()
for (i in 1:length(efiles$electronic_file_name)) {
  
  efile_paths[[i]] <- list.files(file.path(datapath, efiles$mission[i]),
                                 pattern = efiles$electronic_file_name[i],
                                 recursive = TRUE,
                                 full.names = TRUE)
}
cat('.')

bionessdata <- list()
for (i in 1:length(efile_paths)) {
  bionessdata[[i]] <- read_bioness(efile_paths[[i]])
}


cat('.')

# Once the electronic files were accessible in R, I was able to extract the volume 
# data to provide along with the plankton taxonomic data and other event metadata.
if (!'volume' %in% colnames(efiles)){
efiles <- efiles %>%
  dplyr::mutate(volume = NA)
}

# Synthesize volume data in a table for loading
vol_full <- map_dfr(bionessdata, function(efiledat) {
  event_num <- as.numeric(efiledat$metadata$`Event #`)
  net_nums <- as.numeric(str_extract(efiledat$data$net_number, "\\d+"))
  volume <- as.numeric(efiledat$data$volume)
  
  vol_dat <- data.frame(event_num, net_nums, volume)
  
  efiles %>%
    select(-volume) %>%
    inner_join(vol_dat, by = c('event' = 'event_num', 'net_number' = 'net_nums'))
})

# remove duplicates if necessary
vol_full <- vol_full %>% distinct()
if (nrow(vol_full) == 0) {
  stop('Empty volume dataframe! Check metadata matching between electronic files')
}

cat('.')

xlsx::write.xlsx(x = vol_full,
                 file = log)

cat('File: ', log, 'complete! \n')
cat('========================================================================')

}

