#!/bin/bash
#SBATCH --job-name=SQ3_loop
#SBATCH --cpus-per-task=10
#SBATCH --mem=32G
#SBATCH --output=sqanti_loop_%j.out
#SBATCH --error=sqanti_loop_%j.err
#SBATCH --time=3:00:00
#SBATCH --qos=short
set -e

module load anaconda
conda activate sqanti3
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

declare -A SAMPLES
SAMPLES["Muestra_1"]="s23_D21"
SAMPLES["Muestra_2"]="s107_D21"
SAMPLES["Muestra_3"]="s22_D0"
SAMPLES["Muestra_4"]="s22_D21"
SAMPLES["Muestra_5"]="s23_D0"
SAMPLES["Muestra_6"]="s107_D0"

for M in "${!SAMPLES[@]}"; do
    NAME=${SAMPLES[$M]}

ISO_GTF="/home/patroy/longseq/results/isoquant_results/$M/$M/$M.transcript_models.gtf"
GENCODE_GTF="/home/patroy/longseq/data/anotation/Homo_sapiens.GRCh38.115.chr.gtf"
GENOME_FA="/home/patroy/longseq/data/genome_reference/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa"
COUNTS="/home/patroy/longseq/results/isoquant_results/$M/$M/$M.discovered_transcript_counts.tsv"
OUT_DIR="/home/patroy/longseq/results/sqanti_results/$NAME"

python /home/patroy/Programs/SQANTI3/sqanti3_qc.py \
  --isoforms $ISO_GTF \
  --refGTF $GENCODE_GTF \
  --refFasta $GENOME_FA \
  -fl $COUNTS \
  -d $OUT_DIR \
  -o $NAME \
  --include_ORF \
  --report both \
  -t 10

echo "Finished sample $NAME"
done
