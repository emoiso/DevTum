#!/bin/Rscript
#Author: Enrico Moiso
#email: em.metaminer@gmail.com
#Date: 02/29/2022

#this script perform the analysis of the distance between the concordat and the discordant prediction, as well as the distance within the discordant preditcions as see in figs14b
library(lsa)

load('dep_files/discordant_prediction_labs.rsave')
res=read.delim('dep_files/data_fig5_class_res.csv.gz',sep=',',stringsAsFactors = F)
labs=read.delim('dep_files/data_fig5_test_lables.csv.gz',sep=',',stringsAsFactors = F)
res=res[match(rownames(res),labs$value),]


faroff=do.call('rbind',lapply(1:nrow(res),function(x1){
  q2=res[x1,]
  tail(colnames(sort(q2)),n=3)
}))
rownames(faroff)=rownames(res)
colnames(faroff)=3:1

faroff_scores=as.data.frame(do.call('rbind',lapply(1:nrow(res),function(x1){
  q2=res[x1,]
  if(rownames(q2)%in%discordant_pred$value){
    a=c(ifelse(q2==as.numeric(q2[faroff[x1,3]]),5,0),
        ifelse(q2==as.numeric(q2[faroff[x1,2]]),3,0),
        ifelse(q2==as.numeric(q2[faroff[x1,1]]),2,0))  
    a}else{
      a=c(ifelse(q2==as.numeric(q2[faroff[x1,3]]),5,0),
          ifelse(q2==as.numeric(q2[faroff[x1,3]]),5,0),
          ifelse(q2==as.numeric(q2[faroff[x1,3]]),5,0))
    }
  a  
})))
rownames(faroff_scores)=rownames(res)
faroff_scores=t(faroff_scores)

#this takes some time to run
faroff_scores_dist=lsa::cosine(faroff_scores)

library(umap)
umap.33=umap.defaults
umap.33$n_neighbors=5
set.seed(123456)
a3_u_1=umap(faroff_scores_dist, a=1, b=1, ret_nn=T,config = umap.33)
z=umap(faroff_scores_dist,a=0.01,b=.5,nn_method=a3_u_1$knn)

par(mfrow=c(1,1))
par(mar=c(.1,.1,.1,.1))
plot(z$layout)

