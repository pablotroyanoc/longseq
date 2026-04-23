#!/bin/bash
#SBATCH --job-name=run_isoquant_M1
#SBATCH --output=/home/patroy/longseq/scripts/isoquant/logs/isoquant_%j.out
#SBATCH --error=/home/patroy/longseq/scripts/isoquant/logs/isoquant_%j.err
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=12:00:00
#SBATCH --qos=long

module load anaconda
source activate isoquant_env

ISO_EXEC="/home/patroy/programs/isoquant/IsoQuant/isoquant.py"
GENOME="$HOME/longseq/data/genome_reference/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa"
GTF="$HOME/longseq/data/anotation/Homo_sapiens.GRCh38.115.chr.gtf"
INPUT="$HOME/longseq/results/filtered/Muestra_1_filtered.fastq"
OUT_DIR="$HOME/longseq/results/isoquant_results/Muestra_1"

python3 $ISO_EXEC \
  --reference $GENOME \
  --genedb $GTF \
  --complete_genedb \
  --fastq $INPUT \
  --data_type nanopore \
  --output $OUT_DIR \
  --prefix Muestra_1 \
  --threads 16
