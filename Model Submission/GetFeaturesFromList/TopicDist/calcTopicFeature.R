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


source("listMultiplication.R")
sind=c(1:500,111314:111814)

#feature AB, which is AP
sAP=apply(train[sind,3:4],1,listMutInApply2,com_aut_train,com_all)#40 secs on laptop
save(sAP,file="sAP.rda")

#feature AB_BB, which is AP%*%PP
sAP.PP=apply(train[sind,3:4],1,AB_BBApply,com_aut_train,com_all,aut_papind)#almost 5 hours on laptop
save(sAP.PP,file="sAP.PP.rda")
sAA.AP=apply(train[sind,4:3],1,AB_BBApply,com_all,com_aut2,pap_autind)#(PA.AA)'
save(sAA.AP,file="sAA.AP.rda")

#feature AB_BC_CB, which is AP%*%PJ%*%JP and AP%*%PC%*%CP
sAP.PJ.JP=apply(train[sind,3:5],1,AB_BC_CBApply,com_aut_train,com_all,comJ,aut_papind)#0.4s for 1:50, 52s for 1:300, 50s for 301:600, almost is 14h
sAP.PC.CP=apply(train[sind,c(3,4,6)],1,AB_BC_CBApply,com_aut_train,com_all,comC,aut_papind)#0.1 for 1:50, 16s for 1:300, 21s for 301:600, almost is 5h
sAF.FA.AP=apply(train[sind,c(4,3,7)],1,AB_BC_CBApply,com_all,com_aut2,com_aff,pap_autind)#(PA.AF.FA)'
save(sAP.PJ.JP,file="sAP.PJ.JP.rda")
save(sAP.PC.CP,file="sAP.PC.CP.rda")
save(sAF.FA.AP,file="sAF.FA.AP.rda")

#feature AB_BC_CC_CB,which is AP%*%PJ%*%JJ%*%JP and AP%*%PC%*%C%*%CP
sAP.PJ.JJ.JP=apply(train[sind,3:4],1,AB_BC_CC_CBApply,com_aut_train,com_all,comJ,aut_papind,train[,5])#0.26s for 1:50, 18s for 1:300, 19s for 301:600, almost is 5.5h
sAP.PC.CC.CP=apply(train[sind,3:4],1,AB_BC_CC_CBApply,com_aut_train,com_all,comC,aut_papind,train[,6])#0.22s for 1:50, 10s for 1:300, 20s for 301:600, almost is 4h
save(sAP.PJ.JJ.JP,file="sAP.PJ.JJ.JP.rda")
save(sAP.PC.CC.CP,file="sAP.PC.CC.CP.rda")

sResult=c(rep(1,500),rep(0,501))
sampleTrain=cbind(sResult,train[sind,1:2],sAP,sAP.PP,sAP.PJ.JP,sAP.PC.CP,sAP.PJ.JJ.JP,sAP.PC.CC.CP)
save(sampleTrain,file="sampleTrain.rda")
write.table(sampleTrain,file="sampleTrain.txt",row.names=F,col.names=T,quote=F)
