#!/bin/Rscript
#Author: Enrico Moiso
#email: em.metaminer@gmail.com
#Date: 02/29/2022

#this files generate the plot for the fig2s
#this scripts load info for mgh correlation with tcga




load('dep_files/data_figs2.rsave')

pdf('figs/paper/figs2.pdf',height = 20,width = 10)
pheatmap::pheatmap(e4_single,clustering_method = 'ward.D',cluster_rows = full_z_scores_hct,
                   annotation_col = data.frame(Correlation_with_TCGA=a3$R,Sample_type=a3$tumor_type, row.names = a3$sample_id),
                   col=c(rev(brewer.pal(9,'Blues')),'white',brewer.pal(9,'Reds')),scale = 'row',
                   fontsize_col = 9,treeheight_col = 15,treeheight_row = 0,labels_col = gsub('D20-247','MGH',colnames(e4_single)),
                   labels_row = gsub('primitive_er','Primitive_er',gsub('_trajectory', '',rownames(e4_single))),annotation_row = annotazioni_t,annotation_colors = mycolors2
)
dev.off()