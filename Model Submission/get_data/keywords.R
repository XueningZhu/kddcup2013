

#������������ʱ�����æ��飬��ӭ���估�޸�

#������Ĭ��·��
setwd("~/kdd_data/rda")
load("paper.rda")
keyword=as.character(paper$keyword)
notNULL=which(keyword!=""&is.na(keyword)==F)
#keyword[notNULL]=""
keyword=keyword[notNULL]
keyword=gsub("(\\w+)", "\\L\\1",keyword, perl=TRUE)




#������������������ʽ�Ĳ���
#������������ʽ�﷨��http://msdn.microsoft.com/zh-cn/library/ae5bf541(v=vs.80).aspx
#R ����غ�����help grep
#tm ���������pdf��˼���ı��ھ�ƪ

#1��
#��Щkeywords�ڲ����߿�ͷ���ֻ�ע��keywords:����index terms:�����ּǺţ���ʽ���ܲ�Ψһ��
#��ƥ�����ʽ���������������ʽ���֣�����㷢��������ʽ�Ŀ�ͷ��ǣ����֪��
#2��
#��ʱkeywords֮ǰ�������������keywords��Ϣ������Ϊ���ǵļ������keywords�������Ǳ��Ϊfirstkey

#������δ���ȥ��keywords��ͷ��˵����ǣ�ͬʱ���firstkey(�������keywords)��
######trim the key first ###########

key.trim<-function(word)
{
  end=nchar(word)+2
  a=gregexpr("[\\(\\-��.,\\s:]*index[\\s-��]*terms*[\\s:.\\-��,;]*",word,perl=T,ignore.case=T)
  show(word);show(a);
  if (a[[1]][1]!=-1)
    word=substr(word,a[[1]][1]+attr(a[[1]],"match.length")[1],end)
  
  a=gregexpr("[\\(\\-��.,\\s:]*Key[\\s-��]*words(\\sand\\sphrases)*[\\s:.\\-��,;]*",word,perl=T,ignore.case=T)
  if (a[[1]][1]==-1) return(c(word,""))
  
  start=a[[1]][1]+attr(a[[1]],"match.length")[1]
  b=gregexpr(":\\s*",substr(word,start,end),perl=T)
  if (b[[1]][1]!=-1) start=b[[1]][1]+start+attr(b[[1]],"match.length")-1
  
  if (a[[1]][1]==1)
  {
    return(c(substr(word,start,end),""))
  }
  if (a[[1]][1]>1)
  {
    spl=unlist(strsplit(word,substr(word,a[[1]][1],start),fixed=T))
    if (is.na(spl[2])) spl[2]=spl[1]
    return(spl[2:1])
  }
}

a=grepl("Key[\\s\\-��]*words",keyword,perl=T,ignore.case=T)
b=grepl("index[\\s\\-��]*terms",keyword,perl=T,ignore.case=T)
index=which(a|b)
kk=lapply(keyword[index],key.trim)
k=matrix(unlist(kk),ncol=2,byrow=T)
keyword[index]=k[,1]
firstkey=rep("",length(keyword))
firstkey[index]=k[,2]

#keywords�ı��ָ���ʽ�ܲ���ͬ��ͬʱ�����һ�ֱ�������;������
#������ڡ�.����������Ϊ���������ָ�����ʡ�Է���������Ҫ��������Ϊ�ָ���������

#����Ϊ���ǵ����ȼ���������s����1-7��˳��һ�£�����ͨ��ind���۲����ǵ�ͳ�������
#�ҵõ��Ĺ����ǣ������ȼ�������ķָ������ǿ�ķָ���ͬʱ����ʱ��һ�������ȼ���ǿ�ķָ�����Ϊ�ָ���
#��ʱ���ȼ������ķָ�����Ϊ����;��ʹ��
#��ֻ��ע�⣬�ǡ�ֻ�����������ȼ������ķָ���ʱ��һ����Ϊ�ָ���ʹ��

#ֵ��һ����ǣ��ֺţ�;���붺�ţ�,��ͬʱʹ�õ�����
#��ʱ��,����ʾ����";"���ֵ�keywords��һ�����keywords���Ժ����ʱ���Կ��Ǹ��Բ�ͬȨ��

#���⣬��" - "���ֽṹֻ����һ��ʱ��ǰ��һ�߱�ʾ����category�����ֶ��ʱ���𵽷ָ�������
#������δ������ڷָ�keywords

######split the keywords ####
getLen<-function(vector)
{
  if (min(vector)==-1) return(0)
  else return(length(vector))
}

splitkey<-function(keyword)
{
  s=matrix(0,nrow=length(keyword),ncol=7)
  s[,1]=unlist(lapply(gregexpr(";",keyword),getLen))
  s[,2]=unlist(lapply(gregexpr("��",keyword),getLen))
  s[,3]=unlist(lapply(gregexpr("\\|",keyword),getLen))
  s[,4]=unlist(lapply(gregexpr("��",keyword),getLen))
  s[,5]=unlist(lapply(gregexpr(",",keyword),getLen))
  s[,6]=unlist(lapply(gregexpr("\\s-\\s",keyword,perl=T),getLen))
  s[,7]=unlist(lapply(gregexpr("[^0-9]\\.[^0-9]",keyword,perl=T),getLen))
  return(s)
}

s=splitkey(keyword)
#ss=splitkey(firstkey[notNULL])
#####just for stat #####
pasteind<-function(vector)
{
  if (max(vector)==0) return("0")
  else return(paste(which(vector!=0),collapse=" "))
}

ind=apply(s,1,pasteind)
ind7=which(ind=="7")
s[ind7,7][s[ind7,7]==1]=0

spl=c("\\s*;\\s*","\\s*[��/]\\s*","\\s*[/\\|]\\s*","\\s*[/��]\\s*","\\s*[,/]\\s*","\\s*[/\\-]\\s*","\\s*[\\./]\\s*")
spliter=apply(s,1,
              function(x) {
                if (max(x)==0) return(spl[1])
                else return(spl[which(x!=0)[1]])
              })
key=strsplit(keyword,spliter)

#��ʱ" - "֮ǰ���ʾ�����µĴ�����Ϣ����:Computer Science
#������δ����������������Ϣ����ȥ����ݡ��·ݣ���һЩ��ע������ʱ��ģ����ڿ���š���ҳ����
#��������Ϣ
#����������£�

#####extract the category & trim the words ####
get.cate<-function(words)
{
  cate=""
  if (words=="") return(c(cate,words))
  
  a=unlist(strsplit(words,"\\s+",perl=T))
  a=a[grepl("\\[[0-9]+\\]",a,perl=T)==F]
  a=a[a!=""]
  #  show(words)
  #if (a[1]==""|length(grep("[\\s:��-]+",a[1],perl=T))==1) a=a[-1]
  words=paste(a,collapse=" ")
  b=gregexpr("\\s-\\s",words,perl=T)
  #  show(length(b[[1]]))
  if (b[[1]][1]!=-1)
  {
    new=unlist(strsplit(words,"\\s-\\s",perl=T))
    tmp=unlist(strsplit(new[1],"[:��,]\\s*",perl=T))
    cate=tmp[length(tmp)]
    words=paste(new[-1],collapse=" ")
  }
  words=paste(unlist(strsplit(words,"[^\\s]-\\s",perl=T)),collapse="")
  c=gregexpr(",",words,perl=T)
  
  return(c(cate,words))
}

get.key.cate<-function(vector)
{
  show(vector)
  vector[grepl("(http)|(www)",vector,perl=T)]=""
  vector[grepl(paste("(\\s",paste(c(month.name,month.abb),collapse="\\s)|(\\s"),"\\s)",sep="")
               ,vector,perl=T)&grepl("\\s[12][0-9]{3}\\s",vector,perl=T)]=""
  vector=vector[vector!=""]
  if (length(vector)==0) return(list(cate="",key=""))
  show(vector)
  a=matrix(unlist(lapply(vector,get.cate)),ncol=2,byrow=T)
  #cate=paste(unique(a[,1][a[,1]!=""]),collapse=";")
  cate=unique(a[,1][a[,1]!=""])
  key=a[,2][a[,2]!=""]
  return(list(cate=cate,key=key))
}


ind1=which(!unlist(lapply(key,function(x) all(x==""))))

key.cate=list()
for (i in 1:length(ind1))
{
  show(i)
  key.cate[[i]]=get.key.cate(key[[ind1[i]]])
}


cate=lapply(key.cate,function(x) x$cate)
key2=lapply(key.cate,function(x) x$key)


#��ʱkeywords�����У���ע�������ǻ��ʾ��д��ʽ���ҽ�������������ɴ�
#������������֮����ڵġ�����û�зָ���ȫ�����Σ��ҽ�������Ϊsubkey���
#���ڳ��ֵ�ͣ�ʣ���ͣ����Ϊ�ָ�����keywords��һ���ָ�
#ȥ����������
#����x-ray???
#���ڷ�ȫ��д�ĵ��ʱ�ΪСд��ĸ
#����keyword!=""�����Σ����ս��������key3 subkey �Լ�cate��
#���������>=5�ķָ�ɵ���


##extract subkey & trim again #####
library(tm)
stopword=paste("(\\s+",paste(stopwords("en"),collapse="\\s+)|(\\s+"),"\\s+)",sep="")

modify.word<-function(word)
{
  word1=word
  n=nchar(word)
  a=gregexpr("[a-z]\\.",word,perl=T)
  if (any((a[[1]]+1)==n))
    word=substr(word,1,n-1)
  #if (grepl("[a-z]",word,perl=T))
  #   word=gsub("(\\w+)", "\\L\\1",word, perl=TRUE)
  word=unlist(strsplit(paste(" ",word," "),stopword,perl=T))
  word=word[word!=""]
  word=strsplit(word," ")
  word=unlist(lapply(word,function(x) {x=x[x!=""]; x=paste(x,collapse=" ")}))
  if (length(word)==0) return(word1)
  return(word)
}
#modify.word("aef (aef)")

remove.bracket<-function(word)
{
  word=paste(" ",word)
  ab=gregexpr("\\s\\([\\w^\\W]+\\)",word,perl=T)
  abb=NULL
  if (ab[[1]][1]!=-1)
  {
    abb=substring(word,ab[[1]]+2,ab[[1]]+attr(ab[[1]],"match.length")-2)
    word=unlist(strsplit(word,"\\s\\([\\w^\\W]+\\)",perl=T))
  }
  word=unlist(lapply(lapply(word,function(x) unlist(strsplit(x,"\\(|\\)",perl=T))),
                     paste,collapse=""))
  if (all(word=="")==F) word=word[word!=""]
  else word=""
  return(list(word=word,abb=abb))
}
#remove.bracket(" (e,e����h)")

get.subkey<-function(words)
{
  subkey=""
  c=gregexpr(",",words,perl=T)
  if (c[[1]][1]!=-1)
  {
    subkey=unlist(lapply(unlist(strsplit(words,"\\s*[,?/]\\s*",perl=T)),modify.word))
    words=""
  }
  
  words=unlist(lapply(words,modify.word))
  words=words[words!=""]
  subkey=subkey[subkey!=""]
  return(list(words=c(words),subkey=subkey))
}


get.key.subkey<-function(vector)
{
  b=lapply(vector,remove.bracket)
  vector=unlist(lapply(b,function(x) x$word))
  abb=unlist(lapply(b,function(x) x$abb))
  a=lapply(vector,get.subkey)
  words=c(unlist(lapply(a,function(x) x$words)),abb)
  subkey=unlist(lapply(a,function(x) x$subkey))
  
  
  w=strsplit(words," ")
  s=strsplit(subkey," ")
  l1=unlist(lapply(w,length))
  l2=unlist(lapply(s,length))
  ww=words[l1>4]
  ss=subkey[l2>4]
  words=c(words[l1<=4],unlist(w[l1>4]))
  subkey=c(subkey[l2<=4],unlist(s[l2>4]))
  
  notN1=grepl("[^0-9]",words,perl=T)
  notN2=grepl("[^0-9]",subkey,perl=T)
  words=words[words!=""&words!="character(0)"&notN1==T]
  subkey=subkey[subkey!=""&subkey!="character(0)"&notN2==T]
  return(list(Words=words,Subkey=subkey))      
}

#get.key.subkey(key[test>0][[33]])

kk2=list()
for (i in 1:length(key2))
{
  show(i)
  kk2[[i]]=get.key.subkey(key2[[i]])
}



kk2=lapply(key2,get.key.subkey)
key3=lapply(kk2,function(x) x$Words)
subkey=lapply(kk2,function(x) x$Subkey)
ll=unlist(lapply(subkey,length))



keyind=notNULL[ind1]
c=as.list(rep("",nrow(paper)))
Cate=c
Cate[keyind]=cate
Key=c
Key[keyind]=key3
Subkey=c
Subkey[keyind]=subkey
save(Cate,file="Cate.rda")
save(Key,file="Key.rda")
save(Subkey,file="Subkey.rda")




