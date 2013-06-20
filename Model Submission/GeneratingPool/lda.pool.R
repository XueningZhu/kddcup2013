lda.pool=function(formula,n=50,train,valid)
{
	require(MASS)
	m=ncol(train)
	ind=getVars(n,m)
	#ind=setdiff(ind,1:2)
	ans=NULL
	for (i in 1:n)
	{
		indt=setdiff(ind[[i]],1:2)
		model=lda(formula,data=train[,indt])
		pred=predict(model,newdata=valid)$posterior[,2]
		ans=cbind(ans,pred)
	}
	return(as.data.frame(ans))
}
