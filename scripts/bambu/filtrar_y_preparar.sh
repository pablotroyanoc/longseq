#!/bin/bash
#SBATCH --job-name=filtprep
#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --output=filtprep%j.out
#SBATCH --error=filtprep%j.err
#SBATCH --time=12:00:00
#SBATCH --qos=medium
set -e

IN_DIR="/home/patroy/longseq/results/bambu"
OUT_DIR="/home/patroy/longseq/results/bambu/prepared"
SAMPLES=("s107_D0" "s107_D21" "s22_D0" "s22_D21" "s23_D0" "s23_D21")

for M in "${SAMPLES[@]}"; do
    # 1. Crear lista de IDs con expresión > 0
    awk -F'\t' 'NR>1 && $2 > 0 {print $1}' ${IN_DIR}/${M}_counts.txt | sed 's/"//g' > ${M}_list.tmp

    # 2. Filtrar GTF y guardarlo en 'prepared'
    grep "^#" ${IN_DIR}/${M}.gtf > ${OUT_DIR}/${M}_filtered.gtf
    grep -F -f ${M}_list.tmp ${IN_DIR}/${M}.gtf >> ${OUT_DIR}/${M}_filtered.gtf

    # 3. Filtrar y formatear TSV de expresión y guardarlo en 'prepared'
    sed 's/"//g' ${IN_DIR}/${M}_counts.txt | sed '1s/^\t//' | sed "1s/^/isoform\t/" > ${M}_temp.tsv
    head -n 1 ${M}_temp.tsv > ${OUT_DIR}/${M}_expression.tsv
    grep -F -f ${M}_list.tmp ${M}_temp.tsv >> ${OUT_DIR}/${M}_expression.tsv

    # Borrar temporales de la carpeta de scripts
    rm ${M}_list.tmp ${M}_temp.tsv
echo "done sample ${M}"
done
