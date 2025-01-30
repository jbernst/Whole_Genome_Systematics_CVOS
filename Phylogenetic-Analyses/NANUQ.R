# Below is an example of the PhyloNet analysis that was run for this project.

setwd("/home/administrator/ExtraSSD2/Justin/Analyses_JMB/NANUQ/all-chrom")
library(MSCquartets)

## import gene tre data (a text files with 1 newick tree per line)
genedata <- "all-chrom_iqtrees_nohual.tre"

## run NANUQ to generate quartet trees. if taxanames = NULL, all taxa in first tree are used. Otherwise, give it a vector of the taxa to include).
nanuq.genome <- NANUQ(genedata, outfile="NANUQdistAll-Chrom", alpha=0.05, beta=0.95, taxanames = NULL, plot = FALSE)

ptable_nanuq.genome <- quartetTablePrint(nanuq.genome$pTable)
saveRDS(ptable_nanuq.genome, "ptable_nanuq.AllChrom_ptable_alpha0_5_beta0_95.rds")
write.table(ptable_nanuq.genome, "ptable_nanuq.AllChrom_ptable_alpha0_5_beta0_95.txt")
write.table(nanuq.genome$pTable, "ptable_nanuq.AllChrom_ptable_alpha0_5_beta0_95.csv")
# readRDS("ptable_nanuq.AllChrom_ptable_alpha0_5_beta0_95.rds")


## Recalculate and replot simplex graph using different alpha and/or beta. 
pdf("Nanuq_CVOS-phylo-all-chrom-nohual_alpha-1e-100.pdf")
NANUQdist(nanuq.genome$pTable, outfile = "NANUQdistAll-Chrom", alpha = 1e-100, beta = 0.95, plot = TRUE)
dev.off()
