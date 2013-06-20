#nohup Rscript AP.PP_topic.R &> AP.PP_topic_log &
#ps 32454
source("~/KDDCUP2013_SYSU/R code/GetFeatures/topicMultiplication.R")

setwd("~/kdd_data/rda/")

load("aut_papind.rda")
load("pap_autind.rda")
load("train.rda")
load("com_aut_topic.rda")
load("com_all_topic.rda")
load("comC_topic.rda")
load("comJ_topic.rda")


AP.PP_topic=apply(train[,3:4],1,AB_BBApply,com_aut_topic,com_all_topic,aut_papind)
save(AP.PP_topic,file="AP.PP_topic.rda")
