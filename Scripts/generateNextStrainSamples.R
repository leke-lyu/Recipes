options(warn=-1)
args = commandArgs(trailingOnly=TRUE)
library(magrittr)
library(RSQLite)
library(DBI)

if(length(args)!=11){
  stop("At least 11 argument must be supplied (input file).n", call.=FALSE)
}

# prepare the ZIP code table for US districts
temp <- tempfile()
"http://download.geonames.org/export/zip/US.zip" %>% download.file(., temp)
zipCodeTable <- temp %>%
  unz(., "US.txt") %>%
  read.table(., sep="\t")
unlink(temp)
names(zipCodeTable) = c("CountryCode", "zip", "PlaceName", "AdminName1", "AdminCode1", "AdminName2", "AdminCode2", "AdminName3", "AdminCode3", "latitude", "longitude", "accuracy")
#counties <- zipCodeTable %>% dplyr::filter(AdminName1=="Texas") %>% dplyr::select(AdminName2) %>% unique() %>% .[,1]
#for(i in counties){
#  latitude <- zipCodeTable %>% dplyr::filter(AdminName1=="Texas" & AdminName2==i) %>% dplyr::select(latitude) %>% .[,1] %>% mean()
#  longitude <- zipCodeTable %>% dplyr::filter(AdminName1=="Texas" & AdminName2==i) %>% dplyr::select(longitude) %>% .[,1] %>% mean()
#  line=paste0("location\t",i," county\t",latitude,"\t",longitude)
#  write(line, file="lat_longs.tsv", append=TRUE)
#}

# select delta, filter zip code, and add the "county" column
vendorDeltaMeta <- args[1] %>%
  read.table(., sep=",", header=TRUE) %>%
  dplyr::filter(clade_Nextclade_clade=="21A (Delta)") #select delta
zipAndCounty <- vendorDeltaMeta %>%
  dplyr::count(., zip, sort = TRUE) %>%
  merge(., zipCodeTable) %>%
  dplyr::select(zip, AdminName1, AdminName2) #remove wrong zip codes 
zipAndCounty <- zipAndCounty[zipAndCounty$AdminName1=="Texas",] %>%
  dplyr::select(zip, AdminName2) #only select Texas
vendorDeltaMeta <- merge(vendorDeltaMeta, zipAndCounty)
rm(zipAndCounty, zipCodeTable, temp)
conn <- args[2] %>%
  dbConnect(RSQLite::SQLite(), .)
vendorDeltaMeta %>% dplyr::select(GISAID_name) %>% dbWriteTable(conn, "vendorDeltaGISAID_name", ., overwrite=TRUE) #dbListTables(conn)

# prepare worldwide sample list
texasSeq <- args[4] %>%
  paste0("SELECT * FROM GISAID_meta WHERE Virus_name in (SELECT GISAID_name FROM vendorDeltaGISAID_name) AND Variant LIKE '%Delta%' AND Is_high_coverage_ Like '%True%' AND Is_complete_ Like '%True%' ORDER BY RANDOM() LIMIT ", .) %>%
  dbGetQuery(conn, .)
maxDate <- texasSeq$Collection_date %>% as.Date() %>% max()
args[3] %>%
  paste0(., "/seq.list") %>%
  write.table(texasSeq$Accession_ID, ., sep = ",", append=TRUE, col.names = F, row.names = F, quote = F)

usaSeq <- args[5] %>%
  paste0("SELECT * FROM GISAID_meta WHERE Location LIKE '%North America / USA / %' AND Location NOT LIKE '%North America / USA / Texas%' AND Host LIKE '%Human%' AND Variant LIKE '%Delta%' AND Is_high_coverage_ Like '%True%' AND Is_complete_ Like '%True%' AND Collection_date GLOB '20[1-2][0-9]-[0-1][0-9]-[0-3][0-9]' AND Collection_date < '", maxDate, "' ORDER BY RANDOM() LIMIT ", .) %>%
  dbGetQuery(conn, .)
args[3] %>%
  paste0(., "/seq.list") %>%
  write.table(usaSeq$Accession_ID, ., sep = ",", append=TRUE, col.names = F, row.names = F, quote = F)

northAmericaSeq <- args[6] %>%
  paste0("SELECT * FROM GISAID_meta WHERE Location LIKE '%North America / %' AND Location NOT LIKE '%North America / USA%' AND Host LIKE '%Human%' AND Variant LIKE '%Delta%' AND Is_high_coverage_ Like '%True%' AND Is_complete_ Like '%True%' AND Collection_date GLOB '20[1-2][0-9]-[0-1][0-9]-[0-3][0-9]' AND Collection_date < '", maxDate, "' ORDER BY RANDOM() LIMIT ", .) %>%
  dbGetQuery(conn, .)
args[3] %>%
  paste0(., "/seq.list") %>%
  write.table(northAmericaSeq$Accession_ID, ., sep = ",", append=TRUE, col.names = F, row.names = F, quote = F)

africaSeq <- args[7] %>% 
  paste0("SELECT * FROM GISAID_meta WHERE Location LIKE '%Africa / %' AND Host LIKE '%Human%' AND Variant LIKE '%Delta%' AND Is_high_coverage_ Like '%True%' AND Is_complete_ Like '%True%' AND Collection_date GLOB '20[1-2][0-9]-[0-1][0-9]-[0-3][0-9]' AND Collection_date < '", maxDate, "' ORDER BY RANDOM() LIMIT ", .) %>%
  dbGetQuery(conn, .)
args[3] %>%
  paste0(., "/seq.list") %>%
  write.table(africaSeq$Accession_ID, ., sep = ",", append=TRUE, col.names = F, row.names = F, quote = F)

asiaSeq <- args[8] %>%
  paste0("SELECT * FROM GISAID_meta WHERE Location LIKE '%Asia / %' AND Host LIKE '%Human%' AND Variant LIKE '%Delta%' AND Is_high_coverage_ Like '%True%' AND Is_complete_ Like '%True%' AND Collection_date GLOB '20[1-2][0-9]-[0-1][0-9]-[0-3][0-9]' AND Collection_date < '", maxDate, "' ORDER BY RANDOM() LIMIT ", .) %>%
  dbGetQuery(conn, .)
args[3] %>%
  paste0(., "/seq.list") %>%
  write.table(asiaSeq$Accession_ID, ., sep = ",", append=TRUE, col.names = F, row.names = F, quote = F)

europeSeq <- args[9] %>%
  paste0("SELECT * FROM GISAID_meta WHERE Location LIKE '%Europe / %' AND Host LIKE '%Human%' AND Variant LIKE '%Delta%' AND Is_high_coverage_ Like '%True%' AND Is_complete_ Like '%True%' AND Collection_date GLOB '20[1-2][0-9]-[0-1][0-9]-[0-3][0-9]' AND Collection_date < '", maxDate, "' ORDER BY RANDOM() LIMIT ", .) %>%
  dbGetQuery(conn, .)
args[3] %>%
  paste0(., "/seq.list") %>%
  write.table(europeSeq$Accession_ID, ., sep = ",", append=TRUE, col.names = F, row.names = F, quote = F)

oceaniaSeq <- args[10] %>%
  paste0("SELECT * FROM GISAID_meta WHERE Location LIKE '%Oceania / %' AND Host LIKE '%Human%' AND Variant LIKE '%Delta%' AND Is_high_coverage_ Like '%True%' AND Is_complete_ Like '%True%' AND Collection_date GLOB '20[1-2][0-9]-[0-1][0-9]-[0-3][0-9]' AND Collection_date < '", maxDate, "' ORDER BY RANDOM() LIMIT ", .) %>%
  dbGetQuery(conn, .)
args[3] %>%
  paste0(., "/seq.list") %>%
  write.table(oceaniaSeq$Accession_ID, ., sep = ",", append=TRUE, col.names = F, row.names = F, quote = F)

southAmericaSeq <- args[11] %>%
  paste0("SELECT * FROM GISAID_meta WHERE Location LIKE '%South America / %' AND Host LIKE '%Human%' AND Variant LIKE '%Delta%' AND Is_high_coverage_ Like '%True%' AND Is_complete_ Like '%True%' AND Collection_date GLOB '20[1-2][0-9]-[0-1][0-9]-[0-3][0-9]' AND Collection_date < '", maxDate, "' ORDER BY RANDOM() LIMIT ", .) %>%
  dbGetQuery(conn, .)
args[3] %>%
  paste0(., "/seq.list") %>%
  write.table(southAmericaSeq$Accession_ID, ., sep = ",", append=TRUE, col.names = F, row.names = F, quote = F)
