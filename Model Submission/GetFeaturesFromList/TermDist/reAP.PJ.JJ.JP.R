#nohup Rscript reAP.PJ.JJ.JP.R &> reAP.PJ.JJ.JP_log &
#ps 9991
source("~/KDDCUP2013_SYSU/R code/GetFeatures/listMultiplication.R")

setwd("~/kdd_data/rda/")

load("aut_papind.rda")
load("pap_autind.rda")
load("train.rda")
load("recom_aut.rda")
load("recom_all.rda")
load("recomC.rda")
load("recomJ.rda")


reAP.PJ.JJ.JP=apply(train[,3:4],1,AB_BC_CC_CBApply,recom_aut,recom_all,recomJ,aut_papind,train[,5])
save(reAP.PJ.JJ.JP,file="reAP.PJ.JJ.JP.rda")
