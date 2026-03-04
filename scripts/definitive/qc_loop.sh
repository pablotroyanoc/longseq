#!/bin/bash
#SBATCH --job-name=qc_loop
#SBATCH --output=logs/qc_loop%j.out
#SBATCH --error=logs/qc_loop%j.err
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=20:00:00
#SBATCH --qos=short

export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH
GTF=~/longseq/data/anotation/Homo_sapiens.GRCh38.115.chr.gtf
FASTA=~/longseq/data/genome_reference/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa
RENAME_FILE="../../rename.txt"

while read -r RUTA_EXTERNA NOMBRE_CORTO; do

    zcat ${RUTA_EXTERNA}/*.fastq.gz > "${NOMBRE_CORTO}.full.fastq"

    python ~/Programs/SQANTI3/sqanti3_qc.py \
        --isoforms "${NOMBRE_CORTO}.full.fastq" \
        --refGTF $GTF \
        --refFasta $FASTA \
        --fasta \
        --aligner_choice minimap2 \
        --output "${NOMBRE_CORTO}_QC" \
        --dir "../../results/sqanti_qc/${NOMBRE_CORTO}" \
        -t $SLURM_CPUS_PER_TASK
    
    rm "${NOMBRE_CORTO}.full.fastq"

done < "$RENAME_FILE"