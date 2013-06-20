#nohup Rscript reAP.PC.CC.CP.R &> reAP.PC.CC.CP_log &
#ps 10093
source("~/KDDCUP2013_SYSU/R code/GetFeatures/listMultiplication.R")

setwd("~/kdd_data/rda/")

load("aut_papind.rda")
load("pap_autind.rda")
load("train.rda")
load("recom_aut.rda")
load("recom_all.rda")
load("recomC.rda")
load("recomJ.rda")


reAP.PC.CC.CP=apply(train[,3:4],1,AB_BC_CC_CBApply,recom_aut,recom_all,recomC,aut_papind,train[,6])
save(reAP.PC.CC.CP,file="reAP.PC.CC.CP.rda")
