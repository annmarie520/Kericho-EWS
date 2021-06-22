# Kericho-EWS
### Ann Marie
code to accompany Evidence of Critical Slowing Down Prior to Malaria Resurgence in Kericho, Kenya

This repository contains code to conduct all computations and generate all figures discussed in the manuscript:
Harris MJ, Hay SI, Drake JM. 2020 Evidence of Critical Slowing Down Prior to Malaria Resurgence in Kericho, Kenya (In Review).

All analyses were conducted in RStudio using R version 3.5.1

The script Kericho-Computations.R generates all computations used in this manuscript and saves them. All outputs of this script are also available in this repository, with variable names explained below. This uses the package spaero (version 0.4.0) and the dataset kericho.csv

The script Kericho-Figures.R generates all figures used in this manuscript and saves them. This script utilizes the files: kericho.csv, indics, cors, pvals, pvals_rf, pvals_tw, pvals_sa, and pvals_sa_spearman, pvals_rf_spearman. All nine files are provided in the Github. Each figure is separated into a self-contained section (demarcated by a comment with starting and ending ####). The figure sections and their required files and packages are as follows.

*	FIG 1: Time series with approach to criticality shaded – kericho.csv

*	FIG 2: Rolling forecast p-values - pvals_rf

*	SUPPLEMENTARY FIG S3: rolling forecast p-values for Spearman’s correlation coefficient – pvals_rf_spearman, pvals_rf

*	SUPPLEMENTARY FIGS S1.1-10: Significance Analyses/Heatmap of p-value - Notional Beginning of Approach to Criticality & Notional Month of Critical Transition – pvals_tw, kericho.csv, gplots (version 3.0.1) package, viridis (version 0.5.1) package

*	SUPPLEMENTARY FIGS S2.1-10: Significance Analyses/Heatmap of p-values  - Notional Month of Critical Transition & Bandwidth - pvals_sa, kericho.csv, gplots (version 3.0.1) package, viridis (version 0.5.1) package

*	Significance Analyses/Heatmap of p-value for Spearman coefficient (not included in manuscript/supplement) – pvals_sa_spearman, kericho.csv, gplots (version 3.0.1) package, viridis (version 0.5.1) package

*	SUPPLEMENTARY FIG S4: Line graphs of each rolling window statistic over time (top), null distributions of tau for each statistic with test value shaded (bottom) – pvals, cors, indics, kericho.csv

## VARIABLE NAMES

Monthly malaria incidence in Kericho, Kenya between January 1965 and November 2002 is given by kericho.csv

The table below gives variable names by the methods used to generate all sixteen intermediate data files (testing parameters by correlation coefficient used). Five intermediate files (cors_rf, cors_rf_spearman, cors_sa, cors_sa_spearman, and cors_tw) are excluded from this repository due to storage limitations and are available upon request.

|                                                                                                                  | <br>Correlation coefficient:<br>Kendall's τ | <br>Correlation Coefficient:<br>Spearman's ρ       |
|------------------------------------------------------------------------------------------------------------------|----------------------------------------------|----------------------------------------------------|
| TEST AT TRANSITION:<br>Bandwidth: 40<br>Notional month of critical<br>transition: Apr 1993                       | indics<br>cors<br>pvals<br>                  | indics<br>cors_spearman<br>pvals_spearman          |
| ROLLING FORECAST:<br>Bandwidth: 40<br>Month of EWS testing: <br>Feb 1984 - Apr 1994                              | indics*<br>cors_rf<br>pvals_rf               | indics*<br>cors_rf_spearman<br>pvals_rf_spearman   |
| SENSITIVITY ANALYSIS 1:<br>Bandwidth: 40<br>Month of EWS testing: <br>(Jly 81-May 82) - (Mar 93 - Jan 94)                              | cors_tw<br>pvals_tw               | N/A   |
| SENSITIVITY ANALYSIS 2:<br>Bandwidth: 35 - 45<br>Notional month of critical<br>transition: <br>Apr 1992 - Apr 1994 | indics_sa<br>cors_sa<br>pvals_sa<br>         | indics_sa<br>cors_sa_spearman<br>pvals_sa_spearman |


*Holds the indicator values from December 1981 through April 1994. Can be subset through a given n months after December 1981 using the command:
```indics <- lapply(indics, function(x) x[1:n]) ```

## VARIABLE FORMATS
```indics``` is a list with each element corresponding to a statistical indicator’s values from the Kericho data at each month of the analysis (December 1981 through April 1994). 

```indics_sa[[i]][[j]]``` subsets to a list with the same format as ```indics```, where the ith entry corresponds to a notional month of critical transition i months since March 1992 and the jth entry corresponds to a bandwidth size of 34+j (1 ≤ i ≤ 25 ; 1 ≤ j ≤ 11).

```cors``` and ```cors_spearman``` are matrices with 10,001 rows and 10 columns, with the first 10,000 rows reporting correlation coefficients for all ten indicators for the corresponding null model and the final row (cors[10001,]) giving the correlation coefficients for the Kericho data. 

```cors_rf``` and ```cors_rf_spearman``` are lists of length 96 where the ith entry corresponds to early warning signal testing beginning in December 1981 and ending i months after April 1985. Each entry of this list is a matrix with the same format as cors and cors_spearman. These files are not included in the repository and are available upon request due to storage limitations. 

```cors_tw[[i]][[j]]``` returns a matrix with the same format as cors, where the ith entry corresponds to a notional month of beginning of approach to criticality i months since November 1987 and the jth entry corresponds to a notional month of beginning of approach to criticality i months since March 1993 (1 ≤ i ≤ 11 ; 1 ≤ j ≤ 11). This is not included in the repository and is available upon request due to storage limitations.

```cors_sa[[i]][[j]]``` and ```cors_sa_spearman[[i]][[j]]``` returns a matrix with the same format as cors and cors_spearman, where the ith entry corresponds to a notional month of critical transition  i months since March 1992 and the jth entry corresponds to a bandwidth size of 34+j (1 ≤ i ≤ 25 ; 1 ≤ j ≤ 11). These files are not included in the repository and are available upon request due to storage limitations. 

```pvals``` and ```pvals_spearman``` returns a vector of the p-values corresponding to all ten indicators.

```pvals_rf``` and ```pvals_rf_spearman``` are lists of length 96 where the ith entry corresponds to early warning signal testing beginning in December 1981 and ending i months after April 1985. Each entry of this list is a vector with the same format as ```pvals``` and ```pvals_spearman```.

```pvals_tw[[i]][[j]]``` returns a vector with the same format as pvals, where the ith entry corresponds to a notional month of beginning of approach to criticality i months since November 1987 and the jth entry corresponds to a notional month of beginning of approach to criticality i months since March 1993 (1 ≤ i ≤ 11 ; 1 ≤ j ≤ 11).

```pvals_sa[[i]][[j]]``` and ```cors_sa_spearman[[i]][[j]]``` return a vector with the same format as pvals and pvals_spearman, where the ith entry corresponds to a notional month of critical transition  i months since March 1992 and the jth entry corresponds to a bandwidth size of 34+j (1 ≤ i ≤ 25 ; 1 ≤ j ≤ 11).


