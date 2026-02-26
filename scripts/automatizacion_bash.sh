#!/bin/bash
set -e


for file in /storage/gge/longseq_epitranscriptomics/ ; do
 id=$(echo $file | cut -d "_")
 Nanoplot
