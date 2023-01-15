options(warn=-1)
args = commandArgs(trailingOnly=TRUE)
library(magrittr)
library(ggplot2)
library(scales)
setwd(args[2])

if(length(args)!=4){
  stop("4 argument must be supplied (input file).n", call.=FALSE)
}

meta <- args[1] %>%
  read.table(., sep="\t", header=T, fill = T, quote = "", row.names = NULL, stringsAsFactors = FALSE)
meta$date %>%
  as.Date() %>%
  data.frame(date=.) %>%
  ggplot(., aes(x=date)) +
  geom_bar(fill="red") +
  scale_x_date(breaks = "1 month", labels = date_format("%Y-%b"), limits = c(as.Date(args[3]), as.Date(args[4])) ) +
  theme_classic() +
  labs(title=paste0("sampling date distribution: delta wave (", nrow(meta), " genomes)")) +
  theme(
    plot.title = element_text(color="red", size=14, face="bold.italic"),
    axis.title.x = element_text(color="blue", size=14, face="bold"),
    axis.title.y = element_text(color="#993333", size=14, face="bold"),
    axis.text.x = element_text(angle=60, hjust=1)
  )
ggsave("samplingDateDistribution.pdf", width = 12, height = 6)