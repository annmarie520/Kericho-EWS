kericho <- read.csv("kericho.csv")

#takes in a list of 10 indicators and returns 10 correlation coefficient to quantify each indicator's corresponding change over time

#len allows the user to adjust the length of the window over which the analyses are performed (by shifting the right endpoint)
#and is automatically set to the length of the time period defined as the approach to criicality (137 months from December 1981 to April 1993)

#cor allows the user to define select the correlation coefficient to use. "kendall" is the default and "spearman" may be alternatively used

get_cor_coeffs<-function(indic, len=FALSE, cor="kendall"){
  
  if(!len){
    len<-length(indic$autocorrelation)
  }
  
  else{
    len<-len
  }
  
  cor_coeffs<-lapply(indic, function(x) cor.test(tail(x, len), 1:len, method=cor)$estimate)
  names(cor_coeffs)<-names(indic)
  return(cor_coeffs)
}

#calculates p-value as the proportion of null observations with a value more extreme than that of the test statistic
significance<-function(cors){
  test.cor=as.numeric(tail(cors, n=1)) #last entry is the test statistic for the Kericho value
  null.cor=unlist(cors[-length(cors)])
  numsig=length(which(null.cor>=test.cor))
  pvalue=numsig/length(null.cor)
  return(pvalue)
}


####EWS TESTING: MAIN TEXT VERSION####
test<-kericho$BBK[204:340]

#generate 10,000 null permutations
obs<-list(length=10001)
obs[[10001]]<-test
  
set.seed(10022016) 
for (i in 1:10000){
  obs[[i]]<-sample(test, length(test), replace=FALSE)
} 


#Use SPAERO to calculate rolling window statistics for each time series#
indicators<-lapply(obs, function(x) spaero::get_stats(x, center_kernel="gaussian", center_trend="local_constant",center_bandwidth=40,stat_bandwidth=40)$stats)

#calculate correlation coefficients and store as matrix
l.cors<-lapply(indicators, function(x) unlist(get_cor_coeffs(x)))
cors<-do.call(rbind, l.cors)
colnames(cors)<-names(l.cors[[1]])

#store final pvalues, test indicators 
pvals<-apply(cors, 2, significance)
indics<-indicators[[10001]]

save(pvals, file="pvals")
save(cors, file="cors")
save(indics, file="indics")
 
#calculate Spearman correlation coefficients and store as matrix
l.cors_spearman<-lapply(indicators, function(x) unlist(get_cor_coeffs(x, cor="spearman")))
cors_spearman<-do.call(rbind, l.cors_spearman)
colnames(cors_spearman)<-names(l.cors_spearman[[1]])

#store final pvalues, test indicators 
pvals_spearman<-apply(cors, 2, significance)

save(pvals_spearman, file="pvals_spearman")
save(cors_spearman, file="cors_spearman")

####ROLLING FORECAST####
test<-kericho$BBK[204:340]

#generate 10,000 null permutations
obs<-list(length=10001)
obs[[10001]]<-test

set.seed(10022016) 
for (i in 1:10000){
  obs[[i]]<-sample(test, length(test), replace=FALSE)
} 


#use SPAERO to calculate rolling window statistics for each time series
indicators<-lapply(obs, function(x) spaero::get_stats(x, center_kernel="gaussian", center_trend="local_constant",center_bandwidth=40,stat_bandwidth=40)$stats)

#calculate correlation coefficients and store as matrix
l.cors_rf<-lapply(28:length(indicators[[1]]), function(n) lapply(indicators, function(indic) get_cor_coeffs(indic, n)))
cors_rf<-lapply(l.cors_rf, function(x) do.call(rbind, x))
cors_rf<-lapply(cors_rf, function(x) {colnames(x) <-names(indicators[[1]]);x})

#store final pvalues, test indicators 
pvals_rf<-lapply(cors_rf, function(x) apply(x, 2, significance))

save(pvals_rf, file="pvals_rf")
save(cors_rf, file="cors_rf")

#calculate spearman correlation coefficients and store as matrix
l.cors_rf_spearman<-lapply(28:length(indicators[[1]]), function(n) lapply(indicators, function(indic) get_cor_coeffs(indic, n, cor="spearman")))
cors_rf_spearman<-lapply(l.cors_rf_spearman, function(x) do.call(rbind, x))
cors_rf_spearman<-lapply(cors_rf_spearman, function(x) {colnames(x) <-names(indicators[[1]]);x})

#store final pvalues, test indicators 
pvals_rf_spearman<-lapply(cors_rf_spearman, function(x) apply(x, 2, significance))

save(pvals_rf, file="pvals_rf_spearman")
save(cors_rf, file="cors_rf_spearman")

####SENSITIVITY ANALYSIS####
#loop through potential end months from Apr 1992 through Apr 1994
kericho <- read.csv("kericho.csv")
beg=204

pvals_sa<-list()
cors_sa<-list()
indics_sa<-list()

for(end in 328:352){
  #window of approach to criticality 
  test_sa<-kericho$BBK[beg:end]
  pvals_sa[[end-327]]<-list()
  cors_sa[[end-327]]<-list()
  indics_sa[[end-327]]<-list()
  
  pvals_sa_spearman[[end-327]]<-list()
  cors_sa_spearman[[end-327]]<-list()
  #generate 10,000 null permutations
  obs_sa<-list(length=10001)
  obs_sa[[10001]]<-test_sa
  
  set.seed(10022016) 
  for (i in 1:10000){
    obs_sa[[i]]<-sample(test_sa, length(test_sa), replace=FALSE)
  } 
  
  #loop through bandwidth sizes from 35 through 45
  
  for(bw in 35:45){
    #Use SPAERO to calculate rolling window statistics for each time series
    indicators_sa<-lapply(obs_sa, function(x) spaero::get_stats(x, center_kernel="gaussian", center_trend="local_constant",center_bandwidth=bw,stat_bandwidth=bw)$stats)
    
    #calculate correlation coefficients and store as matrix
    l.cors_sa<-lapply(indicators_sa, get_cor_coeffs)
    the.cors_sa<-do.call(rbind, l.cors_sa)
    colnames(the.cors_sa)<-names(l.cors_sa[[1]])
    
    #store as a list of lists, where the first index corresponds to critical window end month and the second index correponds to bandwidth size  
    pvals_sa[[end-327]][[bw-34]]<-apply(the.cors_sa, 2, significance)
    cors_sa[[end-327]][[bw-34]]<-the.cors_sa
    indics_sa[[end-327]][[bw-34]]<-indicators_sa[[10001]]
    
    #calculate spearman correlation coefficients and store as matrix
    l.cors_sa_spearman<-lapply(indicators_sa, function(x) get_cor_coeffs(x, cor="spearman"))
    the.cors_sa_spearman<-do.call(rbind, l.cors_sa_spearman)
    colnames(the.cors_sa_spearman)<-names(l.cors_sa_spearman[[1]])
    
    #store as a list of lists, where the first index corresponds to critical window end month and the second index correponds to bandwidth size  
    pvals_sa_spearman[[end-327]][[bw-34]]<-apply(the.cors_sa_spearman, 2, significance)
    cors_sa_spearman[[end-327]][[bw-34]]<-the.cors_sa_spearman
  }
  save(pvals_sa_spearman, file="pvals_sa_spearman")
  save(cors_sa_spearman, file="cors_sa_spearman")
}
