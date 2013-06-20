#nohup Rscript reAP.PJ.JP4.R &> reAP.PJ.JP4_log &
#ps 11208
source("~/KDDCUP2013_SYSU/R code/GetFeatures/listMultiplication.R")

setwd("~/kdd_data/rda/")

load("aut_papind.rda")
load("pap_autind.rda")
load("train.rda")
load("recom_aut.rda")
load("recom_all.rda")
load("recomC.rda")
load("recomJ.rda")

ind4=241427:321903   
reAP.PJ.JP4=apply(train[ind4,3:5],1,AB_BC_CBApply,recom_aut,recom_all,recomJ,aut_papind)
save(reAP.PJ.JP4,file="reAP.PJ.JP4.rda")
