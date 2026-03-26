#!/bin/bash
#SBATCH --job-name=SQ3_FINAL_OK
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=1:00:00
#SBATCH --qos=short
#SBATCH --output=sqanti_reads.out
#SBATCH --error=sqanti_reads.out
set -e

module load anaconda
conda activate sqanti3

export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

WD=/home/patroy/longseq

python /home/patroy/Programs/SQANTI3/sqanti3_reads.py \
  --refFasta $WD/data/genome_reference/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa \
  --refGTF $WD/data/anotation/Homo_sapiens.GRCh38.115.chr.gtf \
  --design $WD/results/sqanti_reads/design.csv \
  -d $WD/results/sqanti_reads/reads_SQ_QC/ \
  -o $WD/results/sqanti_reads/sqanti_reads_v2 \
  -t 8 --verbose
