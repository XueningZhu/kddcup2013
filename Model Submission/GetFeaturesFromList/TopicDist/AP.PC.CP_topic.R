#nohup Rscript AP.PC.CP_topic.R &> AP.PC.CP_topic_log &
#ps 32352
source("~/KDDCUP2013_SYSU/R code/GetFeatures/topicMultiplication.R")

setwd("~/kdd_data/rda/")

load("aut_papind.rda")
load("pap_autind.rda")
load("train.rda")
load("com_aut_topic.rda")
load("com_all_topic.rda")
load("comC_topic.rda")
load("comJ_topic.rda")


AP.PC.CP_topic=apply(train[,c(3,4,6)],1,AB_BC_CBApply,com_aut_topic,com_all_topic,comC_topic,aut_papind)
save(AP.PC.CP_topic,file="AP.PC.CP_topic.rda")
