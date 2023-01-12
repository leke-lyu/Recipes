options(warn=-1)
args = commandArgs(trailingOnly=TRUE)
library(RSQLite)
library(DBI)
setwd(dirname(args[1]))

if(length(args)==0){
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
}else if(length(args)==1){
  whole_meta <- read.table(paste0(args[1], "/metadata.tsv"), #read the table
                           sep="\t",
                           header=T,
                           fill = T,
                           quote = "",
                           row.names = NULL,
                           stringsAsFactors = FALSE)
  names(whole_meta) <- gsub("\\.", "_", names(whole_meta)) #change name tags
  conn <- dbConnect(RSQLite::SQLite(), "meta.db")
  dbWriteTable(conn, "GISAID_meta", whole_meta)
  rm(whole_meta)
}
