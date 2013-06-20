#pseduo code below

i1=train[i,3]
i2=train_aut_name[[i1]]#name vector after cleaning
j1=train[i,4]
j2=pap_autind[[j1]]#author vector of the j1-th paper
for jj2 in j2 #a1~ak
{
	name_pa=bigaut_nameind[jj2]
	for nnm_pa in name_pa#n11~n1s1
	{
		nameMatch(nnm_pa,i2)
	}
	sum,max,min
	int1=bigaut_papind[jj2]
	int2=aut_papind[i1]
	intsc=length(intersect(int1,int2))
}
#return sum/max/min divided by intsc ,then sum/max/min

AA_AP_name=function()
{
	i2=train_aut_name[[i]]
	j2=pap_autind[[j]]
	ans=NULL
	for (jj2 in j2) #a1~ak
	{
		name_pa=bigaut_nameind[jj2]
		nMtc=NULL
		for (nnm_pa in name_pa)#n11~n1s1
			nMtc=c(nMtc,nameMatch(nnm_pa,i2))
		SumM=sum(nMtc)
		MaxM=max(nMtc)
		MinM=min(nMtc)
		int1=bigaut_papind[jj2]
		int2=aut_papind[i1]
		intsc=length(intersect(int1,int2))
		ans=rbind(ans,c(SumM/intsc,MaxM/intsc,MinM/insc))
	}
	SumA=apply(ans,2,sum)
	MaxA=apply(ans,2,max)
	MinA=apply(ans,2,min)
	ans=c(SumA,MaxA,MinA)
	return(ans)
}


	