#nohup Rscript AP.PC.CC.CP_topic.R &> AP.PC.CC.CP_topic_log &
#ps 32575
source("~/KDDCUP2013_SYSU/R code/GetFeatures/topicMultiplication.R")

setwd("~/kdd_data/rda/")

load("aut_papind.rda")
load("pap_autind.rda")
load("train.rda")
load("com_aut_topic.rda")
load("com_all_topic.rda")
load("comC_topic.rda")
load("comJ_topic.rda")


AP.PC.CC.CP_topic=apply(train[,3:4],1,AB_BC_CC_CBApply,com_aut_topic,com_all_topic,comC_topic,aut_papind,train[,6])
save(AP.PC.CC.CP_topic,file="AP.PC.CC.CP_topic.rda")
