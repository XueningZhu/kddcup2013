#nohup Rscript AP.PJN.JNP1.R &> AP.PJN.JNP1_log &
#pid 19958
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


ind1=1:80475  
AP.PJN.JNP1=apply(train[ind1,3:5],1,AB_BC_CBApply,com_aut_train,com_all,comJN,aut_papind)
save(AP.PJN.JNP1,file="AP.PJN.JNP1.rda")
