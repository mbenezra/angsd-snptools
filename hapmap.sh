#!/bin/sh

cp /storage/benezra/hapmap/hapmap_3.3.hg19.vcf.gz .
vcftools --gzvcf hapmap_3.3.hg19.vcf.gz --keep indv.txt --recode --out hapmap_3.3.ceu.hg19
gzip --keep hapmap_3.3.ceu.hg19.recode.vcf
grep "^[^#;]" hapmap_3.3.ceu.hg19.recode.vcf | awk '{print $1"\t"$2}' > sites.txt
angsd sites index sites.txt
