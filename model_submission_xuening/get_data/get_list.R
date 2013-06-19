
#setwd("F:/kdd/2013 kdd/rda/original data")
### packages
library(sqldf)

setwd("~/kdd_data/rda")
### load the original data
load("author.rda")
load("paper.rda")
load("paperauthor.rda")
load("journal.rda")
load("conference.rda")
load("trainconfirmed.rda")
load("traindeleted.rda")
load("validpaper.rda")

### load the keywords rda
load("Cate.rda")
load("Key.rda")
load("Subkey.rda")
load("title_key.rda")

### loda the rda from get_rda.R
load("train.rda")
load("train_papid.rda")
load("train_con.rda")
load("train_del.rda")
load("valid.rda")

load("train_autid.rda")
load("autid.rda")
load("big_autid.rda")
load("big_author.rda")

load("big_autid2.rda")
load("big_papid2.rda")
load("bigaut_name.rda")
load("train_aut_name.rda")

load("aff.rda")
load("aff1.rda")
load("aff_all.rda")

load("jourid.rda")
load("pap_jourid.rda")
load("confid.rda")
load("pap_confid.rda")

#load("com_all.rda")
load("pap_aut_train1.rda")
load("pap_aut_train2.rda")
load("pap_aut_train3.rda")
load("pap_aut_train4.rda")
load("pap_aut_train5.rda")
load("pap_aut_train6.rda")


### source the functions
source("functions.R")

#aff=unique(author$affiliation[is.element(author$id,train_autid)])
#aff=aff[aff!=""]
#save(aff,file="aff.rda")
#autid=author$id[is.element(author$affiliation,aff)]
#autid_all=autid
#save(autid,file="autid.rda")
#autind=(1:length(autid))[is.element(author$affiliation,aff)]



### com/ com_all list

ind=which(paper$keyword!=""|paper$title!="")
com=lapply(1:length(ind),comb,wei=c(3,2,1,1),cate=Cate[ind],key=Key[ind],
           subkey=Subkey[ind],title_key=title_key[ind])
zero=unlist(lapply(1:length(ind),function(i) {if (any(com[[i]]==0|is.null(com[[i]]))) i}))
com=com[setdiff(1:length(ind),zero)]
ind=setdiff(ind,ind[zero]) ##ind is the non-zero ones

com_all=as.list(rep(0,nrow(paper)))
com_all[ind]=com
save(com,file="com.rda")
save(com,file="com_all.rda")

### comJ/ comC list
system.time((comJ=comOrg(com_all=com_all,orgid=unique(journal$id),allid=paper$journalid)))
comC=comOrg(com_all,orgid=unique(conference$id),allid=paper$conferenceid)

### comJN/ comCN list could be omitted
### refer to the Orgnames.R for details


### aut_papind list
aut_papind=lapply(1:length(train_autid),function(i) 
  i=pap_aut_train4$papind[pap_aut_train4$authorid==train_autid[i]])
save(aut_papind,file="aut_papind.rda")

### pap_autind list
pap_autind=lapply(1:length(train_papid),function(i) 
  i=pap_aut_train1$big_autind[pap_aut_train1$paperid==train_papid[i]])
save(pap_autind,file="pap_autind.rda")


### com_aut_big list

com_aut_big=comAut(paperauthor=paperauthor,com_all=com_all,
                   orgid=autid,allid=paperauthor$authorid)
save(com_aut_big,file="com_aut_big.rda")

### com_aff list
com_aff=com_Aff(orgid=aff,allid=author$affiliation[is.element(author$id,train_autid)],
                  com_aut_big)
save(com_aff,file="com_aff.rda")

### com_aut_train
com_aut_train=comAut(paperauthor=pap_aut_train4,com_all=com_all,
                     orgid=train_autid,allid=pap_aut_train4$authorid)
save(com_aut_train,file="com_aut_train.rda")

### com_aut2 list
system.time((com_aut2=comAut(paperauthor=pap_aut_train2,com_all=com_all,
                             orgid=big_autid,allid=pap_aut_train2$authorid)))
  
#ind=is.element(train_autid,autid)
#tmp1=com_aut_big[is.element(autid,train_autid)]
#tmp2=comAut(paperauthor=paperauthor,com_all=com_all,
#            orgid=setdiff(train_autid,autid),
#            allid=paperauthor$authorid)

#com_aut_train[ind]=tmp1
#com_aut_train[!ind]=tmp2
#save(com_aut_train,file="com_aut_train.rda")



### list with respliting the keywords (recom series)
source("resplit.keywords.R")  #### resplit functions

### recom list
system.time((recom=lapply(1:length(com),function(i) {cat(i,"\n"); return(keyword.resplit(com[[i]]))})))
save(recom,file="recom.rda")

### recom_all list
ll=which(unlist(lapply(com_all,function(x) return(!all(x==0)))))
recom_all=as.list(rep(0,length(com_all)))
recom_all[ll]=recom
save(recom_all,file="recom_all.rda")

### recomJ/recomC list (parallel: recom_Org.R)

system.time((recomJ=comOrg(recom_all,orgid=jourid,allid=pap_jourid)))
save(recomJ,file="recomJ.rda")
system.time((recomC=comOrg(recom_all,orgid=confid,allid=pap_confid)))
save(recomC,file="recomC.rda")

### recom_bigaut.R (parallel: recom_bigaut.R)
system.time((recom_bigaut=comAut(paperauthor=pap_aut_train2,com_all=recom_all,
                                  orgid=big_autid,allid=pap_aut_train2$authorid)))
save(recom_bigaut,file="recom_bigaut.rda")

### recom_aff_aut (parallel: recom_aff_aut.R) --authors related to aff
recom_aff_aut=comAut(paperauthor=pap_aut_train,com_all=recom_all,
                       orgid=autid,allid=pap_aut_train3$authorid)
save(recom_aff_aut,file="recom_aff_aut.rda")

### recom_train_aut (parallel: recom_train_aut.R)
recom_train_aut=comAut(paperauthor=pap_aut_train,com_all=recom_all,
                        orgid=train_autid,allid=pap_aut_train4$authorid)
save(recom_train_aut,file="recom_train_aut.rda")

### recom_aff (parallel: recom_aff.R)
setwd("~/kdd_data/rda")
load("aff.rda")
load("aff_allid.rda")
load("recom_aff_aut.rda")

system.time((recom_aff=comOrg(recom_aff_aut,orgid=aff[,2],allid=aff_allid)))

### recom_aut2 (parallel: recom_bigaut.R)
system.time((recom_bigaut=comAut(paperauthor=pap_aut_train2,com_all=recom_all,
                                  orgid=big_autid,allid=pap_aut_train2$authorid)))
save(recom_bigaut,file="recom_bigaut.rda")


### list related to names
### recom_bigaut_name (paralell not needed)
recom_bigaut_name=system.time((recom_train_aut_name=lapply(1:length(bigaut_name), function(i){
                                              cat(i,"\n"); return(clean.name(bigaut_name[i ]))})))
save(recom_bigaut_name,file="recom_bigaut_name.rda")

### recom_train_aut_name 
system.time((recom_train_aut_name=lapply(1:length(train_aut_name), function(i){
                                           cat(i,"\n");return(clean.name(train_aut_name[i]))})))
save(recom_train_aut_name,file="recom_train_aut_name.rda")



### bigaut_nameind (parallel: bigaut_nameind.R) --actually names, not ind
system.time((bigaut_nameind=lapply(1:length(big_autid),function(i) {cat(i,"\n"); return(recom_bigaut_name[unique(
  pap_aut_train2$nameind[pap_aut_train2$authorid==big_autid[i]])])})))
save(bigaut_nameind,file="bigaut_nameind.rda")

### bigaut_papind (paralle: bigaut_papind.R)
system.time((bigaut_papind=lapply(1:length(big_autid), function(i) 
{ cat(i,"\n");return(pap_aut_train2$papind[pap_aut_train2$authorid==big_autid[i]])})))
save(bigaut_papind,file="bigaut_papind.rda")

### for ap-pa-ap feature
### pap_autid2 (parallel: pap_autid2)
pap_autid2=lapply(1:length(big_papid2),function(i)
                    {cat(i,"\n");return(pap_aut_train5$authorid[pap_aut_train5$paperid==big_papid2[i]])})
save(pap_autid2,file="pap_autid2.rda")

### big_autid2_papid (parallel: big_autid2_papid)
big_autid2_papid=lapply(1:length(big_autid2),function(i)
                          {cat(i,"\n");return(pap_aut_train6$paperid[pap_aut_train6$authorid==big_autid2[i]])})






