options(warn=-1)
args = commandArgs(trailingOnly=TRUE)
library(magrittr)
library(RSQLite)
library(DBI)
library(stringr)

if(length(args)!=3){
  stop("3 argument must be supplied (input file).n", call.=FALSE)
}

# prepare the ZIP code table for US districts
temp <- tempfile()
"http://download.geonames.org/export/zip/US.zip" %>% download.file(., temp)
zipCodeTable <- temp %>%
  unz(., "US.txt") %>%
  read.table(., sep="\t")
unlink(temp)
names(zipCodeTable) = c("CountryCode", "zip", "PlaceName", "AdminName1", "AdminCode1", "AdminName2", "AdminCode2", "AdminName3", "AdminCode3", "latitude", "longitude", "accuracy")

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
texasSeqMeta <- "SELECT * FROM GISAID_meta WHERE Virus_name in (SELECT GISAID_name FROM vendorDeltaGISAID_name) AND Variant LIKE '%Delta%' AND Is_high_coverage_ Like '%True%' AND Is_complete_ Like '%True%'" %>%
  dbGetQuery(conn, .) #vendorDeltaMeta[vendorDeltaMeta$GISAID_name %in% texasSeqMeta$Virus_name, ]
args[3] %>%
  paste0(., "/seq.list") %>%
  write.table(texasSeqMeta$Accession_ID, ., sep = ",", append=TRUE, col.names = F, row.names = F, quote = F)

idAndCounty <- vendorDeltaMeta %>% 
  dplyr::select(GISAID_name, AdminName2) %>% 
  merge(texasSeqMeta, ., by.x = 'Virus_name', by.y ='GISAID_name') %>%
  dplyr::select(Virus_name, Accession_ID, Collection_date, AdminName2)
idAndCounty <- data.frame(tip=paste(str_replace_all(idAndCounty$Virus_name, "/", "_"), idAndCounty$Accession_ID, idAndCounty$Collection_date, sep="_"), location=idAndCounty$AdminName2) 

temp <- tempfile()
"https://raw.githubusercontent.com/leke-lyu/Recipes/main/Data/taxesPublicHealthRegions.txt" %>% download.file(., temp)
taxesHealthRegions <- temp %>%
  read.table(., sep="\t", header=T)
unlink(temp)
idAndHealthRegions <- merge(idAndCounty, taxesHealthRegions, by.x = 'location', by.y ='County.Name') %>%
  dplyr::select(tip, Health.Service.Region)


save(vendorDeltaMeta, texasSeqMeta, idAndCounty, idAndHealthRegions, file = paste0(args[3], "/data.RData"))

