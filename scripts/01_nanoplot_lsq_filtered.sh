#!/bin/bash
#SBATCH --job-name=01_nanoplot_lsq_filtered
#SBATCH --output=logs/01_nanoplot_lsq_filtered_%j.out
#SBATCH --error=logs/01_nanoplot_lsq_filtered_%j.err
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --qos=short

module load anaconda
conda activate nanoplot_env

mkdir -p results/qc_filtered

for i in {1..6}; do
    NanoPlot --fastq results/filtered/Muestra_${i}_filtered.fastq -o results/qc_filtered/QC_Muestra_${i} -t 4
done