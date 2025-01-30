# Obtaining Genome-Wide Weighted Topologies (TWISST)

This `README` is actually going to combine two different parts into a single bash script:

1. Bootstrapping the maximum likelihood (ML) trees, obtained from `RAxML-NG`
2. Running `TWISST`

### Bootstrapping the RAxML-NG Trees

The RAxML-NG directories are in These are in `/Users/a108594/Documents/CVOS_Phylogeny/Previously-run-RAxML-NG_trees/`

Starting first with a directory of:

1. RAxML-NG best tree files
2. RAxML-NG bootstrap files for all trees obtained

Created a list of the best ML tree files (these trees are the ones with no missing data [`nmd`] from Drew):

```
ls bestTrees > raxml.trees.nmd.txt
```

Convert this to a tab separated list with replacement (`%s`) in vim. Here is an example of what the `.txt` file will look like:

```
scaffold-mi9    6100000 6110000
scaffold-mi9    6130000 6140000
scaffold-mi9    6140000 6150000
```

Once you have this, you can set up the first part of the bash script to bootstrap the best trees obtained from `RAxML-NG`:

```bash
# set variables that are important for the loop (the chromosome interval and the chromosome ID)
while IFS=$'\t' read -r chrom begin int; do
# Append bootstrapped trees to best RAxML-NG tree
    raxml-ng --support --tree /Users/a108594/Documents/CVOS_Phylogeny/Previously-run-RAxML-NG_trees/bestTrees/*${chrom}*-${int}*.bestTree.tre \
        --bs-trees /Users/a108594/Documents/CVOS_Phylogeny/Previously-run-RAxML-NG_trees/bootstraps/*${chrom}*-${int}*.bootstraps \
        --prefix /Users/a108594/Documents/CVOS_Phylogeny/Previously-run-RAxML-NG_trees/bootstrapped-trees/${chrom}_$int --threads 2 #*${chrom}*-${int} #take the interval after the dash (this is what we set for interval). Place in a directory you created called bootstrapped-trees
done < raxml.trees.nmd.txt

cat bootstrapped-trees/*.support > /Users/a108594/Documents/CVOS_Phylogeny/Analyses/TWISST/all_trees.raxml.support
```

This will provide the file `all_trees.raxml.support` which contains all of the bootstrapped trees, a requirement for running `TWISST`. This will file will be
located in the directory where we will run our TWISST analysis: `/Users/a108594/Documents/CVOS_Phylogeny/Analyses/TWISST/`

### Running TWISST

To run `TWISST`, you will need a .txt file of your bootstrapped trees (which we have in the file called `all_trees.raxml.support`) and a file for grouping taxa (or, alternatively, just list them like we will do below).
Each group, which is used when you have multiple individuals for a particular taxon/group, needs to get its own `-g` flag, followed by the name of the Group and finally the taxa within it (as named in your trees),
separated by commas. It will also need two output directories that you must create for the output topologies and output weights using `-outputTopos` and `-w` respectively. We will use the `complete` algorithm as
recommended by the documentation. Note, I have added the first two lines to indicate that if `output-weights` and `output-topologies` do not exist, then `(&&)` create them.

```bash
if [ ! -d  output-weights ]; then mkdir  output-weights #if output-weights and output-topologies do not exist, then create them
fi
if [ ! -d  output-topologies ]; then mkdir  output-topologies
fi
nano
python twisst.py -t all_trees_nohual.UFB.support -w output-weights/all_trees.output.nohual.weights.csv.gz \
    --outputTopos output-topologies/all_trees.output.nohual.topologies.trees --method complete --outgroup Outgroup \
    -g Outgroup CA0346_atro,CR0001_rube \
    -g Sscutulatus CS0143_cent,CS0142_cent,CS0237_chih,CS0029_chih,CS0153_moha,CS0027_moha,CS0146_salv,CS0148_salv \
    -g Vviridis CV0018_vir2,CV0008_vir1,CV0648_vir1,CV0631_vir2,CV0075_nunt,CV0756_nunt \
    -g Ooreganus CV0716_cerb,CV0755_cerb,CV0711_conc,CV0040_conc,CV0067_luto,CV0203_luto,CV0721_abys,CV0719_abys,CV0136_ore2,CV0086_ore1,CV0147_ore1,CV0094_ore2,CV0053_hell,CV0054_hell,CV0732_cali,CV0736_cali

#make a data frame without the headers from twisst 
cd output-weights
gunzip all_trees.output.nohual.weights.csv.gz
grep '^[0-9]' all_trees.output.nohual.weights.csv > all_trees.output.nohual.weights_noheader.csv
gzip all_trees.output.nohual.weights.csv

```

This script will give you your weighted topologist, which you can then analyze using [R code](https://github.com/simonhmartin/twisst/blob/master/plot_twisst.R) from `TWISST` documentation.

 [ !So, below will be the full script which will do Parts 1 and 2 of this README:

```bash
# set variables that are important for the loop (the chromosome interval and the chromosome ID)
while IFS=$'\t' read -r chrom begin int; do
# Append bootstrapped trees to best RAxML-NG tree
    raxml-ng --support --tree /Users/a108594/Documents/CVOS_Phylogeny/Previously-run-RAxML-NG_trees/bestTrees/*${chrom}*-${int}*.bestTree.tre \
        --bs-trees /Users/a108594/Documents/CVOS_Phylogeny/Previously-run-RAxML-NG_trees/bootstraps/*${chrom}*-${int}*.bootstraps \
        --prefix /Users/a108594/Documents/CVOS_Phylogeny/Previously-run-RAxML-NG_trees/bootstrapped-trees/${chrom}_$int --threads 2 #*${chrom}*-${int} #take the interval after the dash (this is what we set for interval). #Place in a directory you created called bootstrapped-trees
done < raxml.trees.nmd.txt

cat bootstrapped-trees/*.support > /Users/a108594/Documents/CVOS_Phylogeny/Analyses/TWISST/all_trees.raxml.support

if [ ! -d  output-weights ]; then mkdir  output-weights #if output-weights and output-topologies do not exist, then create them
fi
if [ ! -d  output-topologies ]; then mkdir  output-topologies
fi
python twisst.py -t all_trees.raxml.support -w output-weights/all_trees.output.weights.csv.gz \
    --outputTopos output-topologies/all_trees.output.topologies.trees --method complete \
    -g Outgroup CA0346_atro,CR0001_rube \
    -g Sscutulatus CS0143_cent,CS0142_cent,CS0237_chih,CS0029_chih,CS0153_moha,CS0027_moha,CS0146_salv,CS0148_salv \
    -g Vviridis CV0018_vir2,CV0008_vir1,CV0648_vir1,CV0631_vir2,CV0075_nunt,CV0756_nunt \
    -g Ooreganus CV0716_cerb,CV0755_cerb,CV0703_hual,CV0725_hual,CV0711_conc,CV0040_conc,CV0067_luto,CV0203_luto,CV0721_abys,CV0719_abys,CV0136_ore2,CV0086_ore1,CV0147_ore1,CV0094_ore2,CV0053_hell,CV0054_hell,CV0732_cali,CV0736_cali

#make a data frame without the headers from twisst 
cd output-weights
gunzip all_trees.output.weights.csv.gz
grep '^[0-9]' all_trees.output.weights.csv > all_trees.output.weights_noheader.csv
gzip all_trees.output.weights.csv

```

Note: had to add use vim to edit a new file to create a file for smoothing. Part of the smoothing process in `TWISST` that we created requires us to make a file called `topology-weights_all-regions.csv` so we can establish an easier way to visualize the trees. To do this, I combined two files I made:

1. A file that takes our weight columns from thw `TWISST` output and exports them without the topology lines (this is what the last few lines of the code does, which is not part of the loop). This is called `all_trees.output-weights_noheader.csv`.
2. A file called `chrom_end.txt`. This was made by running an `ls` command on the directory with the bootstrapped trees and appending the results to a `check.txt` file. Than I used vim to edit `check.txt` file to remove the `.raxml.support` extension from the file list and add a tab between the chromosome name and the chromosome end number: so we replace the `_` with a `/t` in vim. I saved this to a file called `chrom_end.txt`.
3. Once you have these files, you can merge them using `paste chrom_end.txt all_trees.output-weights_noheader.csv` to have a single file that gives the weights of each tree with an identifying chromosome and window end base pair. This is our `topology-weights_all-regions.csv` file.

To do this for particular trees you are looking for, you will need to extract out the specific topologies you want from the `all_trees.output.topologies.trees` file in the `output-topologies` directory. Fortunately, the topologies are labeled in consecutive order, so just find the line number that corresponds to the newick tree you want to extract, and extract that column number from the `all_trees.output-weights_noheader.csv`. I did this for the Great Basin Rattlesnakes to see what the frequency *C. concolor*, *C. lutosus*, and *C. abyssus* relationships was. I extracted out topologies 16, 17, and 18 from the `all_trees.output.weights_noheader_scheme8.`csv file (a different run of `TWISST` I did) using `awk -F'\t' -v OFS='\t' '{print $16, $17, $18}' all_trees.output.weights_noheader_scheme8.csv > all_trees.output.weights_noheader_scheme8_GBR.csv` (because `cut` was not recognizing the tabs as delimited for some reason). Then you can continue with the `paste` command with `chrom_end.txt`.

Plotting these topologies and their weights can be a bit tedious, but fortunately there are two ways to do this, of which is using R sciprts from the authors of `Twisst`. These can be a a bit lengthy, but all code for plotting the weights using `TWISST`-provided R code or my own custom scripts to creates circos plots are on my [GitHub](https://github.com/jbernst).
