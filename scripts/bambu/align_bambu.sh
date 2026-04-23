#!/bin/bash
#SBATCH --job-name=align_bambu
#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --output=align_%j.out
#SBATCH --error=align_%j.err
#SBATCH --time=12:00:00
#SBATCH --qos=medium

set -e

module load anaconda
conda activate sqanti3
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

GENOME="/home/patroy/longseq/data/genome_reference/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa"
FASTQ_DIR="/home/patroy/longseq/results/filtered" # Donde esten tus FASTQ filtrados
OUT_DIR="/home/patroy/longseq/results/bambu"

mkdir -p "$OUT_DIR"

SAMPLES=("s107_D0" "s107_D21" "s23_D0" "s23_D21" "s22_D0" "s22_D21")

for NAME in "${SAMPLES[@]}"; do
    
    echo "Processing sample: ${NAME}"
   
    minimap2 -ax splice -u f -t $SLURM_CPUS_PER_TASK "$GENOME" "${FASTQ_DIR}/${NAME}_filtered.fastq" | \
    samtools sort -@ 4 -o "${OUT_DIR}/${NAME}.bam"

    samtools index "${OUT_DIR}/${NAME}.bam"

    echo "Sample ${NAME} aligned and indexed."

done
