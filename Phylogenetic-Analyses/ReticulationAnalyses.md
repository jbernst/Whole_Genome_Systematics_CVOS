# Reconstructing Phylogenetic Networks (PhyloNet and NANUQ)

## PhyloNet

It is widely known that our typical ways of reconstructing phylogenies (bifurcating) is not always the most accurate depiction of a group's evolutionary history. We will use `PhyloNet` [version 3.8.2](https://phylogenomics.rice.edu/html/phylonetTutorial.html). `PhyloNet` was ran on all macrochromosomes, microchromosomes, and the Z chromosome by using the 10kb-based trees from IQ-TREE as input. For each analysis (chromosome), 10 iterations of PhyloNet were run, allowing a maximum of 1 to 8 reticulations. An example (showing only the first 10 trees lines, without the actual Newick tree shown to not have weird spacing in this file), and a maximum of 5 reticulations allowed. I used the .treeFile which did not have UFBs, but it should be fine if it includes the UFBs (if not, just use trees without them). This software assumes you have one alleles per species, so if you have multiple tips for a single taxon, group them together using the `-a` flag. I used the InferNetwork_MPL (maximum pseudolikelihood approach). This is pretty standard and given how much data we have, will take a long time if we used the maximum likelihood or Bayesian approaches (though even with MPL, this took ~1 to run for all chromosomes) on the StarBeast nodes that have 8 cores and 32 GB of RAM. So, this all means I ran 8 analyses for each chromosome.

```
#Nexus

Begin trees;

Tree geneTree0 = {Tree in from IQ-TREE .treeFile}
Tree geneTree1 = {Tree in from IQ-TREE .treeFile}
Tree geneTree2 = {Tree in from IQ-TREE .treeFile}
Tree geneTree3 = {Tree in from IQ-TREE .treeFile}
Tree geneTree4 = {Tree in from IQ-TREE .treeFile}
Tree geneTree6 = {Tree in from IQ-TREE .treeFile}
Tree geneTree7 = {Tree in from IQ-TREE .treeFile}
Tree geneTree8 = {Tree in from IQ-TREE .treeFile}
Tree geneTree9 = {Tree in from IQ-TREE .treeFile}

END;

BEGIN PHYLONET;

InferNetwork_MPL (all) 5 -a <Outgroup:CA0346_atro,CR0001_rube; Sscutulatus:CS0143_cent,CS0142_cent,CS0237_chih,CS0029_chih,CS0153_moha,CS0027_moha; Ssalvini:CS0148_salv,CS0146_salv; Vviridis:CV0018_vir2,CV0008_vir1,CV0648_vir1,CV0631_vir2; Vnuntius:CV0075_nunt,CV0756_nunt; Ocerberus:CV0716_cerb,CV0755_cerb; Ohualapaiensi:CV0703_hual,CV0725_hual; Oconcolor:CV0711_conc,CV0040_conc; Olutosus:CV0067_luto,CV0203_luto; Oabyssus:CV0721_abys,CV0719_abys; Ooreganus:CV0136_ore2,CV0086_ore1,CV0147_ore1,CV0094_ore2; Ohelleri:CV0053_hell,CV0054_hell; Ocaliginis:CV0732_cali,CV0736_cali> -pl 8 -di;

END;
```

Let's call this one `PhyloNet-ma5-IQ-5R.nex` (to symbolize the use of `PhyloNet` on IQ-TREE trees with a maximum of 5 reticulations allowed in our analysis); the PhyloNet input and output files are all stored on Norma (`/home/administrator/Desktop/ExtraSSD2/Justin/phylogeny/PHYLONET`).

To run the analysis, you simpled call upon the PhyloNet .jar file and give it the input file:

`java - jar PhyloNetv3_8_2.jar PhyloNet-ma5-IQ-5R.nex`

I stored all of the input files (`PhylonNet-ma5-IQ-1R.nex, PhyloNet-ma5-IQ-2R.nex`, ... `PhyloNet-ma5-IQ-8R.nex`)``  for one chromosome and ran a loop so that it would move onto the next analysis when the first one is done (and printing output to a file before doing so):

```
for i in *.nex
do java -jar PhyloNetv3_8_2.jar $i > $i.output.txt
done
```

## NANUQ

Interpreting PhyloNet results can be a bit difficult with how the trees and reticulations are plotted, especially in groups that have extensive introgression (like our system here). We can also run NANUQ to valid our findings that reticulations exist by using another analysis. We will use [NANUQ](https://doi.org/10.1186/s13015-019-0159-2) in the R package [MSCquartets](https://cran.r-project.org/web/packages/MSCquartets/index.html). NANUQ performs two hypothesis tests for reticulations on quartets from gene trees. You define an alpha parameter and test if reticulations are a better explanation (rather than a bifurcating tree) for the data. The best practice is to change alpha to a smaller and smaller value to make it "harder" to support reticulations and see if the results are consistent. For this study, we ran the analysis on all chromosomes, just macrochromosomes, just microchromosomes, and the Z chromosome. This was done for all species and then just the *C. oreganus* clade.

Actually running NANUQ is quite easy. An exmaple code is below (and can also be found in the [Phylogenetic-Analyses/NANUQ.R](NANUQ.R) file:

```R
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
```
