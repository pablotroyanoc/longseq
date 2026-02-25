#!/bin/bash
#SBATCH --job-name=01_nanoplot
#SBATCH --output=logs/01_nanoplot_%j.out
#SBATCH --error=logs/01_nanoplot_%j.err
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --qos=short

module load anaconda
conda activate nanoplot_env

NanoPlot --fastq data/s107_D0_pass.fastq -o results/01_nanoplot_report -t 4
