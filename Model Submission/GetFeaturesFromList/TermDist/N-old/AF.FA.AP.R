#nohup Rscript AF.FA.AP.R &> AF.FA.AP_log &
#ps 7406
source("~/KDDCUP2013_SYSU/R code/GetFeatures/listMultiplication.R")

setwd("~/kdd_data/rda/")

load("aut_papind.rda")
load("pap_autind.rda")
load("train.rda")
load("com_aut2.rda")
load("com_all.rda")
load("comC.rda")
load("comJ.rda")
load("com_aff.rda")


#AF.FA.AP=apply(train[,c(3,4,6)],1,AB_BC_CBApply,com_aut,com_all,comC,aut_papind)
AF.FA.AP=apply(train[,c(8,3,7)],1,AB_BC_CBApply,com_all,com_aut2,com_aff,pap_autind)

save(AF.FA.AP,file="AF.FA.AP.rda")
