#for i-th observation in train,
#i1=train[i,3]
#i2=aut_papind[[i1]] , which is a vector
#i3=paper$id[i2] , which is a vector, id for p_1 ~ p_n
#j1=train[i,4]
#j2=pap_autind[[j1]], which is a vector of the IND authors of the i-the paper
#j3=big_autid[j2], which is a vector of the ID authors of the i-the paper
#for ii3 each i3 do :
#{
#	ii4=pap_autid2[big_papid==ii3], which means the author of the ii3-th paper, which is from the i-th author
#	intsc[ii3]=intersect(ii4,j3), which is the set {b}
#	for iint in each intsc[ii3]
#	{
#		bind=big_aut2_papid[[big_autid2==iint]], paperids for the iint-th in {b}
#		intsc2[iint]=length(intersect(bind,i3))
#	}
#	ans2[ii3]=sum(intsc2),max,min
#}
#sum(max,min * length(i3)), sum(sum)
#

getCo=function()
{
	i2=aut_papind[[i]]
	i3=paper$id[i2]
	j2=pap_autind[[j]]
	j3=big_autid[j2]
	ans=NULL
	lgt=sapply(i3,length)
	for (ii3 in i3)
	{
		ii4=pap_autid2[big_papid==ii3]
		intsc[ii3]=intersect(ii4,j3)
		intsc2=NULL
		for (iint in intsc[ii3])
		{
			bind=big_aut2_papid[[big_autid2==iint]]
			intsc2=c(intsc2,length(intersect(bind,i3)))
		}
		ans=rbind(ans,c(sum(intsc2),max(intsc2),min(intsc2)))
	}
	ans[,2]=ans[,2]*lgt
	ans[,3]=ans[,3]*lgt
	answer=apply(ans,2,sum)
	return(answer)
}