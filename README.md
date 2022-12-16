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
source deactivate
```
### 2b. Convert CDS gff3 to GenePred format
```
conda create -n gff3ToGenePred -c bioconda ucsc-gff3togenepred
source activate gff3ToGenePred
gff3ToGenePred human_CDSonly.gff3 human_CDSonly.GenePred
source deactivate
```
### 2c. Convert GenePred to bed
```
conda create -n genePredToBed -c bioconda ucsc-genepredtobed
source activate genePredToBed
genePredToBed human_CDSonly.GenePred human_CDSonly.bed
source deactivate
``` 
## 3. Create 2bit files for both genomes
In our example, we will be lifting over annotations from a high quality human reference to bigfoot, presumably a reasonably close relative.
```
conda create -n faToTwoBit -c bioconda ucsc-fatotwobit
source activate faToTwoBit
faToTwoBit human_genomic.fasta human.2bit
faToTwoBit bigfoot_v1_genome.fasta bigfoot.2bit
source deactivate
```

