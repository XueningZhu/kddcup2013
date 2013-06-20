#nohup Rscript reAP.PP.R &> reAP.PP_log &
#ps 9936
source("~/KDDCUP2013_SYSU/R code/GetFeatures/listMultiplication.R")

setwd("~/kdd_data/rda/")

load("aut_papind.rda")
load("pap_autind.rda")
load("train.rda")
load("recom_aut.rda")
load("recom_all.rda")
load("recomC.rda")
load("recomJ.rda")


reAP.PP=apply(train[,3:4],1,AB_BBApply,recom_aut,recom_all,aut_papind)
save(reAP.PP,file="reAP.PP.rda")
