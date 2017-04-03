#!/bin/sh

mkdir hapmap

for number in {1..22}; do vcftools --gzvcf ./hapmap/hapmap_3.3.hg19.vcf.gz --keep indv.txt --chr chr$number --recode --out ./hapmap/hapmap_3.3.ceu.chr$number.hg19; done

for number in {1..22}; do gzip --keep ./hapmap/hapmap_3.3.ceu.chr$number.hg19.recode.vcf; done

cp /storage/benezra/hapmap/hapmap_3.3.hg19.vcf.gz ./hapmap/.
vcftools --gzvcf ./hapmap/hapmap_3.3.hg19.vcf.gz --keep indv.txt --not-chr chrX --recode --out ./hapmap/hapmap_3.3.ceu.hg19
gzip --keep ./hapmap/hapmap_3.3.ceu.hg19.recode.vcf
 
for number in {1..22}; do grep -P "^chr$number\t" ./hapmap/hapmap_3.3.ceu.hg19.recode.vcf | awk '{print $1"\t"$2}' | cut -c 4- > ./hapmap/$number.sites.txt; done

for number in {1..22}; do angsd sites index ./hapmap/$number.sites.txt; done

grep "^[^#;]" ./hapmap/hapmap_3.3.ceu.hg19.recode.vcf | awk '{print $1"\t"$2}' | cut -c 4- > ./hapmap/sites.txt
angsd sites index ./hapmap/sites.txt
