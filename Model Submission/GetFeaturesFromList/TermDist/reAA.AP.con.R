#nohup Rscript reAA.AP.con.R &> reAA.AP.con_log &
#ps 23370
source("~/KDDCUP2013_SYSU/R code/GetFeatures/listMultiplication.R")

setwd("~/kdd_data/rda/")

load("aut_papind.rda")
load("pap_autind.rda")
load("train.rda")
load("recom_aut2.rda")
load("recom_all.rda")
load("recomC.rda")
load("recomJ.rda")
load("del_papaut_ind.rda")
load("con_papaut_ind.rda")


#pap_autind[[train$papind2[i]]]
reAA.AP.con=apply(train[,c(8,3)],1,AB_BBApply,recom_all,recom_aut2,con_papaut_ind)
save(reAA.AP.con,file="reAA.AP.con.rda")
