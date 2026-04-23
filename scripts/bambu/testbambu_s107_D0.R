library(bambu)

gtf <- "/home/patroy/longseq/data/anotation/Homo_sapiens.GRCh38.115.chr.gtf"
fa <- "/home/patroy/longseq/data/genome_reference/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa"
bam <- "/home/patroy/longseq/results/bambu/s107_D0.bam"
out <- "/home/patroy/longseq/results/bambu"

dir.create(out, recursive = TRUE)
annotations <- prepareAnnotations(gtf)
se <- bambu(reads = bam, annotations = annotations, genome = fa, ncore = 8, discovery = TRUE)

writeToGTF(rowRanges(se), file.path(out, "s107_D0.gtf"))
write.table(assays(se)$counts, file.path(out, "counts.txt"), sep="\t", quote=FALSE, col.names = NA)
