#!/bin/sh

# BAMS
ls /home/thorfinn/data/1000g2/*CEU*.bam > bam.list
for indv in `cat indv.txt`; do grep $indv bam.list; done > bams.list

# HG19
sh hg19.sh

# HAPMAP
sh hapmap.sh

# PILEUP
sh pileup.sh

# VARISITE
sh varisite.sh

# BAMODEL
sh bamodel.sh

# POPROB
ls *.raw > raws.list
/storage/benezra/bin/snptools/poprob sites.vcf raws.list prob -b 25600

# PROB2VCF
sh prob2vcf.sh
