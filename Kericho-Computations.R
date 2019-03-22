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

kericho <- read.csv("kericho.csv")
beg=204

#lopp through potential end months from Apr 1992 through Apr 1994
for(end in 328:352){
  #window of approach to criticality 
  test<-kericho$BBK[beg:end]
  pvals[[end-327]]<-list()
  cors[[end-327]]<-list()
  indics[[end-327]]<-list()
  
  #generate 10,000 null permutations
  obs=list(length=10001)
  obs[[10001]]<-test
  
  set.seed(10022016) 
  for (i in 1:10000){
    obs[[i]]<-sample(test, length(test), replace=FALSE)
  } 
  
  #lopp through bandwidth sizes from 35 through 45
  
  for(bw in 35:45){
    #Use SPAERO to calculate rolling window statistics for each time series
    indicators<-lapply(obs, function(x) spaero::get_stats(x, center_kernel="gaussian", center_trend="local_constant",center_bandwidth=bw,stat_bandwidth=bw)$stats)
    
    #calculate correlation coefficients and store as matrix
    l.cors<-lapply(indicators, get_taus)
    the.cors<-do.call(rbind, l.cors)
    colnames(the.cors)<- c("autocorrelation", "variance", "variance_first_diff")
    
    #store as a list of lists, where the first index corresponds to critical window end month and the second index correponds to bandwidth size  
    pvals[[end-327]][[bw-34]]<-apply(the.cors, 2, significance)
    cors[[end-327]][[bw-34]]<-the.cors
    indics[[end-327]][[bw-34]]<-indicators[[10001]]
  }
  save(pvals, file=paste("pvals"))
  save(cors, file=paste("cors"))
  save(indics, file=paste("indics"))
}
