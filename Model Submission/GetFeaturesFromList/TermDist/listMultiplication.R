cosine=function(a,b)
{
	a=a[which(!is.na(a))]
	b=b[which(!is.na(b))]
	if (length(a)==0 || length(b)==0)
		return(0)
	return(sum(a*b)/sqrt(sum(a^2)*sum(b^2)))
}

intSec=function(a,b)
{
	dat=c(a,b)
	dat=sort(dat)
	l=length(dat)
	dat2=c(dat[2:l],dat[1])
	dat3=dat-dat2
	return(dat[which(dat3==0)])
}

listMut=function(A,B,i=1,j=1)
{
	a=A[[i]]
	b=B[[j]]
	na=names(a)
	nb=names(b)
	nc=intersect(na,nb)
	aa=a[nc]
	bb=b[nc]
	if (is.null(aa) || is.null(bb))
		return(0)
	aa=aa[which(!is.na(aa))]
	bb=bb[which(!is.na(bb))]
	if (length(aa)==0 || length(bb)==0)
		return(0)
	return(sum(aa*bb)/sqrt(sum(a^2)*sum(b^2)))
	#return(cosine(a,b))
}#O(intersect(M)), where M is the number representing sparsity

listMutIn=function(A,B,i=1,j=1)
{
	a=A[[i]]
	b=B[[j]]
	nb=names(b)
	aa=a[nb]
	if (is.null(aa))
		return(0)
	aa=aa[which(!is.na(aa))]
	if (length(aa)==0)
		return(0)
	if (length(aa)!=length(b))
		return(listMut(A,B,i,j))
	return(sum(aa*b)/sqrt(sum(a^2)*sum(b^2)))
	#return(cosine(a,b))
}#O(M), where M is the number representing sparsity

listMutApply=function(j,A,B,i)
{
	return(listMut(A,B,i,j))
}

listMutInApply=function(j,A,B,i)
{
	return(listMutIn(A,B,i,j))
}

AB_BB=function(A,B,tb,i,j)
{
	pind=tb[[i]]
	if (pind==0)
		return(0)
	#plist=com_all[pind]
	a=sapply(pind,listMutInApply,A,B,i)
	b=sapply(pind,listMutApply,B,B,j)
	return(sum(a*b))
}#O(M*M)
#For BB_BA(B,A,tb,i,j), we could just use it as AB_BB(A,B,tb,j,i)
#lapply(pap_nameind,listMutApply,train_aut_name,recom_bigaut_name,i)

AB_BC_CB=function(A,B,C,tbAB,tbCB,i,j)
{
	ABind=tbAB[[i]]
	CBind=tbCB
	if (is.na(CBind))
		return(0)
	if (ABind==0 || CBind==0)
		return(0)
	#AB=sapply(ABind,listMutInApply,A,B,i)
	AB=sapply(ABind,listMutApply,A,B,i)
	BC=sapply(ABind,listMutApply,C,B,CBind)
	#CB=listMutIn(C,B,CBind,j)
	CB=listMut(C,B,CBind,j)
	
	return(CB*sum(AB*BC))
}#O(M*M*M)
#For BC_CB_BA, we could just use it as AB_BC_CB(A,B,C,tbAB,tbCB,j,i)

BC_CC_CB=function(B,C,tbBC,i,j)
{
	Lind=tbBC[i]
	Rind=tbBC[j]
	if (is.na(Rind) || is.na(Lind))
		return(0)
	if (Lind==0 || Rind==0)
		return(0)
	#BC=listMutIn(C,B,Lind,i)
	BC=listMut(C,B,Lind,i)
	#BC=sapply(Lind,listMutInApply,C,B,i)
	
	tmp=listMut(C,C,Lind,Rind)
	
	#CB=listMutIn(C,B,Rind,j)
	CB=listMut(C,B,Rind,j)
	
	return(BC*tmp*CB)
}#O(M*M*M)

BC_CC_CB_Apply=function(i,B,C,tbBC,j)
{
	return(BC_CC_CB(B,C,tbBC,i,j))
}

AB_BC_CC_CB=function(A,B,C,tbAB,tbBC,i,j)
{
	ABind=tbAB[[i]]
	if (ABind==0)
		return(0)
	#a=sapply(ABind,listMutInApply,A,B,i)
	a=sapply(ABind,listMutApply,A,B,i)
	b=sapply(ABind,BC_CC_CB_Apply,B,C,tbBC,j)
	return(sum(a*b))
}#O(M*M*M*M)


listMutApply2=function(x,A,B)
{
	i=x[1]
	j=x[2]
	return(listMut(A,B,i,j))
}

listMutInApply2=function(x,A,B)
{
	i=x[1]
	j=x[2]
	return(listMutIn(A,B,i,j))
}

AB_BBApply=function(x,A,B,tb)
{
	i=x[1]
	j=x[2]
	return(AB_BB(A,B,tb,i,j))
}

AB_BC_CBApply=function(x,A,B,C,tbAB)
{
	i=x[1]
	j=x[2]
	tbCB=x[3]
	return(AB_BC_CB(A,B,C,tbAB,tbCB,i,j))
}

AB_BC_CC_CBApply=function(x,A,B,C,tbAB,tbBC)
{
	i=x[1]
	j=x[2]
	return(AB_BC_CC_CB(A,B,C,tbAB,tbBC,i,j))
}
