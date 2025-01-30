# set working directory
#setwd("/Users/a108594/Desktop/")
setwd("D:/Documents/Castoe_Lab/CVOS_Phylogeny/analysis/PSTD/")


# load depends #
library(phangorn)
library(PSTDistanceR)


# read your trees into an object #
list.SpeciesTrees <- read.tree(file = '~/Desktop/handle.species.trees.set')


# make matrix to save results #
matrix.H <- matrix(0, nrow = length(list.SpeciesTrees), ncol = length(list.SpeciesTrees))
rownames(matrix.H) <- colnames(matrix.H) <- paste0("Tree_", 1:length(list.SpeciesTrees))
matrix.KL <- matrix.JS <- matrix.H
#vector.KEEP <- c("lutosus","concolor","oreganus","viridis","scutulatus")
vector.KEEP <- c("abyssus","lutosus","concolor","helleri","oreganus","cerberus","nuntius","viridis", "scutulatus")


# loop through trees #
matrix.AllSets <- combn(x = 1:length(list.SpeciesTrees), m = 2)
numeric.TotalComb <- ncol(matrix.AllSets)


# LOOP #
for (i in 1:numeric.TotalComb){
  print(i)
  TREE_01_POS <- matrix.AllSets[1,i]
  TREE_02_POS <- matrix.AllSets[2,i]
  
  TREE_01 <- list.SpeciesTrees[[TREE_01_POS]]
  TREE_02 <- list.SpeciesTrees[[TREE_02_POS]]
  
  TREE_01$edge.length[is.na(TREE_01$edge.length)] <- rep(0, length(TREE_01$edge.length[is.na(TREE_01$edge.length)]))
  TREE_02$edge.length[is.na(TREE_02$edge.length)] <- rep(0, length(TREE_02$edge.length[is.na(TREE_02$edge.length)]))
  
  TREE_01$node.label <- NULL
  TREE_02$node.label <- NULL
  
  TREE_01 <- drop.tip(TREE_01,TREE_01$tip.label[-match(vector.KEEP, TREE_01$tip.label)])
  TREE_02 <- drop.tip(TREE_02,TREE_02$tip.label[-match(vector.KEEP, TREE_02$tip.label)])
  
  # GET D #
  handle.RESULTS <- Compute.Probabilistic.SpeciesTree.Distances(handle.SpeciesTree.Model1 = TREE_01, 
                                                                handle.SpeciesTree.Model2 = TREE_02, 
                                                                string.PathParentDir = '~/Desktop/', 
                                                                string.PathHybridCoal = '~/Desktop/hybrid-coal-v0.2.1-beta/hybrid-coal')
  
  matrix.H[TREE_01_POS, TREE_02_POS] <- matrix.H[TREE_02_POS, TREE_01_POS] <- handle.RESULTS[1]
  matrix.KL[TREE_01_POS, TREE_02_POS] <- matrix.KL[TREE_02_POS, TREE_01_POS] <- handle.RESULTS[2]
  matrix.JS[TREE_01_POS, TREE_02_POS] <- matrix.JS[TREE_02_POS, TREE_01_POS] <- handle.RESULTS[3]
}


# Export the matrices
write.csv(matrix.H, "matrix.H.csv")
write.csv(matrix.KL, "matrix.KL.csv")
write.csv(matrix.JS, "matrix.JS.csv")


# visualize it with a 
library(qgraph)
setwd("/Users/a108594/Desktop/PSTD_2024-05-18/SpeciesTreeModel_Model2_2024-05-18")
final.dist <- read.csv("matrix.H.csv")


#View(nba)
dist_m <- as.matrix(dist(final.dist[1:19, -1]))
dist_mi <- 1/dist_m # one over, as qgraph takes similarity matrices as input
#jpeg('All_chroms_Jensen-Shannon_group.jpg', width=1000, height=1000, unit='px')
pdf('All_chroms_Hellinger_spring.pdf')
qgraph(dist_mi, layout='spring', vsize=3, shape = "circle", posCol = "forestgreen", negCol = "red", directed = FALSE)
centrality_auto(dist_mi)
#?qgraph()
dev.off()
qgraph::qg(dist_mi)


# can also do multidimensional scaling (MDS)
matrix.H <- read.csv("matrix.H.csv")


d <- dist(matrix.H) # euclidean distances between the rows


# Perform MDS analysis
fit <- cmdscale(d,eig=TRUE, k=2) # k is the number of dim
fit # view results


# plot solution
x <- fit$points[,1]
y <- fit$points[,2]
plot(x, y, xlab="Coordinate 1", ylab="Coordinate 2",
     main="Metric MDS", type="n")
text(x, y, labels = row.names(matrix.H), cex=.6)


# Let's make the MDS plot look nicer!
library(ggplot2)
library(dplyr)


# Form clusters using K-means clustering (specify the number of clusters, e.g., 3)
kmeans_clusters <- kmeans(fit$points, centers =4)$cluster


# Add cluster information to the MDS results
mds_df <- as.data.frame(fit$points)
mds_df$groups <- as.factor(kmeans_clusters)
mds_df <- mds_df %>%
  mutate(mds_df, chrom.type = "NULL") %>%
  mutate(chrom.type = ifelse(row_number() == 1, "all",
                        ifelse(row_number() >= 2 & row_number() <= 8, "macrochromosome",
                        ifelse(row_number() >= 9 & row_number() <= 18, "microchromosome",
                        ifelse(row_number() == 19, "Z-chromosome", chrom.type))))) %>%
  mutate(mds_df, chrom = c("All", "Ma1", "Ma2", "Ma3", "Ma4", "Ma5", "Ma6", "Ma7", 
                           "Mi1", "Mi2", "Mi3", "Mi4", "Mi5", "Mi6", "Mi7", "Mi8", "Mi9", "Mi10",
                           "Z"))




View(mds_df)


library(ggpubr)
library(ggrepel)


# Plot using ggscatter with labels using ggrepel
pdf("MDS_trees.pdf")
ggscatter(mds_df, x = "V1", y = "V2",
          color = "groups",
          palette = "jco",
          size = 3,
          ellipse = TRUE,
          ellipse.type = "convex",
          title = "K-means Clustering of MDS Tree Data",
          xlab = "MDS Dimension 1",
          ylab = "MDS Dimension 2") +
  geom_text_repel(aes(label = chrom), box.padding = 0.5)
dev.off()
