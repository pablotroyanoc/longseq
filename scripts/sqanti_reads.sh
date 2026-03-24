#!/bin/bash
#SBATCH --job-name=SQ3_FINAL_OK
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --qos=short
#SBATCH --output=sqanti_reads.out
#SBATCH --error=sqanti_reads.err


module load anaconda
conda activate sqanti3

export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

python /home/patroy/Programs/SQANTI3/sqanti3_reads.py \
  --refFasta /home/patroy/longseq/data/genome_reference/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa \
  --refGTF /home/patroy/longseq/data/anotation/Homo_sapiens.GRCh38.115.chr.gtf \
  --design design.csv \
  -d ./ \
  -o total_analysis_merged \
  -t 8
