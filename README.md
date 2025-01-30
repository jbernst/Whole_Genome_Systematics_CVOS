# Whole_Genome_Systematics_CVOS
This repository contains pipelines and analyses for disentangling conflicting evolutionary histories from whole genomes using _Crotalus_ rattlesnakes. 

## Data and Sampling
Whole genome data can be found on the [Sequence Read Archive (SRA)](https://www.ncbi.nlm.nih.gov/sra) under Projects PRJNA1150930 and PRJNA1137891. Specific sampling information can also be found on the SRA, or in [Supplementary Table S1](Supplemental_Tables).

## Code and Analyses
This project (accepted in _Molecular Phylogenetics and Evolution_) involves a suite of analyses for identifying biological processes that are correlated with alternative topologies in systematic efforts. A README file for **all** analyses in bash is provided in the [MASTER_CVOS-WGS_Workflow.md file](MASTER_CVOS-WGS_Workflow.md). This will contain a tutorial for the analytical workflow for the entire project. However, below I will subset this into different phases of the project:

### Sampling, Genomic Data Processing, and Alignment Generation
* Information on our sampling scheme, whoe genome data processing and cleaning, and alignment creation and filtering can be found here: [Sampling-Genome-Processing.md](Sampling-Genome-Processing.md).

### Phylogenetic Analyses
```
               ---------- FUN!
     ---------|
    |          ---------- FUN!
----|1.0
    |         ----------- FUN!
     --------|
              ----------- FUN!
```
With our genomic datasets, we perform various phylogenetic analyses. These will include: 
* Maximum Likelihood analysis of 10 kb genomic windows was run using [bash scripts](Phylogenetic-Analyses/MaximumLikelihood.md)
* Testing for phylogenetic reticulations was performed using PhyloNet and NANUQ in custom [bash and shell scripts](Phylogenetic-Analyses/ReticulationAnalyses.md).
* Divergence Dating analyses using TreePL can be found [here](Phylogenetic-Analyses/DivergenceDating.md). For species tree (coalescent) analysis, [ASTRAL-III](https://github.com/smirarab/ASTRAL) was used.
* Topology weighting was done using the software TWISST in a [custom pipeline](Phylogenetic-Analyses/TopologyWeighting.md).

### Site Specific Likelihood (SSL) Analysis
* To determine support for the species vs. alternative topologies at a site-by-site and genomic window basis using our whole genomes, we performed site likehood analysis in `IQTREE2` and then used [custom scripts](Site-Likelihood-Analysis/SSL.md) for further analysis and visualization.

### Analysis of Tree Space and Tree Distances
* Two methods were used for identifying similarity of trees in Tree Space. The first was using Probabilistic Species Tree Distances (PSTD) using [custom R scripts]().
