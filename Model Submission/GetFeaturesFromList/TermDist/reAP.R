#nohup Rscript reAP.R &> reAP_log &
#ps 10472
source("~/KDDCUP2013_SYSU/R code/GetFeatures/listMultiplication.R")

setwd("~/kdd_data/rda/")

load("aut_papind.rda")
load("pap_autind.rda")
load("train.rda")
load("recom_aut.rda")
load("recom_all.rda")
load("recomC.rda")
load("recomJ.rda")


reAP=apply(train[,3:4],1,listMutInApply2,recom_aut,recom_all)
save(reAP,file="reAP.rda")
