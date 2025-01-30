# script for creating weight smoothing from TWISST. Please download the plot_twisst.R file from the TWISST Github by Simon Martin

library(tidyverse)
library(rlist)
library(stats)
source("plot_twisst.R")

# set working directory and bring in the weighted data file from TWISST
setwd("/Users/a108594/Documents/CVOS_Phylogeny/TWISST_nohual_2024.2.29")
data = read.delim('./topology-weights_all-regions_no-hual.csv', header = F) 
View(data)
# assign names to the columns in the dataframe
names(data) = c(
	'chrom',
	'end',
	'top1_abs',
	'top2_abs',
	'top3_abs'
)

# read in the chromosome list file and change the column names
chromlist = read.delim('./chrom.list', header = F)
names(chromlist) = c('chrom',  'length')

# convert weights to relative weights
# rowwise() is part of dplyr and tells the code to treat the subsequent operations as a rowwise sequence (i.e., each row).
# we are taking the data and forming a new column called sum with the sums of top1_abs, top2_abs, and top3_abs for EACH ROW 
# and then turning it into a dataframe
data = data %>% rowwise() %>% mutate(sum = sum(top1_abs + top2_abs + top3_abs),
	top1 = top1_abs/sum,
	top2 = top2_abs/sum,
	top3 = top3_abs/sum) %>%
	as.data.frame()

# create settings for smoothing
span_bp = 1e6
spacing = 5e5

# set number of topologies
ntopos = 3

datalist = list()
for(i in unique(data$chrom))
{
	d = data %>% filter(chrom == i)
	length = (chromlist %>% filter(chrom == i))$length
	span = span_bp/length
	new_x = seq(0,length,spacing)

	smoothed1 = simple.loess.predict(d$end, d$top1, span = span, new_x = new_x, max = 1, min = 0, weights = NULL, family = NULL)
	smoothed2 = simple.loess.predict(d$end, d$top2, span = span, new_x = new_x, max = 1, min = 0, weights = NULL, family = NULL)
	smoothed3 = simple.loess.predict(d$end, d$top3, span = span, new_x = new_x, max = 1, min = 0, weights = NULL, family = NULL)

	dsmoothed_temp = data.frame(
		top1 = smoothed1,
		top2 = smoothed2,
		top3 = smoothed3
	)

	dsmoothed_temp = dsmoothed_temp / apply(dsmoothed_temp,1,sum)

	dsmoothed = data.frame(
		chrom = i,
		end = new_x,
		top1 = dsmoothed_temp$top1,
		top2 = dsmoothed_temp$top2,
		top3 = dsmoothed_temp$top3
	)

	dsmoothed = dsmoothed %>%
		mutate(top1_add = top1,
			top2_add = top1 + top2,
			top3_add = top1 + top2 + top3)

	datalist = list.append(datalist, dsmoothed)
}

smoothed_topology = do.call(rbind.data.frame, datalist)
write.csv(smoothed_topology,'./smoothed_topology_nohual.csv')

# smoothed.long = smoothed_topology %>% pivot_longer(-c(chrom,end,top1_add:top3_add), values_to = 'weights', names_to = 'topology')
# ggplot(smoothed.long %>% filter(chrom == 'scaffold-mi10'), aes(x = end, y = weights, col = topology)) + geom_line()


smoothed.long = smoothed_topology %>% pivot_longer(-c(chrom,end,top1:top3), values_to = 'weights', names_to = 'topology') %>%
	mutate(topology = factor(topology, levels = c('top3_add','top2_add','top1_add')))
ggplot(smoothed.long %>% filter(chrom == 'scaffold-ma6')) + 
	geom_ribbon(aes(x = end, ymax = weights, ymin = 0, fill = topology))
