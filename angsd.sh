#!/bin/sh

for number in {1..22}; do echo angsd -sites ./hapmap/sites.txt -bam bams.list -SNP_pval 0.001 -doMaf 2 -doMajorMinor 1 -r $number: -doGeno 18 -doPost 2 -GL 1 -out angsd.uni.chr$number; done > angsd.uni.txt

cat angsd.uni.txt | parallel

for number in {1..22}; do echo angsd -sites ./hapmap/sites.txt -bam bams.list -SNP_pval 0.001 -doMaf 2 -doMajorMinor 1 -r $number: -doGeno 18 -doPost 1 -GL 1 -out angsd.freq.chr$number; done > angsd.freq.txt

cat angsd.freq.txt | parallel
