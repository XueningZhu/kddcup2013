setwd("~/kdd_data/rda")

load("reAP.rda")
load("reAP.PP.rda")
load("reAP.PC.CP.rda")
load("reAP.PJ.JJ.JP.rda")
load("reAP.PC.CC.CP.rda")
load("reAP.PJ.JP.rda")

load("train.rda")

train.refeatures=cbind(train,reAP,reAP.PP,reAP.PC.CP,reAP.PJ.JJ.JP,reAP.PC.CC.CP,reAP.PJ.JP)
save(train.refeatures,file="train.refeatures.rda")
