#!/bin/Rscript
#Author: Enrico Moiso
#email: moiso.enrico@gmail.com
#Date: 09/23/2019

#This script does: 
#1 aggregate dfs (e6t) from data.recap.R
#2 select, scale and average mean correlation coefficients for each tumor type



library(parallel)

overall_mean_scores_z_o=''
overall_mean_scores_noz_o=''
full_z_o=''

ncores=detectCores()

# overall_mean_scores=parallel::mclapply(
#   grep('single',invert=T,value=T,
#        grep('scores', value = T, 
#             dir('/home/emoiso/data/DATA/Pdevtum/recap2', full.names = T))), function(x){
#               load(x)
#               a1=e6t[,c(1,2)] 
#             }, mc.cores = ncores)
# names(overall_mean_scores)=gsub('cor_','',
#                                 gsub('_tscores.rsave','',
#                                      grep('single',invert=T,value=T,
#                                           (grep('scores', value = T, 
#                                                 dir('/home/emoiso/data/DATA/Pdevtum/recap2', full.names = F)
#                                           )
#                                           )
#                                      )
#                                 )
# )
# names(overall_mean_scores)=gsub('_01', '_TP', names(overall_mean_scores))
# names(overall_mean_scores)=gsub('_11', '_NT', names(overall_mean_scores))
# names(overall_mean_scores)=gsub('_06', '_TM', names(overall_mean_scores))
# names(overall_mean_scores)=gsub('_02', '_TR', names(overall_mean_scores))
# names(overall_mean_scores)=gsub('_03', '_TB', names(overall_mean_scores))
# names(overall_mean_scores)=gsub('_05', '_TAP', names(overall_mean_scores))
# names(overall_mean_scores)=gsub('_07', '_TAM', names(overall_mean_scores))

overall_samples=lapply(overall_mean_scores, '[[',1)
common=Reduce('intersect',overall_samples)
overall_mean_scores_df=Reduce('cbind',parallel::mclapply(overall_mean_scores,'[',2, mc.cores = 20))
colnames(overall_mean_scores_df)=names(overall_mean_scores)
rownames(overall_mean_scores_df)=common
save(overall_mean_scores_df, file=overall_mean_scores_noz_o)

overall_mean_scores_z=t(scale(t(overall_mean_scores_df)))
save(overall_mean_scores_z, file=overall_mean_scores_z_o)

full_z=merge(cell_annotations, overall_mean_scores_df, by.x = 1, by.y=0)
full_z$Sub_trajectory_name=gsub(' ','_',fixed=T, full_z$Sub_trajectory_name)
full_z$Sub_trajectory_name=gsub('/','_',fixed=T, full_z$Sub_trajectory_name)
save(full_z, file =full_z_o)
