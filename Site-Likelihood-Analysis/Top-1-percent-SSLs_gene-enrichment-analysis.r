#
# Running gene enrichment tests on the top 1% quantile of data from site specific likelihoods 
# Date: 2024/9/4
#
rm(list=ls())

# setwd
setwd("/home/administrator/ExtraSSD2/Justin/Analyses_JMB/SSL_plots/SSL_IQTREE_NucConcat/")

# load libraries
library(tidyverse)
library(rlist)
library(karyoploteR)
library(qqman)
library(dplyr)
library(purrr)

# # get mito and Z SSLs
# mito.ssl <- list.files(pattern = "\\.mitoTree.sitelh", full.names = TRUE)
# Z.ssl <- list.files(pattern = "\\.ZTree.sitelh", full.names = TRUE)

# # load in nuclear SSLs. Make sure the files are in the same order in both lists 
# gen.pos <- list.files(pattern = "partitions\\.txt$", full.names = TRUE)
# ssl <- list.files(pattern = "\\.nucTree.sitelh", full.names = TRUE)
# chromlist = c('scaffold-ma1',
#               'scaffold-ma2',
#               'scaffold-ma3',
#               'scaffold-ma4',
#               'scaffold-ma5',
#               'scaffold-ma6',
#               'scaffold-ma7',
#               'scaffold-mi1',
#               'scaffold-mi10',
#               'scaffold-mi2',
#               'scaffold-mi3',
#               'scaffold-mi4',
#               'scaffold-mi5',
#               'scaffold-mi6',
#               'scaffold-mi7',
#               'scaffold-mi8',
#               'scaffold-mi9',
#               'scaffold-Z')


# templist = list()

# # read in all of the partition files (obtained from catsequences)
# for(i in 1:length(gen.pos))
# {
#     gen.pos.file = gen.pos[i]
#     print(i)
#     data = read.delim(gen.pos.file, header = FALSE) %>%
#     mutate(V1 = gsub(".*_", "", V1)) %>% #.* in regex is any number (.) or any character (*)
#     mutate(V1 = gsub(".fasta", "", V1)) %>%
#     rowwise() %>% # must use this because dplyr works in a vector way, but strsplit outputs a list. So we do this row by row and take the proper element of the list each time.
#     mutate(start = strsplit(V1, "-")[[1]][1]) %>% #split on the "-" and will give two elements, one before and one after the dash. Here we are naming 1,1 as start and 1,2 as end (next line).
#     mutate(end = strsplit(V1, "-")[[1]][2]) %>%
#     as.data.frame()
    
#     temp <- readLines(ssl[i])
#     numbers <- as.numeric(strsplit(temp[2], "\\s+")[[1]])
#     nuc.numbers <- numbers[-1] # delete the first 'number' as it is NA due to the .sitelh format
#     temp <- readLines(mito.ssl[i])
#     numbers <- as.numeric(strsplit(temp[2], "\\s+")[[1]])
#     mito.numbers <- numbers[-1] # delete the first 'number' as it is NA due to the .sitelh format
#     temp <- readLines(Z.ssl[i])
#     numbers <- as.numeric(strsplit(temp[2], "\\s+")[[1]])
#     Z.numbers <- numbers[-1] # delete the first 'number' as it is NA due to the .sitelh format
    
#     templistpos = list()
#     for(j in 1:nrow(data))
#     {
#       print(paste0(j,'/',nrow(data)))
#       pos = seq(data$start[j], data$end[j], 1)
#       templistpos = list.append(templistpos, pos)
#     }
#     pos.vec =unlist(templistpos)
    
#     temp_df = data.frame(Chrom = chromlist[i],
#                          pos = pos.vec,
#                          nuc.ssl = nuc.numbers,
#                          mito.ssl = mito.numbers,
#                          Z.ssl = Z.numbers)
#     templist = list.append(templist,temp_df)
# }

# final_df = do.call(rbind.data.frame, templist)

# # write.csv(final_df, "SSL_all-chrom.csv")
# dim(final_df)


# # Read the .txt file
# data <- readLines()

# # Extract numbers from the second line
# numbers <- as.numeric(strsplit(data[2], "\\s+")[[1]])

# # Print the vector
# print(numbers)

###################################################
#
# Checking where the top 1% quantile of SSLs are
#
##################################################

# setwd
setwd("/home/administrator/ExtraSSD2/Justin/Analyses_JMB/SSL_plots/")

# this function is faster than read.csv but will make a new first column out of the row names, so we will select it out.
final_df = readr::read_csv("./SSL_all-chrom.csv") %>%
    as.data.frame() %>% 
    select(-1)
head(final_df)

# Make a column for the delta (change) SSL betwen nuclear and mito SSLs
# A difference between two logs is a ratio, so we need to transform after since we are not trying to get a ratio. 
delta.ssl <- as.data.frame(final_df) %>%
    mutate(Delta.NucMito = nuc.ssl-mito.ssl) %>%
    mutate(Delta.NucZ = nuc.ssl-Z.ssl)

head(delta.ssl)
range(delta.ssl$Delta.NucMito)


# remove outliers of Deltas keeping everything between 1 and 99% 
delta.ssl.no.out <- delta.ssl %>% 
  filter(Delta.NucMito > quantile(Delta.NucMito, 0.01) &
  Delta.NucMito < quantile(Delta.NucMito, 0.99)
  )

# make another dataframe that keeps only the top 1%
delta.ssl.out <- delta.ssl %>%
    filter(Delta.NucMito > quantile(Delta.NucMito, 0.99))

# check values
head(delta.ssl) #everything
head(delta.ssl.no.out) #no outliers (data in the 1-99% quantile)
head(delta.ssl.out) #only the outliers in the top 1% quantile

# bring in a bed file of gene names (obtained from a gtf and using bedtools gtf2bed)
genes <- read.delim("./converted.gene.names.bed", header = FALSE)
colnames(genes) <- c("chrom", "start", "end", "gene")
head(genes)

# bring in mito-nuc genes
oxphos <- read.delim("./OxPhos.genes.only.full.ordered.bed", header = FALSE)
oxphos <- oxphos %>%
    select(V1, V2, V3, V7)
colnames(oxphos) <- c("chrom", "start", "end", "gene")
head(oxphos)

# Let's see how many sites in the delta.ssl.out dataframe (top 1% quantil of the original dataframe delta.ssl) are found within a gene (the range of 'start' and 'end' within the 'genes' dataframe). There are a few ways to do this


#################### 1. Using R base and progress bar 

# We will use a progress bar to see how long this might take (can also use print functions but this is a nice package)
library(dplyr)
library(progress)

# Initialize an empty dataframe to store results
result <- data.frame()

# Create a progress bar
pb <- progress_bar$new(
  format = "  Processing [:bar] :percent in :elapsed",
  total = nrow(genes),
  width = 60
)

# Loop through each row in the genes dataframe
for (i in 1:nrow(genes)) {
  # Filter delta.ssl.out for positions within the current gene's range
  temp <- delta.ssl.out %>%
    filter(Chrom == genes$chrom[i] & pos >= genes$start[i] & pos <= genes$end[i]) %>%
    mutate(gene = genes$gene[i])
  
  # Bind the results together
  result <- bind_rows(result, temp)
  
  # Update the progress bar
  pb$tick()
}

# Count the number of matches for each gene
gene_counts <- result %>%
  group_by(gene) %>%
  summarize(count = n())

# Print the counts
print(gene_counts)

# Total count across all genes
gene.ssls <- nrow(result)
print(gene.ssls)

total.ssls <- nrow(delta.ssl.out)

# total of the top 1% SSLs that are in genes
gene.ssls/total.ssls
#.4584781

#################### 2. Same as above but using a print statement for the progress

# library(dplyr)

# # Initialize an empty dataframe to store results
# result <- data.frame()

# # Loop through each row in the genes dataframe
# for (i in 1:nrow(genes)) {
#   # Filter delta.ssl.out for positions within the current gene's range
#   temp <- delta.ssl.out %>%
#     filter(Chrom == genes$chrom[i] & pos >= genes$start[i] & pos <= genes$end[i]) %>%
#     mutate(gene = genes$gene[i])
  
#   # Bind the results together
#   result <- bind_rows(result, temp)
  
#   # Print progress
#   if (i %% 10 == 0) {  # Print progress every 10 iterations
#     print(paste("Processing gene", i, "of", nrow(genes), ":", genes$gene[i]))
#   }
# }

# # Count the number of matches for each gene
# gene_counts <- result %>%
#   group_by(gene) %>%
#   summarize(count = n())

# # Print the counts
# print(gene_counts)

# # Total count across all genes
# total_count <- nrow(result)
# print(total_count)



# Use intersect in bedtools to determine how many of our 10 kb alignments overlap with gene regions

pos <- read.delim(file = "chrom_start-positions.txt", header = FALSE)
pos <- pos %>%
  mutate(end = V2 + 1e4) %>%
  dplyr::rename(chrom = V1, start = V2)

# write out as bed files
write_delim(pos, file = "alignment_pos.bed", delim = "\t")
write_delim(genes, file = "gene_pos.bed", delim = "\t")

# send bedtools code to command line (need to have bedtools installed)
system("bedtools intersect -a gene_pos.bed -b alignment_pos.bed > alignment-gene_intersection.bed")

# read the resulting bed file back in
inter.pos.gene <- read.delim(file = "alignment-gene_intersection.bed", header = FALSE) 
inter.pos.gene <- inter.pos.gene %>%
  dplyr::rename(chrom = V1, start = V2, end = V3, gene = V4)

head(inter.pos.gene)

# make a length column to show how big the intersection is for a particular gene (10 kb alignment)
inter.pos.gene <- inter.pos.gene %>%
  mutate(length = end-start)


test <- read.delim(file = "converted.gene.names.bed", header = FALSE) 
test <- test %>%
  dplyr::rename(chrom = V1, start = V2, end = V3, gene = V4)
test <- test %>%
  mutate(length = end-start)
sum(test$length)
hist(test$length)

head(inter.pos.gene, 30)

# total number of base pairs where an alignment overlaps with a gene
gene.pos.overlap <- sum(inter.pos.gene$length)
# 119894471


# total base pairs of the alignments we have
total.pos <- sum(nrow(pos)*1e4)
# 310930000


# fraction of our windows in gene regions
gene.pos.overlap/total.pos 
# 0.3855996