
library(sqldf)

### for later python features; notin means which columns you don't want to include in new combine features
### in the case below, just set it to NULL
get.newdata<-function(old,new_features,valid,notin=1:7)
{
  new=cbind(old,new_features[1:233960,-notin])
  new_dup0=new[new$dup!=1,]
  new_dup0$dup=NULL
  valid_new=cbind(valid,new_features[233961:321903,-notin])
  return(list(train_new=new,train_new_dup0=new_dup0,valid_new=valid_new))
}

#########################################################################################
### -- get the data from yingzhen # set the txt path; the colnames is V1 V2 V3 for default
bench_confirm1=read.table("F:/kdd/2013 kdd/yingzhen/关于journal_conference name 的特征/TrainConfirmed_subject.txt")
bench_delete1=read.table("F:/kdd/2013 kdd/yingzhen/关于journal_conference name 的特征/TrainDeleted_subject.txt")
bench_valid1=read.table("F:/kdd/2013 kdd/yingzhen/关于journal_conference name 的特征/ValidPaper_subject.txt")

bench_confirm1=unique(bench_confirm1)
bench_delete1=unique(bench_delete1)
bench_valid1=unique(bench_valid1)

### check the order; if not the same, join the table using train_con/train_del/valid
### tt=rbind(bench_delete1,bench_confirm1,bench_valid1)

### load("train.rda")
### all(tt[,1]==train[,1])
### all(tt[,2]==train[,2])

### if not the same
### load("train_con.rda"); load("train_del.rda"); load("valid.rda")


tr_con=sqldf("select * from train_con left join bench_confirm1 on bench_confirm1.V1=train_con.authorid and bench_confirm1.V2=train_con.paperid")
tr_del=sqldf("select * from train_del left join bench_delete1 on bench_delete1.V1=train_del.authorid and bench_delete1.V2=train_del.paperid")
tr_valid=sqldf("select * from valid left join bench_valid1  on bench_valid1.V1=valid.authorid and bench_valid1.V2=valid.paperid")


########################################################################

### change the "new_name" below
py_new=data.frame(new_name=c(tr_del$V3,tr_con$V3,tr_valid$V3))

### assume you want to combine the features with train_new4/ valid_new4 
### (actually it's the latest version, so you need to combine the new features with train_new4/valid_new4) 
### to get train_new5/ train_new5_dup0 (the duplicate records in confirmed & deleted has been deleted,
### we just use the *_dup0 version for later training)/ valid_new5
load("train_new4.rda")
load("valid_new4.rda")

newdata=get.newdata(old=train_new4,new_features=py.new,valid=valid_new4,notin=NULL)

train_new5=newdata[[1]]
train_new5_dup0=newdata[[2]]
valid_new5=newdata[[3]]

save(train_new5,file="train_new5.rda")
save(train_new5_dup0,file="train_new5_dup0.rda")
save(valid_new5,file="valid_new5.rda")

  
  