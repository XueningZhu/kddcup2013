nameMut=function(A,B,i=1,j=1)
{
	return(nameMatch(A[[i]],B[[j]]))
}

nameMutApply=function(j,A,B,i)
{
	return(nameMut(A,B,i,j))
}

AN_NP=function(i,j,A,B,tb)
{
	ind=tb[[j]]
	a=lapply(ind,nameMutApply,A,B,i)
	a=do.call(rbind,a)
	Mans=apply(a,2,max)
	Sans=apply(a,2,sum)
	return(c(Mans,Sans))
}

AN_NP_Apply=function(x,A,B,tb)
{
	i=x[1]
	j=x[2]
	return(AN_NP(i,j,A,B,tb))
}

#AN_NP(i,j,train_aut_name,recom_bigaut_name,pap_nameind)

a=apply(train[,c(3,7)],1,AN_NP_Apply,train_aut_name,recom_bigaut_name,pap_nameind)
ans=do.call(a,rbind)