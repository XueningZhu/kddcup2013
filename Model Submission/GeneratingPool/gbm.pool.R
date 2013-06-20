gbm.pool=function(formula,n=50,train,valid,n.trees,interaction.depth,n.minobsinnode,shrinkage,bag.fraction,train.fraction)
{
	require(gbm)
	m=length(n.trees)
	ind.n.trees=getParaInd(n,m)
	m=length(interaction.depth)
	ind.interaction.depth=getParaInd(n,m)
	m=length(n.minobsinnode)
	ind.n.minobsinnode=getParaInd(n,m)
	m=length(shrinkage)
	ind.shrinkage=getParaInd(n,m)
	m=length(bag.fraction)
	ind.bag.fraction=getParaInd(n,m)
	m=length(train.fraction)
	ind.train.fraction=getParaInd(n,m)
	
	ans=NULL
	for (i in 1:n)
	{
		show(i)
		model=gbm(
			formula, 
			distribution = "adaboost", 
			data = train[,-(1:2)], 
			#var.monotone = NULL,
			n.trees = n.trees[ind.n.trees[i]],
			interaction.depth = interaction.depth[ind.interaction.depth[i]],
			n.minobsinnode = n.minobsinnode[ind.n.minobsinnode[i]],
			shrinkage = shrinkage[ind.shrinkage[i]],
			bag.fraction = bag.fraction[ind.bag.fraction[i]],
			train.fraction = train.fraction[ind.train.fraction[i]],
			#cv.folds=5,
			#keep.data = TRUE,
			verbose = FALSE)
		pred=predict.gbm (model,valid, n.trees = n.trees[ind.n.trees[i]], type = "response")
		ans=cbind(ans,pred)
	}
	ind=cbind(n.trees[ind.n.trees],
				interaction.depth[ind.interaction.depth],
				n.minobsinnode[ind.n.minobsinnode],
				shrinkage[ind.shrinkage],
				bag.fraction[ind.bag.fraction],
				train.fraction[ind.train.fraction])
	return(list(as.data.frame(ans),ind))
}

setwd("~/KDDCUP2013_SYSU/R code/GetFeatures")
source("pool.preparation.R")
setwd("~/kdd_data/rda")
load("train_new4_dup0.rda")
load("valid_new4.rda")

#sind=sample(1:nrow(train_new2_dup0),10000)

n.trees=seq(2000,7000,by=1000)
interaction.depth=2:5
n.minobsinnode=seq(20,50,by=10)
shrinkage=seq(0,0.1,by=0.01)
bag.fraction=seq(0.05,0.3,by=0.05)
train.fraction=c(0.6,0.8,1)

system.time((gbm.Pool=gbm.pool(as.factor(result)~.,
									n=30,
									train=train_new4_dup0,
									valid=valid_new4,
									n.trees=n.trees,
									interaction.depth=interaction.depth,
									n.minobsinnode=n.minobsinnode,
									shrinkage=shrinkage,
									bag.fraction=bag.fraction,
									train.fraction=train.fraction
								)
			))
save(gbm.Pool,file="gbm.Pool.rda")

#n.trees = 5000,
#interaction.depth = 4,
#n.minobsinnode = 30,
#shrinkage = 0.05,
#bag.fraction = 0.2,
#train.fraction = 0.8,
