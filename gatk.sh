#!/bin/sh

angsd -sites ./hapmap/sites.txt -bam bams.list -SNP_pval 0.001 -doMaf 2 -doMajorMinor 1 -doGeno 18 -doPost 2 -GL 2 -out gatk/gatk.uni

angsd -sites ./hapmap/sites.txt -bam bams.list -SNP_pval 0.001 -doMaf 2 -doMajorMinor 1 -doGeno 18 -doPost 1 -GL 2 -out gatk/gatk.freq

mkdir gatk

for number in {1..22}; do echo angsd -sites ./hapmap/$number.sites.txt -bam bams.list -doMaf 2 -doMajorMinor 1 -r $number: -doGeno 18 -doPost 2 -GL 2 -out gatk/gatk.uni.chr$number; done > gatk.uni.txt

cat gatk.uni.txt | parallel

for number in {1..22}; do echo angsd -sites ./hapmap/$number.sites.txt -bam bams.list -doMaf 2 -doMajorMinor 1 -r $number: -doGeno 18 -doPost 1 -GL 2 -out gatk/gatk.freq.chr$number; done > gatk.freq.txt

cat gatk.freq.txt | parallel
