#!/bin/bash
#SBATCH --job-name=collapse_flair
#SBATCH --output=col_flair.out
#SBATCH --error=col_flair.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --qos=long
set -e

module load anaconda
source $(conda info --base)/etc/profile.d/conda.sh
conda activate flair

flair collapse \
    -f /home/patroy/longseq/data/anotation/Homo_sapiens.GRCh38.115.chr.gtf \
    -q /home/patroy/longseq/results/flair/resultados_totales_flair.bed \
    -g /home/patroy/longseq/data/genome_reference/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa \
    -r /home/patroy/longseq/results/filtered/Muestra_1_filtered.fastq,\
/home/patroy/longseq/results/filtered/Muestra_2_filtered.fastq,\
/home/patroy/longseq/results/filtered/Muestra_3_filtered.fastq,\
/home/patroy/longseq/results/filtered/Muestra_4_filtered.fastq,\
/home/patroy/longseq/results/filtered/Muestra_5_filtered.fastq,\
/home/patroy/longseq/results/filtered/Muestra_6_filtered.fastq \
    -t 16 \
    --stringent \
    --check_splice \
    --generate_map \
    --annotation_reliant generate \
    -i \
    --trust_ends \
    -o /home/patroy/longseq/results/flair/result_flair_collapse/collapsed
