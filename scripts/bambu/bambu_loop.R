library(bambu)

args <- commandArgs(trailingOnly = TRUE)

bam_path <- args[1]

sample_id <- sub("\\.bam$", "", basename(bam_path))


gtf <- "/home/patroy/longseq/data/anotation/Homo_sapiens.GRCh38.115.chr.gtf"
fa <- "/home/patroy/longseq/data/genome_reference/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa"
out <- "/home/patroy/longseq/results/bambu"

annotations <- prepareAnnotations(gtf)
se <- bambu(reads = bam_path, annotations = annotations, genome = fa, ncore = 8, discovery = TRUE)

writeToGTF(rowRanges(se), file.path(out, paste0(sample_id, ".gtf")))
write.table(assays(se)$counts, file.path(out, paste0(sample_id, "_counts.txt")), 
            sep="\t", quote=FALSE, col.names = NA)


