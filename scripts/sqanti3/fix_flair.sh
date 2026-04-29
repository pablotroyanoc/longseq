#!/bin/bash
#SBATCH --job-name=sqanti_flair
#SBATCH --cpus-per-task=10
#SBATCH --mem=32G
#SBATCH --output=sqanti_flair%j.out
#SBATCH --error=sqanti_flair%j.err
#SBATCH --time=10:00:00
#SBATCH --qos=medium
set -e
# Fix FLAIR counts TSV: strips _ENSG... suffix from isoform IDs so they
# match the transcript_id in the isoforms GTF (ENST only, no _ENSG suffix)

FLAIR_DIR="/home/patroy/longseq/results/flair/transcriptome"
SAMPLES=("s23_D21" "s107_D21" "s22_D0" "s22_D21" "s23_D0" "s107_D0")

for NAME in "${SAMPLES[@]}"; do
    INPUT="${FLAIR_DIR}/${NAME}_transcriptome.isoform.counts.tsv"
    OUTPUT="${FLAIR_DIR}/${NAME}_transcriptome.isoform.counts.fixed.tsv"

    if [[ ! -f "$INPUT" ]]; then
        echo "WARNING: $INPUT not found, skipping"
        continue
    fi

    # Keep header as-is, strip _ENSG... from isoform ID column (col 1)
    awk 'NR==1 { print; next } { sub(/_ENSG[0-9]+$/, "", $1); print }' "$INPUT" > "$OUTPUT"

    echo "Fixed: $OUTPUT"
    echo "  Before: $(sed -n '2p' $INPUT)"
    echo "  After:  $(sed -n '2p' $OUTPUT)"
done
