#!/bin/sh

for number in {1..22}; do echo /storage/benezra/bin/snptools/prob2vcf prob $number.out.vcf.gz $number; done > prob2vcf.txt
cat prob2vcf.txt | parallel
