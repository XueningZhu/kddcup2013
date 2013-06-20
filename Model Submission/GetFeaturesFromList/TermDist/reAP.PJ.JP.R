#nohup Rscript reAP.PJ.JP.R &> reAP.PJ.JP_log &
#ps 32581
source("~/KDDCUP2013_SYSU/R code/GetFeatures/listMultiplication.R")

setwd("~/kdd_data/rda/")

#load("aut_papind.rda")
#load("pap_autind.rda")
#load("train.rda")
#load("recom_aut.rda")
#load("recom_all.rda")
#load("recomC.rda")
#load("recomJ.rda")


#reAP.PJ.JP=apply(train[,3:5],1,AB_BC_CBApply,recom_aut,recom_all,recomJ,aut_papind)
#save(reAP.PJ.JP,file="reAP.PJ.JP.rda")

load("reAP.PJ.JP1.rda")
load("reAP.PJ.JP2.rda")
load("reAP.PJ.JP3.rda")
load("reAP.PJ.JP4.rda")
reAP.PJ.JP=c(reAP.PJ.JP1,reAP.PJ.JP2,reAP.PJ.JP3,reAP.PJ.JP4)
save(reAP.PJ.JP,file="reAP.PJ.JP.rda")
