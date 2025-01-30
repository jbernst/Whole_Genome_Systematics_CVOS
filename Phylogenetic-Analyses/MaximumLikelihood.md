# Maximum Likelihood Tree Reconstruction (IQ-TREE2)

Maximum likelihood inference was performed using `iqtree2` [version 2.1.2](http://www.iqtree.org/release/v1.2.2/). For all analyses, we used 1000 ultrafast bootstraps (UFB; using the `-bb` flag). We could use Shimodaira-Hasegawa approximate likelihood tests, but we will skip that since we are running a lot computationally (~31,000 trees). The trees will be from 10kb alignments from macrochromosomes, microchromosomes, and the Z chromosomes that pass the missing data criteria for a mean of 35% and max. of 60%.

With a list of *.fasta alignments in a directory called `chromosome`, I set a loop to iteratively run `iqtree2`, searching for the best partition scheme and evolutionary model for each alignment:

```
for i in m*
do
iqtree2 -s $i -bb 1000 -nt AUTO
done
```

The outputs have the prefix of the genomic windows (the filenames other than the .fasta extension). The files ending in `*.treefile` will have the observable ultrafast bootstraps at nodes.

When I ran the tree for `PhyloNet` (below) I did not run them with the bootstraps. For this, I used the same command above, but ran it as a loop so that each StarBeast server ran 20 trees at once:

```
N=20                                                        # number of jobs to run in parallel
for i in *.fasta; do
                (
                ./iqtree2 -s $i -bb 1000 -nt AUTO                    # Command to run; the parentheses and ampersand run this in the background, allowing for parallel execution
                ) &
if [[ $(jobs -r -p | wc -l) -ge $N ]]; then # check if the number of jobs is lower than N
                                wait -n                     # wait that a job finishes
        fi
done
wait                                                        # wait that all job finish before continuing with the script.
```

The above script was also modified for the StarBeast servers with 8 cores, to run 8 jobs at once in parallel. This script also takes into account that if a final file (the `*.treefile`) already exists for an alignment, then just skip it. We also will add in the option to obtain ultrafast bootstraps.

```
N=8 # number of jobs to run in parallel
for i in *.fasta; do
        if [  ! -f ${i}.treefile ]; then. #This line ensures that iqtree runs only if an alignment doesn't have a *.treefile
                (
                ./iqtree2 -s $i -nt AUTO  
                ) &
        else echo "$i exists, skipping"
        fi
if [[ $(jobs -r -p | wc -l) -ge $N ]]; then 
                                wait -n 
        fi
done
wait #wait that all job finish before continuing with the script.
```
