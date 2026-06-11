#!/bin/bash
#SBATCH --job-name=isoquant_no_db
#SBATCH --output=/home/patroy/longseq/scripts/isoquant/logs/isoquant_nodb%j.out
#SBATCH --error=/home/patroy/longseq/scripts/isoquant/logs/isoquant_nodb%j.err
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --qos=long

module load anaconda
source activate isoquant_env

ISO_EXEC="/home/patroy/programs/isoquant/IsoQuant/isoquant.py"
GENOME="$HOME/longseq/data/genome_reference/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa"

for i in {1..6}
do
    python3 $ISO_EXEC \
      --reference $GENOME \
      --fastq /home/patroy/longseq/results/filtered/Muestra_${i}_filtered.fastq \
      --data_type nanopore \
      --output /home/patroy/longseq/results/isoquant_results_no_db/Muestra_${i} \
      --prefix Muestra_${i} \
      --threads 16
echo "isoquant hecho para Muestra_${i}"
done

