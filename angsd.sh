#!/bin/sh

angsd -sites ./hapmap/sites.txt -bam bams.list -SNP_pval 0.001 -doMaf 2 -doMajorMinor 1 -doGeno 18 -doPost 2 -GL 1 -out angsd/angsd.uni

angsd -sites ./hapmap/sites.txt -bam bams.list -SNP_pval 0.001 -doMaf 2 -doMajorMinor 1 -doGeno 18 -doPost 1 -GL 1 -out angsd/angsd.freq

mkdir angsd

for number in {1..22}; do echo angsd -sites ./hapmap/$number.sites.txt -bam bams.list -doMaf 2 -doMajorMinor 1 -r $number: -doGeno 18 -doPost 2 -GL 1 -out angsd/angsd.uni.chr$number; done > angsd.uni.txt

cat angsd.uni.txt | parallel

for number in {1..22}; do echo angsd -sites ./hapmap/$number.sites.txt -bam bams.list -doMaf 2 -doMajorMinor 1 -r $number: -doGeno 18 -doPost 1 -GL 1 -out angsd/angsd.freq.chr$number; done > angsd.freq.txt

cat angsd.freq.txt | parallel
