# TOGA: exon-aware liftover
In cases where there is a reasonably high-quality annotation for a species closely related to the genome you wish to annotate, transferring or "lifting over" gene models from that high quality annotation may be a useful approach. Such methods begin with a whole-genome alignment (WGA), which serves as the basis of mapping the genomic coordinates of the source annotation to analogous coordinates in the target genome, i.e. the one you wish to annotate. [TOGA](https://github.com/hillerlab/TOGA) is an exon-aware liftover approach that is also able to classify genes in the target species as orthologs, paralogs or processed pseudogenes. 

In our TOGA workflow, we begin with a WGA created with Cactus, following our recommended best practice documented [here](https://github.com/harvardinformatics/GenomeAnnotation-WholeGenomeAlignment). Running TOGA requires that a genome with a high quality anotation is part of the WGA, and that a number of files be generated. A potentially confusing part of the workflow is naming conventions for the reference annotation species and the species to which annotations are being tranferred ... the confusion being that they vary among the tools in the workflow! Thus, we are explicit about what gets called what in various steps in the workflow.

## 1. Create bed file of target genome chromosome lengths
In this step, the "target" genome is that to which we are lifting over annotations from a reference (source). We use a a python script [WriteChromLengthBedFromFasta.py](https://github.com/harvardinformatics/GenomeAnnotation-TOGA/blob/main/utilities/WriteChromLengthBedFromFasta.py) to create this file. This script uses a fasta parser from the [Biopython](https://biopython.org/) python package. We highly recommend using an Anaconda or comparable python distribution that allows you to create conda environments. Assuming this version of python is in your path, you can create a biopython conda environment as follows:
```
conda create -n biopython -c anaconda biopython
```
Then to activate the environment:
```
source activate biopython
```
From here, you can then run the script simply by supplying the species name and full path to the genome fasta as a command line argument:
```
python WriteChromLengthBedFromFasta.py bigfoot /PATH/TO/bigfoot_v1_genome.fasta
```
## 2. Create CDS annotation bed file for the reference genome
This CDS file is used by TOGA to only consider protein-coding genes and isoforms. This requires three steps. While we demonstrate how to create separate conda environments for the bioinformatics tool required for each step, in principle all tools can be installed to a common conda environment that you use for all three steps.
### 2a. Extract CDS-only gff3 with gffread
Create a conda environment for gffread and extract CDS entries
```
conda create -n gffread -c bioconda gffread
source activate gffread
genome=human_genomic.fasta
gff3=human.gff3
gffread $gff3 -g $genome -C -o human_CDSonly.gff3
conda deactivate
```
### 2b. Convert CDS gff3 to GenePred format
```
conda create -n gff3ToGenePred -c bioconda ucsc-gff3togenepred
source activate gff3ToGenePred
gff3ToGenePred human_CDSonly.gff3 human_CDSonly.GenePred
conda deactivate
```
### 2c. Convert GenePred to bed
```
conda create -n genePredToBed -c bioconda ucsc-genepredtobed
source activate genePredToBed
genePredToBed human_CDSonly.GenePred human_CDSonly.bed
conda deactivate
``` 
## 3. Create 2bit files for both genomes
In our example, we will be lifting over annotations from a high quality human reference to bigfoot, presumably a reasonably close relative.
```
conda create -n faToTwoBit -c bioconda ucsc-fatotwobit
source activate faToTwoBit
faToTwoBit human_genomic.fasta human.2bit
faToTwoBit bigfoot_v1_genome.fasta bigfoot.2bit
conda deactivate
```
## 4. Create CDS isoforms table for reference
One has the option of providing isoform information to TOGA. If one doesn't, TOGA treats every isoform as a separate gene. To generate the isoform table, with gene in first column and isoform in the second, one can use a simple awk cmd:
```
awk -F"\t" '$3=="mRNA"{print $9}' human_CDSonly.gff3 |awk -F";" '{print $3"\t"$1}' |sed 's/gene_name=//g' | sed 's/ID=//g' > human_CDS_isoforms.tsv
```
This awk command works for CDS gff3 files extracted from NCBI gff3 files. Slight changes may be required if the reference annotation is generated by a different repository or workflow.

## 5. Extract psl file from cactus hal (WGA) file
We extract a psl format file describing the overlaps of the genome we wish to annotate to the reference genome. In this case, the genome to be annotated is the "source" and the annotated reference genome is the "target". We execute halLiftover in a singularity container built for cactus. Details on how to build your own cactus image will be available soon [here](https://github.com/harvardinformatics/GenomeAnnotation-WholeGenomeAlignment). The commands below are written as if they were embedded in a shell script with numbered command line arguments, i.e. $1 is the first cmd line argument, $2 is the second, etc.
```
#!/bin/bash

CACTUS_IMAGE=/PATH/TO/cactus.sif

halfile=$1
sourcegenome=$2 # name of source genome in hal file
sourcebed=$3 # chrom length bed file of source genome
targetgenome=$4 # target is the reference genome to which one is lifting
pslout=$5

singularity exec --cleanenv ${CACTUS_IMAGE} halLiftover --outPSL $halfile $sourcegenome $sourcebed $targetgenome $pslout 
``` 
## 6. Force alignments in psl file to positive strand
This step is implemented with pslPosTarget, and can be run in a script, after creating the conda environment:
```
conda create -n pslPosTarget -c bioconda ucsc-pslpostarget
```
Then, run the script:
```
#!/bin/bash
source activate pslPosTarget
inpsl=$1
outpsl=$2
pslPosTarget $1 $2
conda deactivate
``` 
