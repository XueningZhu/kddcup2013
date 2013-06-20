ensemble=function(pool,ans,maxn,IDs,k=10000,replacement=T,cross=5,maxmap=0,cind=NULL,avail=NULL,cumcsn=NULL)#pool must be validation pool
{
	#cind=NULL#the list of selected ensemble
	nc=ncol(pool)
	nr=nrow(pool)
	if (is.null(avail))
		avail=rep(TRUE,nc)#the logical vector indicating available models in the pool
	if (is.null(cumcsn))
		cumcsn=rep(0,nr)#the cumulative sum pool of chosen models
	#x=cbind(IDs,ans)
	#act=getSubList(x,train=T)
	act=ans
	for (tt in 1:maxn)
	{
		maxi=0#the index of selected model
		topflag=TRUE#flag of peak
		ncind=length(cind)#number of chosen models
		for (i in 1:nc)
		{
			show(c(tt,i))
			p=proc.time()
			if (avail[i])
			{
				tmpprob=(pool[,i]+cumcsn)/(ncind+1)#the average of models in chosen and the tested one
				tmpmap=NULL

				x=cbind(IDs,tmpprob)
				pred=getSubList(x)
				tmpmap=mapk(k,act,pred)
				#tmpmap=getMapk(k,x)
				
				if (tmpmap>maxmap)
				{
					topflag=FALSE#not peak yet
					maxmap=tmpmap
					maxi=i
				}
			}
			show(proc.time()-p)
			p=proc.time()
		}
		if (!topflag)
		{
			cind=c(cind,maxi)#add maxi into the list
			cumcsn=pool[,maxi]+cumcsn#add new cumcsn
			avail[maxi]=FALSE#not available
		}
		else
		{
			tmpcsn=cumcsn/ncind
			tmpmap=NULL
			#x=cbind(IDs,ans,tmpcsn)
			#tmpmap=getMapk(k,x)#the tested auc
			x=cbind(IDs,tmpcsn)
			pred=getSubList(x)
			tmpmap=mapk(k,act,pred)
			if (sum(as.numeric(avail))==nc)
				return(list(ModelID=cind,MAP=tmpmap))
			if (replacement)
				avail=rep(TRUE,nc)#begin replacement
			else
				return(list(ModelID=cind,AUC=tmpmap))
		}
	}
	tmpcsn=cumcsn/ncind
	tmpmap=NULL
	#x=cbind(IDs,ans,tmpcsn)
	#tmpmap=getMapk(k,x)#the tested auc
	x=cbind(IDs,tmpcsn)
	pred=getSubList(x)
	tmpmap=mapk(k,act,pred)
	#set.seed(proc.time())
	return(list(ModelID=cind,AUC=tmpmap))
}

setwd("~/KDDCUP2013_SYSU/R code/GetFeatures")
source("pool.preparation.R")

load("logit.Pool.rda")
load("qda.Pool.rda")
load("rpart.Pool.rda")
load("gbm.Pool.rda")
load("rF.Pool.rda")
load("Valid.Ans.rda")
load("valid_new4.rda")

full.Pool=cbind(logit.Pool[[1]],qda.Pool[[1]],rpart.Pool[[1]],gbm.Pool[[1]],rF.Pool[[1]])

a=ensemble(full.Pool,Valid.Ans,maxn=40,valid_new4[,1:2])
Ensemble.result=a
save(Ensemble.result,file="Ensemble.result.rda")
