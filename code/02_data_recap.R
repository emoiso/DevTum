#!/bin/Rscript
#Author: Enrico Moiso
#email: em.metaminer@gmail.com
#Date: 09/23/2019

#This script does: 
#1 take as input the results (e) produced by correlation.R stored in folder (e1)  
#2 wrap up all the results (e) in folder (e1) into a big data.frame that contains 1331000rows x amount of samples for dataset (a), and saves it to (e3)
#3 center and scale corr coefficient in (e3), columnwise (human samples) and generate df (e4t)
#4 perform mean across all cells for each columns (tissue) and generates df (e6t)
#5 agggregates per developmental trajectory all the tissue averaged centered and scaled scores from step 4 (e7). e7 is a dataframe of 56 rows (MOCA sub trajectories) and a variable amount of TCGA samples (depending of how many saple type data_recap.R has been run on)

library(parallel)
library(data.table)
load('dep_files/cell_annotations.rsave')

path_to_e='' #file path
results_e=dir(path_to_e,full.names = T)
output_e3='' #file path
output_e4t='' #file path 
output_e6t='' #file path
output_z1='' #file path
ncores=detectCores() 

#1
e2=mclapply(1:length(results_e),function(x){
  load(results_e[x])
  a1=as.data.frame(e)
  a1=cbind(rownames(a1), a1)
}, mc.cores = ncores)
#2
e3=rbindlist(e2)
rm(e2)
gc()
class(e3)='data.frame'
rownames(e3)=e3[,1]
e3=e3[,-1]
save(e3, file = output_e3) #modificato
#3
e4t=scale(e3, center=T, scale=T)
save(e4t, file = output_e4t)
#4
e5t=parallel::mclapply(rownames(e4t),function(x){
  data.frame(
    sample=x,
    mean=mean(as.numeric(e4t[x,])),
    stringsAsFactors=F)
},mc.cores=ncpu)
e6t=rbindlist(e5t)
class(e6t)='data.frame'
rm(e5t,e4t)
gc()
save(e6t, file=output_e6t)
#5
e7=t(scale(t(e6t[,2])))
rownames(z1)=e6t[,1]
e7=merge(cell_annotations, e7, by.x = 1, by.y=0)
e7=aggregate(mean~Sub_trajectory_name.y,data=e7,mean)
file(z1,file=output_z1)

