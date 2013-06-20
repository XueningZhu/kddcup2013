#nohup Rscript AA.AP.R &> AA.AP_log &
#ps 3172
source("~/KDDCUP2013_SYSU/R code/GetFeatures/listMultiplication.R")

setwd("~/kdd_data/rda/")

load("aut_papind.rda")
load("pap_autind.rda")
load("train.rda")
load("com_aut2.rda")
load("com_all.rda")
load("comC.rda")
load("comJ.rda")

#pap_autind[[train$papind2[i]]]
AA.AP=apply(train[,c(8,3)],1,AB_BBApply,com_all,com_aut2,pap_autind)
save(AA.AP,file="AA.AP.rda")
