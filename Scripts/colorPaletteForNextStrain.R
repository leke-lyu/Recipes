options(warn=-1)
args = commandArgs(trailingOnly=TRUE)
library(RColorBrewer)
library(magrittr)

coul <- brewer.pal(9, "Set1") #display.brewer.all()

nextstrainMeta <- args[1] %>%
  read.table(., sep = "\t", header = T, fill = T, quote = "", row.names = NULL, stringsAsFactors = FALSE)

region <- nextstrainMeta$region %>% unique()
coulregion <- region %>% length %>% colorRampPalette(coul)(.)
regionColor <- data.frame(code="region", place=region, color=coulregion)
args[2] %>%
  paste0(., "/colors.tsv") %>%
  write.table(regionColor, ., sep="\t", row.names = FALSE, col.names = FALSE, quote=F, append=TRUE)

country <- nextstrainMeta$country %>% unique()
country <- country[is.na(pmatch(country, region))]
coulcountry <- country %>% length %>% colorRampPalette(coul)(.)
countryColor <- data.frame(code="country", place=country, color=coulcountry)
args[2] %>%
  paste0(., "/colors.tsv") %>% 
  write.table(countryColor, ., sep="\t", row.names = FALSE, col.names = FALSE, quote=F, append=TRUE)
regionColor <- data.frame(code="country", place=region, color=coulregion)
args[2] %>%
  paste0(., "/colors.tsv") %>% 
  write.table(regionColor, ., sep="\t", row.names = FALSE, col.names = FALSE, quote=F, append=TRUE)

division <- nextstrainMeta$division %>% unique()
division <- division[is.na(pmatch(division, country))]
division <- division[is.na(pmatch(division, region))]
couldivision <- division %>% length %>% colorRampPalette(coul)(.)
divisionColor <- data.frame(code="division", place=division, color=couldivision)
args[2] %>%
  paste0(., "/colors.tsv") %>% 
  write.table(divisionColor, ., sep="\t", row.names = FALSE, col.names = FALSE, quote=F, append=TRUE)
countryColor <- data.frame(code="division", place=country, color=coulcountry)
args[2] %>%
  paste0(., "/colors.tsv") %>% 
  write.table(countryColor, ., sep="\t", row.names = FALSE, col.names = FALSE, quote=F, append=TRUE)
regionColor <- data.frame(code="division", place=region, color=coulregion)
args[2] %>%
  paste0(., "/colors.tsv") %>% 
  write.table(regionColor, ., sep="\t", row.names = FALSE, col.names = FALSE, quote=F, append=TRUE)

location <- nextstrainMeta$location %>% unique()
location <- location[is.na(pmatch(location, division))]
location <- location[is.na(pmatch(location, country))]
location <- location[is.na(pmatch(location, region))]
coullocation <- location %>% length %>% colorRampPalette(coul)(.)
locationColor <- data.frame(code="location", place=location, color=coullocation)
args[2] %>%
  paste0(., "/colors.tsv") %>% 
  write.table(locationColor, ., sep="\t", row.names = FALSE, col.names = FALSE, quote=F, append=TRUE)
divisionColor <- data.frame(code="location", place=division, color=couldivision)
args[2] %>%
  paste0(., "/colors.tsv") %>% 
  write.table(divisionColor, ., sep="\t", row.names = FALSE, col.names = FALSE, quote=F, append=TRUE)
countryColor <- data.frame(code="location", place=country, color=coulcountry)
args[2] %>%
  paste0(., "/colors.tsv") %>% 
  write.table(countryColor, ., sep="\t", row.names = FALSE, col.names = FALSE, quote=F, append=TRUE)
regionColor <- data.frame(code="location", place=region, color=coulregion)
args[2] %>%
  paste0(., "/colors.tsv") %>% 
  write.table(regionColor, ., sep="\t", row.names = FALSE, col.names = FALSE, quote=F, append=TRUE)

