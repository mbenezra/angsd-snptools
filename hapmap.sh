#!/bin/sh

mkdir hapmap

cp /storage/benezra/hapmap/hapmap_3.3.hg19.vcf.gz ./hapmap/.
vcftools --gzvcf ./hapmap/hapmap_3.3.hg19.vcf.gz --keep indv.txt --not-chr chrX --recode --out ./hapmap/hapmap_3.3.ceu.hg19
gzip --keep ./hapmap/hapmap_3.3.ceu.hg19.recode.vcf
grep "^[^#;]" ./hapmap/hapmap_3.3.ceu.hg19.recode.vcf | awk '{print $1"\t"$2}' | cut -c 4- > ./hapmap/sites.txt
angsd sites index ./hapmap/sites.txt
