#nohup Rscript reAP.PJ.JP1.R &> reAP.PJ.JP1_log &
#ps 10951
source("~/KDDCUP2013_SYSU/R code/GetFeatures/listMultiplication.R")

setwd("~/kdd_data/rda/")

load("aut_papind.rda")
load("pap_autind.rda")
load("train.rda")
load("recom_aut.rda")
load("recom_all.rda")
load("recomC.rda")
load("recomJ.rda")

ind1=1:80475  
reAP.PJ.JP1=apply(train[ind1,3:5],1,AB_BC_CBApply,recom_aut,recom_all,recomJ,aut_papind)
save(reAP.PJ.JP1,file="reAP.PJ.JP1.rda")
