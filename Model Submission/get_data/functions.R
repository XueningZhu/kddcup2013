##### packages needed #####
library(slam)
library(topicmodels)
library(RWeka)
library(Snowball)
library(Matrix)
library(tm)
library(cluster)
library(gregmisc)
library(parallel)
library(proxy)

setwd("F:/kdd/2013 kdd/rda")
##### rda needed #####
#load("comJ.rda")
#load("comC.rda")
#load("author.rda")
#load("journal.rda")
#load("conference.rda")
#load("paper.rda")
#load("paperauthor.rda")
#load("trainconfirmed.rda")
#load("traindeleted.rda")
load("stops.rda")
#load("com.rda")
#load("com_all.rda")
##### combine features for single paper #######
##### features including title & keyword ######
##### of which wei indicating the weight ######

split.vector<-function(l,n)
{
  avg=floor(l/n)
  res=list()
  for (i in 1:(n-1))
  {
    res=c(res,list((avg*(i-1)+1):(avg*i)))
  }
  res=c(res,list((avg*(n-1)+1):l))
  return(res)
}

comb<-function(i,wei,cate,key,subkey,title_key)
{
  a=c(table(cate[[i]])*wei[1],table(key[[i]])*wei[2],
      table(subkey[[i]])*wei[3],table(title_key[[i]])*wei[4])
  name=unique(names(a))
  name=name[name!=""]
  if (length(name)==0) return(0)
  c=unlist(lapply(name,function(x) sum(a[x])))
  names(c)=name
  return(c)
}

##### combine organizations: journal, conference and affiliations #####
##### com_all is needed for the papers belong to the organization #####

comOrg<-function(com_all,orgid,allid,onlyname=F,comN)
{
  comO=list()
  for (i in 1:length(orgid))
  {
    show(i)
    id=which(allid==orgid[i])
    if (onlyname==F) a=unlist(com_all[id])
    else  a=c(unlist(com_all[id]),comN[[i]])
    
    name=unique(names(a))
    
    name=name[name!=""]
    if (length(name)==0) comO[[i]]=0
    else
    {
      c=unlist(lapply(name,function(x) sum(a[x])))
      names(c)=name
      comO[[i]]=c
    }
  }
  return(comO)
}

##### for organization names ######
removeStops<-function(corpus,stops,m=1000)
{
  n=length(stops)
  for (i in 1:ceiling(n/m))
  {
    if (i==ceiling(n/m))
      corpus= tm_map(corpus, removeWords, stops[((i-1)*m):n])
    else
      corpus= tm_map(corpus, removeWords, stops[((i-1)*m):(i*m)])
  }
  return(corpus)
}
#mc <- getOption("mc.cores", 5)
deNoise<-function(text,stem=T,lower=T)
{
  docs=as.character(text)
  corpus=Corpus(VectorSource(docs))
  for (i in 1:length(corpus)){
 #   cat(i,"\n")
    Encoding(corpus[[i]])<-"UTF-8"}
  #  corpus=mclapply(1:length(corpus), 
  #                  function(i) Encoding(corpus[[i]])<-"UTF-8", 
  #                  mc.cores = mc)

  corpus= tm_map(corpus, stripWhitespace)
  corpus= tm_map(corpus, removeNumbers)
  corpus= tm_map(corpus, removePunctuation)
  
  if (lower==T)
    corpus= tm_map(corpus, tolower)
  corpus= tm_map(corpus, removeWords, c("and","of","the"))
  #corpus1=unlist(inspect(corpus))
  c1=inspect(corpus)
  
  #split and stemming
  key=lapply(c1,function(x) {#x=gsub("[^a-z]"," ",x,perl=T);
    x=unlist(strsplit(x," ",perl=T)); 
    if(stem==T) x=SnowballStemmer(x)
    x=x[x!=""]
    })
#  key=lapply(key,function(x) {x=x[grepl("(\\s)+((univers|univ)|(depart|dept.*)|(lab)|(school)|(instit|inst.*)|(resear)|(center)|(nation))(\\s)+",
#                                        x,perl=T)==F];x=x[x!=""]})
  ll=unlist(lapply(key,length))
  key[ll<=1]=as.list(docs[ll<=1])
  return(key)
}
comName<-function(full,short)
{
  cc=list()
  for (i in 1:length(full))
  {
    show(i)
    a=c(table(full[[i]]),table(short[[i]]))
    name=unique(names(a))
    name=name[name!=""]
    if (length(name)==0|all(is.na(a))) cc[[i]]=0
    else
    {
      c=unlist(lapply(name,function(x) sum(a[x])))
      names(c)=name
      cc[[i]]=c
    }
  }
  return(cc)
}

####get sparsematrix #######

get.col<-function(com)
{
  col=unique(unlist(lapply(com,function(x) names(x))))
  return(col)
}


get.mat<-function(col,com,M=F)
{
  nrow=length(com);ncol=length(col)
  ijv=NULL
  for (i in 1:length(com))
  {
    cat(i,"\n")
    ii=which(is.element(col,names(com[[i]])))
    ijv=rbind(ijv,cbind(i,ii,as.vector(com[[i]])))
  }
  if (M==T)
    mat=sparseMatrix(ijv[,1],ijv[,2],ijv[,3],
                     dims=c(nrow,ncol))
  else
    mat=simple_triplet_matrix(ijv[,1],ijv[,2],ijv[,3], dimnames = NULL)
  
  colnames(mat)=col
  return(mat)
}

#### topic models #########
####for more details, please download the pdf:
## http://cran.r-project.org/web/packages/topicmodels/vignettes/topicmodels.pdf

###### get matrix to model the relationships between the entities ####

#get aut-aut matrix due to the exact relationship
get.auau<-function(author)
{
  aff=unique(author$affiliation)
  aff=aff[aff!=""]
  ijv=NULL
  for(i in 1:length(aff))
  {
    ind=which(author$affiliation==aff[i])
    ijv=rbind(ijv,cbind(permutations(length(ind),2,ind,repeats.allowed=T),1))
  }
  mat=sparseMatrix(ijv[,1],ijv[,2],x=ijv[,3],dims=c(length(author$id),length(author$id)))
  mat[cbind(1:length(author$id),1:length(author$id))]=1
  colnames(mat)=author$id
  return(mat)
}



#modify the author-author matrix according to the dist between the affs
get.auau.distMat<-function(author,dist_aff_dtm)
{
  
  aff=unique(author$affiliation)
  aff=aff[aff!=""]
  ijv=NULL
  
  for(i in 1:length(aff))
  {
    for (j in 1:i)
    {
      rowid=which(author$affiliation==aff[i])
      
      colid=which(author$affiliation==aff[j])
      
      ijv=rbind(ijv,cbind(rep(rowid,each=length(colid)),
                          rep(colid,length(rowid)),
                          1-dist_aff_dtm[i,j]))
      
    }
    
  }
  mat=sparseMatrix(ijv[,1],ijv[,2],x=ijv[,3],dims=c(length(author$id),length(author$id)))
  mat=mat+t(mat)
  mat[cbind(1:length(author$id),1:length(author$id))]=1
  colnames(mat)=author$id
  return(mat)
}


####get the paper-author matrix according to the confirmed deleted paperauthor matrix

get.aut_pap<-function(train,author,paper,v)
{
  aut=unique(author$id)
  pap=unique(paper$id)
  ijv=NULL
  for (i in 1:nrow(train))
  {
    rowid=which(aut==train[i,"authorid"])
    colid=which(pap==train[i,"paperid"])
    ijv=rbind(ijv,cbind(rowid,colid,v))
  }
  mat=sparseMatrix(ijv[,1],ijv[,2],x=ijv[,3],dims=c(length(aut),length(pap)))
  rownames(mat)=aut
  colnames(mat)=pap
  return(mat)
}

#### paper-paper

####paper-paper belong to the same organization
get.papaOrg<-function(paper,org,cha)
{
  orgid=unique(org$id)
  ijv=NULL
  
  for(i in 1:length(orgid))
  {
    ind=which(paper[,cha]==orgid[i])
    ijv=rbind(ijv,cbind(permutations(length(ind),2,ind,repeats.allowed=T),1))
  }
  mat=sparseMatrix(ijv[,1],ijv[,2],x=ijv[,3],dims=c(length(paper$id),length(paper$id) ))
  mat[cbind(1:length(paper$id),1:length(paper$id))]=1
  colnames(mat)=paper$id
  return(mat)
}

### organization-paper matrix using similarity of texts
get.Org_pap.dist<-function(comJ,com,ind,journal,paper)
{
  comJ_ind=which(unlist(lapply(comJ,function(x) !all(x==0))))
  comJJ=comJ[comJ_ind]
  com_ind=which(unlist(lapply(com,function(x) !all(x==0))))
  comm=com[com_ind]
  dist=Matrix(0,length(comJJ),length(comm),sparse=T)
  for (i in 1:length(comJJ))
  {
    for (j in 1:length(comm))
    {
      name=unique(get.col(c(comJJ[i],comm[j])))
      v1=rep(0,length(name))
      v2=rep(0,length(name))
      names(v1)=name
      names(v2)=name
      v1[names(comJJ[[i]])]=scale(comJJ[[i]],center=F)
      v2[names(comm[[j]])]=scale(comm[[j]],center=F)
      dist[i,j]=1-matrix(v1,nrow=1)%*%matrix(v2,ncol=1)
    }
  }
  dd=Matrix(0,length(journal$id),length(paper$id),sparse=T)
  dd[comJ_ind,ind[com_ind]]=dist
  return(dd)
}


smp<-function(cross=5,n,seed)
{
  set.seed(seed)
  dd=list()
  aa0=sample(rep(1:cross,ceiling(n/cross))[1:n],n)
  for (i in 1:cross) dd[[i]]=(1:n)[aa0==i]
  return(dd)
}


selectK<-function(dtm,kv=seq(5,50,5),SEED=2013,cross=5)
{
  per_gib=NULL
  log_gib=NULL
  for (k in kv)
  {
    per=NULL
    loglik=NULL
    for (i in 1:cross)
    {
      te=sp[[i]]
      tr=setdiff(1:nrow(dtm),te)
      Gibbs = LDA(dtm[tr,], k = k, method = "Gibbs",
                  control = list(seed = SEED, burnin = 1000,
                                 thin = 100, iter = 1000))
      per=c(per,perplexity(Gibbs,newdata=dtm[te,]))
      loglik=c(loglik,logLik(Gibbs,newdata=dtm[te,]))
    }
    
    per_gib=rbind(per_gib,per)
    log_gib=rbind(log_gib,loglik)
  }
  return(list(perplex=per_gib,loglik=log_gib))
}

get.topic<-function(dtm,k=seq(10,200,10),SEED=2013,cross=5,gibK)
{
  m_per=apply(gibK[[1]],1,mean)
  m_log=apply(gibK[[2]],1,mean)
  K=mean(c(k[which.min(m_per)],k[which.max(m_log)]))
  
  TM <- list(VEM = LDA(dtm, k = K, control = list(seed = SEED)),
             VEM_fixed = LDA(dtm, k = K,
                             control = list(estimate.alpha = FALSE, seed = SEED)),
             Gibbs = LDA(dtm, k = K, method = "Gibbs",
                         control = list(seed = SEED, burnin = 1000,
                                        thin = 100, iter = 1000)),
             CTM = CTM(dtm, k = K,
                       control = list(seed = SEED,
                                      var = list(tol = 10^-4), em = list(tol = 10^-3))))
  return(TM)
}


get.author.paper<-function(data,com_all)
{
  autid=unique(data$authorid)
  comAut=list()
  for (i in 1:length(autid))
  {
    pid=data$paperid[data$authorid==autid[i]]
    a=unlist(com_all[pid])
    
    name=unique(names(a))
    
    name=name[name!=""]
    if (length(name)==0) comAut[[i]]=0
    else
    {
      c=unlist(lapply(name,function(x) sum(a[x])))
      names(c)=name
      comAut[[i]]=c
    }
  }
  return(comAut)
}







comAut<-function(paperauthor,com_all,orgid,allid)
{
  comO=list()
  for (i in 1:length(orgid))
  {
    show(i)
    id=paperauthor$papind[which(allid==orgid[i])]
    id=id[!is.na(id)]
    #if (onlyname==F) a=unlist(com_all[id])
    #else  
    a=unlist(com_all[id])
    
    name=unique(names(a))
    
    name=name[name!=""]
    if (length(name)==0) comO[[i]]=0
    else
    {
      c=unlist(lapply(name,function(x) sum(a[x])))
      names(c)=name
      comO[[i]]=c
    }
  }
  return(comO)
}
com_Aff<-function(orgid,allid,com_aut_big)
{
  comO=list()
  for (i in 1:length(orgid))
  {
    show(i)
    id=which(allid==orgid[i])
    #if (onlyname==F) a=unlist(com_all[id])
    #else  
    a=unlist(com_aut_big[id])
    
    name=unique(names(a))
    
    name=name[name!=""]
    if (length(name)==0) comO[[i]]=0
    else
    {
      c=unlist(lapply(name,function(x) sum(a[x])))
      names(c)=name
      comO[[i]]=c
    }
  }
  return(comO)
}

