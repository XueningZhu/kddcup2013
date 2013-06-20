#nohup Rscript AP.PJ.JP_topic.R &> AP.PJ.JP_topic_log &
#ps 32581
source("~/KDDCUP2013_SYSU/R code/GetFeatures/topicMultiplication.R")

setwd("~/kdd_data/rda/")

load("aut_papind.rda")
load("pap_autind.rda")
load("train.rda")
load("com_aut_topic.rda")
load("com_all_topic.rda")
load("comC_topic.rda")
load("comJ_topic.rda")


AP.PJ.JP_topic=apply(train[,3:5],1,AB_BC_CBApply,com_aut_topic,com_all_topic,comJ_topic,aut_papind)
save(AP.PJ.JP_topic,file="AP.PJ.JP_topic.rda")
