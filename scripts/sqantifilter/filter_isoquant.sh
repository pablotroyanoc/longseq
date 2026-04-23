#!/bin/bash
#SBATCH --job-name=filt_isoquant
#SBATCH --cpus-per-task=10
#SBATCH --mem=32G
#SBATCH --output=filt_isoquant%j.out
#SBATCH --error=filt_isoquant%j.err
#SBATCH --time=3:00:00
#SBATCH --qos=short
set -e

module load anaconda
conda activate sqanti3
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

SAMPLES=("s107_D0" "s107_D21" "s23_D0" "s23_D21" "s22_D0" "s22_D21")

for NAME in "${SAMPLES[@]}"; do

mkdir -p "/home/patroy/longseq/results/sqanti_results_isoquant/${NAME}/filtered"

    python /home/patroy/Programs/SQANTI3/sqanti3_filter.py rules \
      --sqanti_class "/home/patroy/longseq/results/sqanti_results_isoquant/${NAME}/${NAME}_classification.txt" \
      --filter_gtf "/home/patroy/longseq/results/sqanti_results_isoquant/${NAME}/${NAME}_corrected.gtf" \
      --filter_isoforms "/home/patroy/longseq/results/sqanti_results_isoquant/${NAME}/${NAME}_corrected.fasta" \
      -j "/home/patroy/longseq/scripts/sqantifilter/sqanti_filter.json" \
      -o "${NAME}_filtered" \
      -d "/home/patroy/longseq/results/sqanti_results_isoquant/${NAME}/filtered" \
      --cpus $SLURM_CPUS_PER_TASK

    echo "sample ${NAME} filtered"
done
