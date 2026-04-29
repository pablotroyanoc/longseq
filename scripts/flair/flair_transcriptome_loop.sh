#!/bin/bash
#SBATCH --job-name=flair_transcriptome_loop
#SBATCH --output=flair_trc_loop%j.out
#SBATCH --error=flair_trc_loop%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --qos=medium

set -e

module load anaconda
source $(conda info --base)/etc/profile.d/conda.sh
conda activate flair

ALIGN_DIR="/home/patroy/longseq/results/flair/align"
GENOME="/home/patroy/longseq/data/genome_reference/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa"
GTF="/home/patroy/longseq/data/anotation/Homo_sapiens.GRCh38.115.chr.gtf"
OUT_DIR="/home/patroy/longseq/results/flair/transcriptome"

mkdir -p $OUT_DIR

SAMPLES=("s107_D0" "s107_D21" "s22_D0" "s22_D21" "s23_D0" "s23_D21")

for M in "${SAMPLES[@]}"; do

    flair transcriptome \
        -b "${ALIGN_DIR}/${M}_flair.bam" \
        -g "$GENOME" \
        -f "$GTF" \
        -t 16 \
        -o "${OUT_DIR}/${M}_transcriptome"

    echo "Finalizado transcriptome para: ${M}"
done
