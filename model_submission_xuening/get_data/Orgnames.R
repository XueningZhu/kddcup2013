
setwd("~/kdd_data/rda")
#add the source path
source("functions.R")
load("journal.rda")
load("conference.rda")
#####remove the stops, punctuation,number and lower the letters ####
#### get the single words, not the phrases #######


#J_fkey=deNoise(journal$fullname)
#J_skey=deNoise(journal$shortname,stem=F,lower=F)
#C_fkey=deNoise(conference$fullname)
#C_skey=deNoise(conference$shortname,stem=F,lower=F)

ll=nrow(journal)
n=ceiling(ll/100)

J_fkey=list()

for (i in 1:n)
{
  cat(i,"\n")
  J_fkey=c(J_fkey,deNoise(journal$fullname[(100*(i-1)+1):min(100*i,ll)]))
}
J_skey=list()
for (i in 1:n)
{
  cat(i,"\n")
  J_skey=c(J_skey,deNoise(journal$shortname[(100*(i-1)+1):min(100*i,ll)],stem=F,lower=F))
}
comJN=list()
for (i in 1:n)
{
  cat(i,"\n")
  comJN=c(comJN,comName(J_fkey[(100*(i-1)+1):min(100*i,ll)],
                        J_skey[(100*(i-1)+1):min(100*i,ll)]))
}

ll=nrow(conference)
n=ceiling(ll/100)
C_fkey=list()
for (i in 1:n)
{
  cat(i,"\n")
  C_fkey=c(C_fkey,deNoise(conference$fullname[(100*(i-1)+1):min(100*i,ll)]))
}
C_skey=list()
for (i in 1:n)
{
  cat(i,"\n")
  C_skey=c(C_skey,deNoise(conference$shortname[(100*(i-1)+1):min(100*i,ll)],stem=F,lower=F))
}
comCN=list()
for (i in 1:n)
{
  cat(i,"\n")
  comCN=c(comCN,comName(C_fkey[(100*(i-1)+1):min(100*i,ll)],
                        C_skey[(100*(i-1)+1):min(100*i,ll)]))
}
comJN=comName(J_fkey,J_skey)
comCN=comName(C_fkey,C_skey)

save(comJN,file="comJN.rda")
save(comCN,file="comCN.rda")




