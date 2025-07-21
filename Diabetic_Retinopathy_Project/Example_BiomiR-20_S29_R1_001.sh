#!/bin/bash

# Load required modules
module load cutadapt/2.10
module load fastqc/0.11.9
module load multiqc/1.9
module load hisat2/2.1.0
module load samtools/1.9

# Define input files and output prefixes
SAMPLE="BiomiR-20_S29"
R1="${SAMPLE}_R1_001.fastq.gz"
R2="${SAMPLE}_R2_001.fastq.gz"
REF_INDEX="/N/project/Mammalian_Genomics/Neel_2020/Genome_Assembly/GRCh38.p13.102/index_build/genome_102"

# 1. Trim adapters using Cutadapt
echo "Running Cutadapt..."
cutadapt -a AGATCGGAAGAGC -A AGATCGGAAGAGC \
  -o ${SAMPLE}_R1_trimmed.fastq.gz -p ${SAMPLE}_R2_trimmed.fastq.gz \
  $R1 $R2 > ${SAMPLE}_cutadapt.log

# 2. Run FastQC on trimmed reads
echo "Running FastQC..."
fastqc ${SAMPLE}_R1_trimmed.fastq.gz ${SAMPLE}_R2_trimmed.fastq.gz

# 3. Summarize FastQC reports with MultiQC
echo "Running MultiQC..."
multiqc .

# 4. Align with HISAT2
echo "Running HISAT2..."
hisat2 -x $REF_INDEX \
  -1 ${SAMPLE}_R1_trimmed.fastq.gz -2 ${SAMPLE}_R2_trimmed.fastq.gz \
  -S ${SAMPLE}.sam 2> ${SAMPLE}_hisat2.log

# 5. Convert SAM to sorted BAM
echo "Converting SAM to sorted BAM..."
samtools view -h -b -u ${SAMPLE}.sam | samtools sort -n -o ${SAMPLE}_sorted.bam

# Optional: Clean up intermediate files to save space
# rm ${SAMPLE}.sam
