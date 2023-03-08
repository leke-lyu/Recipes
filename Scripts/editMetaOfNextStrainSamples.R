options(warn=-1)
args = commandArgs(trailingOnly=TRUE)
library(magrittr)

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

# edit nextstrainMeta
nextstrainMeta <- args[2] %>%
  read.table(., sep = "\t", header = T, fill = T, quote = "", row.names = NULL, stringsAsFactors = FALSE)
nextstrainMeta[nextstrainMeta$sex!="Male" & nextstrainMeta$sex!="Female", "sex"] <- "Unknown" #add traits like age and race in the future
for(i in 1:nrow(nextstrainMeta)){
  id <- nextstrainMeta[i, "strain"]
  if(nextstrainMeta[i, "region"]=="North America" & nextstrainMeta[i, "country"]=="USA" & nextstrainMeta[i, "division"]=="Texas"){
    nextstrainMeta[i, "location"] <- paste0(vendorDeltaMeta[vendorDeltaMeta$GISAID_name %in% id, "AdminName2"], " county")
    nextstrainMeta[i, "sex"] <- vendorDeltaMeta[vendorDeltaMeta$GISAID_name %in% id, "sex"]
  }
  if(nextstrainMeta[i, "region"]=="North America" & nextstrainMeta[i, "country"]=="USA" & nextstrainMeta[i, "division"]!="Texas"){
    nextstrainMeta[i, "location"] <- nextstrainMeta[i, "division"]
  }
  if(nextstrainMeta[i, "region"]=="North America" & nextstrainMeta[i, "country"]!="USA"){
    nextstrainMeta[i, "division"] <- nextstrainMeta[i, "country"]
    nextstrainMeta[i, "division_exposure"] <- nextstrainMeta[i, "country"]
    nextstrainMeta[i, "location"] <- nextstrainMeta[i, "country"]
  }
  if(nextstrainMeta[i, "region"]!="North America"){
    nextstrainMeta[i, "country"] <- nextstrainMeta[i, "region"]
    nextstrainMeta[i, "country_exposure"] <- nextstrainMeta[i, "region"]
    nextstrainMeta[i, "division"] <- nextstrainMeta[i, "region"]
    nextstrainMeta[i, "division_exposure"] <- nextstrainMeta[i, "region"]
    nextstrainMeta[i, "location"] <- nextstrainMeta[i, "region"]
  }
}
args[2] %>% write.table(nextstrainMeta, ., sep="\t", row.names = F, col.names = T, quote=F)
