# Investigating Topological Support Across the Genome with Site-Specific Likelihoods (SSL)

Site-specific likelihoods are a useful tool for testing topological support for one tree topology vs. another on a site-by-site basis in an alignment. The basis of this, which is descrbed well in [Castoe et al. (2009)](https://doi.org/10.1073/pnas.0900233106),  is that when we run phylogenetic analyses, we get a summed likelihood value for a particular tree, which is obtained by summing up the site likelihoods across a tree. Remember, typical phylogenetic analyses involve obtaining a tree, for a particular alignment under a particular model of molecular evolution. When analyses are run, site-specific likelihoods show the support for a particular tree and are summed up across sites. The difference in site-specific likelihoods (SSL of tree A at position X - SSL of tree B at position X = ΔSSL) can be used to compare two competing trees. So, far a particular site in an alignment, do we get a positive or negative value, thus denoting support for tree A or tree B (in our example), respectively. Model misspecifications, due to phenomena like convergence or selection, can inflate SSL values, and thus instead of getting a moderate ΔSSL of -2 or 2 (most ΔSSL are within this range), you may get a ΔSSL several folder greater in magnitude (absolute value of ΔSSL). Given that SSL are summed up to obtain support for a tree, that means just a single site that has a ΔSSL of 200 can swamp out ALL of the information in an alignment if all other sites have ΔSSL of, say, 0.5 or somewhere close to 0.

So, to look at genome-wide support of our most distinct trees (concatenated/species tree topology, mitochondrial topology, and the Z topology), I ran three sets of SSL analyses by changing the reference tree to determine what the SSL of a site is given a particular topology. I obtained SSLs, separately, when giving a reference tree of:

1. the concatenated tree (used to include all specimens; species tree only has one tip per species)
2. the mitochondrial tree
3. the Z chromosome tree

Running the SSL analysis is actually pretty easy and can be performed in `IQ-TREE2`:

We will constrain the model of molecular evolution to be GTR+G, as the **ONLY** thing that we want to change in the analysis (i.e., everything else in the SSL calculation is the same) is the reference tree:

```bash
./iqtree2 -s ma1_allseqs.SL.nohual.fas -wsl -te all_chrom_allseqs.SL.nohual.fas.treefile -m GTR+G -nt AUTO
```

So this shows the code for generation SSL for macrochromosome 1 (all 10 kb windows concatenated) given the nuclear concatenated tree under a GTR+G model of molecular evolution. This is done for all chromosomes, and then the entire process is repeated two more times, replacing the -`te `flag with the other two tree topolgy files: `CVOS_mito-concatenated.phy.treefile` and `Z_allseqs.SL.nohual.fas.treefile`. The treefiles in the `-te` flag are just the `*.treefile` that is outputted from an `IQ-TREE2 analysis`.

Once you gert the SSL values, which are output as a `*.sitelh` file for each analysis (so one file for each chromosome for each reference tree), the ΔSSL can be calculated. This is best done in R, which is also where we will plot these along chromosomes in a fun package called [karyoploteR](https://bernatgel.github.io/karyoploter_tutorial/).

Important Note: The `*.sitelh` files are quite large. They could not be uploaded to Github for these scripts, but these files, for when you reach the part of the code that calls for them, are obtained through `IQ-TREE2`. 
