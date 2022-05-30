#!/bin/Rscript
#Author: Enrico Moiso
#email: em.metaminer@gmail.com
#Date: 09/23/2019

#This script does: 
#1 generate deconvolution
#require cell_annotations.rsave

library(data.table)

input='' #file path to file (e3) from 01_data.recap.R results 
output='' #file path to results folder
load('dep_files/cell_annotations.rsave')
load(input)

#rank transformation
tum_deconvo=lapply(colnames(e3),function(i){
  a1=e3[,i]
  names(a1)=rownames(e3)
  a2=names(tail(sort(a1), n = 1331))
  a3=names(head(sort(a1), n = 1331))
  list(top=data.frame(rank=1:1331,
                      subtyestime=gsub(' ','_',gsub('^ ','',cell_annotations[match(a2,cell_annotations[,1]),3], fixed=F))
  ),
  
  bottom=a3)
})
names(tum_deconvo)=colnames(e3)
save(tum_deconvo, file=paste0(output,'tum_deconvo.rsave'))
a2=rbindlist(lapply(tum_deconvo, '[[',1),idcol=T)
class(a2)='data.frame'
colnames(a2)[1]=sample
save(a2, file=paste0(output,'tum_deconvo_df.rsave'))
#matrix creation
a2_m=as.data.frame.matrix(xtabs(rank~.id+subtyestime, data=a2))
save(a2_m,file=paste0(output,'rank_m.rsave'))

