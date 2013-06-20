rF.pool=function(formula,n=50,train,valid,ntree,mtry,nodesize,maxnodes)
{
	require(randomForest)
	m=length(ntree)
	ind.ntree=getParaInd(n,m)
	m=length(mtry)
	ind.mtry=getParaInd(n,m)
	m=length(nodesize)
	ind.nodesize=getParaInd(n,m)
	m=length(maxnodes)
	ind.maxnodes=getParaInd(n,m)
	ans=NULL
	for (i in 1:n)
	{
		show(i)
		model=randomForest(formula,data=train[,-(1:2)],ntree=ntree[ind.ntree[i]],mtry=mtry[ind.mtry[i]],nodesize=nodesize[ind.nodesize[i]],maxnodes=maxnodes[ind.maxnodes[i]])
		pred=predict(model,newdata=valid,type="prob")[,2]
		ans=cbind(ans,pred)
	}
	ind=cbind(ntree[ind.ntree],mtry[ind.mtry],nodesize[ind.nodesize],maxnodes[ind.maxnodes])
	return(list(as.data.frame(ans),ind))
}

setwd("~/KDDCUP2013_SYSU/R code/GetFeatures")
source("pool.preparation.R")
setwd("~/kdd_data/rda")
load("train_new4_dup0.rda")
load("valid_new4.rda")

#sind=sample(1:nrow(train_new2_dup0),10000)

ntree=c(500,1000,1500,2000,2500,3000)
m=trunc(sqrt(ncol(train_new2_dup0)))
mtry=c(m-1,m,m+1)
nodesize=c(1,2,3)
maxnodes=c(10,20,NULL)
system.time((rF.Pool=rF.pool(as.factor(result)~.,
								n=30,
								train=train_new4_dup0,
								valid=valid_new4,
								ntree=ntree,
								mtry=mtry,
								nodesize=nodesize,
								maxnodes=maxnodes
							)
			))#100s for 100rows in train, 50rows in valid, n=3
save(rF.Pool,file="rF.Pool.rda")
