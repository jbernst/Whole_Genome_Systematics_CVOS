# Divergence Dating

## treePL: Divergence Date Estimation using Gene Trees

To use `treePL`, we need to get concatenated trees of our alignments because `treePL` using the number of sites in its parameter file (i.e., how many sites was the tree based off of, which is not considered in an `ASTRAL` tree because `ASTRAL-III` uses individual gene/locus trees as input).

Using the script for `catsequences` by [Chris Creevey](https://github.com/ChrisCreevey/catsequences), we can easily concatenate our `*.fastsa` files for each chromosome (and all chromosomes). First, make an input file for catsequences by running `ls *.fasta > {chrom}_algn.txt` . The name of the output file can be anything, but I like to identify it by chromosome number and calling it an alignment text file (`_algn.txt`). Than you run catsequences on this file. I ran this as a loop and changed the resulting `allseqs.fas` and `allseqs.partitions.txt` file to have the chromosome number in their name (as I had multiple chromosomes in one directory, so the names have to be changed so they do not get overwritten). Be extremely careful for chromosomes that have overlapping digits (e.g., mi1 and mi10, as these will get lumped together. This happened using the code below, so I had to manually fix mi1, which had all 95 alignments of mi10 in it, but not the other way around.

```
for i in *_algn.txt
do
name=${i%_*}
echo "Concatenating" $i
echo " "
../catsequences/catsequences ${i}
echo "Changing file names.."
mv allseqs.fas ${name}_allseqs.fas
mv allseqs.partitions.txt ${name}_allseqs.partitions.txt
echo " "
done

echo "catsequences complete :)"
```

To run `treePL` (installation is easiest using `Linuxbrew`), use the following command on the configuation file (called `config.config`):

`config.config` is as below:

```
treefile = filename [the name of the file with the newick tree to transform]
smooth = 100 [the smoothing value]
numsites = 310000193 [the number of sites in the alignment that created the tree]
mrca = RUBTROX CA0346_atro CR0001_rube [MRCA that will be used for calibrations]
min = RUBTROX 1.2 [minimum calibration with mrca name and date]
max = RUBTROX 5.2 [maximum calibration with mrca name and date]
mrca = CVOS CA0346_atro CR0001_rube [MRCA that will be used for calibrations]
min = CVOS 3.7 [minimum calibration with mrca name and date]
max = CVOS 15.5 [maximum calibration with mrca name and date]
outfile = CVOS_all_chrom_treePL.out.tre [the file that the transformed tree will be written to]
thorough [designate that you want a thorough analysis]
#prime [designate that you want to determine the best optimization parameters]
opt = integer [set the gradient based optimizer]
optad = integer [set the autodiff based optimizer]
optcvad = integer [set the autodiff cross validation based optimizer]
cv [designate that you want to do a cross validation analysis]
randomcv [designate that you want to do random sampled cross validation]
cvoutfile = CVOS_all_chrom_treePL.cv.out [designate where you want the cross validation results to be printed, default = cv.out]
cvstart = number [set where you want to start cross validation, default = 1000]
cvstop = number [set where you want to stop cross validation, default = 0.1]
nthreads = integer [number of threads]
#cviter = number [the number of cross validation total optimization iterations, default = 2]
#pliter = number [the number of penalized likelihood total optimization iterations, default = 2]
#cvsimaniter = number [the number of cross validation simulated annealing iterations, default = 5000]
#plsimaniter = number [the number of penalized likelihood simulated annealing iterations, default = 5000]
#log_pen [rate penalty will use log instead of additive function]
#seed = number [seed for random number generator, default = clock]
```

The configuration file was run using the `thorough` command to ensure it ran until convergence, and the `prime` command (just once) to get optimal parameters.

ran it with `prime` first, then commented it out, then added `cv` and `randomcv` as well. Chose one with best smoothing parameter, which will have the lowest error (so you should choose the smoothing value that has the lowest number. and the smoothing value is the one in parentheses).

To run `treePL` run:

```
treePL config.config
```

The resulting tree for this came out with dates that are ~5 million years older than previous estimates, so let's try another methods using [SNAPP](https://beast2.blogs.auckland.ac.nz/snapp/) (in [BEAST2](https://beast2.blogs.auckland.ac.nz/)).

The analysis had to be redone, so I did the following config file:

```bash
treefile = all_chrom_allseqs.SL.nohual.fas.newick.treefile 
smooth = 1000 
numsites = 310000193 
mrca = RUBTROX CA0346_atro CR0001_rube 
min = RUBTROX 1.56 
max = RUBTROX 4.84
mrca = CVOS CV0736_cali CS0027_moha 
min = CVOS 5.38 
max = CVOS 7.71
mrca = ALL CA0346_atro CS0027_moha 
min = ALL 6.4 
max = ALL 10
outfile = CVOS_all_chrom_treePL.out.tre 
thorough 
#prime 
opt = 2
optad = 2
optcvad = 5
moredetailcvad
#cv 
#randomcv 
#cvoutfile = CVOS_all_chrom_treePL.cv.out 
#cvstart = number 
#cvstop = number
#nthreads = integer 
#cviter = number
#pliter = number
#cvsimaniter = number 
#plsimaniter = number 
#log_pen
#seed = number 
```

The logic behind these were using the mean, standard deviations. and offsets of the same calibrations used in [Schield et al. (2019)](https://doi.org/10.1093/biolinnean/blz077). Then, I took the 95% confidence interval range for the minimum and maximum.

I also tried the below version (which has all result files have a "`_2`" appended to them). These are where I changed the Log Normal distribution to be the 95% HPD if we did Mean in Real Space in `BEAST2` but that means the interval is only 5 and 5.02 (I also did not specify a maximum for the MRCA).

```bash
treefile = all_chrom_allseqs.SL.nohual.fas.newick.treefile 
smooth = 1000 
numsites = 310000193 
mrca = RUBTROX CA0346_atro CR0001_rube 
min = RUBTROX 1.56 
max = RUBTROX 4.84
mrca = CVOS CV0736_cali CS0027_moha 
min = CVOS 5 
max = CVOS 5.02
mrca = ALL CA0346_atro CS0027_moha 
min = ALL 7.3 
outfile = CVOS_all_chrom_treePL_2.out.tre 
thorough 
#prime 
opt = 5
optad = 5
optcvad = 5
moredetailcvad
#cv 
#randomcv 
#cvoutfile = CVOS_all_chrom_treePL_2.cv.out 
#cvstart = number 
#cvstop = number
#nthreads = integer 
#cviter = number
#pliter = number
#cvsimaniter = number 
#plsimaniter = number 
#log_pen
#seed = number 
```
