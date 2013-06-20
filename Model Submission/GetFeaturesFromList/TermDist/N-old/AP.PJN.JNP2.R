#nohup Rscript AP.PJN.JNP2.R &> AP.PJN.JNP2_log &
#pid 19964
source("~/KDDCUP2013_SYSU/R\ code/GetFeatures/listMultiplication.R")

setwd("~/kdd_data/rda/")

load("aff.rda")
load("aff_all.rda")
load("aut_papind.rda")
load("big_author.rda")
load("com_aff.rda")
load("com_all.rda")
load("com_aut2.rda")
load("com_aut_train.rda")
load("comA_aff.rda")
load("comC.rda")
load("comCN.rda")
load("comJ.rda")
load("comJN.rda")
load("pap_autind.rda")
load("train.rda")


ind2=80476:160951  
AP.PJN.JNP2=apply(train[ind2,3:5],1,AB_BC_CBApply,com_aut_train,com_all,comJN,aut_papind)
save(AP.PJN.JNP2,file="AP.PJN.JNP2.rda")
