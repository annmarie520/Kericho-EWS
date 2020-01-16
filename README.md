# Kericho-EWS
code to accompany Evidence of Critical Slowing Down Prior to Malaria Resurgence in Kericho, Kenya


```{r eval=TRUE, echo=FALSE}
mat<-rbind(c(paste("indics","cors","pvals", sep="\n"), 
             paste("indics","cors_spearman","pvals_spearman", sep="\n")),
           c(paste("indics_sa","cors_sa","pvals_sa", sep="\n"), 
             paste("indics_sa","cors_sa_spearman","pvals_sa_spearman", sep="\n")),
            c(paste("indics*","cors_rf,"pvals_rf", sep="\n"), 
             paste("indics*","cors_rf_spearman","pvals_rf_spearman", sep="\n"))
)

colnames(mat)<-c(paste("Correlation Coefficient:",\n,"Kendall's ", \tau, sep="",
                 paste("Correlation Coefficient:",\n,"Spearman's ", \rho, sep=""
)

rownames(mat)<-c(paste("TEST AT TRANSITION:", "Bandwidth: 40", "Notional month of critical transition: Apr 1993", sep="\n"),
                 paste("SENSITIVITY ANALYSIS:", "Bandwidth: 35 - 45", "Notional month of critical transition:", Apr 1992 - Apr 1994", sep="\n"),
                 paste("ROLLING FORECAST:", "Bandwidth: 40", "Month of EWS testing:", "Feb 1984 - Apr 1994" sep="\n")
)

library(knitr)
kable(mat) 
```

