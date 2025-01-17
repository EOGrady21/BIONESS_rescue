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


library(BIONESSQC)
datapath <- 'R:/Science/BIODataSvc/SRC/ZPlankton_DataRescue/OGrady_2024/raw_data'
# Gather all files for HUD2014030 (test mission to be loaded first)
efiles <- readxl::read_xlsx(file.path(datapath, 'HUD2014030/HUD2014030_electronic_file_log.xlsx'))
efile_paths <- list()
for (i in 1:length(efiles$electronic_file_name)) {
  efile_paths[[i]] <- list.files(file.path(datapath, efiles$mission[i]),
                                 pattern = efiles$electronic_file_name[i],
                                 recursive = TRUE,
                                 full.names = TRUE)
}

bionessdata <- list()
for (i in 1:length(efile_paths)) {
  bionessdata[[i]] <- read_bioness(efile_paths[[i]])
}




# Once the electronic files were accessible in R, I was able to extract the volume 
# data to provide along with the plankton taxonomic data and other event metadata.


# Read the volume table
vol_table <- readxl::read_xlsx(file.path(datapath, 'HUD2014030/HUD2014030_electronic_file_log.xlsx'))

# Synthesize volume data in a table for loading
vol_full <- map_dfr(bionessdata, function(efiledat) {
  event_num <- as.numeric(efiledat$metadata$`Event #`)
  net_nums <- as.numeric(str_extract(efiledat$data$net_number, "\\d+"))
  volume <- as.numeric(efiledat$data$volume)
  
  vol_dat <- data.frame(event_num, net_nums, volume)
  
  vol_table %>%
    select(-volume) %>%
    inner_join(vol_dat, by = c('event' = 'event_num', 'net_number' = 'net_nums'))
})

xlsx::write.xlsx(x = vol_full,
                 file = file.path(datapath, 'HUD2014030/HUD2014030_electronic_file_log.xlsx')
)

head(vol_full)
