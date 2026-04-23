#!/bin/bash
#SBATCH --job-name=SQ3_M1
#SBATCH --cpus-per-task=10
#SBATCH --mem=32G
#SBATCH --output=sqanti_M1_%j.out
#SBATCH --error=sqanti_M1_%j.err
#SBATCH --time=1:00:00
#SBATCH --qos=short

module load anaconda
conda activate sqanti3
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

ISO_GTF="/home/patroy/longseq/results/isoquant_results/Muestra_1/Muestra_1/Muestra_1.transcript_models.gtf"
GENCODE_GTF="/home/patroy/longseq/data/anotation/Homo_sapiens.GRCh38.115.chr.gtf"
GENOME_FA="/home/patroy/longseq/data/genome_reference/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa"
COUNTS="/home/patroy/longseq/results/isoquant_results/Muestra_1/Muestra_1/Muestra_1.kallisto_limpio.tsv"
SAMPLE_ID="s23_D21"
OUT_DIR="/home/patroy/longseq/results/sqanti_results/$SAMPLE_ID"

python /home/patroy/Programs/SQANTI3/sqanti3_qc.py \
  --isoforms $ISO_GTF \
  --refGTF $GENCODE_GTF \
  --refFasta $GENOME_FA \
  -e $COUNTS \
  -d $OUT_DIR \
  -o $SAMPLE_ID \
  --report pdf \
  --genename \
  -t 10

