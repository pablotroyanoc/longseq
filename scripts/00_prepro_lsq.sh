#!/bin/bash
#SBATCH --job-name=00_prepro_lsq
#SBATCH --output=logs/00_prepro_lsq_%j.out
#SBATCH --error=logs/00_prepro_lsq_%j.err
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=02:00:00
#SBATCH --qos=short

while read -r old_path new_id; do

    echo "==> Generando archivo para: $new_id"

    cat ${old_path}/*.fastq.gz > data/${new_id}.fastq.gz

done < rename.txt
