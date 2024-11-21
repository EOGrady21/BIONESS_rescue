library(librarian)
shelf(fs, tidyverse, here, ROracle, DBI)

# read in BIOCHEM creds
source('c:/users/ogradye/desktop/biochem_creds.R')

bioness_missions <- list.files('R:/Science/BIODataSvc/SRC/ZPlankton_DataRescue/OGrady_2024/raw_data')

# query biochem
conn <- try(expr = {
  dbConnect(dbDriver("Oracle"), biochem.user, biochem.password, dbname = "PTRAN")
}, silent = TRUE)
if (class(conn) == 'try-error'){
  stop('Cannot connect to BioChem!')
}

for (i in 1:length(bioness_missions)) {
cruisename <- bioness_missions[i]
query <- stringr::str_c(readLines('check_event_md.sql'), collapse = " ")
query <- gsub(x = query, pattern = 'cruisename', replacement = cruisename)
query <- str_trim(query, side = 'both')


data <- dbGetQuery(conn, query)


# export data because evnt numbers are too inconsistent to compare programatically :(
filepath <- file.path('R:/Science/BIODataSvc/SRC/ZPlankton_DataRescue/OGrady_2024/raw_data',
                      cruisename,
                      paste0(cruisename, '_event_md_biochem.csv'))
write.csv(data, filepath, row.names = FALSE)
}

dbDisconnect(conn)

# sort events numerically

# load in bioness raw data

# compare event numbers

# export list of bioness events not in biochem