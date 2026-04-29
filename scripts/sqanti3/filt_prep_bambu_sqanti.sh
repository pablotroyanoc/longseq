#!/bin/bash
#SBATCH --job-name=sqanti_bambu_filtprep
#SBATCH --cpus-per-task=10
#SBATCH --mem=32G
#SBATCH --output=sqanti_bambu_filtprep%j.out
#SBATCH --error=sqanti_bambu_filtprep%j.err
#SBATCH --time=12:00:00
#SBATCH --qos=medium
set -e

module load anaconda
conda activate sqanti3
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

PREPARED_DIR="/home/patroy/longseq/results/bambu/prepared"
GENCODE_GTF="/home/patroy/longseq/data/anotation/Homo_sapiens.GRCh38.115.chr.gtf"
GENOME_FA="/home/patroy/longseq/data/genome_reference/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa"

SAMPLES=("s107_D0" "s107_D21" "s22_D0" "s22_D21" "s23_D0" "s23_D21")

for M in "${SAMPLES[@]}"; do

  ISO_GTF="${PREPARED_DIR}/${M}_filtered.gtf"
  EXPRESSION="${PREPARED_DIR}/${M}_expression.tsv"
  OUT_DIR="/home/patroy/longseq/results/sqanti_results_bambu/filt_prep/${M}"

  mkdir -p $OUT_DIR


  python /home/patroy/Programs/SQANTI3/sqanti3_qc.py \
    --isoforms $ISO_GTF \
    --refGTF $GENCODE_GTF \
    --refFasta $GENOME_FA \
    -fl $EXPRESSION \
    -d $OUT_DIR \
    -o $M \
    --include_ORF \
    --report both \
    -t 10

  echo "done sample $M"
done
