#!/bin/bash
#SBATCH --job-name=coorect_flair
#SBATCH --output=flair_cor.out
#SBATCH --error=flair_cor.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --qos=long
set -e

module load anaconda
source $(conda info --base)/etc/profile.d/conda.sh
conda activate flair

flair correct \
    -f /home/patroy/longseq/data/anotation/Homo_sapiens.GRCh38.115.chr.gtf \
    -q /home/patroy/longseq/results/flair/resultados_totales_flair.bed \
    -t 16 \
    -o /home/patroy/longseq/results/flair/result_flair_corrected
