#!/bin/sh

angsd -sites ./hapmap/sites.txt -vcf-GL ./prob2vcf/out.vcf.gz -nInd 90 -SNP_pval 0.001 -doMajorMinor 1 -doGeno 18 -doPost 2 -out snptools/snptools.uni -fai ./hg19/hg19.fa.gz.fai -doMaf 1

angsd -sites ./hapmap/sites.txt -vcf-GL ./prob2vcf/out.vcf.gz -nInd 90 -SNP_pval 0.001 -doMajorMinor 1 -doGeno 18 -doPost 1 -out snptools/snptools.freq -fai ./hg19/hg19.fa.gz.fai -doMaf 1

mkdir snptools

for number in {1..22}; do echo angsd -sites ./hapmap/$number.sites.txt -vcf-GL ./prob2vcf/$number.out.vcf.gz -nInd 90 -doMajorMinor 1 -r $number: -doGeno 18 -doPost 2 -out snptools/snptools.uni.chr$number -fai ./hg19/chr$number.hg19.fa.gz.fai -doMaf 1; done > snptools.uni.txt

cat snptools.uni.txt | parallel

wait

for number in {1..22}; do echo angsd -sites ./hapmap/$number.sites.txt -vcf-GL ./prob2vcf/$number.out.vcf.gz -nInd 90 -doMajorMinor 1 -r $number: -doGeno 18 -doPost 1 -out snptools/snptools.freq.chr$number -fai ./hg19/chr$number.hg19.fa.gz.fai -doMaf 1; done > snptools.freq.txt

cat snptools.freq.txt | parallel
