#!/bin/bash

while read -r old_path new_id; do

    echo "==> Generando archivo para: $new_id"

    cat ${old_path}/*.fastq.gz > data/${new_id}.fastq.gz

done < rename.txt
