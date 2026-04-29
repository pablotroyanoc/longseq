#!/bin/bash
#SBATCH --job-name=filtprep
#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --output=filtprep%j.out
#SBATCH --error=filtprep%j.err
#SBATCH --time=12:00:00
#SBATCH --qos=medium

# Quitamos set -e temporalmente para que no muera si grep da 0 matches
set +e 

IN_DIR="/home/patroy/longseq/results/bambu"
OUT_DIR="/home/patroy/longseq/results/bambu/prepared"
SAMPLES=("s107_D0" "s107_D21" "s22_D0" "s22_D21" "s23_D0" "s23_D21")

mkdir -p $OUT_DIR

for M in "${SAMPLES[@]}"; do
    echo "--- Procesando muestra: ${M} ---"

    # 1. Crear lista de IDs (limpiando comillas y posibles espacios raros)
    # Usamos awk '$2 > 0' para asegurar que solo pillamos lo expresado
    sed 's/"//g' ${IN_DIR}/${M}_counts.txt | awk 'NR>1 && $2 > 0 {print $1}' > ${M}_list.tmp

    LINEAS_LISTA=$(wc -l < ${M}_list.tmp)
    echo "Isoformas con expresión encontradas: $LINEAS_LISTA"

    if [ "$LINEAS_LISTA" -eq 0 ]; then
        echo "ERROR: La lista de IDs para $M está vacía. Saltando..."
        continue
    fi

    # 2. Filtrar GTF
    echo "Filtrando GTF..."
    grep "^#" ${IN_DIR}/${M}.gtf > ${OUT_DIR}/${M}_filtered.gtf
    # Añadimos || true para que si no hay matches no aborte el script
    grep -F -f ${M}_list.tmp ${IN_DIR}/${M}.gtf >> ${OUT_DIR}/${M}_filtered.gtf || true

    # 3. Filtrar TSV
    echo "Preparando TSV de expresión..."
    sed 's/"//g' ${IN_DIR}/${M}_counts.txt | sed '1s/^\t//' | sed "1s/^/isoform\t/" > ${M}_temp.tsv
    head -n 1 ${M}_temp.tsv > ${OUT_DIR}/${M}_expression.tsv
    grep -F -f ${M}_list.tmp ${M}_temp.tsv >> ${OUT_DIR}/${M}_expression.tsv || true

    rm ${M}_list.tmp ${M}_temp.tsv
    echo "Hecho: ${M}"
done
