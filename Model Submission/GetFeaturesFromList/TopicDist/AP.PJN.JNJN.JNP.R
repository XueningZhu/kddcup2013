#nohup Rscript AP.PJN.JNJN.JNP.R &> AP.PJN.JNJN.JNP_log &
#pid 19737
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

AP.PJN.JNJN.JNP=apply(train[,3:4],1,AB_BC_CC_CBApply,com_aut_train,com_all,comJN,aut_papind,train[,5])
save(AP.PJN.JNJN.JNP,file="AP.PJN.JNJN.JNP.rda")
