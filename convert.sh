#!/bin/sh

# AA AC AG AT
# CA CC CG CT
# GA GC GG GT
# TA TC TG TT

# sed -i 's/AA/AA/g' snptools.uni.chr22.geno
sed -i 's/AC/AC/g' snptools.uni.chr22.geno
# sed -i 's/AG/AG/g' snptools.uni.chr22.geno
# sed -i 's/AT/AT/g' snptools.uni.chr22.geno

sed -i 's/CA/AC/g' snptools.uni.chr22.geno
# sed -i 's/CC/CC/g' snptools.uni.chr22.geno
# sed -i 's/CG/CG/g' snptools.uni.chr22.geno
# sed -i 's/CT/CT/g' snptools.uni.chr22.geno

sed -i 's/GA/AG/g' snptools.uni.chr22.geno
sed -i 's/GC/CG/g' snptools.uni.chr22.geno
# sed -i 's/GG/GG/g' snptools.uni.chr22.geno
# sed -i 's/GT/GT/g' snptools.uni.chr22.geno

sed -i 's/TA/AT/g' snptools.uni.chr22.geno
sed -i 's/TC/CT/g' snptools.uni.chr22.geno
sed -i 's/TG/GT/g' snptools.uni.chr22.geno
# sed -i 's/TT/TT/g' snptools.uni.chr22.geno
