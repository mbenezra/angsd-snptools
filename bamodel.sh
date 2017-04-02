#!/bin/sh

for sample in `cat indv.txt`; do echo /storage/benezra/bin/snptools/bamodel $sample sites.vcf `grep $sample bams.list | tr '\n' ' '`; done > bamodel.txt

cat bamodel.txt | head -n 20 | tail -n 20 | parallel
wait
cat bamodel.txt | head -n 40 | tail -n 20 | parallel
wait
cat bamodel.txt | head -n 60 | tail -n 20 | parallel
wait
cat bamodel.txt | head -n 80 | tail -n 20 | parallel
wait
cat bamodel.txt | head -n 99 | tail -n 19 | parallel
