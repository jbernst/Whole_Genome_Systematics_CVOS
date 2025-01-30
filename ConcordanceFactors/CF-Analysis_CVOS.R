#########################################
#   Viewing Concordance Factors (CFs)   #
#     Original Tutorial: Rob Lanfear    #
#########################################


# Load in packages
library(viridis)
library(cowplot)
library(rlist)
library(ggplot2)
library(dplyr)
library(ggrepel)
library(GGally)
library(entropy)
library(phytools)
library(ape)


getwd()
setwd("/Users/a108594/Documents/CVOS_Phylogeny/Concordance-Factors_no-hual_2024.2.28")


# Let's check the ASTRAL phylogeny first to ensure we are working with the correct species tree.
tre <- read.tree("all_chrom_allseqs.SL.nohual.fas.treefile")
tre <-ladderize(tre, right = "TRUE")
plot(tre, no.margin = TRUE, edge.width = 2, cex = 1.3)
outgroup <- c("CR0001_rube","CA0346_atro")
t <- root(tre, outgroup = outgroup)
plot(tre, no.margin = TRUE, edge.width = 2, cex = 1.3)
nodelabels(text=1:tre$Nnode,node=1:tre$Nnode+Ntip(tre), cex = 1)


# pdf("all_chrom_allseqs.SL.nohual.fas.nodes.tree.pdf", 10, 15)
# plot(tre, no.margin = TRUE, edge.width = 2, cex = 1.3)
# nodelabels(text=1:tre$Nnode,node=1:tre$Nnode+Ntip(tre), cex = 1)
# dev.off()




#check that our outgroups are monophyletic
is.monophyletic(tre, tips = c("CA0346", "CR0001_rube"))


#=======================#
#  Macrochromosome CFs  #
#=======================#


# Set the working directory to work on the macrochromosomes.
getwd()
setwd("/Users/a108594/Documents/CVOS_Phylogeny/Concordance-Factors_no-hual_2024.2.28/macrochromosomes")


# read in your data from iqtree2 CF analyses. We will do this as a loop.
list.files()
temp <- list()
d <- list.files(pattern = "*.concord.cf.stat")
for (i in d) {
    chrom_name <- gsub("\\.concord\\.cf\\.stat$", "", i)
    temp[[i]]  <- read.delim(i, header = T, comment.char = '#') 
    temp[[i]] <- temp[[i]] %>% mutate(ID = 1:29) %>% rename(posterior_prob = Label, branchlength = Length)
    temp[[i]] <- temp[[i]] %>% mutate(chrom = chrom_name)
}


# now let's make a loop to add our CF plots to a list using the rlist and cowplot packages
plotlist = list()
for(i in temp){
# plot the values
p = ggplot(i, aes(x = gCF, y = sCF)) + 
    ggtitle(i$chrom) +
    geom_point(aes(colour = posterior_prob)) + 
    scale_colour_viridis(direction = -1) + 
    xlim(0, 100) +
    ylim(0, 100) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed") + 
    geom_text(aes(label = ID), vjust = 1.5, hjust = 1.5, cex = 2)


plotlist = list.append(plotlist,p)
}


# plot the list 
plot_grid(plotlist = plotlist, nrow = 3, ncol = 3)


# save the plot
pdf(file = "/Users/a108594/Documents/CVOS_Phylogeny/Concordance-Factors_no-hual_2024.2.28/macrochromosomes/macrochromosome_CFs.pdf", 
    width = 13, height = 10)
plot_grid(plotlist = plotlist, nrow = 3, ncol = 3)
dev.off()


#=======================#
#  Microchromosome CFs  #
#=======================#


# Set the working directory to work on the microchromosomes.
getwd()
setwd("/Users/a108594/Documents/CVOS_Phylogeny/Concordance-Factors_no-hual_2024.2.28/microchromosomes")


# read in your data from iqtree2 CF analyses. We will do this as a loop.
list.files()
temp2 <- list()
e <- list.files(pattern = "*.concord.cf.stat")
for (i in e) {
    chrom_name <- gsub("\\.concord\\.cf\\.stat$", "", i)
    temp2[[i]]  <- read.delim(i, header = T, comment.char = '#') 
    temp2[[i]] <- temp2[[i]] %>% mutate(ID = 1:29) %>% rename(posterior_prob = Label, branchlength = Length)
    temp2[[i]] <- temp2[[i]] %>% mutate(chrom = chrom_name)
}


# now let's make a loop to add our CF plots to a list using the rlist and cowplot packages
plotlist = list()
for(i in temp2){
# plot the values
p = ggplot(i, aes(x = gCF, y = sCF)) + 
    ggtitle(i$chrom) +
    geom_point(aes(colour = posterior_prob)) + 
    scale_colour_viridis(direction = -1) + 
    xlim(0, 100) +
    ylim(0, 100) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed") + 
    geom_text(aes(label = ID), vjust = 1.5, hjust = 1.5, cex = 2)


plotlist = list.append(plotlist,p)
}


# plot the list 
plot_grid(plotlist = plotlist, nrow = 4, ncol = 3)


# save the plot
pdf(file = "/Users/a108594/Documents/CVOS_Phylogeny/Concordance-Factors_no-hual_2024.2.28/microchromosomes/microchromosome_CFs.pdf", 
    width = 13, height = 10)
plot_grid(plotlist = plotlist, nrow = 4, ncol = 3)
dev.off()


#=======================#
#  Z Chromosome CFs     #
#=======================#


# Set the working directory to work on the microchromosomes.
getwd()
setwd("/Users/a108594/Documents/CVOS_Phylogeny/Concordance-Factors_no-hual_2024.2.28/Z-chromosome/")


# read in the Z chromosome CF data (no need for a loop this time, as it is just one file)
z = read.delim("Z.concord.cf.stat", header = T, comment.char = '#')               
View(z)
# change the columns of Label and length to posterior_prob and branchlength
# note: we could have also done what we did for the loops where we used piping into mutate()
names(z)[18] = "posterior_prob"
names(z)[19] = "branchlength"


# add a column for the chromosome names
z <- z %>% mutate(chrom = "Z")
z$ID <- seq(1,29)


# plot the values
ggplot(z, aes(x = gCF, y = sCF)) + 
    ggtitle(z$chrom) +
    geom_point(aes(colour = posterior_prob)) + 
    scale_colour_viridis(direction = -1) + 
    xlim(0, 100) +
    ylim(0, 100) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
    geom_text(aes(label = ID), vjust = 1.5, hjust = 2)


# save the plot
pdf(file = "/Users/a108594/Documents/CVOS_Phylogeny/Concordance-Factors_no-hual_2024.2.28/Z-chromosome/Z_CFs.pdf", 
    width = 13, height = 10)
ggplot(z, aes(x = gCF, y = sCF)) + 
    ggtitle(z$chrom) +
    geom_point(aes(colour = posterior_prob)) + 
    scale_colour_viridis(direction = -1) + 
    xlim(0, 100) +
    ylim(0, 100) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
    geom_text(aes(label = ID), vjust = 1.5, hjust = 2)
dev.off()


#=================#
#   Global  CFs   #
#=================#
# here are out lists of tables
temp
temp2
z


# combine tables using rbind.data.frame (regular rbind can get weird with too many variables)
ma.table <- do.call(rbind.data.frame, temp)
mi.table <- do.call(rbind.data.frame, temp2)
mami.table <- rbind.data.frame(ma.table, mi.table)
chrom.table <- rbind.data.frame(z, mami.table)


setwd("/Users/a108594/Documents/CVOS_Phylogeny/Concordance-Factors_no-hual_2024.2.28/")
write.csv(chrom.table, file = "/Users/a108594/Documents/CVOS_Phylogeny/Concordance-Factors_no-hual_2024.2.28/Z-chromosome/All_CVOS_CFs.csv", row.names = FALSE)


#View(chrom.table)
#chrom.table <- read.csv("/Users/a108594/Documents/CVOS_Phylogeny/Concordance-Factors_no-hual_2024.2.28/Z-chromosome/All_CVOS_CFs.csv")


View(chrom.table)
# test for ILS
chisq = function(DF1, DF2, N){
    tryCatch({
        # converts percentages to counts, runs chisq, gets pvalue
        chisq.test(c(round(DF1*N)/100, round(DF2*N)/100))$p.value
    },
    error = function(err) {
        # errors come if you give chisq two zeros
        # but here we're sure that there's no difference
        return(1.0)
    })
}
View(c)
e = chrom.table %>% 
    group_by(ID) %>%
    mutate(gEF_p = chisq(gDF1, gDF2, gN)) %>%
    mutate(sEF_p = chisq(sDF1, sDF2, sN))


subset(data.frame(e), (gEF_p < 0.05 | sEF_p < 0.05))




# let's also make a column to group by macrochromosomes, microchromosomes, and the Z chromosome
chrom.table <- chrom.table %>% mutate(chromtype = ifelse(
    grepl("ma", chrom),
    "macrochromosomes",
    "microchromosomes")) %>% 
    mutate(chromtype = ifelse(chrom == 'Z', 'Z', chromtype))


# plot the values by chromosome
pdf("Genome-Wide-CFs_chrom.pdf")
ggplot(chrom.table, aes(x = gCF, y = sCF)) + 
    ggtitle("Genome Wide CFs") +
    geom_point(aes(colour = chrom), size = 3, alpha = 0.5) + 
    scale_colour_viridis_d(direction = -1) + 
    theme_bw() +
    xlim(0, 100) +
    ylim(0, 100) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed")
dev.off()


# plot the values by chromosome type
pdf("Genome-Wide-CFs_type.pdf")
ggplot(chrom.table, aes(x = gCF, y = sCF)) + 
    ggtitle("Genome Wide CFs") +
    geom_point(aes(colour = chromtype), size = 3, alpha = 0.5) + 
    scale_colour_viridis_d(direction = -1) + 
    theme_bw() +
    xlim(0, 100) +
    ylim(0, 100) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed")
dev.off()


# plot the values by posterior probability
pdf("Genome-Wide-CFs_UFB.pdf")
ggplot(chrom.table, aes(x = gCF, y = sCF)) + 
    ggtitle("Genome Wide CFs") +
    geom_point(aes(colour = posterior_prob), size = 3, alpha = 0.7) + 
    scale_colour_viridis_b(direction = -1) + 
    theme_bw() +
    xlim(0, 100) +
    ylim(0, 100) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed")
dev.off()


# plot the values by node
pdf("Genome-Wide-CFs_node_labeled.pdf")
ggplot(chrom.table, aes(x = gCF, y = sCF)) + 
    ggtitle("Genome Wide CFs") +
    geom_point(aes(colour = as.factor(ID)), size = 3, alpha = 0.5) + 
    scale_colour_viridis_d(direction = -1) + 
    theme_bw() +
    xlim(0, 100) +
    ylim(0, 100) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
    geom_text(aes(label = ID), vjust = 1.5, hjust = 1.5, size = 2, check_overlap = TRUE)
dev.off()


# plot the values by nodees we designated 
pdf("Genome-Wide-CFs_node17_labeled.pdf")
ggplot(chrom.table, aes(x = gCF, y = sCF)) + 
    ggtitle("Genome Wide CFs Node 17 Highlighted") +
    geom_point(aes(colour = as.factor(Node_17)), size = 3, alpha = 0.5) + 
    scale_colour_manual(values = c("TRUE" = "#138deb", "FALSE" = "#9a9a9aa6")) +
    theme_bw() +
    xlim(0, 100) +
    ylim(0, 100) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed")
dev.off()


View(chrom.table)
# have only specific nodes labeled
label_data <- subset(chrom.table, ID == 3)
View(label_data)


# ID=8 micro 9 low sCF
# ID=4 good example of population variation 
# ID=9 the Z has a significantly higher gCF
# ID=10 mi5, mi6, mi9 have really lower gCFs
# ID=18 agreement on all chroms of very low gCFs - this is the GBC
# ID=17 agreement on all chroms of very low gCFs - this is the oreganus clade without cerberus 


pdf("Genome-Wide-CFs_node_labeled_subset3.pdf")
ggplot(chrom.table, aes(x = gCF, y = sCF)) + 
    ggtitle("Genome Wide CFs") +
    geom_point(aes(colour = as.factor(ID)), size = 3, alpha = 0.5) + 
    scale_colour_viridis_d(direction = -1) + 
    theme(panel.background = element_rect(fill = "#cccccc")) +
    xlim(0, 100) +
    ylim(0, 100) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
    geom_text(data = label_data, aes(label = ID), size = 3)
dev.off()




# Create a loop to iterate plotting over all IDs
for (i in 1:29) {
  # Subset the data for the current ID
  label_data <- subset(chrom.table, ID == i)
  
  # Check if there are observations for this ID
  if (nrow(label_data) > 0) {
    # Set the filename with the subset number
    pdf_name <- paste0("Genome-Wide-CFs_node_labeled_subset", i, ".pdf")
    
    # Start the PDF device
    pdf(pdf_name)
    
    # Create the plot
    p <- ggplot(chrom.table, aes(x = gCF, y = sCF)) + 
      ggtitle(paste("Genome Wide CFs Subset", i)) +
      geom_point(aes(colour = as.factor(ID)), size = 3, alpha = 0.5) + 
      scale_colour_viridis_d(direction = -1) + 
      theme(panel.background = element_rect(fill = "#cccccc")) +
      xlim(0, 100) +
      ylim(0, 100) +
      geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
      geom_text(data = label_data, aes(label = ID), size = 3)
    
    # Print the plot
    print(p)
    
    # Turn off the device
    dev.off()
  } else {
    cat("No observations found for ID", i, "\n")
  }
}


# make some boxplots and run stat tests
data.bp <- read.csv("./CFs_all-chrom_box-plot-data.csv")


# Define macro, micro, and Z chromosome groups
macrochromosomes <- c("ma1", "ma2", "ma3", "ma4", "ma5", "ma6", "ma7")
microchromosomes <- c("mi1", "mi2", "mi3", "mi4", "mi5", "mi6", "mi7", "mi8", "mi9", "mi10")


# make a 'chrom.type' column to label chromosomes by type
data.bp$chrom.group <- ifelse(data.bp$chrom == "Z", "Z",
                              ifelse(data.bp$chrom %in% macrochromosomes, "Macrochromosome",
                                     ifelse(data.bp$chrom %in% microchromosomes, "Microchromosome", NA)))


head(data.bp)


# run an ANOVA
anova.gcf <- aov(gCF ~ chrom.group, data = data.bp)


# check the results 
summary(anova.gcf)
#              Df Sum Sq Mean Sq F value Pr(>F)
# chrom.group   2   3114  1556.8   3.728 0.0247 *
# Residuals   519 216720   417.6
# ---
# Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1


TukeyHSD(anova.gcf)
#   Tukey multiple comparisons of means
#     95% family-wise confidence level


# Fit: aov(formula = gCF ~ chrom.group, data = data.bp)


# $chrom.group
#                                      diff         lwr       upr     p adj
# Microchromosome-Macrochromosome  5.090217   0.6948559  9.485578 0.0183731
# Z-Macrochromosome                3.839458  -5.6954183 13.374335 0.6111032
# Z-Microchromosome               -1.250759 -10.6051479  8.103631 0.9470182


# run an ANOVA and Tukey HSD for sCF
anova.scf <- aov(sCF ~ chrom.group, data = data.bp)


# check the results 
summary(anova.scf)
#              Df Sum Sq Mean Sq F value Pr(>F)
# chrom.group   2    845   422.5    1.28  0.279
# Residuals   519 171348   330.2


TukeyHSD(anova.scf)
#   Tukey multiple comparisons of means
#     95% family-wise confidence level


# Fit: aov(formula = sCF ~ chrom.group, data = data.bp)


# $chrom.group
#                                      diff       lwr       upr     p adj
# Microchromosome-Macrochromosome -1.481074 -5.389346  2.427198 0.6464076
# Z-Macrochromosome                3.742857 -4.735376 12.221090 0.5534338
# Z-Microchromosome                5.223931 -3.093816 13.541678 0.3032177


# gCF boxplots
pdf("gCF-boxplots-chrom.pdf", 13, 10)
boxplot.gcf <- ggplot(data.bp, aes(x = chrom, y = gCF, fill = chrom)) +
    geom_boxplot(alpha = 0.8) + 
    ggtitle("Box Plot of gCF by Chromosome") +
    theme_bw() +
    xlab("Chromosome") +
    ylab("gCF")
boxplot.gcf
dev.off()


# sCF boxplots
pdf("sCF-boxplots-chrom.pdf", 13, 10)
boxplot.scf <- ggplot(data.bp, aes(x = chrom, y = sCF, fill = chrom)) +
    geom_boxplot(alpha = 0.8) + 
    ggtitle("Box Plot of sCF by Chromosome") +
    xlab("Chromosome") +
    theme_bw() +
    ylab("sCF")
boxplot.scf
dev.off()


# make violin plots to better show the spread of the data (but they are quite ugly)
pdf("gCF-violinplots-chrom.pdf", 13, 10)
violinplot.gcf <- ggplot(data.bp, aes(x = chrom, y = gCF, fill = chrom)) +
    geom_violin(alpha = 0.5) +
    ggtitle("Violin Plot of gCF by Chromosome") +
    xlab("Chromosome") +
    ylab("gCF")
violinplot.gcf
dev.off()


pdf("sCF-violinplots-chrom.pdf", 13, 10)
violinplot.scf <- ggplot(data.bp, aes(x = chrom, y = sCF, fill = chrom)) +
    geom_violin(alpha = 0.5) + 
    ggtitle("Violin Plot of sCF by Chromosome") +
    xlab("Chromosome") +
    ylab("sCF")
violinplot.scf
dev.off()




# run a gCF linear regression
p <- lm(formula = gCF ~ branchlength, data = data.bp)
summary(p)
rsquared <- summary(p)$r.squared


# make a function for plotting


pdf("lm-gCF-branchlengths.pdf", 13,10)
ggplot(data.bp, aes(x = gCF, y = branchlength)) + 
  geom_point() +
  ggtitle("Linear Regression of gCF and Branchlengths") +
  stat_smooth(method = "lm", col = "red") +
  geom_text(label = paste("R² =", round(rsquared, 3)), x = Inf, y = -Inf, hjust = 1, vjust = 0)
dev.off()


# run an sCF linear regression
p <- lm(formula = sCF ~ branchlength, data = data.bp)
summary(p)
rsquared <- summary(p)$r.squared


# make a function for plotting
pdf("lm-sCF-branchlengths.pdf", 13,10)
ggplot(data.bp, aes(x = sCF, y = branchlength)) + 
  geom_point() +
  ggtitle("Linear Regression of sCF and Branchlengths") +
  stat_smooth(method = "lm", col = "red") +
  geom_text(label = paste("R² =", round(rsquared, 3)), x = Inf, y = -Inf, hjust = 1, vjust = 0)
dev.off()
