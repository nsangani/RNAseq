library('rstudioapi')
library('DESeq2')
library('GenomicFeatures')
library('GenomicAlignments')

setwd(dirname(getActiveDocumentContext()$path))

sample_Table <- data.frame(
  sample_Name = c('Hepatocyte_1','Hepatocyte_2','WholeLiver_1','WholeLiver_2'),
  file_Name = c('T-RNA_Hepatocyte_3.sorted.bam','T-RNA_Hepatocyte_4.sorted.bam','T-RNA_WholeLiver_3.sorted.bam','T-RNA_WholeLiver_4.sorted.bam'),
  treatment = c('Hepatocyte', 'Hepatocyte','WholeLiver','WholeLiver'))

bam_Files <- file.path('./HT Data', sample_Table$file_Name)

mouse_Annot <- makeTxDbFromGFF('mm10.ensGene.gtf',format = 'gtf')
exons_Bygene <- exonsBy(mouse_Annot, by = "gene")

exp_Summary <- summarizeOverlaps(exons_Bygene, BamFileList(bam_Files, yieldSize = 50000), mode = 'Union', singleEnd = FALSE, ignore.strand = TRUE, fragments = TRUE)
colData(exp_Summary) <- cbind( colData(exp_Summary), sample_Table)
dds_Full <- DESeqDataSet(exp_Summary, design = ~treatment)

write.table(as.data.frame(counts(dds_Full)), file = 'Hep_WL_B_Comparison_Data.tsv', sep = '\t')

deseq_Result <- DESeq(dds_Full)
deg_Result <- results(deseq_Result)
mcols(deg_Result, use.names=TRUE)

resultsNames(deseq_Result)

plotCounts(deseq_Result, gene = which.min(deg_Result$padj), intgroup = 'treatment')

deg_Lfc <- lfcShrink(deseq_Result, coef = 'treatment_WholeLiver_vs_Hepatocyte', type = 'apeglm')

write.table(as.data.frame(deg_Lfc), file = 'DESEQ_Hep_WL_DEGS.csv')

p_Res <- subset(deg_Lfc, padj < 0.05)
low_Res <- subset(p_Res, abs(log2FoldChange) > 1.5)
write.table(low_Res, file = 'Hep_WL_15FC_Data.csv', sep = '\t')
write.table(row.names(low_Res), file = 'Hep_WL_15FC_Genes.csv', row.names = FALSE, sep = ',')

high_Res <- subset(p_Res, abs(log2FoldChange) > 2)
write.table(low_Res, file = 'Hep_WL_2FC_Data.csv', sep = '\t')
write.table(row.names(high_Res), file = 'Hep_WL_2FC_Genes.csv', row.names = FALSE, sep = ',')

sample_Table <- data.frame(
  sample_Name = c('Hepatocyte_1','Hepatocyte_2','Hepatocyte_3','Hepatocyte_4','NASH_Hepatocyte_1','NASH_Hepatocyte_2','NASH_Hepatocyte_3', 'NASH_Hepatocyte_4'),
  file_Name = c('T-RNA_Hepatocyte_1.sorted.bam','T-RNA_Hepatocyte_2.sorted.bam', 'T-RNA_Hepatocyte_3.sorted.bam','T-RNA_Hepatocyte_4.sorted.bam','T-RNA_NASH_Hepatocyte_1.sorted.bam', 'T-RNA_NASH_Hepatocyte_2.sorted.bam','T-RNA_NASH_Hepatocyte_3.sorted.bam', 'T-RNA_NASH_Hepatocyte_4.sorted.bam'),
  treatment = c('Healthy', 'Healthy','Healthy','Healthy','NASH','NASH','NASH', 'NASH'))

bam_Files <- file.path('./HT Data', sample_Table$file_Name)

exp_Summary <- summarizeOverlaps(exons_Bygene, BamFileList(bam_Files, yieldSize = 2000000), mode = 'Union', singleEnd = FALSE, ignore.strand = TRUE, fragments = TRUE)
colData(exp_Summary) <- cbind( colData(exp_Summary), sample_Table)
dds_Full <- DESeqDataSet(exp_Summary, design = ~treatment)

write.table(as.data.frame(counts(dds_Full)), file = 'Hep_NASH_Comparison_Data.tsv', sep = '\t')

deseq_Result <- DESeq(dds_Full)
deg_Result <- results(deseq_Result)
mcols(deg_Result, use.names=TRUE)

resultsNames(deseq_Result)

plotCounts(deseq_Result, gene = which.min(deg_Result$padj), intgroup = 'treatment')

deg_Lfc <- lfcShrink(deseq_Result, coef = 'treatment_NASH_vs_Healthy', type = 'apeglm')

write.table(as.data.frame(deg_Lfc), file = 'DESEQ_Hep_NASH_DEGS.csv')


p_Res <- subset(deg_Lfc, padj < 0.05)
low_Res <- subset(p_Res, abs(log2FoldChange) > 1.5)
write.table(low_Res, file = 'Hep_NASH_15FC_Data.csv', sep = '\t')
write.table(row.names(low_Res), file = 'Hep_NASH_15FC_Genes.csv', row.names = FALSE, sep = ',')

high_Res <- subset(p_Res, abs(log2FoldChange) > 2)
write.table(low_Res, file = 'Hep_NASH_2FC_Data.csv', sep = '\t')
write.table(row.names(high_Res), file = 'Hep_NASH_2FC_Genes.csv', row.names = FALSE, sep = ',')


sample_Table <- data.frame(
  sample_Name = c('WholeLiver_1','WholeLiver_2','WholeLiver_3','WholeLiver_4','NASH_WholeLiver_1','NASH_WholeLiver_2'),
  file_Name = c('T-RNA_WholeLiver_1.sorted.bam','T-RNA_WholeLiver_2.sorted.bam', 'T-RNA_WholeLiver_3.sorted.bam','T-RNA_WholeLiver_4.sorted.bam','T-RNA_NASH_WholeLiver_1.sorted.bam', 'T-RNA_NASH_WholeLiver_2.sorted.bam'),
  treatment = c('Healthy', 'Healthy','Healthy','Healthy','NASH','NASH'))

bam_Files <- file.path('./HT Data', sample_Table$file_Name)

exp_Summary <- summarizeOverlaps(exons_Bygene, BamFileList(bam_Files, yieldSize = 2000000), mode = 'Union', singleEnd = FALSE, ignore.strand = TRUE, fragments = TRUE)
colData(exp_Summary) <- cbind( colData(exp_Summary), sample_Table)
dds_Full <- DESeqDataSet(exp_Summary, design = ~treatment)

write.table(as.data.frame(counts(dds_Full)), file = 'WL_NASH_Comparison_Data.tsv', sep = '\t')

deseq_Result <- DESeq(dds_Full)
deg_Result <- results(deseq_Result)
mcols(deg_Result, use.names=TRUE)

resultsNames(deseq_Result)

plotCounts(deseq_Result, gene = which.min(deg_Result$padj), intgroup = 'treatment')

deg_Lfc <- lfcShrink(deseq_Result, coef = 'treatment_NASH_vs_Healthy', type = 'apeglm')

write.table(as.data.frame(deg_Lfc), file = 'DESEQ_wL_NASH_DEGS.csv')


p_Res <- subset(deg_Lfc, padj < 0.05)
low_Res <- subset(p_Res, abs(log2FoldChange) > 1.5)
write.table(low_Res, file = 'WL_NASH_15FC_Data.csv', sep = '\t')
write.table(row.names(low_Res), file = 'WL_NASH_15FC_Genes.csv', row.names = FALSE, sep = ',')

high_Res <- subset(p_Res, abs(log2FoldChange) > 2)
write.table(low_Res, file = 'WL_NASH_2FC_Data.csv', sep = '\t')
write.table(row.names(high_Res), file = 'WL_NASH_2FC_Genes.csv', row.names = FALSE, sep = ',')