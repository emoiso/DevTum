#!/bin/Rscript
#Author: Enrico Moiso
#email: em.metaminer@gmail.com
#Date: 09/23/2019

#this files generate the plots seen in  fig6 and figS15
#it also loads the list of DC differentially represented between the 4 clusters

library(pheatmap)
library(grDevices)
load('dep_files/data_fig6b_figs15.rsave')
load('dep_files/color_annotations.rsave')


annot=data.frame(Main_trajectory=gsub(' trajectory','',z3$Main_trajectory_refined_by_cluster[order(z3$v5)]), row.names = z3$v1[order(z3$v5)],stringsAsFactors = T)
annot_col=list(Main_trajectory=unique(z3[,c(4,7)])[,2])
names(annot_col$Main_trajectory)=gsub(' trajectory','',unique(z3[,c(4,7)])[,1])

quantile_breaks <- function(xs, n = 10) {
  breaks <- quantile(xs, probs = seq(0, 1, length.out = n), na.rm=T)
  breaks[!duplicated(breaks)]
}

mat_breaks <- quantile_breaks(cups_sc2, n = 11)

my_palette <- c(colorRampPalette(colors = c( "#2D004B","#B4ACC9"))(n = 5),
                "white",
                c(colorRampPalette(colors = c("#DFB88C", "#7F3B08"))(n= 5)))

pdf('figs/paper/fig6.pdf')
pheatmap::pheatmap(t(cups_sc2[,z3$v1[order(z3$Main_trajectory_refined_by_cluster,z3$v3,z3$v2)]]),cluster_cols = hclust(amap::Dist(cups_sc,method = 'spearman'), method = 'ward.D'),cluster_rows = F, cutree_cols = 4,
                   show_rownames = F,show_colnames = F, color = my_palette,
                   annotation_row =  annot,annotation_colors  = annot_col,  treeheight_col = 0,gaps_row = c(29,80,98,105,138,154,176,214),breaks = mat_breaks
)
dev.off()






annot=data.frame(Main_trajectory=gsub(' trajectory','',z3$Main_trajectory_refined_by_cluster[order(z3$v5)]), row.names = z3$v1[order(z3$v5)],stringsAsFactors = T)
annot_col=list(Main_trajectory=unique(z3[,c(4,7)])[,2])
names(annot_col$Main_trajectory)=gsub(' trajectory','',unique(z3[,c(4,7)])[,1])



bk1 <- seq(-7,-0.1,by=0.1)
bk2 <- seq(0.1,3.4,by=0.1)
bk <- c(bk1,bk2)  #combine the break limits for purpose of graphing

my_palette <- c(colorRampPalette(colors = c("darkblue", "lightblue"))(n = length(bk1)-1),
                "white", "white",
                c(colorRampPalette(colors = c( "tomato1","darkred"))(n = length(bk2)-1)))

rownames(cups_sc2)=gsub('^','MGH',gsub('D20-24|-5670F|D22-15','',fixed = F,rownames(cups_sc2)))


pdf('figs/paper/fig15.pdf')
pheatmap::pheatmap(t(cups_sc2[,cups_ddc_pval005$traj[order(cups_ddc_pval005$Main_trajectory_refined_by_cluster,cups_ddc_pval005$traj2,cups_ddc_pval005$traj)]]),
                   cluster_cols = hclust(amap::Dist(cups_sc,method = 'spearman'), method = 'ward.D'),cluster_rows = F, cutree_cols = 4,
                   show_rownames = T,show_colnames = T,labels_row =gsub('_trajectory','', cups_ddc_pval005$traj[order(cups_ddc_pval005$Main_trajectory_refined_by_cluster,cups_ddc_pval005$traj2,cups_ddc_pval005$traj)])
                   ,labels_col = gsub('^','MGH',gsub('D20-24|-5670F|D22-15','',fixed = F,rownames(cups_sc2))),
                   annotation_row =  annot,annotation_colors  = annot_col,  treeheight_col = 0, breaks = bk, color = my_palette,legend_breaks = c(3,1,0,-1,-3,-5,-7),legend_labels = c(3,1,0,-1,-3,-5,-7))
dev.off()



