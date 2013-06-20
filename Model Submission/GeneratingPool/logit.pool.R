logit.pool=function(formula,n=50,train,valid)
{
	m=ncol(train)
	ind=getVars(n,m)
	#ind=setdiff(ind,1:2)
	ans=NULL
	for (i in 1:n)
	{
		show(i)
		indt=setdiff(ind[[i]],1:2)
		indt=union(indt,16)
		model=glm(formula,data=train[,indt],family=binomial)
		pred=1/(exp(-predict(model,newdata=valid))+1)
		ans=cbind(ans,pred)
	}
	return(list(pool=as.data.frame(ans),ind))
}

setwd("~/KDDCUP2013_SYSU/R code/GetFeatures")
source("pool.preparation.R")
setwd("~/kdd_data/rda")
load("train_new4_dup0.rda")
load("valid_new4.rda")

system.time((logit.Pool=logit.pool(as.factor(result)~.,n=200,train=train_new4_dup0,valid=valid_new4)))#814s for n=50
save(logit.Pool,file="logit.Pool.rda")
