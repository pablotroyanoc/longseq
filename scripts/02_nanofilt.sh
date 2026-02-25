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

NanoFilt -q 9.5 data/s107_D0_pass.fastq > data/s107_D0_filtered.fastq