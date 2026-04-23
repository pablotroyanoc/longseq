#!/bin/bash
#SBATCH --job-name=bambu_s107
#SBATCH --cpus-per-task=8
#SBATCH --mem=40G
#SBATCH --time=04:00:00
#SBATCH --qos=medium
#SBATCH --output=/home/patroy/longseq/scripts/bambu/bambu_test%j.out
#SBATCH --error=/home/patroy/longseq/scripts/bambu/bambu_test%j.err

module load anaconda
conda activate bambu
Rscript testbambu_s107_D0.R
