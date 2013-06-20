#nohup Rscript reAP.PC.CP.R &> reAP.PC.CP_log &
#ps 9942
source("~/KDDCUP2013_SYSU/R code/GetFeatures/listMultiplication.R")

setwd("~/kdd_data/rda/")

load("aut_papind.rda")
load("pap_autind.rda")
load("train.rda")
load("recom_aut.rda")
load("recom_all.rda")
load("recomC.rda")
load("recomJ.rda")


reAP.PC.CP=apply(train[,c(3,4,6)],1,AB_BC_CBApply,recom_aut,recom_all,recomC,aut_papind)
save(reAP.PC.CP,file="reAP.PC.CP.rda")
