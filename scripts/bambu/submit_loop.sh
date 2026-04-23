#!/bin/bash
#SBATCH --job-name=bambu_loop
#SBATCH --cpus-per-task=8
#SBATCH --mem=40G
#SBATCH --time=12:00:00
#SBATCH --qos=medium
#SBATCH --output=/home/patroy/longseq/scripts/bambu/bambu_loop%j.out
#SBATCH --error=/home/patroy/longseq/scripts/bambu/bambu_loop%j.err

module load anaconda
conda activate bambu

cd /home/patroy/longseq/results/bambu

for f in *.bam; do
    name=$(basename "$f" .bam)

    if [ "$name" == "s107_D0" ]; then
        echo "Saltando $name porque ya esta lista"
        continue
    fi

    echo "Procesando muestra: $name"
    Rscript /home/patroy/longseq/scripts/bambu/bambu_loop.R "$f"
done
