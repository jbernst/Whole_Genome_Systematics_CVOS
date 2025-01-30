# Sampling

This section of the `README` file contains details about the data processing and analysis for our whole
genome phylogeny for the western rattlesnake species complex. This `README` file was created by Drew Schield.

We chose 34 samples total to use for whole genome sequencing, including two represenatives of each of the major CVOS lineages (2 lineages each for *viridis* group and *oreganus* group), and *C. atrox*
and *C. ruber* as outgroups. We did not include *C. oreganus hualapaiensis* here.

All samples were prepped using either Kapa HyperPlus or Illumina Flex kits and sequenced
on an Illumina NovaSeq 6000 at the North Texas Genome Center (NTGC) )using 150 bp paired end reads.
Samples were either sequenced as part of the May 2018 sequencing run, or the May 2019 sequencing
run.

We targeted ~ 20x coverage per sample, and there was quite a bit of variation in overall coverage (see below).

The sampling for this project is:

| Sample_ID | Collector_ID      | Genus    | Species    | Subspecies | Country | State           | County     | Latitude  | Longitude    |
| --------- | ----------------- | -------- | ---------- | ---------- | ------- | --------------- | ---------- | --------- | ------------ |
| CA0346    | CAS_229233        | Crotalus | atrox      | -          | USA     | New_Mexico      | San_Miguel | 35.33193  | -104.0571694 |
| CR0001    | CAS_223514        | Crotalus | ruber      | -          | USA     | California      | Imperial   | 33.1015   | -116.4653333 |
| CS0153    | PFS0265-FTB01868  | Crotalus | scutulatus | scutulatus | USA     | AZ              | Greenlee   | 32.76791  | -109.14928   |
| CS0027    | NTRC926           | Crotalus | scutulatus | scutulatus | USA     | AZ              | Pima       | 31.51524  | -110.59236   |
| CS0237    | DRS379            | Crotalus | scutulatus | scutulatus | USA     | Texas           | Jeff Davis | 30.562    | -104.280     |
| CS0029    | NTRC345           | Crotalus | scutulatus | scutulatus | USA     | Texas           | Culberson  | 31.267    | -104.843     |
| CS0142    | NMB_037           | Crotalus | scutulatus | scutulatus | Mexico  | Aguascalientes  | -          | 22.26025  | -102.1769    |
| CS0143    | NMB_038           | Crotalus | scutulatus | scutulatus | Mexico  | Aguascalientes  | -          | 22.26107  | -102.17521   |
| CS0146    | OFV_1124          | Crotalus | scutulatus | salvini    | Mexico  | Puebla          | -          | 19.261495 | -97.531133   |
| CS0148    | CLS_868           | Crotalus | scutulatus | salvini    | Mexico  | Puebla          | -          | 18.73796  | -98.32419    |
| CV0721    | DD3               | Crotalus | oreganus   | abyssus    | USA     | Arizona         | Coconino   | 36.840008 | -111.593996  |
| CV0719    | DD1               | Crotalus | oreganus   | abyssus    | USA     | Arizona         | Coconino   | 36.840008 | -111.593996  |
| CV0736    | 081815RWCA        | Crotalus | oreganus   | caliginis  | Mexico  | Baja_California | -          | 32.41193  | -117.24457   |
| CV0732    | 050115RWCB        | Crotalus | oreganus   | caliginis  | Mexico  | Baja_California | -          | 32.40163  | -117.24311   |
| CV0755    | CLP_1942          | Crotalus | oreganus   | cerberus   | USA     | Arizona         | Pima       | 32.30317  | -110.59197   |
| CV0716    | BLF8              | Crotalus | oreganus   | cerberus   | USA     | Arizona         | Pima       | 32.160009 | -110.513091  |
| CV0711    | BLF3              | Crotalus | oreganus   | concolor   | USA     | Utah            | Wayne      | 38.311    | -111.438     |
| CV0040    | CAS_170462        | Crotalus | oreganus   | concolor   | USA     | Utah            | Uintah     | 40.36952  | -109.3349    |
| CV0053    | CAS_228044        | Crotalus | oreganus   | helleri    | USA     | California      | San_Diego  | 32.693056 | -116.3611111 |
| CV0054    | CAS_228048        | Crotalus | oreganus   | helleri    | USA     | California      | San_Diego_ | 32.813889 | -117.2433333 |
| CV0203    | CAS_223558        | Crotalus | oreganus   | lutosus    | USA     | Nevada          | Lander_    | 40.547    | -117.0463333 |
| CV0067    | CAS_202965        | Crotalus | oreganus   | lutosus    | USA     | Nevada          | Washoe_    | 41.523639 | -119.4570833 |
| CV0086    | CAS_205205        | Crotalus | oreganus   | oreganus   | USA     | California      | Butte_     | 39.443111 | -121.4086667 |
| CV0147    | CAS_234623        | Crotalus | oreganus   | oreganus   | USA     | California      | Butte_     | 39.731111 | -121.5014444 |
| CV0094    | CAS_208761        | Crotalus | oreganus   | oreganus   | USA     | California      | Fresno     | 37.023639 | -119.3425278 |
| CV0136    | CAS_224859        | Crotalus | oreganus   | oreganus   | USA     | California      | Fresno     | 36.846806 | -119.0955    |
| CV0756    | CLP_1817          | Crotalus | viridis    | nuntius    | USA     | Arizona         | Coconino   | 35.05765  | -111.03354   |
| CV0075    | CAS_170509        | Crotalus | viridis    | nuntius    | USA     | Arizona         | Coconino   | 35.181455 | -110.929985  |
| CV0008    | SPM-W09002        | Crotalus | viridis    | viridis    | USA     | Colorado        | Weld       | 40.31     | -104.28      |
| CV0648    | DRS225            | Crotalus | viridis    | viridis    | USA     | Colorado        | Weld       | 40.31     | -104.28      |
| CV0018    | SPM-317           | Crotalus | viridis    | viridis    | USA     | New_Mexico      | Luna       | 33.51     | -108.56      |
| CV0631    | DRS211            | Crotalus | viridis    | viridis    | USA     | New_Mexico      | Socorro    | 34.079841 | -107.407005  |

The samples that were sequenced in May 2018 have already been mapped and their variants
have been called. Unless noted, the following workflows are for the May 2019 samples.

1. Read mapping & file processing
2. HaplotypeCaller to generate gVCFs

# Mapping to the *C. viridis* genome

We will trim and alig reads to the CroVir3.0 reference genome of *Crotalus viridis* ([Schield et al. 2019](http://www.genome.org/cgi/doi/10.1101/gr.240952.118)).

Set up variant calling pipeline directories:
--------------------------------------------

```bash
mkdir _fastq
mkdir _bam
mkdir _variants
```

## Generated an index for the viridis reference genome:

```bash
bwa index CroVir_genome_L77pg_16Aug2017.final_rename.fasta
```

Mapped to viridis reference genome:
-----------------------------------

```bash
map_05-2019_CVOS.sh
```

Samples sequenced on NTGC NovaSeq May, 2019

```bash
#!/bin/bash
bwa mem -t 32 -R "@RG\tID:CS0237\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CS0237" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CS0237_S1_L002_R1_001.fastq.gz ./_fastq/CS0237_S1_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CS0237.bam -
bwa mem -t 32 -R "@RG\tID:CV0040\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0040" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0040_S1_L003_R1_001.fastq.gz ./_fastq/CV0040_S1_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0040.bam -
bwa mem -t 32 -R "@RG\tID:CV0190\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0190" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0190_S2_L003_R1_001.fastq.gz ./_fastq/CV0190_S2_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0190.bam -
bwa mem -t 32 -R "@RG\tID:CV0191\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0191" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0191_S3_L003_R1_001.fastq.gz ./_fastq/CV0191_S3_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0191.bam -
bwa mem -t 32 -R "@RG\tID:CV0202\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0202" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0202_S4_L003_R1_001.fastq.gz ./_fastq/CV0202_S4_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0202.bam -
bwa mem -t 32 -R "@RG\tID:CV0203\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0203" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0203_S5_L003_R1_001.fastq.gz ./_fastq/CV0203_S5_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0203.bam -
bwa mem -t 32 -R "@RG\tID:CV0600\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0600" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0600_S7_L003_R1_001.fastq.gz ./_fastq/CV0600_S7_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0600.bam -
bwa mem -t 32 -R "@RG\tID:CV0602\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0602" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0602_S8_L003_R1_001.fastq.gz ./_fastq/CV0602_S8_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0602.bam -
bwa mem -t 32 -R "@RG\tID:CV0618\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0618" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0618_S9_L003_R1_001.fastq.gz ./_fastq/CV0618_S9_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0618.bam -
bwa mem -t 32 -R "@RG\tID:CV0623\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0623" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0623_S10_L003_R1_001.fastq.gz ./_fastq/CV0623_S10_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0623.bam -
bwa mem -t 32 -R "@RG\tID:CV0656\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0656" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0656_S11_L003_R1_001.fastq.gz ./_fastq/CV0656_S11_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0656.bam -
bwa mem -t 32 -R "@RG\tID:CV0659\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0659" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0659_S2_L002_R1_001.fastq.gz ./_fastq/CV0659_S2_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0659.bam -
bwa mem -t 32 -R "@RG\tID:CV0672\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0672" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0672_S12_L003_R1_001.fastq.gz ./_fastq/CV0672_S12_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0672.bam -
bwa mem -t 32 -R "@RG\tID:CV0673\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0673" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0673_S13_L003_R1_001.fastq.gz ./_fastq/CV0673_S13_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0673.bam -
bwa mem -t 32 -R "@RG\tID:CV0674\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0674" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0674_S14_L003_R1_001.fastq.gz ./_fastq/CV0674_S14_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0674.bam -
bwa mem -t 32 -R "@RG\tID:CV0697\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0697" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0697_S15_L003_R1_001.fastq.gz ./_fastq/CV0697_S15_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0697.bam -
bwa mem -t 32 -R "@RG\tID:CV0699\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0699" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0699_S16_L003_R1_001.fastq.gz ./_fastq/CV0699_S16_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0699.bam -
bwa mem -t 32 -R "@RG\tID:CV0701\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0701" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0701_S3_L002_R1_001.fastq.gz ./_fastq/CV0701_S3_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0701.bam -
bwa mem -t 32 -R "@RG\tID:CV0702\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0702" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0702_S4_L002_R1_001.fastq.gz ./_fastq/CV0702_S4_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0702.bam -
bwa mem -t 32 -R "@RG\tID:CV0704\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0704" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0704_S17_L003_R1_001.fastq.gz ./_fastq/CV0704_S17_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0704.bam -
bwa mem -t 32 -R "@RG\tID:CV0706\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0706" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0706_S18_L003_R1_001.fastq.gz ./_fastq/CV0706_S18_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0706.bam -
bwa mem -t 32 -R "@RG\tID:CV0707\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0707" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0707_S6_L002_R1_001.fastq.gz ./_fastq/CV0707_S6_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0707.bam -
bwa mem -t 32 -R "@RG\tID:CV0708\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0708" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0708_S7_L002_R1_001.fastq.gz ./_fastq/CV0708_S7_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0708.bam -
bwa mem -t 32 -R "@RG\tID:CV0709\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0709" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0709_S8_L002_R1_001.fastq.gz ./_fastq/CV0709_S8_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0709.bam -
bwa mem -t 32 -R "@RG\tID:CV0711\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0711" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0711_S19_L003_R1_001.fastq.gz ./_fastq/CV0711_S19_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0711.bam -
bwa mem -t 32 -R "@RG\tID:CV0712\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0712" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0712_S9_L002_R1_001.fastq.gz ./_fastq/CV0712_S9_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0712.bam -
bwa mem -t 32 -R "@RG\tID:CV0713\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0713" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0713_S20_L003_R1_001.fastq.gz ./_fastq/CV0713_S20_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0713.bam -
bwa mem -t 32 -R "@RG\tID:CV0714\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0714" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0714_S21_L003_R1_001.fastq.gz ./_fastq/CV0714_S21_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0714.bam -
bwa mem -t 32 -R "@RG\tID:CV0715\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0715" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0715_S10_L002_R1_001.fastq.gz ./_fastq/CV0715_S10_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0715.bam -
bwa mem -t 32 -R "@RG\tID:CV0716\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0716" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0716_S22_L003_R1_001.fastq.gz ./_fastq/CV0716_S22_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0716.bam -
bwa mem -t 32 -R "@RG\tID:CV0717\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0717" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0717_S11_L002_R1_001.fastq.gz ./_fastq/CV0717_S11_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0717.bam -
bwa mem -t 32 -R "@RG\tID:CV0718\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0718" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0718_S12_L002_R1_001.fastq.gz ./_fastq/CV0718_S12_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0718.bam -
bwa mem -t 32 -R "@RG\tID:CV0719\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0719" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0719_S13_L002_R1_001.fastq.gz ./_fastq/CV0719_S13_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0719.bam -
bwa mem -t 32 -R "@RG\tID:CV0720\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0720" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0720_S14_L002_R1_001.fastq.gz ./_fastq/CV0720_S14_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0720.bam -
bwa mem -t 32 -R "@RG\tID:CV0721\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0721" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0721_S15_L002_R1_001.fastq.gz ./_fastq/CV0721_S15_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0721.bam -
bwa mem -t 32 -R "@RG\tID:CV0722\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0722" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0722_S16_L002_R1_001.fastq.gz ./_fastq/CV0722_S16_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0722.bam -
bwa mem -t 32 -R "@RG\tID:CV0724\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0724" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0724_S17_L002_R1_001.fastq.gz ./_fastq/CV0724_S17_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0724.bam -
bwa mem -t 32 -R "@RG\tID:CV0726\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0726" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0726_S19_L002_R1_001.fastq.gz ./_fastq/CV0726_S19_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0726.bam -
bwa mem -t 32 -R "@RG\tID:CV0732\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0732" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0732_S20_L002_R1_001.fastq.gz ./_fastq/CV0732_S20_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0732.bam -
bwa mem -t 32 -R "@RG\tID:CV0734\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0734" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0734_S21_L002_R1_001.fastq.gz ./_fastq/CV0734_S21_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0734.bam -
bwa mem -t 32 -R "@RG\tID:CV0735\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0735" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0735_S22_L002_R1_001.fastq.gz ./_fastq/CV0735_S22_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0735.bam -
bwa mem -t 32 -R "@RG\tID:CV0736\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0736" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0736_S23_L002_R1_001.fastq.gz ./_fastq/CV0736_S23_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0736.bam -
bwa mem -t 32 -R "@RG\tID:CV0753\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0753" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0753_S23_L003_R1_001.fastq.gz ./_fastq/CV0753_S23_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0753.bam -
bwa mem -t 32 -R "@RG\tID:CV0755\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0755" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0755_S24_L003_R1_001.fastq.gz ./_fastq/CV0755_S24_L003_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0755.bam -
bwa mem -t 32 -R "@RG\tID:CV0756\tLB:CVOS_WGS\tPL:illumina\tPU:NovaSeq6000\tSM:CV0756" CroVir_genome_L77pg_16Aug2017.final_rename.fasta ./_fastq/CV0756_S24_L002_R1_001.fastq.gz ./_fastq/CV0756_S24_L002_R2_001.fastq.gz | samtools sort -O bam -T temp -o ./_bam/CV0756.bam -
```

## Output mapping statistics files using samtools:

```bash
cd _bam
mkdir _stats
```

Example command:

```bash
samtools flagstat sample.bam > _stats/sample.flagstat.txt
```

Simple bash one-liner to do it on all samples:

```bash
for i in *.bam; do samtools flagstat $i > _stats/$i.flagstat.txt; done
cd _stats
```

## Quick check of mapping statistics (mapped reads from flagstat, number of bases mapped from stat):

This will read out the file name followed by the line containing the percent reads mapped

```bash
for i in *.flagstat.txt; do echo $i; grep 'mapped (' $i; done
```

This will read out the file name followed by the line containing number of bases mapped

```bash
for i in *.stat.txt; do echo $i; grep 'bases mapped:' $i; done
```

# Variant discovery using GATK

Generated samtools index for viridis reference genome:
------------------------------------------------------

```bash
samtools faidx CroVir_genome_L77pg_16Aug2017.final_rename.fasta
```

Generated sequence dictionary for viridis reference genome:
-----------------------------------------------------------

```bash
./gatk-4.0.8.1/gatk CreateSequenceDictionary -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta
```

Indexed mapping files using a shell script:
-------------------------------------------

Can use a bash file called `index_bams.sh that will do the following:`

```bash
for i in _bam/*.bam; do
	samtools index $i
done
```

Cam run the following to execute the bash file:

```bash
sh index_bams.sh
```

Generated genomic VCF per sample using GATK HaplotypeCaller:
------------------------------------------------------------

We can use `nohup` to run processes in the background so that scripts keep running even if you log out or close out of th terminal. Samples to be used in the whole genome phylogeny were prioritized:

```bash
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CS0237.bam -O _gvcf/CS0237.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CS0237.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0040.bam -O _gvcf/CV0040.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0040.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0203.bam -O _gvcf/CV0203.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0203.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0711.bam -O _gvcf/CV0711.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0711.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0716.bam -O _gvcf/CV0716.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0716.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0719.bam -O _gvcf/CV0719.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0719.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0721.bam -O _gvcf/CV0721.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0721.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0732.bam -O _gvcf/CV0732.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0732.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0736.bam -O _gvcf/CV0736.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0736.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0755.bam -O _gvcf/CV0755.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0755.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0756.bam -O _gvcf/CV0756.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0756.log
```

Then, 6 mexico scutulatus

```bash
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CS0142.bam -O _gvcf/CS0142.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CS0142.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CS0143.bam -O _gvcf/CS0143.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CS0143.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CS0146.bam -O _gvcf/CS0146.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CS0146.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CS0148.bam -O _gvcf/CS0148.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CS0148.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CS0224.bam -O _gvcf/CS0224.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CS0224.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CS0225.bam -O _gvcf/CS0225.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CS0225.log
```

Remaining samples from May 2019:

```bash
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0190.bam -O _gvcf/CV0190.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0190.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0191.bam -O _gvcf/CV0191.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0191.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0202.bam -O _gvcf/CV0202.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0202.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0600.bam -O _gvcf/CV0600.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0600.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0602.bam -O _gvcf/CV0602.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0602.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0618.bam -O _gvcf/CV0618.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0618.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0623.bam -O _gvcf/CV0623.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0623.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0656.bam -O _gvcf/CV0656.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0656.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0659.bam -O _gvcf/CV0659.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0659.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0672.bam -O _gvcf/CV0672.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0672.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0673.bam -O _gvcf/CV0673.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0673.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0674.bam -O _gvcf/CV0674.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0674.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0697.bam -O _gvcf/CV0697.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0697.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0699.bam -O _gvcf/CV0699.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0699.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0701.bam -O _gvcf/CV0701.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0701.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0702.bam -O _gvcf/CV0702.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0702.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0704.bam -O _gvcf/CV0704.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0704.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0706.bam -O _gvcf/CV0706.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0706.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0707.bam -O _gvcf/CV0707.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0707.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0708.bam -O _gvcf/CV0708.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0708.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0709.bam -O _gvcf/CV0709.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0709.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0712.bam -O _gvcf/CV0712.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0712.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0713.bam -O _gvcf/CV0713.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0713.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0714.bam -O _gvcf/CV0714.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0714.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0715.bam -O _gvcf/CV0715.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0715.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0717.bam -O _gvcf/CV0717.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0717.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0718.bam -O _gvcf/CV0718.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0718.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0720.bam -O _gvcf/CV0720.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0720.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0722.bam -O _gvcf/CV0722.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0722.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0724.bam -O _gvcf/CV0724.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0724.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0726.bam -O _gvcf/CV0726.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0726.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0734.bam -O _gvcf/CV0734.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0734.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0735.bam -O _gvcf/CV0735.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0735.log
nohup ./gatk-4.0.8.1/gatk HaplotypeCaller -R CroVir_genome_L77pg_16Aug2017.final_rename.fasta --ERC GVCF -I _bam/CV0753.bam -O _gvcf/CV0753.raw.snps.indels.g.vcf > _gvcf/haplotypecaller.CV0753.log
```

# Renaming May 2018 GVCF files

Samples sequenced and processed in May 2018 were done so on Basespace, since we had access to unlimited compute and storage. We used the Dragen germline variant caller to generate per sample GVCFs. Because of a bunch of weird sample labeling things at the NTGC, and because the word 'trim' was appended to samples that were quality trimmed using Basespace fastq toolkit, samples do not all follow the correct naming convention, and need to be relabeled.

For example, the GVCF for CS0029 is `CS0029trim.gvcf.gz`.

We want all samples to fit this format:  `CXXXXX.raw.snps.indels.g.vcf.gz`

Several of the samples failed (i.e., had too few reads), but to keep better track, we can run them through the following pipeline, then move them to a subdirectory called
`2018_May_FAILED`, so that they don't get in the way.

Renamed and relabeled GVCF using RenameSampleInVcf by GATK:
-----------------------------------------------------------

```bash
cd _variants/2018_dragen_gvcfs/
```

Run a bash file `rename_2018-05_CVOS_GVCFs.sh` that contains the following:

```bash
##Samples sequenced on NTGC NovaSeq May, 2018 and GVCFs generated with Dragen; GVCFs needed renaming/relabeling
#!/bin/bash
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I Atroxtrim.gvcf.gz -O CA0346.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CA0346
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I ATTCAGAA-GTACTGACtrim.gvcf.gz -O CV0075.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0075
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CS0029trim.gvcf.gz -O CS0029.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CS0029
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0004trim.gvcf.gz -O CV0004.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0004
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0006trim.gvcf.gz -O CV0006.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0006
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0008trim.gvcf.gz -O CV0008.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0008
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0009trim.gvcf.gz -O CV0009.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0009
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0015trim.gvcf.gz -O CV0015.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0015
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0016trim.gvcf.gz -O CV0016.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0016
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0022trim.gvcf.gz -O CV0022.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0022
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0023trim.gvcf.gz -O CV0023.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0023
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0025trim.gvcf.gz -O CV0025.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0025
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0027trim.gvcf.gz -O CV0027.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0027
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0035trim.gvcf.gz -O CV0035.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0035
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0039trim.gvcf.gz -O CV0039.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0039
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0043trim.gvcf.gz -O CV0043.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0043
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0047trim.gvcf.gz -O CV0047.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0047
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0053trim.gvcf.gz -O CV0053.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0053
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0056trim.gvcf.gz -O CV0056.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0056
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0067trim.gvcf.gz -O CV0067.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0067
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0071trim.gvcf.gz -O CV0071.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0071
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0072trim.gvcf.gz -O CV0072.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0072
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0073trim.gvcf.gz -O CV0073.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0073
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0077trim.gvcf.gz -O CV0077.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0077
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0083trim.gvcf.gz -O CV0083.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0083
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0085trim.gvcf.gz -O CV0085.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0085
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0086trim.gvcf.gz -O CV0086.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0086
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0087trim.gvcf.gz -O CV0087.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0087
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0089trim.gvcf.gz -O CV0089.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0089
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0092trim.gvcf.gz -O CV0092.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0092
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0093trim.gvcf.gz -O CV0093.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0093
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0094trim.gvcf.gz -O CV0094.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0094
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0095trim.gvcf.gz -O CV0095.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0095
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0096trim.gvcf.gz -O CV0096.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0096
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0098trim.gvcf.gz -O CV0098.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0098
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0101trim.gvcf.gz -O CV0101.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0101
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0105trim.gvcf.gz -O CV0105.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0105
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0111trim.gvcf.gz -O CV0111.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0111
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0135trim.gvcf.gz -O CV0135.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0135
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0136trim.gvcf.gz -O CV0136.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0136
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0137trim.gvcf.gz -O CV0137.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0137
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0141trim.gvcf.gz -O CV0141.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0141
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0144trim.gvcf.gz -O CV0144.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0144
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0145trim.gvcf.gz -O CV0145.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0145
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0147trim.gvcf.gz -O CV0147.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0147
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0148trim.gvcf.gz -O CV0148.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0148
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0150trim.gvcf.gz -O CV0150.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0150
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0151trim.gvcf.gz -O CV0151.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0151
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0152trim.gvcf.gz -O CV0152.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0152
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0153trim.gvcf.gz -O CV0153.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0153
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0155trim.gvcf.gz -O CV0155.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0155
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0157trim.gvcf.gz -O CV0157.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0157
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0159trim.gvcf.gz -O CV0159.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0159
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0160trim.gvcf.gz -O CV0160.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0160
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0161trim.gvcf.gz -O CV0161.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0161
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0162trim.gvcf.gz -O CV0162.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0162
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0309trim.gvcf.gz -O CV0309.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0309
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0619trim.gvcf.gz -O CV0619.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0619
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0621trim.gvcf.gz -O CV0621.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0621
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0622trim.gvcf.gz -O CV0622.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0622
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0624trim.gvcf.gz -O CV0624.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0624
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0625trim.gvcf.gz -O CV0625.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0625
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0626trim.gvcf.gz -O CV0626.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0626
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0627trim.gvcf.gz -O CV0627.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0627
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0628trim.gvcf.gz -O CV0628.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0628
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0629trim.gvcf.gz -O CV0629.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0629
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0630trim.gvcf.gz -O CV0630.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0630
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0631trim.gvcf.gz -O CV0631.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0631
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0632trim.gvcf.gz -O CV0632.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0632
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0634trim.gvcf.gz -O CV0634.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0634
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0635trim.gvcf.gz -O CV0635.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0635
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0636trim.gvcf.gz -O CV0636.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0636
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0638trim.gvcf.gz -O CV0638.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0638
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0639trim.gvcf.gz -O CV0639.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0639
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0641trim.gvcf.gz -O CV0641.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0641
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0642trim.gvcf.gz -O CV0642.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0642
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0643trim.gvcf.gz -O CV0643.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0643
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0646trim.gvcf.gz -O CV0646.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0646
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0648trim.gvcf.gz -O CV0648.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0648
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0649trim.gvcf.gz -O CV0649.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0649
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I CV0650trim.gvcf.gz -O CV0650.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0650
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I GAATTCGT-ATAGAGGCtrim.gvcf.gz -O CS0027.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CS0027
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I GAATTCGT-CCTATCCTtrim.gvcf.gz -O CV0620.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0620
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I GAATTCGT-TATAGCCTtrim.gvcf.gz -O CV0018.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0018
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I GAGATTCC-AGGCGAAGtrim.gvcf.gz -O CV0128.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0128
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I GAGATTCC-ATAGAGGCtrim.gvcf.gz -O CV0012.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0012
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I GAGATTCC-CAGGACGTtrim.gvcf.gz -O CV0054.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0054
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I GAGATTCC-CCTATCCTtrim.gvcf.gz -O CV0013.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0013
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I GAGATTCC-GGCTCTGAtrim.gvcf.gz -O CV0308.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0308
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I GAGATTCC-TAATCTTAtrim.gvcf.gz -O CV0055.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0055
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I GAGATTCC-TATAGCCTtrim.gvcf.gz -O CV0010.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0010
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I Oreganus2trim.gvcf.gz -O CS0236.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CS0236
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I Ruber1trim.gvcf.gz -O CR0001.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CR0001
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I Ruber2trim.gvcf.gz -O CR0002.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CR0002
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I Ruber3trim.gvcf.gz -O CR0003.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CR0003
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I TCCGCGAA-AGGCGAAGtrim.gvcf.gz -O CV0127.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0127
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I TCCGCGAA-CAGGACGTtrim.gvcf.gz -O CV0007.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0007
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I TCCGCGAA-CCTATCCTtrim.gvcf.gz -O CS0153.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CS0153
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I TCCGCGAA-GTACTGACtrim.gvcf.gz -O CV0005.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0005
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I TCCGCGAA-TAATCTTAtrim.gvcf.gz -O CV0011.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0011
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I TCCGGAGA-AGGCGAAGtrim.gvcf.gz -O CV0045.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0045
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I TCCGGAGA-CAGGACGTtrim.gvcf.gz -O CV0074.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0074
../../gatk-4.0.8.1/gatk RenameSampleInVcf -I TCCGGAGA-TAATCTTAtrim.gvcf.gz -O CV0040.raw.snps.indels.g.vcf --NEW_SAMPLE_NAME CV0040
```

Cleaned up previous GVCFs that were renamed:
--------------------------------------------

This is the file extension for the OLD GVCFs!!

```bash
rm *.gvcf.gz
```

This is the file extension for the OLD GVCF INDEXES!!

```bash
rm *.gvcf.gz.tbi
```

Bgzipped and tabix indexed renamed GVCFs:
-----------------------------------------

Have a bash file `bgzip_index_GVCFs.sh which contains:`

```bash
#!/bin/bash
for i in *.g.vcf; do
	echo 'compressing and indexing $i'
	bgzip -c i > i>i.gz
	tabix -p vcf $i.gz
done
```

Execute this by running the following:

```bash
sh bgzip_index_GVCFs.sh
```

Now the GVCFs are ready for further analysis!

Removed uncompressed renamed GVCFs to save disk space:
------------------------------------------------------

```bash
rm *.g.vcf
```

Moved 'failed' compressed GVCFs so they are out of the way:
-----------------------------------------------------------

```bash
mv CV0040.raw.snps.indels.g.vcf.gz 2018_May_FAILED
mv CV0074.raw.snps.indels.g.vcf.gz 2018_May_FAILED
mv CV0045.raw.snps.indels.g.vcf.gz 2018_May_FAILED
mv CV0308.raw.snps.indels.g.vcf.gz 2018_May_FAILED
mv CV0012.raw.snps.indels.g.vcf.gz 2018_May_FAILED
mv CV0128.raw.snps.indels.g.vcf.gz 2018_May_FAILED
mv CV0649.raw.snps.indels.g.vcf.gz 2018_May_FAILED
mv CV0638.raw.snps.indels.g.vcf.gz 2018_May_FAILED
```

# Multi-sample variant calling with GATK GenotypeGVCFs

After all variant calling and file processing (see above steps for GVCFs), run GATK GenotypeGVCFs on all 32 samples included in the sampling design for the WGS phylogeny paper.

Formatted list file of path to all GVCFs to analyze:
----------------------------------------------------

Make a file containing all samples

```bash
cd /CVOS/_vcf/
touch sample.gvcf.list
```

Note, the `sample.gvcf.list contains the following:`

```
../_gvcf/CA0346.raw.snps.indels.g.vcf.gz
../_gvcf/CR0001.raw.snps.indels.g.vcf.gz
../_gvcf/CS0153.raw.snps.indels.g.vcf.gz
../_gvcf/CS0027.raw.snps.indels.g.vcf.gz
../_gvcf/CS0237.raw.snps.indels.g.vcf.gz
../_gvcf/CS0029.raw.snps.indels.g.vcf.gz
../_gvcf/CS0142.raw.snps.indels.g.vcf.gz
../_gvcf/CS0143.raw.snps.indels.g.vcf.gz
../_gvcf/CS0146.raw.snps.indels.g.vcf.gz
../_gvcf/CS0148.raw.snps.indels.g.vcf.gz
../_gvcf/CV0721.raw.snps.indels.g.vcf.gz
../_gvcf/CV0719.raw.snps.indels.g.vcf.gz
../_gvcf/CV0736.raw.snps.indels.g.vcf.gz
../_gvcf/CV0732.raw.snps.indels.g.vcf.gz
../_gvcf/CV0755.raw.snps.indels.g.vcf.gz
../_gvcf/CV0716.raw.snps.indels.g.vcf.gz
../_gvcf/CV0040.raw.snps.indels.g.vcf.gz
../_gvcf/CV0711.raw.snps.indels.g.vcf.gz
../_gvcf/CV0053.raw.snps.indels.g.vcf.gz
../_gvcf/CV0054.raw.snps.indels.g.vcf.gz
../_gvcf/CV0203.raw.snps.indels.g.vcf.gz
../_gvcf/CV0067.raw.snps.indels.g.vcf.gz
../_gvcf/CV0086.raw.snps.indels.g.vcf.gz
../_gvcf/CV0147.raw.snps.indels.g.vcf.gz
../_gvcf/CV0094.raw.snps.indels.g.vcf.gz
../_gvcf/CV0136.raw.snps.indels.g.vcf.gz
../_gvcf/CV0756.raw.snps.indels.g.vcf.gz
../_gvcf/CV0075.raw.snps.indels.g.vcf.gz
../_gvcf/CV0008.raw.snps.indels.g.vcf.gz
../_gvcf/CV0648.raw.snps.indels.g.vcf.gz
../_gvcf/CV0018.raw.snps.indels.g.vcf.gz
../_gvcf/CV0631.raw.snps.indels.g.vcf.gz
```

Ran GenotypeGVCFs on the 32 GVCFs to call variants among samples:
-----------------------------------------------------------------

```bash
nohup java -jar ../gatk-3.8-1-0/GenomeAnalysisTK.jar -T GenotypeGVCFs -R ../CroVir_genome_L77pg_16Aug2017.final_rename.fasta -V sample.gvcf.list -allSites -o cvos.32.phylogeny.raw.vcf.gz > GenotypeGVCFs.cvos.32.phylogeny.raw.vcf.log
```

# Variant filtering

We need to filter variants while retaining positioning within the *C. viridis* reference.
We want to filter/mask repeat bases, low quality genotype calls, and low coverage calls.
We will also conservatively code indels as missing genotypes.

Ran GATK VariantFiltration to mask repeat annotation bases:
-----------------------------------------------------------

This also annotates 'REP' to the VCF filter column for positions overlapping repeat annotations

```bash
nohup java -jar ../gatk-3.8-1-0/GenomeAnalysisTK.jar -T VariantFiltration -R ../CroVir_genome_L77pg_16Aug2017.final_rename.fasta --mask ../CroVir_genome_L77pg_16Aug2017.final.reformat.repeat.masked.sort.chrom.bed --maskName REP --setFilteredGtToNocall --variant cvos.32.phylogeny.raw.vcf.gz --out cvos.32.phylogeny.raw.masked.vcf.gz > VariantFiltration.cvos.32.phylogeny.raw.masked.vcf.log
```

---

Used bcftools filter to set masked positions as missing genotypes:
------------------------------------------------------------------

```bash
bcftools filter --threads 12 -e 'FILTER="REP"' --set-GTs . -O z -o cvos.32.phylogeny.raw.masked.fix.vcf.gz cvos.32.phylogeny.raw.masked.vcf.gz
```

---

Used bcftools filter to set indels, low coverage, and low quality calls as missing:
-----------------------------------------------------------------------------------

```bash
bcftools filter --threads 16 -e 'TYPE="indel" || FORMAT/DP<5 | FORMAT/GQ<30' --set-GTs . -O z -o cvos.32.phylogeny.masked.fix.fil.vcf.gz cvos.32.phylogeny.raw.masked.fix.vcf.gz
```

# Final touch - appending lineage names to sample names

It will be useful in downstream analyses to quickly ID what sample belongs to which lineage.

Used bcftools query to get readout of samples in order from VCF header:
-----------------------------------------------------------------------

```bash
bcftools query -l cvos.32.phylogeny.masked.fix.fil.vcf.gz
```

Appended lineage names and used bcftools reheader to replace old with new names:
--------------------------------------------------------------------------------

```bash
touch rename_cvos.id
nano rename_cvos.id
```

Pasted this in:

```
CA0346_atro
CR0001_rube
CS0027_moha
CS0029_chih
CS0142_cent
CS0143_cent
CS0146_salv
CS0148_salv
CS0153_moha
CS0237_chih
CV0008_vir1
CV0018_vir2
CV0040_conc
CV0053_hell
CV0054_hell
CV0067_luto
CV0075_nunt
CV0086_ore1
CV0094_ore2
CV0136_ore2
CV0147_ore1
CV0203_luto
CV0631_vir2
CV0648_vir1
CV0711_conc
CV0716_cerb
CV0719_abys
CV0721_abys
CV0732_cali
CV0736_cali
CV0755_cerb
CV0756_nunt
```

```bash
bcftools reheader -s rename_cvos.id -o cvos.32.phylogeny.final.vcf.gz cvos.32.phylogeny.masked.fix.fil.vcf.gz
```

Double checked that the new sample names are correct:
-----------------------------------------------------

```bash
bcftools query -l cvos.32.phylogeny.final.vcf.gz
```

Indexed final VCF:
------------------

```bash
tabix -p vcf cvos.32.phylogeny.final.vcf.gz
```

Stored older VCFs in 'vcf_older' directory:
-------------------------------------------

```bash
mkdir vcf_older
mv cvos.32.phylogeny.raw.vcf.gz* vcf_older
```

**REMEMBER, THIS IS THE WORKFLOW:**
map > variant calling > variant filtering > quantifying missing data in genomic regions > selecting genomic regions > generate alignments of selected regions > gene tree estimation

# Filtering spurious female heterozygous calls on the Z Chromosome

Female rattlesnakes cannot have true heterozygous sites on Z-linked regions (because they are ZZ/homogametic).

Any spurious heterozygous calls in females need to be dealt with.

We are going to follow the same procedure used in the recombination study ([Schield et al. 2020](https://doi.org/10.1093/molbev/msaa003)), which is to first query the Z chromosome variant calls for heterozygous sites in known females, then mask those positions as missing data in all individuals. This may be overly stringent, but has the benefit of being conservative since we do not necessarily know the genetic sex of all other individuals in the dataset.

Known females are: CV0721, CV0732, CV0716, CV0756.

Extracted Z chromosome from genomic VCF:
----------------------------------------

Here, we can specify SNPs, because any female heterozyous calls MUST be SNPs at this point,
so we can retroactively filter the VCF

```bash
conda deactivate
bcftools view -r scaffold-Z -o cvos.32.phylogeny.scaffold-Z.vcf cvos.32.phylogeny.final.vcf.gz
```

Figured out which columns the known females were in:
----------------------------------------------------

```bash
less cvos.32.phylogeny.scaffold-Z.vcf
```

Wrote Python script to identify female heterozygous sites:
----------------------------------------------------------

NOTE: this checks that the position is outside of the pseudoautosomal regoin (PAR), which is the recombining part of the Z chromosome with the W chromosome!

The script is `female_hetZ_cvos.32.phylogeny.py` and includes the following code:

```python
import sys
#Known female viridis samples are CV0721_abys, CV0732_cali, CV0716_cerb, CV0756_nunt - need to search their columns for heterozygous sites!
#CV0716_cerb = 35
#CV0721_abys = 37
#CV0732_cali = 39
#CV0756_nunt = 42
python female_hetZ_viridis.py in.Z.vcf out.pos.listout = open(sys.argv[2], 'w')for line in open(sys.argv[1], 'r'):
	if line.split()[0] == 'scaffold-Z':
		chrom = line.split()[0]
		pos = line.split()[1]
		# print chrom, pos
		CV0716_cerb = line.split()[35]
		CV0716_cerb = CV0716_cerb.split(':')[0]
		CV0721_abys = line.split()[16]
		CV0721_abys = CV0721_abys.split(':')[0]
		CV0732_cali = line.split()[17]
		CV0732_cali = CV0732_cali.split(':')[0]
		CV0756_nunt = line.split()[18]
		CV0756_nunt = CV0756_nunt.split(':')[0]    # Only apply this to sites outside of the putative PAR (106800000 - 113984505 bp on Z)
		if int(pos) <= 106800000:
			if CV0716_cerb == '0/1' or CV0721_abys == '0/1' or CV0732_cali == '0/1' or CV0756_nunt == '0/1':
				out.write(str(chrom)+'\t'+str(pos)+'\n')
```

Run the following to execute:

```python
python female_hetZ_cvos.32.phylogeny.py cvos.32.phylogeny.scaffold-Z.vcf cvos.32.phylogeny.filter.scaffold-Z.femHet
```

Quantified number of sites to filter:
-------------------------------------

```bash
cat cvos.32.phylogeny.filter.scaffold-Z.femHet | wc -l
```

501998 sites!

Quantify total number of SNP positions on Z before filtering:
-------------------------------------------------------------

This is to make sure that the above command is not just nuking all variant sites for some
reason.

```bash
awk '{if (length($4) == 1 && length($5) == 1 && $4 ~ /[A-Z]/ && $5 ~ /[A-Z]/ || $1 ~ /^#/) print $1,$2,$4,$5}' cvos.32.phylogeny.scaffold-Z.vcf > cvos.32.phylogeny.scaffold-Z.SNPs.prefilter.txt
cat cvos.32.phylogeny.scaffold-Z.SNPs.prefilter.txt | wc -l
```

6197691 sites! There will still be plenty of variable sites after filtering.

Wrote a filtered Z chromosome VCF without SNPS with female heterozygous calls:
------------------------------------------------------------------------------

```bash
bcftools filter --threads 12 -T ^cvos.32.phylogeny.filter.scaffold-Z.femHet -O z -o cvos.32.phylogeny.scaffold-Z.final.vcf.gz cvos.32.phylogeny.scaffold-Z.vcf
```

Removed enormous uncompressed unfiltered Z chromosome VCF:
----------------------------------------------------------

```bash
tabix -p vcf cvos.32.phylogeny.scaffold-Z.final.vcf.gz
```

Removed enormous uncompressed unfiltered Z chromosome VCF:
----------------------------------------------------------

```bash
rm cvos.32.phylogeny.scaffold-Z.vcf
```

# Calculate missing genotypes in sliding windows

After calling and filtering variants and generating a genomic VCF for all of our samples, it will be useful to quantify how much missing data there is within a given set of genomic
regions that will be analyzed. Daren Card pasted together a couple of `bcftools` commands to output a column of the sample ID, followed by a column of the proportion of missing genotypes for the individual.

Here we looped this to go through a series of genomic windows (`regions.txt`) and also pre-pended a `bcftools` view command to first extract only the region of interest.

The 'regions' used can be taken from a previously-generated 10 kb genomic window file for the *C. viridis* reference genome.

**AN IMPORTANT NOTE:** Later stages of this pipeline to extract alignments barf if the first position of a scaffold is zero-based, thus we'll recode the first position of the first
window per scaffold as 1 instead of 0. For whatever reason, this barfs if executed as a shell script (i.e., `.sh`), so...

Paste this one-liner into terminal:

```bash
for region in cat regions.txt; do y={region%:*}; z="{region%:*}; z="{region##*:}"; regionfix="y"_"y""z"; echo $region;
    paste
    <(bcftools query -f '[%SAMPLE\t]\n' cvos.32.phylogeny.final.vcf.gz | head -1 | tr '\t' '\n')
    <(bcftools view -rregion cvos.32.phylogeny.final.vcf.gz | bcftools query -f '[%GT\t]\n' - | awk -v OFS="\t" '{for (i=1;i<=NF;i++) if (regioncvos.32.phylogeny.final.vcf.gz∣bcftoolsquery−f′[i == "./.") sum[i]+=1 } END {for (i in sum) print i, sum[i] / NR }' | sort -k1,1n | cut -f 2) | head -n -1 - > region_missing/$regionfix.missing.txt; done
```

# Quantify Mean and Max missing data in region list

Now that we know about the amount of missing data per individual for each region, we want to quantify the mean and maximum proportion of missing genotypes for each region
among individuals in our sampling. We can use this information to filter regions out of downstream analyses.

For example, we might specify that we are not going to analyze alignments with an average missing data > 50% and/or maximum missing data > 75%. (This would be a pretty permissive
dataset). The `window_missing.sh` scripts writes output tables per region into a common directory.

We can write a python script  `region_quantify_missing.py` to kick out the region (i.e., file name), mean missing data, and maximum missing data among individuals.

`region_quantify_missing.py` (assuming missing data tables are in directory claled `./region_missing/`) is as follows:

```python
import sys,os,glob
import numpy as npout = open(sys.argv[1], 'w')
out.write('Region'+'\t'+'Mean_Missing'+'\t'+'Max_Missing'+'\n')path = './region_missing/'
for file in glob.glob(os.path.join(path, '*.txt')):    data = []    with open(file, 'r') as f:
		region = file.split('/')[2]
		input = f.readlines()
		for line in input:
			miss = line.split('\t')[1]
			data.append(miss)    datanum = np.array(data).astype(np.float)
	avg = np.mean(datanum)
	max = np.max(datanum)    out.write(str(region)+'\t'+str(avg)+'\t'+str(max)+'\n')
```

Ran region_quantify_missing.py to output table with missingness stats per region:
---------------------------------------------------------------------------------

```python
python region_quantify_missing.py region_missing_table.txt
```

# Filter regions according to missing data

With the mean and maximum missing data proportions quantified per region, we can filter
down to a list of regions that have missing data below a given set of thresholds.

Let's use a second python script to read in the table from `region_quantify_missing.py`
and kick out a list of regions that have missing data proportions below mean and individual
maximum thresholds.

`select_regions.py` is as follows:

```python
import sysout = open(sys.argv[2], 'w')mean_threshold = float(sys.argv[3])
max_threshold = float(sys.argv[4])with open(sys.argv[1], 'r') as input:
	next(input)
	for line in input:
		region_file = line.split('\t')[0]
		region = region_file.split('.')[0]
		region_fix = region.replace('_',':')
		mean = line.split('\t')[1]
		max = line.split('\t')[2]    if float(mean) <= mean_threshold and float(max) <= max_threshold:
			out.write(region_fix+'\n')
			print region_fix, mean, max
```

Ran `select_regions.py` to generate list of regions with mean missing <= 0.25 and max missing <= 0.5:
----------------------------------------------------------------------------------

```python
python select_regions.py region_missing_table.txt region_lists/region_list.mean015.max03.txt 0.15 0.3
python select_regions.py region_missing_table.txt region_lists/region_list.mean025.max05.txt 0.25 0.5
python select_regions.py region_missing_table.txt region_lists/region_list.mean035.max06.txt 0.35 0.6
```

This produced a list file that can be used in the multi-alignment extraction procedure below.

Tabulated numbers of regions under different filtering schemes:
---------------------------------------------------------------

First, made a file called `chrom.txt` with a list of the scaffolds:

```bash
touch chrom.txt
nano chrom.txt
```

Entered info.

Queried all of the regionlist files for the total number of regions:

```bash
for i in regionlist.mean*; do wc -l $i; done
```

```
45 		regionlist.mean015.max03.txt
8142 	regionlist.mean025.max05.txt
30998 	regionlist.mean035.max06.txt
```

Then ran this one-liner to kick out a table per select_regions.py output:

```bash
for i in `cat chrom.list`; do paste <(echo $i) <(grep -c $i regionlist.mean015.max03.txt); done
for i in `cat chrom.list`; do paste <(echo $i) <(grep -c $i regionlist.mean025.max05.txt); done
for i in `cat chrom.list`; do paste <(echo $i) <(grep -c $i regionlist.mean035.max06.txt); done
```

This provides information about how many alignments per chromosome meet the threshold criteria.

For example, for mean = 0.35 and max = 0.6:

```
scaffold-ma1	8968
scaffold-ma2	6404
scaffold-ma3	5611
scaffold-ma4	1871
scaffold-ma5	2115
scaffold-ma6	1228
scaffold-ma7	961
scaffold-Z	452
scaffold-mi1	750
scaffold-mi2	249
scaffold-mi3	447
scaffold-mi4	356
scaffold-mi5	154
scaffold-mi6	386
scaffold-mi7	426
scaffold-mi8	579
scaffold-mi9	41
scaffold-mi10	95
```

# Generating multi-alignments for genomic windows

With a set of genomic regions that we have filtered by proportion of missing data, we can now extract sequences per individual for each region, generating input alignments for gene tree inference. We will use a shell script that iterates through all genomic regions in a list file, formatted as `chrom:start-end`, and then for each sample in a list of samples from the input VCF, extracts a consensus sequence for the sample and appends it to an alignment file, named for the current region.

The script `consensus_align_v2.sh` is below:

```bash
for region in `cat regions.txt`; do y=${region%:*}; z="${region##*:}"; regionfix="$y"_"$z"; echo $region; \
	paste \
	<(bcftools query -f '[%SAMPLE\t]\n' cvos.32.phylogeny.final.vcf.gz | head -1 | tr '\t' '\n') \
	<(bcftools view -r $region cvos.32.phylogeny.final.vcf.gz | bcftools query -f '[%GT\t]\n' - | awk -v OFS="\t" '{for (i=1;i<=NF;i++) if ($i == "./.") sum[i]+=1 } END {for (i in sum) print i, sum[i] / NR }' | sort -k1,1n | cut -f 2) | head -n -1 - > region_missing/$regionfix.missing.txt; done
```

Run `consensus_align_v2.sh` to generate alignments for the 30,998 regions from above:
--------------------------------------------------------------

```bash
sh consensus_align_v2.sh region_lists/regionlist.mean035.max06.txt cvos.32.phylogeny.final.vcf.gz
```

Performed some special steps for the Z chromosome, after filtering female heterozygous
sites (see above):
------------------

```bash
cd region_lists
grep scaffold-Z regionlist.mean035.max06.txt > regionlist.scaffold-Z.mean035.max06.txt
cd ../
rm region_alignments/scaffold-Z*sh consensus_align_v2.sh region_lists/regionlist.scaffold-Z.mean035.max06.txt cvos.32.phylogeny.scaffold-Z.final.vcf.gz
```

