#return Kendall's correlation coefficient (tau) to quantify each indicator's change over time
get_taus<-function(indic){
  len<-length(indic$autocorrelation)
  acor<-cor.test(indic$autocorrelation, 1:len,method="kendall")$estimate
  vcor<-cor.test(indic$variance, 1:len,method="kendall")$estimate
  dvcor<-cor.test(indic$variance_first_diff, 1:len,method="kendall")$estimate
  return(c(acor, vcor, dvcor))
}

#calculates p-value as the proportion of null observations with a value more extreme than that of the test statistic
significance<-function(cors){
  test.cor=tail(cors, n=1) #last entry is the test statistic for the Kericho value
  null.cor=cors[-length(cors)]
  numsig=length(which(null.cor>=test.cor))
  pvalue=numsig/length(null.cor)
  return(pvalue)
}

kericho <- read.csv("C:/Users/mjh68/OneDrive - University of Georgia/Drake/Kericho/kericho.csv")

beg=204
trend=c("local_constant", "local_linear")

pvals<-list()
test.cors<-list()
test.cors2<-list()


pvals<-list()
test.cors<-list()

#window of approach to criticality 
test<-kericho$BBK[beg:344]

#generate 10,000 null permutation
obs=list(length=10001)
obs[[10001]]<-test

set.seed(10022016)   
for (i in 1:10000){
  obs[[i]]<-sample(test, length(test), replace=FALSE)
} 

  
for(t in trend){
  #Use SPAERO to calculate rolling window statistics for each time series
  indicators<-lapply(obs, function(x) spaero::get_stats(x, center_kernel="gaussian", center_trend=t,center_bandwidth=40,stat_bandwidth=40)$stats)
  

  
  l.cors<-lapply(indicators, get_taus)
  cors<-do.call(rbind, l.cors)
  colnames(cors)<- c("autocorrelation", "variance", "variance_first_diff")
  
  
  #p-values and values of tau for the test data are stored for autocorrelation, variance, and variance 1st difference respectively
  pvals[[t]]<-apply(cors, 2, significance)
  test.cors[[t]]<-cors[10001,] 
}


#FIG 1: Time series with approach to criticality shaded
plot(kericho$BBK, main="Time Series of Malaria Incidence in Kericho", type="l", ylab="Cases Reported", xlab="Time", xaxt='n')
rect(beg,-15,344,391, density=20,col="light gray", border=NA)
lines(kericho$BBK)
box()
newyears=which(kericho$Month=="Jan")
axis(1, at = newyears, labels = 1965:2002, tick = TRUE)

#FIG 2: Line graphs of each rolling window statistic over time (left), null distributions of tau for each statistic with test value shaded (right)
par(mfcol=c(3,2)) 

#left column
plot(indicators[[10001]]$autocorrelation,type='l', main="Indicators During Approach to Criticality", cex.main=1.5, ylab="Autocorrelation", xlab=NA, cex.lab=1.5)
plot(indicators[[10001]]$variance,type='l', cex.main=1.5, ylab="Variance", xlab=NA, cex.lab=1.5)
plot(indicators[[10001]]$variance_first_diff,type='l', cex.main=1.5, ylab="First Difference of Variance", xlab="Time", cex.lab=1.5)


#right column
h<-hist(cors[1:10000,1], breaks=40, plot=FALSE)
bin<-cut(cors[10001,1], h$breaks)
clr<-rep("white",  length(h$counts))
clr[bin]<-"red"
plot(h, col=clr, main="Null Distribution of Tau", xlab=NA, ylab="Frequency", cex.lab=1.5, cex.axis=1.5, cex.main=1.5, cex.sub=1.5)


h<-hist(cors[1:10000,2], breaks=40, plot=FALSE)
bin<-cut(cors[10001,2], h$breaks)
clr<-rep("white",  length(h$counts))
clr[bin]<-"red"
plot(h, col=clr, xlab=NA, ylab="Frequency", main=NA,cex.lab=1.5, cex.axis=1.5, cex.main=1.5, cex.sub=1.5)


h<-hist(cors[1:10000,3], breaks=40, plot=FALSE)
bin<-cut(cors[10001,3], h$breaks)
clr<-rep("white",  length(h$counts))
clr[bin]<-"red"
plot(h, col=clr, xlab="Tau", ylab="Frequency", main=NA,cex.lab=1.5, cex.axis=1.5, cex.main=1.5, cex.sub=1.5)


