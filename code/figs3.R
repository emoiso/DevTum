#!/bin/Rscript
#Author: Enrico Moiso
#email: em.metaminer@gmail.com
#Date: 09/23/2019


#this scripts generate the figure figs3A
#it also load the correlation table for tcga-hfo and the moca to hfo mapping

load('dep_files/figs3.rsave')

#
pdf('figs/paper/figs3a.pdf',height = 15,width = 10)
pheatmap::pheatmap(z1$mc[z1_hcl$mc$r$order, z1_hcl$mc$c$order], scale = 'column',col=c(rev(brewer.pal(9, 'Blues'))[-9],'grey80',
                                                                                       brewer.pal(9, 'Reds')[-1]),cluster_rows = F, cluster_cols = F,
                   gaps_col = c(5,8,39,45,54,59),gaps_row =c(23,32,49,68,71,73),fontsize = 18)
dev.off()