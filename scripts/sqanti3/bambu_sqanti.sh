#!/bin/bash
#SBATCH --job-name=sqanti_bambu
#SBATCH --cpus-per-task=10
#SBATCH --mem=32G
#SBATCH --output=sqanti_bambu%j.out
#SBATCH --error=sqanti_bambu%j.err
#SBATCH --time=3:00:00
#SBATCH --qos=short
set -e

module load anaconda
conda activate sqanti3
export LD_LIBRARY_PATH=$CONDA_PREFIX/lib:$LD_LIBRARY_PATH

SAMPLES=("s107_D0" "s107_D21" "s22_D0" "s22_D21" "s23_D0" "s23_D21")

for M in "${SAMPLES[@]}"; do

  ISO_GTF="/home/patroy/longseq/results/bambu/${M}.gtf"
  GENCODE_GTF="/home/patroy/longseq/data/anotation/Homo_sapiens.GRCh38.115.chr.gtf"
  GENOME_FA="/home/patroy/longseq/data/genome_reference/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa"
  COUNTS="/home/patroy/longseq/results/bambu/${M}_counts.txt"
  OUT_DIR="/home/patroy/longseq/results/sqanti_results_bambu/${M}"

  mkdir -p $OUT_DIR

  sed 's/"//g' $COUNTS > "${M}.tmp"
  sed '1s/^\t//' "${M}.tmp" | sed "1s/^/isoform\t/" > "${M}_expression.tsv"

  python /home/patroy/Programs/SQANTI3/sqanti3_qc.py \
    --isoforms $ISO_GTF \
    --refGTF $GENCODE_GTF \
    --refFasta $GENOME_FA \
    -fl "${M}_expression.tsv" \
    -d $OUT_DIR \
    -o $M \
    --include_ORF \
    --report both \
    -t 10

  rm "${M}.tmp" "${M}_expression.tsv"

  echo "done sample $M"
done
