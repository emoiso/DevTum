#!/bin/Rscript
#Author: Enrico Moiso
#email: moiso.enrico@gmail.com
#Date: 09/23/2019

#This script does: 
#1 generate differential DC analysis of discordantly classified samples

setwd('/home/enrico/Documenti/ME@MIT/Pdevtum/classifier_nn/kfold10/')
load('res/dis/discordant.rsave')
load('data.rsave')
load('../campioni_tcga_nontcga_mgh.rsave')
library(limma)

espr=as.data.frame(t(tcga_nontcga_mgh_rankyes_nonnorm))
dis_tcga=dis[grep('TCGA-', dis$value),]
disc_DC=lapply(unique(dis_tcga$L1),function(x){
  print(x)
  tutti=campioni$sample[campioni$dataset=='TCGA'&campioni$tum2==x]
  k1=as.character(dis_tcga$value[dis_tcga$L1==x])
  k2=tutti[!tutti%in%k1]
  matrix=cbind(espr[,k1],espr[,k2])
  f=(rbind(data.frame(sample=k1, group="k1"), data.frame(sample=k2, group= "k2")))
  f=f[,-1]
  design=model.matrix(~0+f)
  cont.matrix=makeContrasts(k1_VS_k2="fk1-fk2", levels = design)
  fit=lmFit(matrix, design)
  fit2=contrasts.fit(fit, cont.matrix)
  fit2=eBayes(fit2)
  res=topTable(fit2, number = Inf)
})
names(disc_DC)=unique(dis_tcga$L1)
disc_DC_lfc=lapply(names(disc_DC), function(x){
  x1=data.frame(dc=rownames(disc_DC[[x]]) , lfc=disc_DC[[x]][,1])
  colnames(x1)[2]=x
  x1
})
disc_DC_pa=lapply(names(disc_DC), function(x){
  x1=data.frame(dc=rownames(disc_DC[[x]]) , pa=disc_DC[[x]][,5])
  colnames(x1)[2]=x
  x1
})

merge_all=function(x,y){df=merge(x,y,by="dc",all.x=T);return(df)}

all_lfc=Reduce(merge_all, disc_DC_lfc)
rownames(all_lfc)=all_lfc$dc


