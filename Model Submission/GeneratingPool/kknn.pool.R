kknn.pool=function(formula,n=50,train,valid,k,distance,kernel)
{
	require(kknn)
	m=length(k)
	ind.k=getParaInd(n,m)
	m=length(distance)
	ind.distance=getParaInd(n,m)
	m=length(kernel)
	ind.kernel=getParaInd(n,m)
	ans=NULL
	for (i in 1:n)
	{
		show(i)
		model=kknn(formula,train=train[,-(1:2)],test=valid,k=k[ind.k[i]],distance=distance[ind.distance[i]],kernel=kernel[ind.kernel[i]])
		pred=model$prob[,2]
		ans=cbind(ans,pred)
	}
	ind=cbind(k[ind.k],distance[ind.distance],kernel[ind.kernel])
	return(list(as.data.frame(ans),ind))
}

setwd("~/KDDCUP2013_SYSU/R code/GetFeatures")
source("pool.preparation.R")
setwd("~/kdd_data/rda")
load("train_new4_dup0.rda")
load("valid_new4.rda")

#sind=sample(1:nrow(train_new2_dup0),10000)

k=seq(5,30,by=5)
distance=seq(0.5,3,by=0.5)
kernel=c("rectangular","triangular","epanechnikov","gaussian")

system.time((kknn.Pool=kknn.pool(as.factor(result)~.,
									n=50,
									train=train_new4_dup0,
									valid=valid_new4,
									k=k,
									distance=distance,
									kernel=kernel
								)
			))
save(kknn.Pool,file="kknn.Pool.rda")
