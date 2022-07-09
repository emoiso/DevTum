#/bin/bash
#Author Enrico Moiso
#mail: em.metaminer@gmail.com
#Script for the analysis of MGH FFPE derived RNA seq fastq

module load star/2.7.1a
module load perl/5.24.1
module load r/3.6.0
module load rsem/1.3.1

path_to_genome1='' #star 1st pass res
path_to_genome2='' #star 2nd pass res
path_to_genome_fa='' #path and filename of the genome fasta file GENCODE/v35_GRCh38.p13/GRCh38.p13.genome.fa
path_to_assembly='' #path to genomic assembly (specifically GENCODE/v35_GRCh38.p13)
path_to_gtf='' #path and filename of the genome GTF file GENCODE/v35_GRCh38.p13/gencode.v35.annotation.gtf
out=''
file='' #path to fastq files
path_to_bam1='' #path to 1st pass bam
path_to_bam2='' #path to 2nd pass bam

#STAR genome generation 1st pass
STAR \
--runMode genomeGenerate \
--runThreadN 30 \
--genomeDir $path_to_genome1 \
--genomeFastaFiles $path_to_genome_fa \
--sjdbGTFfile $path_to_gtf \
--sjdbOverhang 149

#STAR 1st genomic alignment
STAR \
--runThreadN 16 \
--genomeDir $path_to_genome1 \
--outFileNamePrefix ${out}_ \
--outFilterType BySJout --outFilterMultimapNmax 20 --alignSJoverhangMin 8 \
--alignSJDBoverhangMin 1 \
--outFilterMismatchNmax 999 \
--outFilterMismatchNoverLmax 0.04 \
--alignIntronMin 20 \
--alignIntronMax 1000000 \
--alignMatesGapMax 1000000 \
--readFilesIn ${file}_1_sequence.fastq ${file}_2_sequence.fastq 

#STAR genome generation 2nd pass
STAR \
--runMode genomeGenerate \
--runThreadN 30 \
--genomeDir $path_to_genome2 \
--genomeFastaFiles $path_to_genome_fa \
--sjdbGTFfile $path_to_gtf \
--sjdbFileChrStartEnd ${path_tobam1}/*_SJ.out.tab \
--limitSjdbInsertNsj 3000000 \ 
--sjdbOverhang 149

#START transcriptome aligment for rsem quantification
STAR \
--genomeDir $path_to_genome2/  \
--outSAMunmapped Within  \
--outFilterType BySJout  \
--outSAMattributes NH HI AS NM MD  \
--outFilterMultimapNmax 20  \
--outFilterMismatchNmax 999  \
--outFilterMismatchNoverLmax 0.04  \
--alignIntronMin 20  \
--alignIntronMax 1000000  \
--alignMatesGapMax 1000000  \
--alignSJoverhangMin 8  \
--alignSJDBoverhangMin 1  \
--sjdbScore 1  \
--runThreadN 16  \
--genomeLoad NoSharedMemory  \
--outSAMtype BAM Unsorted  \
--quantMode TranscriptomeSAM  \
--outSAMheaderHD \@HD VN:1.4 SO:unsorted  \
--outFileNamePrefix ${out}/star_  \
--outFilterScoreMinOverLread 0.3 \
--outFilterMatchNminOverLread 0.3 \
--readFilesIn ${file}_1_sequence.fastq ${file}_2_sequence.fastq

#RSEM reference genome
rsem-prepare-reference \
-p 30 \
--gtf $path_to_gtf 
--star --star-path /home/software/star/star-2.7.1a/bin/ $path_to_assembly
$path_to_rsem_genome

#RSEM gene expression calculation
rsem-calculate-expression \
-p 16 \
--bam \
--paired-end \
--no-bam-output \
--forward-prob 0.5 \
--seed 12345 \
$file  $path_to_rsem_genome ${out}/rsem_

