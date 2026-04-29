#!/bin/bash
#SBATCH --job-name=sqanti_flair
#SBATCH --cpus-per-task=10
#SBATCH --mem=32G
#SBATCH --output=sqanti_flair%j.out
#SBATCH --error=sqanti_flair%j.err
#SBATCH --time=10:00:00
#SBATCH --qos=medium
set -e

module load anaconda
conda activate sqanti3
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

SAMPLES=("s23_D21" "s107_D21" "s22_D0" "s22_D21" "s23_D0" "s107_D0")
FLAIR_DIR="/home/patroy/longseq/results/flair/transcriptome"
GENCODE_GTF="/home/patroy/longseq/data/anotation/Homo_sapiens.GRCh38.115.chr.gtf"
GENOME_FA="/home/patroy/longseq/data/genome_reference/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa"

for NAME in "${SAMPLES[@]}"; do

    ISO_GTF="${FLAIR_DIR}/${NAME}_transcriptome.isoforms.gtf"
    COUNTS="${FLAIR_DIR}/${NAME}_transcriptome.isoform.counts.fixed.tsv"
    OUT_DIR="/home/patroy/longseq/results/sqanti_results_flair/$NAME"
    mkdir -p $OUT_DIR

    python /home/patroy/Programs/SQANTI3/sqanti3_qc.py \
      --isoforms $ISO_GTF \
      --refGTF $GENCODE_GTF \
      --refFasta $GENOME_FA \
      -fl $COUNTS \
      -d $OUT_DIR \
      -o $NAME \
      --include_ORF \
      --report both \
      -t 10

    echo "Finished sample $NAME"
done
