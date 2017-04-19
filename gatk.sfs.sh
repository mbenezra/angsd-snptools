#!/bin/sh

mkdir sfs

less -S bams.list | head -n 10 > ./sfs/CEU.filelist

FILTERS="-minMapQ 30 -minQ 20 -minInd 8"

OPT=" -dosaf 1 -gl 2"

#angsd -r 21: -b ./sfs/CEU.filelist -anc ./hg19anc/chimpHg19.fa.gz -out ./sfs/gatk.ceu $FILTERS $OPT -ref ./hg19/hg19.fa.gz 

angsd -sites ./prob2vcf/sites.txt -b ./sfs/CEU.filelist -anc ./hg19anc/chimpHg19.fa.gz -out ./sfs/gatk.ceu $FILTERS $OPT -ref ./hg19/hg19.fa.gz

realSFS ./sfs/gatk.ceu.saf.idx > ./sfs/gatk.ceu.sfs
