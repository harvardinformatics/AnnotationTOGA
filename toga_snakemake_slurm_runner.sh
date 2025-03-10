#!/bin/bash
#SBATCH -J toga
#SBATCH -n 1                 
#SBATCH -t 72:00:00        
#SBATCH -p sapphire # add partition      
#SBATCH --mem=10000           
#SBATCH -o logs/test.%A.out # need to create logs directory first  
#SBATCH -e logs/test.%A.err  

module purge
module load python
mamba activate snakemake # need to have created a snakemake conda environment
profile=$1

snakemake --snakefile workflow/Snakefile --profile $profile --workflow-profile ./profiles/slurm --unlock
snakemake --snakefile workflow/Snakefile --profile $profile --workflow-profile ./profiles/slurm



