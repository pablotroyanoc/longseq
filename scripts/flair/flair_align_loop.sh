#!/bin/bash
#SBATCH --job-name=flair_align
#SBATCH --output=flair_align_%j.out
#SBATCH --error=flair_align_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --qos=medium
set -e

module load anaconda
source $(conda info --base)/etc/profile.d/conda.sh
conda activate flair

FASTQ_DIR="/home/patroy/longseq/results/filtered"
GENOME="/home/patroy/longseq/data/genome_reference/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa"
OUT_DIR="/home/patroy/longseq/results/flair/align"

mkdir -p $OUT_DIR

SAMPLES=("s107_D0" "s107_D21" "s22_D0" "s22_D21" "s23_D0" "s23_D21")

for M in "${SAMPLES[@]}"; do
        flair align \
        -r "${FASTQ_DIR}/${M}_filtered.fastq" \
        -g "$GENOME" \
        -t 16 \
        -o "${OUT_DIR}/${M}_flair"

    echo "Finalizado: ${M}"
done

