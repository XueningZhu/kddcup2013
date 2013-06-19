
## for the third cbind of data
## using the second result train_new/ train.refeatures/ valid_new

load("train_new.rda")
load("train.refeatures.rda")
load("valid_new.rda")

## for later new features

get.newdata<-function(old,new_features,valid,notin=1:7)
{
  new=cbind(old,new_features[1:233960,-notin])
  new_dup0=new[new$dup!=1,]
  new_dup0$dup=NULL
  valid_new=cbind(valid,new_features[233961:321903,-notin])
  return(list(train_new=new,train_new_dup0=new_dup0,valid_new=valid_new))
}

newdata=get.newdata(old=train_new,new_features=train.refeatures,valid=valid_new)

train_new1=newdata[[1]]
train_new1_dup0=newdata[[2]]
valid_new1=newdata[[3]]


save(train_new1,file="train_new1.rda")
save(train_new1_dup0,file="train_new1_dup0.rda")
save(valid_new1,file="valid_new1.rda")

####for the fourth time
load("train.reverse.rda")
load("train_new1.rda")
load("valid_new1.rda")

newdata=get.newdata(old=train_new1,new_features=train.reverse,valid=valid_new1,notin=1:10)

train_new2=newdata[[1]]
train_new2_dup0=newdata[[2]]
valid_new2=newdata[[3]]

save(train_new2,file="train_new2.rda")
save(train_new2_dup0,file="train_new2_dup0.rda")
save(valid_new2,file="valid_new2.rda")

####for the fifth time (the five simple features)
load("train_new2.rda")
load("train_new2_dup0.rda")
load("valid_new2.rda")

newdata=get.newdata(old=train_new2,new_features=simple_feature,valid=valid_new2,notin=1:2)

train_new3=newdata[[1]]
train_new3_dup0=newdata[[2]]
valid_new3=newdata[[3]]

save(train_new3,file="train_new3.rda")
save(train_new3_dup0,file="train_new3_dup0.rda")
save(valid_new3,file="valid_new3.rda")

#### for the sixth combination
load("train_con.rda")
load("train_del.rda")
load("valid.rda")

### -- get the data from yingzhen # set the txt path
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

### get the data from hetong
load("train.last.rda")
train.last$V8=c(bench_delete1[,3],bench_confirm1[,3],bench_valid1[,3])
load("train_new3.rda")
load("valid_new3.rda")
newdata=get.newdata(old=train_new3,new_features=train.last,valid=valid_new3,notin=1:10)

train_new4=newdata[[1]]
train_new4_dup0=newdata[[2]]
valid_new4=newdata[[3]]

save(train_new4,file="train_new4.rda")
save(train_new4_dup0,file="train_new4_dup0.rda")
save(valid_new4,file="valid_new4.rda")




