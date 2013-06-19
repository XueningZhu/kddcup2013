load("F:/kdd/2013 kdd/rda/original data/Traindat.rda")
library(sqldf)

bench_confirmed=read.table("F:/kdd/2013 kdd/txt/confirmed_feature_sql.txt")
bench_deleted=read.table("F:/kdd/2013 kdd/txt/deleted_feature_sql.txt")
bench_valid=read.table("F:/kdd/2013 kdd/txt/valid_feature_sql.txt")

bench_confirmed=unique(bench_confirmed)
bench_deleted=unique(bench_deleted)
bench_val=unique(bench_valid)

Train_con=Traindat[Traindat$Result==0,-1]
Train_del=Traindat[Traindat$Result==1,-1]
Train_val=Traindat[Traindat$Result==-1,-1]

tr_con=sqldf("select * from Train_con left join bench_confirmed on bench_confirmed.V1=Train_con.authorid and bench_confirmed.V2=Train_con.paperid")
tr_del=sqldf("select * from Train_del left join bench_deleted on bench_deleted.V1=Train_del.authorid and bench_deleted.V2=Train_del.paperid")
valid=sqldf("select * from Train_val left join bench_val  on bench_val.V1=Train_val.authorid and bench_val.V2=Train_val.paperid")
tr_con$V1=NULL
tr_con$V2=NULL
tr_del$V1=NULL
tr_del$V2=NULL
valid$V1=NULL
valid$V2=NULL


con=apply(Train_con[,1:2],1,paste,collapse=" ")
con_d=data.frame(dup=0,con=con)
del=apply(Train_del[,1:2],1,paste,collapse=" ")
del_d=data.frame(dup=0,del=del)
dup=data.frame(du=1,rec=intersect(con,del))
a=sqldf("select * from con_d left join dup on con_d.con=dup.rec")
a$dup[!is.na(a$du)]=1
b=sqldf("select * from del_d left join dup on del_d.del=dup.rec")
b$dup[!is.na(b$du)]=1



tr_con$dup=a$dup
tr_con$result=1
tr_del$dup=b$dup
tr_del$result=0
trainset=rbind(tr_del,tr_con)
train_dup0=trainset[trainset$dup!=1,]
train_dup0$dup=NULL

save(trainset,file="trainset.rda")
save(train_dup0,file="train_dup0.rda")
save(valid,file="valid.rda")

######for the second preparation
###### the rda has been saved, use the get_laterdata.R to cbind new data


train.new.features$AP_topic=AP_topic
train_new=cbind(trainset,train.new.features[1:233960,-(1:7)])
train_new_dup0=train_new[train_new$dup!=1,]
train_new_dup0$dup=NULL

save(train_new,file="train_new.rda")
save(train_new_dup0,file="train_new_dup0.rda")
valid_new=cbind(valid,train.new.features[233961:321903,-(1:7)])
save(valid_new,file="valid_new.rda")






