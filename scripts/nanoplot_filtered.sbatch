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

for i in {1..6}; do
    NanoPlot --fastq data/Muestra_${i}_filtered.fastq -o results/01_nanoplot_Muestra_${i}_filtered -t 4
done
