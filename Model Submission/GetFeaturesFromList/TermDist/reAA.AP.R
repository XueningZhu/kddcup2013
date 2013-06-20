#nohup Rscript reAA.AP.R &> reAA.AP_log &
#ps 6728
source("~/KDDCUP2013_SYSU/R code/GetFeatures/listMultiplication.R")

setwd("~/kdd_data/rda/")

load("aut_papind.rda")
load("pap_autind.rda")
load("train.rda")
load("recom_aut2.rda")
load("recom_all.rda")
load("recomC.rda")
load("recomJ.rda")

#pap_autind[[train$papind2[i]]]
reAA.AP=apply(train[,c(8,3)],1,AB_BBApply,recom_all,recom_aut2,pap_autind)
save(reAA.AP,file="reAA.AP.rda")
