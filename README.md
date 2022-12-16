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
python WriteChromLengthBedFromFasta.py unicorn /PATH/TO/unicorn_v1_genome.fasta
```
