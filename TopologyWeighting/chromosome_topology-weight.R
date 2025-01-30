# Set working directory
setwd("/Users/a108594/Documents/CVOS_Phylogeny/TWISST_nohual_2024.2.29")

# Load libraries
library("tidyverse")
source("plot_twisst.R")
library("circlize")
library("viridis")

# plot the twisst summary
weights_file <- "./output-weights/all_trees.output.nohual.weights.csv.gz"
twisst_data <- import.twisst(weights_files=weights_file)
plot.twisst.summary(twisst_data, lwd=3, cex=1,)

# read in the identification + weights files
weights <- read.delim("topology-weights_all-regions_no-hual.csv",header = FALSE)

head(weights)
names(weights) = c("chrom", "end", "top1_abs", "top2_abs", "top3_abs")

weights <- mutate(weights, top1 = top1_abs/(top1_abs+top2_abs+top3_abs), top2 = top2_abs/(top1_abs+top2_abs+top3_abs), top3 = top3_abs/(top1_abs+top2_abs+top3_abs))
weights.long <- pivot_longer(weights %>% select(-(top1_abs:top3_abs)), -c(chrom,end), names_to = 'top', values_to = 'weight')

# set some manual colors to match the plot.twisst.summary 
manual_colors <- c("top1" = "#0077ff", "top3" ="#f4bf1f", "top2" = "#0dc500")

# plot individual chromosomes
ggplot(weights.long %>% filter(chrom == "scaffold-Z")) +
    geom_col(aes(x = end, y = weight, fill = top), position = 'stack', width = 100000, alpha = 1) +
    scale_fill_manual(values = manual_colors)

# plot all chromosomes
ggplot(weights.long) +
    geom_col(aes(x = end, y = weight, fill = top), position = 'stack', width = 500000, alpha = 0.5) + 
    facet_grid(. ~ chrom) + 
    scale_fill_manual(values = manual_colors)

# plot in circos; using smoothed data from all_chrom_weight-smoothing.r script
 

#start cirocs
chrom <- read.delim("chrom.list", header = FALSE)
smooth <- read.csv("./smoothed_topology_nohual.csv") 
smooth <- smooth %>% na.omit()

# initialize jpeg 
#jpeg('all_chromosome_weighted-smooth-topologies_concluto_3spp_recomb.jpeg', height = 3300, width =3000, res = 300)
pdf('all_chromosome_weighted-smooth-topologies_3spp_recomb_no-hual.pdf', height = 12, width =9)

circos.clear()
## set basic parameters for the circos plot
circos.par('track.height' = 0.2, cell.padding = c(0.01, 0, 0.01, 0), start.degree = 90, gap.degree = c(rep(1, 17), 20)) # 18 tracks (1-17)
## initiate the circos plot
# initialize circos with the right sectors and size for all sectors
# xlim is used to specify the start and the end value of each chromosome (sectors)
circos.initialize(chrom$V1, xlim = cbind(rep(0,18),chrom$V2))
head(weights)
#making circos
# manual_colors <- c("top1_abs" = "#0077ff", "top2_abs" ="#f4bf1f")
# circos.track(ylim = c(0,1), track.height = 0.10,
#     panel.fun = function(x, y) {
#         # filter data for each chromosome
#         print(CELL_META$sector.index)
#         d = smooth %>% filter(chrom == CELL_META$sector.index)
#         # plot weighted topologies (order matters based on the smoothing code)
#         circos.lines(x = d$end, y = d$top2_add, area = TRUE, baseline = 0, col = "#7FF0B2", border = NA)
#         circos.lines(x = d$end, y = d$top1_add, area = TRUE, baseline = 0, col = "#B171FE",border = NA)
#         # plot chromosome names
#         # mm_y() can be used to nudge something on the y axis
#         circos.text(CELL_META$xcenter, CELL_META$cell.ylim[2] + mm_y(10), CELL_META$sector.index, facing = 'downward')
# })

track for 3 topologies
manual_colors <- c("top1_abs" = "#0077ff", "top3_abs" ="#f4bf1f", "top2_abs" = "#0dc500")
circos.track(ylim = c(0,1), track.height = 0.35,
    panel.fun = function(x, y) {
        # filter data for each chromosome
        print(CELL_META$sector.index)
        d = smooth %>% filter(chrom == CELL_META$sector.index)
        # plot weighted topologies (order matters based on the smoothing code)
        circos.lines(x = d$end, y = d$top3_add, area = TRUE, baseline = 0, col = "#f4bf1f", border = NA)
        circos.lines(x = d$end, y = d$top2_add, area = TRUE, baseline = 0, col = "#0dc500", border = NA)
        circos.lines(x = d$end, y = d$top1_add, area = TRUE, baseline = 0, col = "#0077ff",border = NA)
        # plot chromosome names
        # mm_y() can be used to nudge something on the y axis
        circos.text(CELL_META$xcenter, CELL_META$cell.ylim[2] + mm_y(10), CELL_META$sector.index, facing = 'downward')
})

recomb <- read.delim("./viridis.recomb.bpen10.windowed.100kb.centromereMask.txt") #if headers get screwed up, use read.delim instead of read.table

# log2 the recombination means so they look better in the plot
recomb <- recomb %>% mutate(mean = log2(mean))

# add a column so we can color the mean range for high and low values. circos can change colors in the plot but does not have a function like ggplot where you can color BY a particular value/set of values. These are colored by quantiles so that the max and min values aren't the only ones being colored red and blue. Values will take the values for all chromosomes. This is its own function by Yannick Francioli

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

recomb <- recomb %>% mutate(color = getColorVec(mean))


# set the circos track for recombination; no need to redo everything from the first track parameters since they are already set
circos.track(ylim = range(recomb$mean, na.rm = TRUE), track.height = 0.35,
    panel.fun = function(x, y) {
        # filter data for each chromosome
        print(CELL_META$sector.index)
        d = recomb %>% filter(chrom == CELL_META$sector.index)
        # plot weighted topologies
        circos.points(d$start,d$mean, pch = 16, col = d$color, cex = 0.4)
})
 
dev.off()

#==============================#
##### Extra plot functions #####
#==============================#

# # plot track with non-smoothed data
# manual_colors <- c("top1_abs" = "#0077ff", "top3_abs" ="#f4bf1f", "top2_abs" = "#0dc500")
# circos.track(ylim = c(0,1), track.height = 0.40,
#     panel.fun = function(x, y) {
#         # filter data for each chromosome
#         print(CELL_META$sector.index)
#         d = weights %>% filter(chrom == CELL_META$sector.index)
#         m = d %>% select(top1:top3) %>% as.matrix()
#         # plot weighted topologies
#         circos.barplot(m,d$start, col = plasma(3), border = NA, bar_width = 500000)
#         # plot chromosome names
#         # mm_y() can be used to nudge something on the y axis
#         circos.text(CELL_META$xcenter, CELL_META$cell.ylim[2] + mm_y(10), CELL_META$sector.index, facing = 'downward')
# })

## below is making a circos track and only plotting a particular chromosome
# circos.track(ylim = c(0,1), track.height = 0.40,
#     panel.fun = function(x, y) {
#         # filter data for each chromosome
#         print(CELL_META$sector.index)
#         if(CELL_META$sector.index == "scaffold-ma6") { #comment this line and associated bracket pair for plotting all chroms
#         d = weights %>% filter(chrom == CELL_META$sector.index)
#         m = d %>% select(top1:top3) %>% as.matrix()
#         # plot weighted topologies
#         circos.barplot(m,d$start, col = manual_colors, border = NA, bar_width = 500000)
#         # plot chromosome names
#         # mm_y() can be used to nudge something on the y axis
#         circos.text(CELL_META$xcenter, CELL_META$cell.ylim[2] + mm_y(10), CELL_META$sector.index, facing = 'downward') }
# })

## below is plotting a circos track with options to manually color
# circos.track(ylim = range(recomb$mean, na.rm = TRUE), track.height = 0.40,
#     panel.fun = function(x, y) {
#         # filter data for each chromosome
#         print(CELL_META$sector.index)
#         d = recomb %>% filter(chrom == CELL_META$sector.index)
#         # plot weighted topologies
#         circos.points(d$start,d$mean, pch = 21, col = "#0077ffa1", cex = 0.7,bg = "#1aff00a1")
# })
