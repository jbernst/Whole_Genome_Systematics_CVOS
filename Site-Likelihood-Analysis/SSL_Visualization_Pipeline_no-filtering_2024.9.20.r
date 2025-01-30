#
# Checking Site Specific Likelihoods (SSL) from IQTREE2
# Date: 2024/3/4
#

# setwd
setwd("/home/administrator/ExtraSSD2/Justin/Analyses_JMB/SSL_plots/SSL_IQTREE_NucConcat/")

list.files()

# load libraries
library(tidyverse)
library(rlist)
library(karyoploteR)

## we need to fix mi1 as we realized mi1 and mi10 files got fused together
# mi1.partitions <- read.delim("./mi1_allseqs.partitions.txt", header = FALSE)

## went in and deleted the mi10 lines fro mi1.partitions.txt, and now we will renumber the positions in the file so they start from 1
# for(i in 1:nrow(mi1.partitions)) {
#     if(i == 1) {
#         start = 1
#         start_val = 1
#         end = 10001
#         end_val = 10001
#     }
#     else{
#         start_val = start_val + 10001
#         end_val = end_val + 10001
#         start = c(start, start_val)
#         end = c(end, end_val)
#     }
# }
# vec = paste0(paste(start,end,sep = '-'),';')
# mi1.partitions$V3 = vec
# write_delim(mi1.partitions, "mi1_allseqs.partitions.txt", delim = '\t', col_names = FALSE)

# mi1.partitions <- read.delim("./mi1_allseqs.partitions.txt", header = FALSE)

# get mito and Z SSLs
mito.ssl <- list.files(pattern = "\\.mitoTree.sitelh", full.names = TRUE)
Z.ssl <- list.files(pattern = "\\.ZTree.sitelh", full.names = TRUE)

# load in nuclear SSLs. Make sure the files are in the same order in both lists 
gen.pos <- list.files(pattern = "partitions\\.txt$", full.names = TRUE)
ssl <- list.files(pattern = "\\.nucTree.sitelh", full.names = TRUE)
chromlist = c('scaffold-ma1',
              'scaffold-ma2',
              'scaffold-ma3',
              'scaffold-ma4',
              'scaffold-ma5',
              'scaffold-ma6',
              'scaffold-ma7',
              'scaffold-mi1',
              'scaffold-mi10',
              'scaffold-mi2',
              'scaffold-mi3',
              'scaffold-mi4',
              'scaffold-mi5',
              'scaffold-mi6',
              'scaffold-mi7',
              'scaffold-mi8',
              'scaffold-mi9',
              'scaffold-Z')


templist = list()

# read in all of the partition files (obtained from catsequences)
for(i in 1:length(gen.pos))
{
    gen.pos.file = gen.pos[i]
    print(i)
    data = read.delim(gen.pos.file, header = FALSE) %>%
    mutate(V1 = gsub(".*_", "", V1)) %>% #.* in regex is any number (.) or any character (*)
    mutate(V1 = gsub(".fasta", "", V1)) %>%
    rowwise() %>% # must use this because dplyr works in a vector way, but strsplit outputs a list. So we do this row by row and take the proper element of the list each time.
    mutate(start = strsplit(V1, "-")[[1]][1]) %>% #split on the "-" and will give two elements, one before and one after the dash. Here we are naming 1,1 as start and 1,2 as end (next line).
    mutate(end = strsplit(V1, "-")[[1]][2]) %>%
    as.data.frame()
    
    temp <- readLines(ssl[i])
    numbers <- as.numeric(strsplit(temp[2], "\\s+")[[1]])
    nuc.numbers <- numbers[-1] # delete the first 'number' as it is NA due to the .sitelh format
    temp <- readLines(mito.ssl[i])
    numbers <- as.numeric(strsplit(temp[2], "\\s+")[[1]])
    mito.numbers <- numbers[-1] # delete the first 'number' as it is NA due to the .sitelh format
    temp <- readLines(Z.ssl[i])
    numbers <- as.numeric(strsplit(temp[2], "\\s+")[[1]])
    Z.numbers <- numbers[-1] # delete the first 'number' as it is NA due to the .sitelh format
    
    templistpos = list()
    for(j in 1:nrow(data))
    {
      print(paste0(j,'/',nrow(data)))
      pos = seq(data$start[j], data$end[j], 1)
      templistpos = list.append(templistpos, pos)
    }
    pos.vec =unlist(templistpos)
    
    temp_df = data.frame(Chrom = chromlist[i],
                         pos = pos.vec,
                         nuc.ssl = nuc.numbers,
                         mito.ssl = mito.numbers,
                         Z.ssl = Z.numbers)
    templist = list.append(templist,temp_df)
}

final_df = do.call(rbind.data.frame, templist)

write.csv(final_df, "SSL_all-chrom.csv")
dim(final_df)


# Read the .txt file
data <- readLines()

# Extract numbers from the second line
numbers <- as.numeric(strsplit(data[2], "\\s+")[[1]])

# Print the vector
print(numbers)

###############################
#
# Investigations of chromosomes 
#
##############################


# setwd
setwd("/home/administrator/ExtraSSD2/Justin/Analyses_JMB/SSL_plots/")

# this function is faster than read.csv but will make a new first column out of the row names, so we will select it out.
final_df = readr::read_csv("./SSL_all-chrom.csv") %>%
    as.data.frame() %>% 
    select(-1)


final_df %>% filter(Chrom == 'scaffold-mi1' & pos == 70020)


head(final_df)

NucMito.diff <- as.data.frame(final_df) %>%
    mutate(Delta.NucMito = nuc.ssl-mito.ssl)

head(NucMito.diff)


# plot a chromosome
# jpeg("ma1_SSL_DeltaNucMito.jpg",3000,3000,res=300)
# NucMito.diff %>%
#     filter(Chrom == "scaffold-ma1") %>%
#     ggplot(aes(x = pos, y = Delta.NucMito)) +
#     geom_point()
# dev.off()

# loop through all chromosomes and print out graphs
chrom = unique(final_df$Chrom)
for(i in chrom){
    jpeg(paste(i,".NucMito.jpg"),3000,3000,res=300)
    p = NucMito.diff %>%
        filter(Chrom == i) %>%
        ggplot(aes(x = pos, y = Delta.NucMito)) +
        geom_point()
    print(p)
    dev.off()
}

# check numbers in a table
range(NucMito.diff$mito.ssl)
head(NucMito.diff)

# there are clearly outliers in the negative part of the distribution. Let's filter for these to identify where
head(NucMito.diff %>% filter(nuc.ssl == min(nuc.ssl)))


# make BINs
final_df_bins <- NucMito.diff %>%
    mutate(Delta.NucMito.BIN = ifelse(
        Delta.NucMito < 0, "Negative", "Positive")
    ) %>%
    group_by(Chrom, Delta.NucMito.BIN) %>% #group by chromosome AND BINs  
    summarise(count = n()) #count the number of occurence in each group. It will count, per chromosome, each of the BINs. Summarise will calculate whatever you want based on the group_by groups (so we will count = n()) for each group. Can do this for meanm or summary statistics, etc. Grouping it makes a smaller data frame which was summarized.

final_df_bins <- mutate(final_df_bins, log.counts = log10(count))

head(final_df_bins)

View(final_df_bins)
# make bar graph
# jpeg("DeltaSSL-Nuc-vs-Mito.jpg", 2000, 2000, res = 300)
# ggplot(final_df_bins, aes(x = Chrom, y = log.counts, fill = Delta.NucMito.BIN)) +
#     geom_col(position = "stack") + 
#     ggtitle("Delta SSL: Nuclear vs. Mito")
# dev.off()

# make bar graph filtering out the big categories
# final_df_bins_filter <- final_df_bins %>%
#     filter(Delta.NucMito.BIN != "0 to 0.5" & Delta.NucMito.BIN != "-0.5 to 0")

# jpeg("DeltaSSL-Nuc-vs-Mito-filtered.jpg", 2000, 2000, res = 300)
# ggplot(final_df_bins_filter, aes(x = Chrom, y = count, fill = Delta.NucMito.BIN)) +
#     geom_col(position = "stack") + 
#     ggtitle("Delta SSL: Nuclear vs. Mito filtered")
# dev.off()

# try plotting with karyoploteR
library(karyoploteR)
chrom = read.delim('chrom_for_karyo.txt')
chr_names = gsub('scaffold-','',chrom$chr)

# create a genome range object, which is needed for karyoploteR. Requires a bed file (chom, start, end) and then the values of what you want to plot.
genome = toGRanges(chrom)

centro = read.delim('CentroMap.txt')
centro_rg = toGRanges(centro)

# make bins again. This is a delta SSL, so anything positive supports the nuclear tree, and anything negative supports the mitochondrial tree.    
final_df_bin_cat <- NucMito.diff %>%
    mutate(Delta.NucMito.BIN = ifelse(
        Delta.NucMito < 0, "Negative", "Positive")
    )
head(final_df_bin_cat)

# make new dataframes for our categories (the 0.5 to -0.5 range is what we think may not be violating our model assumptions that much). Add chromosome start and end (which will be the same as we are just plotting the density of specific sites, not windows).
final_df_bin_mito <- final_df_bin_cat %>%
    filter(Delta.NucMito.BIN == "Negative") %>%
    mutate(start = pos, end = pos) %>%
    select(Chrom,start,end)

final_df_bin_nuc <- final_df_bin_cat %>%
    filter(Delta.NucMito.BIN == "Positive") %>%
    mutate(start = pos, end = pos) %>%
    select(Chrom,start,end)

mito_rg <- toGRanges(final_df_bin_mito)
nuc_rg <- toGRanges(final_df_bin_nuc)

# add a file to show what regions we data for (obtained by using the ranges of our alignments).
# data_algn <- read.delim("./data-algn.txt", header = FALSE)
# data_algn_rg <- toGRanges(data_algn) 

# we can also sort and then merge overlapping/juxtapods regions (sort and then merge using bedtools).
data_algn <- read.delim("./data-algn-sort-merge.bed", header = FALSE)
data_algn_rg <- toGRanges(data_algn) 

# add a file to show what genes 
data_gene <- read.delim("./converted.gene.names.bed", header = FALSE)
colnames(data_gene) <- c("chrom", "start", "end", "gene")
data_gene_rg <- toGRanges(data_gene) 

# bring in mito-nuc genes
data_mtnuc <- read.delim("./OxPhos.genes.only.full.ordered.bed", header = FALSE)
data_mtnuc <- data_mtnuc %>%
    select(V1, V2, V3, V7)
colnames(data_mtnuc) <- c("chrom", "start", "end", "gene")
head(data_mtnuc)
data_mtnuc_rg <- toGRanges(data_mtnuc)

# add a file for the recombination rates (we will log2 them) 
data_recomb <- read.delim("./viridis.recomb.10kb.txt", header = TRUE)
colnames(data_recomb) <- c("chrom", "start", "mean.rate")
data_recomb <- as.data.frame(data_recomb) %>%
    mutate(end = start) %>%
    select(chrom, start, end, mean.rate)
data_recomb <- data_recomb %>%
    mutate(mean.rate = log2(mean.rate))
data_recomb_rg <- toGRanges(data_recomb)

# prepare a color gradient for the recombination rates

library(colorRamp2)
getColorVec = function(values,cols = c('#4343ffab','#b4b4b4a4','#ff4b4baa'), range_quantiles = NA)
{
    if(is.na(range_quantiles))
    {
        high_lim = quantile(values,0.975, na.rm = T)
        midpoint = quantile(values,0.50, na.rm = T)
        low_lim = quantile(values,0.025, na.rm = T)
    }else
    {
        high_lim = quantile(values, range_quantiles[3], na.rm = T)
        midpoint = quantile(values, range_quantiles[2], na.rm = T)
        low_lim = quantile(values, range_quantiles[1], na.rm = T)
    }
    col_fun = colorRamp2(c(low_lim,midpoint,high_lim), cols)
    col_vector = col_fun(values)
    return(col_vector)
}

data_recomb <- data_recomb %>%
    mutate(color = getColorVec(mean.rate))

# # plot karyoplots (must restart every time if you want to change anything). For plotting on the chromosome, you don't need to use the rg version, but we made it anyways.
# pdf("SSL-Nuc-Mito_karyotype-small-large.pdf", 10, 15)
# kp = plotKaryotype(plot.type = 2, genome = genome, labels.plotter = NULL)
# kpPlotRegions(kp, data = data_algn, data.panel = 'ideogram', col = 'black')
# kpPlotRegions(kp, data = data_gene, data.panel = 'ideogram', col = 'blue')
# kpPlotRegions(kp, data = centro, data.panel = 'ideogram', col = '#ff00007f')
# kpDataBackground(kp, data.panel = 1, r0 = 0, r1 = 1, col = 'white')
# kpDataBackground(kp, data.panel = 2, r0 = 0, r1 = 1, col = 'white')
# kpAddChromosomeNames(kp, chr.names = chr_names, cex = 1.5)

# # Note: if you want to set up more than one data track (like below, we are adding a second dataset which is the 'large' filtered datasets), you must do the r0 = autotrack and give it which dataset it is out of how many
# kpPlotDensity(kp, data = nuc_rg, data.panel = 1, r0 = autotrack(1,2))
# kpPlotDensity(kp, data = nuc_rg_large, data.panel = 1, r0 = autotrack(2,2))
# kpPlotDensity(kp, data = mito_rg, data.panel = 2, r0 = autotrack(1,2))
# kpPlotDensity(kp, data = mito_rg_large, data.panel = 2, r0 = autotrack(2,2))
# dev.off()



###### plot everything on panel 1 with a gene density plot ##########################################

# pdf("SSL-Nuc-Mito_karyotype-small-large_panel1-only-mitonuc-ma3.pdf", 10, 15)
# kp = plotKaryotype(plot.type = 1, genome = genome, chromosomes = "scaffold-ma3", labels.plotter = NULL)
# kpPlotRegions(kp, data = data_algn, data.panel = 'ideogram', col = 'black')
# kpPlotRegions(kp, data = centro, data.panel = 'ideogram', col = '#ff00007f')
# kpPlotDensity(kp, data = data_gene_rg, data.panel = 'ideogram', col = '#1ec7ffc1', border = '#1ec7ff35')
# kpPlotRegions(kp, data = data_mtnuc, data.panel = 'ideogram', col = '#00ff44')
# kpDataBackground(kp, data.panel = 1, r0 = 0, r1 = 1, col = 'white')
# kpAddChromosomeNames(kp, chr.names = "ma3", cex = 1.5)

# # Note: if you want to set up more than one data track (like below, we are adding a second dataset which is the 'large' filtered datasets), you must do the r0 = autotrack and give it which dataset it is out of how many
# kpPlotDensity(kp, data = nuc_rg, data.panel = 1, r0 = 0.25, r1 = 0.5)
# kpPlotDensity(kp, data = nuc_rg_large, data.panel = 1, r0 = 0.75, r1 = 1)
# kpPlotDensity(kp, data = mito_rg, data.panel = 1, r0 = 0.25, r1 = 0)
# kpPlotDensity(kp, data = mito_rg_large, data.panel = 1, r0 = 0.75, r1 = 0.5)
# dev.off()


###### plot everything on panel 1 with a gene density plot  and recomb on the bottom ###############

# plot everything on panel 1 with a gene density plot
# pdf("SSL-Nuc-Mito_karyotype-small-large_panel1-merge-panel2-recomb.pdf",10, 15)
# kp = plotKaryotype(plot.type = 2, genome = genome, labels.plotter = NULL)
# kpPlotRegions(kp, data = data_algn, data.panel = 'ideogram', col = 'black')
# kpPlotRegions(kp, data = centro, data.panel = 'ideogram', col = '#ff00007f')
# kpPlotDensity(kp, data = data_gene_rg, data.panel = 'ideogram', col = '#1ec7ffc1', border = '#1ec7ff35')
# kpDataBackground(kp, data.panel = 1, r0 = 0, r1 = 1, col = 'white')
# kpAddChromosomeNames(kp, chr.names = chr_names, cex = 1.5)

# # we can also add recombination
# kpPlotDensity(kp, data = nuc_rg, data.panel = 1, r0 = 0.25, r1 = 0.5)
# kpPlotDensity(kp, data = nuc_rg_large, data.panel = 1, r0 = 0.75, r1 = 1)
# kpPlotDensity(kp, data = mito_rg, data.panel = 1, r0 = 0.25, r1 = 0)
# kpPlotDensity(kp, data = mito_rg_large, data.panel = 1, r0 = 0.75, r1 = 0.5)
# kpPoints(kp, data = data_recomb_rg, data.panel = 2, y = data_recomb_rg$mean.rate, ymin = -24, ymax = 2, r1 = 0, r0 = 1, col =  data_recomb$color, cex = 0.15, alpha = 0.1)
# dev.off()

# plot everything on panel 1 with a gene density plot for the Z chromosome
# pdf("SSL-Nuc-Mito_karyotype-small-large_panel1-merge-panel2-recomb_scaffold-Z.pdf",10, 15)
# kp = plotKaryotype(plot.type = 2, genome = genome, chromosomes = "scaffold-Z", labels.plotter = NULL)
# kpPlotRegions(kp, data = data_algn, data.panel = 'ideogram', col = 'black')
# kpPlotRegions(kp, data = centro, data.panel = 'ideogram', col = '#ff00007f')
# kpPlotDensity(kp, data = data_gene_rg, data.panel = 'ideogram', col = '#1ec7ffc1', border = '#1ec7ff35')
# kpDataBackground(kp, data.panel = 1, r0 = 0, r1 = 1, col = 'white')
# kpAddChromosomeNames(kp, chr.names = chr_names, cex = 1.5)

# # we can also add recombination
# kpPlotDensity(kp, data = nuc_rg, data.panel = 1, r0 = 0.25, r1 = 0.5)
# kpPlotDensity(kp, data = nuc_rg_large, data.panel = 1, r0 = 0.75, r1 = 1)
# kpPlotDensity(kp, data = mito_rg, data.panel = 1, r0 = 0.25, r1 = 0)
# kpPlotDensity(kp, data = mito_rg_large, data.panel = 1, r0 = 0.75, r1 = 0.5)
# kpPoints(kp, data = data_recomb_rg, data.panel = 2, y = data_recomb_rg$mean.rate, ymin = -24, ymax = 2, r1 = 0, r0 = 1, col =  data_recomb$color, cex = 0.6, alpha = 0.1)
# dev.off()

# summarize per window and plot
head(final_df_bin_cat)

# bin everything and get a count(density) per 100 kb window. This is good to get a count of anything per 100 kb window
final_df_dd.100kb.density <- final_df_bin_cat %>%
    mutate(window = (pos %/% 1e5)*1e5) %>%
    group_by(Chrom,window) %>%
    summarise(mito = sum(Delta.NucMito.BIN == 'Negative'), 
        nuc = sum(Delta.NucMito.BIN == 'Positive')) %>%
        mutate(end = window + 1e4) %>%
    select(Chrom, window, end, mito, nuc)


# do the same a above but for 10 kb window (good for zooming in on genes). We will use this one for plotitng just the negative delta SSLs along the chromosome. So this is the one we will focus on (delete the other objects later)
final_df_dd.10kb.density <- final_df_bin_cat %>%
    mutate(window = (pos %/% 1e4)*1e4) %>%
    group_by(Chrom,window) %>%
    summarise(mito = sum(Delta.NucMito.BIN == 'Negative'), 
        nuc = sum(Delta.NucMito.BIN == 'Positive')) %>%
        mutate(end = window + 1e4) %>%
    select(Chrom, window, end, mito, nuc)


# need to check the data, as every other window is showing a mito value of zero for 10kb, which is probably wrong
# check the final position of each, as it may be that the end of a window is overlapping with the start of the next.
check1 <- final_df_bin_cat %>%
    mutate(window = (pos %/% 1e4)*1e4) %>% 
    filter(window == "3050000")

check2 <- final_df_bin_cat %>%
    mutate(window = (pos %/% 1e4)*1e4) %>% 
    filter(window == "3060000")

# 3050000 - 3059999
head(check1 %>% filter(Chrom == 'scaffold-Z'))
tail(check1)

# 3060000 - 3060000
head(check2)
tail(check2)

# turns out the alignments are 10,001 basepairs, so the 'end' column is creating these artificial 1 bp windows with nothing in them. So the issue is when we have windows that are NOT juxtaposed. Let's redo this, and count (n()) the number of windows with 1 value:
final_df_dd.10kb.density <- final_df_bin_cat %>%
    mutate(window = (pos %/% 1e4)*1e4) %>%
    group_by(Chrom,window) %>%
    summarise(mito = sum(Delta.NucMito.BIN == 'Negative'), 
        nuc = sum(Delta.NucMito.BIN == 'Positive'), 
        n = n()) %>%
        mutate(end = window + 1e4) %>%
    select(Chrom, window, end, mito, nuc, n)

head(final_df_dd.10kb.density)

# make new dataframe using a loop to move the one value from the next window back into the previous window. 
# make new dataframe
new.data <- final_df_dd.10kb.density

#
for(i in 1:nrow(final_df_dd.10kb.density)) {
    if(final_df_dd.10kb.density$n[i] == 1) { # access the n value of the i row
        new.data$mito[i-1] = final_df_dd.10kb.density$mito[i-1] + final_df_dd.10kb.density$mito[i]
        new.data$nuc[i-1] = final_df_dd.10kb.density$nuc[i-1] + final_df_dd.10kb.density$nuc[i]
        new.data$n[i-1] = final_df_dd.10kb.density$n[i-1] + final_df_dd.10kb.density$n[i]
    } 
    print(i)
} 

new.data <- new.data %>%
    filter(n > 1)
head(new.data %>% filter(n > 10002), 20)

# check number of rows. # now we have the correct number of 10 kb windows again
nrow(new.data)
head(new.data)

 # get new name back
final_df_dd.10kb.density.fix <- new.data

nrow(final_df_dd.10kb.density.fix)
head(final_df_dd.10kb.density.fix)

# # check. We still have rows greats than 10,001 (we noticed this when plotting, we saw proportions for the Z code that were over 1 and also high mito proportions).
# head(final_df_dd.10kb.density %>% filter(n > 10002), 20)
# dups <- final_df_dd.10kb.density %>% filter(n > 10002)

# dups <- dups %>%
#     group_by(Chrom) %>%
#     summarise(n = n())
# dups

# calculate the difference in densities
final_df_dd.100kb.density.diff <- final_df_dd.100kb.density %>%
    mutate(delt.dens= nuc - mito, 
        end = window + 1e5) %>% #add an end column so we can convert it to an RG for karyoploteR
        select(Chrom,window,end,delt.dens) %>%
        as.data.frame()

final_df_dd.10kb.density.diff <- final_df_dd.10kb.density.fix %>%
    mutate(delt.dens= nuc - mito, 
        end = window + 1e4) %>% #add an end column so we can convert it to an RG for karyoploteR
        select(Chrom,window,end,delt.dens) %>%
        as.data.frame()

head(final_df_dd.10kb.density.diff)

dd.100kb.rg <- toGRanges(final_df_dd.100kb.density.diff)
dd.10kb.rg <- toGRanges(final_df_dd.10kb.density.diff)

# also make one to filter out and anything that isn't supporting mito
final_df_dd.10kb.density.diff.mito.filt <- final_df_dd.10kb.density.diff %>%
    filter(delt.dens < 0) 
final_df_dd.10kb.density.diff.mito.filt.rg <- toGRanges(final_df_dd.10kb.density.diff.mito.filt) 

# also make one to filter out and anything that isn't supporting mito
final_df_dd.100kb.density.diff.mito.filt <- final_df_dd.100kb.density.diff %>%
    filter(delt.dens < 0) 
final_df_dd.100kb.density.diff.mito.filt.rg <- toGRanges(final_df_dd.100kb.density.diff.mito.filt) 


# get the range so we can put them into the y limits for plotting in karyoploteR
range.dd.100kb <- range(dd.100kb.rg$delt.dens)

# get the range so we can put them into the y limits for plotting in karyoploteR
range.dd.10kb <- range(dd.10kb.rg$delt.dens)

# plot everything on panel 1 with a gene density plot. So this is the delta of density of our delta SSLs. We will view bars at 100 kb resolution and habve panel 2
# be a density plot of what sites support the mitochondria at a 100kb resolution. The line where the blue density plot corresponds to gene density
# pdf("SSL-Nuc-Mito_karyotype-Delta-Delta-Density-100kb-bottom.pdf",10, 15)
# kp = plotKaryotype(plot.type = 2, genome = genome, labels.plotter = NULL)
# kpDataBackground(kp, data.panel = 1, r0 = 0, r1 = 1, col = 'white')
# kpPlotRegions(kp, data = data_algn, data.panel = 'ideogram', col = 'black')
# kpPlotRegions(kp, data = centro, data.panel = 'ideogram', col = '#ff00007f')
# kpPlotDensity(kp, data = data_gene_rg, data.panel = 'ideogram', col = '#1ec7ffc1', border = '#1ec7ff35')
# kpPlotRegions(kp, data = data_mtnuc, data.panel = 'ideogram', col = '#00ff44')
# kpBars(kp, data = dd.100kb.rg, data.panel = 1, y1 = dd.100kb.rg$delt.dens.0.5, ymin = range.dd.100kb.0.5[1], ymax = range.dd.100kb.0.5[2], r0 = 0, r1 = 0.5)
# kpBars(kp, data = dd.100kb.rg, data.panel = 1, y1 = dd.100kb.rg$delt.dens.out, ymin = range.dd.100kb.out[1], ymax = range.dd.100kb.out[2], r0 = 0.5, r1 = 1)
# kpPlotDensity(kp, data = final_df_dd.100kb.density.diff.mito.filt.rg, data.panel = 2)
# kpAddChromosomeNames(kp, chr.names = chr_names, cex = 1.5)

# we can also add recombination
# kpPoints(kp, data = data_recomb_rg, data.panel = 2, y = data_recomb_rg$mean.rate, ymin = -24, ymax = 2, r1 = 0, r0 = 1, col =  data_recomb$color, cex = 0.15, alpha = 0.1)
# dev.off()


############

# plot everything on panel 1 with a gene density plot. So this is the delta of density of our delta SSLs. We will view bars at 100 kb resolution and habve panel 2
# be a density plot of what sites support the mitochondria at a 10kb resolution. The line where the blue density plot corresponds to gene density
# pdf("SSL-Nuc-Mito_karyotype-Delta-Delta-Density-10kb-bottom.pdf",10, 15)
# kp = plotKaryotype(plot.type = 2, genome = genome, labels.plotter = NULL)
# kpDataBackground(kp, data.panel = 1, r0 = 0, r1 = 1, col = 'white')
# kpPlotRegions(kp, data = data_algn, data.panel = 'ideogram', col = 'black')
# kpPlotRegions(kp, data = centro, data.panel = 'ideogram', col = '#ff00007f')
# kpPlotDensity(kp, data = data_gene_rg, data.panel = 'ideogram', col = '#1ec7ffc1', border = '#1ec7ff35')
# kpPlotRegions(kp, data = data_mtnuc, data.panel = 'ideogram', col = '#00ff44')
# kpBars(kp, data = dd.100kb.rg, data.panel = 1, y1 = dd.100kb.rg$delt.dens.0.5, ymin = range.dd.100kb.0.5[1], ymax = range.dd.100kb.0.5[2], r0 = 0, r1 = 0.5)
# kpBars(kp, data = dd.100kb.rg, data.panel = 1, y1 = dd.100kb.rg$delt.dens.out, ymin = range.dd.100kb.out[1], ymax = range.dd.100kb.out[2], r0 = 0.5, r1 = 1)
# kpPlotDensity(kp, data = final_df_dd.10kb.density.diff.mito.filt.rg, data.panel = 2)
# kpAddChromosomeNames(kp, chr.names = chr_names, cex = 1.5)

# we can also add recombination
# kpPoints(kp, data = data_recomb_rg, data.panel = 2, y = data_recomb_rg$mean.rate, ymin = -24, ymax = 2, r1 = 0, r0 = 1, col =  data_recomb$color, cex = 0.15, alpha = 0.1)
# dev.off()

############

# plot everything on panel 1 with a gene density plot. So this is the delta of density of our delta SSLs. We will view bars at 100 kb resolution and habve panel 2
# be a density plot of what sites support the mitochondria at a 10kb resolution. The blue density plot in the middle will be the support for the mito tree instead of putting it on panel 2 (so we will comment out the line where the blue density plot corresponds to gene density).
pdf("SSL-Nuc-Mito_karyotype-Delta-Delta-Density-10kb-ideogram_mito-density-only.pdf",10, 15)
kp = plotKaryotype(plot.type = 1, genome = genome, labels.plotter = NULL)
kpDataBackground(kp, data.panel = 1, r0 = 0, r1 = 1, col = 'white')
kpPlotRegions(kp, data = data_algn, data.panel = 'ideogram', col = 'black')
kpPlotRegions(kp, data = centro, data.panel = 'ideogram', col = '#ff00007f')
#kpPlotDensity(kp, data = data_gene_rg, data.panel = 'ideogram', col = '#1ec7ffc1', border = '#1ec7ff35')
kpPlotRegions(kp, data = data_mtnuc, data.panel = 'ideogram', col = '#00ff44')
kpBars(kp, data = dd.100kb.rg, data.panel = 1, y1 = dd.100kb.rg$delt.dens.0.5, ymin = range.dd.100kb.0.5[1], ymax = range.dd.100kb.0.5[2], r0 = 0, r1 = 0.5)
kpBars(kp, data = dd.100kb.rg, data.panel = 1, y1 = dd.100kb.rg$delt.dens.out, ymin = range.dd.100kb.out[1], ymax = range.dd.100kb.out[2], r0 = 0.5, r1 = 1)
kpAddChromosomeNames(kp, chr.names = chr_names, cex = 1.5)
kpAxis(kp, data.panel=2)
# we can also add recombination
# kpPoints(kp, data = data_recomb_rg, data.panel = 2, y = data_recomb_rg$mean.rate, ymin = -24, ymax = 2, r1 = 0, r0 = 1, col =  data_recomb$color, cex = 0.15, alpha = 0.1)
dev.off()

final_df_dd.10kb.density.fix <- as.data.frame(final_df_dd.10kb.density.fix)
head(final_df_dd.10kb.density.fix)

final_df_dd.10kb.density.props <- final_df_dd.10kb.density.fix %>%
    mutate(proportion = final_df_dd.10kb.density.fix$mito/10000)

# Check the range of proportions for chromosomes
# Get unique Chrom values from final_df_dd.10kb.density.props
unique_chroms <- unique(final_df_dd.10kb.density.props$Chrom)

# Create an empty data frame to store results
result_df <- data.frame(Chrom = character(), Min_Proportion = numeric(), Max_Proportion = numeric(), Avg_Proportion = numeric())

# Loop through each unique Chrom and calculate the range and average of 'proportion'
for (chrom in unique_chroms) {
  # Filter rows for the current Chrom
  filtered_data <- final_df_dd.10kb.density.props[final_df_dd.10kb.density.props$Chrom == chrom, ]
  
  # Calculate the range of 'proportion'
  range_proportion <- range(filtered_data$proportion, na.rm = TRUE)
  
  # Calculate the average of 'proportion'
  avg_proportion <- mean(filtered_data$proportion, na.rm = TRUE)
  
  # Add the result to the result_df
  result_df <- rbind(result_df, data.frame(Chrom = chrom, Min_Proportion = range_proportion[1], Max_Proportion = range_proportion[2], Avg_Proportion = avg_proportion))
}

# Print the result as a table
print(result_df)
#           Chrom Min_Proportion Max_Proportion Avg_Proportion
#1     scaffold-Z         0.0271         0.2993    0.171954425
#2   scaffold-ma1         0.0016         0.2114    0.007943666
#3   scaffold-ma2         0.0024         0.1151    0.010689085
#4   scaffold-ma3         0.0302         0.3114    0.211613687
#5   scaffold-ma4         0.0024         0.0769    0.009074025
#6   scaffold-ma5         0.0049         0.0911    0.013247849
#7   scaffold-ma6         0.0055         0.1076    0.013062948
#8   scaffold-ma7         0.0037         0.0699    0.011537045
#9   scaffold-mi1         0.0324         0.3077    0.210378779
#10 scaffold-mi10         0.0663         0.2903    0.200666316
#11  scaffold-mi2         0.0296         0.3089    0.219194779
#12  scaffold-mi3         0.0036         0.0667    0.012340492
#13  scaffold-mi4         0.0733         0.3026    0.229021629
#14  scaffold-mi5         0.0041         0.0357    0.013951948
#15  scaffold-mi6         0.0892         0.3107    0.223825907
#16  scaffold-mi7         0.0039         0.0866    0.012669484
#17  scaffold-mi8         0.0024         0.0692    0.010064076
#18  scaffold-mi9         0.0784         0.2867    0.208443902

# plot just the density plot for mito support
pdf("SSL-Nuc-Mito_karyotype-10kb-mito-density-only_colored.pdf",10, 15)
kp = plotKaryotype(plot.type = 1, genome = genome, labels.plotter = NULL)
kpDataBackground(kp, data.panel = 1, r0 = 0, r1 = 1, col = 'white')
kpPlotRegions(kp, data = data_algn, data.panel = 'ideogram', col = 'black')
kpPlotRegions(kp, data = centro, data.panel = 'ideogram', col = '#ff00007f')
#kpPlotDensity(kp, data = data_gene_rg, data.panel = 'ideogram', col = '#1ec7ffc1', border = '#1ec7ff35')
kpPlotRegions(kp, data = data_mtnuc, data.panel = 'ideogram', col = '#00ff44')
#kpBars(kp, data = dd.10kb.rg, data.panel = 1, y1 = dd.10kb.rg$delt.dens.0.5, ymin = range.dd.10kb.0.5[1], ymax = range.dd.10kb.0.5[2], r0 = 0, r1 = 0.5)
#kpBars(kp, data = dd.10kb.rg, data.panel = 1, y1 = dd.10kb.rg$delt.dens.out, ymin = range.dd.10kb.out[1], ymax = range.dd.10kb.out[2], r0 = 0.5, r1 = 1)
# kpPlotDensity(kp, data = final_df_dd.10kb.density.diff.mito.filt.rg, data.panel = 1, col = '#1ec7ffc1', border = '#1ec7ff35')
kpBars(kp, data = dd.10kb.rg, y0 = 0, y1 = final_df_dd.10kb.density.fix$mito/10000, ymin = 0, ymax = 1, data.panel = 1, col = '#1ec7ffc1', border = '#a8f7a099')
kpAddChromosomeNames(kp, chr.names = chr_names, cex = 1.5)
kpAxis(kp, data.panel=2)
# we can also add recombination
# kpPoints(kp, data = data_recomb_rg, data.panel = 2, y = data_recomb_rg$mean.rate, ymin = -24, ymax = 2, r1 = 0, r0 = 1, col =  data_recomb$color, cex = 0.15, alpha = 0.1)
dev.off()



####################################################################################################
####################################################################################################
####################################################################################################

# Run the above now comparing nuclear vs Z SSLs

####################################################################################################
####################################################################################################
####################################################################################################


# setwd
setwd("/home/administrator/ExtraSSD2/Justin/Analyses_JMB/SSL_plots/")

# this function is faster than read.csv but will make a new first column out of the row names, so we will select it out.
final_df = readr::read_csv("./SSL_all-chrom.csv") %>%
    as.data.frame() %>% 
    select(-1)
head(final_df)

# Make a column for the delta (change) SSL betwen nuclear and Z SSLs
NucZ.diff <- as.data.frame(final_df) %>%
    mutate(Delta.NucZ = nuc.ssl-Z.ssl)

head(NucZ.diff)


# plot a chromosome
# jpeg("ma1_SSL_DeltaNucZ.jpg",3000,3000,res=300)
# NucZ.diff %>%
#     filter(Chrom == "scaffold-ma1") %>%
#     ggplot(aes(x = pos, y = Delta.NucZ)) +
#     geom_point()
# dev.off()

# loop through all chromosomes and print out graphs
chrom = unique(final_df$Chrom)
for(i in chrom){
    jpeg(paste(i,".NucZ.jpg"),3000,3000,res=300)
    p = NucZ.diff %>%
        filter(Chrom == i) %>%
        ggplot(aes(x = pos, y = Delta.NucZ)) +
        geom_point()
    print(p)
    dev.off()
}

# check numbers in a table
range(NucZ.diff$Z.ssl)
head(NucZ.diff)

# there are clearly outliers in the negative part of the distribution. Let's filter for these to identify where
head(NucZ.diff %>% filter(nuc.ssl == min(nuc.ssl)))


# make BINs
final_df_bins <- NucZ.diff %>%
    mutate(Delta.NucZ.BIN = ifelse(
        Delta.NucZ < 0, "Negative", "Positive")
    ) %>%
    group_by(Chrom, Delta.NucZ.BIN) %>% #group by chromosome AND BINs  
    summarise(count = n()) #count the number of occurence in each group. It will count, per chromosome, each of the BINs. Summarise will calculate whatever you want based on the group_by groups (so we will count = n()) for each group. Can do this for meanm or summary statistics, etc. Grouping it makes a smaller data frame which was summarized.

final_df_bins <- mutate(final_df_bins, log.counts = log10(count))

head(final_df_bins)

View(final_df_bins)
# make bar graph
# jpeg("DeltaSSL-Nuc-vs-Z.jpg", 2000, 2000, res = 300)
# ggplot(final_df_bins, aes(x = Chrom, y = log.counts, fill = Delta.NucZ.BIN)) +
#     geom_col(position = "stack") + 
#     ggtitle("Delta SSL: Nuclear vs. Z")
# dev.off()

# make bar graph filtering out the big categories
# final_df_bins_filter <- final_df_bins %>%
#     filter(Delta.NucZ.BIN != "0 to 0.5" & Delta.NucZ.BIN != "-0.5 to 0")

# jpeg("DeltaSSL-Nuc-vs-Z-filtered.jpg", 2000, 2000, res = 300)
# ggplot(final_df_bins_filter, aes(x = Chrom, y = count, fill = Delta.NucZ.BIN)) +
#     geom_col(position = "stack") + 
#     ggtitle("Delta SSL: Nuclear vs. Z filtered")
# dev.off()

# try plotting with karyoploteR
library(karyoploteR)
chrom = read.delim('chrom_for_karyo.txt')
chr_names = gsub('scaffold-','',chrom$chr)

# create a genome range object, which is needed for karyoploteR. Requires a bed file (chom, start, end) and then the values of what you want to plot.
genome = toGRanges(chrom)

centro = read.delim('CentroMap.txt')
centro_rg = toGRanges(centro)

# make bins again. This is a delta SSL, so anything positive supports the nuclear tree, and anything negative supports the Zchondrial tree.    
final_df_bin_cat <- NucZ.diff %>%
    mutate(Delta.NucZ.BIN = ifelse(
        Delta.NucZ < 0, "Negative", "Positive")
    )

head(final_df_bin_cat)

# make new dataframes for our categories (the 0.5 to -0.5 range is what we think may not be violating our model assumptions that much). Add chromosome start and end (which will be the same as we are just plotting the density of specific sites, not windows).
final_df_bin_Z <- final_df_bin_cat %>%
    filter(Delta.NucZ.BIN == "Negative") %>%
    mutate(start = pos, end = pos) %>%
    select(Chrom,start,end)

final_df_bin_nuc <- final_df_bin_cat %>%
    filter(Delta.NucZ.BIN == "Positive") %>%
    mutate(start = pos, end = pos) %>%
    select(Chrom,start,end)

Z_rg <- toGRanges(final_df_bin_Z)
nuc_rg <- toGRanges(final_df_bin_nuc)

# add a file to show what regions we data for (obtained by using the ranges of our alignments).
# data_algn <- read.delim("./data-algn.txt", header = FALSE)
# data_algn_rg <- toGRanges(data_algn) 

# we can also sort and then merge overlapping/juxtapods regions (sort and then merge using bedtools).
data_algn <- read.delim("./data-algn-sort-merge.bed", header = FALSE)
data_algn_rg <- toGRanges(data_algn) 

# add a file to show what genes 
data_gene <- read.delim("./converted.gene.names.bed", header = FALSE)
colnames(data_gene) <- c("chrom", "start", "end", "gene")
data_gene_rg <- toGRanges(data_gene) 

# bring in mito-nuc genes
data_mtnuc <- read.delim("./OxPhos.genes.only.full.ordered.bed", header = FALSE)
data_mtnuc <- data_mtnuc %>%
    select(V1, V2, V3, V7)
colnames(data_mtnuc) <- c("chrom", "start", "end", "gene")
head(data_mtnuc)
data_mtnuc_rg <- toGRanges(data_mtnuc)

# add a file for the recombination rates (we will log2 them) 
data_recomb <- read.delim("./viridis.recomb.10kb.txt", header = TRUE)
colnames(data_recomb) <- c("chrom", "start", "mean.rate")
data_recomb <- as.data.frame(data_recomb) %>%
    mutate(end = start) %>%
    select(chrom, start, end, mean.rate)
data_recomb <- data_recomb %>%
    mutate(mean.rate = log2(mean.rate))
data_recomb_rg <- toGRanges(data_recomb)

# prepare a color gradient for the recombination rates

library(colorRamp2)
getColorVec = function(values,cols = c('#4343ffab','#b4b4b4a4','#ff4b4baa'), range_quantiles = NA)
{
    if(is.na(range_quantiles))
    {
        high_lim = quantile(values,0.975, na.rm = T)
        midpoint = quantile(values,0.50, na.rm = T)
        low_lim = quantile(values,0.025, na.rm = T)
    }else
    {
        high_lim = quantile(values, range_quantiles[3], na.rm = T)
        midpoint = quantile(values, range_quantiles[2], na.rm = T)
        low_lim = quantile(values, range_quantiles[1], na.rm = T)
    }
    col_fun = colorRamp2(c(low_lim,midpoint,high_lim), cols)
    col_vector = col_fun(values)
    return(col_vector)
}

data_recomb <- data_recomb %>%
    mutate(color = getColorVec(mean.rate))

# # plot karyoplots (must restart every time if you want to change anything). For plotting on the chromosome, you don't need to use the rg version, but we made it anyways.
# pdf("SSL-Nuc-Z_karyotype-small-large.pdf", 10, 15)
# kp = plotKaryotype(plot.type = 2, genome = genome, labels.plotter = NULL)
# kpPlotRegions(kp, data = data_algn, data.panel = 'ideogram', col = 'black')
# kpPlotRegions(kp, data = data_gene, data.panel = 'ideogram', col = 'blue')
# kpPlotRegions(kp, data = centro, data.panel = 'ideogram', col = '#ff00007f')
# kpDataBackground(kp, data.panel = 1, r0 = 0, r1 = 1, col = 'white')
# kpDataBackground(kp, data.panel = 2, r0 = 0, r1 = 1, col = 'white')
# kpAddChromosomeNames(kp, chr.names = chr_names, cex = 1.5)

# # Note: if you want to set up more than one data track (like below, we are adding a second dataset which is the 'large' filtered datasets), you must do the r0 = autotrack and give it which dataset it is out of how many
# kpPlotDensity(kp, data = nuc_rg, data.panel = 1, r0 = autotrack(1,2))
# kpPlotDensity(kp, data = nuc_rg_large, data.panel = 1, r0 = autotrack(2,2))
# kpPlotDensity(kp, data = Z_rg, data.panel = 2, r0 = autotrack(1,2))
# kpPlotDensity(kp, data = Z_rg_large, data.panel = 2, r0 = autotrack(2,2))
# dev.off()



###### plot everything on panel 1 with a gene density plot ##########################################

# pdf("SSL-Nuc-Z_karyotype-small-large_panel1-only-Znuc-ma3.pdf", 10, 15)
# kp = plotKaryotype(plot.type = 1, genome = genome, chromosomes = "scaffold-ma3", labels.plotter = NULL)
# kpPlotRegions(kp, data = data_algn, data.panel = 'ideogram', col = 'black')
# kpPlotRegions(kp, data = centro, data.panel = 'ideogram', col = '#ff00007f')
# kpPlotDensity(kp, data = data_gene_rg, data.panel = 'ideogram', col = '#1ec7ffc1', border = '#1ec7ff35')
# kpPlotRegions(kp, data = data_mtnuc, data.panel = 'ideogram', col = '#00ff44')
# kpDataBackground(kp, data.panel = 1, r0 = 0, r1 = 1, col = 'white')
# kpAddChromosomeNames(kp, chr.names = "ma3", cex = 1.5)

# # Note: if you want to set up more than one data track (like below, we are adding a second dataset which is the 'large' filtered datasets), you must do the r0 = autotrack and give it which dataset it is out of how many
# kpPlotDensity(kp, data = nuc_rg, data.panel = 1, r0 = 0.25, r1 = 0.5)
# kpPlotDensity(kp, data = nuc_rg_large, data.panel = 1, r0 = 0.75, r1 = 1)
# kpPlotDensity(kp, data = Z_rg, data.panel = 1, r0 = 0.25, r1 = 0)
# kpPlotDensity(kp, data = Z_rg_large, data.panel = 1, r0 = 0.75, r1 = 0.5)
# dev.off()


###### plot everything on panel 1 with a gene density plot  and recomb on the bottom ###############

# plot everything on panel 1 with a gene density plot
# pdf("SSL-Nuc-Z_karyotype-small-large_panel1-merge-panel2-recomb.pdf",10, 15)
# kp = plotKaryotype(plot.type = 2, genome = genome, labels.plotter = NULL)
# kpPlotRegions(kp, data = data_algn, data.panel = 'ideogram', col = 'black')
# kpPlotRegions(kp, data = centro, data.panel = 'ideogram', col = '#ff00007f')
# kpPlotDensity(kp, data = data_gene_rg, data.panel = 'ideogram', col = '#1ec7ffc1', border = '#1ec7ff35')
# kpDataBackground(kp, data.panel = 1, r0 = 0, r1 = 1, col = 'white')
# kpAddChromosomeNames(kp, chr.names = chr_names, cex = 1.5)

# # we can also add recombination
# kpPlotDensity(kp, data = nuc_rg, data.panel = 1, r0 = 0.25, r1 = 0.5)
# kpPlotDensity(kp, data = nuc_rg_large, data.panel = 1, r0 = 0.75, r1 = 1)
# kpPlotDensity(kp, data = Z_rg, data.panel = 1, r0 = 0.25, r1 = 0)
# kpPlotDensity(kp, data = Z_rg_large, data.panel = 1, r0 = 0.75, r1 = 0.5)
# kpPoints(kp, data = data_recomb_rg, data.panel = 2, y = data_recomb_rg$mean.rate, ymin = -24, ymax = 2, r1 = 0, r0 = 1, col =  data_recomb$color, cex = 0.15, alpha = 0.1)
# dev.off()

# plot everything on panel 1 with a gene density plot for the Z chromosome
# pdf("SSL-Nuc-Z_karyotype-small-large_panel1-merge-panel2-recomb_scaffold-Z.pdf",10, 15)
# kp = plotKaryotype(plot.type = 2, genome = genome, chromosomes = "scaffold-Z", labels.plotter = NULL)
# kpPlotRegions(kp, data = data_algn, data.panel = 'ideogram', col = 'black')
# kpPlotRegions(kp, data = centro, data.panel = 'ideogram', col = '#ff00007f')
# kpPlotDensity(kp, data = data_gene_rg, data.panel = 'ideogram', col = '#1ec7ffc1', border = '#1ec7ff35')
# kpDataBackground(kp, data.panel = 1, r0 = 0, r1 = 1, col = 'white')
# kpAddChromosomeNames(kp, chr.names = chr_names, cex = 1.5)

# # we can also add recombination
# kpPlotDensity(kp, data = nuc_rg, data.panel = 1, r0 = 0.25, r1 = 0.5)
# kpPlotDensity(kp, data = nuc_rg_large, data.panel = 1, r0 = 0.75, r1 = 1)
# kpPlotDensity(kp, data = Z_rg, data.panel = 1, r0 = 0.25, r1 = 0)
# kpPlotDensity(kp, data = Z_rg_large, data.panel = 1, r0 = 0.75, r1 = 0.5)
# kpPoints(kp, data = data_recomb_rg, data.panel = 2, y = data_recomb_rg$mean.rate, ymin = -24, ymax = 2, r1 = 0, r0 = 1, col =  data_recomb$color, cex = 0.6, alpha = 0.1)
# dev.off()

# summarize per window and plot
head(final_df_bin_cat)

# bin everything and get a count(density) per 100 kb window. This is good to get a count of anything per 100 kb window
final_df_dd.100kb.density <- final_df_bin_cat %>%
    mutate(window = (pos %/% 1e5)*1e5) %>%
    group_by(Chrom,window) %>%
    summarise(Z = sum(Delta.NucZ.BIN == 'Negative'), 
        nuc = sum(Delta.NucZ.BIN == 'Positive')) %>%
        mutate(end = window + 1e4) %>%
    select(Chrom, window, end, Z, nuc)

# do the same a above but for 10 kb window (good for zooming in on genes). We will use this one for plotitng just the negative delta SSLs along the chromosome. So this is the one we will focus on (delete the other objects later)
final_df_dd.10kb.density <- final_df_bin_cat %>%
    mutate(window = (pos %/% 1e4)*1e4) %>%
    group_by(Chrom,window) %>%
    summarise(Z = sum(Delta.NucZ.BIN == 'Negative'), 
        nuc = sum(Delta.NucZ.BIN == 'Positive')) %>%
        mutate(end = window + 1e4) %>%
    select(Chrom, window, end, Z, nuc)

head(final_df_dd.10kb.density)

# need to check the data, as every other window is showing a Z value of zero for 10kb, which is probably wrong
# check the final position of each, as it may be that the end of a window is overlapping with the start of the next.
check1 <- final_df_bin_cat %>%
    mutate(window = (pos %/% 1e4)*1e4) %>% 
    filter(window == "3050000")

check2 <- final_df_bin_cat %>%
    mutate(window = (pos %/% 1e4)*1e4) %>% 
    filter(window == "3060000")

# 3050000 - 3059999
head(check1 %>% filter(Chrom == 'scaffold-Z'))
tail(check1 %>% filter(Chrom == 'scaffold-Z'))

# 3060000 - 3060000
head(check2)
tail(check2)
head(check2 %>% filter(Chrom == 'scaffold-Z'))
tail(check2 %>% filter(Chrom == 'scaffold-Z'))


# turns out the alignments are 10,001 basepairs, so the 'end' column is creating these artificial 1 bp windows with nothing in them. So the issue is when we have windows that are NOT juxtaposed. Let's redo this, and count (n()) the number of windows with 1 value:
final_df_dd.10kb.density <- final_df_bin_cat %>%
    mutate(window = (pos %/% 1e4)*1e4) %>%
    group_by(Chrom,window) %>%
    summarise(Z = sum(Delta.NucZ.BIN == 'Negative'), 
        nuc = sum(Delta.NucZ.BIN == 'Positive'), 
        n = n()) %>%
        mutate(end = window + 1e4) %>%
    select(Chrom, window, end, Z, nuc, n)

# make new dataframe using a loop to move the one value from the next window back into the previous window. 
# make new dataframe
new.data <- final_df_dd.10kb.density

# 
for(i in 1:nrow(final_df_dd.10kb.density)) {
    if(final_df_dd.10kb.density$n[i] == 1) { # access the n value of the i row
        new.data$Z[i-1] = final_df_dd.10kb.density$Z[i-1] + final_df_dd.10kb.density$Z[i] 
    } 
    print(i)
} 

new.data <- new.data %>%
    filter(n > 1)

head(final_df_dd.10kb.density)

nrow(final_df_dd.10kb.density %>% filter(n > 10000))

# check number of rows. # now we have the correct number of 10 kb windows again
nrow(new.data)
head(new.data)

 # get new name back
rm(final_df_dd.10kb.density)
final_df_dd.10kb.density.fix <- new.data

nrow(final_df_dd.10kb.density.fix)
head(final_df_dd.10kb.density.fix)

# calculate the difference in densities
final_df_dd.100kb.density.diff <- final_df_dd.100kb.density %>%
    mutate(delt.dens= nuc - Z, 
        end = window + 1e5) %>% #add an end column so we can convert it to an RG for karyoploteR
        select(Chrom,window,end,delt.dens) %>%
        as.data.frame()

final_df_dd.10kb.density.diff <- final_df_dd.10kb.density.fix %>%
    mutate(delt.dens= nuc - Z, 
        end = window + 1e4) %>% #add an end column so we can convert it to an RG for karyoploteR
        select(Chrom,window,end,delt.dens) %>%
        as.data.frame()

dd.100kb.rg <- toGRanges(final_df_dd.100kb.density.diff)
dd.10kb.rg <- toGRanges(final_df_dd.10kb.density.diff)

# also make one to filter out and anything that isn't supporting Z
final_df_dd.10kb.density.diff.Z.filt <- final_df_dd.10kb.density.diff %>%
    filter(delt.dens < 0) 
final_df_dd.10kb.density.diff.Z.filt.rg <- toGRanges(final_df_dd.10kb.density.diff.Z.filt) 

# also make one to filter out and anything that isn't supporting Z
final_df_dd.100kb.density.diff.Z.filt <- final_df_dd.100kb.density.diff %>%
    filter(delt.dens < 0) 
final_df_dd.100kb.density.diff.Z.filt.rg <- toGRanges(final_df_dd.100kb.density.diff.Z.filt) 


# get the range so we can put them into the y limits for plotting in karyoploteR
range.dd.100kb <- range(dd.100kb.rg$delt.dens)

# get the range so we can put them into the y limits for plotting in karyoploteR
range.dd.10kb <- range(dd.10kb.rg$delt.dens)

# plot everything on panel 1 with a gene density plot. So this is the delta of density of our delta SSLs. We will view bars at 100 kb resolution and habve panel 2
# be a density plot of what sites support the Z at a 100kb resolution. The line where the blue density plot corresponds to gene density
# pdf("SSL-Nuc-Z_karyotype-Delta-Delta-Density-100kb-bottom.pdf",10, 15)
# kp = plotKaryotype(plot.type = 2, genome = genome, labels.plotter = NULL)
# kpDataBackground(kp, data.panel = 1, r0 = 0, r1 = 1, col = 'white')
# kpPlotRegions(kp, data = data_algn, data.panel = 'ideogram', col = 'black')
# kpPlotRegions(kp, data = centro, data.panel = 'ideogram', col = '#ff00007f')
# kpPlotDensity(kp, data = data_gene_rg, data.panel = 'ideogram', col = '#1ec7ffc1', border = '#1ec7ff35')
# kpPlotRegions(kp, data = data_mtnuc, data.panel = 'ideogram', col = '#00ff44')
# kpBars(kp, data = dd.100kb.rg, data.panel = 1, y1 = dd.100kb.rg$delt.dens.0.5, ymin = range.dd.100kb.0.5[1], ymax = range.dd.100kb.0.5[2], r0 = 0, r1 = 0.5)
# kpBars(kp, data = dd.100kb.rg, data.panel = 1, y1 = dd.100kb.rg$delt.dens.out, ymin = range.dd.100kb.out[1], ymax = range.dd.100kb.out[2], r0 = 0.5, r1 = 1)
# kpPlotDensity(kp, data = final_df_dd.100kb.density.diff.Z.filt.rg, data.panel = 2)
# kpAddChromosomeNames(kp, chr.names = chr_names, cex = 1.5)

# we can also add recombination
# kpPoints(kp, data = data_recomb_rg, data.panel = 2, y = data_recomb_rg$mean.rate, ymin = -24, ymax = 2, r1 = 0, r0 = 1, col =  data_recomb$color, cex = 0.15, alpha = 0.1)
# dev.off()


############

# plot everything on panel 1 with a gene density plot. So this is the delta of density of our delta SSLs. We will view bars at 100 kb resolution and habve panel 2
# be a density plot of what sites support the Z at a 10kb resolution. The line where the blue density plot corresponds to gene density
# pdf("SSL-Nuc-Z_karyotype-Delta-Delta-Density-10kb-bottom.pdf",10, 15)
# kp = plotKaryotype(plot.type = 2, genome = genome, labels.plotter = NULL)
# kpDataBackground(kp, data.panel = 1, r0 = 0, r1 = 1, col = 'white')
# kpPlotRegions(kp, data = data_algn, data.panel = 'ideogram', col = 'black')
# kpPlotRegions(kp, data = centro, data.panel = 'ideogram', col = '#ff00007f')
# kpPlotDensity(kp, data = data_gene_rg, data.panel = 'ideogram', col = '#1ec7ffc1', border = '#1ec7ff35')
# kpPlotRegions(kp, data = data_mtnuc, data.panel = 'ideogram', col = '#00ff44')
# kpBars(kp, data = dd.100kb.rg, data.panel = 1, y1 = dd.100kb.rg$delt.dens.0.5, ymin = range.dd.100kb.0.5[1], ymax = range.dd.100kb.0.5[2], r0 = 0, r1 = 0.5)
# kpBars(kp, data = dd.100kb.rg, data.panel = 1, y1 = dd.100kb.rg$delt.dens.out, ymin = range.dd.100kb.out[1], ymax = range.dd.100kb.out[2], r0 = 0.5, r1 = 1)
# kpPlotDensity(kp, data = final_df_dd.10kb.density.diff.Z.filt.rg, data.panel = 2)
# kpAddChromosomeNames(kp, chr.names = chr_names, cex = 1.5)

# we can also add recombination
# kpPoints(kp, data = data_recomb_rg, data.panel = 2, y = data_recomb_rg$mean.rate, ymin = -24, ymax = 2, r1 = 0, r0 = 1, col =  data_recomb$color, cex = 0.15, alpha = 0.1)
# dev.off()

############

# plot everything on panel 1 with a gene density plot. So this is the delta of density of our delta SSLs. We will view bars at 100 kb resolution and habve panel 2
# be a density plot of what sites support the Z at a 10kb resolution. The blue density plot in the middle will be the support for the Z tree instead of putting it on panel 2 (so we will comment out the line where the blue density plot corresponds to gene density).
pdf("SSL-Nuc-Z_karyotype-Delta-Delta-Density-10kb-ideogram_Z-density-only.pdf",10, 15)
kp = plotKaryotype(plot.type = 1, genome = genome, labels.plotter = NULL)
kpDataBackground(kp, data.panel = 1, r0 = 0, r1 = 1, col = 'white')
kpPlotRegions(kp, data = data_algn, data.panel = 'ideogram', col = 'black')
kpPlotRegions(kp, data = centro, data.panel = 'ideogram', col = '#ff00007f')
#kpPlotDensity(kp, data = data_gene_rg, data.panel = 'ideogram', col = '#1ec7ffc1', border = '#1ec7ff35')
kpPlotRegions(kp, data = data_mtnuc, data.panel = 'ideogram', col = '#00ff44')
kpBars(kp, data = dd.100kb.rg, data.panel = 1, y1 = dd.100kb.rg$delt.dens.0.5, ymin = range.dd.100kb.0.5[1], ymax = range.dd.100kb.0.5[2], r0 = 0, r1 = 0.5)
kpBars(kp, data = dd.100kb.rg, data.panel = 1, y1 = dd.100kb.rg$delt.dens.out, ymin = range.dd.100kb.out[1], ymax = range.dd.100kb.out[2], r0 = 0.5, r1 = 1)
kpAddChromosomeNames(kp, chr.names = chr_names, cex = 1.5)
kpAxis(kp, data.panel=2)
# we can also add recombination
# kpPoints(kp, data = data_recomb_rg, data.panel = 2, y = data_recomb_rg$mean.rate, ymin = -24, ymax = 2, r1 = 0, r0 = 1, col =  data_recomb$color, cex = 0.15, alpha = 0.1)
dev.off()

final_df_dd.10kb.density.fix <- as.data.frame(final_df_dd.10kb.density.fix)
head(final_df_dd.10kb.density.fix)

final_df_dd.10kb.density.props <- final_df_dd.10kb.density.fix %>%
    mutate(proportion = final_df_dd.10kb.density.fix$Z/10000)

# Check the range of proportions for chromosomes
# Get unique Chrom values from final_df_dd.10kb.density.props
unique_chroms <- unique(final_df_dd.10kb.density.props$Chrom)

# Create an empty data frame to store results
result_df <- data.frame(Chrom = character(), Min_Proportion = numeric(), Max_Proportion = numeric(), Avg_Proportion = numeric())

# Loop through each unique Chrom and calculate the range and average of 'proportion'
for (chrom in unique_chroms) {
  # Filter rows for the current Chrom
  filtered_data <- final_df_dd.10kb.density.props[final_df_dd.10kb.density.props$Chrom == chrom, ]
  
  # Calculate the range of 'proportion'
  range_proportion <- range(filtered_data$proportion, na.rm = TRUE)
  
  # Calculate the average of 'proportion'
  avg_proportion <- mean(filtered_data$proportion, na.rm = TRUE)
  
  # Add the result to the result_df
  result_df <- rbind(result_df, data.frame(Chrom = chrom, Min_Proportion = range_proportion[1], Max_Proportion = range_proportion[2], Avg_Proportion = avg_proportion))
}

# Print the result as a table
print(result_df)
#           Chrom Min_Proportion Max_Proportion Avg_Proportion
#1     scaffold-Z         0.6722         0.9504    0.780513274
#2   scaffold-ma1         0.0053         0.3616    0.216688515
#3   scaffold-ma2         0.0042         0.1407    0.014668145
#4   scaffold-ma3         0.0293         0.3237    0.210302834
#5   scaffold-ma4         0.0226         0.3045    0.214275414
#6   scaffold-ma5         0.0031         0.1076    0.011474184
#7   scaffold-ma6         0.0039         0.0556    0.009853257
#8   scaffold-ma7         0.0043         0.0755    0.010636420
#9   scaffold-mi1         0.0354         0.3093    0.211421374
#10 scaffold-mi10         0.1029         0.3382    0.235276842
#11  scaffold-mi2         0.0301         0.3079    0.222104819
#12  scaffold-mi3         0.0226         0.3080    0.206766890
#13  scaffold-mi4         0.0069         0.1058    0.016521629
#14  scaffold-mi5         0.0814         0.3071    0.226144805
#15  scaffold-mi6         0.0937         0.3182    0.226608290
#16  scaffold-mi7         0.3145         0.5258    0.405015493
#17  scaffold-mi8         0.0061         0.1108    0.016836442
#18  scaffold-mi9         0.2494         0.4629    0.350604878

# plot just the density plot for Z support
pdf("SSL-Nuc-Z_karyotype-10kb-Z-density-only_colored.pdf",10, 15)
kp = plotKaryotype(plot.type = 1, genome = genome, labels.plotter = NULL)
kpDataBackground(kp, data.panel = 1, r0 = 0, r1 = 1, col = 'white')
kpPlotRegions(kp, data = data_algn, data.panel = 'ideogram', col = 'black')
kpPlotRegions(kp, data = centro, data.panel = 'ideogram', col = '#ff00007f')
#kpPlotDensity(kp, data = data_gene_rg, data.panel = 'ideogram', col = '#1ec7ffc1', border = '#1ec7ff35')
kpPlotRegions(kp, data = data_mtnuc, data.panel = 'ideogram', col = '#00ff44')
#kpBars(kp, data = dd.100kb.rg, data.panel = 1, y1 = dd.100kb.rg$delt.dens.0.5, ymin = range.dd.100kb.0.5[1], ymax = range.dd.100kb.0.5[2], r0 = 0, r1 = 0.5)
#kpBars(kp, data = dd.100kb.rg, data.panel = 1, y1 = dd.100kb.rg$delt.dens.out, ymin = range.dd.100kb.out[1], ymax = range.dd.100kb.out[2], r0 = 0.5, r1 = 1)
# kpPlotDensity(kp, data = final_df_dd.10kb.density.diff.Z.filt.rg, data.panel = 1, col = '#1ec7ffc1', border = '#1ec7ff35')
kpBars(kp, data = toGRanges(final_df_dd.10kb.density.fix), y0 = 0, y1 = final_df_dd.10kb.density.fix$Z/10000, ymin = 0, ymax = 1, data.panel = 1, col = '#1ec7ffc1', border = '#b694ee35')
kpAddChromosomeNames(kp, chr.names = chr_names, cex = 1.5)
kpAxis(kp, data.panel=2)
# we can also add recombination
# kpPoints(kp, data = data_recomb_rg, data.panel = 2, y = data_recomb_rg$mean.rate, ymin = -24, ymax = 2, r1 = 0, r0 = 1, col =  data_recomb$color, cex = 0.15, alpha = 0.1)
dev.off()

