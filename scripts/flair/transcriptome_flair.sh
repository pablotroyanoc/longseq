#!/bin/bash
#SBATCH --job-name=transcriptome_flair
#SBATCH --output=trc_flair.out
#SBATCH --error=trc_flair.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --qos=long
set -e

module load anaconda
source $(conda info --base)/etc/profile.d/conda.sh
conda activate flair

flair transcriptome \
    -f /home/patroy/longseq/data/anotation/Homo_sapiens.GRCh38.115.chr.gtf \
    -b /home/patroy/longseq/results/flair/resultados_totales_flair.bam \
    -g /home/patroy/longseq/data/genome_reference/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa \
    -t 16 \
    -o /home/patroy/longseq/results/flair/result_flair_transcriptome
