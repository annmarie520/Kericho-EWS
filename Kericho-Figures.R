####FIG 1: Time series with approach to criticality shaded####
kericho<-read.csv("kericho.csv")
par(mfrow=c(1,1))
plot(kericho$BBK, main="Time Series of Malaria Incidence in Kericho", type="h", ylab="Cases Reported", xlab="Time", xaxt='n', ylim=c(0, 400), cex.main=2, cex.lab=1.5, cex.axis=1.5)
rect(204,-30,340,450, col="gray", border=NA)
box()
lines(kericho$BBK, type="h")
lines(341:415, kericho$BBK[341:415], type="h", lwd=2)
lines(x=c(2, 2, 30), y=c(65, 70, 70))
lines(x=c(174,202, 202), y=c(70, 70, 65))
text(x=c(102,230), y=c(70, 120), labels=c("Disease free equilibrium", "Drug \nresistance \ndevelops"), cex=1.2)
text(x=274, y=270, labels="Approach to Criticality", cex=1.8)
text(x=380, y=390, labels="Resurgence", cex=1.2)
lines(x=c(345,345,354), y=c(385, 390, 390))
lines(x=c(406,415,415), y=c(390, 390, 385))

newyears=which(kericho$Month=="Jan")
axis(1, at = newyears, labels = 1965:2002, tick = TRUE,cex.axis=1.5, cex.lab=1.5)

####FIG 2: Line graphs of each rolling window statistic over time (top), null distributions of tau for each statistic with test value shaded (bottom)####
load("pvals")
load("cors")
load("indics")
kericho<-read.csv("kericho.csv")

par(mfcol=c(3,2), mai=c(0.82,0.82,0.42,1.2))
newyears=which(kericho$Month=="Jan")
newyears2<-newyears[18:29]-beg+1


#top half: rolling window statistics over time, overlaying case data
par(mfrow=c(4, 5), mai = c(.5, 0.6, .5,.5))
for(i in 1:10){  
  plot(204:340, kericho$BBK[204:340]*.5, main=names(indics)[i], type="h", cex.main=1.5, cex.axis=1.2, xlab=NA, ylim=c(0,100), ylab="Cases", xaxt='n', cex.lab=1.5)
  axis(1, at=newyears, labels = 65:102, cex.axis=1.5)
  par(new = T)
  plot(indics[[i]],type='l', main=NA, axes=F, ylab=NA, xlab="Time (Years)", lwd=2, col="red", cex.lab=1.5)
  axis(side = 4, cex.axis=1.2)
}

#bottom half: null distribution of correlation coefficients, with test statistics given in red
for(i in 1:10){
  h<-hist(as.numeric(cors[1:10000,i]), breaks=40, plot=FALSE)
  bin<-cut(as.numeric(cors[10001,i]), h$breaks)
  clr<-rep("white",  length(h$counts))
  clr[bin]<-"red"
  plot(h, col=clr, main=colnames(cors)[i], xlab=NA, ylab="Frequency", cex.lab=1.5, cex.axis=1.2, cex.main=1.5, cex.sub=1.5)
}


####FIG 3: Rolling forecast p-values####
load("pvals_rf")

par(mfrow=c(5,2))
for(i in 1:10){
  plot(sapply(pvals_rf, function(x) x[[i]]), xaxt='n', lwd=2, cex.main=2, cex.lab=1.5, cex.axis=1.2, xlab="Time to Transition (Months)", ylab=NA, ylim=c(0,.3), main=names(pvals_rf[[1]][i]), type="l")
  abline(h=.05, col="red", lty=2)
  abline(h=.01, col="red", lty=3)
  axis(side=1, at=seq(0,length(pvals_rf), by=12), labels=seq(length(pvals_rf),0, by=-12), cex.axis=1.2)
  dev.copy(png, "fig3.png", width = 1200, height = 1325)
  dev.off()
}

####SUPPLEMENTARY FIG S3: : rolling forecast p-values for Spearman’s correlation coefficient####
load("pvals_rf_spearman")
load("pvals_rf")
par(mfrow=c(5,2))
for(i in 1:10){
  plot(sapply(pvals_rf_spearman, function(x) x[[i]]), xaxt='n', lwd=2, cex.main=2, cex.lab=1.5, cex.axis=1.2, xlab="Time to Transition (Months)", ylab="p-value", ylim=c(0,.3), main=names(pvals_rf[[1]][i]), type="l", col="blue", lty=3)
  lines(sapply(pvals_rf, function(x) x[[i]]))
  abline(h=.05, col="red", lty=2)
  abline(h=.01, col="red", lty=3)
  axis(side=1, at=seq(0,length(pvals_rf_spearman), by=12), labels=seq(length(pvals_rf),0, by=-12), cex.axis=1.2)
  dev.copy(png, "figs3.png", width = 1200, height = 1325)
  dev.off()
}



####SUPPLEMENTARY FIGS S1.1-10: Significance Analyses/Heatmap of p-values - Notional Beginning of Approach to Criticality & Notional Month of Critical Transition####
#will automatically save plots as pngs with prefix "heatmap"
library(gplots)
library(viridis)

load("pvals_tw")
kericho <- read.csv("kericho.csv")
stat_names<-names(pvals_tw[[1]][[1]])

pval<-lapply(1:10, matrix, data=NA, nrow=11, ncol=11)
names(pval)<-stat_names

for(beg in 1:11){
  for(end in 1:11){
    for(stat in stat_names){
      pval[[stat]][end,beg]<-pvals_tw[[beg]][[end]][[stat]]
    }
  }
}

times<-sapply(c(199:209, 335:345), function(x) paste(kericho$Month[x], substr(toString(kericho$YYYY[x]),3,4)))

for(i in 1:length(pval)){
  mat<-pval[[i]]
  mat2<-apply(mat,2,rev) #reflects matrix, intermediate in properly transforming matrix to recolor cell notes
  heatmap.2(mat, notecex=1.2, colsep=c(5,6), cex.main=3, lmat = rbind(c(0,3,0),c(0,1,1),c(2,4,0)), rowsep=c(5,6), key.xlab="p-value", key.title="", breaks=0:500*.0005, col=viridis(500), labRow=times[12:22], labCol=times[1:11], Rowv=FALSE, Colv=FALSE, dendrogram="none", trace="none", cellnote=format(round(mat, digits=3), nsmall = 3) , notecol=t(ifelse(mat2>.2,"black", "white")), sepcolor="white", scale="none", lwid = c(.3, 4,.5), lhei=c(.5,4,1), cexRow=1.5, cexCol=1.5, key=TRUE, density.info="none", main=paste("                     ", names(pval[i])), keysize=3, key.par=list(cex.axis=1.5, cex.lab=1.5))
  dev.copy(png, paste("heatmap_tw", i, '.png', sep=""), width = 600, height = 600)
  dev.off()
}

####SUPPLEMENTARY FIGS S2.1-10: Significance Analyses/Heatmap of p-values - Notional Month of Critical Transition & Bandwidth####
#will automatically save plots as pngs with prefix "heatmap"
library(gplots)
library(viridis)

load("pvals_sa")
kericho <- read.csv("kericho.csv")
stat_names<-names(pvals_sa[[1]][[1]])

pval<-lapply(1:10, matrix, data=NA, nrow=11, ncol=25)
names(pval)<-stat_names

for(bw in 1:11){
  for(end in 1:25){
    for(stat in stat_names){
      pval[[stat]][bw,end]<-pvals_sa[[end]][[bw]][[stat]]
    }
  }
}

times<-sapply(328:352, function(x) paste(kericho$Month[x], substr(toString(kericho$YYYY[x]),3,4)))

for(i in 1:length(pval)){
  mat<-pval[[i]]
  mat2<-apply(mat,2,rev) #reflects matrix, intermediate in properly transforming matrix to recolor cell notes
  heatmap.2(mat, notecex=1.2, colsep=c(12,13),lmat = rbind(c(0,3,0),c(0,1,1),c(2,4,0)), rowsep=c(5,6), key.xlab="p-value", key.title="", breaks=0:500*.0005, col=viridis(500), labCol=times, labRow=35:45, Rowv=FALSE, Colv=FALSE, dendrogram="none", trace="none", cellnote=format(round(mat, digits=3), nsmall = 3) , notecol=t(ifelse(mat2>.2,"black", "white")), sepcolor="white", scale="none", lwid = c(.3, 4,.5), lhei=c(.5,4,1), cexRow=1.5, cexCol=1.5, key=TRUE, density.info="none", main=paste("                     ", names(pval[i])), keysize=3, key.par=list(cex.axis=1.5, cex.lab=1.5))
  dev.copy(png, paste("heatmap_sa", i, '.png', sep=""), width = 960, height = 640)
  dev.off()
}


####Significance Analyses/Heatmap of p-values for Spearman coefficient (not included in manuscript/supplement)####
#will automatically save plots as pngs with prefix "heatmap_spearman"
library(gplots)
library(viridis)
load("pvals_sa_spearman")
kericho <- read.csv("kericho.csv")
stat_names<-names(pvals_sa_spearman[[1]][[1]])

pval<-lapply(1:10, matrix, data=NA, nrow=11, ncol=25)
names(pval)<-stat_names

for(bw in 1:11){
  for(end in 1:25){
    for(stat in stat_names){
      pval[[stat]][bw,end]<-pvals_sa_spearman[[end]][[bw]][[stat]]
    }
  }
}

times<-sapply(328:352, function(x) paste(kericho$Month[x], substr(toString(kericho$YYYY[x]),3,4)))

for(i in 1:length(pval)){
  mat<-pval[[i]]
  mat2<-apply(mat,2,rev) #reflects matrix, intermediate in properly transforming matrix to recolor cell notes
  heatmap.2(mat, notecex=1.2, colsep=c(12,13),lmat = rbind(c(0,3,0),c(0,1,1),c(2,4,0)), rowsep=c(5,6), key.xlab="p-value", key.title="", breaks=0:500*.0005, col=viridis(500), labCol=times, labRow=35:45, Rowv=FALSE, Colv=FALSE, dendrogram="none", trace="none", cellnote=format(round(mat, digits=3), nsmall = 3) , notecol=t(ifelse(mat2>.2,"black", "white")), sepcolor="white", scale="none", lwid = c(.3, 4,.5), lhei=c(.5,4,1), cexRow=1.5, cexCol=1.5, key=TRUE, density.info="none", main=paste("                     ", names(pval[i])), keysize=3, key.par=list(cex.axis=1.5, cex.lab=1.5))
  dev.copy(png, paste("heatmap_spearman", i, '.png', sep=""), width = 960, height = 640)
  dev.off()
}

