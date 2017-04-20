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

loadIt <- function(file, indv) {
  it <- read.table(file)
  row.names(it) <- it[,2]
  it <- it[,-c(1,2)]
  names(it) <- indv
  return(it)
}

indv <- read.table("../indv.txt")[,1]

hapmap.chr1 <- loadIt("../hapmap/hapmap.chr1.gt.gz", indv)

snptools.uni.chr1.gt <- loadIt("../snptools/snptools.uni.chr1.gt.gz", indv)
snptools.uni.chr1.gl <- loadIt("../snptools/snptools.uni.chr1.gl.gz", indv)
snptools.freq.chr1.gt <- loadIt("../snptools/snptools.freq.chr1.gt.gz", indv)
snptools.freq.chr1.gl <- loadIt("../snptools/snptools.freq.chr1.gl.gz", indv)

# angsd.uni.chr1.gt <- loadIt("../angsd/snptools.uni.chr1.gt.gz", indv)
# angsd.uni.chr1.gl <- loadIt("../angsd/snptools.uni.chr1.gl.gz", indv)
# angsd.freq.chr1.gt <- loadIt("../angsd/snptools.freq.chr1.gt.gz", indv)
# angsd.freq.chr1.gl <- loadIt("../angsd/snptools.freq.chr1.gl.gz", indv)
# 
# gatk.uni.chr1.gt <- loadIt("../gatk/snptools.uni.chr1.gt.gz", indv)
# gatk.uni.chr1.gl <- loadIt("../gatk/snptools.uni.chr1.gl.gz", indv)
# gatk.freq.chr1.gt <- loadIt("../gatk/snptools.freq.chr1.gt.gz", indv)
# gatk.freq.chr1.gl <- loadIt("../gatk/snptools.freq.chr1.gl.gz", indv)

snptools.uni.roc <- roc(hapmap.chr1, snptools.uni.chr1.gt, snptools.uni.chr1.gl)
snptools.freq.roc <- roc(hapmap.chr1, snptools.freq.chr1.gt, snptools.freq.chr1.gl)

# angsd.uni.roc <- roc(hapmap.chr1, angsd.uni.chr1.gt, angsd.uni.chr1.gl)
# angsd.freq.roc <- roc(hapmap.chr1, angsd.freq.chr1.gt, angsd.freq.chr1.gl)
# 
# gatk.uni.roc <- roc(hapmap.chr1, gatk.uni.chr1.gt, gatk.uni.chr1.gl)
# gatk.freq.roc <- roc(hapmap.chr1, gatk.freq.chr1.gt, gatk.freq.chr1.gl)


jpeg("roc.jpg")
plot(snptools.uni.roc$spe, snptools.uni.roc$sen, main = "ROC curve (chr1) - SNPTOOLS vs SAMTOOLS vs GATK", xlab = "Specificity", ylab = "Sensitivity", col = "green", type = "l", xlim = c(0, 1), ylim = c(0, 1))
lines(snptools.freq.roc$spe, snptools.freq.roc$sen, col = "green", type = "l", lwd = 3)
dev.off()

# lines(angsd.uni.roc$spe, angsd.uni.roc$sen, col = "red", type = "l")
# lines(angsd.freq.roc$spe, angsd.freq.roc$sen, col = "red", type = "l", lwd = 3)
# 
# lines(gatk.uni.roc$spe, gatk.uni.roc$sen, col = "blue", type = "l")
# lines(gatk.freq.roc$spe, gatk.freq.roc$sen, col = "blue", type = "l", lwd = 3)

legend("topleft", c("SNPTOOLS uniform", "SNPTOOLS allele freq", "SAMTOOLS uniform", "SAMTOOLS allele freq", "GATK uniform", "GATK allele freq"), lwd = c(1,3,1,3,1,3), lty = c(1,1,1,1,1,1), col=c("green", "green", "red", "red", "blue", "blue"))
