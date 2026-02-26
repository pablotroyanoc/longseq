#!/bin/bash
#SBATCH --job-name=02_nanofilt
#SBATCH --output=logs/02_nanofilt_%j.out
#SBATCH --error=logs/02_nanofilt_%j.err
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --qos=short

module load anaconda
conda activate nanoplot_env

for i in {1..6}; do
    zcat data/Muestra_${i}.fastq.gz | NanoFilt -q 6 > data/Muestra_${i}_filtered.fastq
done
