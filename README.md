# TOGA: exon-aware liftover
This repository cotains a Snakemake workflow for running[TOGA](https://github.com/hillerlab/TOGA), which performs exon-aware liftover of genome annotations from a high-quality reference annotation to a new genome assembly (predicated on the feasibility of whole genome alignment between the two genomes). This workflow runs the necessary input data pre-processing steps, as well some additional post-TOGA annotation processing. 

## Workflow input file requirements
* A whole-genome alignment (WGA) in *hal* generated with [Cactus](https://www.nature.com/articles/s41586-020-2871-y), that can be implemented using our [Cactus Snakemake workflow](https://github.com/harvardinformatics/cactus-snakemake). This WGA must contain the reference genome (whose annotations will be transferred to the species of interest) and the genome to which annotations will be transferred.
* Genome fasta files for both reference and target genomes.
* A tab-separated table, that maps reference annotation protein-coding gene names to isoform names, in the first and second columns, respectively. This information is typically embedded in the attributes column (column 9) of a gff3 file, but due to the heterogeneity of attributes field composition across various annotation sources, at this point we have decided not to try and create a robust parser to generate this table on the fly. It should be straightforward to create the table using a python script, or either *awk* or *sed* command line tools. Should this workflow generate errors relating to there being no matching features found, look at the *genepred* file in the *results/* directory to confirm that the isoform names in it match those in your isoforms table. If they don't, change your isoforms table so that they match.
* The annotation for the reference genome in gff3 format.



## Workflow software requirements
This workflow has been tested with python v. 3.11, the same version that the TOGA developers recommend using. Assuming you already have a conda-enabled python distribution where you plan on running this workflow, you will want to create a snakemake environment as follows:

```bash
mamba create -n snakemake_py311 python=3.11
mamba activate snakemake_py311
mamba install snakemake
mamba install bioconda::snakemake-executor-plugin-slurm 
mamba deactivate
```
You will also need to clone the TOGA repository from [here](https://github.com/hillerlab/TOGA), e.g.

```bash
git clone git@github.com:hillerlab/TOGA.git
```
Finally, you will need a singularity container for cactus, as one of the cactus utilities is used in the workflow. You will need singularity installed where you plan on running your workflow. If it is not, you can install it into your *snakemake_py311* environment:
```bash
mamba activate snakemake_py311
mamba install conda-forge::singularity
mamba deactivate
```

The following command can be run from inside *snakemake_py311* or outside of it, depending upon whether singularity is already installed globally:
```bash
singularity pull docker://quay.io/comparative-genomics-toolkit/cactus:v2.9.3
```

## Directory structure requirements
An idiosyncracy of the TOGA workflow is that the repository does not contain all the necessary pieces to run it, such that it downloads the executable and associated code of the program CESAR when the Nextflow workflow launches. It also downloads it into the directory of your local TOGA clone, and the TOGA code only wants to look for CESAR inside that directory: adding the CESAR directory to the $PATH variable does not circumvent this. Thus, you need to launch your Snakemake workflow from **inside** the TOGA clone. So, to run the workflow,
* clone this GitHub repository
* inside of it, create a directory called *data* and stick all of your input files in it
* clone the TOGA GitHub repository into it
* edit *config/config.yaml* so that the full paths to the input files and the cactus singularity image are added
* edit *profiles/slurm/config.yaml* so that SLURM account and partitions are added. Note, if your HPC cluster does not run SLURM as it's job scheduler, you will need to download another scheduler profile template and edit accordingly.
* copy *workflow/*, *profiles/*, and *config/* into the *TOGA/* clone directory

## Running the workflow
Once the above steps have been completed, all you need to do is cd into the *TOGA/* directory, and run the following "dry-run":

```bash
snakemake -np --snakefile workflow/Snakefile --use-singularity --use-conda --profile profiles/slurm/
```
If the directed acyclic graph (DAG) of the steps is created and no other errors occur, you can then run the workflow:

```bash
snakemake --snakefile workflow/Snakefile --use-singularity --use-conda --profile profiles/slurm/ 
```
