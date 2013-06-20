#nohup Rscript reAP.PJ.JP3.R &> reAP.PJ.JP3_log &
#ps 11105
source("~/KDDCUP2013_SYSU/R code/GetFeatures/listMultiplication.R")

setwd("~/kdd_data/rda/")

load("aut_papind.rda")
load("pap_autind.rda")
load("train.rda")
load("recom_aut.rda")
load("recom_all.rda")
load("recomC.rda")
load("recomJ.rda")

ind3=160952:241426 
reAP.PJ.JP3=apply(train[ind3,3:5],1,AB_BC_CBApply,recom_aut,recom_all,recomJ,aut_papind)
save(reAP.PJ.JP3,file="reAP.PJ.JP3.rda")
