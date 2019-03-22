load("pvals")
load("cors")
load("indics")
library(gplots)

pval<-list()
pval$acf<-pval$var<-pval$dv<-matrix(nrow=11, ncol=25)
for(bw in 1:11){
  for(end in 1:25){
    pval$acf[bw,end]<-pvals[[end]][[bw]][1]
    pval$var[bw,end]<-pvals[[end]][[bw]][2]
    pval$dv[bw,end]<-pvals[[end]][[bw]][3]
  }
}


#Significance Analyses: Heatmap of P-Values
times<-sapply(328:352, function(x) paste(kericho$Month[x], substr(toString(kericho$YYYY[x]),3,4)))
heatmap.2(pval$acf, colsep=c(12,13), rowsep=c(5,6), main="Autocorrelation", col=terrain.colors(500), labCol=times, labRow=35:45, ylab="Bandwidth", Rowv=FALSE, Colv=FALSE, dendrogram="none", trace="none", cellnote=round(pval$acf, digits=3), notecol="black", sepcolor="white", scale="none")
heatmap.2(pval$var, colsep=c(12,13), rowsep=c(5,6), main="Variance", col=terrain.colors(500), labCol=times, labRow=35:45, ylab="Bandwidth", Rowv=FALSE, Colv=FALSE, dendrogram="none", trace="none", cellnote=round(pval$var, digits=3), notecol="black", sepcolor="white", scale="none")
heatmap.2(pval$dv, colsep=c(12,13), rowsep=c(5,6),main="Second Difference of Variance", col=terrain.colors(500), labCol=times, labRow=35:45, ylab="Bandwidth", Rowv=FALSE, Colv=FALSE, dendrogram="none", trace="none", cellnote=round(pval$dv, digits=3), notecol="black", sepcolor="white", scale="none")


#Significance Analyses: Across the rows are the statistical indicators. The top row shows variation in end of critical window and the bottom rows shows variation in bandwidth. 
par(mfrow=c(2,3))
col<-c(rep("black",12),"red",rep("black",12))
plot(pval$acf[5,], xaxt="n",ylab="P-Value", main="Autocorrelation", col=col, xlab=NA)
axis(1, at=1:25, labels=times, las=2)
mtext("Month of Critical Transition", side=1, line=4, cex=.8)

plot(pval$var[5,], xaxt="n",ylab="P-Value", main="Variance", col=col, xlab=NA)
axis(1, at=1:25, labels=times, las=2)
mtext("Month of Critical Transition", side=1, line=4, cex=.8)

plot(pval$dv[5,], xaxt="n", ylab="P-Value", main="First Difference of Variance", col=col, xlab=NA)
axis(1, at=1:25, labels=times, las=2)
mtext("Month of Critical Transition", side=1, line=4, cex=.8)

col=c(rep("black",5),"red",rep("black",5))
plot(35:45, pval$acf[,13], ylab="P-Value",col=col, xlab="Bandwidth", main="Autocorrelation")

plot(35:45, pval$var[,13], ylab="P-Value",col=col, xlab="Bandwidth", main="Variance")

plot(35:45, pval$dv[,13],  ylab="P-Value",col=col, xlab="Bandwidth", main="First Difference of Variance")

#FIG 1: Time series with approach to criticality shaded
par(mfrow=c(1,1))
plot(kericho$BBK, main="Time Series of Malaria Incidence in Kericho", type="h", ylab="Cases Reported", xlab="Time", xaxt='n', ylim=c(0, 400), cex.main=2, cex.lab=1.5, cex.axis=1.5)
rect(beg,-30,344,450, col="gray", border=NA)
box()
lines(kericho$BBK, type="h")
lines(345:415, kericho$BBK[345:415], type="h", lwd=2)
lines(x=c(2, 2, 30), y=c(65, 70, 70))
lines(x=c(174,202, 202), y=c(70, 70, 65))
text(x=c(102,230), y=c(70, 120), labels=c("Disease free equilibrium", "Drug \nresistance \ndevelops"), cex=1.2)
text(x=274, y=270, labels="Approach to Criticality", cex=1.8)
text(x=380, y=390, labels="Resurgence", cex=1.2)
lines(x=c(345,345,354), y=c(385, 390, 390))
lines(x=c(406,415,415), y=c(390, 390, 385))

newyears=which(kericho$Month=="Jan")
axis(1, at = newyears, labels = 1965:2002, tick = TRUE,cex.axis=1.5, cex.lab=1.5)

#FIG 2: Line graphs of each rolling window statistic over time (left), null distributions of tau for each statistic with test value shaded (right)
par(mfcol=c(3,2), mai=c(0.82,0.82,0.42,1.2))
newyears2<-newyears[18:29]-beg+1

the_cors<-cors[[13]][[6]]
the_indics<-indics[[13]][[6]]

#Returns values: correlation coefficients and P-Values
the_cors[10001,]
pvals[[13]][[6]]

#left column: rowlling window statistics over time, overlaying case data
plot(204:340, kericho$BBK[204:340]*.5, type="h", cex.main=1.5, xlab=NA, ylim=c(0,100), ylab="Number of cases reported", xaxt='n', cex.lab=1.5)
axis(1, at=newyears, labels = 1965:2002)
par(new = T)
plot(the_indics$autocorrelation,type='l', main="Indicators During Approach to Criticality", axes=F, ylab=NA, xlab=NA, lwd=2, ylim=c(.25, .7),col="red")
axis(side = 4)
mtext(side = 4, line = 3, "Autocorrelation")

plot(204:340, kericho$BBK[204:340]*.5, type="h", cex.main=1.5, xlab=NA, ylim=c(0,100), ylab="Number of cases reported", xaxt='n', cex.lab=1.5)
axis(1, at=newyears, labels = 1965:2002)
par(new = T)
plot(the_indics$variance,type='l', main="Indicators During Approach to Criticality", axes=F, ylab=NA, xlab=NA, lwd=2,col="red")
axis(side = 4)
mtext(side = 4, line = 3, "Variance")

plot(204:340, kericho$BBK[204:340]*.5, type="h", cex.main=1.5, xlab=NA, ylim=c(0,100), ylab="Number of cases reported", xaxt='n', cex.lab=1.5)
axis(1, at=newyears, labels = 1965:2002)
par(new = T)
plot(the_indics$variance_first_diff,type='l', main="Indicators During Approach to Criticality", axes=F, ylab=NA, xlab=NA, lwd=2, ylim=c(-50,150), col="red")
axis(side = 4)
mtext(side = 4, line = 3, "First Difference of Variance")

#right column: null distribution of correlation coefficients, with test statistics given in red
h<-hist(the_cors[1:10000,1], breaks=40, plot=FALSE)
bin<-cut(the_cors[10001,1], h$breaks)
clr<-rep("white",  length(h$counts))
clr[bin]<-"red"
plot(h, col=clr, main="Null Distribution of Tau", xlab=NA, ylab="Frequency", cex.lab=1.5, cex.axis=1.5, cex.main=1.5, cex.sub=1.5)


h<-hist(the_cors[1:10000,2], breaks=40, plot=FALSE)
bin<-cut(the_cors[10001,2], h$breaks)
clr<-rep("white",  length(h$counts))
clr[bin]<-"red"
plot(h, col=clr, xlab=NA, ylab="Frequency", main=NA,cex.lab=1.5, cex.axis=1.5, cex.main=1.5, cex.sub=1.5)


h<-hist(the_cors[1:10000,3], breaks=40, plot=FALSE)
bin<-cut(the_cors[10001,3], h$breaks)
clr<-rep("white",  length(h$counts))
clr[bin]<-"red"
plot(h, col=clr, xlab="Tau", ylab="Frequency", main=NA,cex.lab=1.5, cex.axis=1.5, cex.main=1.5, cex.sub=1.5)


