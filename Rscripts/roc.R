loadGeno <- function(file, indv) {
  geno <- read.table(file)
  row.names(geno) <- geno[,2]
  geno <- geno[,-c(1,2)]
  gl <- geno[,seq(2, 180, 2)]
  gt <- geno[,seq(1, 180, 2)]
  names(gl) <- indv
  names(gt) <- indv
  return (list("gt" = gt, "gl" = gl))
}

loadHapMapVCF <- function(file) {
  hapmap <- read.table(file)
  row.names(hapmap) <- hapmap[,2]
  hapmap <- hapmap[,c(4,5)]
  return(hapmap)
}  
  
loadHapMap012 <- function(file, indv, pos) {  
  hapmap.012 <- data.frame(t(read.table(file)))
  hapmap.indv <- read.table(indv)
  hapmap.pos <- read.table(pos)
  hapmap.012 <- hapmap.012[-1,]
  row.names(hapmap.012) <- hapmap.pos[,2]
  names(hapmap.012) <- hapmap.indv[,1]
  return (hapmap.012)
}

loadMafs <- function(file) {
  mafs <- read.table(file)
  row.names(mafs) <- mafs[,2]
  mafs <- mafs[-1,c(3,4)]
  return(mafs)
}

# compareMafsHapMap <- function(hapmap, mafs) {
#   ta<-table(c(unique(as.numeric(row.names(hapmap))),unique(as.numeric(row.names(mafs)))))
#   pos <- as.numeric(names(ta[ta==2]))
#   
#   true <- true[row.names(true)%in%pos,]
#   gt <- gt[row.names(gt)%in%pos,]
#   gl <- gl[row.names(gl)%in%pos,]
#   
#   true <- as.vector(unlist(true))
#   gt <- as.vector(unlist(gt))
#   gl <- as.vector(unlist(gl))
#   
# }

# INDIVIDUALS
indv <- read.table("../indv.txt")[,1]

chr21.vcf <- loadHapMapVCF("../hapmap/hapmap_3.3.ceu.chr21.hg19.vcf.gz")
snptools.uni.mafs <- loadMafs("../snptools_21/snptools.uni.chr21.mafs.gz")
snptools.freq.mafs <- loadMafs("../snptools_21/snptools.freq.chr21.mafs.gz")

ta<-table(c(unique(as.numeric(row.names(chr21.vcf))),unique(as.numeric(row.names(snptools.uni.mafs)))))
pos <- as.numeric(names(ta[ta==2]))

chr21.vcf <- chr21.vcf[row.names(chr21.vcf)%in%pos,]
snptools.uni.mafs <- snptools.uni.mafs[row.names(snptools.uni.mafs)%in%pos,]
snptools.freq.mafs <- snptools.freq.mafs[row.names(snptools.freq.mafs)%in%pos,]

chr21.vcf$one <- paste(trimws(chr21.vcf$V4), trimws(chr21.vcf$V5), sep = "")
snptools.uni.mafs$one <- paste(trimws(snptools.uni.mafs$V3), trimws(snptools.uni.mafs$V4), sep = "")

sum(chr21.vcf$one == snptools.uni.mafs$one)/17332


chr21.vcf.sorted <- t(apply(chr21.vcf, 1, sort))
snptools.uni.mafs.sorted <- t(apply(snptools.uni.mafs, 1, sort))

sum(as.character(unlist(chr21.vcf.sorted))!=as.character(unlist(snptools.uni.mafs.sorted)))


snptools.uni <- loadGeno("../snptools_21/snptools.uni.chr21.geno.gz", indv)
snptools.freq <- loadGeno("../snptools_21/snptools.freq.chr21.geno.gz", indv)

angsd.uni <- loadGeno("../angsd_21/angsd.uni.chr21.geno.gz", indv)
angsd.freq <- loadGeno("../angsd_21/angsd.freq.chr21.geno.gz", indv)

gatk.uni <- loadGeno("../gatk_21/gatk.uni.chr21.geno.gz", indv)
gatk.freq <- loadGeno("../gatk_21/gatk.freq.chr21.geno.gz", indv)

chr21.012 <- loadHapMap012("../hapmap/hapmap_3.3.CEU.chr21.hg19.012",
                        "../hapmap/hapmap_3.3.CEU.chr21.hg19.012.indv",
                        "../hapmap/hapmap_3.3.CEU.chr21.hg19.012.pos")

# chr21.012 <- data.frame(t(read.table("../hapmap/hapmap_3.3.CEU.chr21.hg19.012")))
# chr21.indv <- read.table("../hapmap/hapmap_3.3.CEU.chr21.hg19.012.indv")
# chr21.pos <- read.table("../hapmap/hapmap_3.3.CEU.chr21.hg19.012.pos")
# chr21.012 <- chr21.012[-1,]
# row.names(chr21.012) <- chr21.pos[,2]
# names(chr21.012) <- chr21.indv[,1]

# true <- chr21.012
# gt <- snptools.uni$gt
# gl <- snptools.uni$gl

roc <- function(true, gt, gl){
  ta <- table(c(unique(as.numeric(row.names(true))),unique(as.numeric(row.names(gt)))))
  pos <- as.numeric(names(ta[ta==2]))
  
  true <- true[row.names(true)%in%pos,]
  gt <- gt[row.names(gt)%in%pos,]
  gl <- gl[row.names(gl)%in%pos,]
  
  true <- as.vector(unlist(true))
  gt <- as.vector(unlist(gt))
  gl <- as.vector(unlist(gl))
  
  score <- gl
  trueSet <- as.vector(unlist(gt))==as.vector(unlist(true))
  ord <- order(score)
  trueSet <- trueSet[ord]
  sen <- cumsum(trueSet)/sum(trueSet)
  spe <- cumsum(!trueSet)/sum(!trueSet)

  return (list("sen" = sen, "spe" = spe))
}

snptools.uni.roc <- roc(chr21.012, snptools.uni$gt, snptools.uni$gl)
snptools.freq.roc <- roc(chr21.012, snptools.freq$gt, snptools.freq$gl)

angsd.uni.roc <- roc(chr21.012, angsd.uni$gt, angsd.uni$gl)
angsd.freq.roc <- roc(chr21.012, angsd.freq$gt, angsd.freq$gl)

gatk.uni.roc <- roc(chr21.012, gatk.uni$gt, gatk.uni$gl)
gatk.freq.roc <- roc(chr21.012, gatk.freq$gt, gatk.freq$gl)

plot(snptools.uni.roc$spe, snptools.uni.roc$sen, main = "ROC curve (chr21) - SNPTOOLS vs ANGSD vs GATK", xlab = "Specificity", ylab = "Sensitivity", col = "green", type = "l", xlim = c(0, 1), ylim = c(0, 1))
lines(snptools.freq.roc$spe, snptools.freq.roc$sen, col = "green", type = "l", lwd = 3)

lines(angsd.uni.roc$spe, angsd.uni.roc$sen, col = "red", type = "l")
lines(angsd.freq.roc$spe, angsd.freq.roc$sen, col = "red", type = "l", lwd = 3)

lines(gatk.uni.roc$spe, gatk.uni.roc$sen, col = "blue", type = "l")
lines(gatk.freq.roc$spe, gatk.freq.roc$sen, col = "blue", type = "l", lwd = 3)

legend("topleft", c("SNPTOOLS uniform", "SNPTOOLS allele freq", "ANGSD uniform", "ANGSD allele freq", "GATK uniform", "GATK allele freq"), lwd = c(1,3,1,3,1,3), lty = c(1,1,1,1,1,1), col=c("green", "green", "red", "red", "blue", "blue"))






# 
# score <- rnorm(1000)
# trueSet <- rbinom(1000,1,0.5)==1
# ord <- order(score)
# trueSet <- trueSet[ord]
# sen <- cumsum(trueSet)/sum(trueSet)
# spe <- cumsum(!trueSet)/sum(!trueSet)
# plot(x=spe,y=sen,type='l')


