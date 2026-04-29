#!/bin/bash
#SBATCH --job-name=quant_flair
#SBATCH --output=quant_flair.out
#SBATCH --error=quant_flair.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=32G
#SBATCH --time=24:00:00
#SBATCH --qos=long
set -e

module load anaconda
source $(conda info --base)/etc/profile.d/conda.sh
conda activate flair

flair quantify \
  -r /home/patroy/longseq/results/flair/manifest.txt \
  -i /home/patroy/longseq/results/flair/result_flair_collapse/collapsed.isoforms.fa \
  -o /home/patroy/longseq/results/flair/result_flair_quantify/flair_quantify \
  -t 16 \
  --sample_id_only \
  --tpm \
  --trust_ends \
  --temp_dir /home/patroy/longseq/results/flair/tmp_quant 
