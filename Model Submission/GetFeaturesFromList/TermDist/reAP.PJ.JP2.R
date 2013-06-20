#nohup Rscript reAP.PJ.JP2.R &> reAP.PJ.JP2_log &
#ps 11068
source("~/KDDCUP2013_SYSU/R code/GetFeatures/listMultiplication.R")

setwd("~/kdd_data/rda/")

load("aut_papind.rda")
load("pap_autind.rda")
load("train.rda")
load("recom_aut.rda")
load("recom_all.rda")
load("recomC.rda")
load("recomJ.rda")

ind2=80476:160951 
reAP.PJ.JP2=apply(train[ind2,3:5],1,AB_BC_CBApply,recom_aut,recom_all,recomJ,aut_papind)
save(reAP.PJ.JP2,file="reAP.PJ.JP2.rda")
