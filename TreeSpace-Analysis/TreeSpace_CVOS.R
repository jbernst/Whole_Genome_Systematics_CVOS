# Using TreeSpace R package


# set working directory
setwd("~/ExtraSSD2/Justin/Analyses_JMB/TreeSpace_Subsetted-Data")


# set a new environment for our stored objects
env <- new.env()


# load packages
library(devtools)


#install_github("thibautjombart/treespace")
library(treespace)
library(adegenet)
library(adegraphics)
library(rgl)
library(phylobase)
library(webshot)
install.packages("readPNG")


# read newick trees where we take 200 random trees per chromosome
trees <- readLines("./all-chrom-rand500.tre")


# or (and this should be done), ready in treeas as a multiPhylo object
myTree <- ape::read.tree("./all-chrom-rand500.tre")
class(myTree)
is.rooted(myTree)


outgroup <- c("CA0346_atro")


myTree <- ape::root(myTree, outgroup, resolve.root = TRUE)
is.rooted(myTree)


# test
plot(myTree[[42]])


# further explore tree space. Run with retention of 3 PCs. We will store this in an object that can be loaded.
# res <- treespace(myTree, nf=3)
# save(res, file = "res_myTree_nf-3.RData")
load("res_myTree_nf-3.RData", envir = env)
res <- env$res




# check the PCs
head(res$pco$li)


# when prompted on how many axes, pick 3
# clust <- findGroves(myTree, nclust = 4)
# save(clust, file = "clust_myTree_nclust-4.RData")
load("clust_myTree_nclust-4.RData", envir = env)
clust <- env$clust


# basic plot
plotGrovesD3(clust)


plotGrovesD3(clust, tooltip_text=paste0("Tree ",1:7106), legend_width=50, col_lab="Cluster", treeNames=1:7106)


# check ma3 and mi9
# ma3 are trees 1001-1500
# mi9 are trees 6614-6654


chromosome_names <- c(rep("ma1", 500), rep("ma2", 500), rep("ma3", 500), rep("ma4", 500),
                      rep("ma5", 500), rep("ma6", 500), rep("ma7", 500), rep("mi10", 95),
                      rep("mi1", 500), rep("mi2", 249), rep("mi3", 447), rep("mi4", 356),
                      rep("mi5", 154), rep("mi6", 386), rep("mi7", 426), rep("mi8", 500),
                      rep("mi9", 41), rep("Z", 452))


# Check the length of chromosome_names to ensure it matches the number of trees
length(chromosome_names)  # Should match the total number of trees, (7106))


# plot showing chromosome labels
test <- plotGrovesD3(clust, xax=1, yax=3, tooltip_text=paste0("Tree ",1:7106), legend_width=50, col_lab="Cluster", treeNames=chromosome_names)


# view the same plot above but on 3 axes
plotGrovesD3(clust, xax=1, yax=3, tooltip_text=paste0("Tree ",1:7106), legend_width=50, col_lab="Cluster", ellipses = TRUE)


# we can also change the groupings to be by chromosome type
# make a vector of names/types
chromosome_names <- c(
  rep("macro", 3500),
  rep("micro", 3154),
  rep("Z", 452)
)
# Ensure that the lengths of clust$groups and chromosome_names match
if (length(clust$groups) == length(chromosome_names)) {
  clust$groups <- chromosome_names
} else {
  stop("Length of clust$groups and chromosome_names do not match!")
}


# view the plots
plot <- plotGrovesD3(clust, xax=1, yax=2, tooltip_text=paste0("Tree ",1:7106), legend_width=50, col_lab="Cluster", ellipses = TRUE)


htmlwidgets::saveWidget(plot, "scatter_plot_chrom-type_x1y2.html")


plot <- plotGrovesD3(clust, xax=1, yax=3, tooltip_text=paste0("Tree ",1:7106), legend_width=50, col_lab="Cluster", ellipses = TRUE)


htmlwidgets::saveWidget(plot, "scatter_plot_chrom-type_x1y3.html")


# we can use fac2col to turn factors to colors
colours <- fac2col(clust$groups, col.pal=funky)
# or make our own
colours.man <- c(
  rep("#138FED", 3500),
  rep("#ED131E", 3154),
  rep("#00DE1E", 452)
)


plot3d(clust$treespace$pco$li[,1],
       clust$treespace$pco$li[,2],
       clust$treespace$pco$li[,3],
       col=colours.man, type="s", size=1,
       xlab="", ylab="", zlab="", treeNames=1:7106)
rglwidget()


# We can also find the median tree of all of our trees, like below:
# get first median tree
tre <- medTree(myTree)$trees[[1]]


# plot tree
pdf("TreeSpace_all-chrom_MedianTree.pdf")
plot(tre,type="phylogram",edge.width=3, cex=0.8)
dev.off()


# Though, a more accurate summary would be to find the summary tree from each cluster
res <- medTree(myTree, clust$groups)
names(res)


# get the first median of each
med.trees <- lapply(res, function(e) ladderize(e$trees[[1]]))


# plot trees
pdf("TreeSpace_all-chrom_MedianTrees_3-groups.pdf", 10, 11)
par(mfrow=c(2,3))
for(i in 1:length(med.trees)) plot(med.trees[[i]], main=paste("cluster",i),cex=1)
dev.off()




# ladderize the trees in the same direction
tree1 <- ladderize(med.trees[[1]], right = FALSE) # macrochromosome median tree
tree2 <- ladderize(med.trees[[2]], right = FALSE) # microchromosome median tree
tree3 <- ladderize(med.trees[[3]], right = FALSE) # Z chromosome median tree


# Compare median trees from clusters 1 and 2:
pdf("TreeSpace_MedTree1-Ma_vs_MedTree2-Mi.pdf")
plotTreeDiff(tree1, tree2, use.edge.length=FALSE, 
             treesFacing = TRUE, colourMethod = "palette", palette = funky)
dev.off()


# Compare median trees from clusters 1 and 2, and change aesthetics:
pdf("TreeSpace_MedTree1-Ma_vs_MedTree2-Mi_DiagonalTree.pdf", 12, 10)
plotTreeDiff(tree1, tree2, type="cladogram", use.edge.length=FALSE, 
             treesFacing = TRUE, edge.width=2, colourMethod="palette", palette=spectral)
dev.off()


# Compare median trees from clusters 1 and 3:
pdf("TreeSpace_MedTree1-Ma_vs_MedTree3-Z.pdf")
plotTreeDiff(tree1, tree3, use.edge.length=FALSE, 
             treesFacing = TRUE, colourMethod = "palette", palette = funky)
dev.off()


# Compare median trees from clusters 1 and 3, and change aesthetics:
pdf("TreeSpace_MedTree1-Ma_vs_MedTree3-Z_DiagonalTree.pdf", 12, 10)
plotTreeDiff(tree1, tree3, type="cladogram", use.edge.length=FALSE, 
             treesFacing = TRUE, edge.width=2, colourMethod="palette", palette=spectral)
dev.off()


# Compare median trees from clusters 2 and 3:
pdf("TreeSpace_MedTree2-Mi_vs_MedTree3-Z.pdf")
plotTreeDiff(tree2, tree3, use.edge.length=FALSE, 
             treesFacing = TRUE, colourMethod = "palette", palette = funky)
dev.off()


# Compare median trees from clusters 2 and 3, and change aesthetics:
pdf("TreeSpace_MedTree2-Mi_vs_MedTree3-Z_DiagonalTree.pdf", 12, 10)
plotTreeDiff(tree2, tree3, type="cladogram", use.edge.length=FALSE, 
             treesFacing = TRUE, edge.width=2, colourMethod="palette", palette=spectral)
dev.off()
