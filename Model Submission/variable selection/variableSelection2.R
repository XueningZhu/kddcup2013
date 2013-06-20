varSelect=function(set)
{
	require(RRF)
	require(msgps)
	mlrs=msgps(X=as.matrix(set[,-c(1:2,16)]),y=set$result)
	x=coef(mlrs)
	ind=which(apply(x,1,function(x) sum(x==0)==0))
	nms=names(ind)
	ind2=which(nms!="(Intercept)")
	LassoRes=nms[ind2]
	show("Lasso Finished.")
	
	nrf <- RRF(as.factor(result)~.,data=set[,-c(1:2,36,37)], flagReg = 0)
	impRF=nrf$importance
	impRF=impRF[,"MeanDecreaseGini"]
	
	rrf=RRF(as.factor(result)~.,data=set[,-c(1:2,36,37)])
	imp=rrf$importance
	imp=imp[,"MeanDecreaseGini"]
	subsetRRF = which(imp>0)
	show("RRF Finished.")
	
	imp=impRF/(max(impRF))#normalize the importance score
	gamma = 0.5
	coefReg=(1-gamma)+gamma*imp #weighted average
	rrf <- RRF(as.factor(result)~.,data=set[,-c(1:2,36,37)],coefReg=coefReg)
	imp=rrf$importance
	imp=imp[,"MeanDecreaseGini"]
	subsetGRRF = which(imp>0)
	show("GRRF Finished.")
	
	return(list(LassoRes,subsetRRF,subsetGRRF))
}
#system.time((a=varSelect(train_new2_dup0[sample(1:nrow(train_new2_dup0),1000),])))
system.time((a=varSelect(train_new4_dup0)))
varSelected=a
save(varSelected,file="varSelected.rda")


