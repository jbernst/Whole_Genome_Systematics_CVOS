# Assessing Tree Discordance with Concordance Factors

We can check to see how many genes and sites agree with our ASTRAL species tree using concordance factors (gCF and sCF) in `iqtree2`. To do this, all we need is a directory containing our alignment files and a single file with all of our gene trees (not really genes, they are 10kb window trees). To make the gene tree file, just go into a directory with your *.treefile files from iqtree2 and use `cat *.treefile > {chrom}_UFBtree.tre`. You can use any reference tree for this, but since we used ASTRAL for our species tree, let's use that as the reference; I exported it as a newick tree from `FigTree` and called this file `cvos.all.astral_newick.tre`.

As of 2022, sCFs and gCFs can be run with maximum likelihood, as opposed to parismony in versions of iqtree <2.2.2. However, due to the size of our dataset, we will run with parsimony. To run both gCFs and sCFs (with 8 cores), I ran the code as follows (this shows an example with a tree file of gene trees from macrochromosome 4 and a directory called `ma4` with alignment files):

```
iqtree2 -t cvos.all.astral_newick.tre --gcf ma4_UFB.tree -p ma4 --scf 100 --prefix ma4.concord -T 8
```

The output (`ma4.concord.cf.stat`) was then viewed in R using [Rob Lanfear&#39;s concordance factor tutorial](http://www.robertlanfear.com/blog/files/concordance_factors.html):

```r
library(viridis)
library(ggplot2)
library(dplyr)
library(ggrepel)
library(GGally)
library(entropy)

# read the data
d = read.delim("concord.cf.stat", header = T, comment.char=‘#')
   
names(d)[10] = "bootstrap"
names(d)[11] = "branchlength"


# plot the values
ggplot(d, aes(x = gCF, y = sCF)) + 
    geom_point(aes(colour = bootstrap)) + 
    scale_colour_viridis(direction = -1) + 
    xlim(0, 100) +
    ylim(0, 100) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed")
```
