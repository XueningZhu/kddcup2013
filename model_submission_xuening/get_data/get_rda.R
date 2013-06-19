
setwd("~/kdd_data/rda")
library(sqldf)
load("trainconfirmed.rda")
load("traindeleted.rda")
load("validpaper.rda")
load("paper.rda")
load("paperauthor.rda")
load("journal.rda")
load("conference.rda")
load("author.rda")

### paperauthor
b1=data.frame(id=1:nrow(paper),papid=paper$id)
bb=sqldf("select paperauthor.authorid,a1.id from paperauthor left join b1 on paperauthor.paperid=b1.papid")
paperauthor$papind=bb$id

a1=data.frame(id=1:nrow(author),autid=author$id)
aa=sqldf("select paperauthor.authorid,a1.id from paperauthor left join a1 on paperauthor.authorid=a1.autid")
paperauthor$autind=aa$id

save(paperauthor,file="paperauthor.rda")

#### train.rda
train=rbind(trainconfirmed,traindeleted,validpaper)
#####
train_autid=unique(train$authorid)
save(train_autid,file="train_autid.rda")

train_papid=unique(train$paperid)
save(train_papid,file="train_papid.rda")

### aff
aff=unique(author$affiliation[is.element(author$id,train_autid)])
aff=aff[aff!=""]
aff=data.frame(ind=1:length(aff),aff=aff)
save(aff,file="aff.rda")
### aff1
aff1=unique(author$affiliation[author$affiliation!=""])
save(aff1,file="aff1.rda")

### aff_all
aff_all=data.frame(id=1:length(aff1),aff=aff1)
save(aff_all,file="aff_all.rda")

### autid
autid=author$id[is.element(author$affiliation,aff)]
#autid_all=autid
save(autid,file="autid.rda")

### jourid (used by comJ/recomJ)
jourid=unique(journal$id)
save(jourid,file="jourid.rda")

### pap_jourid (used by comJ/recomJ)
pap_jourid=paper$journalid
save(pap_jourid,file="pap_jourid.rda")

### confid
confid=unique(conference$id)
save(confid,file="confid.rda")

### pap_confid
pap_confid=unique(paper$conferenceid)
save(pap_confid,file="pap_confid.rda")

### confid
confid=unique(conference$id)
save(confid,file="confid.rda")

#####
pp=sqldf("select train.paperid, paper.ind from train, paper on train.paperid=paper.id")
train$papind=pp$ind

journal$jourind=1:nrow(journal)
conference$confind=1:nrow(conference)
train_pap_jour=sqldf("select train.paperid,paper.journalid from train,paper where train.paperid=paper.id")
train_pap_jour1=sqldf("select train_pap_jour.paperid,journal.jourind from train_pap_jour left join journal on train_pap_jour.journalid=journal.id")
train$jourind=train_pap_jour1$jourind

conference$confind=1:nrow(conference)
train_pap_conf=sqldf("select train.paperid,paper.conferenceid from train,paper where train.paperid=paper.id")
train_pap_conf1=sqldf("select train_pap_conf.paperid,conference.confind from train_pap_conf left join conference on train_pap_conf.conferenceid=conference.id")
train$confind=train_pap_conf1$confind

train_aut=data.frame(ind=1:length(train_autid),autid=train_autid)
train_aut1=sqldf("select train.authorid,train_aut.ind from train,train_aut where train.authorid=train_aut.autid")
train$autind=train_aut1$ind

aut=sqldf("select author.id, aff.ind from author,aff where author.affiliation=aff.aff")
train_aut1=sqldf("select train.authorid,aut.ind from train left join aut on train.authorid=aut.id")
train$affind=train_aut1$ind

aut=sqldf("select author.id, aff.ind from author,aff where author.affiliation=aff.aff")
train_aut1=sqldf("select train.authorid,aut.ind from train left join aut on train.authorid=aut.id")
train$affind=train_aut1$ind

train_papid1=data.frame(id=1:length(train_papid),papid=train_papid)
tt=sqldf("select train.paperid,train_papid1.id from train left join train_papid1 on train.paperid=train_papid1.papid")
train$papind2=tt$id

### -- train_con/ train_del/ valid
train_del=train[1:111313,]
train_con=train[111314:(111314+122647-1),]
valid=train[(111314+122647):321903,]

save(train_del,file="train_del.rda")
save(train_con,file="train_con.rda")
save(valid,file="valid.rda")
### 
get.papinds<-function(data,train)
{
  data_papid=unique(data$paperid)
  data_papid1=data.frame(id=1:length(data_papid),papid=data_papid)
  tt=sqldf("select train.paperid,data_papid1.id from train left join data_papid1 on train.paperid=data_papid1.papid")
  return(tt$id)
}

t1=get.papinds(data=train_con,train=train)
t2=get.papinds(data=train_del,train=train)

train$papind3=t1
train$papind4=t2

save(train,file="train.rda")



### function to get papinds
get.papinds<-function(data,train)
{
  data_papid=unique(data$paperid)
  data_papid1=data.frame(id=1:length(data_papid),papid=data_papid)
  tt=sqldf("select train.paperid,data_papid1.id from train left join data_papid1 on train.paperid=data_papid1.papid")
  return(tt$id)
}
###
t1=get.papinds(data=train_con,train=train)
t2=get.papinds(data=train_del,train=train)

train$papind3=t1
train$papind4=t2

save(train,file="train.rda")

#### pap_aut_train*.rda

#pap_aut_train=paperauthor[is.element(paperauthor$authorid,train_autid),]


### pap_aut_train1 data
pap_aut_train1=paperauthor[is.element(paperauthor$paperid,train_papid),]
pap_aut_tt=sqldf("select pap_aut_train1.authorid, big_author.id from pap_aut_train1,big_author where pap_aut_train1.authorid=big_author.big_autid")
pap_aut_train1$big_autind=pap_aut_tt$id
save(pap_aut_train1,file="pap_aut_train1.rda")



### big_autid.rda big_author.rda
big_autid=unique(paperauthor$authorid[is.element(paperauthor$paperid,train_papid)])
big_author=data.frame(id=1:length(big_autid),big_autid=big_autid)
save(big_autid,file="big_autid.rda")
save(big_author,file="big_author.rda")


### pap_aut_train2
pap_aut_train2=paperauthor[is.element(paperauthor$authorid,big_autid),]

### -- bigaut_name
bigaut_name=unique(pap_aut_train2$name)
bigaut_name=bigaut_name[bigaut_name!=""]
save(bigaut_name,file="bigaut_name.rda")
bigaut_name1=data.frame(id=1:length(bigaut_name),name=bigaut_name)
###

### -- nameind& big_autind
tt=sqldf("select pap_aut_train2.name, bigaut_name1.id from pap_aut_train2 left join bigaut_name1 on bigaut_name1.name=pap_aut_train2.name")
pap_aut_train2$nameind=tt$id

tt=sqldf("select pap_aut_train2.authorid, big_author.id from pap_aut_train2 left join big_author on pap_aut_train2.authorid=big_author.big_autid")
pap_aut_train2$big_autind=tt$id
### --
save(pap_aut_train2,file="pap_aut_train2.rda")

### pap_aut_train3
pap_aut_train3=paperauthor[is.element(paperauthor$authorid,autid),]
save(pap_aut_train3,file="pap_aut_train3.rda")

### pap_aut_train4
pap_aut_train4=paperauthor[is.element(paperauthor$authorid,train_autid),]
save(pap_aut_train4,file="pap_aut_train4.rda")

### pap_aut_train5
pap_aut_train5=paperauthor[is.element(paperauthor$paperid,pap_aut_train4$paperid),]
save(pap_aut_train5,file="pap_aut_train5.rda")

### big_papid2
big_papid2=unique(pap_aut_train5$paperid)
save(big_papid2,file="big_papid2.rda")

### big_autid2
big_autid2=unique(paperauthor$authorid[is.element(paperauthor$paperid,big_papid2)])
save(big_autid2,file="big_autid2.rda")

### pap_aut_train6
pap_aut_train6=paperauthor[is.element(paperauthor$authorid,big_autid2),]
save(pap_aut_train6,file="pap_aut_train6.rda")



### train_aut_name
train_autid1=data.frame(id=1:length(train_autid),autid=train_autid)
tt=sqldf("select train_autid1.autid, author.name from train_autid1 left join author on train_autid1.autid=author.id")
train_aut_name=tt$name
save(train_aut_name,file="train_aut_name.rda")



### train_new train_new_dup0 valid_new, get the data (with features) from tomhall
### ,see the details of data_preparation.R



