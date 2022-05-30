#!/bin/Rscript
#Author: Enrico Moiso
#email: em.metaminer@gmail.com
#Date: 09/23/2019

#This script does: 
#1 take as input data.frame (df)/matrix of gene expression profile for tumor samples (a) and moca cells subset (b). (a) and (b) must be in a gene (rows) x sample (columns) format
#2 check for rownames consitency and correct order for both inputs
#3 perform Spearman correlation between (a) and (b)
#4 generate a df (e) correlation coefficinet axb
#1-4 must be repreated for n times where n is the number of dfs the cell expression matrix ha been divided into

library(Matrix)
path_to_a=''
path_to_a=''
output_e=''

input_a=dir(path_to_a,full.names = T)
input_b=dir(path_to_b,full.names = T)

load(input_a)
load(input_b)
b=b[rownames(b)%in%rownames(a),]  
b=b[match(rownames(a),rownames(b)),] 
e=cor(b,t(a),method='spearman')
save(e, file=output_e)