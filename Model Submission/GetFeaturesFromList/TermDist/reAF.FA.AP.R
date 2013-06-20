#nohup Rscript reAF.FA.AP.R &> reAF.FA.AP_log &
#ps 6758
source("~/KDDCUP2013_SYSU/R code/GetFeatures/listMultiplication.R")

setwd("~/kdd_data/rda/")

load("aut_papind.rda")
load("pap_autind.rda")
load("train.rda")
load("recom_aut2.rda")
load("recom_all.rda")
load("recomC.rda")
load("recomJ.rda")
load("recom_aff.rda")


#reAF.FA.AP=apply(train[,c(3,4,6)],1,AB_BC_CBApply,recom_aut,recom_all,recomC,aut_papind)
reAF.FA.AP=apply(train[,c(8,3,7)],1,AB_BC_CBApply,recom_all,recom_aut2,recom_aff,pap_autind)

save(reAF.FA.AP,file="reAF.FA.AP.rda")
